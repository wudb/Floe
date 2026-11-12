//
//  MenuBarItemAXCache.swift
//  Floe
//

import Cocoa

/// 27 收起图标后可能不再枚举其 AX 节点；保留本次运行中实际读到的身份与分区。
/// 缓存仅用于呈现，移动的落点确认仍使用实时快照。
struct MenuBarItemAXCache {
    private struct Entry {
        var item: MenuBarItemAXDiscovery.AXMenuBarItem
        var section: MenuBarItemAXDiscovery.SectionKind?
    }

    private var entries = [Entry]()
    private var runningPIDs = Set<pid_t>()

    mutating func update(
        _ items: [MenuBarItemAXDiscovery.AXMenuBarItem],
        runningPIDs: Set<pid_t>,
        hiddenDividerX: CGFloat?,
        alwaysHiddenDividerX: CGFloat?,
        menuBarBands: [CGRect]
    ) {
        // 退出或重启的进程不能继续使用旧 AX 引用，同一宿主的多个图标分别保留。
        self.runningPIDs = runningPIDs
        entries.removeAll { !runningPIDs.contains($0.item.pid) }
        for item in items where runningPIDs.contains(item.pid) {
            let index = entries.firstIndex { Self.sameItem($0.item, item) }
            var section = index.flatMap { entries[$0].section }
            if let frame = item.axFrame, hiddenDividerX != nil,
               frame.width.isFinite, frame.height.isFinite, !frame.isEmpty,
               menuBarBands.contains(where: { $0.contains(CGPoint(x: frame.midX, y: frame.midY)) }) {
                section = MenuBarItemAXDiscovery.classify(
                    centerX: frame.midX,
                    hiddenDividerX: hiddenDividerX,
                    alwaysHiddenDividerX: alwaysHiddenDividerX
                )
            }
            let entry = Entry(item: item, section: section)
            if let index { entries[index] = entry } else { entries.append(entry) }
        }
        entries.removeAll { entry in
            entry.section != .hidden && entry.section != .alwaysHidden &&
                !items.contains(where: { Self.sameItem(entry.item, $0) })
        }
    }

    /// 只补回已确认的隐藏项；未知分区或消失的可见项不能成为虚构的浮栏图标。
    func merging(_ items: [MenuBarItemAXDiscovery.AXMenuBarItem]) -> [MenuBarItemAXDiscovery.AXMenuBarItem] {
        items.filter { runningPIDs.contains($0.pid) } + entries.compactMap { entry in
            guard entry.section == .hidden || entry.section == .alwaysHidden,
                  !items.contains(where: { Self.sameItem(entry.item, $0) }) else { return nil }
            return entry.item
        }
    }

    func section(for item: MenuBarItemAXDiscovery.AXMenuBarItem) -> MenuBarItemAXDiscovery.SectionKind? {
        entries.first { Self.sameItem($0.item, item) }?.section
    }

    private static func sameItem(_ lhs: MenuBarItemAXDiscovery.AXMenuBarItem, _ rhs: MenuBarItemAXDiscovery.AXMenuBarItem) -> Bool {
        lhs.pid == rhs.pid && CFEqual(lhs.element, rhs.element)
    }
}
