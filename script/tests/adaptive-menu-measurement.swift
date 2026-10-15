import Foundation

// 执行生产 AX 菜单测量，验证过期预算、慢宿主和异常子项不会让自动刷新无限等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarManager.swift"), encoding: .utf8)
func member(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
        .replacingOccurrences(of: "CGDisplayBounds", with: "TestDisplayBounds")
}
let methods = [member("    private func menuBarElement("), member("    func getApplicationMenuFrame(")].joined(separator: "\n")
let fixture = #"""
import Foundation
import CoreGraphics
enum Attribute { case children, enabled, frame }
enum Role { case menuBar }
enum Failure: Error { case timeout }
final class Node {
    var timeout: Float = 9
    var delay: Double = 0
    var children = [UIElement]()
    var frame = CGRect(x: 0, y: 0, width: 100, height: 24)
    var enabled = true
    var reads = 0
    func read() throws {
        reads += 1
        if delay > 0 {
            Thread.sleep(forTimeInterval: min(delay, Double(timeout)))
            if delay > Double(timeout) { throw Failure.timeout }
        }
    }
}
let menu = Node()
final class UIElement {
    let element: Node
    init(_ node: Node) { element = node }
    func elementAtPosition(_ x: Float, _ y: Float) throws -> UIElement? { try element.read(); return UIElement(menu) }
    func role() throws -> Role? { try element.read(); return .menuBar }
    func arrayAttribute<T>(_ attribute: Attribute) throws -> [T]? { try element.read(); return element.children as? [T] }
    func attribute<T>(_ attribute: Attribute) throws -> T? {
        try element.read()
        switch attribute {
        case .enabled: return element.enabled as? T
        case .frame: return element.frame as? T
        case .children: return nil
        }
    }
}
func SystemWideElement(_ node: Node) -> UIElement { UIElement(node) }
let systemWideElement = UIElement(Node())
func AXUIElementCreateSystemWide() -> Node { Node() }
@discardableResult func AXUIElementSetMessagingTimeout(_ element: Node, _ timeout: Float) -> Int { element.timeout = timeout; return 0 }
func TestDisplayBounds(_ id: UInt32) -> CGRect { CGRect(x: 0, y: 0, width: 1000, height: 800) }
struct NSScreen: Equatable {
    static let screens = [NSScreen(displayID: 1)]
    static var main: NSScreen? { screens.first }
    let displayID: UInt32
    let hasNotch = false
    var auxiliaryTopLeftArea: CGRect? { nil }
}
struct Manager {
__PRODUCTION__
}
let manager = Manager()
let first = Node(), second = Node()
second.frame.origin.x = 100
menu.children = [UIElement(first), UIElement(second)]
precondition(manager.getApplicationMenuFrame(for: 1)?.width == 200)
precondition(manager.getApplicationMenuFrame(for: 1, deadline: Date().addingTimeInterval(0.15))?.width == 200)
precondition(systemWideElement.element.timeout == 9, "bounded probe must not change global AX timeout")
let reads = menu.reads
precondition(manager.getApplicationMenuFrame(for: 1, deadline: .distantPast) == nil && menu.reads == reads)
second.delay = 1
let start = Date()
precondition(manager.getApplicationMenuFrame(for: 1, deadline: Date().addingTimeInterval(0.15)) == nil)
precondition(Date().timeIntervalSince(start) < 0.5, "slow item must respect short per-message timeout")
second.delay = 0
menu.children = Array(repeating: UIElement(first), count: 129)
precondition(manager.getApplicationMenuFrame(for: 1, deadline: Date().addingTimeInterval(0.15)) == nil)
precondition(manager.getApplicationMenuFrame(for: 1)?.width == 100, "legacy unbounded path must retain its behavior")
print("PASS: production adaptive AX measurement rejects expired/oversized snapshots, bounds a slow host, preserves complete geometry and leaves global AX timeout unchanged")
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-adaptive-menu-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
let runner = Process(); runner.executableURL = URL(fileURLWithPath: "/usr/bin/env"); runner.arguments = ["swift", file.path]
try runner.run(); runner.waitUntilExit(); exit(runner.terminationStatus)
