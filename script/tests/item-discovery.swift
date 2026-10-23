//
//  item-discovery.swift
//  Floe
//

// Runs the actual cacheItemsIfNeeded method with controlled WindowServer inputs.
// No app launch, TCC changes, synthetic clicks, or copied cache algorithm.
import Foundation

let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent().path
let source = try String(contentsOfFile: repo + "/Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift", encoding: .utf8)
let start = source.range(of: "    func cacheItemsIfNeeded(force:")!.lowerBound
let end = source.range(of: "\n}\n\n// MARK: - Menu Bar Item Events", range: start..<source.endIndex)!.lowerBound
let method = String(source[start..<end])
let idsDeclaration = source.components(separatedBy: "\n").first { $0.contains("private var cachedItemWindowIDs") }!
    .replacingOccurrences(of: "private ", with: "")

let prelude = #"""
import Foundation
typealias CGWindowID = UInt32
struct TaskTimeoutError: Error {}
struct Logger {
    static let itemManager = Logger()
    func warning(_ text: String) {}
    func error(_ text: String) {}
    func debug(_ text: String) {}
}
enum Bridging {
    struct Options: OptionSet {
        let rawValue: Int
        static let menuBarItems = Self(rawValue: 1)
        static let activeSpace = Self(rawValue: 2)
    }
    static var windowIDs: [CGWindowID] = []
    static var allWindowIDs: [CGWindowID] = []
    static func getWindowList(option: Options) -> [CGWindowID] {
        option.contains(.activeSpace) ? windowIDs : allWindowIDs
    }
}
enum Info { case hiddenControlItem, alwaysHiddenControlItem, app }
struct MenuBarItem {
    let info: Info
    static var snapshot: [MenuBarItem] = []
    static var scans = 0
    static func getMenuBarItems(onScreenOnly: Bool, activeSpaceOnly: Bool) -> [MenuBarItem] {
        scans += 1
        return snapshot
    }
}
extension Array where Element == MenuBarItem {
    func firstIndex(matching info: Info) -> Int? { firstIndex { $0.info == info } }
}
struct Cache {
    var count = 0
    mutating func clear() { count = 0 }
}
@MainActor final class LayoutStoreStub { func restoreIfNeeded(manager: Manager) async {} }
@MainActor final class Manager {
    let layoutStore = LayoutStoreStub()
    func reconcileLayout() async { await layoutStore.restoreIfNeeded(manager: self) }
    var isCachingItems = false
    var cacheReadGeneration = 0
    var completedCacheReadGeneration = 0
    var layoutEnvironmentRevision = 0
    var isLayoutRecoverySuspended = false
    func scheduleLayoutReconciliation() {}
    var waitDelay = false
    var failedWaits = 0
    var isItemDiscoveryUnavailable = false
    var itemCache = Cache()
    var itemHasRecentlyMoved = false
    func waitForItemsToStopMoving(timeout: Duration) async throws {
        if waitDelay { try await Task.sleep(for: .milliseconds(30)) }
        if failedWaits > 0 { failedWaits -= 1; throw TaskTimeoutError() }
    }
    func logSkippingCache(reason: String) {}
    func enforceControlItemOrder(hiddenControlItem: MenuBarItem, alwaysHiddenControlItem: MenuBarItem) async throws -> Bool { false }
    func uncheckedCacheItems(hiddenControlItem: MenuBarItem, alwaysHiddenControlItem: MenuBarItem?, otherItems: [MenuBarItem]) {
        itemCache.count = otherItems.count
    }
"""#
let tests = #"""
}
@main struct RegressionTests {
    static var failures = 0
    static func expect(_ value: Bool, _ name: String) {
        print("\(value ? "PASS" : "FAIL"): \(name)")
        if !value { failures += 1 }
    }
    static func input(_ ids: [CGWindowID], all: [CGWindowID]? = nil, hasDivider: Bool = false) {
        Bridging.windowIDs = ids
        Bridging.allWindowIDs = all ?? ids
        MenuBarItem.snapshot = hasDivider ? [.init(info: .hiddenControlItem), .init(info: .app)] : []
    }
    @MainActor static func main() async {
        let empty = Manager()
        input([])
        await empty.cacheItemsIfNeeded()
        expect(empty.isItemDiscoveryUnavailable, "empty first snapshot selects Accessibility fallback")

        let multipleWindows = Manager()
        input([11, 22], all: [11, 22, 33])
        await multipleWindows.cacheItemsIfNeeded()
        expect(multipleWindows.isItemDiscoveryUnavailable, "multiple windows without Floe's divider select Accessibility fallback")

        let recovery = Manager()
        input([11])
        await recovery.cacheItemsIfNeeded()
        expect(recovery.isItemDiscoveryUnavailable, "single-window failure selects Accessibility fallback")
        input([11], hasDivider: true)
        await recovery.cacheItemsIfNeeded()
        expect(!recovery.isItemDiscoveryUnavailable && recovery.itemCache.count == 1,
               "discovery recovers with unchanged IDs after window metadata becomes available")

        recovery.failedWaits = 1
        await recovery.cacheItemsIfNeeded(force: true)
        expect(recovery.cachedItemWindowIDs == nil, "a failed forced read invalidates the prior success stamp")
        await recovery.cacheItemsIfNeeded(force: true)
        let scans = MenuBarItem.scans
        await recovery.cacheItemsIfNeeded()
        expect(MenuBarItem.scans == scans, "successful unchanged snapshots still skip redundant scans")
        await recovery.cacheItemsIfNeeded(force: true)
        expect(MenuBarItem.scans == scans + 1, "forced refresh still scans unchanged IDs")

        input([88, 99])
        await recovery.cacheItemsIfNeeded()
        expect(recovery.isItemDiscoveryUnavailable && recovery.itemCache.count == 0,
               "loss of the divider invalidates the old cache and selects fallback")
        input([11], hasDivider: true)
        await recovery.cacheItemsIfNeeded()
        expect(!recovery.isItemDiscoveryUnavailable && recovery.itemCache.count == 1,
               "return to an earlier successful ID list rebuilds a cleared cache")
        let coalesced = Manager()
        coalesced.waitDelay = true
        input([11], hasDivider: true)
        MenuBarItem.scans = 0
        let first = Task { await coalesced.cacheItemsIfNeeded() }
        while !coalesced.isCachingItems { await Task.yield() }
        for _ in 0..<50 { await coalesced.cacheItemsIfNeeded() }
        var forceReturned = false
        let forced = Task { await coalesced.cacheItemsIfNeeded(force: true); forceReturned = true }
        let otherForced = Task { await coalesced.cacheItemsIfNeeded(force: true) }
        try? await Task.sleep(for: .milliseconds(5))
        expect(!forceReturned && MenuBarItem.scans == 0, "forced caller waits instead of reading the old in-flight snapshot")
        await first.value
        await forced.value
        await otherForced.value
        expect(MenuBarItem.scans == 2, "forced callers await and share one new non-overlapping scan")

        let cancelling = Manager()
        cancelling.waitDelay = true
        MenuBarItem.scans = 0
        let active = Task { await cancelling.cacheItemsIfNeeded() }
        while !cancelling.isCachingItems { await Task.yield() }
        let waiting = Task { await cancelling.cacheItemsIfNeeded(force: true) }
        try? await Task.sleep(for: .milliseconds(5))
        waiting.cancel(); await waiting.value
        await active.value
        expect(MenuBarItem.scans == 1 && !cancelling.isCachingItems, "cancelling a waiting forced caller stops its scan without cancelling the active caller")
        let failedScan = Manager()
        failedScan.waitDelay = true
        failedScan.failedWaits = 1
        MenuBarItem.scans = 0
        let unsuccessful = Task { await failedScan.cacheItemsIfNeeded() }
        while !failedScan.isCachingItems { await Task.yield() }
        let retry = Task { await failedScan.cacheItemsIfNeeded(force: true) }
        await unsuccessful.value; await retry.value
        expect(MenuBarItem.scans == 1 && failedScan.itemCache.count == 1,
               "a failed in-flight scan cannot satisfy a waiting forced refresh")

        let changedEnvironment = Manager()
        changedEnvironment.waitDelay = true
        MenuBarItem.scans = 0
        let oldEnvironment = Task { await changedEnvironment.cacheItemsIfNeeded(force: true) }
        while !changedEnvironment.isCachingItems { await Task.yield() }
        changedEnvironment.layoutEnvironmentRevision += 1
        await oldEnvironment.value
        expect(MenuBarItem.scans == 0 && changedEnvironment.itemCache.count == 0,
               "an environment change invalidates an old scan before publishing")
        changedEnvironment.isLayoutRecoverySuspended = true
        await changedEnvironment.cacheItemsIfNeeded(force: true)
        expect(MenuBarItem.scans == 0, "sleep suspends menu bar scans")
        exit(failures == 0 ? 0 : 1)
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-regression-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
let generated = directory.appendingPathComponent("discovery-test-generated.swift")
try (prelude + "\n" + idsDeclaration + "\n" + method + "\n" + tests).write(to: generated, atomically: true, encoding: .utf8)
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
compiler.arguments = ["swiftc", "-parse-as-library", generated.path, "-o", directory.appendingPathComponent("discovery-tests").path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let runner = Process()
runner.executableURL = directory.appendingPathComponent("discovery-tests")
try runner.run()
runner.waitUntilExit()
let status = runner.terminationStatus
try FileManager.default.removeItem(at: directory)
exit(status)
