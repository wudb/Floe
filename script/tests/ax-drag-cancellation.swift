import Foundation

// 编译生产拖拽执行器，以受控事件服务验证取消及异常不会留下按键/鼠标状态。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemAXMover.swift"), encoding: .utf8)
    .replacingOccurrences(of: "import Cocoa", with: "import Foundation\nimport CoreGraphics")
    .replacingOccurrences(of: "CGWarpMouseCursorPosition", with: "fixtureWarp")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-drag-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
enum CGEventType { case mouseMoved, flagsChanged, leftMouseDown, leftMouseDragged, leftMouseUp }
struct CGEventFlags: OptionSet { let rawValue: Int; static let maskCommand = CGEventFlags(rawValue: 1) }
enum Tap { case cghidEventTap }
enum Button { case left }
final class CGEventSource { enum State { case hidSystemState }; init?(stateID: State) {} }
final class Recorder: @unchecked Sendable {
    let lock = NSLock()
    var events: [(CGEventType, CGEventFlags)] = []
    var warps = 0
    var failDrag = false
    func record(_ type: CGEventType, _ flags: CGEventFlags) { lock.lock(); defer { lock.unlock() }; events.append((type, flags)) }
    var snapshot: [(CGEventType, CGEventFlags)] { lock.lock(); defer { lock.unlock() }; return events }
}
let recorder = Recorder()
final class CGEvent {
    var type = CGEventType.mouseMoved
    var flags: CGEventFlags = []
    var location = CGPoint(x: 42, y: 42)
    init?(source: CGEventSource?) {}
    init?(keyboardEventSource: CGEventSource, virtualKey: Int, keyDown: Bool) {}
    init?(mouseEventSource: CGEventSource, mouseType: CGEventType, mouseCursorPosition: CGPoint, mouseButton: Button) {
        if recorder.failDrag && mouseType == .leftMouseDragged { return nil }
        type = mouseType; location = mouseCursorPosition
    }
    func post(tap: Tap) { recorder.record(type, flags) }
}
func fixtureWarp(_ point: CGPoint) { recorder.lock.lock(); defer { recorder.lock.unlock() }; recorder.warps += 1 }
__PRODUCTION__
@main struct Checks {
    @MainActor static func main() async {
        Task.detached { try await Task.sleep(for: .seconds(10)); exit(124) }
        let source = CGPoint(x: 100, y: 10), destination = CGPoint(x: 200, y: 10)
        let invalid = await MenuBarItemAXMover.commandDrag(from: CGPoint(x: CGFloat.infinity, y: 0), to: destination)
        precondition(!invalid)
        let task = Task { await MenuBarItemAXMover.commandDrag(from: source, to: destination) }
        while !recorder.snapshot.contains(where: { $0.0 == .leftMouseDown }) { await Task.yield() }
        let overlapping = await MenuBarItemAXMover.commandDrag(from: source, to: destination)
        precondition(!overlapping)
        task.cancel()
        let cancelled = await task.value
        precondition(!cancelled && !MenuBarItemAXMover.isDragging)
        precondition(recorder.snapshot.contains(where: { $0.0 == .leftMouseUp }))
        precondition(recorder.snapshot.last?.0 == .flagsChanged && recorder.snapshot.last?.1.isEmpty == true)
        precondition(recorder.warps == 1)
        recorder.events.removeAll(); recorder.failDrag = true
        let failed = await MenuBarItemAXMover.commandDrag(from: source, to: destination)
        precondition(!failed && !MenuBarItemAXMover.isDragging)
        precondition(recorder.snapshot.contains(where: { $0.0 == .leftMouseUp }))
        precondition(recorder.snapshot.last?.1.isEmpty == true && recorder.warps == 2)
        recorder.events.removeAll(); recorder.failDrag = false
        let normal = await MenuBarItemAXMover.commandDrag(from: source, to: destination)
        precondition(normal && !MenuBarItemAXMover.isDragging && recorder.warps == 3)
        precondition(recorder.snapshot.filter { $0.0 == .leftMouseDragged }.count == 15)
        print("PASS: production AX drag rejects overlap/invalid points, releases mouse and Command on cancel/failure, restores cursor and remains reusable")
    }
}
"""#
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: source).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
let executable = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", file.path, "-o", executable])
try run([executable])
