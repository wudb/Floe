//
//  SettingsView.swift
//  Floe
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var appearanceManager = AppAppearanceManager.shared
    @EnvironmentObject var navigationState: AppNavigationState
    @Environment(\.sidebarRowSize) var sidebarRowSize

    private var sidebarWidth: CGFloat {
        switch sidebarRowSize {
        case .small: 190
        case .medium: 210
        case .large: 230
        @unknown default: 210
        }
    }

    private var sidebarItemHeight: CGFloat {
        switch sidebarRowSize {
        case .small: 26
        case .medium: 32
        case .large: 34
        @unknown default: 32
        }
    }

    private var sidebarItemFontSize: CGFloat {
        switch sidebarRowSize {
        case .small: 13
        case .medium: 15
        case .large: 16
        @unknown default: 15
        }
    }

    var body: some View {
        // 保留固定导航，避免分栏折叠控件挤占紧凑设置窗口的空间。
        HStack(spacing: 0) {
            sidebar
                .frame(width: sidebarWidth)
                .floeSidebarSurface()
            VStack(alignment: .leading, spacing: 0) {
                if navigationState.settingsNavigationIdentifier != .menuBarLayout {
                    Text(navigationState.settingsNavigationIdentifier.localized)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.horizontal, 24)
                        .padding(.top, 22)
                        .padding(.bottom, 4)
                }
                detailView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color(nsColor: .windowBackgroundColor).ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(spacing: 6) {
                Image(nsImage: ApplicationIcon.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)
                Text("Floe")
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .padding(.bottom, 24)

            ForEach(mainIdentifiers, id: \.self) { identifier in
                SettingsSidebarItem(
                    identifier: identifier,
                    icon: icon(for: identifier),
                    isSelected: navigationState.settingsNavigationIdentifier == identifier,
                    fontSize: sidebarItemFontSize,
                    rowHeight: sidebarItemHeight + 4
                ) {
                    navigationState.settingsNavigationIdentifier = identifier
                }
            }
            Divider()
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
            ForEach(secondaryIdentifiers, id: \.self) { identifier in
                SettingsSidebarItem(
                    identifier: identifier,
                    icon: icon(for: identifier),
                    isSelected: navigationState.settingsNavigationIdentifier == identifier,
                    fontSize: sidebarItemFontSize,
                    rowHeight: sidebarItemHeight + 4
                ) {
                    navigationState.settingsNavigationIdentifier = identifier
                }
            }
            Spacer(minLength: 24)
            Label(appearanceManager.selection.statusTitleKey, systemImage: appearanceManager.selection.symbolName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
        }
        .padding(.horizontal, 10)
        .frame(maxHeight: .infinity)
    }

    /// 常用设置置于上组，关于信息单独放在分隔线下。
    private var mainIdentifiers: [SettingsNavigationIdentifier] {
        SettingsNavigationIdentifier.allCases.filter { $0 != .about }
    }

    private var secondaryIdentifiers: [SettingsNavigationIdentifier] {
        [.about]
    }

    @ViewBuilder
    private var detailView: some View {
        switch navigationState.settingsNavigationIdentifier {
        case .general:
            GeneralSettingsPane()
        case .menuBarLayout:
            MenuBarLayoutSettingsPane()
        case .menuBarAppearance:
            MenuBarAppearanceSettingsPane()
        case .hotkeys:
            HotkeysSettingsPane()
        case .advanced:
            AdvancedSettingsPane()
        case .about:
            AboutSettingsPane()
        }
    }

    private func icon(for identifier: SettingsNavigationIdentifier) -> IconResource {
        switch identifier {
        case .general: .systemSymbol("gearshape")
        case .menuBarLayout: .systemSymbol("rectangle.topthird.inset.filled")
        case .menuBarAppearance: .systemSymbol("swatchpalette")
        case .hotkeys: .systemSymbol("keyboard")
        case .advanced: .systemSymbol("gearshape.2")
        case .about: .assetCatalog(.iceCubeStroke)
        }
    }
}

/// 图标与文字共用选中反馈，亮色和深色模式均由系统语义色驱动。
private struct SettingsSidebarItem: View {
    let identifier: SettingsNavigationIdentifier
    let icon: IconResource
    let isSelected: Bool
    let fontSize: CGFloat
    let rowHeight: CGFloat
    let action: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                icon.view
                    .frame(width: 18, height: 18)
                    .foregroundStyle(isSelected ? .blue : .secondary)
                Text(identifier == .about ? LocalizedStringKey("About Floe") : identifier.localized)
                    .font(.system(size: fontSize, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .blue : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: rowHeight)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        isSelected
                            ? .blue.opacity(0.16)
                            : (isHovering ? .primary.opacity(0.06) : .clear)
                    )
            }
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
    }
}
