import Foundation

// 编译生产规则与持久化，覆盖优先级、组合范围、测量失败和临界宽度滞回，不读取用户偏好。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let policy = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/AdaptivePresentationPolicy.swift"), encoding: .utf8)
let preferences = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/AdaptivePresentationPreferences.swift"), encoding: .utf8)
    .replacingOccurrences(of: "UserDefaults.standard", with: "MemoryDefaults.standard")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-adaptive-\(UUID().uuidString)")
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
__POLICY__
__PREFERENCES__
@main struct Checks {
    @MainActor static func main() {
        typealias P = AdaptivePresentationPolicy
        var rules = P.Rules()
        var context = P.Context(builtIn: true, notched: true, displayCount: 1, fullscreen: false, autoHiddenMenuBar: false, availableWidth: 500, requiredWidth: 400)
        func decide(_ previous: P.Decision? = nil, override: P.Override = .automatic) -> P.Decision {
            P.resolve(context, rules: rules, override: override, previous: previous)
        }
        precondition(decide() == .native)
        context.availableWidth = 423
        precondition(decide() == .floating)
        context.availableWidth = 450
        precondition(decide(.floating) == .floating && decide(.native) == .native)
        context.availableWidth = 472
        precondition(decide(.floating) == .native)
        for invalid: Double? in [nil, .nan, .infinity, -1] {
            context.availableWidth = invalid
            precondition(decide() == .floating && decide(override: .native) == .native)
        }
        context.availableWidth = 500
        for invalid: Double? in [nil, .nan, .infinity, -1] {
            context.requiredWidth = invalid
            precondition(decide() == .floating)
        }
        context.requiredWidth = 400
        context.autoHiddenMenuBar = true; precondition(decide() == .floating)
        context.autoHiddenMenuBar = false
        rules.onlyWhenCrowded = false
        for display in P.DisplayRule.allCases {
            rules.display = display
            for count in P.CountRule.allCases {
                rules.count = count
                for builtIn in [false, true] {
                    for notched in [false, true] {
                        for connected in [1, 2, 3] {
                            context.builtIn = builtIn; context.notched = notched; context.displayCount = connected
                            let matchDisplay = display == .all || display == .builtIn && builtIn || display == .external && !builtIn || display == .notched && notched
                            let matchCount = count == .any || count == .single && connected == 1 || count == .multiple && connected > 1
                            precondition(decide() == (matchDisplay && matchCount ? .floating : .native))
                            precondition(decide(override: .floating) == .floating && decide(override: .native) == .native)
                        }
                    }
                }
            }
        }
        context.fullscreen = true
        for fullscreen in P.FullscreenRule.allCases {
            rules.fullscreen = fullscreen
            if fullscreen != .followRules {
                let expected: P.Decision = fullscreen == .native ? .native : fullscreen == .floating ? .floating : .disabled
                precondition(decide() == expected)
            }
            precondition(decide(override: .native) == .native && decide(override: .floating) == .floating)
        }
        context.fullscreen = nil
        rules = P.Rules(); context.autoHiddenMenuBar = false; context.availableWidth = 500; context.requiredWidth = 480
        rules.reserveSpace = .nan; precondition(decide() == .floating)
        rules.reserveSpace = -10; precondition(decide() == .native)
        rules.reserveSpace = 1000; precondition(decide() == .floating)
        // Quartz 坐标：负 X、上下排列、刘海安全区、应用菜单与屏幕归属。
        let bounds = CGRect(x: -1920, y: -1080, width: 1920, height: 1080)
        let menu = CGRect(x: -1920, y: -1080, width: 420, height: 24)
        precondition(P.availableWidth(bounds: bounds, rightSafeArea: nil, applicationMenu: menu) == 1500)
        let safe = CGRect(x: -900, y: 0, width: 900, height: 37)
        precondition(P.availableWidth(bounds: bounds, rightSafeArea: safe, applicationMenu: menu) == 900)
        precondition(P.availableWidth(bounds: bounds, rightSafeArea: nil, applicationMenu: nil) == nil)
        precondition(P.availableWidth(bounds: bounds, rightSafeArea: safe, applicationMenu: nil) == nil)
        precondition(P.availableWidth(bounds: bounds, rightSafeArea: nil, applicationMenu: CGRect(x: -1920, y: 0, width: 420, height: 24)) == nil)
        let stored = AdaptivePresentationPreferences()
        stored.rules = rules; stored.setOverride(.floating, for: "display-A"); stored.setOverride(.native, for: "display-B")
        let restored = AdaptivePresentationPreferences()
        precondition(restored.rules == rules && restored.override(for: "display-A") == .floating && restored.override(for: "display-B") == .native)
        precondition(restored.override(for: "new-display") == .automatic)
        restored.setOverride(.automatic, for: "display-A")
        precondition(AdaptivePresentationPreferences().override(for: "display-A") == .automatic)
        MemoryDefaults.standard.value = Data("invalid".utf8)
        precondition(AdaptivePresentationPreferences().rules == P.Rules())
        print("PASS: adaptive policy scope matrix, fullscreen/display overrides, unknown measurements, hysteresis, negative/stacked display geometry and persistence")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__POLICY__", with: policy).replacingOccurrences(of: "__PREFERENCES__", with: preferences).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
