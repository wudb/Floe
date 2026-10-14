//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let methods = [method("    private func waitWithTask("), method("    private func waitForFrameChange("), method("    func slowMove(")].joined(separator: "\n")
let timeout = try String(contentsOf: repo.appendingPathComponent("Floe/Utilities/TaskTimeout.swift"), encoding: .utf8)
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-move-wait-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
struct MenuBarItem { let logString = "fixture" }
struct Log { func debug(_ text: String) {}; func warning(_ text: String) {} }
enum Logger { static let itemManager = Log() }
func NSStringFromRect(_ frame: CGRect) -> String { String(describing: frame) }
struct EventError: Error {
    enum Code { case frameCheckTimeout, otherTimeout }
    let code: Code
    let item: MenuBarItem
}
@MainActor final class Manager {
    enum MoveDestination { case fixture }
    var itemMoveCount = 0
    var queries = 0
    var positioned = false
    var frame: CGRect? = CGRect(x: 0, y: 0, width: 20, height: 20)
    func move(item: MenuBarItem, to: MoveDestination) async throws { try Task.checkCancellation() }
    func itemHasCorrectPosition(item: MenuBarItem, for: MoveDestination) throws -> Bool {
        queries += 1; return positioned
    }
    func getCurrentFrame(for item: MenuBarItem) -> CGRect? { frame }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async throws {
        Task.detached { try await Task.sleep(for: .seconds(5)); exit(124) }
        let manager = Manager(); let item = MenuBarItem()
        do {
            try await manager.slowMove(item: item, to: .fixture, timeout: .milliseconds(100))
            preconditionFailure("stationary move must time out")
        } catch let error as EventError { precondition(error.code == .otherTimeout) }
        precondition(manager.queries > 0 && manager.queries <= 25, "polling must be bounded")
        precondition(manager.itemMoveCount == 0)
        let cancelled = Task { try await manager.slowMove(item: item, to: .fixture, timeout: .seconds(4)) }
        try await Task.sleep(for: .milliseconds(20)); cancelled.cancel()
        do { try await cancelled.value; preconditionFailure("must cancel") } catch is CancellationError {}
        precondition(manager.itemMoveCount == 0)
        let snapshot = manager.queries
        try await Task.sleep(for: .milliseconds(30))
        precondition(manager.queries == snapshot, "cancelled polling must stop")
        manager.positioned = true
        try await manager.slowMove(item: item, to: .fixture)
        precondition(manager.itemMoveCount == 0)
        let initial = manager.frame!
        let frameWait = Task { try await manager.waitForFrameChange(of: item, initialFrame: initial, timeout: .seconds(4)) }
        try await Task.sleep(for: .milliseconds(20)); frameWait.cancel()
        do { try await frameWait.value; preconditionFailure("frame wait must cancel") } catch is CancellationError {}
        manager.frame = CGRect(x: 1, y: 0, width: 20, height: 20)
        try await manager.waitForFrameChange(of: item, initialFrame: initial, timeout: .milliseconds(50))
        print("PASS: production move polling is bounded; cancellation stops both position and frame waits and releases move state")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: fixturePath, atomically: true, encoding: .utf8)
try timeout.write(to: directory.appendingPathComponent("TaskTimeout.swift"), atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("checks")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
compiler.arguments = ["swiftc", "-parse-as-library", fixturePath.path, directory.appendingPathComponent("TaskTimeout.swift").path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let checks = Process()
checks.executableURL = binary
try checks.run()
checks.waitUntilExit()
exit(checks.terminationStatus)
