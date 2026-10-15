//
//  AdaptivePresentationPolicy.swift
//  Floe
//

import CoreGraphics
import Foundation

/// 纯决策层：只消费目标屏幕快照，不读取系统状态，也不更改用户显隐选择。
enum AdaptivePresentationPolicy {
    enum Decision: String { case native, floating, disabled }
    enum DisplayRule: String, Codable, CaseIterable {
        case all, builtIn, external, notched
        var title: String {
            switch self {
            case .all: "All displays"
            case .builtIn: "Built-in display only"
            case .external: "External displays only"
            case .notched: "Notched displays only"
            }
        }
    }

    enum CountRule: String, Codable, CaseIterable {
        case any, single, multiple
        var title: String {
            switch self {
            case .any: "Any display count"
            case .single: "One display connected"
            case .multiple: "Multiple displays connected"
            }
        }
    }

    enum FullscreenRule: String, Codable, CaseIterable {
        case followRules, native, floating, disabled
        var title: String {
            switch self {
            case .followRules: "Follow adaptive rules"
            case .native: "Native menu bar"
            case .floating: "Floe Bar"
            case .disabled: "Do not reveal in full screen"
            }
        }
    }

    enum Override: String, Codable, CaseIterable {
        case automatic, native, floating
        var title: String {
            switch self {
            case .automatic: "Follow adaptive rules"
            case .native: "Native menu bar"
            case .floating: "Floe Bar"
            }
        }
    }

    struct Rules: Codable, Equatable {
        var display = DisplayRule.all
        var count = CountRule.any
        var onlyWhenCrowded = true
        var reserveSpace: Double = 24
        var fullscreen = FullscreenRule.followRules
    }

    /// 所有长度均为逻辑点；未知的空间测量用 nil 表示，不能当成零个隐藏项。
    struct Context {
        var builtIn: Bool
        var notched: Bool
        var displayCount: Int
        var fullscreen: Bool?
        var autoHiddenMenuBar: Bool
        var availableWidth: Double?
        var requiredWidth: Double?
    }

    static func resolve(_ context: Context, rules: Rules, override: Override, previous: Decision?) -> Decision {
        switch override {
        case .native: return .native
        case .floating: return .floating
        case .automatic: break
        }
        if context.fullscreen == true {
            switch rules.fullscreen {
            case .native: return .native
            case .floating: return .floating
            case .disabled: return .disabled
            case .followRules: break
            }
        }
        // 屏幕类型和数量是同时满足的作用范围；范围之外仍可正常原生展开。
        switch rules.display {
        case .builtIn where !context.builtIn, .external where context.builtIn, .notched where !context.notched: return .native
        default: break
        }
        switch rules.count {
        case .single where context.displayCount != 1, .multiple where context.displayCount <= 1: return .native
        default: break
        }
        guard rules.onlyWhenCrowded else { return .floating }
        // 自动隐藏时原生空间会滑动；发现/测量缺失时也保留浮栏访问入口。
        guard !context.autoHiddenMenuBar,
              let available = context.availableWidth, available.isFinite, available >= 0,
              let required = context.requiredWidth, required.isFinite, required >= 0 else { return .floating }
        let reserve = rules.reserveSpace.isFinite ? min(300, max(0, rules.reserveSpace)) : 24
        // 进入浮栏后多留 48 点退出余量，避免临界宽度反复切换。
        let threshold = reserve + (previous == .floating ? 48 : 0)
        return available - required < threshold ? .floating : .native
    }

    /// AppKit 和 Quartz 的 X 轴相同；右侧刘海安全区限制连续原生菜单栏的容量。
    static func availableWidth(bounds: CGRect, rightSafeArea: CGRect?, applicationMenu: CGRect?) -> Double? {
        guard bounds.width.isFinite, bounds.width > 0 else { return nil }
        var left = bounds.minX
        if let safe = rightSafeArea, safe.width > 0, safe.minX >= bounds.minX, safe.maxX <= bounds.maxX + 1 {
            left = max(left, safe.minX)
        }
        if let menu = applicationMenu, !menu.isNull, menu.width.isFinite, menu.width > 0,
           menu.minX >= bounds.minX - 1, menu.maxX <= bounds.maxX + 1,
           menu.minY >= bounds.minY - 1, menu.maxY <= bounds.minY + 64 {
            left = max(left, menu.maxX)
        } else {
            // 只有刘海几何不足以证明应用菜单没有伸入右侧区域。
            return nil
        }
        return max(0, bounds.maxX - left)
    }
}
