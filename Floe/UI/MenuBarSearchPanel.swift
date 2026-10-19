//
//  MenuBarSearchPanel.swift
//  Floe
//

import Cocoa
import SwiftUI

/// 独立检索入口，保留键盘焦点；AX 与 CGS 两种发现结果共用列表。
@MainActor
final class MenuBarSearchPanel: NSPanel {
    private weak var appState: AppState?

    init(appState: AppState) {
        self.appState = appState
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 360),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        title = L10n.string("Search menu bar items")
        isReleasedWhenClosed = false
        level = .floating
        collectionBehavior = [.fullScreenAuxiliary, .moveToActiveSpace]
    }

    func show() {
        guard let appState else { return }
        contentView = NSHostingView(rootView: MenuBarSearchView(appState: appState) { [weak self] in
            self?.close()
        }.appLanguage().appAppearance())
        center()
        appState.activate(withPolicy: NSApp.activationPolicy(), usingDock: false)
        makeKeyAndOrderFront(nil)
    }

    override func close() {
        super.close()
        // 销毁视图取消其扫描任务，迟到结果不能留到下次打开。
        contentView = nil
    }
}

private struct MenuBarSearchView: View {
    enum Target {
        case ax(MenuBarItemAXDiscovery.AXMenuBarItem)
        case cgs(MenuBarItem)
    }

    struct Row: Identifiable {
        let id: String
        let name: String
        let detail: String
        let icon: NSImage?
        let target: Target
    }

    let appState: AppState
    let closePanel: () -> Void
    @State private var query = ""
    @State private var rows = [Row]()
    @State private var isLoading = true
    @State private var selectedID: String?
    @FocusState private var isFocused: Bool

    private var matches: [Row] {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return rows.filter {
            text.isEmpty || $0.name.localizedStandardContains(text) || $0.detail.localizedStandardContains(text)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            TextField("Search menu bar items", text: $query)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .onSubmit {
                    if let row = matches.first(where: { $0.id == selectedID }) ?? matches.first { activate(row) }
                }
                .onKeyPress(keys: [.upArrow, .downArrow]) { press in
                    guard press.modifiers.isDisjoint(with: [.control, .command, .option]) else { return .ignored }
                    moveSelection(press.key == .upArrow ? -1 : 1)
                    return .handled
                }
                .onKeyPress(characters: CharacterSet(charactersIn: "np")) { press in
                    guard press.modifiers.intersection([.control, .command, .option]) == .control else { return .ignored }
                    moveSelection(press.characters == "p" ? -1 : 1)
                    return .handled
                }
            if isLoading && rows.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if matches.isEmpty {
                Text("No matching menu bar items")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(matches) { row in
                                Button { activate(row) } label: {
                                    HStack(spacing: 10) {
                                        if let icon = row.icon {
                                            Image(nsImage: icon).resizable().scaledToFit().frame(width: 24, height: 24)
                                        } else {
                                            Image(systemName: "menubar.rectangle").frame(width: 24, height: 24)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(row.name)
                                            Text(row.detail).font(.caption).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(8)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .accessibilityValue(row.id == selectedID ? L10n.string("Selected") : "")
                                .background(row.id == selectedID ? Color.accentColor.opacity(0.18) : .clear, in: RoundedRectangle(cornerRadius: 6))
                                .id(row.id)
                            }
                        }
                    }
                    .onChange(of: selectedID) { _, id in
                        if let id { proxy.scrollTo(id) }
                    }
                }
            }
        }
        .padding(16)
        .frame(width: 480, height: 360)
        .onChange(of: matches.map(\.id)) { _, ids in
            if !ids.contains(selectedID ?? "") { selectedID = ids.first }
        }
        .onExitCommand(perform: closePanel)
        .task {
            isFocused = true
            await refresh()
            while !Task.isCancelled {
                do { try await Task.sleep(for: .seconds(5)) } catch { return }
                await refresh()
            }
        }
    }

    /// AX 名称优先；CGS 补入没有 AX 节点的项目，几何去重不合并同名兄弟项。
    private func refresh() async {
        await appState.itemManager.cacheItemsIfNeeded()
        let apps = NSWorkspace.shared.runningApplications
        let axItems = await Task.detached(priority: .userInitiated) {
            MenuBarItemAXDiscovery.isTrusted() ? MenuBarItemAXDiscovery.discoverItems(in: apps) : []
        }.value
        guard !Task.isCancelled else { return }
        var next = axItems.map { item in
            Row(
                id: "ax:\(item.pid):\(CFHash(item.element))",
                name: item.displayName,
                detail: item.bundleID ?? item.appName,
                icon: NSRunningApplication(processIdentifier: item.pid)?.icon,
                target: .ax(item)
            )
        }
        for item in appState.itemManager.itemCache.allItems where item.info.namespace != .floe {
            let duplicate = axItems.contains { ax in
                guard let frame = ax.axFrame else { return false }
                return abs(frame.midX - item.frame.midX) < 2 && abs(frame.midY - item.frame.midY) < 2
            }
            guard !duplicate else { continue }
            next.append(Row(
                id: "cgs:\(item.windowID)",
                name: item.displayName,
                detail: item.owningApplication?.bundleIdentifier ?? item.ownerName ?? "",
                icon: item.owningApplication?.icon,
                target: .cgs(item)
            ))
        }
        rows = next.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        isLoading = false
    }

    private func moveSelection(_ offset: Int) {
        selectedID = MenuBarListSelection.moving(selectedID, in: matches.map(\.id), by: offset)
    }

    private func activate(_ row: Row) {
        closePanel()
        switch row.target {
        case .ax(let item):
            appState.menuBarManager.floeBarPanel.activateAXItem(item)
        case .cgs(let item):
            appState.itemManager.tempShowItem(item, clickWhenFinished: true, mouseButton: .left)
        }
    }
}

/// 搜索选择只保存身份；刷新/过滤后重建索引，避免激活旧行或越界。
enum MenuBarListSelection {
    static func moving(_ current: String?, in ids: [String], by offset: Int) -> String? {
        guard !ids.isEmpty else { return nil }
        guard let current, let index = ids.firstIndex(of: current) else { return offset < 0 ? ids.last : ids.first }
        return ids[min(max(0, index + offset), ids.count - 1)]
    }
}
