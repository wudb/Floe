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
    private var retryAfter = Date.distantPast
    private(set) var appliedRevision = 0
    var isApplyingChoices: Bool { isRestoring }

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

    func hasChoice(for key: String) -> Bool { entries.contains { $0.key == key } }

    /// 为升级前已有项目建立基线，保留此前保存的用户选择和退出宿主记录。
    func seedMissingChoices(_ cache: MenuBarItemManager.ItemCache) {
        var changed = false
        let identified = identifiedItems(cache.allItems)
        for section in MenuBarSection.Name.allCases {
            for item in cache[section].sorted(by: { $0.frame.minX < $1.frame.minX }) {
                if let key = identified.first(where: { $0.value.windowID == item.windowID })?.key, !hasChoice(for: key) {
                    entries.append(Entry(key: key, section: String(describing: section)))
                    observedWindows[key] = item.windowID
                    changed = true
                }
            }
        }
        if changed { saveEntries() }
    }

    /// 新项/显式规则选择进入既有恢复管线，复用菜单保护、失败退避和用户操作取消。
    func assign(key: String, section: String, atEnd: Bool) {
        guard ["visible", "hidden", "alwaysHidden"].contains(section) else { return }
        // 同一待恢复规则不重置退避，也不改变同区其他项目的相对顺序。
        if entries.contains(where: { $0.key == key && $0.section == section }), observedWindows[key] == nil { return }
        choiceRevision += 1
        entries.removeAll { $0.key == key }
        let entry = Entry(key: key, section: section)
        if atEnd { entries.append(entry) } else { entries.insert(entry, at: 0) }
        observedWindows.removeValue(forKey: key)
        saveEntries()
    }

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) { UserDefaults.standard.set(data, forKey: Self.defaultsKey) }
    }

    /// 用户开始原生拖拽后淘汰尚未执行的自动恢复步骤。
    func cancelPendingRestore() {
        choiceRevision += 1
    }

    /// 只对首次观察/窗口重建执行恢复；正常扫描不不断覆盖用户的原生拖拽。
    func restoreIfNeeded(manager: MenuBarItemManager) async {
        guard !isRestoring, !entries.isEmpty, Date() >= retryAfter,
              !manager.isMovingItem, !manager.isEditingLayout, !manager.mouseHasRecentlyMoved, !manager.hasTemporarilyShownItems,
              let appState = manager.appState,
              !MenuInteractionGuard.isInteracting
        else { return }
        let identified = identifiedItems(manager.itemCache.allItems)
        let recreated = Set(identified.compactMap { key, item in
            observedWindows[key] != item.windowID ? key : nil
        })
        // 即使没有新项也记录退出，防止宿主重新出现时复用相同窗口 ID 而漏恢复。
        observedWindows = identified.mapValues(\.windowID)
        guard !recreated.isEmpty else { return }
        isRestoring = true
        let revision = choiceRevision
        var pending = Set(entries.map(\.key)).intersection(recreated)
        defer {
            isRestoring = false
            if choiceRevision == revision, !pending.isEmpty {
                // 失败不是“已恢复”；退避后重试，不在每次扫描中反复操纵鼠标。
                for key in pending { observedWindows.removeValue(forKey: key) }
                retryAfter = Date().addingTimeInterval(30)
            }
        }
        for section in MenuBarSection.Name.allCases {
            guard section != .alwaysHidden || appState.menuBarManager.section(withName: .alwaysHidden)?.isEnabled == true else {
                for entry in entries where entry.section == "alwaysHidden" { pending.remove(entry.key) }
                continue
            }
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
                        appliedRevision += 1
                        pending.remove(key)
                    } catch {
                        Logger.layoutStore.error("Layout restore failed for \(item.logString): \(error)")
                        continue
                    }
                } else {
                    pending.remove(key)
                }
                anchor = item
            }
        }
    }
}

private extension Logger {
    static let layoutStore = Logger(category: "MenuBarLayoutStore")
}
