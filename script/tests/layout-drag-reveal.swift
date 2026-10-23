import Foundation

// 编译生产分区拖拽方法，验证屏外项先展开，结束/取消恢复分区且不写启动偏好。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
        .replacingOccurrences(of: "private var", with: "var")
}
let methods = [
    "    private func drop(itemID: String, to kind:", "    private func drop(itemID: String, onto targetID:",
    "    private func moveLayoutItem(", "    private func makeMovePreview(", "    private func waitForDropResult(",
    "    private func restoreLayoutSections(", "    private func findItem(", "    private func isImmediatelyBefore(", "    private func hasLanded(",
    "    private var displayedSections:", "    private func enqueueLayoutMove(", "    private func startLayoutMoveQueue(",
].map(method).joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-layout-reveal-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
@MainActor enum NSEvent { static var pressedMouseButtons = 0 }
enum MenuBarItemAXDiscovery { enum SectionKind: Hashable { case visible, hidden, alwaysHidden } }
final class Advanced { var enableAlwaysHiddenSection = true }
final class Settings { let advancedSettingsManager = Advanced() }
@MainActor final class MenuBarSection {
    enum State { case hideItems, showItems }
    final class Control { var state = State.hideItems }
    let controlItem = Control()
    var isEnabled = true, stateRevision = 0, writes = 0
    func setState(_ state: State, persist: Bool) { controlItem.state = state; stateRevision += 1; if persist { writes += 1 } }
}
@MainActor final class Bar { let sections = [MenuBarSection(), MenuBarSection(), MenuBarSection()] }
@MainActor final class ItemManager {
    var isEditingLayout = false, records = 0
    func cacheItemsIfNeeded(force: Bool) async {}
    func recordLayoutChoice() { records += 1 }
}
@MainActor final class AppState { let itemManager = ItemManager(); let menuBarManager = Bar(); let settingsManager = Settings() }
struct RowItem { let id: String; let quartzFrame: CGRect?; var isMovable = true; var canBeHidden = true }
struct Animation { static func easeInOut(duration: Double) -> Animation { Animation() } }
func withAnimation(_ animation: Animation, _ body: () -> Void) { body() }
@MainActor final class Pane {
    let appState = AppState()
    var isMoving = false, scanGeneration = 0, dividerPollGeneration = 0, iconRetryGeneration = 0, moveFailed = false
    var pendingMoves = Set<String>()
    var dropTargetID: String?
    var activeDrag: (token: String, itemID: String)?
    var movePreview: [MenuBarItemAXDiscovery.SectionKind: [RowItem]]?
    var isPageVisible = true
    var moveTask: Task<Void, Never>?
    var moveQueue = [(itemID: String, kind: MenuBarItemAXDiscovery.SectionKind, targetID: String?)]()
    var queuedMovePreview: [MenuBarItemAXDiscovery.SectionKind: [RowItem]]?
    var sections: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] = [:]
    var live: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] = [:]
    var dropped = false, requestedDrag = false, fail = false
    var sources = [CGPoint]()
    var reads = 0, posts = 0, staleReads = 0, refreshes = 0
    var pauseMove = false
    var movePending: CheckedContinuation<Void, Never>?
    var pauseFinalRead = false
    var finalRead: CheckedContinuation<Void, Never>?
    var lastSnapshot: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] = [:]
    var pauseFirstRead = false, failAfterLanding = false
    var firstRead: CheckedContinuation<Void, Never>?
    func seed(_ groups: [MenuBarItemAXDiscovery.SectionKind: [String]]) {
        live = groups.mapValues { $0.map { RowItem(id: $0, quartzFrame: CGRect(x: 100, y: 0, width: 20, height: 20)) } }
        sections = live
    }
    func refreshAfterDrop() async { refreshes += 1; await rescanAfterDrag() }
    func rescanAfterDrag() async {
        reads += 1
        if pauseFirstRead {
            pauseFirstRead = false
            await withCheckedContinuation { firstRead = $0 }
        }
        if NSEvent.pressedMouseButtons != 0 { sections = lastSnapshot; return }
        let revealed = appState.menuBarManager.sections.allSatisfy { $0.controlItem.state == .showItems }
        if dropped && !revealed && pauseFinalRead {
            await withCheckedContinuation { finalRead = $0 }
        }
        if dropped && staleReads > 0 {
            staleReads -= 1; sections = lastSnapshot; return
        }
        sections = live.mapValues { rows in rows.map { row in
            RowItem(id: row.id, quartzFrame: CGRect(x: revealed || row.id != "a" ? 100 : -10000, y: 0, width: 20, height: 20))
        } }
    }
    func performLayoutMove(_ item: RowItem, to kind: MenuBarItemAXDiscovery.SectionKind, anchorID: String? = nil, destination: CGPoint?) async -> Bool {
        posts += 1; requestedDrag = true
        if !item.id.hasPrefix("cgs:") {
            guard let frame = item.quartzFrame, frame.midX > 0, destination != nil else { return false }
            sources.append(CGPoint(x: frame.midX, y: frame.midY))
        }
        if pauseMove { await withCheckedContinuation { movePending = $0 } }
        guard !Task.isCancelled, !fail else { return false }
        lastSnapshot = live
        for key in Array(live.keys) { live[key]?.removeAll { $0.id == item.id } }
        var rows = live[kind] ?? []
        let index = anchorID.flatMap { id in rows.firstIndex(where: { $0.id == id }) } ?? (kind == .visible ? 0 : rows.count)
        rows.insert(item, at: index); live[kind] = rows
        dropped = true
        return !failAfterLanding
    }
    func destinationPoint(for kind: MenuBarItemAXDiscovery.SectionKind) -> CGPoint? { CGPoint(x: 200, y: 10) }
    func reorderDestination(for kind: MenuBarItemAXDiscovery.SectionKind, leftFrame: CGRect?, rightFrame: CGRect?) -> CGPoint? { CGPoint(x: 200, y: 10) }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        Task.detached { try await Task.sleep(for: .seconds(15)); exit(124) }
        let pane = Pane()
        pane.seed([.hidden: ["a"], .visible: ["existing"]])
        await pane.rescanAfterDrag()
        let moving = Task { await pane.drop(itemID: "a", to: .visible) }
        while !pane.isMoving { await Task.yield() }
        precondition(pane.movePreview?[.visible]?.map(\.id) == ["a", "existing"], "preview must immediately match the native divider insertion")
        precondition(pane.sections[.hidden]?.map(\.id) == ["a"], "preview cannot overwrite confirmed positions")
        await moving.value
        precondition(pane.sources.count == 1 && pane.sources[0].x > 0)
        precondition(!pane.moveFailed && !pane.isMoving && pane.movePreview == nil)
        precondition(!pane.appState.itemManager.isEditingLayout && pane.appState.itemManager.records == 1)
        precondition(pane.appState.menuBarManager.sections.allSatisfy { $0.controlItem.state == .hideItems && $0.writes == 0 })

        let native = Pane()
        native.seed([.visible: ["cgs:a", "cgs:b", "cgs:c"]])
        native.pauseMove = true
        let reordering = Task { await native.drop(itemID: "cgs:c", onto: "cgs:a") }
        while native.movePending == nil { await Task.yield() }
        precondition(native.movePreview?[.visible]?.map(\.id) == ["cgs:c", "cgs:a", "cgs:b"])
        precondition(native.sections[.visible]?.map(\.id) == ["cgs:a", "cgs:b", "cgs:c"] && native.reads == 0)
        native.movePending?.resume(); await reordering.value
        precondition(native.reads == 1 && native.posts == 1 && native.refreshes == 0, "native success needs one verification, no pre-scan or duplicate final scan")
        precondition(native.sections[.visible]?.map(\.id) == ["cgs:c", "cgs:a", "cgs:b"] && !native.moveFailed)
        precondition(native.appState.menuBarManager.sections.allSatisfy { $0.stateRevision == 0 }, "visible ordering must not reveal hidden sections")
        let beforeNoOp = native.posts
        await native.drop(itemID: "cgs:c", to: .visible)
        await native.drop(itemID: "cgs:c", onto: "cgs:a")
        precondition(native.posts == beforeNoOp && native.reads == 1, "same-group and already-positioned drops must not refresh or move rows")
        precondition(native.sections[.visible]?.map(\.id) == ["cgs:c", "cgs:a", "cgs:b"])

        let settling = Pane()
        settling.seed([.visible: ["cgs:a", "cgs:b", "cgs:c"]]); settling.staleReads = 3
        await settling.drop(itemID: "cgs:c", onto: "cgs:a")
        precondition(settling.posts == 1 && settling.reads == 4 && !settling.moveFailed, "late frames need readback, not another physical drag")

        // 第一项正在读回时开始第二次拖拽；原生拖拽期间的旧帧不能导致首项出队回跳。
        let queued = Pane()
        queued.seed([.visible: ["cgs:a", "cgs:b", "cgs:c", "cgs:d"]])
        queued.pauseFirstRead = true
        queued.enqueueLayoutMove(itemID: "cgs:c", to: .visible, before: "cgs:a")
        while queued.firstRead == nil { await Task.yield() }
        NSEvent.pressedMouseButtons = 1
        queued.firstRead?.resume()
        try? await Task.sleep(for: .milliseconds(800))
        precondition(queued.moveQueue.count == 1 && queued.pendingMoves.contains("cgs:c") && !queued.moveFailed,
                     "confirmation must not exhaust retries while the next native drag owns input")
        NSEvent.pressedMouseButtons = 0
        queued.enqueueLayoutMove(itemID: "cgs:d", to: .visible, before: "cgs:b")
        precondition(queued.displayedSections[.visible]?.map(\.id) == ["cgs:c", "cgs:a", "cgs:d", "cgs:b"],
                     "second drop must preserve the first pending position")
        while queued.moveTask != nil { await Task.yield() }
        precondition(queued.sections[.visible]?.map(\.id) == ["cgs:c", "cgs:a", "cgs:d", "cgs:b"])
        precondition(queued.posts == 2 && queued.appState.itemManager.records == 2 && !queued.moveFailed)

        let closing = Pane()
        closing.seed([.visible: ["cgs:a", "cgs:b", "cgs:c"]]); closing.pauseFirstRead = true
        closing.enqueueLayoutMove(itemID: "cgs:c", to: .visible, before: "cgs:a")
        while closing.firstRead == nil { await Task.yield() }
        NSEvent.pressedMouseButtons = 1
        closing.firstRead?.resume()
        try? await Task.sleep(for: .milliseconds(30))
        closing.isPageVisible = false; closing.moveTask?.cancel()
        while closing.moveTask != nil { await Task.yield() }
        precondition(closing.pendingMoves.isEmpty && closing.moveQueue.isEmpty && closing.queuedMovePreview == nil)
        precondition(!closing.isMoving && !closing.appState.itemManager.isEditingLayout && closing.appState.itemManager.records == 0,
                     "closing the page while confirmation waits must cancel and release queue ownership")
        NSEvent.pressedMouseButtons = 0

        // 回执报错不等同于移动失败；迟到的系统落点仍需读回核验，不能重复发事件。
        let lateAck = Pane()
        lateAck.seed([.visible: ["cgs:a", "cgs:b", "cgs:c"]]); lateAck.failAfterLanding = true
        await lateAck.drop(itemID: "cgs:c", onto: "cgs:a")
        precondition(!lateAck.moveFailed && lateAck.posts == 1 && lateAck.appState.itemManager.records == 1,
                     "a landed move with a late acknowledgement must be confirmed from system truth")

        let failed = Pane()
        failed.seed([.visible: ["cgs:a", "cgs:b", "cgs:c"]]); failed.fail = true
        await failed.drop(itemID: "cgs:c", onto: "cgs:a")
        precondition(failed.moveFailed && failed.movePreview == nil && failed.pendingMoves.isEmpty)
        precondition(failed.sections[.visible]?.map(\.id) == ["cgs:a", "cgs:b", "cgs:c"] && failed.appState.itemManager.records == 0)

        let finishing = Pane()
        finishing.seed([.hidden: ["a"]]); finishing.pauseFinalRead = true
        let finishingTask = Task { await finishing.drop(itemID: "a", to: .visible) }
        while finishing.finalRead == nil { await Task.yield() }
        precondition(finishing.isMoving && finishing.appState.itemManager.isEditingLayout && finishing.movePreview != nil, "collapse readback retains edit ownership and preview")
        finishing.finalRead?.resume(); await finishingTask.value
        precondition(!finishing.isMoving && !finishing.appState.itemManager.isEditingLayout)

        let cancelled = Pane()
        cancelled.seed([.hidden: ["a"]])
        let task = Task { await cancelled.drop(itemID: "a", to: .visible) }
        while !cancelled.isMoving { await Task.yield() }
        task.cancel(); await task.value
        precondition(cancelled.sources.isEmpty && cancelled.movePreview == nil && !cancelled.isMoving && !cancelled.appState.itemManager.isEditingLayout)
        precondition(cancelled.appState.menuBarManager.sections.allSatisfy { $0.controlItem.state == .hideItems && $0.writes == 0 })
        print("PASS: full move/confirmation queue retains the first position across a second drag, verifies late acknowledgements, cancels input waits and preserves failure/reveal cleanup")

    }
}
"""#
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
let executable = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", file.path, "-o", executable])
try run([executable])
