//
//  MenuBarLayoutStore.swift
//  Floe
//

import Foundation

/// 保存用户确认的布局；窗口/PID 重建后用宿主身份恢复，拒绝猜测同名多状态项。
@MainActor
final class MenuBarLayoutStore {
    struct Entry: Codable, Equatable {
        let key: String
        let section: String
    }

    private static let defaultsKey = "MenuBarLayoutChoices.v1"
    private var entries: [Entry]
    private var observedWindows = [String: UInt32]()
    private var isRestoring = false
    private var choiceRevision = 0

    init() {
        entries = UserDefaults.standard.data(forKey: Self.defaultsKey)
            .flatMap { try? JSONDecoder().decode([Entry].self, from: $0) } ?? []
    }

    /// 单状态项以 bundle 为稳定身份；多状态项必须有唯一且非占位的标识。
    func identifiedItems(_ items: [MenuBarItem]) -> [String: MenuBarItem] {
        let groups = Dictionary(grouping: items.filter { $0.info.namespace != .floe }) {
            $0.info.namespace.rawValue
        }
        var result = [String: MenuBarItem]()
        for (bundle, siblings) in groups where bundle != "<null>" {
            if siblings.count == 1, bundle != "com.apple.controlcenter", bundle != "com.apple.systemuiserver" {
                result[bundle] = siblings[0]
            } else {
                let titles = Dictionary(grouping: siblings, by: { $0.info.title })
                for (title, matches) in titles where matches.count == 1 && !title.isEmpty {
                    guard title.range(of: "^Item-[0-9]+$", options: .regularExpression) == nil else { continue }
                    result[bundle + ":" + title] = matches[0]
                }
            }
        }
        return result
    }

    /// 仅由明确用户拖拽的最终快照调用，不把自动临时显示保存为新选择。
    func record(_ cache: MenuBarItemManager.ItemCache) {
        choiceRevision += 1
        let identified = identifiedItems(cache.allItems)
        let keys = Dictionary(uniqueKeysWithValues: identified.map { ($0.value.windowID, $0.key) })
        var next = [Entry]()
        for section in MenuBarSection.Name.allCases {
            for item in cache[section].sorted(by: { $0.frame.minX < $1.frame.minX }) {
                if let key = keys[item.windowID] {
                    next.append(Entry(key: key, section: String(describing: section)))
                }
            }
        }
        guard !next.isEmpty else { return }
        // 暂时退出的宿主仍保留其原选择，更新应用后才有恢复依据。
        let present = Set(next.map(\.key))
        entries = next + entries.filter { !present.contains($0.key) }
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: Self.defaultsKey)
        }
        observedWindows = identified.mapValues(\.windowID)
    }

    /// 用户开始原生拖拽后淘汰尚未执行的自动恢复步骤。
    func cancelPendingRestore() {
        choiceRevision += 1
    }

    /// 只对首次观察/窗口重建执行恢复；正常扫描不不断覆盖用户的原生拖拽。
    func restoreIfNeeded(manager: MenuBarItemManager) async {
        guard !isRestoring, !entries.isEmpty,
              !manager.isMovingItem, !manager.isEditingLayout, !manager.mouseHasRecentlyMoved, !manager.hasTemporarilyShownItems,
              let appState = manager.appState,
              !MenuInteractionGuard.isInteracting
        else { return }
        let identified = identifiedItems(manager.itemCache.allItems)
        let recreated = Set(identified.compactMap { key, item in
            observedWindows[key] != item.windowID ? key : nil
        })
        guard !recreated.isEmpty else { return }
        isRestoring = true
        let revision = choiceRevision
        defer { isRestoring = false }
        // 先标记本轮，避免强制刷新再次排队恢复；下一次窗口重建仍会被检测。
        observedWindows = identified.mapValues(\.windowID)
        for section in MenuBarSection.Name.allCases {
            guard section != .alwaysHidden || appState.menuBarManager.section(withName: .alwaysHidden)?.isEnabled == true else { continue }
            let desired = entries.filter { $0.section == String(describing: section) }
                .compactMap { entry in identified[entry.key].map { (entry.key, $0) } }
            guard !desired.isEmpty else { continue }
            let live = MenuBarItem.getMenuBarItems(onScreenOnly: false, activeSpaceOnly: true)
            let dividerInfo: MenuBarItemInfo = section == .alwaysHidden ? .alwaysHiddenControlItem : .hiddenControlItem
            guard var anchor = live.first(where: { $0.info == dividerInfo }) else { continue }
            let ordered = section == .visible ? desired : desired.reversed().map { $0 }
            for (key, item) in ordered {
                guard !Task.isCancelled, choiceRevision == revision,
                      !MenuInteractionGuard.isInteracting else { return }
                // 顺序正确的存活邻项作锚点；只移动重建项，避免拉动整组状态项。
                if recreated.contains(key), item.isMovable, section == .visible || item.canBeHidden {
                    let destination: MenuBarItemManager.MoveDestination = section == .visible
                        ? .rightOfItem(anchor) : .leftOfItem(anchor)
                    do {
                        try await manager.move(item: item, to: destination)
                    } catch {
                        Logger.layoutStore.error("Layout restore failed for \(item.logString): \(error)")
                    }
                }
                anchor = item
            }
        }
    }
}

private extension Logger {
    static let layoutStore = Logger(category: "MenuBarLayoutStore")
}
