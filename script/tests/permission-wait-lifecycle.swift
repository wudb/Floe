import Foundation

// 直接编译生产 Permission，验证重入等待、取消与返回应用后的状态刷新。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Permissions/Permission.swift"), encoding: .utf8)
let production = String(source.prefix(upTo: source.range(of: "// MARK: - AccessibilityPermission")!.lowerBound))
    .replacingOccurrences(of: "import AXSwift", with: "")
    .replacingOccurrences(of: "import ScreenCaptureKit", with: "")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-permission-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
__PRODUCTION__
@main struct Checks {
    @MainActor static func main() async throws {
        Task.detached {
            try await Task.sleep(for: .seconds(10))
            exit(124)
        }
        var checks = 0
        var granted = false
        let permission = Permission(title: "Test", details: [], isRequired: true, settingsURL: nil, check: { checks += 1; return granted }, request: {})
        permission.stopTimerCheck()
        let first = Task { try await permission.waitForPermission() }
        let second = Task { try await permission.waitForPermission() }
        try await Task.sleep(for: .milliseconds(30))
        first.cancel()
        do { try await first.value; preconditionFailure("must cancel independently") } catch is CancellationError {}
        let checksBefore = checks
        try await Task.sleep(for: .milliseconds(400))
        precondition(checks == checksBefore, "waiters must not poll independently")
        granted = true
        try await second.value
        precondition(permission.hasPermission)
        let third = Task { try await permission.waitForPermission() }
        let fourth = Task { try await permission.waitForPermission() }
        try await third.value
        try await fourth.value
        granted = false
        NotificationCenter.default.post(name: NSApplication.didBecomeActiveNotification, object: nil)
        precondition(!permission.hasPermission, "stopped polling must still notice revocation on activation")
        granted = true
        // 不发送激活通知：撤权后应已恢复检测，后台授予也能被发现。
        try await Task.sleep(for: .milliseconds(1200))
        precondition(permission.hasPermission, "revocation must restart shared polling")
        permission.stopTimerCheck()
        granted = false
        NotificationCenter.default.post(name: NSApplication.didBecomeActiveNotification, object: nil)
        let togetherA = Task { try await permission.waitForPermission() }
        let togetherB = Task { try await permission.waitForPermission() }
        try await Task.sleep(for: .milliseconds(20))
        granted = true
        NotificationCenter.default.post(name: NSApplication.didBecomeActiveNotification, object: nil)
        try await togetherA.value
        try await togetherB.value
        let cancelled = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            try await permission.waitForPermission()
        }
        do { try await cancelled.value; preconditionFailure("pre-cancelled grant must cancel") } catch is CancellationError {}
        print("PASS: production permission waits are independent and cancellable; waiters share checks and revocation restarts polling")
    }
}
"""#
let path = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: production).write(to: path, atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("checks")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
compiler.arguments = ["swiftc", "-parse-as-library", path.path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let checks = Process()
checks.executableURL = binary
try checks.run()
checks.waitUntilExit()
exit(checks.terminationStatus)
