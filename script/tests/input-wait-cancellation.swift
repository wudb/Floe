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
import Cocoa
@MainActor enum FixtureEvents { static var modifierFlags: NSEvent.ModifierFlags = [] }
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
        // 用 AppKit 的真实标志位，防止把 Caps Lock、方向键及 Fn 状态当成按住修饰键。
        let passive: NSEvent.ModifierFlags = [.capsLock, .numericPad, .function, .help]
        for flags: NSEvent.ModifierFlags in [[], .capsLock, .numericPad, .function, .help, passive] {
            FixtureEvents.modifierFlags = flags
            try await manager.waitForNoModifiersPressed(timeout: .milliseconds(100))
        }
        for modifier: NSEvent.ModifierFlags in [.command, .control, .option, .shift] {
            FixtureEvents.modifierFlags = modifier.union(passive)
            do {
                try await manager.waitForNoModifiersPressed(timeout: .milliseconds(20))
                preconditionFailure("held mouse-affecting modifiers must still wait")
            } catch is TaskTimeoutError {}
        }
        FixtureEvents.modifierFlags = [.command, .capsLock]
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
        FixtureEvents.modifierFlags = passive // 松开 Command 后仍保留 Caps Lock 等状态，没有 flagsChanged 事件。
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
        print("PASS: input waits ignore Caps Lock/numeric-pad/Fn/help flags, wait for Command/Control/Option/Shift, and preserve timeout/cancellation")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
let methods = String(source[start..<end]).replacingOccurrences(of: "NSEvent.modifierFlags", with: "FixtureEvents.modifierFlags")
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
