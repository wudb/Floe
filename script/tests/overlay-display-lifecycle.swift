import Foundation

// 编译生产 show/validate，验证全屏、系统隐藏、断屏和无菜单栏时不显示旧外观。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/Appearance/MenuBarOverlayPanel.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let methods = [method("    private func validate(for kind:"), method("    private func show()")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-overlay-lifecycle-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
typealias CGDirectDisplayID = UInt32
struct NSScreen {
    static var screens = [NSScreen(displayID: 1)]
    let displayID: UInt32
    var frame: CGRect { CGRect(x: 0, y: 0, width: 1000, height: 800) }
    func getMenuBarHeight() -> CGFloat? { 24 }
}
struct WindowInfo {
    var windowID: UInt32 = 10
    static func getOnScreenWindows() -> [WindowInfo] { [] }
    static func getMenuBarWindow(for: UInt32) -> WindowInfo? { WindowInfo() }
}
final class Bar {
    var isMenuBarHiddenBySystemUserDefaults = false, isMenuBarHiddenBySystem = false, valid = true
    func hasValidMenuBar(in: [WindowInfo], for: UInt32) -> Bool { valid }
}
final class Appearance { var overlayPanels = Set<Panel>() }
final class AppState {
    var isActiveSpaceFullscreen = false, isPreview = false
    let menuBarManager = Bar(), appearanceManager = Appearance()
}
struct Logger {
    static let overlayPanel = Logger()
    func debug(_ message: String) {}
    func warning(_ message: String) {}
}
final class Panel: NSObject {
    enum ValidationKind { case showing, updates }
    enum UpdateFlag { case applicationMenuFrame }
    var appState: AppState? = AppState()
    let owningScreen = NSScreen(displayID: 1)
    var hasLoggedMissingMenuBar = false
    var alphaValue = 0.0, fronts = 0, outs = 0
    var updateFlags = Set<UpdateFlag>()
    func orderOut(_ sender: Any?) { outs += 1 }
    func orderFrontRegardless() { fronts += 1 }
    func setFrame(_ frame: CGRect, display: Bool) {}
    enum Ordering { case above }
    func order(_ position: Ordering, relativeTo: Int) {}
    __PRODUCTION__
}
let panel = Panel(), state = panel.appState!
state.appearanceManager.overlayPanels.insert(panel)
panel.show(); precondition(panel.fronts == 1)
state.isActiveSpaceFullscreen = true
panel.show(); precondition(panel.fronts == 1 && panel.outs == 1)
state.isActiveSpaceFullscreen = false
state.menuBarManager.isMenuBarHiddenBySystemUserDefaults = true
panel.show(); precondition(panel.fronts == 1 && panel.outs == 2)
state.menuBarManager.isMenuBarHiddenBySystemUserDefaults = false
state.menuBarManager.valid = false
panel.show(); precondition(panel.fronts == 1 && panel.outs == 3)
state.menuBarManager.valid = true
NSScreen.screens = []
panel.show(); precondition(panel.fronts == 1 && panel.outs == 4)
NSScreen.screens = [NSScreen(displayID: 1)]
panel.show(); precondition(panel.fronts == 2)
print("PASS: production overlay show validates fullscreen, auto-hide, real menu bar and attached display before ordering; valid recovery shows again")
"""#
let file = directory.appendingPathComponent("main.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = ["swift", file.path]
try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
