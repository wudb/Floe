//
//  FloeForm.swift
//  Floe
//

import SwiftUI

struct FloeForm<Content: View>: View {
    @Environment(\.isScrollEnabled) private var isScrollEnabled

    private let alignment: HorizontalAlignment
    private let padding: EdgeInsets
    private let spacing: CGFloat
    private let content: Content

    init(
        alignment: HorizontalAlignment = .center,
        padding: EdgeInsets,
        spacing: CGFloat = 10,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.padding = padding
        self.spacing = spacing
        self.content = content()
    }

    init(
        alignment: HorizontalAlignment = .center,
        padding: CGFloat = 24,
        spacing: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
            spacing: spacing
        ) {
            content()
        }
    }

    var body: some View {
        // 始终保留滚动容器，避免高度测量反复切换布局；长设置页可直接滚动。
        if isScrollEnabled {
            ScrollView {
                contentStack
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.automatic)
        } else {
            contentStack
        }
    }

    @ViewBuilder
    private var contentStack: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content
                .toggleStyle(FloeFormToggleStyle())
                .buttonStyle(FloeButtonStyle())
        }
        .padding(padding)
    }
}

private struct FloeFormToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        FloeLabeledContent {
            Toggle(isOn: configuration.$isOn) {
                configuration.label
            }
            .labelsHidden()
            .toggleStyle(.switch)
            .controlSize(.small)
        } label: {
            configuration.label
        }
    }
}
