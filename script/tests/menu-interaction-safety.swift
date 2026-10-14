//
//  menu-interaction-safety.swift
//  Floe
//

import Foundation

// 用受控 AX/窗口/激活服务编译生产保护与隐藏方法，不操作真实菜单或 Dock。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let guardSource = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuInteractionGuard.swift"), encoding: .utf8)
    .replacingOccurrences(of: "import AXSwift", with: "")
    .replacingOccurrences(of: "import Cocoa", with: "")
func method(_ path: String, _ signature: String) throws -> String {
    let source = try String(contentsOf: repo.appendingPathComponent(path), encoding: .utf8)
    let start = source.range(of: signature)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end])
}
let hide = try method("Floe/MenuBar/MenuBarManager.swift", "    func hideApplicationMenus()")
let show = try method("Floe/MenuBar/MenuBarManager.swift", "    func showApplicationMenus()")
let length = try method("Floe/MenuBar/ControlItem/ControlItem.swift", "    private func applyStatusItemLength(")
let fixture = #"""
import Foundation
import CoreGraphics
enum FixtureError: Error { case denied }
enum Fixture {
    static var focused: UIElement?
    static var denied = false
    static var windows: [WindowInfo] = []
}
final class UIElement {
    let role: String?
    let parent: UIElement?
    let system: Bool
    var element: UIElement { self }
    init(role: String? = nil, parent: UIElement? = nil, system: Bool = false) {
        self.role = role; self.parent = parent; self.system = system
    }
    convenience init(_ native: UIElement) { self.init(role: native.role, parent: native.parent, system: native.system) }
    func attribute<T>(_ name: String) throws -> T {
        precondition(Thread.isMainThread)
        guard !Fixture.denied else { throw FixtureError.denied }
        let value: Any?
        switch name {
        case "AXFocusedUIElement": value = Fixture.focused
        case "AXRole": value = role
        case "AXParent": value = parent
        default: value = nil
        }
        guard let value = value as? T else { throw FixtureError.denied }
        return value
    }
}
func AXUIElementCreateSystemWide() -> UIElement { UIElement(system: true) }
func AXUIElementSetMessagingTimeout(_ element: UIElement, _ seconds: Double) {
    precondition(Thread.isMainThread && seconds <= 0.02)
}
enum LevelKey { case popUpMenuWindow }
func CGWindowLevelForKey(_ key: LevelKey) -> Int { 101 }
struct WindowInfo {
    var ownerPID: Int32 = 42
    var layer = 101
    var alpha = 1.0
    var frame = CGRect(x: 10, y: 100, width: 120, height: 180)
    static func getOnScreenWindows() -> [WindowInfo] { Fixture.windows }
}
final class NSRunningApplication: NSObject { let processIdentifier: Int32 = 42 }
final class NSWorkspace {
    static let shared = NSWorkspace()
    var frontmostApplication: NSRunningApplication? = NSRunningApplication()
}
struct Logger {
    static let menuBarManager = Logger()
    func error(_ text: String) {}
    func info(_ text: String) {}
}
final class AppState {
    enum Policy { case regular, accessory }
    var activations = 0
    var dockActivations = 0
    var restoredApp: NSRunningApplication?
    func activate(withPolicy: Policy, usingDock: Bool = true) {
        activations += 1
        if usingDock { dockActivations += 1 }
    }
    func deactivate(withPolicy: Policy, yieldingTo app: NSRunningApplication? = nil) { restoredApp = app }
}
@MainActor final class Manager {
    var appState: AppState? = AppState()
    var isHidingApplicationMenus = false
    var applicationBeforeHidingMenus: NSRunningApplication?
    __HIDE__
    __SHOW__
}
final class StatusItem {
    var writes = 0
    var length: CGFloat = 0 { didSet { writes += 1 } }
}
final class ControlItem {
    let statusItem = StatusItem()
    __LENGTH__
    func apply(_ length: CGFloat) { applyStatusItemLength(length) }
}
@main struct Checks {
    @MainActor static func main() {
        for role in ["AXMenu", "AXMenuItem", "AXPopover"] {
            Fixture.focused = UIElement(role: "AXStaticText", parent: UIElement(role: role))
            precondition(MenuInteractionGuard.isInteracting)
        }
        Fixture.focused = UIElement(role: "AXTextField")
        precondition(!MenuInteractionGuard.isInteracting)
        Fixture.denied = true
        Fixture.windows = [WindowInfo()]
        precondition(MenuInteractionGuard.isInteracting)
        Fixture.windows = [WindowInfo(ownerPID: 99), WindowInfo(layer: 0), WindowInfo(alpha: 0)]
        precondition(!MenuInteractionGuard.isInteracting)
        Fixture.windows = []
        Fixture.denied = false
        print("PASS: AX menus, submenu ancestry and foreground popup windows block automatic changes")
        print("PASS: ordinary windows, transparent popups and other processes do not block")
        let manager = Manager()
        Fixture.focused = UIElement(role: "AXMenu")
        manager.hideApplicationMenus()
        precondition(manager.appState?.activations == 0 && !manager.isHidingApplicationMenus)
        Fixture.focused = nil
        let originalApp = NSWorkspace.shared.frontmostApplication
        for _ in 0..<100 { manager.hideApplicationMenus() }
        precondition(manager.appState?.activations == 1 && manager.appState?.dockActivations == 0)
        manager.showApplicationMenus()
        precondition(manager.appState?.restoredApp === originalApp && !manager.isHidingApplicationMenus)
        print("PASS: no activation during menu tracking; repeated hides activate once without Dock")
        print("PASS: application menus restore the original host")
        let item = ControlItem()
        for _ in 0..<500 { item.apply(10_000) }
        precondition(item.statusItem.writes == 1)
        item.apply(0)
        item.apply(0)
        precondition(item.statusItem.writes == 2)
        print("PASS: duplicate status-item lengths do not repeatedly update AppKit")
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-menu-safety-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let generated = directory.appendingPathComponent("Checks.swift")
try (guardSource + fixture.replacingOccurrences(of: "__HIDE__", with: hide)
    .replacingOccurrences(of: "__SHOW__", with: show)
    .replacingOccurrences(of: "__LENGTH__", with: length)).write(to: generated, atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("checks")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
compiler.arguments = ["swiftc", "-parse-as-library", generated.path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let checks = Process()
checks.executableURL = binary
try checks.run()
checks.waitUntilExit()
exit(checks.terminationStatus)
