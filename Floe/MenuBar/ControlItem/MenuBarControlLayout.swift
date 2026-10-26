//
//  MenuBarControlLayout.swift
//  Floe
//

import Foundation

/// macOS 27 的状态项空间有限；没有可信屏幕尺寸时保持展开，不猜测一个可能吞掉入口的宽度。
enum MenuBarControlLayout {
    struct Region {
        let displayWidth: CGFloat?
        let statusRegionWidth: CGFloat?
    }

    /// NSStatusItem 只接受一个长度，必须同时适合所有屏幕，不能把外接屏的宽占位发给内置屏。
    static func hidingLength(for regions: [Region]) -> CGFloat {
        regions.map { hidingLength(displayWidth: $0.displayWidth, statusRegionWidth: $0.statusRegionWidth) }.min() ?? 1
    }

    static func hidingLength(displayWidth: CGFloat?, statusRegionWidth: CGFloat?) -> CGFloat {
        guard let displayWidth, displayWidth.isFinite, displayWidth > 64,
              let statusRegionWidth, statusRegionWidth.isFinite, statusRegionWidth > 32 else { return 1 }
        // 上游实测达到半屏的项会被 MenuBarAgent 丢弃；点坐标计算，不使用像素宽度。
        let maximum = floor(displayWidth / 2) - 1
        return max(1, min(statusRegionWidth - 32, maximum))
    }
}
