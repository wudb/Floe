import Foundation

// 编译生产移动路由，验证空隐藏区按分隔符身份插入，而非命中分隔符内的坐标。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
let start = source.range(of: "    private func performLayoutMove(")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end]).replacingOccurrences(of: "private func", with: "func").replacingOccurrences(of: "CGDisplayBounds", with: "TestDisplayBounds")
let fixture = #"""
import Foundation
import CoreGraphics
enum MenuBarItemAXDiscovery { enum SectionKind { case visible, hidden, alwaysHidden } }
enum MenuInteractionGuard { static var isInteracting = false }
struct App { let bundleIdentifier: String? }
struct MenuBarItem {
    enum Info { case other, hiddenControlItem, alwaysHiddenControlItem }
    let windowID: UInt32
    var info = Info.other
    var isMovable = true
    var owningApplication: App? = App(bundleIdentifier: "test")
    static var items = [MenuBarItem(windowID: 1), MenuBarItem(windowID: 2, info: .hiddenControlItem), MenuBarItem(windowID: 3, info: .alwaysHiddenControlItem), MenuBarItem(windowID: 4)]
    static func getMenuBarItems(onScreenOnly: Bool, activeSpaceOnly: Bool) -> [MenuBarItem] { items }
}
struct RowItem { let id: String; var bundleID: String? = "test"; var quartzFrame: CGRect? = nil }
struct NSScreen { static let screens = [NSScreen()]; let displayID: UInt32 = 1 }
func TestDisplayBounds(_ id: UInt32) -> CGRect { CGRect(x: 0, y: 0, width: 1000, height: 800) }
@MainActor final class MenuBarItemManager {
    enum MoveDestination { case leftOfItem(MenuBarItem), rightOfItem(MenuBarItem) }
    var moves = [String](), fail = false
    func move(item: MenuBarItem, to destination: MoveDestination) async throws {
        if fail { throw NSError(domain: "test", code: 1) }
        switch destination {
        case .leftOfItem(let anchor): moves.append("\(item.windowID)<\(anchor.windowID)")
        case .rightOfItem(let anchor): moves.append("\(item.windowID)>\(anchor.windowID)")
        }
    }
}
@MainActor final class AppState { let itemManager = MenuBarItemManager() }
@MainActor final class Pane {
    let appState = AppState()
    var syntheticDrags = 0
    func performDrag(from source: CGPoint, to destination: CGPoint) async -> Bool { syntheticDrags += 1; return true }
__PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        let pane = Pane(), item = RowItem(id: "cgs:1")
        // 目标分区完全为空、无几何坐标也可按原生分隔符身份移动。
        let hidden = await pane.performLayoutMove(item, to: .hidden, destination: nil)
        let visible = await pane.performLayoutMove(item, to: .visible, destination: nil)
        let always = await pane.performLayoutMove(item, to: .alwaysHidden, destination: nil)
        let ordered = await pane.performLayoutMove(item, to: .hidden, anchorID: "cgs:4", destination: nil)
        precondition(hidden && visible && always && ordered)
        precondition(pane.appState.itemManager.moves == ["1<2", "1>2", "1<3", "1<4"] && pane.syntheticDrags == 0)
        let wrongOwner = await pane.performLayoutMove(RowItem(id: "cgs:1", bundleID: "different"), to: .hidden, destination: .zero)
        precondition(!wrongOwner)
        pane.appState.itemManager.fail = true
        let failed = await pane.performLayoutMove(item, to: .hidden, destination: .zero)
        precondition(!failed && pane.syntheticDrags == 0, "native failure must not fall back to an unsafe coordinate drag")
        let offscreen = await pane.performLayoutMove(RowItem(id: "ax:1", quartzFrame: CGRect(x: -10000, y: 0, width: 20, height: 20)), to: .hidden, destination: CGPoint(x: 50, y: 10))
        precondition(!offscreen)
        let ax = await pane.performLayoutMove(RowItem(id: "ax:1", quartzFrame: CGRect(x: 100, y: 0, width: 20, height: 20)), to: .hidden, destination: CGPoint(x: 50, y: 10))
        precondition(ax && pane.syntheticDrags == 1)
        print("PASS: native layout moves use divider/item identity for empty groups, reject stale owners and failures, and restrict AX fallback to on-screen points")
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("layout-native-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let file = directory.appendingPathComponent("Tests.swift"), binary = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: method).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc"); compiler.arguments = ["-parse-as-library", file.path, "-o", binary.path]
try compiler.run(); compiler.waitUntilExit(); guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let runner = Process(); runner.executableURL = binary
try runner.run(); runner.waitUntilExit(); exit(runner.terminationStatus)
