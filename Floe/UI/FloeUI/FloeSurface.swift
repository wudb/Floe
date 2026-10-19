//
//  FloeSurface.swift
//  Floe
//

import SwiftUI

/// V2 的内容层保持实色和细边框，玻璃只用于导航与悬浮控件。
struct FloeCardSurface: ViewModifier {
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background {
                shape.fill(Color(nsColor: .windowBackgroundColor))
                shape.fill(colorScheme == .dark ? Color.white.opacity(0.045) : Color(nsColor: .controlBackgroundColor))
            }
            .overlay {
                shape.strokeBorder(.primary.opacity(contrast == .increased ? 0.3 : 0.09), lineWidth: 1)
                    .allowsHitTesting(false)
            }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
    }
}

private struct FloeGlassSurface<S: InsettableShape>: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    let shape: S

    func body(content: Content) -> some View {
        content.background {
            // 尊重系统辅助设置；旧系统使用同一轮廓的原生磨砂材质。
            if reduceTransparency {
                shape.fill(Color(nsColor: .windowBackgroundColor))
            } else if #available(macOS 26.0, *) {
                Color.clear.glassEffect(.regular, in: shape)
            } else {
                VisualEffectView(material: .popover, blendingMode: .behindWindow)
                    .clipShape(shape)
                    .overlay {
                        shape.strokeBorder(.white.opacity(0.28), lineWidth: 1)
                    }
            }
        }
    }
}

extension View {
    func floeCardSurface() -> some View {
        modifier(FloeCardSurface())
    }

    func floeGlassSurface(in shape: some InsettableShape) -> some View {
        modifier(FloeGlassSurface(shape: shape))
    }
}
