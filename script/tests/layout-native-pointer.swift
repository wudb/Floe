import Foundation

// 编译生产原生移动事务；用内存事件替身验证指针清理，不发送真实鼠标事件。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift"), encoding: .utf8)
let start = source.range(of: "    func move(\n        item: MenuBarItem,")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end])
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-native-pointer-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
@MainActor enum NSEvent { static var pressedMouseButtons = 0 }
struct MenuBarItem { let logString = "item" }
struct MoveDestination { let logString = "destination" }
struct EventError: Error {
    enum Code { case couldNotComplete, invalidAppState, invalidCursorLocation, invalidItem }
    init(code: Code, item: MenuBarItem) {}
}
struct Log {
    func debug(_ text: String) {}
    func info(_ text: String) {}
    func warning(_ text: String) {}
}
enum Logger { static let itemManager = Log() }
@MainActor enum MouseCursor {
    static var events = [String](), canHide = true
    static var locationCoreGraphics: CGPoint? { CGPoint(x: 42, y: 24) }
    static func hide() -> Bool { events.append("hide"); return canHide }
    static func warp(to point: CGPoint) { precondition(point == CGPoint(x: 42, y: 24)); events.append("warp") }
    static func show() { events.append("show") }
}
@MainActor final class Events {
    var stopped = false
    func stopAll() { precondition(!stopped); stopped = true }
    func startAll() { precondition(stopped); stopped = false }
}
@MainActor final class AppState { let eventManager = Events() }
@MainActor final class Manager {
    var appState: AppState? = AppState()
    var itemMoveCount = 0, calls = 0, wakeups = 0
    var frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    var correct = false, fail = false, cancel = false
    func itemHasCorrectPosition(item: MenuBarItem, for destination: MoveDestination) throws -> Bool { correct }
    func waitForNoModifiersPressed() async throws { try Task.checkCancellation() }
    func waitForMouseToStopMoving() async throws { try Task.checkCancellation() }
    func getCurrentFrame(for item: MenuBarItem) -> CGRect? { frame }
    func wakeUpItem(_ item: MenuBarItem) async throws { wakeups += 1 }
    func moveItemWithoutRestoringMouseLocation(_ item: MenuBarItem, to destination: MoveDestination) async throws {
        precondition(itemMoveCount > 0 && appState?.eventManager.stopped == true)
        precondition(MouseCursor.events.last == "hide", "hide before any synthetic mouse event")
        calls += 1
        if cancel { withUnsafeCurrentTask { $0?.cancel() }; throw CancellationError() }
        if fail { throw EventError(code: .couldNotComplete, item: item) }
        frame.origin.x += 20
    }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        let waiting = Manager()
        var enteredPointerTransaction = false
        NSEvent.pressedMouseButtons = 1
        let task = Task {
            try? await waiting.move(item: MenuBarItem(), to: MoveDestination(), maxAttempts: 1) {
                enteredPointerTransaction = true
            }
        }
        try? await Task.sleep(for: .milliseconds(30))
        precondition(!enteredPointerTransaction && waiting.calls == 0 && MouseCursor.events.isEmpty)
        NSEvent.pressedMouseButtons = 0; await task.value
        precondition(enteredPointerTransaction && waiting.calls == 1)
        for outcome in ["success", "failure", "cancel", "hideFailure", "alreadyPositioned"] {
            let manager = Manager()
            manager.fail = outcome == "failure"; manager.cancel = outcome == "cancel"
            manager.correct = outcome == "alreadyPositioned"
            MouseCursor.events = []; MouseCursor.canHide = outcome != "hideFailure"
            let task = Task { () -> Bool in
                do { try await manager.move(item: MenuBarItem(), to: MoveDestination(), maxAttempts: 1); return true }
                catch { return false }
            }
            let result = await task.value
            precondition(result == !["failure", "cancel"].contains(outcome))
            precondition(manager.itemMoveCount == 0 && manager.appState?.eventManager.stopped == false)
            precondition(manager.wakeups == 0 && manager.calls == (manager.correct ? 0 : 1), "layout failure cannot trigger hidden physical retries")
            let expected = manager.correct ? [] : (MouseCursor.canHide ? ["hide", "warp", "show"] : ["hide", "warp"])
            precondition(MouseCursor.events == expected, "restore before show; balance only successful hides on every exit")
        }
        print("PASS: native layout move uses one physical attempt and restores cursor/event ownership on success, failure and cancellation")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), binary = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: method).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
try run(["swiftc", "-parse-as-library", file.path, "-o", binary.path])
try run([binary.path])
