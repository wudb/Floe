//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift"), encoding: .utf8)
let start = source.range(of: "    private func waitWithTask(")!.lowerBound
let end = source.range(of: "\n}\n", range: start..<source.endIndex)!.lowerBound
let timeout = try String(contentsOf: repo.appendingPathComponent("Floe/Utilities/TaskTimeout.swift"), encoding: .utf8)
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-input-wait-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
@MainActor enum NSEvent { static var modifierFlags: Set<Int> = [] }
@MainActor final class Manager {
    var isMovingItem = false
    var lastMouseMoveStartDate: Date?
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async throws {
        // 若生产等待发生回归，终止测试而非永久挂住验证进程。
        Task.detached {
            try await Task.sleep(for: .seconds(5))
            exit(124)
        }
        let manager = Manager()
        NSEvent.modifierFlags = [1]
        let start = ContinuousClock.now
        do {
            try await manager.waitForNoModifiersPressed(timeout: .milliseconds(30))
            preconditionFailure("held modifiers must time out")
        } catch is TaskTimeoutError {}
        precondition(start.duration(to: .now) < .seconds(1))
        let cancelled = Task { try await manager.waitForNoModifiersPressed() }
        try await Task.sleep(for: .milliseconds(20))
        cancelled.cancel()
        do { try await cancelled.value; preconditionFailure("must cancel") } catch is CancellationError {}
        let released = Task { try await manager.waitForNoModifiersPressed(timeout: .seconds(1)) }
        try await Task.sleep(for: .milliseconds(20))
        NSEvent.modifierFlags = [] // 模拟状态已恢复但没有 flagsChanged 事件。
        try await released.value
        manager.isMovingItem = true
        let movement = Task { try await manager.waitForItemsToStopMoving() }
        try await Task.sleep(for: .milliseconds(20))
        movement.cancel()
        do { try await movement.value; preconditionFailure("movement must cancel") } catch is CancellationError {}
        let alreadyCancelled = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            try await manager.waitForNoModifiersPressed()
        }
        do { try await alreadyCancelled.value; preconditionFailure("pre-cancelled call must cancel") } catch is CancellationError {}
        print("PASS: production input waits support deadlines, cancellation and modifier release without events")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: String(source[start..<end])).write(to: fixturePath, atomically: true, encoding: .utf8)
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
