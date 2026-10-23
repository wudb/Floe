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

    struct RestoreResult {
        var restored = 0
        var remaining = 0
        var wasInterrupted = false
    }

    /// PID 与窗口 ID 一起使用，避免宿主退出后窗口编号复用被误判为原项目。
    private struct ObservedItem: Equatable {
        let windowID: UInt32
        let ownerPID: Int32

        init(_ item: MenuBarItem) {
            windowID = item.windowID
            ownerPID = item.ownerPID
        }
    }

    private static let defaultsKey = "MenuBarLayoutChoices.v1"
    private var entries: [Entry]
    private var observedWindows = [String: ObservedItem]()
    private var pendingKeys = Set<String>()
    private var isRestoring = false
    private var choiceRevision = 0
    private var retryAfter = Date.distantPast
    private(set) var appliedRevision = 0
    var isApplyingChoices: Bool { isRestoring }
    var hasSavedLayout: Bool { !entries.isEmpty }
    var revision: Int { choiceRevision }
    private(set) var isSavedLayoutValid = true

    init() {
        entries = []
        guard let data = UserDefaults.standard.data(forKey: Self.defaultsKey) else { return }
        guard let decoded = try? JSONDecoder().decode([Entry].self, from: data),
              decoded.allSatisfy({ !$0.key.isEmpty && ["visible", "hidden", "alwaysHidden"].contains($0.section) }),
              Set(decoded.map(\.key)).count == decoded.count else {
            // 损坏的记录原样保留，后台初始化和规则同步不能静默覆盖用户的数据。
            isSavedLayoutValid = false
            return
        }
        entries = decoded
    }

    /// 单状态项以 bundle 为稳定身份；多状态项必须有唯一且非占位的标识。
    func identifiedItems(_ items: [MenuBarItem]) -> [String: MenuBarItem] {
        let windowCounts = Dictionary(grouping: items, by: \.windowID)
        let groups = Dictionary(grouping: items.filter { $0.info.namespace != .floe && windowCounts[$0.windowID]?.count == 1 }) {
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
        // 暂时退出的宿主保留分区与相对锚点；不能一律追加到末尾而丢失原顺序。
        let present = Set(next.map(\.key))
        for (index, entry) in entries.enumerated().reversed() where !present.contains(entry.key) {
            let following = entries.dropFirst(index + 1).first { $0.section == entry.section && next.contains($0) }
            if let following, let insertion = next.firstIndex(of: following) {
                next.insert(entry, at: insertion)
            } else if let last = next.lastIndex(where: { $0.section == entry.section }) {
                next.insert(entry, at: last + 1)
            } else {
                next.append(entry)
            }
        }
        entries = next
        isSavedLayoutValid = true
        saveEntries()
        pendingKeys.subtract(present)
        observedWindows = identified.mapValues(ObservedItem.init)
    }

    func hasChoice(for key: String) -> Bool { entries.contains { $0.key == key } }

    /// 为升级前已有项目建立基线，保留此前保存的用户选择和退出宿主记录。
    func seedMissingChoices(_ cache: MenuBarItemManager.ItemCache) {
        guard isSavedLayoutValid else { return }
        var changed = false
        let identified = identifiedItems(cache.allItems)
        for section in MenuBarSection.Name.allCases {
            for item in cache[section].sorted(by: { $0.frame.minX < $1.frame.minX }) {
                if let key = identified.first(where: { $0.value.windowID == item.windowID })?.key, !hasChoice(for: key) {
                    entries.append(Entry(key: key, section: String(describing: section)))
                    observedWindows[key] = ObservedItem(item)
                    changed = true
                }
            }
        }
        if changed { saveEntries() }
    }

    /// 新项/显式规则选择进入既有恢复管线，复用菜单保护、失败退避和用户操作取消。
    func assign(key: String, section: String, atEnd: Bool) {
        guard isSavedLayoutValid, ["visible", "hidden", "alwaysHidden"].contains(section) else { return }
        // 同一待恢复规则不重置退避，也不改变同区其他项目的相对顺序。
        if entries.contains(where: { $0.key == key && $0.section == section }), pendingKeys.contains(key) { return }
        choiceRevision += 1
        entries.removeAll { $0.key == key }
        let entry = Entry(key: key, section: section)
        if atEnd { entries.append(entry) } else { entries.insert(entry, at: 0) }
        observedWindows.removeValue(forKey: key)
        pendingKeys.insert(key)
        saveEntries()
    }

    private static let importBackupKey = "MenuBarLayoutImportBackup.v1"

    var hasImportBackup: Bool { UserDefaults.standard.data(forKey: Self.importBackupKey) != nil }

    /// 一次写入整批导入；未提及应用保留原分区与相对顺序，导入项目按源顺序排在本区开头，避免以不可移动的时钟作为插入锚点。
    @discardableResult
    func importEntries(_ incoming: [Entry]) -> Bool {
        guard isSavedLayoutValid, !incoming.isEmpty,
              incoming.allSatisfy({ !$0.key.isEmpty && ["visible", "hidden", "alwaysHidden"].contains($0.section) }),
              Set(incoming.map(\.key)).count == incoming.count,
              let backup = try? JSONEncoder().encode(entries) else { return false }
        let keys = Set(incoming.map(\.key))
        let next = incoming + entries.filter { !keys.contains($0.key) }
        guard let encoded = try? JSONEncoder().encode(next) else { return false }
        UserDefaults.standard.set(backup, forKey: Self.importBackupKey)
        UserDefaults.standard.set(encoded, forKey: Self.defaultsKey)
        entries = next
        observedWindows = [:]
        requestRestore()
        return true
    }

    /// 回退同样经由恢复管线，备份跨重启保留；不把导入后的扫描结果覆盖为备份。
    @discardableResult
    func undoImport() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: Self.importBackupKey),
              let previous = try? JSONDecoder().decode([Entry].self, from: data),
              previous.allSatisfy({ !$0.key.isEmpty && ["visible", "hidden", "alwaysHidden"].contains($0.section) }),
              Set(previous.map(\.key)).count == previous.count else { return false }
        entries = previous
        isSavedLayoutValid = true
        UserDefaults.standard.set(data, forKey: Self.defaultsKey)
        observedWindows = [:]
        pendingKeys = []
        requestRestore()
        return true
    }

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) { UserDefaults.standard.set(data, forKey: Self.defaultsKey) }
    }

    /// 用户开始原生拖拽后淘汰尚未执行的自动恢复步骤。
    func cancelPendingRestore() {
        choiceRevision += 1
    }

    /// 唤醒、显示器变化和显式恢复都复用当前保存的选择，不把异常布局保存为新基线。
    func requestRestore() {
        cancelPendingRestore()
        pendingKeys.formUnion(entries.map(\.key))
        retryAfter = .distantPast
    }

    /// 用户取消显式恢复后不在后台继续该批操作，保存的布局仍留待下次请求。
    func cancelExplicitRestore() {
        cancelPendingRestore()
        pendingKeys.removeAll()
    }

    /// 只对首次观察/窗口重建执行恢复；正常扫描不不断覆盖用户的原生拖拽。
    @discardableResult
    func restoreIfNeeded(manager: MenuBarItemManager) async -> RestoreResult {
        let identified = identifiedItems(manager.itemCache.allItems)
        let recreated = Set(identified.compactMap { key, item in
            observedWindows[key] != ObservedItem(item) ? key : nil
        })
        pendingKeys.formUnion(Set(entries.map(\.key)).intersection(recreated))
        // 记录发现与记录完成分开；取消和超时均保留待办，下一轮仍可继续。
        observedWindows = identified.mapValues(ObservedItem.init)
        var result = RestoreResult(remaining: pendingKeys.intersection(identified.keys).count)
        guard !isRestoring, !entries.isEmpty, Date() >= retryAfter, !Task.isCancelled,
              !manager.isMovingItem, !manager.isEditingLayout, !manager.mouseHasRecentlyMoved, !manager.hasTemporarilyShownItems,
              let appState = manager.appState,
              !MenuInteractionGuard.isInteracting
        else { return result }
        guard result.remaining > 0 else { return result }
        isRestoring = true
        let revision = choiceRevision
        defer {
            isRestoring = false
            if choiceRevision == revision, !pendingKeys.isDisjoint(with: identified.keys), !Task.isCancelled {
                retryAfter = Date().addingTimeInterval(30)
            }
        }
        for section in MenuBarSection.Name.allCases {
            guard section != .alwaysHidden || appState.menuBarManager.section(withName: .alwaysHidden)?.isEnabled == true else {
                // 暂时禁用分区不等于已完成；保留选择，重新启用后再恢复。
                continue
            }
            let desired = entries.filter { $0.section == String(describing: section) }
                .compactMap { entry in identified[entry.key].map { (entry.key, $0) } }
            guard !desired.isEmpty else { continue }
            let live = MenuBarItem.getMenuBarItems(onScreenOnly: false, activeSpaceOnly: true)
            let dividerInfo: MenuBarItemInfo = section == .alwaysHidden ? .alwaysHiddenControlItem : .hiddenControlItem
            guard var anchor = live.first(where: { $0.info == dividerInfo }) else { continue }
            let ordered = section == .visible ? desired : desired.reversed().map { $0 }
            for (key, original) in ordered {
                guard !Task.isCancelled, choiceRevision == revision,
                      !MenuInteractionGuard.isInteracting, !manager.isEditingLayout else {
                    result.wasInterrupted = true
                    result.remaining = pendingKeys.intersection(identified.keys).count
                    return result
                }
                // 每次移动都重新解析项目，不能在 await 后使用已退出或重建宿主的旧引用。
                let current = MenuBarItem.getMenuBarItems(onScreenOnly: false, activeSpaceOnly: true)
                guard let item = identifiedItems(current)[key], ObservedItem(item) == ObservedItem(original) else { continue }
                if pendingKeys.contains(key) {
                    let destination: MenuBarItemManager.MoveDestination = section == .visible
                        ? .rightOfItem(anchor) : .leftOfItem(anchor)
                    // 系统保护项若已在正确位置，无需移动，也不能永远阻塞后续可移动项。
                    if (try? manager.itemHasCorrectPosition(item: item, for: destination)) == true {
                        pendingKeys.remove(key)
                        anchor = item
                        continue
                    }
                    guard item.isMovable, section == .visible || item.canBeHidden else { break }
                    do {
                        let target = anchor
                        try await manager.move(item: item, to: destination, beforePostingEvents: {
                            // 等待用户松开鼠标后再校验一次，旧恢复不能覆盖新的拖拽、规则或屏幕环境。
                            guard self.choiceRevision == revision, !manager.isEditingLayout,
                                  !manager.hasTemporarilyShownItems, !MenuInteractionGuard.isInteracting else { throw CancellationError() }
                            let latest = MenuBarItem.getMenuBarItems(onScreenOnly: false, activeSpaceOnly: true)
                            guard let source = self.identifiedItems(latest)[key], ObservedItem(source) == ObservedItem(item),
                                  latest.contains(where: { $0.windowID == target.windowID && $0.ownerPID == target.ownerPID && $0.info == target.info })
                            else { throw CancellationError() }
                        })
                        guard choiceRevision == revision, !Task.isCancelled else {
                            result.wasInterrupted = true
                            result.remaining = pendingKeys.intersection(identified.keys).count
                            return result
                        }
                        appliedRevision += 1
                        result.restored += 1
                        pendingKeys.remove(key)
                    } catch {
                        Logger.layoutStore.error("Layout restore failed for \(item.logString): \(error)")
                        if Task.isCancelled || choiceRevision != revision {
                            result.wasInterrupted = true
                            result.remaining = pendingKeys.intersection(identified.keys).count
                            return result
                        }
                        // 当前锚点未到位，不能让后面的项目跟着它进入错误分区。
                        break
                    }
                } else {
                    let hidden = current.first(where: { $0.info == .hiddenControlItem })
                    let alwaysHidden = current.first(where: { $0.info == .alwaysHiddenControlItem })
                    let inSection: Bool
                    switch section {
                    case .visible: inSection = hidden.map { item.frame.minX >= $0.frame.maxX } ?? false
                    case .hidden: inSection = hidden.map { item.frame.maxX <= $0.frame.minX } == true && (alwaysHidden.map { item.frame.minX >= $0.frame.maxX } ?? true)
                    case .alwaysHidden: inSection = alwaysHidden.map { item.frame.maxX <= $0.frame.minX } ?? false
                    }
                    guard inSection else { continue }
                }
                anchor = item
            }
        }
        result.remaining = pendingKeys.intersection(identified.keys).count
        return result
    }
}

private extension Logger {
    static let layoutStore = Logger(category: "MenuBarLayoutStore")
}
