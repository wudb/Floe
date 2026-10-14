//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift"), encoding: .utf8)
let start = source.range(of: "    func rehideTempShownItems()")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-rehide-lifecycle-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
@MainActor struct MenuBarItem {
    let info: Int
    var logString: String { "item \(info)" }
    static var discovered = [MenuBarItem(info: 1), MenuBarItem(info: 2)]
    static func getMenuBarItems(onScreenOnly: Bool, activeSpaceOnly: Bool) -> [MenuBarItem] {
        discovered
    }
}
struct TempShownItemContext {
    let info: Int
    var returnDestination: Int { info }
    var isShowingInterface = false
}
@MainActor final class TimerStub {
    var invalidated = false
    func invalidate() { invalidated = true }
}
@MainActor enum MenuInteractionGuard { static var isInteracting = false }
@MainActor enum MouseCursor {
    static var balance = 0
    static func hide() { balance += 1 }
    static func show() { balance -= 1 }
}
struct Log {
    func debug(_ text: String) {}
    func info(_ text: String) {}
    func error(_ text: String) {}
    func warning(_ text: String) {}
}
enum Logger { static let itemManager = Log() }
@MainActor final class Manager {
    var cancelledTempReturns = Set<Int>()
    var isRehidingTempShownItems = false
    var itemMoveCount = 0
    var isMouseButtonDown = false
    var isPreparingTempShow = false
    var tempShownItemContexts = [TempShownItemContext(info: 1)]
    var tempShownItemsTimer: TimerStub? = TimerStub()
    var scheduled: [Int] = []
    var moves: [Int] = []
    var pending: CheckedContinuation<Void, Never>?
    var fail = false
    func runTempShownItemTimer(for seconds: Int) { scheduled.append(seconds) }
    func move(item: MenuBarItem, to: Int) async throws {
        moves.append(item.info)
        await withCheckedContinuation { pending = $0 }
        if fail { throw CancellationError() }
    }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func waitForMove(_ manager: Manager) async {
        while manager.pending == nil { await Task.yield() }
    }
    @MainActor static func main() async {
        Task.detached { try await Task.sleep(for: .seconds(5)); exit(124) }
        let failed = Manager(); failed.fail = true
        let first = Task { await failed.rehideTempShownItems() }
        await waitForMove(failed)
        failed.tempShownItemContexts.append(TempShownItemContext(info: 2))
        await failed.rehideTempShownItems() // 重入不移动刚加入的第二项。
        precondition(failed.moves == [1] && failed.itemMoveCount == 1)
        failed.pending!.resume(); await first.value
        precondition(Set(failed.tempShownItemContexts.map(\.info)) == [1, 2])
        precondition(failed.scheduled == [3] && failed.itemMoveCount == 0 && !failed.isRehidingTempShownItems)
        let abandoned = Manager(); abandoned.fail = true
        let abandonedTask = Task { await abandoned.rehideTempShownItems() }
        await waitForMove(abandoned)
        abandoned.cancelledTempReturns.insert(1)
        abandoned.pending!.resume(); await abandonedTask.value
        precondition(abandoned.tempShownItemContexts.isEmpty)
        let success = Manager()
        let request = Task { await success.rehideTempShownItems() }
        await waitForMove(success)
        success.tempShownItemContexts.append(TempShownItemContext(info: 2))
        let newTimer = TimerStub(); success.tempShownItemsTimer = newTimer
        success.pending!.resume(); await request.value
        precondition(success.moves == [1] && success.tempShownItemContexts.map(\.info) == [2])
        precondition(!newTimer.invalidated && success.tempShownItemsTimer === newTimer)
        MenuInteractionGuard.isInteracting = true
        let menu = Manager()
        await menu.rehideTempShownItems()
        precondition(menu.moves.isEmpty && menu.scheduled == [3])
        MenuInteractionGuard.isInteracting = false
        let held = Manager(); held.isMouseButtonDown = true
        await held.rehideTempShownItems()
        precondition(held.moves.isEmpty && held.tempShownItemContexts.count == 1 && held.scheduled == [3])
        precondition(held.itemMoveCount == 0 && !held.isRehidingTempShownItems && MouseCursor.balance == 0)
        MenuBarItem.discovered = []
        let unavailable = Manager()
        for _ in 0..<20 { await unavailable.rehideTempShownItems() }
        precondition(unavailable.moves.isEmpty && unavailable.tempShownItemContexts.map(\.info) == [1])
        precondition(unavailable.scheduled.count == 20 && unavailable.itemMoveCount == 0 && !unavailable.isRehidingTempShownItems)
        precondition(MouseCursor.balance == 0)
        MenuBarItem.discovered = [MenuBarItem(info: 1)]
        let recovery = Task { await unavailable.rehideTempShownItems() }
        await waitForMove(unavailable)
        unavailable.pending!.resume(); await recovery.value
        precondition(unavailable.tempShownItemContexts.isEmpty && unavailable.moves == [1])
        precondition(unavailable.itemMoveCount == 0 && MouseCursor.balance == 0)
        print("PASS: empty discovery retains restoration records across retries and restores after recovery")
        print("PASS: production rehide prevents overlap, preserves new and failed contexts, retains newer timer and balances cleanup")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")).write(to: fixturePath, atomically: true, encoding: .utf8)
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
