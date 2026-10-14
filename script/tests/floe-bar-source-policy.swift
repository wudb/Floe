import Foundation

// 编译生产浮栏来源选择，验证自动隐藏/跨屏/截图失败时可进入 AX 路径。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
let start = source.range(of: "    private var usesAXFallback:")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end]).replacingOccurrences(of: "private var", with: "var")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-source-policy-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = """
import Foundation
struct Screen { let displayID: Int }
final class ItemManager { var isItemDiscoveryUnavailable = false }
final class Bar { var isMenuBarHiddenBySystemUserDefaults = false }
final class Cache { var failed = false; var screen: Screen? = Screen(displayID: 1); func cacheFailed(for: Int) -> Bool { failed } }
enum MenuBarItemAXDiscovery { static var trusted = true; static func isTrusted() -> Bool { trusted } }
struct View {
    let itemManager = ItemManager(), menuBarManager = Bar(), imageCache = Cache()
    var screen = Screen(displayID: 1), section = 1
    \(method)
}
var view = View()
precondition(!view.usesAXFallback)
view.screen = Screen(displayID: 2); precondition(view.usesAXFallback)
view.screen = Screen(displayID: 1); view.imageCache.failed = true; precondition(view.usesAXFallback)
view.imageCache.failed = false; view.menuBarManager.isMenuBarHiddenBySystemUserDefaults = true; precondition(view.usesAXFallback)
view.menuBarManager.isMenuBarHiddenBySystemUserDefaults = false; MenuBarItemAXDiscovery.trusted = false
view.imageCache.failed = true; precondition(!view.usesAXFallback)
view.itemManager.isItemDiscoveryUnavailable = true; precondition(view.usesAXFallback)
print("PASS: production source policy preserves CGS when valid, falls back for trusted cross-screen/failed capture and supports auto-hide/no-discovery AX permission flow")
"""
let file = directory.appendingPathComponent("main.swift")
try fixture.write(to: file, atomically: true, encoding: .utf8)
let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = ["swift", file.path]
try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
