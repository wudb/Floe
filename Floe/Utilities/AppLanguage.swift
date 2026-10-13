//
//  AppLanguage.swift
//  Floe
//

import Foundation

/// 用户选择与实际显示语言分离，保留“跟随系统”的持续语义。
enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case english = "en"
    case simplifiedChinese = "zh-Hans"

    var id: String { rawValue }

    /// 仅匹配系统首选语言；繁体中文和未支持的语言回退英语。
    static func resolved(_ selection: AppLanguage, preferredLanguages: [String]) -> AppLanguage {
        guard selection == .system else { return selection }
        let components = (preferredLanguages.first ?? "en")
            .replacingOccurrences(of: "_", with: "-")
            .lowercased().split(separator: "-").map(String.init)
        guard components.first == "zh" else { return .english }
        if components.contains("hant") { return .english }
        if components.contains("hans") { return .simplifiedChinese }
        if components.contains(where: { ["tw", "hk", "mo"].contains($0) }) { return .english }
        return .simplifiedChinese
    }

    var locale: Locale { Locale(identifier: rawValue) }
}

/// AppKit 菜单、弹窗和动态文案使用同一语言资源，不修改全局 AppleLanguages。
enum L10n {
    static func string(_ key: String, _ arguments: CVarArg...) -> String {
        let selection = AppLanguage(rawValue: Defaults.string(forKey: .language) ?? "") ?? .system
        let language = AppLanguage.resolved(selection, preferredLanguages: Locale.preferredLanguages)
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle = path.flatMap(Bundle.init(path:)) ?? Bundle.main
        let format = bundle.localizedString(forKey: key, value: key, table: nil)
        return arguments.isEmpty ? format : String(format: format, locale: language.locale, arguments: arguments)
    }
}
