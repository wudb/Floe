//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func").replacingOccurrences(of: "private var", with: "var").replacingOccurrences(of: "Bundle.main", with: "FixtureBundle.main").replacingOccurrences(of: "NSWorkspace", with: "FixtureWorkspace")
}
let methods = [method("    private var displayableCachedItems:"), method("    private func scanAndApply()"), method("    private func rescanAfterDrag()"), method("    private func applySnapshotFromCache()"), method("    private func supplementalAXItems(")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-layout-fallback-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
struct Application { let bundleIdentifier: String? }
struct MenuBarItem { let id: Int; let owningApplication: Application?; var frame = CGRect.zero; var ownerPID: pid_t = 42; var title: String? = nil }
struct FixtureBundle { static let main = FixtureBundle(); let bundleIdentifier: String? = "com.wudb.Floe" }
struct FixtureWorkspace { static let shared = FixtureWorkspace(); let runningApplications = [1] }
enum ScreenCapture { static func cachedCheckPermissions(reset: Bool) -> Bool { true } }
enum MenuBarItemAXDiscovery {
    struct AXMenuBarItem { let id: Int; var axFrame: CGRect? = nil; var pid: pid_t = 42; var title: String? = nil }
    static var trusted = true
    static func isTrusted() -> Bool { trusted }
    static var discovered = [AXMenuBarItem(id: 99)]
    static func discoverItems(in: [Int]) -> [AXMenuBarItem] { discovered }
}
@MainActor final class Cache { var allItems: [MenuBarItem] = [] }
@MainActor final class ItemManager {
    let itemCache = Cache()
    var forces: [Bool] = []
    var shouldWait = false
    var nextID = 0
    var pending: [Int: CheckedContinuation<Void, Never>] = [:]
    func cacheItemsIfNeeded(force: Bool = false) async {
        forces.append(force)
        if shouldWait {
            let id = nextID; nextID += 1
            await withCheckedContinuation { pending[id] = $0 }
        }
    }
}
@MainActor final class AppState { let itemManager = ItemManager() }
@MainActor final class Pane {
    let appState = AppState()
    var scanGeneration = 0
    var axSnapshot = [MenuBarItemAXDiscovery.AXMenuBarItem]()
    var dividerPollGeneration = 0
    var iconRetryGeneration = 0
    var hasScreenRecordingPermission = true
    var hasAccessibilityPermission = true
    var hiddenDividerX: CGFloat?
    var alwaysHiddenDividerX: CGFloat?
    var anchorY: CGFloat = 0
    var sections: [String: [Int]] = [:]
    func resolveDividers() -> (CGFloat?, CGFloat?) { (100, 50) }
    func isMissingExpectedDivider(hiddenX: CGFloat?, alwaysHiddenX: CGFloat?) -> Bool { false }
    func startDividerPoll() {}
    func scheduleIconRetryIfNeeded(axFallback: [MenuBarItemAXDiscovery.AXMenuBarItem]) {}
    func buildSections(hiddenX: CGFloat?, alwaysHiddenX: CGFloat?, axFallback: [MenuBarItemAXDiscovery.AXMenuBarItem]) -> (grouped: [String: [Int]], midQuartzY: CGFloat?) {
        let ids = displayableCachedItems.map(\.id)
        let chosen = ids + supplementalAXItems(axFallback, cached: displayableCachedItems).map(\.id)
        return (chosen.isEmpty ? [:] : ["visible": chosen], nil)
    }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        let pane = Pane()
        let frame = CGRect(x: 200, y: 0, width: 20, height: 24)
        let cached = MenuBarItem(id: 20, owningApplication: Application(bundleIdentifier: "foreign"), frame: frame, ownerPID: 10, title: "Status")
        let duplicate = MenuBarItemAXDiscovery.AXMenuBarItem(id: 21, axFrame: frame, pid: 99, title: "Different proxy title")
        let sibling = MenuBarItemAXDiscovery.AXMenuBarItem(id: 22, axFrame: frame.offsetBy(dx: 30, dy: 0), pid: 10, title: "Status")
        precondition(pane.supplementalAXItems([duplicate, sibling], cached: [cached]).map(\.id) == [22])
        let nameless = MenuBarItemAXDiscovery.AXMenuBarItem(id: 23)
        precondition(pane.supplementalAXItems([nameless], cached: [cached]).map(\.id) == [23])
        let identified = MenuBarItemAXDiscovery.AXMenuBarItem(id: 24, pid: 10, title: "Status")
        precondition(pane.supplementalAXItems([identified], cached: [cached]).isEmpty)
        let ambiguous = MenuBarItemAXDiscovery.AXMenuBarItem(id: 25, pid: 10, title: "Status")
        precondition(pane.supplementalAXItems([identified, ambiguous], cached: [cached]).map(\.id) == [24, 25])
        let own = MenuBarItem(id: 1, owningApplication: Application(bundleIdentifier: "com.wudb.Floe"))
        let foreign = MenuBarItem(id: 2, owningApplication: Application(bundleIdentifier: "foreign.app"))
        pane.appState.itemManager.itemCache.allItems = [own]
        precondition(pane.displayableCachedItems.isEmpty)
        await pane.scanAndApply()
        precondition(pane.sections == ["visible": [99]], "own-only cache must use AX on normal refresh")
        precondition(pane.appState.itemManager.forces.last == true, "refresh must update unchanged-ID metadata")
        pane.sections = [:]
        await pane.rescanAfterDrag()
        precondition(pane.sections == ["visible": [99]], "own-only cache must use AX after drag")
        pane.appState.itemManager.itemCache.allItems = [own, foreign]
        await pane.scanAndApply()
        precondition(pane.sections == ["visible": [2, 99]], "usable CGS items retain preference and exclude own items")
        pane.appState.itemManager.itemCache.allItems = []
        await pane.scanAndApply()
        precondition(pane.sections == ["visible": [99]])
        pane.sections = [:]
        pane.applySnapshotFromCache()
        precondition(pane.sections == ["visible": [99]], "cache updates must retain AX fallback snapshot")
        pane.appState.itemManager.shouldWait = true
        let older = Task { await pane.scanAndApply() }
        while pane.appState.itemManager.pending[0] == nil { await Task.yield() }
        let newest = Task { await pane.rescanAfterDrag() }
        while pane.appState.itemManager.pending[1] == nil { await Task.yield() }
        pane.appState.itemManager.itemCache.allItems = [foreign]
        pane.appState.itemManager.pending.removeValue(forKey: 1)!.resume(); await newest.value
        pane.appState.itemManager.itemCache.allItems = [own]
        pane.appState.itemManager.pending.removeValue(forKey: 0)!.resume(); await older.value
        precondition(pane.sections == ["visible": [2, 99]], "stale scan must not overwrite current post-drag result")
        let cancelled = Task { await pane.scanAndApply() }
        while pane.appState.itemManager.pending[2] == nil { await Task.yield() }
        let beforeCancel = pane.sections
        cancelled.cancel(); pane.appState.itemManager.pending.removeValue(forKey: 2)!.resume(); await cancelled.value
        precondition(pane.sections == beforeCancel)
        pane.appState.itemManager.shouldWait = false
        MenuBarItemAXDiscovery.discovered = []
        await pane.scanAndApply()
        precondition(pane.sections.isEmpty && pane.axSnapshot.isEmpty, "completed empty scan must remove stale rows")
        MenuBarItemAXDiscovery.trusted = false
        pane.sections = [:]
        await pane.scanAndApply()
        precondition(pane.sections.isEmpty, "untrusted AX must not be requested")
        print("PASS: production layout merges partial caches, deduplicates safely, retains AX snapshots and rejects stale/cancelled scans")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: fixturePath, atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("checks")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
compiler.arguments = ["swiftc", "-parse-as-library", fixturePath.path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let checks = Process()
checks.executableURL = binary
try checks.run()
checks.waitUntilExit()
exit(checks.terminationStatus)
