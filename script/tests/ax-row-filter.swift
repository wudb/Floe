//
//  ax-row-filter.swift
//  Floe
//

// Exercises the actual AX row scan and shared classifier with controlled discovery geometry.
import Foundation

let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent().path
let source = try String(contentsOfFile: repo + "/Floe/UI/FloeBar/FloeBar.swift", encoding: .utf8)
let discovery = try String(contentsOfFile: repo + "/Floe/MenuBar/MenuBarItems/MenuBarItemAXDiscovery.swift", encoding: .utf8)
let cache = try String(contentsOfFile: repo + "/Floe/MenuBar/MenuBarItems/MenuBarItemAXCache.swift", encoding: .utf8)
func method(_ signature: String, in source: String) -> String {
    let start = source.range(of: signature)!.lowerBound
    let end = source.range(of: "\n    }\n", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let scan = method("    private func scanAXRowsOnce(", in: source)
    .replacingOccurrences(of: "NSWorkspace", with: "FixtureWorkspace")
    .replacingOccurrences(of: "NSRunningApplication", with: "FixtureApplication")
let classification = ["    static func classify(", "    static func normalizedDividers(", "    static func isSettledDividerFrame("]
    .map { method($0, in: discovery) }.joined(separator: "\n")
let fixtures = #"""
import Cocoa
struct FixtureApplication {
    init?(processIdentifier: pid_t) {}
    var icon: NSImage? { nil }
}
struct FixtureWorkspace {
    static let shared = FixtureWorkspace()
    let runningApplications = [FixtureApplication]()
}
enum MenuBarItemAXDiscovery {
    enum SectionKind { case visible, hidden, alwaysHidden }
    struct AXMenuBarItem {
        let element = NSObject()
        let pid: pid_t = 42
        let bundleID: String? = nil
        var identifier: String? = nil
        let title: String?
        var displayName: String { title ?? "unknown" }
        let axFrame: CGRect?
    }
    static var items = [AXMenuBarItem]()
    static var dividers: (hidden: CGRect?, alwaysHidden: CGRect?) = (nil, nil)
    static func discoverItems(in apps: [FixtureApplication]) -> [AXMenuBarItem] { items }
    static func dividerFrames() -> (hidden: CGRect?, alwaysHidden: CGRect?) { dividers }
    static func systemImageName(for item: AXMenuBarItem) -> String? { nil }
    static func systemIconImage(forIdentifier identifier: String?, title: String?, bundleID: String?) -> NSImage? { nil }
    static func inputSourceIcon() -> NSImage? { nil }
    // PRODUCTION_CLASSIFICATION
}
struct AXRowItem {
    let id: String
    let item: MenuBarItemAXDiscovery.AXMenuBarItem
    let title: String?
    let displayName: String
    let systemImage: String?
    let appIcon: NSImage?
    let midX: CGFloat?
}
struct Window { let frame: CGRect }
final class ControlItem { var window: Window? }
final class Section {
    enum Name { case hidden, alwaysHidden }
    let controlItem = ControlItem()
}
final class PresentationController {
    var fullscreen: Bool? = false
    func fullscreenState(on screen: Screen) -> Bool? { fullscreen }
}
final class MenuBarManager {
    let presentationController = PresentationController()
    let hidden = Section()
    let alwaysHidden = Section()
    func section(withName name: Section.Name) -> Section? { name == .hidden ? hidden : alwaysHidden }
}
final class AppState { var isActiveSpaceFullscreen = false }
struct Screen {
    let displayID = 1
    let frame = CGRect(x: 0, y: 0, width: 1200, height: 800)
}
struct Logger {
    static let floeBar = Logger()
    func info(_ message: String) {}
}
final class ItemManager {
    var axItemCache = MenuBarItemAXCache()
    var runningPIDs: Set<pid_t> = [42]
    func rememberAXItems(_ items: [MenuBarItemAXDiscovery.AXMenuBarItem], hiddenDividerX: CGFloat?, alwaysHiddenDividerX: CGFloat?) {
        axItemCache.update(items, runningPIDs: runningPIDs, hiddenDividerX: hiddenDividerX, alwaysHiddenDividerX: alwaysHiddenDividerX,
                           menuBarBands: [CGRect(x: 0, y: 0, width: 1200, height: 32)])
    }
}
@MainActor final class Content {
    var section = Section.Name.hidden
    let menuBarManager = MenuBarManager()
    let appState = AppState()
    let screen = Screen()
    let itemManager = ItemManager()
    var axRows = [AXRowItem]()
    // PRODUCTION_SCAN
}
@MainActor func runTests() async {
    var failures = 0
    func expect(_ name: String, _ passed: Bool) {
        print("\(passed ? "PASS" : "FAIL"): \(name)")
        if !passed { failures += 1 }
    }
    func divider(_ x: CGFloat?) -> CGRect? { x.map { CGRect(x: $0, y: 0, width: 20, height: 24) } }
    func check(_ name: String, hidden: CGFloat?, always: CGFloat?,
               fullscreen: Bool? = false, nativeHidden: CGFloat? = nil, wanted: Section.Name = .hidden, expected: [String]) async {
        let content = Content()
        content.section = wanted
        content.menuBarManager.presentationController.fullscreen = fullscreen
        content.menuBarManager.hidden.controlItem.window = divider(nativeHidden).map { Window(frame: $0) }
        MenuBarItemAXDiscovery.dividers = (divider(hidden), divider(always))
        await content.scanAXRowsOnce(attempt: 0)
        expect(name, content.axRows.compactMap(\.title) == expected)
    }
    MenuBarItemAXDiscovery.items = [1000, 600, 400].map {
        .init(title: String($0), axFrame: CGRect(x: $0 - 10, y: 0, width: 20, height: 24))
    } + [.init(title: "unframed", axFrame: nil)]
    let cancelledContent = Content()
    let cancelledScan = Task { @MainActor in
        withUnsafeCurrentTask { $0?.cancel() }
        await cancelledContent.scanAXRowsOnce(attempt: 0)
    }
    await cancelledScan.value
    expect("cancelled AX scan does not publish rows", cancelledContent.axRows.isEmpty)
    await check("hidden bar excludes always-hidden and visible items", hidden: 800, always: 500, expected: ["600"])
    await check("always-hidden bar shows only its own section", hidden: 800, always: 500, wanted: .alwaysHidden, expected: ["400"])
    await check("missing always-hidden divider retains hidden items", hidden: 800, always: nil, expected: ["400", "600"])
    await check("missing hidden boundary does not discard unknown items", hidden: nil, always: 500, expected: ["400", "600", "1000", "unframed"])
    await check("native hidden-divider fallback retains classification", hidden: nil, always: 500, nativeHidden: 800, expected: ["600"])
    await check("parking-spacer geometry is not a hidden boundary", hidden: 7, always: 500, expected: ["400", "600", "1000", "unframed"])
    expect("shared classifier still treats nil as a disabled section", MenuBarItemAXDiscovery.classify(centerX: 600, hiddenDividerX: nil, alwaysHiddenDividerX: 500) == .visible)

    let retained = Content()
    MenuBarItemAXDiscovery.dividers = (divider(800), divider(500))
    let visible = MenuBarItemAXDiscovery.AXMenuBarItem(title: "visible", axFrame: CGRect(x: 990, y: 0, width: 20, height: 24))
    let sibling = MenuBarItemAXDiscovery.AXMenuBarItem(title: "sibling", axFrame: CGRect(x: 390, y: 0, width: 20, height: 24))
    let moved = MenuBarItemAXDiscovery.AXMenuBarItem(title: "moved", axFrame: CGRect(x: 590, y: 0, width: 20, height: 24))
    MenuBarItemAXDiscovery.items = [visible, moved, sibling]
    await retained.scanAXRowsOnce(attempt: 0)
    expect("confirmed Hidden excludes the same process's Always Hidden sibling", retained.axRows.map(\.displayName) == ["moved"])
    MenuBarItemAXDiscovery.items = [visible]
    await retained.scanAXRowsOnce(attempt: 0)
    expect("collapsed AX snapshot retains the exact hidden item", retained.axRows.map(\.displayName) == ["moved"] && CFEqual(retained.axRows[0].item.element, moved.element))
    retained.section = .alwaysHidden
    await retained.scanAXRowsOnce(attempt: 0)
    expect("collapsed Always Hidden snapshot retains its own sibling", retained.axRows.map(\.displayName) == ["sibling"])
    MenuBarItemAXDiscovery.dividers = (nil, nil)
    retained.section = .hidden
    await retained.scanAXRowsOnce(attempt: 0)
    expect("missing dividers preserve confirmed hidden membership", retained.axRows.map(\.displayName) == ["moved"])
    retained.itemManager.runningPIDs = []
    MenuBarItemAXDiscovery.items = []
    await retained.scanAXRowsOnce(attempt: 0)
    expect("exited process removes retained items", retained.axRows.isEmpty)
    var identityCache = MenuBarItemAXCache()
    let original = MenuBarItemAXDiscovery.AXMenuBarItem(title: "original", axFrame: CGRect(x: 390, y: 0, width: 20, height: 24))
    let proxy = MenuBarItemAXDiscovery.AXMenuBarItem(title: "proxy", axFrame: CGRect(x: 590, y: 0, width: 20, height: 24))
    let bands = [CGRect(x: 0, y: 0, width: 1200, height: 32)]
    identityCache.update([original], runningPIDs: [42], hiddenDividerX: 800, alwaysHiddenDividerX: 500, menuBarBands: bands)
    let stableID = identityCache.id(for: original)
    identityCache.update([proxy], runningPIDs: [42], hiddenDividerX: 800, alwaysHiddenDividerX: 500, menuBarBands: bands, allowHiddenSectionChanges: false)
    expect("a recreated singleton keeps its logical ID without duplicate rows", identityCache.id(for: proxy) == stableID && identityCache.merging([proxy]).count == 1)
    expect("parked proxy coordinates cannot change confirmed Always Hidden membership", identityCache.section(for: proxy) == .alwaysHidden)
    identityCache.update([proxy], runningPIDs: [42], hiddenDividerX: 800, alwaysHiddenDividerX: 500, menuBarBands: bands)
    expect("expanded live geometry confirms Always Hidden to Hidden", identityCache.section(for: proxy) == .hidden && identityCache.id(for: proxy) == stableID)
    var first = original, second = moved
    first.identifier = "first"; second.identifier = "second"
    var multi = MenuBarItemAXCache()
    multi.update([first, second], runningPIDs: [42], hiddenDividerX: 800, alwaysHiddenDividerX: 500, menuBarBands: bands)
    let firstID = multi.id(for: first), secondID = multi.id(for: second)
    var replacement = MenuBarItemAXDiscovery.AXMenuBarItem(title: "replacement", axFrame: first.axFrame)
    replacement.identifier = "first"
    multi.update([replacement, second], runningPIDs: [42], hiddenDividerX: 800, alwaysHiddenDividerX: 500, menuBarBands: bands)
    expect("multi-item hosts reconcile only unique identifiers and preserve siblings", multi.id(for: replacement) == firstID && multi.id(for: second) == secondID && firstID != secondID && multi.merging([replacement, second]).count == 2)
    exit(failures == 0 ? 0 : 1)
}
await runTests()
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-row-filter-test-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
let generated = directory.appendingPathComponent("row-filter.swift")
try fixtures.replacingOccurrences(of: "    // PRODUCTION_CLASSIFICATION", with: classification)
    .replacingOccurrences(of: "    // PRODUCTION_SCAN", with: scan)
    .appending("\n" + cache)
    .write(to: generated, atomically: true, encoding: .utf8)
let runner = Process()
runner.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
runner.arguments = [generated.path]
try runner.run()
runner.waitUntilExit()
let status = runner.terminationStatus
try FileManager.default.removeItem(at: directory)
exit(status)
