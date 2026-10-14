import Foundation

// 编译生产浮栏高度 getter，覆盖低分辨率刘海屏的内缩裁切边界。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
let start = source.range(of: "    private var contentHeight:")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-content-height-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = """
import Foundation
struct Screen { var height: CGFloat?; var hasNotch = true; func getMenuBarHeight() -> CGFloat? { height } }
struct Configuration { enum Shape { case none, split }; var shapeKind = Shape.split; var isInset = true }
struct Appearance { var menuBarInsetAmount: CGFloat = 5 }
struct AppState { var appearanceManager = Appearance() }
struct Cache { var menuBarHeight: CGFloat? = nil }
enum NSStatusBar { static let system = Bar(); struct Bar { let thickness: CGFloat = 22 } }
struct View {
    var screen = Screen(height: 32), imageCache = Cache(), configuration = Configuration(), appState = AppState()
    \(String(source[start..<end]).replacingOccurrences(of: "private var", with: "var"))
}
var view = View()
for height: CGFloat in [12,20,24,32,40] {
    view.screen.height = height
    precondition(view.contentHeight! >= 22)
}
view.screen.height = 40; precondition(view.contentHeight == 30)
view.configuration.isInset = false; precondition(view.contentHeight == 40)
view.screen.height = nil; precondition(view.contentHeight == nil)
print("PASS: production inset Floe Bar preserves full icon height on scaled notch displays and retains ordinary/unavailable height semantics")
"""
let file = directory.appendingPathComponent("main.swift")
try fixture.write(to: file, atomically: true, encoding: .utf8)
let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = ["swift", file.path]
try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
