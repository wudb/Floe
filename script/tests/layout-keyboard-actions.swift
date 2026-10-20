import Foundation

// 编译生产无障碍/键盘动作，验证禁用分区、系统限制、相邻顺序与单任务所有权。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let methods = [method("    private func findItem("), method("    private func moveWithKeyboard("), method("    private func reorderWithKeyboard("), method("    private func beginAccessibleMove(")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-layout-keys-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
enum MenuBarItemAXDiscovery { enum SectionKind: Hashable { case visible, hidden, alwaysHidden } }
struct RowItem { let id: String; var isMovable = true, canBeHidden = true }
final class Advanced { var enableAlwaysHiddenSection = true }
final class Settings { let advancedSettingsManager = Advanced() }
final class AppState { let settingsManager = Settings() }
@MainActor final class Pane {
    var sections: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] = [.visible: [RowItem(id: "a"), RowItem(id: "b"), RowItem(id: "c")]]
    var isPageVisible = true, isMoving = false
    var moveTask: Task<Void, Never>?
    var focusedItemID: String? = "a"
    var announcements = 0
    func announceLayoutResult() { announcements += 1 }
    let appState = AppState()
    var actions = [String]()
    func drop(itemID: String, to: MenuBarItemAXDiscovery.SectionKind) async {
        guard !Task.isCancelled else { return }
        actions.append("section:\(itemID):\(to)"); await Task.yield()
    }
    func drop(itemID: String, onto: String) async {
        guard !Task.isCancelled else { return }
        actions.append("before:\(itemID):\(onto)"); await Task.yield()
    }
    func startLayoutMoveQueue() {}
    func finish() async { while moveTask != nil { await Task.yield() } }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        let pane = Pane()
        pane.moveWithKeyboard("a", to: .hidden)
        pane.moveWithKeyboard("b", to: .hidden)
        await pane.finish()
        precondition(pane.actions == ["section:a:hidden"], "only one movement may own the task")
        precondition(pane.focusedItemID == "a" && pane.announcements == 1)
        pane.reorderWithKeyboard("b", offset: -1); await pane.finish()
        precondition(pane.actions.last == "before:b:a")
        pane.reorderWithKeyboard("b", offset: 1); await pane.finish()
        precondition(pane.actions.last == "before:c:b")
        let count = pane.actions.count
        pane.reorderWithKeyboard("a", offset: -1)
        pane.reorderWithKeyboard("c", offset: 1)
        pane.appState.settingsManager.advancedSettingsManager.enableAlwaysHiddenSection = false
        pane.moveWithKeyboard("a", to: .alwaysHidden)
        pane.sections[.visible] = [RowItem(id: "fixed", isMovable: false), RowItem(id: "cannotHide", canBeHidden: false)]
        pane.moveWithKeyboard("fixed", to: .hidden)
        pane.moveWithKeyboard("cannotHide", to: .hidden)
        pane.reorderWithKeyboard("cannotHide", offset: -1)
        await pane.finish(); precondition(pane.actions.count == count)
        pane.isPageVisible = false
        pane.moveWithKeyboard("cannotHide", to: .visible)
        await pane.finish(); precondition(pane.actions.count == count)
        print("PASS: production layout keyboard actions reuse movement paths, preserve ordering, reject protected/disabled targets and prevent overlapping or off-page operations")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env")
compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
