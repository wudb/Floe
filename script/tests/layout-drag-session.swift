import Foundation

// 编译布局页的生产拖拽入口，用真实 NSItemProvider 验证连续会话和迟到回调。
// 不创建系统拖拽、不注入鼠标事件，也不修改用户菜单栏。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func member(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
        .replacingOccurrences(of: "private var", with: "var")
}
let methods = ["    private var displayedSections:", "    private var isLayoutDragSourceEnabled:", "    private var canStartLayoutDrag:",
               "    private func dragProvider(", "    private func acceptLayoutDrop(", "    private func enqueueLayoutMove(",
               "    private func startLayoutMoveQueue(", "    private func makeMovePreview("].map(member).joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-layout-session-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Cocoa
struct RowItem { let id: String; var isMovable = true, canBeHidden = true }
enum MenuBarItemAXDiscovery { enum SectionKind: Hashable { case visible, hidden, alwaysHidden } }
@MainActor enum MenuBarItemAXMover { static var isDragging = false }
@MainActor enum MenuInteractionGuard { static var isInteracting = false }
@MainActor final class Manager { var isMovingItem = false }
final class Advanced { var enableAlwaysHiddenSection = true }
final class Settings { let advancedSettingsManager = Advanced() }
@MainActor final class AppState { let itemManager = Manager(), settingsManager = Settings() }
@MainActor final class Tooltip { func dismiss() {} }
struct Animation { static func easeInOut(duration: Double) -> Animation { Animation() } }
func withAnimation(_ animation: Animation, _ body: () -> Void) { body() }
@MainActor final class Pane {
    let appState = AppState(), tooltip = Tooltip()
    var isPageVisible = true, isMoving = false, isPostingMove = false, pageGeneration = 1
    var moveTask: Task<Void, Never>?
    var activeDrag: (token: String, itemID: String)?
    var moveQueue = [(itemID: String, kind: MenuBarItemAXDiscovery.SectionKind, targetID: String?)]()
    var queuedMovePreview: [MenuBarItemAXDiscovery.SectionKind: [RowItem]]?
    var movePreview: [MenuBarItemAXDiscovery.SectionKind: [RowItem]]?
    var sections: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] = [.visible: ["a", "b", "c", "d"].map { RowItem(id: $0) }]
    var calls = [String](), fail = false
    var pending: CheckedContinuation<Void, Never>?
    func moveLayoutItem(itemID: String, to kind: MenuBarItemAXDiscovery.SectionKind, before targetID: String?) async {
        isMoving = true; calls.append(itemID)
        await withCheckedContinuation { pending = $0 }
        if !fail, !Task.isCancelled, let preview = makeMovePreview(itemID: itemID, to: kind, before: targetID) { sections = preview }
        isMoving = false
    }
    func finishOne() { let continuation = pending; pending = nil; continuation?.resume() }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func wait(_ predicate: () -> Bool) async {
        let deadline = ContinuousClock.now.advanced(by: .seconds(3))
        while !predicate() { precondition(ContinuousClock.now < deadline, "Session timed out"); await Task.yield() }
    }
    @MainActor static func main() async {
        let pane = Pane()
        let old = pane.dragProvider(for: RowItem(id: "a"))
        let current = pane.dragProvider(for: RowItem(id: "c"))
        precondition(pane.acceptLayoutDrop([old], to: .hidden))
        precondition(pane.acceptLayoutDrop([current], onto: "a"))
        _ = pane.acceptLayoutDrop([current], onto: "a")
        await wait { pane.pending != nil }
        precondition(pane.calls == ["c"] && pane.moveQueue.count == 1, "stale and duplicate callbacks cannot enqueue another move")
        precondition(pane.isMoving && pane.isLayoutDragSourceEnabled && pane.canStartLayoutDrag, "readback must not lock new drag sources")
        let next = pane.dragProvider(for: RowItem(id: "d"))
        precondition(pane.acceptLayoutDrop([next], onto: "b"))
        await wait { pane.moveQueue.count == 2 }
        precondition(pane.displayedSections[.visible]?.map(\.id) == ["c", "a", "d", "b"], "both drops preview immediately")
        precondition(pane.calls == ["c"] && pane.sections[.visible]?.map(\.id) == ["a", "b", "c", "d"], "physical moves remain serial, preview cannot verify success")
        pane.finishOne()
        await wait { pane.pending != nil }
        precondition(pane.calls == ["c", "d"] && pane.displayedSections[.visible]?.map(\.id) == ["c", "a", "d", "b"])
        pane.finishOne(); await wait { pane.moveTask == nil }
        precondition(pane.sections[.visible]?.map(\.id) == ["c", "a", "d", "b"] && pane.queuedMovePreview == nil)

        // 前项失败后，下一项依据真实快照执行；同一图标可以连续跨分区排队。
        pane.fail = true
        pane.enqueueLayoutMove(itemID: "c", to: .hidden, before: nil)
        await wait { pane.pending != nil }
        pane.enqueueLayoutMove(itemID: "c", to: .alwaysHidden, before: nil)
        pane.finishOne(); await wait { pane.pending != nil }
        pane.fail = false; pane.finishOne(); await wait { pane.moveTask == nil }
        precondition(pane.sections[.hidden]?.isEmpty != false && pane.sections[.alwaysHidden]?.map(\.id) == ["c"])

        pane.isPostingMove = true
        precondition(!pane.isLayoutDragSourceEnabled && !pane.canStartLayoutDrag)
        precondition(!pane.dragProvider(for: RowItem(id: "a")).canLoadObject(ofClass: NSString.self))
        pane.isPostingMove = false
        pane.appState.itemManager.isMovingItem = true; precondition(!pane.canStartLayoutDrag)
        pane.appState.itemManager.isMovingItem = false
        MenuBarItemAXMover.isDragging = true; precondition(!pane.canStartLayoutDrag)
        MenuBarItemAXMover.isDragging = false
        MenuInteractionGuard.isInteracting = true; precondition(!pane.canStartLayoutDrag)
        MenuInteractionGuard.isInteracting = false
        precondition(!pane.dragProvider(for: RowItem(id: "fixed", isMovable: false)).canLoadObject(ofClass: NSString.self))

        let closed = pane.dragProvider(for: RowItem(id: "a"))
        precondition(pane.acceptLayoutDrop([closed], to: .hidden))
        pane.pageGeneration += 1; pane.isPageVisible = false; pane.activeDrag = nil
        try? await Task.sleep(for: .milliseconds(50))
        let count = pane.calls.count
        precondition(pane.moveQueue.isEmpty)
        pane.isPageVisible = true
        pane.enqueueLayoutMove(itemID: "a", to: .hidden, before: nil)
        await wait { pane.pending != nil }
        pane.enqueueLayoutMove(itemID: "b", to: .hidden, before: nil)
        pane.isPageVisible = false; pane.moveTask?.cancel(); pane.finishOne()
        await wait { pane.moveTask == nil }
        precondition(pane.calls.count == count + 1 && pane.moveQueue.isEmpty && pane.queuedMovePreview == nil, "closing page cancels pending work and removes projected positions")
        print("PASS: consecutive native providers queue with immediate previews during readback, serialize moves, rebase failures, reject duplicate/stale callbacks and cancel on page close")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), binary = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    try process.run(); process.waitUntilExit()
    precondition(process.terminationStatus == 0)
}
try run(["swiftc", "-parse-as-library", file.path, "-o", binary.path])
try run([binary.path])
