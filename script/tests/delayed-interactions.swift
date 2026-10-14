import Foundation

// 编译生产延迟交互方法，验证取消、修饰键快照和设置/分区变化后的旧任务淘汰。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Events/EventManager.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let methods = [method("    func cancelDelayedInteractions()"), method("    private func handleShowOnClick("), method("    private func handleSmartRehide(")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-delayed-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
struct Flags: OptionSet {
    let rawValue: Int
    static let option = Flags(rawValue: 1), control = Flags(rawValue: 2), deviceIndependentFlagsMask = Flags(rawValue: 3)
}
final class Window {}
struct NSEvent { var modifierFlags: Flags = []; var window: Window? = nil }
@MainActor final class General {
    enum Strategy { case smart, timed }
    var showOnClick = true, autoRehide = true
    var rehideStrategy = Strategy.smart
}
final class Advanced { var canToggleAlwaysHiddenSection = true }
@MainActor final class Settings { let generalSettingsManager = General(); let advancedSettingsManager = Advanced() }
@MainActor final class Section {
    enum Name { case visible, hidden, alwaysHidden }
    final class Control { let window = Window() }
    let controlItem = Control()
    var stateRevision = 0, toggles = 0, hides = 0
    var isHidden = true, isEnabled = true
    func toggle() { toggles += 1; isHidden.toggle(); stateRevision += 1 }
    func hide(persistState: Bool) { hides += 1; isHidden = true; stateRevision += 1 }
}
@MainActor final class Bar {
    let sections = [Section(), Section(), Section()]
    let floeBarPanel = Window()
    func section(withName: Section.Name) -> Section? { sections[withName == .visible ? 0 : withName == .hidden ? 1 : 2] }
}
@MainActor final class AppState { let settingsManager = Settings(); let menuBarManager = Bar() }
@MainActor enum Bridging { static var activeSpaceID = 1 }
@MainActor enum MouseCursor { static var locationCoreGraphics: CGPoint? = .zero }
final class Application { enum Policy { case regular }; let bundleIdentifier = "app"; let isActive = true; let activationPolicy = Policy.regular }
struct WindowInfo {
    let frame = CGRect(x: -10, y: -10, width: 20, height: 20), layer = 0
    let title: String? = "normal"
    var owningApplication: Application? { Application() }
    static func getOnScreenWindows(excludeDesktopWindows: Bool) -> [WindowInfo] { [WindowInfo()] }
}
@MainActor final class Manager {
    let appState: AppState? = AppState()
    var clickTask: Task<Void, Never>?, smartRehideTask: Task<Void, Never>?, hoverTask: Task<Void, Never>?
    var hoverIntent: Bool?
    var isMonitoring = true, isMouseInsideEmptyMenuBarSpace = true, isMouseInsideMenuBar = false, isMouseInsideFloeBar = false
    var menuOpen = false, contextMenus = 0
    func isMenuOpenGlobally() -> Bool { menuOpen }
    func isMenuBarDropdownWindow(_ window: WindowInfo) -> Bool { false }
    func handleShowRightClickMenu() { contextMenus += 1 }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async throws {
        let manager = Manager(), app = manager.appState!
        manager.handleShowOnClick(with: NSEvent(modifierFlags: .option))
        try await Task.sleep(for: .milliseconds(80))
        precondition(app.menuBarManager.sections[2].toggles == 1)
        app.settingsManager.generalSettingsManager.showOnClick = false
        manager.handleShowOnClick(with: NSEvent())
        manager.handleShowOnClick(with: NSEvent(modifierFlags: .option))
        try await Task.sleep(for: .milliseconds(80))
        precondition(app.menuBarManager.sections[1].toggles == 0 && app.menuBarManager.sections[2].toggles == 2)
        app.menuBarManager.sections[2].isEnabled = false
        manager.handleShowOnClick(with: NSEvent(modifierFlags: .option))
        try await Task.sleep(for: .milliseconds(80))
        precondition(app.menuBarManager.sections[1].toggles == 1)
        app.menuBarManager.sections[1].toggles = 0
        app.settingsManager.generalSettingsManager.showOnClick = true
        manager.handleShowOnClick(with: NSEvent())
        manager.cancelDelayedInteractions()
        try await Task.sleep(for: .milliseconds(80))
        precondition(app.menuBarManager.sections[1].toggles == 0)
        manager.handleShowOnClick(with: NSEvent())
        app.settingsManager.generalSettingsManager.showOnClick = false
        try await Task.sleep(for: .milliseconds(80))
        precondition(app.menuBarManager.sections[1].toggles == 0)
        for section in app.menuBarManager.sections { section.isHidden = false }
        manager.handleSmartRehide(with: NSEvent())
        app.menuBarManager.sections[1].stateRevision += 1
        try await Task.sleep(for: .milliseconds(300))
        precondition(app.menuBarManager.sections.allSatisfy { $0.hides == 0 })
        manager.handleSmartRehide(with: NSEvent())
        app.settingsManager.generalSettingsManager.autoRehide = false
        try await Task.sleep(for: .milliseconds(300))
        precondition(app.menuBarManager.sections.allSatisfy { $0.hides == 0 })
        app.settingsManager.generalSettingsManager.autoRehide = true
        manager.handleSmartRehide(with: NSEvent())
        Bridging.activeSpaceID += 1; manager.menuOpen = true
        try await Task.sleep(for: .milliseconds(300))
        precondition(app.menuBarManager.sections.allSatisfy { $0.hides == 0 })
        manager.menuOpen = false
        manager.handleSmartRehide(with: NSEvent())
        try await Task.sleep(for: .milliseconds(300))
        precondition(app.menuBarManager.sections.allSatisfy { $0.hides == 1 })
        print("PASS: production delayed click preserves Option, supports Option with click disabled, cancels old tasks; smart rehide respects settings, newer choices and menus across Spaces")
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
