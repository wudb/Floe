//
//  ax-item-press.swift
//  Floe
//

// Executes production AX discovery/press logic against an in-memory Accessibility tree.
// No UI actions, privacy grants, or running Floe app are needed.
import Foundation

let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent().path
var source = try String(contentsOfFile: repo + "/Floe/MenuBar/MenuBarItems/MenuBarItemAXDiscovery.swift", encoding: .utf8)
// Replace only the OS boundary; discovery, item identity, and press selection remain production code.
for name in ["AXUIElement", "NSRunningApplication", "AXIsProcessTrusted", "AXUIElementGetTypeID", "AXUIElementGetPid",
             "AXUIElementCreateApplication", "AXUIElementCreateSystemWide", "AXUIElementCopyElementAtPosition", "AXUIElementSetMessagingTimeout",
             "AXUIElementCopyAttributeValue", "AXUIElementPerformAction"] {
    source = source.replacingOccurrences(of: "\\b" + name + "\\b", with: "Fixture" + name, options: .regularExpression)
}
let fixtures = #"""
import Cocoa
import ApplicationServices
final class FixtureAXUIElement: NSObject {
    var attributes: [String: AnyObject]
    var actionResult = AXError.success
    var ownerPID: pid_t = 42
    var attributeDelay: TimeInterval = 0
    init(_ role: String, title: String? = nil, identifier: String? = nil, children: [FixtureAXUIElement] = []) {
        attributes = [kAXRoleAttribute: role as NSString, kAXChildrenAttribute: children as NSArray]
        attributes[kAXTitleAttribute] = title as NSString?
        attributes["AXIdentifier"] = identifier as NSString?
    }
}
struct FixtureNSRunningApplication {
    let processIdentifier: pid_t
    let bundleIdentifier: String?
    init(processIdentifier: pid_t = 42, bundleIdentifier: String? = "com.apple.controlcenter") {
        self.processIdentifier = processIdentifier
        self.bundleIdentifier = bundleIdentifier
    }
    let localizedName: String? = "Control Center"
    static let current = FixtureNSRunningApplication()
    static func runningApplications(withBundleIdentifier id: String) -> [Self] { [] }
}
var trusted = true
var application = FixtureAXUIElement("AXApplication")
var pressed: [FixtureAXUIElement] = []
var hitTarget = FixtureAXUIElement("AXButton")
var applications: [pid_t: FixtureAXUIElement] = [:]
func FixtureAXIsProcessTrusted() -> Bool { trusted }
func FixtureAXUIElementGetTypeID() -> CFTypeID { CFGetTypeID(application) }
func FixtureAXUIElementGetPid(_ element: FixtureAXUIElement, _ pid: UnsafeMutablePointer<pid_t>) -> AXError {
    pid.pointee = element.ownerPID
    return .success
}
func FixtureAXUIElementCreateApplication(_ pid: pid_t) -> FixtureAXUIElement { applications[pid] ?? application }
func FixtureAXUIElementCreateSystemWide() -> FixtureAXUIElement { application }
func FixtureAXUIElementCopyElementAtPosition(_ element: FixtureAXUIElement, _ x: Float, _ y: Float, _ target: UnsafeMutablePointer<FixtureAXUIElement?>) -> AXError {
    target.pointee = hitTarget
    return .success
}
@discardableResult
func FixtureAXUIElementSetMessagingTimeout(_ element: FixtureAXUIElement, _ timeout: Float) -> AXError { .success }
func FixtureAXUIElementCopyAttributeValue(_ element: FixtureAXUIElement, _ attribute: CFString, _ value: UnsafeMutablePointer<AnyObject?>) -> AXError {
    if element.attributeDelay > 0 { Thread.sleep(forTimeInterval: element.attributeDelay) }
    value.pointee = element.attributes[attribute as String]
    return value.pointee == nil ? .noValue : .success
}
func FixtureAXUIElementPerformAction(_ element: FixtureAXUIElement, _ action: CFString) -> AXError {
    precondition(action as String == kAXPressAction)
    pressed.append(element)
    if let identifier = element.attributes["AXIdentifier"] as? String,
       identifier == "menu-bar-overflow-indicator" || identifier == "menu-bar-overflow-indicator-expanded" {
        element.attributes["AXIdentifier"] = (identifier == "menu-bar-overflow-indicator" ? "menu-bar-overflow-indicator-expanded" : "menu-bar-overflow-indicator") as NSString
    }
    return element.actionResult
}
"""#
let tests = #"""
trusted = true
let complexApp = FixtureAXUIElement("AXApplication")
complexApp.attributes["AXExtrasMenuBar"] = FixtureAXUIElement("AXMenuBar", children: (0..<300).map {
    FixtureAXUIElement("AXMenuBarItem", title: "Complex \($0)")
})
let laterApp = FixtureAXUIElement("AXApplication")
laterApp.attributes["AXExtrasMenuBar"] = FixtureAXUIElement("AXMenuBar", children: [FixtureAXUIElement("AXMenuBarItem", title: "Later App")])
applications = [42: complexApp, 43: laterApp]
let fair = MenuBarItemAXDiscovery.discoverItems(in: [FixtureNSRunningApplication(processIdentifier: 42), FixtureNSRunningApplication(processIdentifier: 43)])
precondition(fair.contains { $0.title == "Later App" }, "one host must not consume later applications' traversal budgets")
precondition(fair.filter { $0.pid == 42 }.count <= 256)
let slowApp = FixtureAXUIElement("AXApplication")
let slowNodes = (0..<30).map { index -> FixtureAXUIElement in
    let node = FixtureAXUIElement("AXMenuBarItem", title: "Slow \(index)")
    node.attributeDelay = 0.1
    return node
}
slowApp.attributes["AXExtrasMenuBar"] = FixtureAXUIElement("AXMenuBar", children: slowNodes)
applications = [42: slowApp, 43: laterApp]
let deadlineStart = Date()
let timed = MenuBarItemAXDiscovery.discoverItems(in: [FixtureNSRunningApplication(processIdentifier: 42), FixtureNSRunningApplication(processIdentifier: 43)])
precondition(timed.contains { $0.title == "Later App" })
precondition(timed.filter { $0.pid == 42 }.count < 30 && Date().timeIntervalSince(deadlineStart) < 3)
let wrappers = (0..<30).map { _ -> FixtureAXUIElement in
    let node = FixtureAXUIElement("AXGroup")
    node.attributeDelay = 0.1
    return node
}
slowApp.attributes["AXExtrasMenuBar"] = FixtureAXUIElement("AXMenuBar", title: "Truncated root", children: wrappers)
applications = [42: slowApp, 43: laterApp]
let truncated = MenuBarItemAXDiscovery.discoverItems(in: [FixtureNSRunningApplication(processIdentifier: 42), FixtureNSRunningApplication(processIdentifier: 43)])
precondition(!truncated.contains { $0.title == "Truncated root" })
precondition(truncated.contains { $0.title == "Later App" })
applications = [:]
print("PASS: production AX discovery isolates node/time budgets and never turns a truncated root into an icon")
let asset = FixtureAXUIElement("AXImage", title: "rounded_menu_asset")
let button = FixtureAXUIElement("AXButton", title: "Status button", children: [asset])
application.attributes["AXExtrasMenuBar"] = FixtureAXUIElement("AXMenuBar", children: [button])
let buttonItems = MenuBarItemAXDiscovery.discoverItems(in: [.current])
precondition(buttonItems.count == 1 && buttonItems[0].title == "Status button")
precondition(buttonItems[0].element == button)
print("PASS: AX status button retains its actionable wrapper and excludes image resource names")
let ownControls = ["FloeIcon", "FloeHiddenDivider", "FloeAlwaysHiddenDivider"].map {
    FixtureAXUIElement("AXButton", title: "Floe", identifier: $0)
}
let clock = FixtureAXUIElement("AXMenuBarItem", title: "Clock", identifier: "com.apple.menuextra.clock")
let wifi = FixtureAXUIElement("AXMenuBarItem", title: "Wi-Fi", identifier: "com.apple.menuextra.wifi")
let audio = FixtureAXUIElement("AXMenuBarItem", title: "Audio", identifier: "com.apple.menuextra.audiovideo")
application.attributes["AXExtrasMenuBar"] = FixtureAXUIElement("AXMenuBar", children: ownControls + [clock, wifi, audio])
let protectedItems = MenuBarItemAXDiscovery.discoverItems(in: [.current])
precondition(protectedItems.count == 3, "Floe controls proxied by MenuBarAgent are not third-party layout entries")
let clockItem = protectedItems.first { $0.identifier == "com.apple.menuextra.clock" }!
let wifiItem = protectedItems.first { $0.identifier == "com.apple.menuextra.wifi" }!
let audioItem = protectedItems.first { $0.identifier == "com.apple.menuextra.audiovideo" }!
precondition(!clockItem.isMovable && !clockItem.canBeHidden)
precondition(wifiItem.isMovable && wifiItem.canBeHidden)
precondition(audioItem.isMovable && !audioItem.canBeHidden)
print("PASS: MenuBarAgent system protection flags exclude own controls while keeping Wi-Fi available")
let vpnIcon = MenuBarItemAXDiscovery.systemIconImage(forIdentifier: "com.apple.menuextra.vpn", title: nil, bundleID: nil)
let vpnSymbol = MenuBarItemAXDiscovery.systemImageName(forIdentifier: "com.apple.menuextra.vpn")
if let vpnIcon {
    precondition(vpnIcon.isTemplate && vpnIcon.size == NSSize(width: 18, height: 14))
    precondition(vpnSymbol == nil, "the native VPN glyph must take precedence over a substitute symbol")
} else {
    precondition(vpnSymbol.flatMap { NSImage(systemSymbolName: $0, accessibilityDescription: nil) } != nil)
}
for host in ["com.apple.MenuBarAgent", "com.apple.systemuiserver", "com.apple.controlcenter"] {
    let vpn = MenuBarItemAXDiscovery.AXMenuBarItem(element: FixtureAXUIElement("AXMenuBarItem"), pid: 42, appName: "System host", bundleID: host, identifier: nil, title: "VPN", axFrame: nil)
    precondition(MenuBarItemAXDiscovery.systemImageName(for: vpn) == vpnSymbol)
    precondition(MenuBarItemAXDiscovery.systemImageName(forTitle: "VPN", bundleID: host) == vpnSymbol)
    let resolvedIcon = MenuBarItemAXDiscovery.systemIconImage(forIdentifier: nil, title: "VPN", bundleID: host)
    precondition(resolvedIcon === vpnIcon)
}
precondition(MenuBarItemAXDiscovery.systemIconImage(forIdentifier: nil, title: "VPN", bundleID: "net.openvpn.connect.app") == nil)
precondition(MenuBarItemAXDiscovery.systemImageName(forTitle: "VPN", bundleID: "net.openvpn.connect.app") == nil)
precondition(MenuBarItemAXDiscovery.systemImageName(forTitle: "VPN", bundleID: nil) == nil)
precondition(MenuBarItemAXDiscovery.systemImageName(forTitle: "OpenVPN Connect", bundleID: "net.openvpn.connect.app") == nil)
print("PASS: system VPN uses the native macOS template glyph with and without AXIdentifier, third-party VPN app icons are preserved")
let overflow = FixtureAXUIElement("AXButton", title: "Localized overflow")
let namedOverflow = FixtureAXUIElement("AXButton", title: "显示隐藏菜单栏项目")
let vpnTarget = FixtureAXUIElement("AXMenuBarItem", title: "VPN")
let proxyBar = FixtureAXUIElement("AXMenuBar", children: [overflow, namedOverflow, vpnTarget])
proxyBar.attributes["AXOverflowButton"] = overflow
let proxyApp = FixtureAXUIElement("AXApplication")
proxyApp.attributes["AXExtrasMenuBar"] = proxyBar
applications = [45: proxyApp]
let proxyItems = MenuBarItemAXDiscovery.discoverItems(in: [.init(processIdentifier: 45, bundleIdentifier: "com.apple.MenuBarAgent")])
precondition(proxyItems.count == 1 && proxyItems[0].element === vpnTarget)
let legacy = FixtureAXUIElement("AXButton", title: "Legacy icon")
legacy.ownerPID = 63
let proxyWindow = FixtureAXUIElement("AXWindow", children: [FixtureAXUIElement("AXGroup", children: [legacy, vpnTarget, overflow])])
var windowOrigin = CGPoint.zero
var windowSize = CGSize(width: 1440, height: 33)
proxyWindow.attributes[kAXPositionAttribute] = AXValueCreate(.cgPoint, &windowOrigin)
proxyWindow.attributes[kAXSizeAttribute] = AXValueCreate(.cgSize, &windowSize)
proxyApp.attributes[kAXWindowsAttribute] = [proxyWindow] as NSArray
let windowItems = MenuBarItemAXDiscovery.discoverItems(in: [.init(processIdentifier: 45, bundleIdentifier: "com.apple.MenuBarAgent")])
precondition(windowItems.filter { $0.element === vpnTarget }.count == 1)
precondition(windowItems.filter { $0.element === legacy }.count == 1)
precondition(windowItems.first { $0.element === legacy }?.pid == 63)
precondition(!windowItems.contains { $0.element === overflow })
print("PASS: shared menu bar window supplies missing legacy icons, keeps source PID and deduplicates exact extras targets")
func setFrame(_ frame: CGRect, on element: FixtureAXUIElement) {
    var origin = frame.origin, size = frame.size
    element.attributes[kAXPositionAttribute] = AXValueCreate(.cgPoint, &origin)
    element.attributes[kAXSizeAttribute] = AXValueCreate(.cgSize, &size)
}
let original = FixtureAXUIElement("AXButton", title: "Original icon")
setFrame(CGRect(x: 108, y: 5, width: 24, height: 24), on: original)
setFrame(CGRect(x: 101, y: 0, width: 38, height: 34), on: legacy)
let sibling = FixtureAXUIElement("AXButton", title: "Original icon")
sibling.ownerPID = 63
setFrame(CGRect(x: 201, y: 0, width: 38, height: 34), on: sibling)
proxyWindow.attributes[kAXChildrenAttribute] = [legacy, sibling, vpnTarget, overflow] as NSArray
let originalApp = FixtureAXUIElement("AXApplication")
originalApp.attributes["AXExtrasMenuBar"] = FixtureAXUIElement("AXMenuBar", children: [original])
applications[63] = originalApp
let combined = MenuBarItemAXDiscovery.discoverItems(in: [
    .init(processIdentifier: 45, bundleIdentifier: "com.apple.MenuBarAgent"),
    .init(processIdentifier: 63, bundleIdentifier: "example.owner"),
])
precondition(combined.contains { $0.element === original })
precondition(!combined.contains { $0.element === legacy })
precondition(combined.contains { $0.element === sibling }, "same-owner adjacent icons must remain separate")
let popupOnly = FixtureAXUIElement("AXButton", title: "Popup content")
let popup = FixtureAXUIElement("AXWindow", children: [popupOnly])
setFrame(CGRect(x: 0, y: 33, width: 400, height: 300), on: popup)
proxyApp.attributes[kAXWindowsAttribute] = [proxyWindow, popup] as NSArray
let withPopup = MenuBarItemAXDiscovery.discoverItems(in: [.init(processIdentifier: 45, bundleIdentifier: "com.apple.MenuBarAgent")])
precondition(!withPopup.contains { $0.element === popupOnly })
print("PASS: source/proxy geometry prevents duplicate rows, distinct same-owner icons survive and popup content is excluded")
overflow.attributes["AXIdentifier"] = "menu-bar-overflow-indicator" as NSString
precondition(MenuBarItemAXDiscovery.setOverflowExpanded(true, in: [.init(processIdentifier: 45, bundleIdentifier: "com.apple.MenuBarAgent")]))
precondition(!MenuBarItemAXDiscovery.setOverflowExpanded(true, in: [.init(processIdentifier: 45, bundleIdentifier: "com.apple.MenuBarAgent")]))
precondition(MenuBarItemAXDiscovery.setOverflowExpanded(false, in: [.init(processIdentifier: 45, bundleIdentifier: "com.apple.MenuBarAgent")]))
let hitItem = MenuBarItemAXDiscovery.AXMenuBarItem(element: original, pid: 63, appName: "Owner", bundleID: "example.owner", identifier: nil, title: nil, axFrame: nil)
MainActor.assumeIsolated {
    hitTarget = original
    precondition(MenuBarItemAXDiscovery.isItemAtPosition(hitItem, point: .zero))
    hitTarget = FixtureAXUIElement("AXButton")
    hitTarget.ownerPID = 99
    precondition(!MenuBarItemAXDiscovery.isItemAtPosition(hitItem, point: .zero))
}
print("PASS: overflow changes are owned and idempotent, dragging rejects a different application's hit target")
applications = [:]
print("PASS: native overflow controls are excluded by exact AX identity and scoped localized fallback, VPN remains listed")
var failures = 0
func check(_ name: String, title: String? = nil, identifier: String? = nil, changedTitle: Bool = false,
           stale: Bool = false, permission: Bool = true) {
    trusted = true
    pressed = []
    let battery = FixtureAXUIElement("AXMenuBarItem", title: title, identifier: identifier)
    let selected = FixtureAXUIElement("AXMenuBarItem", title: title, identifier: identifier)
    let bar = FixtureAXUIElement("AXMenuBar", children: [battery, selected])
    application.attributes["AXExtrasMenuBar"] = bar
    let items = MenuBarItemAXDiscovery.discoverItems(in: [.current])
    precondition(items.count == 2)
    let item = items[1]
    if changedTitle { selected.attributes[kAXTitleAttribute] = "Updated status" as NSString }
    if stale {
        selected.actionResult = .invalidUIElement
        bar.attributes[kAXChildrenAttribute] = [battery] as NSArray
    }
    trusted = permission
    let succeeded = MenuBarItemAXDiscovery.press(item)
    let expectedTargets = permission ? [selected] : []
    let passed = pressed == expectedTargets && succeeded == (permission && !stale)
    print("\(passed ? "PASS" : "FAIL"): \(name) (pressedBattery=\(pressed.contains(battery)))")
    if !passed { failures += 1 }
}
check("anonymous sibling presses the selected item")
check("duplicate titles preserve selection", title: "Control Center")
check("duplicate identifiers preserve selection", identifier: "com.apple.menuextra.shared")
check("title changes after discovery preserve selection", title: "Status", changedTitle: true)
check("stale selection never falls back to battery", stale: true)
check("denied Accessibility permission performs no action", permission: false)
exit(failures == 0 ? 0 : 1)
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-ax-regression-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
let generated = directory.appendingPathComponent("ax-test-generated.swift")
try (fixtures + "\n" + source + "\n" + tests).write(to: generated, atomically: true, encoding: .utf8)
let runner = Process()
runner.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
runner.arguments = [generated.path]
try runner.run()
runner.waitUntilExit()
let status = runner.terminationStatus
try FileManager.default.removeItem(at: directory)
exit(status)
