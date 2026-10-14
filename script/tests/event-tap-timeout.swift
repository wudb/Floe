//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Events/EventTap.swift"), encoding: .utf8)
let start = source.range(of: "    func enable(timeout:", options: .backwards)!.lowerBound
let end = source.range(of: "\n}\n", range: start..<source.endIndex)!.lowerBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-event-timeout-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
// 编译生产超时/禁用方法；以可控 tap 模拟权限失败与系统禁用，无需改动真实事件流。
let fixture = #"""
import Foundation
@MainActor final class EventTap {
    var timeoutGeneration: UUID?
    var isEnabled = false
    var canEnable = true
    func enable() { isEnabled = canEnable }
    func withUnwrappedComponents(body: (Int, Int, Int) -> Void) { isEnabled = false }
    static let mode = 0
    var mode: Int { Self.mode }
    __METHODS__
}
func CFRunLoopRemoveSource(_ loop: Int, _ source: Int, _ mode: Int) {}
enum CGEvent { static func tapEnable(tap: Int, enable: Bool) {} }
@main struct Checks {
    @MainActor static func main() async throws {
        let tap = EventTap()
        var count = 0
        tap.canEnable = false
        tap.enable(timeout: .milliseconds(10)) { count += 1 }
        try await Task.sleep(for: .milliseconds(40))
        precondition(count == 1, "creation failure must time out")
        tap.canEnable = true
        tap.enable(timeout: .milliseconds(10)) { count += 1 }
        tap.isEnabled = false
        try await Task.sleep(for: .milliseconds(40))
        precondition(count == 2, "system disable must time out")
        tap.enable(timeout: .milliseconds(10)) { count += 1 }
        tap.disable()
        try await Task.sleep(for: .milliseconds(40))
        precondition(count == 2, "successful completion must suppress timeout")
        tap.enable(timeout: .milliseconds(10)) { count += 100 }
        tap.disable()
        tap.enable(timeout: .milliseconds(20)) { count += 1 }
        try await Task.sleep(for: .milliseconds(60))
        precondition(count == 3, "old timeout must not complete new operation")
        tap.enable(timeout: .milliseconds(10)) { count += 100 }
        tap.enable(timeout: .milliseconds(20)) { count += 1 }
        try await Task.sleep(for: .milliseconds(60))
        precondition(count == 4, "replacement must invalidate prior timeout")
        tap.enable(timeout: .milliseconds(10)) { count += 1 }
        tap.isEnabled = false
        tap.enable() // 系统回调重新启用不延长本次操作的截止时间。
        try await Task.sleep(for: .milliseconds(40))
        precondition(count == 5)
        try await Task.sleep(for: .milliseconds(40))
        precondition(count == 5, "deadline must only fire once")
        print("PASS: production tap deadline handles creation failure, system disable, completion and replacement")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__METHODS__", with: String(source[start..<end])).write(to: fixturePath, atomically: true, encoding: .utf8)
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
