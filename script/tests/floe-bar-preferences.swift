import Foundation

// 编译生产偏好和几何，使用内存存储验证升级兼容、分区覆盖和固定位置，不写用户偏好。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBarPreferences.swift"), encoding: .utf8)
    .replacingOccurrences(of: "UserDefaults.standard", with: "MemoryDefaults.standard")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-bar-prefs-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
final class MemoryDefaults {
    static let standard = MemoryDefaults()
    var value: Data?
    func data(forKey: String) -> Data? { value }
    func set(_ data: Data, forKey: String) { value = data }
}
__PRODUCTION__
@main struct Checks {
    @MainActor static func main() {
        let preferences = FloeBarPreferences()
        for legacy in [false, true] {
            for section in ["hidden", "alwaysHidden"] { precondition(preferences.usesFloating(section: section, legacy: legacy) == legacy) }
        }
        preferences.setPresentation(.native, for: "hidden")
        preferences.setPresentation(.floating, for: "alwaysHidden")
        for legacy in [false, true] {
            precondition(!preferences.usesFloating(section: "hidden", legacy: legacy))
            precondition(preferences.usesFloating(section: "alwaysHidden", legacy: legacy))
        }
        preferences.layout = .grid; preferences.columns = 100; precondition(preferences.columns == 12)
        preferences.columns = -1; precondition(preferences.columns == 2)
        let bounds = CGRect(x: -1920, y: 37, width: 1920, height: 1040)
        let size = CGSize(width: 320, height: 200)
        preferences.pin(origin: CGPoint(x: -1120, y: 457), size: size, bounds: bounds, display: "left")
        let restored = FloeBarPreferences()
        precondition(restored.layout == .grid && restored.columns == 2)
        precondition(restored.fixedOrigin(size: size, bounds: bounds, display: "left") == CGPoint(x: -1120, y: 457))
        let smaller = CGRect(x: 1728, y: 0, width: 800, height: 600)
        precondition(restored.fixedOrigin(size: size, bounds: smaller, display: "left") == CGPoint(x: 1968, y: 200))
        precondition(restored.fixedOrigin(size: size, bounds: smaller, display: "new-display") == CGPoint(x: 2208, y: 400))
        precondition(restored.fixedOrigin(size: CGSize(width: 2000, height: 2000), bounds: smaller, display: "left") == smaller.origin)
        var invalid = FloeBarPreferences.RelativePosition(origin: .zero, size: .zero, bounds: bounds)
        invalid.x = .nan; invalid.y = .infinity
        precondition(invalid.origin(size: size, bounds: smaller) == CGPoint(x: 2208, y: 400))
        restored.fixedPosition = false
        precondition(restored.fixedOrigin(size: size, bounds: bounds, display: "left") == nil)
        precondition(!FloeBarPreferences().fixedPosition)
        print("PASS: production Floe Bar preferences preserve legacy behavior, isolate sections, clamp grid settings and restore per-display relative positions across negative coordinates/resizing/missing displays")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: source).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
