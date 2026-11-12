//
//  LayoutBarStyle.swift
//  Floe
//

import SwiftUI

extension View {
    /// Returns a view that is drawn in the style of a layout bar.
    ///
    /// - Note: The view this modifier is applied to must be transparent, or the style
    ///   will be drawn incorrectly.
    @ViewBuilder
    func layoutBarStyle(appState: AppState, averageColorInfo: MenuBarAverageColorInfo?, tintOpacity: Double = 0.2, useLiveBlur: Bool = false, isFullscreen: Bool = false) -> some View {
        background {
            // 色调只叠加背景，避免覆盖菜单图标和文字，降低前景对比度。
            ZStack {
                if isFullscreen {
                    Color.black
                } else if useLiveBlur {
                    // 只在浮栏自身绘制实时模糊与色调。
                    let current = appState.floeBarAppearanceManager.configuration.current
                    if !(current.blurAmount <= 0 || (current.tintKind != .none && current.tintOpacity >= 1)) {
                        VisualEffectView(material: .menu, blendingMode: .behindWindow)
                            .opacity(current.blurAmount)
                    }
                } else if let averageColorInfo {
                    switch averageColorInfo.source {
                    case .menuBarWindow:
                        Color(cgColor: averageColorInfo.color)
                            .overlay(
                                Material.bar
                                    .opacity(0.2)
                                    .blendMode(.softLight)
                            )
                    case .desktopWallpaper:
                        Color(cgColor: averageColorInfo.color)
                            .overlay(
                                Material.bar
                                    .opacity(0.5)
                                    .blendMode(.softLight)
                            )
                    }
                } else {
                    Color.defaultLayoutBar
                }
                if !isFullscreen {
                    switch appState.floeBarAppearanceManager.configuration.current.tintKind {
                    case .none:
                        EmptyView()
                    case .solid:
                        Color(cgColor: appState.floeBarAppearanceManager.configuration.current.tintColor)
                            .opacity(tintOpacity)
                            .allowsHitTesting(false)
                    case .gradient:
                        appState.floeBarAppearanceManager.configuration.current.tintGradient
                            .opacity(tintOpacity)
                            .allowsHitTesting(false)
                    }
                }
            }
        }
    }
}
