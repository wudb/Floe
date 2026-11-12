import Foundation

// 编译真实浮栏外观管理器，验证旧配置迁移、独立持久化及启动路径的绘制范围。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/Appearance/FloeBarAppearanceManager.swift"), encoding: .utf8)
let fixture = #"""
import Cocoa
import Combine
protocol BindingExposable {}
struct Logger {
    init(category: String) {}
    func error(_ message: String) {}
}
@MainActor enum Defaults {
    enum Key: Hashable { case floeBarAppearanceConfiguration, menuBarAppearanceConfigurationV2 }
    static var values = [Key: Data]()
    static var writes = 0
    static func data(forKey key: Key) -> Data? { values[key] }
    static func set(_ data: Data, forKey key: Key) { values[key] = data; writes += 1 }
}
enum Shape: Int, Codable { case none, full, split }
enum Cap: Int, Codable { case square, round }
struct Ends: Codable, Equatable {
    var leadingEndCap = Cap.round
    var trailingEndCap = Cap.round
}
struct Split: Codable, Equatable { var trailing = Ends() }
struct Partial: Codable, Equatable {
    var tintOpacity = 0.3
    var blurAmount = 0.7
    var hasShadow = false
    var hasBorder = false
}
struct MenuBarAppearanceConfigurationV2: Codable, Equatable {
    var shapeKind = Shape.split
    var fullShapeInfo = Ends()
    var splitShapeInfo = Split()
    var cornerRadius = 1.0
    var lightModeConfiguration = Partial()
    var darkModeConfiguration = Partial()
    var staticConfiguration = Partial()
    static let defaultConfiguration = Self()
}
__PRODUCTION__
@main struct Checks {
    @MainActor static func main() throws {
        let encoder = JSONEncoder(), decoder = JSONDecoder()
        var legacy = MenuBarAppearanceConfigurationV2()
        legacy.shapeKind = .full
        legacy.fullShapeInfo = Ends(leadingEndCap: .square, trailingEndCap: .round)
        legacy.cornerRadius = 0.25
        legacy.lightModeConfiguration.tintOpacity = 0.61
        legacy.darkModeConfiguration.blurAmount = 0.28
        legacy.staticConfiguration.hasBorder = true
        let legacyData = try encoder.encode(legacy)
        Defaults.values = [.menuBarAppearanceConfigurationV2: legacyData]
        let manager = FloeBarAppearanceManager()
        manager.performSetup()
        precondition(manager.configuration.shapeKind == .split)
        precondition(manager.configuration.splitShapeInfo.trailing == legacy.fullShapeInfo)
        precondition(manager.configuration.cornerRadius == 0.25)
        precondition(manager.configuration.lightModeConfiguration == legacy.lightModeConfiguration)
        precondition(manager.configuration.darkModeConfiguration == legacy.darkModeConfiguration)
        precondition(manager.configuration.staticConfiguration == legacy.staticConfiguration)
        precondition(Defaults.values[.menuBarAppearanceConfigurationV2] == legacyData)
        precondition(Defaults.values[.floeBarAppearanceConfiguration] != nil)
        let writes = Defaults.writes
        manager.performSetup()
        precondition(Defaults.writes == writes, "setup must subscribe once")
        manager.configuration.darkModeConfiguration.tintOpacity = 0.82
        let saved = try decoder.decode(MenuBarAppearanceConfigurationV2.self, from: Defaults.values[.floeBarAppearanceConfiguration]!)
        precondition(saved.darkModeConfiguration.tintOpacity == 0.82)
        precondition(Defaults.values[.menuBarAppearanceConfigurationV2] == legacyData)
        let reopened = FloeBarAppearanceManager()
        reopened.performSetup()
        precondition(reopened.configuration == saved, "the Floe Bar record must take precedence on relaunch")
        var oldRectangular = legacy
        oldRectangular.shapeKind = .none
        Defaults.values = [.menuBarAppearanceConfigurationV2: try encoder.encode(oldRectangular)]
        let rectangular = FloeBarAppearanceManager()
        rectangular.performSetup()
        precondition(rectangular.configuration.splitShapeInfo.trailing == Ends(leadingEndCap: .square, trailingEndCap: .square))
        Defaults.values = [:]
        let fresh = FloeBarAppearanceManager()
        fresh.performSetup()
        precondition(fresh.configuration == .defaultConfiguration)
        print("PASS: production Floe Bar appearance migrates colors and shape, persists independently, reloads new records and initializes once")
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-bar-appearance-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let generated = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: source).write(to: generated, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    precondition(process.terminationStatus == 0)
}
let binary = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", generated.path, "-o", binary])
try run([binary])
precondition(!source.contains("NSPanel") && !source.contains("NSScreen"))
precondition(!FileManager.default.fileExists(atPath: repo.appendingPathComponent("Floe/MenuBar/Appearance/MenuBarOverlayPanel.swift").path))
let bar = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
precondition(bar.contains(".environmentObject(appState.floeBarAppearanceManager)"))
precondition(bar.contains("@EnvironmentObject var appearanceManager: FloeBarAppearanceManager"))
let editor = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/Appearance/FloeBarAppearanceEditor.swift"), encoding: .utf8)
precondition(!editor.contains("isMenuBarHiddenBySystemUserDefaults"), "floating appearance must remain available when the native menu bar auto-hides")
print("PASS: appearance startup has no native overlay and the Floe Bar observes its dedicated appearance manager")
