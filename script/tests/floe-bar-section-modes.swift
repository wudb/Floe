import Foundation

// 编译生产分区显隐，验证混合呈现不会由关闭浮栏误收起另一个原生分区。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarSection.swift"), encoding: .utf8)
func member(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private var", with: "var")
}
let methods = [member("    private var useFloeBar:"), member("    var isHidden:"), member("    func show(persistState:"), member("    func hide(persistState:")].joined(separator: "\n")
let panelSource = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
let resetStart = panelSource.range(of: "    private func collapseNativeHierarchy(")!.lowerBound
let resetEnd = panelSource.range(of: "\n    }", range: resetStart..<panelSource.endIndex)!.upperBound
let resetMethod = String(panelSource[resetStart..<resetEnd]).replacingOccurrences(of: "private func", with: "func")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-section-modes-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
final class Preferences {
    var modes: [String: Bool] = [:]
    func usesFloating(section: String, legacy: Bool) -> Bool { modes[section] ?? legacy }
}
final class General { var useFloeBar = false; let barPreferences = Preferences() }
final class Settings { let generalSettingsManager = General() }
final class Events { func cancelDelayedInteractions() {} }
final class ItemManager { var isEditingLayout = false }
enum MenuInteractionGuard { static var isInteracting = false }
final class Control {
    enum State { case showItems, hideItems }
    var state = State.hideItems, isAddedToMenuBar = true
}
@MainActor final class Panel {
    var currentSection: Section.Name?, isActivatingAXItem = false
    func show(section: Section.Name, on: Int) async { currentSection = section }
    func close() { currentSection = nil }
}
@MainActor final class Bar {
    let panel = Panel()
    var sections = [Section]()
    func section(withName name: Section.Name) -> Section? { sections.first { $0.name == name } }
}
@MainActor final class AppState {
    let settingsManager = Settings(), eventManager = Events(), itemManager = ItemManager(), menuBarManager = Bar()
    func preventShowOnHover() {}
    func allowShowOnHover() {}
}
@MainActor final class Section {
    enum Name { case visible, hidden, alwaysHidden }
    let name: Name
    var appState: AppState?
    let controlItem = Control()
    var stateRevision = 0
    var presentationTask: Task<Void, Never>?
    var screenForFloeBar: Int? = 1
    var floeBarPanel: Panel? { appState?.menuBarManager.panel }
    init(_ name: Name, _ state: AppState) { self.name = name; appState = state }
    func setState(_ state: Control.State, persist: Bool) { controlItem.state = state; stateRevision += 1 }
    func startRehideChecks() {}
    func stopRehideChecks() {}
    __PRODUCTION__
}
typealias MenuBarSection = Section
@MainActor final class Presenter { __RESET__ }
@main struct Checks {
    @MainActor static func main() async {
        let state = AppState()
        let visible = Section(.visible, state), hidden = Section(.hidden, state), always = Section(.alwaysHidden, state)
        state.menuBarManager.sections = [visible, hidden, always]
        let preferences = state.settingsManager.generalSettingsManager.barPreferences
        preferences.modes = ["hidden": false, "alwaysHidden": true]
        hidden.show(); precondition(hidden.controlItem.state == .showItems)
        always.show(); await always.presentationTask?.value
        precondition(!always.isHidden && state.menuBarManager.panel.currentSection == .alwaysHidden)
        always.hide()
        precondition(state.menuBarManager.panel.currentSection == nil && hidden.controlItem.state == .showItems)
        hidden.hide(); precondition(hidden.controlItem.state == .hideItems)
        preferences.modes = ["hidden": true, "alwaysHidden": false]
        hidden.show(); await hidden.presentationTask?.value
        precondition(state.menuBarManager.panel.currentSection == .hidden)
        always.show(); precondition(always.controlItem.state == .showItems)
        hidden.hide()
        precondition(always.controlItem.state == .showItems && state.menuBarManager.panel.currentSection == nil)
        state.itemManager.isEditingLayout = true
        always.hide(persistState: false); precondition(always.controlItem.state == .showItems)
        state.itemManager.isEditingLayout = false
        always.hide(persistState: false); precondition(always.controlItem.state == .hideItems)
        hidden.show(); hidden.hide(); await hidden.presentationTask?.value
        precondition(state.menuBarManager.panel.currentSection == nil)
        let presenter = Presenter()
        for section in state.menuBarManager.sections { section.setState(.showItems, persist: false) }
        presenter.collapseNativeHierarchy(for: .alwaysHidden, in: state)
        precondition(visible.controlItem.state == .showItems && hidden.controlItem.state == .showItems && always.controlItem.state == .hideItems)
        presenter.collapseNativeHierarchy(for: .hidden, in: state)
        precondition(state.menuBarManager.sections.allSatisfy { $0.controlItem.state == .hideItems })
        print("PASS: production mixed section modes preserve other native sections, expose native hierarchy, protect reorder work and cancel pending shows")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).replacingOccurrences(of: "__RESET__", with: resetMethod).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
