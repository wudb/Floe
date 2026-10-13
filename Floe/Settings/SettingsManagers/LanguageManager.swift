//
//  LanguageManager.swift
//  Floe
//

import Combine
import SwiftUI

/// 保存语言选择并通知所有 SwiftUI 根视图即时刷新，避免重建窗口丢失用户状态。
@MainActor
final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var selection: AppLanguage {
        didSet { Defaults.set(selection.rawValue, forKey: .language) }
    }

    @Published private var preferredLanguages = Locale.preferredLanguages
    private var localeObserver: AnyCancellable?

    var locale: Locale {
        AppLanguage.resolved(selection, preferredLanguages: preferredLanguages).locale
    }

    private init() {
        selection = AppLanguage(rawValue: Defaults.string(forKey: .language) ?? "") ?? .system
        localeObserver = NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.preferredLanguages = Locale.preferredLanguages }
    }
}

private struct AppLanguageModifier: ViewModifier {
    @ObservedObject private var manager = LanguageManager.shared

    func body(content: Content) -> some View {
        content.environment(\.locale, manager.locale)
    }
}

extension View {
    /// 覆盖主窗口、权限窗口和独立 NSHostingView/Popover 的语言环境。
    func appLanguage() -> some View {
        modifier(AppLanguageModifier())
    }
}
