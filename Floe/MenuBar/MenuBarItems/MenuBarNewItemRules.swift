//
//  MenuBarNewItemRules.swift
//  Floe
//

import Combine
import Foundation

/// 新项规则只记录稳定身份；不会把窗口 ID、临时展开或身份不明的同名项保存为规则。
@MainActor
final class MenuBarNewItemRules: ObservableObject {
    enum Destination: String, CaseIterable {
        case visible, hidden, alwaysHidden, system

        var title: String {
            switch self {
            case .visible: "Visible"
            case .hidden: "Hidden"
            case .alwaysHidden: "Always Hidden"
            case .system: "Keep system placement"
            }
        }
    }

    private struct State: Codable {
        var destination = Destination.visible.rawValue
        var insertAtEnd = true
        var seen = Set<String>()
        var hasBaseline = false
        var visibleApplications = Set<String>()
    }

    private static let key = "MenuBarNewItemRules.v1"
    private var state: State
    @Published private(set) var revision = 0

    init() {
        state = UserDefaults.standard.data(forKey: Self.key)
            .flatMap { try? JSONDecoder().decode(State.self, from: $0) } ?? State()
    }

    var destination: Destination {
        get { Destination(rawValue: state.destination) ?? .visible }
        set { state.destination = newValue.rawValue; save() }
    }

    var insertAtEnd: Bool {
        get { state.insertAtEnd }
        set { state.insertAtEnd = newValue; save() }
    }

    var alwaysVisibleApplications: Set<String> { state.visibleApplications }

    func alwaysShows(_ bundle: String) -> Bool { state.visibleApplications.contains(bundle) }

    func setAlwaysShown(_ bundle: String, enabled: Bool) {
        guard !bundle.isEmpty, bundle != "<null>", bundle != "com.float.floe" else { return }
        if enabled { state.visibleApplications.insert(bundle) } else { state.visibleApplications.remove(bundle) }
        save()
    }

    /// 初次接入仅记住当前布局，不把升级前的所有图标当作新安装应用搬动。
    /// 应用规则优先于已保存的单项位置；取消规则后保留当前布局，后续仍可手动整理。
    func prepare(cache: MenuBarItemManager.ItemCache, store: MenuBarLayoutStore, alwaysHiddenEnabled: Bool) {
        guard !cache.allItems.isEmpty else { return }
        let identified = store.identifiedItems(cache.allItems)
        let previousSeen = state.seen
        let hadBaseline = state.hasBaseline
        if !state.hasBaseline {
            store.seedMissingChoices(cache)
            state.seen.formUnion(identified.keys)
            state.hasBaseline = true
        }
        let ordered = identified.sorted {
            if $0.value.frame.minX != $1.value.frame.minX { return $0.value.frame.minX < $1.value.frame.minX }
            return $0.key < $1.key
        }
        // 同一批新项保持原生相对顺序；向开头插入时逆序提交，避免整批倒置。
        for (key, item) in state.insertAtEnd ? ordered : ordered.reversed().map({ $0 }) {
            let bundle = item.info.namespace.rawValue
            // 单状态项变为多状态项时身份形态会改变，不能把旧项误认作首次安装。
            let isKnownHost = key != bundle && (state.seen.contains(bundle) || store.hasChoice(for: bundle))
            let isNew = !isKnownHost && !state.seen.contains(key) && !store.hasChoice(for: key)
            if alwaysShows(item.info.namespace.rawValue) {
                // 已在可见区的项不反复触发移动；重建和真实跨区变化才需要恢复。
                if !cache[.visible].contains(where: { $0.windowID == item.windowID }) {
                    store.assign(key: key, section: "visible", atEnd: state.insertAtEnd)
                }
            } else if isNew, destination != .system {
                let section = destination == .alwaysHidden && !alwaysHiddenEnabled ? "hidden" : destination.rawValue
                store.assign(key: key, section: section, atEnd: state.insertAtEnd)
            }
        }
        // 保留系统位置的项也作为后续首尾插入的存活锚点，但本轮不移动它。
        store.seedMissingChoices(cache)
        state.seen.formUnion(identified.keys)
        if previousSeen != state.seen || !hadBaseline { save(notify: false) }
    }

    /// 明确用户操作才迁移当前项目；默认规则改变本身不重排既有布局。
    func showExistingItems(cache: MenuBarItemManager.ItemCache, store: MenuBarLayoutStore) {
        let ordered = store.identifiedItems(cache.allItems).sorted {
            if $0.value.frame.minX != $1.value.frame.minX { return $0.value.frame.minX < $1.value.frame.minX }
            return $0.key < $1.key
        }
        for (key, item) in ordered where item.isMovable {
            store.assign(key: key, section: "visible", atEnd: true)
        }
    }

    private func save(notify: Bool = true) {
        if let data = try? JSONEncoder().encode(state) { UserDefaults.standard.set(data, forKey: Self.key) }
        if notify { revision += 1 }
    }
}
