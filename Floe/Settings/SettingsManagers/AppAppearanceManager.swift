//
//  AppAppearanceManager.swift
//  Floe
//

import SwiftUI

/// 为 Floe 的界面窗口保存并同步外观；不覆盖 NSApp，避免改变菜单栏的系统明暗判定。
@MainActor
final class AppAppearanceManager: ObservableObject {
    static let shared = AppAppearanceManager()

    @Published var selection: AppAppearance {
        didSet {
            Defaults.set(selection.rawValue, forKey: .appAppearance)
            for window in windows.allObjects {
                apply(to: window)
            }
        }
    }

    // 弱引用不延长检索窗口、Popover 或浮栏的生命周期。
    private let windows = NSHashTable<NSWindow>.weakObjects()

    init() {
        selection = AppAppearance(rawValue: Defaults.string(forKey: .appAppearance) ?? "") ?? .system
    }

    func register(_ window: NSWindow?) {
        guard let window else { return }
        windows.add(window)
        apply(to: window)
    }

    private func apply(to window: NSWindow) {
        let appearance = selection.nativeAppearance
        if window.appearance?.name != appearance?.name {
            window.appearance = appearance
        }
    }
}

private struct AppAppearanceModifier: ViewModifier {
    @ObservedObject private var manager = AppAppearanceManager.shared
    @Environment(\.colorScheme) private var inheritedColorScheme

    func body(content: Content) -> some View {
        content
            // 直接提供颜色环境；preferredColorScheme 从显式值改回 nil 时可能滞留旧偏好。
            // 跟随系统时恢复宿主窗口的环境，NSHostingView 会继续响应原生外观变化。
            .environment(\.colorScheme, manager.selection.colorScheme ?? inheritedColorScheme)
            .readWindow { window in
                // 独立 NSHostingView/Popover 同时更新 AppKit 材质和窗口边框。
                manager.register(window)
            }
    }
}

extension View {
    func appAppearance() -> some View {
        modifier(AppAppearanceModifier())
    }
}
