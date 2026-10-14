import Foundation

// 编译生产外部点击处理，验证吸管会话和普通外部点击关闭行为。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/Appearance/MenuBarAppearanceEditor/MenuBarAppearanceEditorPanel.swift"), encoding: .utf8)
let start = source.range(of: "    private(set) lazy var mouseDownMonitor")!.lowerBound
let end = source.range(of: "\n    @ViewBuilder", range: start..<source.endIndex)!.lowerBound
let handler = String(source[start..<end])
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-eyedropper-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
final class NSColorPanel { static let shared = NSColorPanel(); var isVisible = false }
final class GlobalEventMonitor {
    enum Mask { case leftMouseDown }
    let handler: (Int) -> Void
    init(mask: Mask, handler: @escaping (Int) -> Void) { self.handler = handler }
}
final class Popover {
    var closes = 0
    func performClose(_ sender: Any?) { closes += 1 }
    __PRODUCTION__
}
let popover = Popover()
NSColorPanel.shared.isVisible = true
popover.mouseDownMonitor.handler(0); precondition(popover.closes == 0)
NSColorPanel.shared.isVisible = false
popover.mouseDownMonitor.handler(0); precondition(popover.closes == 1)
NSColorPanel.shared.isVisible = true
popover.mouseDownMonitor.handler(0); precondition(popover.closes == 1)
print("PASS: production external click preserves active color-panel/eyedropper session and closes ordinary popover")
"""#
let file = directory.appendingPathComponent("main.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: handler).write(to: file, atomically: true, encoding: .utf8)
let runner = Process(); runner.executableURL = URL(fileURLWithPath: "/usr/bin/env"); runner.arguments = ["swift", file.path]
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
