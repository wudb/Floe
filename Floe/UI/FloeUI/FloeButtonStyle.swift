//
//  FloeButtonStyle.swift
//  Floe
//

import SwiftUI

/// 工具按钮统一使用细边框和蓝色强调，同时保留系统的禁用状态。
struct FloeButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.callout)
            .foregroundStyle(isEnabled ? Color.accentColor : .secondary)
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.blue.opacity(configuration.isPressed && isEnabled ? 0.12 : 0))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(.primary.opacity(0.1), lineWidth: 1)
                    }
            }
    }
}
