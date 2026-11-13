import Foundation

// 编译生产的恢复流程、状态项布局与绘制方法；使用内存状态项，不操作用户的菜单栏或偏好。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
func read(_ path: String) throws -> String {
    try String(contentsOf: repo.appendingPathComponent(path), encoding: .utf8)
}
func method(_ source: String, _ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let control = try read("Floe/MenuBar/ControlItem/ControlItem.swift")
let bar = try read("Floe/MenuBar/MenuBarManager.swift")
let methods = [
    "    private func applyStatusItemLength(", "    private func applyStatusItemLayout(",
    "    func updateStatusItem(", "    func restoreToMenuBar()",
].map { method(control, $0) }.joined(separator: "\n").replacingOccurrences(of: "if #available(macOS 27, *)", with: "if usesNewLayout")
let recovery = ["    func recoverMenuBarVisibility()", "    func resumeMenuBarHiding()"].map { method(bar, $0) }.joined(separator: "\n")
let policy = try read("Floe/MenuBar/ControlItem/MenuBarControlLayout.swift")
let fixture = #"""
import Foundation
import CoreGraphics
final class NSImage {
    var size: CGSize
    init(_ width: CGFloat, _ height: CGFloat) { size = CGSize(width: width, height: height) }
    func resized(to size: CGSize) -> NSImage { NSImage(size.width, size.height) }
}
struct ControlItemImage {
    enum Builtin { case chevronLarge, chevronSmall }
    var image: NSImage?
    func nsImage(for appState: AppState) -> NSImage? { image }
    static func builtin(_ name: Builtin) -> Self { Self(image: NSImage(12, 12)) }
}
struct IconSet {
    enum Name { case custom, normal }
    var name = Name.normal
    var hidden = ControlItemImage(image: NSImage(12, 12))
    var visible = ControlItemImage(image: NSImage(12, 12))
}
final class Cell { var isEnabled = true }
final class Button { var image: NSImage?; var cell: Cell? = Cell(); var isHighlighted = false }
final class Status {
    var button: Button? = Button()
    var autosaveName = "SItem"
    var length: CGFloat = 0
    var isVisible = true
}
final class Constraint { var writes = 0; var isActive = true { didSet { writes += 1 } } }
final class Window {
    var frame = CGRect(x: 0, y: 0, width: 300, height: 24)
    var writes = 0
    func setContentSize(_ size: CGSize) { writes += 1; frame.size = size }
}
enum StatusItemDefaults {
    enum Key { case preferredPosition }
    static var values = [String: CGFloat]()
    static subscript(key: Key, name: String) -> CGFloat? {
        get { values[name] }
        set { values[name] = newValue }
    }
}
final class ControlItem {
    static var usesModernMenuBar = true
    enum HidingState { case hideItems, showItems }
    enum Lengths { static let standard: CGFloat = -1 }
    var section: MenuBarSection?
    weak var appState: AppState?
    let statusItem = Status()
    var constraint: Constraint? = Constraint()
    var window: Window? = Window()
    var usesNewLayout = true
    var isSectionDivider: Bool { section?.name != .visible }
    var state = HidingState.hideItems {
        didSet { updateStatusItem(with: state); applyStatusItemLayout(isVisible: isVisible, state: state) }
    }
    var isVisible = true { didSet { applyStatusItemLayout(isVisible: isVisible, state: state) } }
    func expandedHidingLength() -> CGFloat { 200 }
__CONTROL__
}
final class MenuBarSection {
    enum Name: CaseIterable { case visible, hidden, alwaysHidden }
    let name: Name
    let controlItem = ControlItem()
    var writes = 0, rehideStarts = 0
    init(_ name: Name, _ appState: AppState) {
        self.name = name
        controlItem.section = self
        controlItem.appState = appState
        controlItem.statusItem.autosaveName = name == .visible ? "SItem" : (name == .hidden ? "HItem" : "AHItem")
    }
    func setState(_ state: ControlItem.HidingState, persist: Bool) {
        if persist { writes += 1 }
        controlItem.state = state
    }
    func startRehideChecks() { rehideStarts += 1 }
}
final class General { var showFloeIcon = false, reverseFloeIcon = false, autoRehide = true; var floeIcon = IconSet() }
final class Settings {
    let generalSettingsManager = General()
    let advancedSettingsManager = Advanced()
    final class Advanced { var showSectionDividers = false }
}
final class Events { var cancellations = 0; func cancelDelayedInteractions() { cancellations += 1 } }
final class Items {
    var isMovingItem = false, isEditingLayout = false, hasTemporarilyShownItems = false
    var suspended = false
    func setMenuBarRecoveryActive(_ value: Bool) { suspended = value }
}
final class Panel { var closes = 0; func close() { closes += 1 } }
enum MenuInteractionGuard { static var isInteracting = false }
final class MenuBarManager {
    weak var appState: AppState?
    var sections = [MenuBarSection]()
    let floeBarPanel = Panel()
    var isMenuBarRecoveryActive = false
    var isPreparingInitialAXSnapshot = false
    var statesBeforeMenuBarRecovery = [MenuBarSection.Name: ControlItem.HidingState]()
    func section(withName name: MenuBarSection.Name) -> MenuBarSection? { sections.first { $0.name == name } }
__RECOVERY__
}
final class AppState {
    let settingsManager = Settings(), eventManager = Events(), itemManager = Items(), menuBarManager = MenuBarManager()
    init() {
        menuBarManager.appState = self
        menuBarManager.sections = MenuBarSection.Name.allCases.map { MenuBarSection($0, self) }
    }
}
__POLICY__
@main struct Checks {
    static func main() {
        precondition(MenuBarControlLayout.hidingLength(displayWidth: 1440, statusRegionWidth: 1140) == 696)
        precondition(MenuBarControlLayout.hidingLength(displayWidth: 1512, statusRegionWidth: 700) == 668)
        precondition(MenuBarControlLayout.hidingLength(displayWidth: 3024, statusRegionWidth: 500) == 468)
        for width: CGFloat? in [nil, 0, -1, .nan, .infinity, 64] {
            precondition(MenuBarControlLayout.hidingLength(displayWidth: width, statusRegionWidth: 500) == 1)
        }
        precondition(MenuBarControlLayout.hidingLength(displayWidth: 1440, statusRegionWidth: nil) == 1)
        precondition(MenuBarControlLayout.hidingLength(displayWidth: 1440, statusRegionWidth: .nan) == 1)
        precondition(MenuBarControlLayout.hidingLength(for: []) == 1)
        let internalRegion = MenuBarControlLayout.Region(displayWidth: 1512, statusRegionWidth: 700)
        let externalRegion = MenuBarControlLayout.Region(displayWidth: 3840, statusRegionWidth: 3840)
        precondition(MenuBarControlLayout.hidingLength(for: [externalRegion, internalRegion]) == 668)
        precondition(MenuBarControlLayout.hidingLength(for: [internalRegion, externalRegion]) == 668)
        precondition(MenuBarControlLayout.hidingLength(for: [externalRegion, .init(displayWidth: nil, statusRegionWidth: nil)]) == 1)
        for width: CGFloat in [128, 1366, 1440, 1728, 1920, 3840] {
            let length = MenuBarControlLayout.hidingLength(displayWidth: width, statusRegionWidth: width)
            precondition(length + 16 < width / 2, "AppKit padding must stay below the drop threshold")
        }
        precondition(MenuBarControlLayout.initialPosition(for: "SItem", modernMenuBar: true) == 0.5)
        precondition(MenuBarControlLayout.initialPosition(for: "HItem", modernMenuBar: true) == 100_000)
        precondition(MenuBarControlLayout.initialPosition(for: "AHItem", modernMenuBar: true) == 100_010)
        precondition(MenuBarControlLayout.initialPosition(for: "SItem", modernMenuBar: false) == 0)
        precondition(MenuBarControlLayout.initialPosition(for: "HItem", modernMenuBar: false) == 1)
        precondition(MenuBarControlLayout.initialPosition(for: "AHItem", modernMenuBar: false) == 2)
        precondition(MenuBarControlLayout.initialPosition(for: "unknown", modernMenuBar: true) == nil)
        print("PASS: production spacer math stays below half-screen, uses logical points and reveals safely when geometry is unknown")

        let app = AppState(), manager = app.menuBarManager
        let visible = manager.section(withName: .visible)!, hidden = manager.section(withName: .hidden)!, always = manager.section(withName: .alwaysHidden)!
        manager.isPreparingInitialAXSnapshot = true
        hidden.controlItem.updateStatusItem(with: .hideItems)
        precondition(hidden.controlItem.statusItem.length == ControlItem.Lengths.standard)
        precondition(hidden.controlItem.statusItem.button!.image != nil)
        precondition(hidden.controlItem.state == .hideItems && hidden.writes == 0)
        manager.isPreparingInitialAXSnapshot = false
        hidden.controlItem.updateStatusItem(with: hidden.controlItem.state)
        precondition(hidden.controlItem.statusItem.length > 1)
        print("PASS: first AX snapshot keeps dividers readable before hiding without persisting a reveal")
        hidden.controlItem.applyStatusItemLayout(isVisible: false, state: .showItems)
        precondition(hidden.controlItem.statusItem.length == 1)
        precondition(hidden.controlItem.constraint!.writes == 0 && hidden.controlItem.window!.writes == 0)
        hidden.controlItem.usesNewLayout = false
        hidden.controlItem.applyStatusItemLayout(isVisible: false, state: .showItems)
        precondition(hidden.controlItem.statusItem.length == 0 && hidden.controlItem.constraint!.writes == 1 && hidden.controlItem.window!.writes == 1)
        hidden.controlItem.usesNewLayout = true
        always.setState(.showItems, persist: false)
        StatusItemDefaults.values = ["SItem": 9000, "HItem": 400, "AHItem": 600]
        app.settingsManager.generalSettingsManager.floeIcon = IconSet(name: .custom, hidden: .init(image: nil), visible: .init(image: NSImage(0, 0)))
        precondition(manager.recoverMenuBarVisibility())
        precondition(manager.isMenuBarRecoveryActive && app.itemManager.suspended && app.eventManager.cancellations == 1)
        precondition(app.settingsManager.generalSettingsManager.showFloeIcon && app.settingsManager.generalSettingsManager.autoRehide)
        precondition(visible.controlItem.statusItem.isVisible && StatusItemDefaults.values == ["SItem": 0.5, "HItem": 400, "AHItem": 600])
        precondition(visible.controlItem.statusItem.button!.image!.size.width > 0)
        precondition(visible.controlItem.statusItem.button!.image!.size.width.isFinite)
        for section in [hidden, always] {
            precondition(section.controlItem.statusItem.length == 1 && section.writes == 0)
            section.setState(.hideItems, persist: false) // 模拟迟到的智能隐藏回调。
            precondition(section.controlItem.statusItem.length == 1, "late hide must not reinflate a spacer")
        }
        app.settingsManager.generalSettingsManager.floeIcon = IconSet(name: .custom, hidden: .init(image: NSImage(20, 5)), visible: .init(image: NSImage(20, 5)))
        precondition(manager.recoverMenuBarVisibility())
        precondition(visible.controlItem.statusItem.button!.image!.size.height == 17, "recovery must use a visible built-in image even when custom image data is valid but transparent")
        precondition(manager.resumeMenuBarHiding())
        precondition(visible.controlItem.statusItem.button!.image!.size.height == 6.25, "resume must preserve the original custom image")
        precondition(!manager.isMenuBarRecoveryActive && !app.itemManager.suspended)
        precondition(hidden.controlItem.state == .hideItems && always.controlItem.state == .showItems)
        precondition(hidden.controlItem.statusItem.length == 200 && always.controlItem.statusItem.length == 1)
        precondition(manager.sections.allSatisfy { $0.writes == 0 })
        precondition(!manager.resumeMenuBarHiding())
        MenuInteractionGuard.isInteracting = true
        let closes = manager.floeBarPanel.closes
        precondition(!manager.recoverMenuBarVisibility() && !manager.isMenuBarRecoveryActive && manager.floeBarPanel.closes == closes)
        MenuInteractionGuard.isInteracting = false
        app.itemManager.isMovingItem = true
        precondition(!manager.recoverMenuBarVisibility())
        print("PASS: production recovery releases both spacers, survives late auto-hide, repairs an empty Floe icon, preserves divider positions/preferences and restores prior states after repeated recovery")
        print("PASS: new layout never touches shared-window constraints or size; legacy behavior and menu/move guards remain intact")
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-visibility-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__CONTROL__", with: methods).replacingOccurrences(of: "__RECOVERY__", with: recovery).replacingOccurrences(of: "__POLICY__", with: policy).write(to: file, atomically: true, encoding: .utf8)
let executable = directory.appendingPathComponent("checks").path
for arguments in [["swiftc", "-parse-as-library", file.path, "-o", executable], [executable]] {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    guard process.terminationStatus == 0 else { exit(process.terminationStatus) }
}
