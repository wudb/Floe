//
//  AppAppearance.swift
//  Floe
//

import SwiftUI

/// 用户的界面外观选择，与菜单栏独立的自定义色调配置分开保存。
enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var titleKey: LocalizedStringKey {
        switch self {
        case .system: "Follow System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var statusTitleKey: LocalizedStringKey {
        switch self {
        case .system: "Follows system appearance"
        case .light: "Light Appearance"
        case .dark: "Dark Appearance"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }

    /// nil 会解除窗口覆盖，让系统后续的明暗切换继续自动生效。
    var nativeAppearance: NSAppearance? {
        switch self {
        case .system: nil
        case .light: NSAppearance(named: .aqua)
        case .dark: NSAppearance(named: .darkAqua)
        }
    }

    var symbolName: String {
        switch self {
        case .system: "circle.lefthalf.filled"
        case .light: "sun.max"
        case .dark: "moon"
        }
    }
}
