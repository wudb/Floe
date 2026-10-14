//
//  CustomColorPicker.swift
//  Floe
//

import Combine
import SwiftUI

struct CustomColorPicker: NSViewRepresentable {
    final class Coordinator: NSObject {
        @Binding var selection: CGColor

        var supportsOpacity: Bool
        var mode: NSColorPanel.Mode

        private var cancellables = Set<AnyCancellable>()

        init(
            selection: Binding<CGColor>,
            supportsOpacity: Bool,
            mode: NSColorPanel.Mode
        ) {
            self._selection = selection
            self.supportsOpacity = supportsOpacity
            self.mode = mode
            super.init()
        }

        func update(selection: Binding<CGColor>, supportsOpacity: Bool, mode: NSColorPanel.Mode) {
            self._selection = selection
            self.supportsOpacity = supportsOpacity
            self.mode = mode
        }

        @objc func colorChanged(_ sender: NSColorWell) {
            if selection != sender.color.cgColor {
                selection = sender.color.cgColor
            }
        }

        func dismantle(_ nsView: NSColorWell) {
            // 视图销毁后，共享颜色面板不再向旧 Binding 写入。
            nsView.deactivate()
            nsView.target = nil
            nsView.action = nil
            cancellables.removeAll()
        }

        func configure(with nsView: NSColorWell) {
            var c = Set<AnyCancellable>()

            // 只接收用户操作；KVO 的初始值和程序同步不能反向覆盖 SwiftUI 设置。
            nsView.isContinuous = true
            nsView.target = self
            nsView.action = #selector(colorChanged(_:))

            NSColorPanel.shared
                .publisher(for: \.isVisible)
                .sink { [weak self, weak nsView] isVisible in
                    guard
                        let self,
                        let nsView,
                        isVisible,
                        nsView.isActive
                    else {
                        return
                    }
                    NSColorPanel.shared.showsAlpha = supportsOpacity
                    NSColorPanel.shared.mode = mode
                    if let window = nsView.window {
                        NSColorPanel.shared.level = window.level + 1
                    }
                    if NSColorPanel.shared.frame.origin == .zero {
                        NSColorPanel.shared.center()
                    }
                }
                .store(in: &c)

            NSColorPanel.shared
                .publisher(for: \.level)
                .sink { [weak nsView] level in
                    guard
                        let nsView,
                        nsView.isActive,
                        let window = nsView.window,
                        level != window.level + 1
                    else {
                        return
                    }
                    NSColorPanel.shared.level = window.level + 1
                }
                .store(in: &c)

            cancellables = c
        }
    }

    @Binding var selection: CGColor

    let supportsOpacity: Bool
    let mode: NSColorPanel.Mode

    func makeNSView(context: Context) -> NSColorWell {
        let nsView = NSColorWell()
        if let color = NSColor(cgColor: selection) {
            nsView.color = color
        }
        context.coordinator.configure(with: nsView)
        return nsView
    }

    func updateNSView(_ nsView: NSColorWell, context: Context) {
        // SwiftUI 可复用 Coordinator，必须同步最新 Binding 和面板选项。
        context.coordinator.update(selection: $selection, supportsOpacity: supportsOpacity, mode: mode)
        if let color = NSColor(cgColor: selection), nsView.color != color {
            nsView.color = color
        }
        if nsView.isActive {
            NSColorPanel.shared.showsAlpha = supportsOpacity
            NSColorPanel.shared.mode = mode
        }
        nsView.supportsAlpha = supportsOpacity
    }

    static func dismantleNSView(_ nsView: NSColorWell, coordinator: Coordinator) {
        coordinator.dismantle(nsView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            selection: $selection,
            supportsOpacity: supportsOpacity,
            mode: mode
        )
    }

    func sizeThatFits(
        _ proposal: ProposedViewSize,
        nsView: NSColorWell,
        context: Context
    ) -> CGSize? {
        switch nsView.controlSize {
        case .large:
            CGSize(width: 55, height: 30)
        case .regular:
            CGSize(width: 44, height: 24)
        case .small:
            CGSize(width: 33, height: 18)
        case .mini:
            CGSize(width: 29, height: 16)
        @unknown default:
            // NSControlSizeExtraLarge == 4, introduced in the macOS 26 SDK.
            // Compared by raw value so this still compiles on older SDKs.
            if nsView.controlSize.rawValue == 4 {
                CGSize(width: 66, height: 36)
            } else {
                nsView.intrinsicContentSize
            }
        }
    }
}
