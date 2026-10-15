import Foundation

// 编译生产控制器，注入显示器/菜单快照；不触碰真实菜单栏、Space 或系统设置。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
func source(_ path: String) throws -> String {
    try String(contentsOf: repo.appendingPathComponent(path), encoding: .utf8).replacingOccurrences(of: "UserDefaults.standard", with: "MemoryDefaults.standard")
}
var controller = try source("Floe/MenuBar/MenuBarPresentationController.swift")
let setup = controller.range(of: "    func performSetup() {")!.lowerBound
let refresh = controller.range(of: "    private func refresh() {")!.lowerBound
controller.removeSubrange(setup..<refresh)
controller = controller.replacingOccurrences(of: "import Cocoa", with: "import Foundation")
    .replacingOccurrences(of: "private func refresh()", with: "func refresh()")
    .replacingOccurrences(of: "CGDisplayBounds", with: "TestDisplayBounds")
    .replacingOccurrences(of: "CGDisplayIsBuiltin", with: "TestDisplayIsBuiltin")
let controlSource = try source("Floe/MenuBar/ControlItem/ControlItem.swift")
let controlStart = controlSource.range(of: "            Publishers.Merge3(")!.lowerBound
let controlEnd = controlSource.range(of: "            appState.settingsManager.advancedSettingsManager.$showSectionDividers", range: controlStart..<controlSource.endIndex)!.lowerBound
let subscription = String(controlSource[controlStart..<controlEnd])
let dependencies = try ["Floe/UI/FloeBar/AdaptivePresentationPolicy.swift", "Floe/UI/FloeBar/AdaptivePresentationPreferences.swift", "Floe/UI/FloeBar/FloeBarPreferences.swift"].map(source).joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-adaptive-integration-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
import Combine
extension Publisher { func mapToVoid() -> some Publisher<Void, Failure> { map { _ in () } } }
final class MemoryDefaults {
    static let standard = MemoryDefaults()
    var values = [String: Data]()
    func data(forKey key: String) -> Data? { values[key] }
    func set(_ data: Data, forKey key: String) { values[key] = data }
}
struct NSScreen {
    static var screens = [NSScreen(displayID: 1, persistentDisplayKey: "laptop", frame: CGRect(x: 0, y: 0, width: 1000, height: 800), hasNotch: true, auxiliaryTopRightArea: CGRect(x: 560, y: 0, width: 440, height: 37)),
                          NSScreen(displayID: 2, persistentDisplayKey: "external", frame: CGRect(x: -1920, y: 0, width: 1920, height: 1080), hasNotch: false, auxiliaryTopRightArea: nil)]
    let displayID: UInt32
    let persistentDisplayKey: String
    let frame: CGRect
    let hasNotch: Bool
    let auxiliaryTopRightArea: CGRect?
}
func TestDisplayBounds(_ id: UInt32) -> CGRect { NSScreen.screens.first { $0.displayID == id }!.frame }
func TestDisplayIsBuiltin(_ id: UInt32) -> UInt32 { id == 1 ? 1 : 0 }
enum Bridging {
    static var states = ["laptop": false, "external": false]
    static func fullscreenDisplayStates() -> [String: Bool] { states }
}
enum MenuInteractionGuard { static var isInteracting = false }
@MainActor final class MenuBarSection {
    enum Name: Hashable { case visible, hidden, alwaysHidden }
    var name = Name.hidden
    var hideCalls = 0
    var writes = 0
    func hide(persistState: Bool) { hideCalls += 1; if persistState { writes += 1 } }
}
struct Item {
    enum Info { case hiddenControlItem, alwaysHiddenControlItem, other }
    let info: Info
    let frame: CGRect
    init(_ width: Double, _ info: Info = .other) { self.info = info; frame = CGRect(x: -10000, y: 0, width: width, height: 24) }
}
struct Cache {
    var values: [MenuBarSection.Name: [Item]] = [.visible: [Item(100), Item(10000, .hiddenControlItem)], .hidden: [Item(200)], .alwaysHidden: [Item(200)]]
    subscript(name: MenuBarSection.Name) -> [Item] { values[name] ?? [] }
}
@MainActor final class Items {
    var itemCache = Cache()
    var isItemDiscoveryUnavailable = false, isEditingLayout = false, isMovingItem = false, hasTemporarilyShownItems = false
}
@MainActor final class General {
    let barPreferences = FloeBarPreferences()
    let adaptivePresentation = AdaptivePresentationPreferences()
    @Published var useFloeBar = false
}
@MainActor final class Settings { let generalSettingsManager = General() }
@MainActor final class Events { var bestScreen: NSScreen? = NSScreen.screens[0] }
@MainActor final class Panel { var screen: NSScreen?; var currentSection: MenuBarSection.Name?; var isActivatingAXItem = false }
@MainActor final class Bar {
    let floeBarPanel = Panel()
    var presentationController: MenuBarPresentationController!
    let hidden = MenuBarSection(), always = MenuBarSection()
    var menuReads = 0
    var isMenuBarHiddenBySystemUserDefaults = false
    func section(withName name: MenuBarSection.Name) -> MenuBarSection? { name == .alwaysHidden ? always : hidden }
    func getApplicationMenuFrame(for id: UInt32, deadline: Date? = nil) -> CGRect? {
        menuReads += 1
        let bounds = TestDisplayBounds(id)
        return CGRect(x: bounds.minX, y: bounds.minY, width: 300, height: 24)
    }
}
@MainActor final class AppState {
    let settingsManager = Settings(), eventManager = Events(), itemManager = Items(), menuBarManager = Bar()
}
__DEPENDENCIES__
__CONTROLLER__
enum Event: Hashable { case leftMouseDown, leftMouseUp, rightMouseUp }
final class Button {
    var events = Set<Event>()
    func sendAction(on values: Set<Event>) { events = values }
}
final class StatusItem { let button: Button? = Button() }
@MainActor final class Control {
    let statusItem = StatusItem()
    let section: MenuBarSection? = MenuBarSection()
    var cancellables = Set<AnyCancellable>()
    func configure(_ appState: AppState) {
        var c = Set<AnyCancellable>()
        __SUBSCRIPTION__
        cancellables = c
    }
}
@main struct Checks {
    @MainActor static func main() {
        let app = AppState()
        var owner: AppState? = AppState()
        let detached = MenuBarPresentationController(appState: owner!)
        owner = nil
        precondition(detached.decision(for: .hidden) == .native)
        let manager = MenuBarPresentationController(appState: app)
        app.menuBarManager.presentationController = manager
        let general = app.settingsManager.generalSettingsManager
        let control = Control()
        control.configure(app)
        RunLoop.main.run(until: Date().addingTimeInterval(0.02))
        precondition(control.statusItem.button!.events == [.leftMouseUp, .rightMouseUp])
        general.useFloeBar = true
        RunLoop.main.run(until: Date().addingTimeInterval(0.02))
        precondition(control.statusItem.button!.events == [.leftMouseDown, .rightMouseUp], "production subscription must survive configure scope and react to changes")
        for legacy in [false, true] {
            general.useFloeBar = legacy
            precondition(manager.usesFloating(for: .hidden) == legacy && manager.usesFloating(for: .alwaysHidden) == legacy)
        }
        general.useFloeBar = false
        manager.refresh()
        precondition(app.menuBarManager.menuReads == 0, "legacy mode must not sample AX")
        general.barPreferences.setPresentation(.automatic, for: "hidden")
        general.barPreferences.setPresentation(.automatic, for: "alwaysHidden")
        manager.refresh()
        RunLoop.main.run(until: Date().addingTimeInterval(0.02))
        precondition(control.statusItem.button!.events == [.leftMouseUp, .rightMouseUp], "adaptive mode always resolves on mouse up")
        let laptop = NSScreen.screens[0], external = NSScreen.screens[1]
        precondition(manager.decision(for: .hidden, on: laptop) == .native)
        precondition(manager.decision(for: .alwaysHidden, on: laptop) == .floating, "include hidden and visible widths for native always-hidden reveal")
        precondition(manager.decision(for: .alwaysHidden, on: external) == .native)
        precondition(!manager.activatesOnMouseDown(for: .hidden))
        let reads = app.menuBarManager.menuReads
        for _ in 0..<100 { _ = manager.decision(for: .hidden, on: external) }
        precondition(app.menuBarManager.menuReads == reads, "hot path must not rescan")
        general.adaptivePresentation.rules.fullscreen = .disabled
        Bridging.states["external"] = true
        manager.refresh()
        precondition(manager.decision(for: .hidden, on: external) == .disabled)
        precondition(manager.decision(for: .hidden, on: laptop) == .native, "other display fullscreen must not leak")
        general.adaptivePresentation.setOverride(.floating, for: "external")
        manager.refresh()
        precondition(manager.decision(for: .hidden, on: external) == .floating)
        general.barPreferences.setPresentation(.native, for: "hidden")
        precondition(manager.decision(for: .hidden, on: external) == .native, "section override wins")
        general.barPreferences.setPresentation(.floating, for: "hidden")
        precondition(manager.activatesOnMouseDown(for: .hidden))
        general.barPreferences.setPresentation(.automatic, for: "hidden")
        general.adaptivePresentation.setOverride(.automatic, for: "external")
        app.eventManager.bestScreen = external
        manager.refresh()
        precondition(manager.decision(for: .hidden) == .disabled, "pointer display selects policy")
        // 重现菜单/拖拽期间规则变化，必须延后收起并在空闲后补做。
        app.eventManager.bestScreen = laptop
        app.itemManager.isEditingLayout = true
        let calls = app.menuBarManager.hidden.hideCalls
        general.adaptivePresentation.setOverride(.floating, for: "laptop")
        manager.refresh()
        precondition(app.menuBarManager.hidden.hideCalls == calls)
        app.itemManager.isEditingLayout = false
        manager.refresh()
        precondition(app.menuBarManager.hidden.hideCalls == calls + 1 && app.menuBarManager.hidden.writes == 0)
        // 热插拔清除已断开屏的环境缓存，持久 UUID 覆盖在重连后仍生效。
        NSScreen.screens = [external]; manager.refresh()
        NSScreen.screens = [laptop, external]; manager.refresh()
        precondition(manager.decision(for: .hidden, on: laptop) == .floating)
        general.adaptivePresentation.setOverride(.automatic, for: "laptop")
        app.itemManager.isItemDiscoveryUnavailable = true
        manager.refresh()
        precondition(manager.decision(for: .hidden, on: laptop) == .floating)
        print("PASS: production controller integrates section/display/fullscreen precedence, per-screen capacity, native hierarchy width, pointer targeting, hot-path caching, deferred cleanup and reconnect overrides")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__SUBSCRIPTION__", with: subscription).replacingOccurrences(of: "__DEPENDENCIES__", with: dependencies).replacingOccurrences(of: "__CONTROLLER__", with: controller).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
