//
//  FloeTooltip.swift
//  Floe
//

import SwiftUI

/// 指针变化只刷新提示层，不让包含大量图标的设置页随每个像素的移动重新计算。
@MainActor
final class FloeTooltipController: ObservableObject {
    @Published private(set) var pointerLocation: CGPoint?

    func update(location: CGPoint?, pressedMouseButtons: Int = 0) {
        let next = pressedMouseButtons == 0 ? location : nil
        if pointerLocation != next { pointerLocation = next }
    }

    func dismiss() {
        update(location: nil)
    }
}

private struct FloeTooltipTarget {
    let text: String
    let bounds: Anchor<CGRect>
    let viewport: String?
}

private struct FloeTooltipPreferences {
    var targets = [FloeTooltipTarget]()
    var viewports = [String: Anchor<CGRect>]()
}

private struct FloeTooltipPreferenceKey: PreferenceKey {
    static let defaultValue = FloeTooltipPreferences()

    static func reduce(value: inout FloeTooltipPreferences, nextValue: () -> FloeTooltipPreferences) {
        let next = nextValue()
        value.targets.append(contentsOf: next.targets)
        value.viewports.merge(next.viewports) { _, new in new }
    }
}

/// 提示只对当前可见的图标命中，滚出视口的项目不能在标题栏等位置留下提示。
enum FloeTooltipGeometry {
    static func contains(_ point: CGPoint, target: CGRect, viewport: CGRect) -> Bool {
        target.intersection(viewport).contains(point)
    }

    /// 优先放在图标下方，靠近窗口底部时翻到上方，两侧始终留出安全边距。
    static func origin(size: CGSize, anchor: CGRect, container: CGSize) -> CGPoint {
        let margin: CGFloat = 8
        let gap: CGFloat = 6
        let maxX = max(margin, container.width - size.width - margin)
        let maxY = max(margin, container.height - size.height - margin)
        let below = anchor.maxY + gap
        let y = below <= maxY ? below : anchor.minY - size.height - gap
        return CGPoint(
            x: min(max(margin, anchor.midX - size.width / 2), maxX),
            y: min(max(margin, y), maxY)
        )
    }
}

private struct FloeTooltipBubble: View {
    let text: String
    let anchor: CGRect
    let container: CGSize

    private var size: CGSize {
        // 显式测量名称，使第一次绘制就能贴近图标，无需等下一次布局回调后再定位。
        let maxWidth = max(1, min(280, container.width - 16))
        let font = NSFont.systemFont(ofSize: 12)
        let labelBounds = (text as NSString).boundingRect(
            with: CGSize(width: max(1, maxWidth - 16), height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font]
        )
        return CGSize(
            width: min(maxWidth, ceil(labelBounds.width) + 16),
            height: min(ceil(labelBounds.height), ceil(font.ascender - font.descender + font.leading) * 3) + 12
        )
    }

    var body: some View {
        let origin = FloeTooltipGeometry.origin(size: size, anchor: anchor, container: container)
        Text(verbatim: text)
            .font(.system(size: 12))
            .foregroundStyle(.primary)
            .lineLimit(3)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(width: size.width, height: size.height)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(.primary.opacity(0.15), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.16), radius: 4, y: 2)
            .position(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
            .accessibilityHidden(true)
    }
}

private struct FloeTooltipLayer: ViewModifier {
    @ObservedObject var controller: FloeTooltipController
    let isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .onContinuousHover { phase in
                // 直接响应指针事件，不经过系统 help 的等待时间；按下鼠标后不给拖拽加遮挡。
                if case .active(let location) = phase, isEnabled {
                    controller.update(location: location, pressedMouseButtons: NSEvent.pressedMouseButtons)
                } else {
                    controller.dismiss()
                }
            }
            .overlayPreferenceValue(FloeTooltipPreferenceKey.self) { preferences in
                GeometryReader { proxy in
                    if isEnabled, let point = controller.pointerLocation,
                       let target = preferences.targets.reversed().first(where: { target in
                           let viewport: CGRect
                           if let key = target.viewport {
                               guard let bounds = preferences.viewports[key] else { return false }
                               viewport = proxy[bounds]
                           } else {
                               viewport = CGRect(origin: .zero, size: proxy.size)
                           }
                           return FloeTooltipGeometry.contains(point, target: proxy[target.bounds], viewport: viewport)
                       }) {
                        FloeTooltipBubble(text: target.text, anchor: proxy[target.bounds], container: proxy.size)
                    }
                }
                // 覆盖层不参与命中，避免提示遮住图标后触发反复移入/移出，也不拦截点击和拖拽。
                .allowsHitTesting(false)
            }
            .onChange(of: isEnabled) { _, enabled in
                if !enabled { controller.dismiss() }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)) { _ in
                controller.dismiss()
            }
            .onDisappear { controller.dismiss() }
    }
}

extension View {
    /// 记录图标在页面中的实际位置，名称始终按原文显示，不作为本地化键解析。
    func floeTooltip(_ text: String, viewport: String? = nil) -> some View {
        anchorPreference(key: FloeTooltipPreferenceKey.self, value: .bounds) { anchor in
            FloeTooltipPreferences(targets: [FloeTooltipTarget(text: text, bounds: anchor, viewport: viewport)])
        }
    }

    func floeTooltipViewport(_ id: String) -> some View {
        transformAnchorPreference(key: FloeTooltipPreferenceKey.self, value: .bounds) { value, anchor in
            value.viewports[id] = anchor
        }
    }

    /// 应加在滚动容器外，使即时提示不会被 ScrollView 的裁剪边界截断。
    func floeTooltips(_ controller: FloeTooltipController, isEnabled: Bool = true) -> some View {
        modifier(FloeTooltipLayer(controller: controller, isEnabled: isEnabled))
    }
}
