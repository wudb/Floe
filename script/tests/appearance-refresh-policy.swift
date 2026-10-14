import Foundation

// 编译生产刷新门禁，比较可见/隐藏面板的周期工作次数，不将它当作能耗测量。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/Appearance/MenuBarOverlayPanel.swift"), encoding: .utf8)
let start = source.range(of: "    private var shouldRefreshVisibleChrome:")!.lowerBound
let end = source.range(of: "    private func startTrailingEaseIfNeeded()", range: start..<source.endIndex)!.lowerBound
let policy = String(source[start..<end]).replacingOccurrences(of: "private var", with: "var")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-refresh-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
final class Panel { var isVisible = false; var alphaValue = 1.0 }
enum Shape { case split, full, none }
struct Config { var shapeKind = Shape.split }
final class Content {
    var overlayPanel: Panel? = Panel()
    var fullConfiguration = Config()
    __PRODUCTION__
}
let content = Content(), panel = content.overlayPanel!
func counts() -> (Int, Int) {
    var redraws = 0, probes = 0
    for tick in 0..<240 {
        if tick % 8 == 0, content.shouldRefreshVisibleChrome { redraws += 1 }
        if content.shouldScanTrailingEdge { probes += 1 }
    }
    return (redraws, probes)
}
precondition(counts() == (0, 0))
panel.isVisible = true; precondition(counts() == (30, 240))
content.fullConfiguration.shapeKind = .full; precondition(counts() == (30, 0))
content.fullConfiguration.shapeKind = .none; precondition(counts() == (30, 0))
content.fullConfiguration.shapeKind = .split; panel.alphaValue = 0; precondition(counts() == (0, 0))
content.overlayPanel = nil; precondition(counts() == (0, 0))
print("PASS: production chrome gating skips hidden/transparent/detached work and limits AX edge probes to split shape (60s synthetic ticks)")
"""#
let file = directory.appendingPathComponent("main.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: policy).write(to: file, atomically: true, encoding: .utf8)
let runner = Process(); runner.executableURL = URL(fileURLWithPath: "/usr/bin/env"); runner.arguments = ["swift", file.path]
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
