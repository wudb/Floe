//
//  screen-capture-executor.swift
//  Floe
//

import Foundation

// 编译真实执行器，用受控阻塞模拟 WindowServer，不截图、不申请系统权限。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-capture-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation

@main struct Checks {
    static func main() async {
        let executor = ScreenCaptureExecutor()
        let first: Int? = await executor.run {
            precondition(!Thread.isMainThread, "Screenshot work must never run on the main thread")
            return 42
        }
        precondition(first == 42)
        print("PASS: successful capture runs off the main thread")

        let gate = DispatchSemaphore(value: 0)
        let started = Date()
        let timedOut: Int? = await executor.run(timeout: 0.05) {
            gate.wait()
            return 99
        }
        precondition(timedOut == nil && Date().timeIntervalSince(started) < 1)
        print("PASS: blocked system capture returns within the caller deadline")

        for _ in 0..<200 {
            let busy: Int? = await executor.run(timeout: 0.05) {
                preconditionFailure("Blocked worker must reject additional operations")
            }
            precondition(busy == nil)
        }
        print("PASS: timeout keeps the worker occupied; repeated triggers do not queue more work")

        gate.signal()
        var recovered: Int?
        for _ in 0..<100 {
            recovered = await executor.run { 7 }
            if recovered != nil { break }
            try? await Task.sleep(for: .milliseconds(10))
        }
        precondition(recovered == 7)
        print("PASS: late completion does not resume twice, and a finished worker accepts new captures")

        for _ in 0..<100 {
            let value: Int? = await executor.run(timeout: 0.001) {
                Thread.sleep(forTimeInterval: 0.001)
                return 1
            }
            precondition(value == nil || value == 1)
            try? await Task.sleep(for: .milliseconds(2))
        }
        print("PASS: completion/timeout races do not double-resume continuations")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.write(to: fixturePath, atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("checks")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
compiler.arguments = ["swiftc", "-parse-as-library", repo.appendingPathComponent("Floe/Utilities/ScreenCaptureExecutor.swift").path, fixturePath.path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let checks = Process()
checks.executableURL = binary
try checks.run()
checks.waitUntilExit()
exit(checks.terminationStatus)
