//
//  MenuBarItemAXCache.swift
//  Floe
//

import Cocoa

/// 27 收起图标后可能不再枚举其 AX 节点；保留本次运行中实际读到的身份与分区。
/// 缓存仅用于呈现，移动的落点确认仍使用实时快照。
struct MenuBarItemAXCache {
    private struct Entry {
        let id = UUID().uuidString
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
        menuBarBands: [CGRect],
        allowHiddenSectionChanges: Bool = true
    ) {
        // 退出或重启的进程不能继续使用旧 AX 引用，同一宿主的多个图标分别保留。
        self.runningPIDs = runningPIDs
        entries.removeAll { !runningPIDs.contains($0.item.pid) }
        for item in items where runningPIDs.contains(item.pid) {
            let index = matchingIndex(for: item, in: items)
            var section = index.flatMap { entries[$0].section }
            if let frame = item.axFrame, hiddenDividerX != nil,
               frame.width.isFinite, frame.height.isFinite, !frame.isEmpty,
               menuBarBands.contains(where: { $0.contains(CGPoint(x: frame.midX, y: frame.midY)) }) {
                let actual = MenuBarItemAXDiscovery.classify(
                    centerX: frame.midX,
                    hiddenDividerX: hiddenDividerX,
                    alwaysHiddenDividerX: alwaysHiddenDividerX
                )
                // 收起后的系统溢出代理可能共用占位坐标；已确认的隐藏分区只在展开时更新。
                if section == nil || allowHiddenSectionChanges { section = actual }
            }
            if let index {
                entries[index].item = item
                entries[index].section = section
            } else {
                entries.append(Entry(item: item, section: section))
            }
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

    /// 界面与移动队列使用逻辑身份，当前可操作的 AX 元素可随展开/收起替换。
    func id(for item: MenuBarItemAXDiscovery.AXMenuBarItem) -> String {
        entries.first { Self.sameItem($0.item, item) }?.id ?? "\(item.pid):\(CFHash(item.element))"
    }

    private func matchingIndex(for item: MenuBarItemAXDiscovery.AXMenuBarItem, in items: [MenuBarItemAXDiscovery.AXMenuBarItem]) -> Int? {
        if let exact = entries.firstIndex(where: { Self.sameItem($0.item, item) }) { return exact }
        let candidates = entries.indices.filter { entries[$0].item.pid == item.pid }
        // 单项目宿主在两种 AX 表示之间切换时仍是同一逻辑项，多项目宿主需要明确的唯一标识。
        if candidates.count == 1, items.filter({ $0.pid == item.pid }).count == 1 { return candidates[0] }
        guard let identifier = item.identifier, !identifier.isEmpty,
              items.filter({ $0.pid == item.pid && $0.identifier == identifier }).count == 1 else { return nil }
        let identified = candidates.filter { entries[$0].item.identifier == identifier }
        return identified.count == 1 ? identified[0] : nil
    }

    private static func sameItem(_ lhs: MenuBarItemAXDiscovery.AXMenuBarItem, _ rhs: MenuBarItemAXDiscovery.AXMenuBarItem) -> Bool {
        lhs.pid == rhs.pid && CFEqual(lhs.element, rhs.element)
    }
}
