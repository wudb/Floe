import Foundation

// 编译生产启动扫描与 AX 缓存，覆盖首次收起之前的完整记录及初始化结束后的状态恢复。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let manager = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarManager.swift"), encoding: .utf8)
let marker = "    private func cacheInitialAXSnapshot() async {"
let start = manager.range(of: marker)!.lowerBound
let end = manager.range(of: "\n    }", range: start..<manager.endIndex)!.upperBound
let method = String(manager[start..<end])
    .replacingOccurrences(of: "private func", with: "func")
    .replacingOccurrences(of: "NSWorkspace", with: "FixtureWorkspace")
let cache = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemAXCache.swift"), encoding: .utf8)
let fixture = #"""
import Cocoa

enum MenuBarItemAXDiscovery {
    enum SectionKind { case visible, hidden, alwaysHidden }
    struct AXMenuBarItem {
        let element = NSObject()
        let pid: pid_t = 42
        let identifier: String? = nil
        let axFrame: CGRect?
    }
    static var items = [AXMenuBarItem]()
    static var dividerReads = 0
    static var missingDividers = false
    static func dividerFrames() -> (hidden: CGRect?, alwaysHidden: CGRect?) {
        dividerReads += 1
        guard !missingDividers, dividerReads > 1 else { return (nil, nil) }
        return (CGRect(x: 500, y: 0, width: 20, height: 24), CGRect(x: 250, y: 0, width: 20, height: 24))
    }
    static func isSettledDividerFrame(_ frame: CGRect) -> Bool { frame.minY <= 100 && frame.minX > 100 }
    static func discoverItems(in apps: [Int]) -> [AXMenuBarItem] { items }
    static var overflowExpanded = false
    static var overflowChanges = [Bool]()
    static func setOverflowExpanded(_ expanded: Bool, in apps: [Int]) -> Bool {
        guard overflowExpanded != expanded else { return false }
        overflowExpanded = expanded
        overflowChanges.append(expanded)
        return true
    }
    static func classify(centerX: CGFloat?, hiddenDividerX: CGFloat?, alwaysHiddenDividerX: CGFloat?) -> SectionKind {
        guard let centerX else { return .visible }
        if let alwaysHiddenDividerX, centerX < alwaysHiddenDividerX { return .alwaysHidden }
        if let hiddenDividerX, centerX < hiddenDividerX { return .hidden }
        return .visible
    }
}
struct FixtureWorkspace { static let shared = Self(); let runningApplications = [42] }
struct Logger { static let menuBarManager = Self(); func info(_ value: String) {} }
final class ItemManager {
    var axItemCache = MenuBarItemAXCache()
    var snapshots = 0
    func rememberAXItems(_ items: [MenuBarItemAXDiscovery.AXMenuBarItem], hiddenDividerX: CGFloat?, alwaysHiddenDividerX: CGFloat?) {
        snapshots += 1
        axItemCache.update(items, runningPIDs: [42], hiddenDividerX: hiddenDividerX, alwaysHiddenDividerX: alwaysHiddenDividerX,
                           menuBarBands: [CGRect(x: 0, y: 0, width: 1200, height: 32)])
    }
}
final class AppState { let itemManager = ItemManager() }
final class ControlItem {
    enum HidingState { case showItems, hideItems }
    var state = HidingState.hideItems
    var applied = [HidingState]()
    func updateStatusItem(with value: HidingState) { applied.append(value) }
}
final class MenuBarSection {
    enum Name { case hidden, alwaysHidden }
    let name: Name
    var isEnabled = true
    let controlItem = ControlItem()
    init(_ name: Name) { self.name = name }
}
@MainActor final class Manager {
    var appState: AppState? = AppState()
    var isPreparingInitialAXSnapshot = true
    let sections = [MenuBarSection(.hidden), MenuBarSection(.alwaysHidden)]
    func section(withName name: MenuBarSection.Name) -> MenuBarSection? { sections.first { $0.name == name } }
    __METHOD__
}
__CACHE__
@main struct Checks {
    @MainActor static func main() async {
        let manager = Manager()
        let items = (0..<18).map { index in
            MenuBarItemAXDiscovery.AXMenuBarItem(axFrame: CGRect(x: 100 + index * 50, y: 0, width: 20, height: 24))
        }
        MenuBarItemAXDiscovery.items = items
        // 初始化期间的用户选择必须成为最终应用的状态。
        manager.sections[0].controlItem.state = .showItems
        await manager.cacheInitialAXSnapshot()
        precondition(!manager.isPreparingInitialAXSnapshot)
        precondition(MenuBarItemAXDiscovery.overflowChanges == [true, false] && !MenuBarItemAXDiscovery.overflowExpanded)
        precondition(manager.sections[0].controlItem.applied == [.showItems])
        precondition(manager.sections[1].controlItem.applied == [.hideItems])
        precondition(manager.appState!.itemManager.snapshots == 1)
        precondition(MenuBarItemAXDiscovery.dividerReads >= 2)
        var cache = manager.appState!.itemManager.axItemCache
        let visible = items.filter { cache.section(for: $0) == .visible }
        precondition(visible.count == 10)
        cache.update(visible, runningPIDs: [42], hiddenDividerX: nil, alwaysHiddenDividerX: nil,
                     menuBarBands: [CGRect(x: 0, y: 0, width: 1200, height: 32)])
        let merged = cache.merging(visible)
        precondition(merged.count == 18, "initial snapshot must retain all eight items removed by the first hide")
        precondition(merged.filter { cache.section(for: $0) == .hidden }.count == 5)
        precondition(merged.filter { cache.section(for: $0) == .alwaysHidden }.count == 3)
        precondition(merged.allSatisfy { value in items.contains { CFEqual($0.element, value.element) } })
        print("PASS: initial AX snapshot precedes hiding and retains exact identities and confirmed sections after the first collapsed scan")

        let cancelled = Manager()
        MenuBarItemAXDiscovery.missingDividers = true
        let task = Task { await cancelled.cacheInitialAXSnapshot() }
        await Task.yield()
        task.cancel()
        await task.value
        precondition(!cancelled.isPreparingInitialAXSnapshot)
        precondition(cancelled.sections.allSatisfy { $0.controlItem.applied == [.hideItems] })
        print("PASS: cancelled initialization releases the preparation phase and applies current section states")

        let detached = Manager()
        detached.appState = nil
        await detached.cacheInitialAXSnapshot()
        precondition(!detached.isPreparingInitialAXSnapshot)
        precondition(detached.sections.allSatisfy { $0.controlItem.applied == [.hideItems] })
        print("PASS: missing application state still releases the preparation phase")
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-startup-ax-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let generated = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__METHOD__", with: method).replacingOccurrences(of: "__CACHE__", with: cache)
    .write(to: generated, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    precondition(process.terminationStatus == 0)
}
let binary = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", generated.path, "-o", binary])
try run([binary])
let setupStart = manager.range(of: "    func performSetup() {")!.lowerBound
let setupEnd = manager.range(of: "\n    }", range: setupStart..<manager.endIndex)!.upperBound
let setup = String(manager[setupStart..<setupEnd])
precondition(setup.range(of: "isPreparingInitialAXSnapshot = true")!.lowerBound < setup.range(of: "initializeSections()")!.lowerBound)
print("PASS: startup enables preparation before constructing status items")
