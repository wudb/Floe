import Foundation
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func member(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("layout-refresh-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
import Combine
struct MenuBarItem { var frame = CGRect(x: 900, y: 0, width: 20, height: 24) }
enum MenuBarSection { enum Name { case visible, hidden, alwaysHidden } }
enum MenuBarItemAXDiscovery {
    enum SectionKind { case visible, hidden, alwaysHidden }
    static func classify(centerX: CGFloat?, hiddenDividerX: CGFloat?, alwaysHiddenDividerX: CGFloat?) -> SectionKind { .visible }
}
struct Cache {
    var kind: MenuBarSection.Name? = .hidden
    func section(for item: MenuBarItem) -> MenuBarSection.Name? { kind }
}
@MainActor final class Items { var itemCache = Cache() }
@MainActor final class AppState { let itemManager = Items() }
@MainActor final class Pane {
    let appState = AppState()
    var isRefreshing = false, isManualRefresh = false
    var pending: CheckedContinuation<Void, Never>?
    var reads = 0
    func scanAndApply() async { reads += 1; await withCheckedContinuation { pending = $0 } }
__REFRESH__
__KIND__
}
@main struct Checks {
    @MainActor static func main() async {
        let pane = Pane(), item = MenuBarItem()
        for (stored, expected) in [(MenuBarSection.Name.hidden, MenuBarItemAXDiscovery.SectionKind.hidden), (.alwaysHidden, .alwaysHidden), (.visible, .visible)] {
            pane.appState.itemManager.itemCache.kind = stored
            precondition(pane.cachedKind(for: item, hiddenX: nil, alwaysHiddenX: nil) == expected, "missing UI dividers must not overwrite cached membership")
        }
        let background = Task { await pane.refresh(showProgress: false) }
        while pane.pending == nil { await Task.yield() }
        precondition(pane.isRefreshing && !pane.isManualRefresh)
        await pane.refresh(); precondition(pane.reads == 1)
        pane.pending?.resume(); await background.value; pane.pending = nil
        let manual = Task { await pane.refresh() }
        while pane.pending == nil { await Task.yield() }
        precondition(pane.isManualRefresh)
        pane.pending?.resume(); await manual.value
        precondition(!pane.isRefreshing && !pane.isManualRefresh)
        print("PASS: cached membership survives missing boundaries; background scans stay quiet and manual refresh retains overlap protection")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), binary = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__REFRESH__", with: member("    private func refresh(showProgress:")).replacingOccurrences(of: "__KIND__", with: member("    private func cachedKind(")).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc"); compiler.arguments = ["-parse-as-library", file.path, "-o", binary.path]
try compiler.run(); compiler.waitUntilExit(); guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let runner = Process(); runner.executableURL = binary
try runner.run(); runner.waitUntilExit(); exit(runner.terminationStatus)
