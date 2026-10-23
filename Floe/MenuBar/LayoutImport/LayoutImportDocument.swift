//
//  LayoutImportDocument.swift
//  Floe
//

import Foundation

/// 第三方配置只提取应用身份与顺序；解析阶段不访问偏好、不执行脚本、不移动图标。
struct LayoutImportDocument {
    enum Source: String, CaseIterable {
        case ice = "Ice", barbee = "Barbee", extraBar = "ExtraBar", bartender = "Bartender"
    }

    enum Section: String, CaseIterable, Codable {
        case visible, hidden, alwaysHidden

        var title: String {
            switch self {
            case .visible: "Visible"
            case .hidden: "Hidden"
            case .alwaysHidden: "Always Hidden"
            }
        }
    }

    struct Item: Identifiable, Equatable {
        let id: UUID
        let identity: String
        var section: Section

        init(identity: String, section: Section) {
            id = UUID()
            self.identity = identity
            self.section = section
        }
    }

    /// 未公开格式的导出文件需要用户选择具体有序列表及目标分区，不能猜测字段含义。
    struct List: Identifiable {
        var id: String { path }
        let path: String
        let identities: [String]
        let omittedCount: Int
    }

    enum Failure: String, Error {
        case tooLarge = "The configuration is too large. Choose a file smaller than 10 MB."
        case tooMany = "The preview supports up to 2,000 app entries. Clear it before adding another list."
        case damagedLayout = "The saved layout is damaged. It has been preserved; organize items manually to save a new layout."
        case invalid = "This file is not a readable JSON or property list configuration."
        case noLayout = "No supported app list was found. Choose an export containing app bundle identifiers."
        case iceNotFound = "Ice's original dividers could not be read. Keep Ice running and allow menu bar discovery, then capture again."
        case icePreferences = "Ice preferences do not contain icon layouts. Use Capture Ice Layout while Ice is running."
        case bartenderProfile = "This Bartender file has no supported active profile. Choose its preferences plist or use an app list from an export."
        case busy = "Close menus and finish moving items before importing a layout."
        case discoveryUnavailable = "Layout import requires native menu bar discovery. Check permissions; Accessibility-only mode is not supported."
        case stale = "The layout changed. Refresh the preview before importing."
        case invalidSelection = "No unambiguous, eligible layout items are selected."
    }

    let items: [Item]
    let lists: [List]

    static func read(_ data: Data, source: Source) throws -> Self {
        guard data.count <= 10 * 1024 * 1024 else { throw Failure.tooLarge }
        let object: Any
        if let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) {
            object = json
        } else if let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) {
            object = plist
        } else {
            throw Failure.invalid
        }
        if source == .ice { throw Failure.icePreferences }
        if source == .bartender, let root = object as? [String: Any],
           let profiles = root["ProfileSettings"] as? [String: Any],
           let profile = profiles["activeProfile"] as? [String: Any] {
            var items = [Item]()
            for (field, section) in [("Show", Section.visible), ("Hide", .hidden), ("AlwaysHide", .alwaysHidden)] {
                guard let value = profile[field] else { continue }
                guard let values = value as? [String], values.count <= 2_000 else { throw Failure.invalid }
                items += values.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    .map { Item(identity: $0, section: section) }
            }
            guard !items.isEmpty else { throw Failure.noLayout }
            guard items.count <= 2_000 else { throw Failure.tooMany }
            return Self(items: items, lists: [])
        }
        var lists = [List]()
        var budget = 20_000
        collectLists(object, path: "$", depth: 0, budget: &budget, into: &lists)
        guard !lists.isEmpty else { throw source == .bartender ? Failure.bartenderProfile : Failure.noLayout }
        return Self(items: [], lists: lists)
    }

    static func isBundleIdentifier(_ value: String) -> Bool {
        value.count <= 255 && value.range(of: "^[A-Za-z0-9_-]+(?:\\.[A-Za-z0-9_-]+)+$", options: .regularExpression) != nil
    }

    /// 只展示有序数组中的显式应用字段；不从 URL、命令、任意文本或无序字典推导顺序。
    private static func collectLists(_ object: Any, path: String, depth: Int, budget: inout Int, into lists: inout [List]) {
        guard depth <= 12, budget > 0, lists.count < 100 else { return }
        budget -= 1
        if let array = object as? [Any] {
            guard array.count <= 2_000 else { return }
            if let strings = array as? [String], !strings.isEmpty, strings.allSatisfy(isBundleIdentifier) {
                lists.append(List(path: path, identities: strings, omittedCount: 0))
            } else {
                let fields = ["bundleIdentifier", "bundleID", "bundleId", "appBundleIdentifier"]
                for field in fields {
                    let identities = array.compactMap { ($0 as? [String: Any])?[field] as? String }
                        .filter(isBundleIdentifier)
                    if !identities.isEmpty {
                        lists.append(List(path: path + "." + field, identities: identities, omittedCount: array.count - identities.count))
                    }
                }
                for (index, child) in array.enumerated() {
                    collectLists(child, path: path + "[\(index)]", depth: depth + 1, budget: &budget, into: &lists)
                }
            }
        } else if let dictionary = object as? [String: Any] {
            for key in dictionary.keys.sorted() {
                if let child = dictionary[key] {
                    collectLists(child, path: path + "." + key, depth: depth + 1, budget: &budget, into: &lists)
                }
            }
        } else if let data = object as? Data, data.count < 10 * 1024 * 1024,
                  let child = try? JSONSerialization.jsonObject(with: data) {
            collectLists(child, path: path + " (JSON)", depth: depth + 1, budget: &budget, into: &lists)
        }
    }
}
