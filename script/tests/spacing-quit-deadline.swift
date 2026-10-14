import Foundation

// 运行生产退出等待，模拟应用拒绝退出/强制退出和任务取消，不终止真实应用。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/Spacing/MenuBarItemSpacingManager.swift"), encoding: .utf8)
let start = source.range(of: "    private func signalAppToQuit(")!.lowerBound
let end = source.range(of: "\n    /// Asynchronously launches", range: start..<source.endIndex)!.lowerBound
let method = String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-spacing-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
final class NSRunningApplication {
    var isTerminated = false, acceptsQuit = false, acceptsForce = false, forces = 0
    func terminate() { if acceptsQuit { isTerminated = true } }
    func forceTerminate() { forces += 1; if acceptsForce { isTerminated = true } }
}
struct Logger { static let spacing = Logger(); func debug(_ message: String) {} }
@MainActor final class Manager {
    let forceTerminateDelay = 0
    struct GroupedRelaunchError: Error { let failedApps: [String] }
    func logString(for app: NSRunningApplication) -> String { "fixture" }
    __PRODUCTION__
}
@main struct Tests {
    @MainActor static func main() async throws {
        let manager = Manager()
        let normal = NSRunningApplication(); normal.acceptsQuit = true
        try await manager.signalAppToQuit(normal); precondition(normal.forces == 0)
        let forced = NSRunningApplication(); forced.acceptsForce = true
        try await manager.signalAppToQuit(forced); precondition(forced.forces == 1)
        let stubborn = NSRunningApplication(), start = ContinuousClock().now
        do { try await manager.signalAppToQuit(stubborn); preconditionFailure("must time out") }
        catch is Manager.GroupedRelaunchError {}
        precondition(stubborn.forces == 1 && start.duration(to: ContinuousClock().now) < .seconds(3))
        let cancelled = NSRunningApplication()
        let task = Task { try await manager.signalAppToQuit(cancelled) }
        task.cancel()
        do { try await task.value; preconditionFailure("must cancel") } catch is CancellationError {}
        precondition(cancelled.forces == 0)
        print("PASS: production spacing quit handles normal/forced termination, refuses infinite waits and propagates cancellation")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: method).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env")
compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
