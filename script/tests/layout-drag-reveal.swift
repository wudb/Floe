import Foundation

// 编译生产分区拖拽方法，验证屏外项先展开，结束/取消恢复分区且不写启动偏好。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
let start = source.range(of: "    private func drop(itemID: String, to kind:")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-layout-reveal-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
enum MenuBarItemAXDiscovery { enum SectionKind: Hashable { case visible, hidden, alwaysHidden } }
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
@MainActor final class AppState { let itemManager = ItemManager(); let menuBarManager = Bar() }
struct RowItem { let id: String; let quartzFrame: CGRect?; var isMovable = true; var canBeHidden = true }
struct Animation { static func easeInOut(duration: Double) -> Animation { Animation() } }
func withAnimation(_ animation: Animation, _ body: () -> Void) { body() }
@MainActor final class Pane {
    let appState = AppState()
    var isMoving = false, scanGeneration = 0, dividerPollGeneration = 0, iconRetryGeneration = 0, moveFailed = false
    var pendingMoves = Set<String>()
    var sections: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] = [:]
    var dropped = false, requestedDrag = false
    var sources = [CGPoint]()
    func applySnapshotFromCache() {}
    func refresh() async { await rescanAfterDrag() }
    var pauseFinalRead = false
    var finalRead: CheckedContinuation<Void, Never>?
    func refreshAfterDrop() async {
        if pauseFinalRead { await withCheckedContinuation { finalRead = $0 } }
        await rescanAfterDrag()
    }
    func rescanAfterDrag() async {
        let revealed = appState.menuBarManager.sections.allSatisfy { $0.controlItem.state == .showItems }
        let row = RowItem(id: "a", quartzFrame: CGRect(x: revealed ? 100 : -10000, y: 0, width: 20, height: 20))
        sections = [dropped ? .visible : .hidden: [row]]
    }
    func removeItem(id: String) -> (RowItem, MenuBarItemAXDiscovery.SectionKind)? {
        for (kind, rows) in sections {
            if let row = rows.first(where: { $0.id == id }) { sections[kind] = []; return (row, kind) }
        }
        return nil
    }
    func performLayoutMove(_ item: RowItem, to kind: MenuBarItemAXDiscovery.SectionKind, destination: CGPoint?) async -> Bool {
        guard let frame = item.quartzFrame, let destination else { return false }
        return await performDrag(from: CGPoint(x: frame.midX, y: frame.midY), to: destination)
    }
    func destinationPoint(for kind: MenuBarItemAXDiscovery.SectionKind) -> CGPoint? { CGPoint(x: 200, y: 10) }
    func performDrag(from: CGPoint, to: CGPoint) async -> Bool {
        sources.append(from); requestedDrag = true
        do { try await Task.sleep(for: .milliseconds(10)) } catch { return false }
        dropped = true
        return true
    }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        let pane = Pane()
        await pane.rescanAfterDrag()
        await pane.drop(itemID: "a", to: .visible)
        precondition(pane.sources.count == 1 && pane.sources[0].x > 0)
        precondition(!pane.isMoving && !pane.appState.itemManager.isEditingLayout && pane.appState.itemManager.records == 1)
        precondition(pane.appState.menuBarManager.sections.allSatisfy { $0.controlItem.state == .hideItems && $0.writes == 0 })
        let finishing = Pane()
        finishing.pauseFinalRead = true
        let finishingTask = Task { await finishing.drop(itemID: "a", to: .visible) }
        while finishing.finalRead == nil { await Task.yield() }
        precondition(finishing.isMoving && finishing.appState.itemManager.isEditingLayout, "final scan must retain ownership against background refresh")
        finishing.finalRead?.resume(); await finishingTask.value
        precondition(!finishing.isMoving && !finishing.appState.itemManager.isEditingLayout)
        let cancelled = Pane()
        let task = Task { await cancelled.drop(itemID: "a", to: .visible) }
        while !cancelled.isMoving { await Task.yield() }
        task.cancel(); await task.value
        precondition(cancelled.sources.isEmpty && !cancelled.isMoving && !cancelled.appState.itemManager.isEditingLayout)
        precondition(cancelled.appState.menuBarManager.sections.allSatisfy { $0.controlItem.state == .hideItems && $0.writes == 0 })
        print("PASS: production layout drag reveals offscreen source before reading frames, restores transient section states on success/cancel and releases edit ownership")
    }
}
"""#
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: method).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
let executable = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", file.path, "-o", executable])
try run([executable])
