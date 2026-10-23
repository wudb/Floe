//
//  LayoutImportPlan.swift
//  Floe
//

import Foundation

/// 预览与提交共用纯值匹配，提交前必须用新快照重新验证，拒绝 PID、窗口序号等不稳定身份。
struct LayoutImportPlan {
    struct AvailableItem: Equatable {
        let key: String
        let bundleIdentifier: String
        let title: String
        let isMovable: Bool
        let canBeHidden: Bool
        let alwaysShown: Bool
    }

    struct Row: Identifiable {
        var id: UUID { item.id }
        let item: LayoutImportDocument.Item
        let key: String?
        let status: String
    }

    let rows: [Row]

    init(items: [LayoutImportDocument.Item], available: [AvailableItem], knownBundles: Set<String>, alwaysShownBundles: Set<String> = []) {
        let groups = Dictionary(grouping: available, by: \.bundleIdentifier)
        let bundles = knownBundles.union(groups.keys)
        let provisional = items.map { item -> Row in
            let raw = item.identity.trimmingCharacters(in: .whitespacesAndNewlines)
            let exact = available.first { $0.key == raw }
            let bundle = exact?.bundleIdentifier ?? bundles.filter { raw == $0 || raw.hasPrefix($0 + "-") }
                .max { $0.count < $1.count }
            guard let bundle = bundle ?? (LayoutImportDocument.isBundleIdentifier(raw) && !raw.contains("-Item-") ? raw : nil),
                  !["com.float.floe", "com.jordanbaird.Ice", "com.HyperartFlow.Barbee", "com.appit.ExtraBar"].contains(bundle),
                  !bundle.hasPrefix("com.surteesstudios.Bartender") else {
                return Row(item: item, key: nil, status: "Unrecognized app identity; skipped")
            }
            if item.section != .visible, alwaysShownBundles.contains(bundle) {
                return Row(item: item, key: nil, status: "Conflicts with Always Visible app rule; skipped")
            }
            let siblings = groups[bundle, default: []]
            let token = raw.hasPrefix(bundle + "-") ? String(raw.dropFirst(bundle.count + 1)) : nil
            let matchingTitle = token.flatMap { title in siblings.first { $0.title == title && !title.hasPrefix("Item-") } }
            // 同一应用仅一个图标时按应用迁移；多个图标必须能精确匹配稳定标题。
            let match = exact ?? matchingTitle ?? (siblings.count == 1 ? siblings.first : nil)
            if let match {
                guard !match.key.isEmpty else {
                    return Row(item: item, key: nil, status: "Multiple icons cannot be identified uniquely; skipped")
                }
                guard match.isMovable, item.section == .visible || match.canBeHidden else {
                    return Row(item: item, key: nil, status: "Protected system item; skipped")
                }
                guard item.section == .visible || !match.alwaysShown else {
                    return Row(item: item, key: nil, status: "Conflicts with Always Visible app rule; skipped")
                }
                return Row(item: item, key: match.key, status: "Matched")
            }
            guard siblings.isEmpty else { return Row(item: item, key: nil, status: "Multiple icons cannot be identified uniquely; skipped") }
            guard bundle != "com.apple.controlcenter", bundle != "com.apple.systemuiserver" else {
                return Row(item: item, key: nil, status: "Protected or unavailable system item; skipped")
            }
            return Row(item: item, key: bundle, status: "App is unavailable; keep layout pending")
        }
        let counts = Dictionary(grouping: provisional.compactMap(\.key), by: { $0 }).mapValues(\.count)
        rows = provisional.map { row in
            guard let key = row.key, counts[key, default: 0] > 1 else { return row }
            return Row(item: row.item, key: nil, status: "Duplicate or conflicting app entries; skipped")
        }
    }
}
