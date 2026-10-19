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
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var contrast
    let shape: S

    func body(content: Content) -> some View {
        content.background {
            // 尊重系统辅助设置；旧系统直接填充 SwiftUI 材质，避免原生视图矩形边缘露出圆角。
            if reduceTransparency {
                shape.fill(Color(nsColor: .windowBackgroundColor))
            } else if #available(macOS 26.0, *) {
                Color.clear.glassEffect(.regular, in: shape)
            } else {
                shape.fill(.regularMaterial)
            }
            // 浅色玻璃保留柔和的冷白底，避免后方深色窗口把预览条和浮栏染成厚重的灰色。
            if colorScheme == .light, !reduceTransparency {
                shape.fill(Color(red: 0.96, green: 0.975, blue: 0.995).opacity(0.82))
                    .allowsHitTesting(false)
            }
        }
        .overlay {
            shape.strokeBorder(
                colorScheme == .light
                    ? .black.opacity(contrast == .increased ? 0.3 : 0.09)
                    : .white.opacity(contrast == .increased ? 0.4 : 0.18),
                lineWidth: 1
            )
            .allowsHitTesting(false)
        }
    }
}

private struct FloeSidebarSurface: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        content
            .background {
                Group {
                    if colorScheme == .light {
                        // 导航使用稳定的浅蓝灰层次，不随后方应用变脏；背景延伸至交通灯区域。
                        LinearGradient(
                            colors: [Color(red: 0.955, green: 0.97, blue: 0.99), Color(red: 0.925, green: 0.945, blue: 0.975)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else if reduceTransparency {
                        Color(nsColor: .windowBackgroundColor)
                    } else {
                        VisualEffectView(material: .sidebar, blendingMode: .behindWindow)
                    }
                }
                .ignoresSafeArea()
            }
            .overlay(alignment: .trailing) {
                Rectangle().fill(.primary.opacity(0.06)).frame(width: 1)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
    }
}

private struct FloeFloatingBarSurface<S: InsettableShape>: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var contrast
    let shape: S

    @ViewBuilder
    func body(content: Content) -> some View {
        if colorScheme == .light {
            // 小图标使用稳定的浅银灰底，减少玻璃高光、背景混色与图标阴影的叠加。
            content
                .background { shape.fill(Color(red: 0.91, green: 0.925, blue: 0.945)) }
                .overlay {
                    shape.strokeBorder(.black.opacity(contrast == .increased ? 0.3 : 0.12), lineWidth: 1)
                        .allowsHitTesting(false)
                }
        } else {
            content.floeGlassSurface(in: shape)
        }
    }
}

extension View {
    func floeFloatingBarSurface(in shape: some InsettableShape) -> some View {
        modifier(FloeFloatingBarSurface(shape: shape))
    }

    func floeSidebarSurface() -> some View {
        modifier(FloeSidebarSurface())
    }

    func floeCardSurface() -> some View {
        modifier(FloeCardSurface())
    }

    func floeGlassSurface(in shape: some InsettableShape) -> some View {
        modifier(FloeGlassSurface(shape: shape))
    }
}
