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

    /// 菜单栏顺序键在 macOS 27 中不再等同于旧的“右侧偏移”。仅用于新状态项，不覆盖用户拖拽位置。
    static func initialPosition(for identifier: String, modernMenuBar: Bool) -> CGFloat? {
        switch identifier {
        case "SItem": modernMenuBar ? 0.5 : 0
        case "HItem": modernMenuBar ? 100_000 : 1
        case "AHItem": modernMenuBar ? 100_010 : 2
        default: nil
        }
    }

    static func hidingLength(displayWidth: CGFloat?, statusRegionWidth: CGFloat?) -> CGFloat {
        guard let displayWidth, displayWidth.isFinite, displayWidth > 64,
              let statusRegionWidth, statusRegionWidth.isFinite, statusRegionWidth > 32 else { return 1 }
        // 系统在 length 外另加约 16 点内边距；再留 8 点余量，不能仅把 length 压在半屏以下。
        // 来源：cavaldos/Ice 的 MenuBarSpacerPlan（macOS 27.2 实测）；使用点而非像素。
        let maximum = floor(displayWidth / 2) - 16 - 8
        return max(1, min(statusRegionWidth - 32, maximum))
    }
}
