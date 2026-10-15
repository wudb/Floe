import Foundation

// 编译生产拖拽会话，使用原生 NSItemProvider 验证载荷归属、重复回调和关闭取消。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBarReorderController.swift"), encoding: .utf8)
let end = source.range(of: "    /// 等待用户释放真实拖拽")!.lowerBound
let prefix = String(source[..<end])
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-drag-session-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Cocoa
import Combine
struct MenuBarItem { let windowID: UInt32 }
struct MenuBarItemAXDiscovery { struct AXMenuBarItem {} }
struct MenuBarSection { enum Name { case hidden } }
@MainActor final class AppState {}
@MainActor enum Fixture { static var calls = 0 }
__PRODUCTION__
    private static func move(_ source: Item, before target: Item, after: Bool, section: MenuBarSection.Name, appState: AppState) async -> Bool {
        Fixture.calls += 1
        do { try await Task.sleep(for: .milliseconds(100)); return true } catch { return false }
    }
}
@main struct Checks {
    @MainActor static func wait(_ predicate: () -> Bool) async {
        let clock = ContinuousClock(), deadline = ContinuousClock.now.advanced(by: .seconds(3))
        while !predicate() { precondition(clock.now < deadline); await Task.yield() }
    }
    @MainActor static func main() async {
        let state = AppState(), controller = FloeBarReorderController()
        controller.activate(); controller.isEditing = true
        precondition(!controller.accept([NSItemProvider(object: "external" as NSString)], before: .cgs(MenuBarItem(windowID: 2)), section: .hidden, appState: state))
        let provider = controller.provider(for: .cgs(MenuBarItem(windowID: 1)))
        precondition(controller.accept([provider], before: .cgs(MenuBarItem(windowID: 2)), section: .hidden, appState: state))
        _ = controller.accept([provider], before: .cgs(MenuBarItem(windowID: 3)), section: .hidden, appState: state)
        await wait { Fixture.calls == 1 }; await wait { !controller.isMoving }
        precondition(Fixture.calls == 1 && !controller.failed)
        let editSession = controller.provider(for: .cgs(MenuBarItem(windowID: 8)))
        _ = controller.accept([editSession], before: .cgs(MenuBarItem(windowID: 2)), section: .hidden, appState: state)
        controller.isEditing = false; controller.isEditing = true
        try? await Task.sleep(for: .milliseconds(150))
        precondition(Fixture.calls == 1)
        let late = controller.provider(for: .cgs(MenuBarItem(windowID: 4)))
        _ = controller.accept([late], before: .cgs(MenuBarItem(windowID: 2)), section: .hidden, appState: state)
        controller.cancel()
        try? await Task.sleep(for: .milliseconds(150))
        precondition(Fixture.calls == 1)
        controller.activate()
        let cancelled = controller.provider(for: .cgs(MenuBarItem(windowID: 5)))
        _ = controller.accept([cancelled], before: .cgs(MenuBarItem(windowID: 2)), section: .hidden, appState: state)
        await wait { controller.isMoving }
        controller.cancel(); await wait { !controller.isMoving }
        precondition(Fixture.calls == 2 && !controller.failed)
        print("PASS: production native drag payloads reject external/stale drops, serialize duplicate callbacks and cancel queued/in-flight work on close")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: prefix).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
