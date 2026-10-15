//
//  MenuBarLayoutSettingsPane.swift
//  Floe
//

import Cocoa
import SwiftUI
import UniformTypeIdentifiers

struct MenuBarLayoutSettingsPane: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) private var openURL

    @State private var hasScreenRecordingPermission = ScreenCapture.cachedCheckPermissions()
    @State private var hasAccessibilityPermission = MenuBarItemAXDiscovery.isTrusted()
    @State private var sections = [MenuBarItemAXDiscovery.SectionKind: [RowItem]]()
    @State private var hiddenDividerX: CGFloat?
    @State private var alwaysHiddenDividerX: CGFloat?
    @State private var anchorY: CGFloat = 0
    /// Guards against overlapping Refreshes: stacked AX + CGS scans cause stutter.
    @State private var isRefreshing = false
    /// 异步扫描只能发布最新请求；离开页面后丢弃迟到结果。
    @State private var scanGeneration = 0
    /// CGS 无可展示项时保留最近 AX 快照，供缓存更新和分隔符重分类使用。
    @State private var axSnapshot = [MenuBarItemAXDiscovery.AXMenuBarItem]()
    /// Guards against overlapping drags: two concurrent Command-drags would fight over the mouse.
    @State private var isMoving = false
    /// 页面关闭时取消拖拽，迟到的 provider 回调不能再次占用鼠标。
    @State private var moveTask: Task<Void, Never>?
    @State private var isPageVisible = false
    @State private var pageGeneration = 0
    @State private var moveFailed = false
    @State private var searchText = ""
    @FocusState private var focusedItemID: String?
    /// IDs of icons currently being moved in the background: the UI updates
    /// optimistically right away, with a small badge on each icon showing
    /// it's syncing, so the whole list doesn't freeze.
    @State private var pendingMoves = Set<String>()
    /// Icon hovered during a drag: the blue outline shows dropping here inserts
    /// before it. Also lets the section know this drop already has an item
    /// handling it (so item and section don't both handle the same drop).
    @State private var dropTargetID: String?
    /// Generation counter for the divider poll: a new scan bumps it to cancel
    /// the previous poll, so only the latest scan keeps polling.
    @State private var dividerPollGeneration = 0
    /// App icons by PID: `NSRunningApplication.icon` is nil transiently on
    /// first lookup (app info not loaded yet) → gray box until the next
    /// Refresh. Caching successes keeps icons stable across re-classifies,
    /// and the retry below fills misses without manual taps.
    @State private var iconCache = [pid_t: NSImage]()
    /// Generation for the missing-icon retry: a new scan bumps it to cancel
    /// the previous retry, so only the latest scan keeps retrying.
    @State private var iconRetryGeneration = 0

    /// Floe 自身分隔符不会展示；仅有这些项不能阻止 AX fallback，否则布局会空白。
    private var displayableCachedItems: [MenuBarItem] {
        let ownBundleID = Bundle.main.bundleIdentifier
        return appState.itemManager.itemCache.allItems.filter {
            $0.owningApplication?.bundleIdentifier != ownBundleID
        }
    }

    private var totalCount: Int {
        sections.values.reduce(0) { $0 + $1.count }
    }

    /// Displayed groups: with "Enable always-hidden section" off in
    /// Advanced, the Always Hidden group stays hidden here too.
    private var visibleMetas: [SectionMeta] {
        if appState.settingsManager.advancedSettingsManager.enableAlwaysHiddenSection {
            SectionMeta.all
        } else {
            SectionMeta.all.filter { $0.kind != .alwaysHidden }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Menu Bar Icons")
                    .font(.title)
                Text("\(totalCount)")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.quaternary.opacity(0.6), in: Capsule())

                Spacer()

                Button {
                    Task {
                        await refresh()
                    }
                } label: {
                    if isRefreshing {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
                .buttonStyle(FloeButtonStyle())
                .disabled(isRefreshing)
            }

            NewItemRulesView(rules: appState.itemManager.newItemRules, manager: appState.itemManager)
            TextField("Search menu bar items", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .onExitCommand { searchText = "" }
            if moveFailed {
                Text("Could not move the menu bar item. Its actual position is shown; try again after closing menus.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            if sections.isEmpty {
                if !hasAccessibilityPermission {
                    accessibilityPrompt
                } else if !hasScreenRecordingPermission {
                    permissionPrompt
                } else if appState.itemManager.isItemDiscoveryUnavailable {
                    discoveryUnavailable
                } else {
                    ContentUnavailableView(
                        "No menu bar items",
                        systemImage: "rectangle.topthird.inset.filled",
                        description: Text("Waiting for menu bar items to appear…")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(visibleMetas, id: \.kind) { meta in
                            sectionView(meta: meta, items: filteredItems(in: meta.kind))
                        }
                        if hiddenDividerX == nil, alwaysHiddenDividerX == nil {
                            Text("Can't find Floe's section dividers — make sure the Hidden sections are enabled, then press Refresh.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(20)
        .task {
            pageGeneration += 1
            isPageVisible = true
            // Paint immediately from the available cache (the 5s background timer
            // keeps pumping itemCache), then reconcile with a background scan —
            // opening the tab shows icons right away, no Refresh tap needed.
            applySnapshotFromCache()
            await refresh()
            // AX-only 系统不会发布新的 CGS 项；页面可见期间持续发现新启动/退出的应用。
            while !Task.isCancelled {
                do {
                    try await Task.sleep(for: .seconds(5))
                } catch {
                    return
                }
                guard !isMoving else { continue }
                await refresh()
            }
        }
        .onReceive(appState.itemManager.$itemCache) { _ in
            // When the cache changes (background timer, newly opened app,
            // finished drag), the UI follows. While dragging, keep the
            // optimistic UI and let reconcile overwrite it.
            guard !isMoving else {
                return
            }
            applySnapshotFromCache()
        }
        .onDisappear {
            pageGeneration += 1
            isPageVisible = false
            moveTask?.cancel()
            scanGeneration += 1
            // Stop the divider poll + icon retry when leaving the tab.
            dividerPollGeneration += 1
            iconRetryGeneration += 1
        }
    }

    /// 名称、宿主和标识均可检索；不改变真实分区和排序快照。
    private func filteredItems(in kind: MenuBarItemAXDiscovery.SectionKind) -> [RowItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return (sections[kind] ?? []).filter {
            query.isEmpty || $0.title.localizedStandardContains(query) ||
                ($0.subtitle?.localizedStandardContains(query) ?? false)
        }
    }

    private func sectionView(meta: SectionMeta, items: [RowItem]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: meta.icon)
                Text(LocalizedStringKey(meta.title))
                    .font(.headline)
                Text(LocalizedStringKey(meta.subtitle))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            FlowLayout(spacing: 8) {

                if items.isEmpty {
                    Text(LocalizedStringKey(meta.emptyHint))
                        .font(.callout)
                        .foregroundStyle(.tertiary)
                        .padding(.vertical, 8)
                } else {
                    ForEach(items) { item in
                        itemView(item, pending: pendingMoves.contains(item.id), isDropTarget: dropTargetID == item.id)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .onDrop(of: [.text], isTargeted: .constant(false), perform: { providers in
                // When hovering an icon, let that item handle the drop (positional
                // insert); the section only handles drops into empty space (append to the group's end).
                guard dropTargetID == nil, !isMoving, let provider = providers.first else {
                    return false
                }
                let generation = pageGeneration
                _ = provider.loadObject(ofClass: NSString.self) { string, _ in
                    guard let id = string as? String else {
                        return
                    }
                    Task { @MainActor in
                        guard isPageVisible, pageGeneration == generation, !isMoving, moveTask == nil else { return }
                        moveTask = Task {
                            await drop(itemID: id, to: meta.kind)
                            moveTask = nil
                        }
                    }
                }
                return true
            })
        }
    }

    private func itemVisual(_ item: RowItem) -> some View {
        VStack(spacing: 3) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if let systemName = item.systemImage {
                        Image(systemName: systemName)
                            .font(.system(size: 17))
                            .frame(width: 40, height: 30)
                    } else if let icon = item.appIcon {
                        Image(nsImage: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .frame(width: 40, height: 30)
                    } else {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.quaternary)
                            .frame(width: 40, height: 30)
                    }
                }
                // System icons (com.apple.* bundles) get an extra Apple logo badge
                // at the top-right corner for distinction, as in the mock.
                if item.isSystem {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(width: 14, height: 14)
                        .background(.regularMaterial, in: Circle())
                        .offset(x: 5, y: -5)
                }
            }
            Text(item.title)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: 68)
        }
        .frame(width: 68)
    }

    private func accessibleItem(_ item: RowItem) -> some View {
        itemVisual(item)
        .focusable()
        .focused($focusedItemID, equals: item.id)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(item.title)
        .accessibilityValue(layoutDescription(for: item.id))
        .accessibilityHint(Text(LocalizedStringKey(item.isMovable ? "Use the actions menu to move this icon or change its section." : "This system item cannot be moved.")))
        .accessibilityAction(named: "Move to Visible") { moveWithKeyboard(item.id, to: .visible) }
        .accessibilityAction(named: "Move to Hidden") { moveWithKeyboard(item.id, to: .hidden) }
        .accessibilityAction(named: "Move to Always Hidden") { moveWithKeyboard(item.id, to: .alwaysHidden) }
        .accessibilityAction(named: "Move earlier") { reorderWithKeyboard(item.id, offset: -1) }
        .accessibilityAction(named: "Move later") { reorderWithKeyboard(item.id, offset: 1) }
        .onKeyPress(characters: CharacterSet(charactersIn: "123")) { press in
            guard press.modifiers.intersection([.command, .control, .option]) == .command else { return .ignored }
            let kind: MenuBarItemAXDiscovery.SectionKind = press.characters == "1" ? .visible : press.characters == "2" ? .hidden : .alwaysHidden
            moveWithKeyboard(item.id, to: kind)
            return .handled
        }
        .onKeyPress(keys: [.leftArrow, .rightArrow]) { press in
            guard press.modifiers.isDisjoint(with: [.control, .option]) else { return .ignored }
            let offset = press.key == .leftArrow ? -1 : 1
            if press.modifiers.contains(.command) {
                reorderWithKeyboard(item.id, offset: offset)
            } else {
                let ids = visibleMetas.flatMap { filteredItems(in: $0.kind).map(\.id) }
                if let index = ids.firstIndex(of: item.id), ids.indices.contains(index + offset) {
                    focusedItemID = ids[index + offset]
                }
            }
            return .handled
        }
    }

    @ViewBuilder
    private func itemActions(_ item: RowItem) -> some View {
        Button("Move to Visible") { moveWithKeyboard(item.id, to: .visible) }
            .disabled(!item.isMovable)
        Button("Move to Hidden") { moveWithKeyboard(item.id, to: .hidden) }
            .disabled(!item.isMovable || !item.canBeHidden)
        Button("Move to Always Hidden") { moveWithKeyboard(item.id, to: .alwaysHidden) }
            .disabled(!item.isMovable || !item.canBeHidden || !appState.settingsManager.advancedSettingsManager.enableAlwaysHiddenSection)
        Divider()
        Button("Move earlier") { reorderWithKeyboard(item.id, offset: -1) }.disabled(!item.isMovable)
        Button("Move later") { reorderWithKeyboard(item.id, offset: 1) }.disabled(!item.isMovable)
        if let bundle = item.bundleID, !appState.itemManager.isItemDiscoveryUnavailable {
            Divider()
            Button(LocalizedStringKey(appState.itemManager.newItemRules.alwaysShows(bundle) ? "Stop always showing this app" : "Always show this app")) {
                let rules = appState.itemManager.newItemRules
                rules.setAlwaysShown(bundle, enabled: !rules.alwaysShows(bundle))
                Task { await appState.itemManager.reconcileLayout(); await refresh() }
            }
        }
    }

    private func itemView(_ item: RowItem, pending: Bool, isDropTarget: Bool) -> some View {
        accessibleItem(item)
        .contextMenu { itemActions(item) }
        .help(pending ? L10n.string("%@ — moving…", item.subtitle ?? item.title) : (item.subtitle ?? item.title))
        .opacity(pending ? 0.7 : 1)
        .overlay {
            // Blue outline on drag hover: releasing inserts before this icon.
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(isDropTarget ? .blue : .clear, lineWidth: 2)
                .frame(width: 52, height: 56)
        }
        .overlay(alignment: .topTrailing) {
            if pending {
                ProgressView()
                    .controlSize(.mini)
                    .padding(4)
                    .background(.regularMaterial, in: Circle())
                    .offset(x: 6, y: -6)
            }
        }
        .onDrag {
            NSItemProvider(object: item.id as NSString)
        }
        .onDrop(
            of: [.text],
            isTargeted: dropTargetBinding(for: item.id),
            perform: { providers in
                guard !isMoving, let provider = providers.first else {
                    return false
                }
                let generation = pageGeneration
                _ = provider.loadObject(ofClass: NSString.self) { string, _ in
                    guard let id = string as? String else {
                        return
                    }
                    Task { @MainActor in
                        guard isPageVisible, pageGeneration == generation, !isMoving, moveTask == nil else { return }
                        moveTask = Task {
                            await drop(itemID: id, onto: item.id)
                            moveTask = nil
                        }
                    }
                }
                return true
            }
        )
    }

    /// Hover binding for one icon: dragging over it shows the blue outline, and
    /// the section yields this drop to the item (positional insert instead of appending to the group's end).
    private func dropTargetBinding(for id: String) -> Binding<Bool> {
        Binding(
            get: { dropTargetID == id },
            set: { targeted in
                if targeted {
                    dropTargetID = id
                } else if dropTargetID == id {
                    dropTargetID = nil
                }
            }
        )
    }

    private func layoutDescription(for id: String) -> String {
        guard let found = findItem(id: id), let meta = visibleMetas.first(where: { $0.kind == found.kind }) else { return "" }
        return L10n.string("%@, item %d of %d", L10n.string(meta.title), found.index + 1, sections[found.kind]?.count ?? 0)
    }

    private func moveWithKeyboard(_ id: String, to kind: MenuBarItemAXDiscovery.SectionKind) {
        guard let found = findItem(id: id), found.item.isMovable,
              kind == .visible || found.item.canBeHidden,
              kind != .alwaysHidden || appState.settingsManager.advancedSettingsManager.enableAlwaysHiddenSection else { return }
        beginAccessibleMove { await self.drop(itemID: id, to: kind) }
    }

    private func reorderWithKeyboard(_ id: String, offset: Int) {
        guard let found = findItem(id: id), found.item.isMovable,
              let items = sections[found.kind], items.indices.contains(found.index + offset) else { return }
        // 现有插入操作定义为放到目标前面；后移等价于把下一项放到当前项之前。
        let neighbor = items[found.index + offset]
        guard neighbor.isMovable else { return }
        beginAccessibleMove {
            if offset < 0 { await self.drop(itemID: id, onto: neighbor.id) } else { await self.drop(itemID: neighbor.id, onto: id) }
        }
    }

    private func beginAccessibleMove(_ operation: @escaping @MainActor () async -> Void) {
        guard isPageVisible, !isMoving, moveTask == nil else { return }
        let previousFocus = focusedItemID
        moveTask = Task {
            await operation()
            if isPageVisible, !Task.isCancelled {
                // 跨分区会重建行，操作完成后恢复键盘焦点并向辅助技术报告结果。
                await Task.yield()
                focusedItemID = previousFocus
                announceLayoutResult()
            }
            moveTask = nil
        }
    }

    private func announceLayoutResult() {
        let message = moveFailed
            ? L10n.string("Could not move the menu bar item. Its actual position is shown; try again after closing menus.")
            : L10n.string("Layout updated.")
        NSAccessibility.post(
            element: NSApp,
            notification: .announcementRequested,
            userInfo: [.announcement: message, .priority: NSAccessibilityPriorityLevel.medium.rawValue]
        )
    }

    /// 合成鼠标事件不能触发用户 Command-drag 的“展开全部”逻辑或自动收起。
    private func performDrag(from source: CGPoint, to destination: CGPoint) async -> Bool {
        guard !Task.isCancelled, !MenuInteractionGuard.isInteracting,
              !appState.itemManager.isMovingItem
        else { return false }
        appState.eventManager.stopAll()
        defer { appState.eventManager.startAll() }
        return await MenuBarItemAXMover.commandDrag(from: source, to: destination)
    }

    /// Drop an item into a new group: each attempt re-reads live positions
    /// first (cached frames go stale — a drag changes no window IDs, so a
    /// plain re-scan would reuse pre-drag frames), drags, then verifies the
    /// icon really landed before counting it. Up to 3 physical drags; between
    /// attempts the UI rebuilds from truth, so a miss never leaves a fake
    /// optimistic position behind.
    /// The `isMoving` guard blocks a second drag from fighting over the mouse.
    private func drop(itemID: String, to kind: MenuBarItemAXDiscovery.SectionKind) async {
        guard !isMoving else {
            return
        }
        guard !Task.isCancelled else { return }
        scanGeneration += 1
        dividerPollGeneration += 1
        iconRetryGeneration += 1
        moveFailed = false
        isMoving = true
        appState.itemManager.isEditingLayout = true
        pendingMoves.insert(itemID)
        // 隐藏项可能处于屏外，不能向负坐标发送拖拽；先暂时展开再读取真实帧。
        let revealed = appState.menuBarManager.sections.compactMap { section -> (MenuBarSection, Int)? in
            guard section.isEnabled, section.controlItem.state == .hideItems else { return nil }
            section.setState(.showItems, persist: false)
            return (section, section.stateRevision)
        }
        defer {
            for (section, revision) in revealed where section.stateRevision == revision {
                section.setState(.hideItems, persist: false)
            }
            appState.itemManager.isEditingLayout = false
            pendingMoves.remove(itemID)
            isMoving = false
        }
        do { try await Task.sleep(for: .milliseconds(250)) } catch { return }
        await rescanAfterDrag()
        for _ in 0..<3 {
            guard !Task.isCancelled else { return }
            // Force bypasses the windowIDs equality skip so frames are re-read.
            await appState.itemManager.cacheItemsIfNeeded(force: true)
            guard !Task.isCancelled else { return }
            applySnapshotFromCache()
            let snapshotBeforeDrag = sections
            guard let (item, fromKind) = removeItem(id: itemID) else {
                await refresh()
                return
            }
            guard item.isMovable, kind == .visible || item.canBeHidden else {
                sections = snapshotBeforeDrag
                moveFailed = true
                return
            }
            guard fromKind != kind else {
                // Already in the destination group; put it back where it was,
                // then re-scan so the UI is truth, not the optimistic append.
                sections[kind, default: []].append(item)
                pendingMoves.remove(itemID)
                isMoving = false
                await refreshAfterDrop()
                return
            }
            guard
                let destination = destinationPoint(for: kind),
                let sourceFrame = item.quartzFrame
            else {
                // No drop target known — re-scan for the real positions.
                sections = snapshotBeforeDrag
                moveFailed = true
                await refresh()
                return
            }
            withAnimation(.easeInOut(duration: 0.2)) {
                sections[kind, default: []].append(item)
            }
            let posted = await performDrag(
                from: CGPoint(x: sourceFrame.midX, y: sourceFrame.midY),
                to: destination
            )
            sections = snapshotBeforeDrag
            guard !Task.isCancelled else { return }
            await rescanAfterDrag()
            guard !Task.isCancelled else { return }
            if !posted { moveFailed = true; break }
            if sections[kind]?.contains(where: { $0.id == itemID }) == true {
                // Landed — but the frame right after a drag can still be
                // settling, so always do one settled re-scan instead of
                // trusting this snapshot. Otherwise the UI sometimes stays
                // wrong until the user hits Refresh by hand.
                pendingMoves.remove(itemID)
                isMoving = false
                await refreshAfterDrop()
                appState.itemManager.recordLayoutChoice()
                return
            }
            do { try await Task.sleep(for: .milliseconds(400)) } catch { return }
        }
        moveFailed = true
        pendingMoves.remove(itemID)
        isMoving = false
        await refreshAfterDrop()
    }

    /// Remove the item from its current group, returning the item and its old group.
    private func removeItem(id: String) -> (RowItem, MenuBarItemAXDiscovery.SectionKind)? {
        guard let found = findItem(id: id) else {
            return nil
        }
        var updated = sections[found.kind] ?? []
        updated.remove(at: found.index)
        sections[found.kind] = updated
        return (found.item, found.kind)
    }

    /// Find an item by stable ID, returning the item + group + index within the group
    /// (groups are already ordered left-to-right as on the menu bar).
    private func findItem(id: String) -> (item: RowItem, kind: MenuBarItemAXDiscovery.SectionKind, index: Int)? {
        for (kind, items) in sections {
            if let index = items.firstIndex(where: { $0.id == id }) {
                return (items[index], kind, index)
            }
        }
        return nil
    }

    /// Drop one icon onto another: insert before the target icon (same zone
    /// means reordering, different zone means moving zones at the right position).
    /// Like section drops, each attempt re-reads live positions first, drags,
    /// then verifies the landing — a missed drag is retried with fresh frames
    /// instead of snapping back and forcing the user to redo it by hand.
    private func drop(itemID: String, onto targetID: String) async {
        guard !isMoving else {
            return
        }
        guard itemID != targetID else {
            return
        }
        guard !Task.isCancelled else { return }
        scanGeneration += 1
        dividerPollGeneration += 1
        iconRetryGeneration += 1
        moveFailed = false
        isMoving = true
        appState.itemManager.isEditingLayout = true
        pendingMoves.insert(itemID)
        // 隐藏项可能处于屏外，不能向负坐标发送拖拽；先暂时展开再读取真实帧。
        let revealed = appState.menuBarManager.sections.compactMap { section -> (MenuBarSection, Int)? in
            guard section.isEnabled, section.controlItem.state == .hideItems else { return nil }
            section.setState(.showItems, persist: false)
            return (section, section.stateRevision)
        }
        defer {
            for (section, revision) in revealed where section.stateRevision == revision {
                section.setState(.hideItems, persist: false)
            }
            appState.itemManager.isEditingLayout = false
            pendingMoves.remove(itemID)
            isMoving = false
            dropTargetID = nil
        }
        do { try await Task.sleep(for: .milliseconds(250)) } catch { return }
        await rescanAfterDrag()
        for _ in 0..<3 {
            guard !Task.isCancelled else { return }
            await appState.itemManager.cacheItemsIfNeeded(force: true)
            guard !Task.isCancelled else { return }
            applySnapshotFromCache()
            guard
                let (item, fromKind, fromIndex) = findItem(id: itemID),
                let target = findItem(id: targetID),
                let sourceFrame = item.quartzFrame
            else {
                await refresh()
                return
            }
            let toKind = target.kind
            guard item.isMovable, toKind == .visible || item.canBeHidden else {
                moveFailed = true
                return
            }
            if fromKind == toKind, isImmediatelyBefore(itemID: itemID, targetID: targetID, in: toKind) {
                // Already in position — no drag needed.
                return
            }
            let snapshotBeforeDrag = sections
            // Remove the source first, then compute the insert position after
            // compaction (dragging forward shifts the target index down by 1 because the array is now shorter).
            var withoutSource = sections[fromKind] ?? []
            withoutSource.remove(at: fromIndex)
            sections[fromKind] = withoutSource
            let toItems = sections[toKind] ?? []
            let insertIndex: Int
            if fromKind == toKind, fromIndex < target.index {
                insertIndex = target.index - 1
            } else {
                insertIndex = toItems.firstIndex(where: { $0.id == targetID }) ?? toItems.count
            }
            let leftFrame = insertIndex > 0 ? toItems[max(0, insertIndex - 1)].quartzFrame : nil
            let rightFrame = insertIndex < toItems.count ? toItems[insertIndex].quartzFrame : nil
            guard let destination = reorderDestination(for: toKind, leftFrame: leftFrame, rightFrame: rightFrame) else {
                sections = snapshotBeforeDrag
                moveFailed = true
                await refresh()
                return
            }
            withAnimation(.easeInOut(duration: 0.2)) {
                sections[toKind, default: []].insert(item, at: min(insertIndex, toItems.count))
            }
            let posted = await performDrag(
                from: CGPoint(x: sourceFrame.midX, y: sourceFrame.midY),
                to: destination
            )
            sections = snapshotBeforeDrag
            guard !Task.isCancelled else { return }
            await rescanAfterDrag()
            guard !Task.isCancelled else { return }
            if !posted { moveFailed = true; break }
            if hasLanded(itemID: itemID, targetID: targetID, toKind: toKind) {
                // Same as section drops: one settled re-scan after landing,
                // don't trust the immediate post-drag snapshot.
                pendingMoves.remove(itemID)
                isMoving = false
                dropTargetID = nil
                await refreshAfterDrop()
                appState.itemManager.recordLayoutChoice()
                return
            }
            do { try await Task.sleep(for: .milliseconds(400)) } catch { return }
        }
        moveFailed = true
        pendingMoves.remove(itemID)
        isMoving = false
        dropTargetID = nil
        await refreshAfterDrop()
    }

    /// True when the item already sits immediately before the target in its group.
    private func isImmediatelyBefore(itemID: String, targetID: String, in kind: MenuBarItemAXDiscovery.SectionKind) -> Bool {
        guard
            let items = sections[kind],
            let itemIndex = items.firstIndex(where: { $0.id == itemID }),
            let targetIndex = items.firstIndex(where: { $0.id == targetID })
        else {
            return false
        }
        return itemIndex + 1 == targetIndex
    }

    /// 跨分区拖拽同样必须核验相邻顺序；仅进入目标分区不代表插入位置正确。
    private func hasLanded(
        itemID: String,
        targetID: String,
        toKind: MenuBarItemAXDiscovery.SectionKind
    ) -> Bool {
        isImmediatelyBefore(itemID: itemID, targetID: targetID, in: toKind)
    }

    /// Command-drag drop point for inserting into the gap between two adjacent
    /// frames (Quartz coordinates): mid-gap when both exist, 12pt offset from
    /// the edge at the ends. Clamped inside the zone bounds when the dividers
    /// are known, so the drop can't fall into another zone.
    private func reorderDestination(
        for kind: MenuBarItemAXDiscovery.SectionKind,
        leftFrame: CGRect?,
        rightFrame: CGRect?
    ) -> CGPoint? {
        let y = anchorY == 0 ? 8 : anchorY
        if let left = leftFrame, let right = rightFrame {
            if left.maxX < right.minX {
                return CGPoint(x: (left.maxX + right.minX) / 2, y: y)
            }
            return CGPoint(x: (left.midX + right.midX) / 2, y: y)
        }
        if let right = rightFrame {
            var x = right.minX - 12
            if let bound = leftBound(for: kind), x < bound + 6 {
                x = bound + 10
            }
            return CGPoint(x: x, y: y)
        }
        if let left = leftFrame {
            var x = left.maxX + 12
            if let bound = rightBound(for: kind), x > bound - 6 {
                x = bound - 10
            }
            return CGPoint(x: x, y: y)
        }
        return destinationPoint(for: kind)
    }

    /// Left bound of the zone (minX of the divider on the left), nil when unknown.
    private func leftBound(for kind: MenuBarItemAXDiscovery.SectionKind) -> CGFloat? {
        switch kind {
        case .visible:
            hiddenDividerX ?? alwaysHiddenDividerX
        case .hidden:
            alwaysHiddenDividerX
        case .alwaysHidden:
            nil
        }
    }

    /// Right bound of the zone (minX of the divider on the right), nil when unknown.
    private func rightBound(for kind: MenuBarItemAXDiscovery.SectionKind) -> CGFloat? {
        switch kind {
        case .visible:
            nil
        case .hidden:
            hiddenDividerX
        case .alwaysHidden:
            alwaysHiddenDividerX ?? hiddenDividerX
        }
    }

    /// Command-drag drop point for the destination group (Quartz coordinates,
    /// top-left origin, same system as `CGEvent`): inside that group's region,
    /// offset from the divider so it doesn't land in the divider's hitbox. The
    /// Hidden group sits between two dividers, so drop at the midpoint to be safe.
    private func destinationPoint(for kind: MenuBarItemAXDiscovery.SectionKind) -> CGPoint? {
        switch kind {
        case .visible:
            guard let x = hiddenDividerX ?? alwaysHiddenDividerX else {
                return nil
            }
            return CGPoint(x: x + 40, y: anchorY)
        case .hidden:
            guard let x = hiddenDividerX else {
                return nil
            }
            if let ahX = alwaysHiddenDividerX, ahX < x {
                return CGPoint(x: (ahX + x) / 2, y: anchorY)
            }
            return CGPoint(x: x - 24, y: anchorY)
        case .alwaysHidden:
            guard let x = alwaysHiddenDividerX else {
                return nil
            }
            return CGPoint(x: x - 24, y: anchorY)
        }
    }

    private var accessibilityPrompt: some View {
        VStack(spacing: 12) {
            Text("Menu bar layout requires accessibility permission")
                .font(.title2)
            Text("Grant Accessibility access so Floe can list the icons in your menu bar.")
                .foregroundStyle(.secondary)
            HStack(spacing: 16) {
                Button("Open System Settings") {
                    openURL(Self.accessibilitySettingsURL)
                }
                Button("Check Again") {
                    Task {
                        await refresh()
                    }
                }
            }
            .buttonStyle(FloeButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var permissionPrompt: some View {
        VStack(spacing: 12) {
            Text("Menu bar layout requires screen recording permission")
                .font(.title2)
            Text("Grant Screen Recording access so Floe can see the icons in your menu bar.")
                .foregroundStyle(.secondary)
            HStack(spacing: 16) {
                Button("Open System Settings") {
                    openURL(Self.screenRecordingSettingsURL)
                }
                Button("Check Again") {
                    Task {
                        await refresh()
                    }
                }
            }
            .buttonStyle(FloeButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var discoveryUnavailable: some View {
        VStack(spacing: 12) {
            Text("Menu Bar Layout isn't available on this macOS version")
                .font(.title2)
            Text("This version of macOS no longer exposes individual menu bar items to Floe.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Manual scan from the Refresh button: shows the spinner, blocks overlapping taps.
    private func refresh() async {
        // Guard against overlapping scans when Refresh is tapped repeatedly.
        guard !isRefreshing else {
            return
        }
        isRefreshing = true
        defer {
            isRefreshing = false
        }
        await scanAndApply()
    }

    /// Settled re-scan after a drag: unlike the Refresh button it must never
    /// be skipped by the `isRefreshing` guard (e.g. the tab-open scan still
    /// running), otherwise the UI stays on the pre-drag snapshot until the
    /// user hits Refresh by hand.
    private func refreshAfterDrop() async {
        for _ in 0..<30 where isRefreshing {
            try? await Task.sleep(for: .milliseconds(100))
        }
        if isRefreshing {
            // A scan is stuck (divider wait); run one anyway so the post-drag
            // truth is painted instead of leaving the optimistic UI behind.
            await scanAndApply()
        } else {
            await refresh()
        }
    }

    /// Rebuild post-drag truth without trusting the optimistic SwiftUI state.
    ///
    /// macOS 27 clears the CGS item cache because per-item windows are gone,
    /// so an AX scan is the only real source of fresh frames and membership.
    private func rescanAfterDrag() async {
        guard !Task.isCancelled else { return }
        scanGeneration += 1
        let generation = scanGeneration
        await appState.itemManager.cacheItemsIfNeeded(force: true)
        guard generation == scanGeneration, !Task.isCancelled else { return }
        let (hiddenX, alwaysHiddenX) = resolveDividers()
        hiddenDividerX = hiddenX
        alwaysHiddenDividerX = alwaysHiddenX

        var axFallback = [MenuBarItemAXDiscovery.AXMenuBarItem]()
        if MenuBarItemAXDiscovery.isTrusted() {
            let apps = NSWorkspace.shared.runningApplications
            axFallback = await Task.detached(priority: .userInitiated) {
                MenuBarItemAXDiscovery.discoverItems(in: apps)
            }.value
        }
        guard generation == scanGeneration, !Task.isCancelled else { return }
        axSnapshot = axFallback
        let (grouped, midY) = buildSections(
            hiddenX: hiddenX,
            alwaysHiddenX: alwaysHiddenX,
            axFallback: axFallback
        )
        // 完整扫描得到空结果时清除旧分组，不能永久保留已退出应用的行。
        sections = grouped
        if let midY {
            anchorY = midY
        }
    }

    /// Fast synchronous divider read: prefers AX (own process, no system-wide
    /// walk), falls back to window.frame when AX isn't available yet.
    /// Same approach Floe Bar uses to avoid junk frames from the offscreen spacer park.
    private func resolveDividers() -> (hiddenX: CGFloat?, alwaysHiddenX: CGFloat?) {
        let axDividers = MenuBarItemAXDiscovery.dividerFrames()
        func settledMinX(_ frame: CGRect?) -> CGFloat? {
            frame.flatMap { MenuBarItemAXDiscovery.isSettledDividerFrame($0) ? $0.minX : nil }
        }
        func saneMinX(_ value: CGFloat?) -> CGFloat? {
            value.flatMap { $0 > 0 ? $0 : nil }
        }
        let manager = appState.menuBarManager
        let rawHiddenX = settledMinX(axDividers.hidden)
            ?? saneMinX(manager.section(withName: .hidden)?.controlItem.window?.frame.minX)
        let rawAlwaysHiddenX = settledMinX(axDividers.alwaysHidden)
            ?? saneMinX(manager.section(withName: .alwaysHidden)?.controlItem.window?.frame.minX)
        let dividers = MenuBarItemAXDiscovery.normalizedDividers(
            hiddenDividerX: rawHiddenX,
            alwaysHiddenDividerX: rawAlwaysHiddenX
        )
        return (dividers.hidden, dividers.alwaysHidden)
    }

    /// Build sections from the available CGS cache + current dividers, without scanning.
    /// Called synchronously when opening the tab and when $itemCache changes so the UI appears immediately.
    private func applySnapshotFromCache() {
        hasAccessibilityPermission = MenuBarItemAXDiscovery.isTrusted()
        let (hiddenX, alwaysHiddenX) = resolveDividers()
        hiddenDividerX = hiddenX
        alwaysHiddenDividerX = alwaysHiddenX
        let (grouped, midQuartzY) = buildSections(
            hiddenX: hiddenX,
            alwaysHiddenX: alwaysHiddenX,
            axFallback: hasAccessibilityPermission ? axSnapshot : []
        )
        // Cache still empty (fresh boot, timer hasn't pumped yet): keep the old
        // sections so the UI doesn't flash back to the placeholder; the background scan will fill it in.
        if !grouped.isEmpty {
            sections = grouped
        }
        if let midQuartzY {
            anchorY = midQuartzY
        } else if anchorY == 0 {
            anchorY = 8
        }
    }

    /// CGS 与 AX 同时可用时仅补入缺失项；有几何信息时不能仅凭同名合并不同图标。
    private func supplementalAXItems(
        _ axItems: [MenuBarItemAXDiscovery.AXMenuBarItem],
        cached: [MenuBarItem]
    ) -> [MenuBarItemAXDiscovery.AXMenuBarItem] {
        axItems.filter { axItem in
            !cached.contains { item in
                if let frame = axItem.axFrame, !frame.isEmpty {
                    return abs(frame.midX - item.frame.midX) <= 1 &&
                        abs(frame.midY - item.frame.midY) <= 1 &&
                        abs(frame.width - item.frame.width) <= 2 &&
                        abs(frame.height - item.frame.height) <= 2
                }
                guard let title = axItem.title, !title.isEmpty else { return false }
                guard axItem.pid == item.ownerPID, title == item.title else { return false }
                // 无坐标时只合并双方都唯一的身份；同一宿主的多个同名图标不能被吞掉。
                return axItems.filter { $0.pid == axItem.pid && $0.title == title }.count == 1 &&
                    cached.filter { $0.ownerPID == item.ownerPID && $0.title == title }.count == 1
            }
        }
    }

    /// Build icon groups from the CGS cache in true menu bar order (left-to-right
    /// by center X). Returns the groups + mid-Y to use as the Command-drag drop point.
    private func buildSections(
        hiddenX: CGFloat?,
        alwaysHiddenX: CGFloat?,
        axFallback: [MenuBarItemAXDiscovery.AXMenuBarItem]
    ) -> (grouped: [MenuBarItemAXDiscovery.SectionKind: [RowItem]], midQuartzY: CGFloat?) {
        func kind(centerX: CGFloat?) -> MenuBarItemAXDiscovery.SectionKind {
            MenuBarItemAXDiscovery.classify(centerX: centerX, hiddenDividerX: hiddenX, alwaysHiddenDividerX: alwaysHiddenX)
        }
        var idCounts = [String: Int]()
        func stableID(for base: String) -> String {
            let n = idCounts[base, default: 0]
            idCounts[base] = n + 1
            return n == 0 ? base : "\(base)#\(n)"
        }
        let ownBundleID = Bundle.main.bundleIdentifier
        var grouped = [MenuBarItemAXDiscovery.SectionKind: [RowItem]]()
        var quartzYs = [CGFloat]()
        // Both CGS and AX sort by ascending center X = left-to-right on the menu
        // bar, matching the real-world order with Clock at the far right.
        let cached = displayableCachedItems.sorted { $0.frame.midX < $1.frame.midX }
        if !cached.isEmpty {
            for item in cached {
                quartzYs.append(item.frame.midY)
                // Single lookup: owningApplication builds a new
                // NSRunningApplication each access, and .icon is nil
                // transiently on first touch — reuse + cache it.
                let app = item.owningApplication
                let bundleID = app?.bundleIdentifier
                let systemImage = MenuBarItemAXDiscovery.systemImageName(
                    forTitle: item.title ?? item.displayName, bundleID: bundleID
                )
                var appIcon: NSImage?
                if systemImage == nil {
                    if let cachedIcon = iconCache[item.ownerPID] {
                        appIcon = cachedIcon
                    } else if let icon = app?.icon {
                        iconCache[item.ownerPID] = icon
                        appIcon = icon
                    }
                }
                grouped[kind(centerX: item.frame.midX), default: []].append(
                    RowItem(
                        id: stableID(for: "cgs:\(item.windowID)"),
                        title: item.displayName,
                        subtitle: item.subtitle,
                        systemImage: systemImage,
                        appIcon: appIcon,
                        isSystem: bundleID?.hasPrefix("com.apple.") == true,
                        quartzFrame: item.frame,
                        isMovable: item.isMovable,
                        canBeHidden: item.canBeHidden,
                        bundleID: bundleID
                    )
                )
            }
        }
        for item in supplementalAXItems(axFallback, cached: cached).sorted(by: { ($0.axFrame?.midX ?? .greatestFiniteMagnitude) < ($1.axFrame?.midX ?? .greatestFiniteMagnitude) }) {
            let systemImage = MenuBarItemAXDiscovery.systemImageName(forIdentifier: item.identifier)
            var appIcon: NSImage?
            if systemImage == nil {
                if let cachedIcon = iconCache[item.pid] {
                    appIcon = cachedIcon
                } else if item.bundleID == "com.apple.TextInputMenuAgent" {
                    if let icon = MenuBarItemAXDiscovery.inputSourceIcon() {
                        iconCache[item.pid] = icon
                        appIcon = icon
                    }
                } else if let icon = NSRunningApplication(processIdentifier: item.pid)?.icon {
                    iconCache[item.pid] = icon
                    appIcon = icon
                }
            }
            if let frame = item.axFrame {
                quartzYs.append(frame.midY)
            }
            grouped[kind(centerX: item.axFrame?.midX), default: []].append(
                RowItem(
                    id: stableID(for: "ax:\(item.pid):\(CFHash(item.element))"),
                    title: item.displayName,
                    subtitle: item.subtitle,
                    systemImage: systemImage,
                    appIcon: appIcon,
                    isSystem: item.bundleID?.hasPrefix("com.apple.") == true,
                    quartzFrame: item.axFrame,
                    bundleID: item.bundleID
                )
            )
        }
        // 补充项也按实际位置插入，不能把 AX 项全部堆在 CGS 项后面。
        grouped = grouped.mapValues { rows in
            rows.sorted {
                ($0.quartzFrame?.midX ?? .greatestFiniteMagnitude) <
                    ($1.quartzFrame?.midX ?? .greatestFiniteMagnitude)
            }
        }
        let midY: CGFloat? = quartzYs.isEmpty ? nil : quartzYs.sorted()[quartzYs.count / 2]
        return (grouped, midY)
    }

    /// Whether Floe's Hidden divider is expected in the menu bar right now.
    private func isHiddenDividerExpected() -> Bool {
        appState.menuBarManager.section(withName: .hidden)?.controlItem.isAddedToMenuBar == true
    }

    /// Whether Floe's Always Hidden divider is expected in the menu bar right now.
    private func isAlwaysHiddenDividerExpected() -> Bool {
        guard appState.settingsManager.advancedSettingsManager.enableAlwaysHiddenSection else {
            return false
        }
        return appState.menuBarManager.section(withName: .alwaysHidden)?.controlItem.isAddedToMenuBar == true
    }

    /// True when an expected divider's position is still unknown — icons would
    /// be misclassified until it appears. Checks each divider independently so
    /// a late second divider doesn't get stuck when the first one is already known.
    private func isMissingExpectedDivider(hiddenX: CGFloat?, alwaysHiddenX: CGFloat?) -> Bool {
        (hiddenX == nil && isHiddenDividerExpected())
            || (alwaysHiddenX == nil && isAlwaysHiddenDividerExpected())
    }

    /// Keep re-classifying from the current cache until expected dividers show
    /// up (up to ~7s). Lightweight: only re-reads divider positions, no CGS
    /// walk — the 5s background timer keeps pumping itemCache separately.
    private func startDividerPoll() {
        dividerPollGeneration += 1
        let generation = dividerPollGeneration
        Task { @MainActor in
            for _ in 0..<14 {
                try? await Task.sleep(for: .milliseconds(500))
                guard generation == dividerPollGeneration else {
                    return
                }
                if isMoving {
                    continue
                }
                let (hx, ahx) = resolveDividers()
                if hx != hiddenDividerX || ahx != alwaysHiddenDividerX {
                    hiddenDividerX = hx
                    alwaysHiddenDividerX = ahx
                    applySnapshotFromCache()
                }
                if !isMissingExpectedDivider(hiddenX: hx, alwaysHiddenX: ahx) {
                    return
                }
            }
        }
    }

    /// One real scan: read permissions, CGS cache, classify by dividers.
    private func scanAndApply() async {
        guard !Task.isCancelled else { return }
        scanGeneration += 1
        let generation = scanGeneration
        // Cancel any previous divider poll + icon retry; this scan starts its own if needed.
        dividerPollGeneration += 1
        iconRetryGeneration += 1
        // With permission already granted, use the cache instead of making
        // WindowServer walk the window list again on every Refresh.
        if !hasScreenRecordingPermission {
            hasScreenRecordingPermission = ScreenCapture.cachedCheckPermissions(reset: true)
        }
        hasAccessibilityPermission = MenuBarItemAXDiscovery.isTrusted()
        // Paint a temporary frame from the old cache first so the screen doesn't go blank while waiting.
        applySnapshotFromCache()
        if hasScreenRecordingPermission {
            // 相同 window ID 的位置/标题仍会变化；显式刷新不能复用旧元数据。
            await appState.itemManager.cacheItemsIfNeeded(force: true)
        }

        guard generation == scanGeneration, !Task.isCancelled else { return }

        // Dividers have no window right after boot → minX is nil → every icon
        // would be misclassified as Visible. Prefer fast AX, waiting at most ~2s
        // when an expected divider is still missing, instead of making the user hit Refresh repeatedly.
        var (hiddenX, alwaysHiddenX) = resolveDividers()
        if isMissingExpectedDivider(hiddenX: hiddenX, alwaysHiddenX: alwaysHiddenX) {
            for _ in 0..<20 {
                try? await Task.sleep(for: .milliseconds(100))
                guard generation == scanGeneration, !Task.isCancelled else { return }
                (hiddenX, alwaysHiddenX) = resolveDividers()
                if !isMissingExpectedDivider(hiddenX: hiddenX, alwaysHiddenX: alwaysHiddenX) {
                    break
                }
            }
        }
        hiddenDividerX = hiddenX
        alwaysHiddenDividerX = alwaysHiddenX

        var axFallback = [MenuBarItemAXDiscovery.AXMenuBarItem]()
        if hasAccessibilityPermission {
            let apps = NSWorkspace.shared.runningApplications
            axFallback = await Task.detached(priority: .userInitiated) {
                MenuBarItemAXDiscovery.discoverItems(in: apps)
            }.value
        }
        guard generation == scanGeneration, !Task.isCancelled else { return }
        axSnapshot = axFallback
        let (grouped, midY) = buildSections(hiddenX: hiddenX, alwaysHiddenX: alwaysHiddenX, axFallback: axFallback)
        // 完整扫描得到空结果时清除旧分组，不能永久保留已退出应用的行。
        sections = grouped
        if let midY {
            anchorY = midY
        } else if anchorY == 0 {
            anchorY = 8
        }

        // When an expected divider's window hasn't appeared yet, keep polling
        // so the icons land in the right groups without manual Refresh taps.
        if isMissingExpectedDivider(hiddenX: hiddenX, alwaysHiddenX: alwaysHiddenX), !grouped.isEmpty {
            startDividerPoll()
        }

        // Icons that are still blank (app icon nil on first lookup) fill in
        // on their own — no repeated Refresh taps needed. Pass the AX
        // fallback through: when the CGS cache is empty the retry must
        // rebuild from the same AX items (applySnapshotFromCache alone
        // would rebuild from an empty cache with no fallback and change nothing).
        scheduleIconRetryIfNeeded(axFallback: axFallback)
    }

    /// Re-resolve blank icons a couple times: `NSRunningApplication.icon`
    /// is often nil on first touch right after opening the tab. Retries only
    /// re-read icons/dividers from the current cache (no CGS walk), so they
    /// are cheap; a new scan cancels the previous retry.
    private func scheduleIconRetryIfNeeded(axFallback: [MenuBarItemAXDiscovery.AXMenuBarItem] = []) {
        guard sections.values.flatMap({ $0 }).contains(where: { $0.systemImage == nil && $0.appIcon == nil }) else {
            return
        }
        iconRetryGeneration += 1
        let generation = iconRetryGeneration
        Task { @MainActor in
            for delay in [500, 1500] {
                try? await Task.sleep(for: .milliseconds(delay))
                guard generation == iconRetryGeneration, !isMoving else {
                    return
                }
                let (hx, ahx) = resolveDividers()
                hiddenDividerX = hx
                alwaysHiddenDividerX = ahx
                let (grouped, midY) = buildSections(hiddenX: hx, alwaysHiddenX: ahx, axFallback: axFallback)
                if !grouped.isEmpty {
                    sections = grouped
                }
                if let midY {
                    anchorY = midY
                }
                if !sections.values.flatMap({ $0 }).contains(where: { $0.systemImage == nil && $0.appIcon == nil }) {
                    return
                }
            }
        }
    }

    private static let screenRecordingSettingsURL = URL(
        string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
    )!
    private static let accessibilitySettingsURL = URL(
        string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
    )!
}

// MARK: - Row

private struct RowItem: Identifiable {
    /// Stable ID tied to the real item (not a random UUID per scan)
    /// so SwiftUI diffs smoothly and the item stays verifiable after drag-and-drop.
    let id: String
    let title: String
    let subtitle: String?
    let systemImage: String?
    let appIcon: NSImage?
    /// true for com.apple.* bundles: attaches the Apple logo badge as in the mock.
    let isSystem: Bool
    /// Frame in Quartz coordinates (top-left origin, same system as `CGEvent`),
    /// used as the start point for a Command-drag.
    let quartzFrame: CGRect?
    /// CGS 已知系统限制；AX 未提供可靠限制时保留系统实际拒绝结果。
    var isMovable = true
    var canBeHidden = true
    var bundleID: String?
}

private struct SectionMeta {
    typealias Kind = MenuBarItemAXDiscovery.SectionKind

    let kind: Kind
    let title: String
    let icon: String
    let subtitle: String
    let emptyHint: String

    static let all = [
        SectionMeta(kind: .visible, title: "Visible", icon: "eye", subtitle: "Always in the menu bar", emptyHint: "No visible icons"),
        SectionMeta(kind: .hidden, title: "Hidden", icon: "eye.slash", subtitle: "A hover or click away — or ⌘-drag icons left of the chevron", emptyHint: "No hidden icons — drop icons here to hide them"),
        SectionMeta(kind: .alwaysHidden, title: "Always Hidden", icon: "moon", subtitle: "Out of sight until you double-click or ⌥-click the chevron", emptyHint: "No always-hidden icons — drop icons here to hide them"),
    ]
}

// MARK: - FlowLayout

/// Lay out subviews into multiple rows, wrapping when out of space.
/// Right-align each row to match the real menu bar (icons packed against the right edge).
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(proposal: proposal, subviews: subviews)
        let height = rows.last.map { $0.y + $0.height } ?? 0
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for row in arrange(proposal: proposal, subviews: subviews) {
            for (position, index) in row.indices.enumerated() {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(
                    at: CGPoint(x: bounds.minX + row.x[position] + row.trailingOffset, y: bounds.minY + row.y),
                    proposal: ProposedViewSize(size)
                )
            }
        }
    }

    private struct Row {
        var x = [CGFloat]()
        var indices = [Int]()
        var y: CGFloat = 0
        var height: CGFloat = 0
        /// Offset that packs the row against the right edge (= the remaining space).
        var trailingOffset: CGFloat = 0
        var width: CGFloat = 0
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        let maxWidth = proposal.width ?? .infinity
        var rows = [Row]()
        var current = Row()
        var x: CGFloat = 0
        var y: CGFloat = 0
        func finishRow() {
            // Push incomplete rows fully right to match the menu bar.
            if maxWidth.isFinite {
                current.trailingOffset = max(0, maxWidth - current.width)
            }
            rows.append(current)
            y += current.height + spacing
            current = Row()
            x = 0
        }
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            if !current.indices.isEmpty, x + size.width > maxWidth {
                finishRow()
            }
            current.x.append(x)
            current.indices.append(index)
            current.height = max(current.height, size.height)
            current.y = y
            x += size.width + spacing
            current.width = x - spacing
        }
        if !current.indices.isEmpty {
            finishRow()
        }
        return rows
    }
}

// MARK: - Subtitle

private extension MenuBarItem {
    var subtitle: String {
        if let bundleID = owningApplication?.bundleIdentifier {
            bundleID
        } else if let ownerName {
            ownerName
        } else {
            title ?? ""
        }
    }
}

private extension MenuBarItemAXDiscovery.AXMenuBarItem {
    var subtitle: String? {
        if let identifier, identifier != displayName {
            identifier
        } else {
            bundleID
        }
    }
}
