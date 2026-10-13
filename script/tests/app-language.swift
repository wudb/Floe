//
//  app-language.swift
//  Floe
//

import Foundation

// 从生产文件编译语言解析、保存和资源读取逻辑；仅替换系统语言与资源 Bundle。
// 测试不修改用户偏好或系统 AppleLanguages，也不打开真实窗口。
let repo = FileManager.default.currentDirectoryPath
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-language-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let resources = directory.appendingPathComponent("Localization.bundle")
try FileManager.default.copyItem(at: URL(fileURLWithPath: repo + "/Floe/Resources"), to: resources)
let languageSource = try String(contentsOfFile: repo + "/Floe/Utilities/AppLanguage.swift", encoding: .utf8)
let managerSource = try String(contentsOfFile: repo + "/Floe/Settings/SettingsManagers/LanguageManager.swift", encoding: .utf8)
let fixtures = #"""
import Foundation
var testPreferredLanguages = ["zh-Hans-CN"]
let localizationBundle = Bundle(path: CommandLine.arguments[1])!
enum Defaults {
    enum Key { case language }
    static var saved: String?
    static func string(forKey key: Key) -> String? { saved }
    static func set(_ value: String, forKey key: Key) { saved = value }
}
"""#
let tests = #"""
@main struct LanguageTests {
    @MainActor static func main() {
        let cases: [(String, AppLanguage)] = [
            ("en-US", .english), ("zh-Hans", .simplifiedChinese),
            ("zh-CN", .simplifiedChinese), ("zh_SG", .simplifiedChinese),
            ("zh", .simplifiedChinese), ("zh-Hant", .english),
            ("zh-TW", .english), ("zh-HK", .english), ("zh-MO", .english),
            ("zh-Hant-CN", .english), ("fr-FR", .english), ("ja-JP", .english)
        ]
        for (system, expected) in cases {
            precondition(AppLanguage.resolved(.system, preferredLanguages: [system]) == expected)
        }
        precondition(AppLanguage.resolved(.system, preferredLanguages: []) == .english)
        precondition(AppLanguage.resolved(.system, preferredLanguages: ["fr-FR", "zh-Hans"]) == .english)
        precondition(AppLanguage.resolved(.english, preferredLanguages: ["zh-Hans"]) == .english)
        precondition(AppLanguage.resolved(.simplifiedChinese, preferredLanguages: ["en-US"]) == .simplifiedChinese)
        print("PASS: system language, scripts/regions, unsupported fallback and manual overrides")

        Defaults.saved = "unsupported"
        let manager = LanguageManager.shared
        precondition(manager.selection == .system)
        precondition(manager.locale.identifier == "zh-Hans")
        manager.selection = .english
        precondition(Defaults.saved == "en" && manager.locale.identifier == "en")
        precondition(L10n.string("Language") == "Language")
        manager.selection = .simplifiedChinese
        precondition(Defaults.saved == "zh-Hans" && manager.locale.identifier == "zh-Hans")
        precondition(L10n.string("Language") == "语言")
        precondition(L10n.string("Show the %@ Section", L10n.string("Hidden")) == "显示隐藏分区")
        precondition(L10n.string("Version %@ is now available", "1.2.3") == "版本 1.2.3 已可用")
        precondition(L10n.string("%@ seconds", "15") == "15 秒")
        precondition(L10n.string("Missing translation") == "Missing translation")
        manager.selection = .system
        testPreferredLanguages = ["fr-FR"]
        precondition(L10n.string("Language") == "Language")
        print("PASS: selection persistence, invalid preference recovery, native menus, formatting and resource fallback")
    }
}
"""#
let generated = directory.appendingPathComponent("LanguageTests.swift")
let production = (languageSource + "\n" + managerSource)
    .replacingOccurrences(of: "Bundle.main", with: "localizationBundle")
    .replacingOccurrences(of: "Locale.preferredLanguages", with: "testPreferredLanguages")
try (fixtures + "\n" + production + "\n" + tests).write(to: generated, atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("LanguageTests")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc")
compiler.arguments = ["-parse-as-library", generated.path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let runner = Process()
runner.executableURL = binary
runner.arguments = [resources.path]
try runner.run()
runner.waitUntilExit()
exit(runner.terminationStatus)
