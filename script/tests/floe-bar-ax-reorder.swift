import Foundation

// 编译生产 AX 排序，验证读回、屏外拒绝、暂时展开回滚和取消；不发送真实鼠标事件。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBarReorderController.swift"), encoding: .utf8)
let start = source.range(of: "    private static func moveUsingAX(")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end]).replacingOccurrences(of: "private static func", with: "static func")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-ax-reorder-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
import CoreFoundation
struct NSScreen { let displayID: UInt32; static var screens = [NSScreen(displayID: 1)] }
func CGDisplayBounds(_ id: UInt32) -> CGRect { CGRect(x: 0, y: 0, width: 1000, height: 800) }
struct NSWorkspace { static let shared = NSWorkspace(); let runningApplications = [1] }
enum MenuBarItemAXDiscovery {
    struct AXMenuBarItem { let element: NSNumber; var axFrame: CGRect? }
    static var items = [AXMenuBarItem]()
    static func isTrusted() -> Bool { true }
    static func discoverItems(in: [Int]) -> [AXMenuBarItem] { items }
}
enum MenuInteractionGuard { static var isInteracting = false }
@MainActor final class MenuBarSection {
    enum State { case showItems, hideItems }
    final class Control { var state = State.hideItems }
    let controlItem = Control()
    var isEnabled = true, stateRevision = 0, writes = 0
    func setState(_ state: State, persist: Bool) { controlItem.state = state; stateRevision += 1; if persist { writes += 1 } }
}
@MainActor final class Bar { let sections = [MenuBarSection(), MenuBarSection()] }
@MainActor final class Events { var balance = 0; func stopAll() { balance += 1 }; func startAll() { balance -= 1 } }
@MainActor final class AppState { let menuBarManager = Bar(), eventManager = Events() }
@MainActor enum MenuBarItemAXMover {
    static var calls = 0, applies = true
    static func commandDrag(from: CGPoint, to: CGPoint) async -> Bool {
        calls += 1
        if applies { MenuBarItemAXDiscovery.items[0].axFrame = CGRect(x: 20, y: 0, width: 8, height: 24) }
        return true
    }
}
@MainActor enum Reorder { __PRODUCTION__ }
func check(_ value: Bool) { precondition(value) }
@main struct Checks {
    @MainActor static func main() async throws {
        let state = AppState()
        let item = MenuBarItemAXDiscovery.AXMenuBarItem(element: 1, axFrame: CGRect(x: 80, y: 0, width: 8, height: 24))
        let target = MenuBarItemAXDiscovery.AXMenuBarItem(element: 2, axFrame: CGRect(x: 30, y: 0, width: 8, height: 24))
        MenuBarItemAXDiscovery.items = [item, target]
        check(try await Reorder.moveUsingAX(item, before: target, after: false, appState: state))
        precondition(state.eventManager.balance == 0 && state.menuBarManager.sections.allSatisfy { $0.controlItem.state == .hideItems && $0.writes == 0 })
        MenuBarItemAXDiscovery.items = [item, target]; MenuBarItemAXMover.applies = false
        check(!(try await Reorder.moveUsingAX(item, before: target, after: false, appState: state)))
        precondition(state.eventManager.balance == 0)
        MenuBarItemAXDiscovery.items[0].axFrame = CGRect(x: -20000, y: 0, width: 8, height: 24)
        let count = MenuBarItemAXMover.calls
        check(!(try await Reorder.moveUsingAX(item, before: target, after: false, appState: state)))
        precondition(MenuBarItemAXMover.calls == count)
        MenuBarItemAXDiscovery.items = [item, target]
        let task = Task { try await Reorder.moveUsingAX(item, before: target, after: false, appState: state) }
        while state.menuBarManager.sections[0].controlItem.state != .showItems { await Task.yield() }
        task.cancel()
        do { _ = try await task.value; preconditionFailure("must cancel") } catch is CancellationError {}
        precondition(state.menuBarManager.sections.allSatisfy { $0.controlItem.state == .hideItems && $0.writes == 0 })
        precondition(state.eventManager.balance == 0 && MenuBarItemAXMover.calls == count)
        print("PASS: production AX reorder verifies actual order, rejects offscreen frames, restores transient reveals and balances event monitoring on success/failure/cancellation")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: method).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
