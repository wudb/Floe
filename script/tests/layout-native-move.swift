import Foundation

// 编译生产移动路由，验证空隐藏区按分隔符身份插入，而非命中分隔符内的坐标。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
        .replacingOccurrences(of: "CGDisplayBounds", with: "TestDisplayBounds")
        .replacingOccurrences(of: "isPostingMove = true", with: "self.isPostingMove = true")
        .replacingOccurrences(of: "NSEvent.", with: "FixtureEvents.")
}
let methods = ["    private func performLayoutMove(", "    private func performDrag("].map(method).joined(separator: "\n")
let fixture = #"""
import Cocoa
import CoreGraphics
enum MenuBarItemAXDiscovery { enum SectionKind { case visible, hidden, alwaysHidden } }
enum MenuInteractionGuard { static var isInteracting = false }
@MainActor enum FixtureEvents {
    static var pressedMouseButtons = 0
    static var modifierFlags: NSEvent.ModifierFlags = []
}
@MainActor enum MenuBarItemAXMover {
    static var drags = 0
    static func commandDrag(from source: CGPoint, to destination: CGPoint) async -> Bool { drags += 1; return true }
}
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
    var moves = [String](), fail = false, isMovingItem = false
    func move(item: MenuBarItem, to destination: MoveDestination, maxAttempts: Int, beforePostingEvents: (() -> Void)?) async throws {
        beforePostingEvents?()
        precondition(maxAttempts == 1)
        if fail { throw NSError(domain: "test", code: 1) }
        switch destination {
        case .leftOfItem(let anchor): moves.append("\(item.windowID)<\(anchor.windowID)")
        case .rightOfItem(let anchor): moves.append("\(item.windowID)>\(anchor.windowID)")
        }
    }
}
@MainActor final class Events {
    var stopped = false, stops = 0
    func stopAll() { stopped = true; stops += 1 }
    func startAll() { stopped = false }
}
@MainActor final class AppState { let itemManager = MenuBarItemManager(), eventManager = Events() }
@MainActor final class Pane {
    let appState = AppState()
    var isPostingMove = false
    var syntheticDrags: Int { MenuBarItemAXMover.drags }
__PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        Task.detached { try await Task.sleep(for: .seconds(20)); exit(124) }
        let pane = Pane(), item = RowItem(id: "cgs:1")
        FixtureEvents.pressedMouseButtons = 1
        var completed = false
        let waiting = Task {
            let result = await pane.performLayoutMove(item, to: .hidden, destination: nil)
            completed = true
            return result
        }
        // 下一次拖拽超过旧的两秒阈值，也不能丢掉上一条移动或提前占用指针。
        try? await Task.sleep(for: .milliseconds(2200))
        precondition(!completed && !pane.isPostingMove && pane.appState.itemManager.moves.isEmpty && pane.syntheticDrags == 0,
                     "holding the next drag must pause the move, not time it out")
        FixtureEvents.pressedMouseButtons = 0
        let released = await waiting.value
        precondition(released && pane.appState.itemManager.moves == ["1<2"])
        pane.appState.itemManager.moves = []
        FixtureEvents.pressedMouseButtons = 1
        let cancelled = Task { await pane.performLayoutMove(item, to: .hidden, destination: nil) }
        try? await Task.sleep(for: .milliseconds(20))
        cancelled.cancel()
        let cancelledResult = await cancelled.value
        precondition(!cancelledResult && pane.appState.itemManager.moves.isEmpty)
        FixtureEvents.pressedMouseButtons = 0
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

        // AX-only 路径的鼠标等待和修饰键等待都超过旧阈值，仍应各执行一次而非丢弃操作。
        FixtureEvents.pressedMouseButtons = 1
        FixtureEvents.modifierFlags = [.command, .capsLock]
        completed = false
        let delayedAX = Task {
            let result = await pane.performLayoutMove(RowItem(id: "ax:1", quartzFrame: CGRect(x: 100, y: 0, width: 20, height: 20)), to: .hidden, destination: CGPoint(x: 50, y: 10))
            completed = true
            return result
        }
        try? await Task.sleep(for: .milliseconds(2200))
        precondition(!completed && !pane.isPostingMove && pane.syntheticDrags == 1 && !pane.appState.eventManager.stopped)
        FixtureEvents.pressedMouseButtons = 0
        try? await Task.sleep(for: .milliseconds(2200))
        precondition(!completed && !pane.isPostingMove && pane.syntheticDrags == 1 && pane.appState.eventManager.stops == 1,
                     "waiting for user input must not stop event monitoring or lock the next drag")
        FixtureEvents.modifierFlags = [.capsLock, .numericPad, .function]
        let delayedResult = await delayedAX.value
        precondition(delayedResult && pane.syntheticDrags == 2 && !pane.isPostingMove && !pane.appState.eventManager.stopped)

        FixtureEvents.modifierFlags = .shift
        let cancelledAX = Task { await pane.performDrag(from: .zero, to: CGPoint(x: 50, y: 10)) }
        try? await Task.sleep(for: .milliseconds(30))
        cancelledAX.cancel()
        let cancelledAXResult = await cancelledAX.value
        precondition(!cancelledAXResult && pane.syntheticDrags == 2 && !pane.isPostingMove && !pane.appState.eventManager.stopped)

        // 长等期间打开了菜单，松键后必须重新核验，不能抢发合成输入。
        let menuAX = Task { await pane.performDrag(from: .zero, to: CGPoint(x: 50, y: 10)) }
        try? await Task.sleep(for: .milliseconds(30))
        MenuInteractionGuard.isInteracting = true
        FixtureEvents.modifierFlags = []
        let menuAXResult = await menuAX.value
        precondition(!menuAXResult && pane.syntheticDrags == 2)
        MenuInteractionGuard.isInteracting = false
        print("PASS: native/AX layout moves survive long-held input without locking the pointer, resume once, cancel safely, recheck menus and preserve native/on-screen routing")
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("layout-native-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let file = directory.appendingPathComponent("Tests.swift"), binary = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc"); compiler.arguments = ["-parse-as-library", file.path, "-o", binary.path]
try compiler.run(); compiler.waitUntilExit(); guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let runner = Process(); runner.executableURL = binary
try runner.run(); runner.waitUntilExit(); exit(runner.terminationStatus)
