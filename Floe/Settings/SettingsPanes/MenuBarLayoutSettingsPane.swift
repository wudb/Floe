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
    @State private var isManualRefresh = false
    /// 异步扫描只能发布最新请求；离开页面后丢弃迟到结果。
    @State private var scanGeneration = 0
    /// CGS 无可展示项时保留最近 AX 快照，供缓存更新和分隔符重分类使用。
    @State private var axSnapshot = [MenuBarItemAXDiscovery.AXMenuBarItem]()
    /// Guards against overlapping drags: two concurrent Command-drags would fight over the mouse.
    @State private var isMoving = false
    /// 仅实际发送鼠标事件时暂停拖拽；扫描和落点确认期间仍接受下一次操作。
    @State private var isPostingMove = false
    /// 后续拖拽按用户放下顺序执行，预览独立于系统确认快照。
    @State private var moveQueue = [(itemID: String, kind: MenuBarItemAXDiscovery.SectionKind, targetID: String?)]()
    @State private var queuedMovePreview: [MenuBarItemAXDiscovery.SectionKind: [RowItem]]?
    /// 页面关闭时取消拖拽，迟到的 provider 回调不能再次占用鼠标。
    @State private var moveTask: Task<Void, Never>?
    /// 每次原生拖拽独立持有来源，消费后失效，防止晚到的 provider 回调重复移动。
    @State private var activeDrag: (token: String, itemID: String)?
    @State private var isPageVisible = false
    @State private var pageGeneration = 0
    @State private var moveFailed = false
    @State private var searchText = ""
    @FocusState private var focusedItemID: String?
    @State private var hoveredItemID: String?
    // 只持有控制器，不在页面订阅逐像素的指针更新；提示层独立响应这些变化。
    @State private var tooltip = FloeTooltipController()
    /// IDs of icons currently being moved in the background: the UI updates
    /// optimistically right away, with a small badge on each icon showing
    /// it's syncing, so the whole list doesn't freeze.
    @State private var pendingMoves = Set<String>()
    /// 只用于拖拽中的即时显示；系统读回写入 sections，不能拿预览位置验证移动成功。
    @State private var movePreview: [MenuBarItemAXDiscovery.SectionKind: [RowItem]]?
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

    private var displayedSections: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] {
        queuedMovePreview ?? movePreview ?? sections
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
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Menu Bar Layout")
                        .font(.system(size: 24, weight: .bold))
                    Text("Drag icons to organize your menu bar")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .layoutPriority(1)
                Text("\(totalCount)")
                    .font(.callout.monospacedDigit())
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
                    if isManualRefresh {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
                .buttonStyle(FloeButtonStyle())
                .labelStyle(.iconOnly)
                .help("Refresh")
                .disabled(isRefreshing || isMoving)

                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search menu bar items", text: $searchText)
                        .textFieldStyle(.plain)
                        .onExitCommand { searchText = "" }
                }
                .padding(9)
                .frame(width: 190)
                .floeCardSurface()
            }

            menuBarPreview
            if moveFailed {
                Text("Could not move the menu bar item. Its actual position is shown; try again after closing menus.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
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
                        }
                    } else {
                        ForEach(visibleMetas, id: \.kind) { meta in
                            sectionView(meta: meta, items: filteredItems(in: meta.kind))
                        }
                        if hiddenDividerX == nil, alwaysHiddenDividerX == nil {
                            Text("Can't find Floe's section dividers — make sure the Hidden sections are enabled, then press Refresh.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    NewItemRulesView(rules: appState.itemManager.newItemRules, manager: appState.itemManager)
                        .padding(14)
                        .floeCardSurface()

                    HStack(spacing: 6) {
                        Image(systemName: "hand.draw")
                        // 底部只保留操作说明，图标名称由页面覆盖层即时显示。
                        Text("Hover to see names · Drag to change section and order")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.trailing, 4)
                .padding(.bottom, 4)
            }
            .scrollIndicators(.automatic)
            .floeTooltipViewport("layout-icons")
        }
        .padding(24)
        .floeTooltips(tooltip, isEnabled: !isMoving && dropTargetID == nil)
        .task {
            pageGeneration += 1
            isPageVisible = true
            // Paint immediately from the available cache (the 5s background timer
            // keeps pumping itemCache), then reconcile with a background scan —
            // opening the tab shows icons right away, no Refresh tap needed.
            applySnapshotFromCache()
            await refresh(showProgress: false)
            // AX-only 系统不会发布新的 CGS 项；页面可见期间持续发现新启动/退出的应用。
            while !Task.isCancelled {
                do {
                    try await Task.sleep(for: .seconds(5))
                } catch {
                    return
                }
                guard !isMoving, displayableCachedItems.isEmpty else { continue }
                await refresh(showProgress: false)
            }
        }
        .onReceive(appState.itemManager.$itemCache.receive(on: DispatchQueue.main)) { _ in
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
            activeDrag = nil
            scanGeneration += 1
            // Stop the divider poll + icon retry when leaving the tab.
            dividerPollGeneration += 1
            iconRetryGeneration += 1
        }
    }

    /// 预览只使用当前发现的可见项目，不用示例图标冒充用户的真实菜单栏。
    private var menuBarPreview: some View {
        HStack(spacing: 14) {
            Image(systemName: "apple.logo")
            Text("Floe").fontWeight(.semibold)
            Spacer(minLength: 12)
            if !hasUnknownMembership {
                ForEach(Array((displayedSections[.visible] ?? []).suffix(8))) { item in
                    compactIcon(item)
                        .floeTooltip(item.title)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .floeGlassSurface(in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Menu bar preview"))
    }

    /// 名称、宿主和标识均可检索；不改变真实分区和排序快照。
    private func filteredItems(in kind: MenuBarItemAXDiscovery.SectionKind) -> [RowItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return (displayedSections[kind] ?? []).filter {
            query.isEmpty || $0.title.localizedStandardContains(query) ||
                ($0.subtitle?.localizedStandardContains(query) ?? false)
        }
    }

    /// AX-only 且边界缺失时只能列出发现项，不能宣称这些项都可见或隐藏区为空。
    private var hasUnknownMembership: Bool {
        displayableCachedItems.isEmpty && hiddenDividerX == nil && isHiddenDividerExpected()
    }

    private func sectionView(meta: SectionMeta, items: [RowItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: meta.icon)
                Text(LocalizedStringKey(hasUnknownMembership && meta.kind == .visible ? "Unclassified icons" : meta.title))
                    .font(.headline)
                Text("\(items.count)")
                    .font(.caption.monospacedDigit())
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(.quaternary, in: Capsule())
                Spacer(minLength: 0)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(LocalizedStringKey(hasUnknownMembership ? "Section boundaries are unavailable; membership has not been confirmed." : meta.subtitle))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                FlowLayout(spacing: 4) {
                    if items.isEmpty {
                        Text(LocalizedStringKey(hasUnknownMembership ? "Section membership is unknown. This does not mean the section is empty." : meta.emptyHint))
                            .font(.callout)
                            .foregroundStyle(.tertiary)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(items) { item in
                            itemView(item, pending: pendingMoves.contains(item.id) || moveQueue.contains(where: { $0.itemID == item.id }), isDropTarget: dropTargetID == item.id)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .floeCardSurface()
        .onDrop(of: [.text], isTargeted: .constant(false), perform: { providers in
            // When hovering an icon, let that item handle the drop (positional
            // insert); the section only handles drops into empty space (move to that group).
            guard dropTargetID == nil else { return false }
            return acceptLayoutDrop(providers, to: meta.kind)
        })
    }

    private func compactIcon(_ item: RowItem) -> some View {
        Group {
            if let systemName = item.systemImage {
                Image(systemName: systemName)
                    .font(.system(size: 18))
            } else if let icon = item.appIcon {
                Image(nsImage: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            } else {
                Image(systemName: "app.dashed")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 24, height: 24)
    }

    private func itemVisual(_ item: RowItem) -> some View {
        // 图像保持小尺寸，独立保留 36 点命中区域，兼顾高密度与拖拽操作。
        compactIcon(item)
            .frame(width: 36, height: 36)
            .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.blue.opacity(hoveredItemID == item.id || focusedItemID == item.id ? 0.1 : 0))
            }
            .onHover { hovering in
                if hovering { hoveredItemID = item.id } else if hoveredItemID == item.id { hoveredItemID = nil }
            }
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
            .floeTooltip(pending ? L10n.string("%@ — moving…", item.title) : item.title, viewport: "layout-icons")
            .opacity(pending ? 0.7 : 1)
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(isDropTarget || focusedItemID == item.id ? .blue : .clear, lineWidth: 2)
                    .allowsHitTesting(false)
            }
            .overlay(alignment: .bottomTrailing) {
                if pending {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 12, height: 12)
                        .allowsHitTesting(false)
                }
            }
            .onDrag {
                dragProvider(for: item)
            }
            .onDrop(
                of: [.text],
                isTargeted: dropTargetBinding(for: item.id),
                perform: { providers in
                    acceptLayoutDrop(providers, onto: item.id)
                }
            )
            // 只在系统事件注入期间保护指针；确认快照时可继续拖动并排队。
            .allowsHitTesting(isLayoutDragSourceEnabled)
    }

    private var isLayoutDragSourceEnabled: Bool {
        !isPostingMove
    }

    private var canStartLayoutDrag: Bool {
        isPageVisible && isLayoutDragSourceEnabled &&
            !appState.itemManager.isMovingItem && !MenuBarItemAXMover.isDragging && !MenuInteractionGuard.isInteracting
    }

    private func dragProvider(for item: RowItem) -> NSItemProvider {
        guard canStartLayoutDrag, item.isMovable else { return NSItemProvider() }
        tooltip.dismiss()
        let token = UUID().uuidString
        activeDrag = (token, item.id)
        return NSItemProvider(object: token as NSString)
    }

    /// 图标与分区共用一次性会话；异步载荷只有仍属于当前拖拽时才能启动移动。
    private func acceptLayoutDrop(
        _ providers: [NSItemProvider],
        to kind: MenuBarItemAXDiscovery.SectionKind? = nil,
        onto targetID: String? = nil
    ) -> Bool {
        guard isPageVisible, let drag = activeDrag,
              let provider = providers.first, provider.canLoadObject(ofClass: NSString.self) else { return false }
        let generation = pageGeneration
        _ = provider.loadObject(ofClass: NSString.self) { [self] string, _ in
            guard let token = string as? String else { return }
            Task { @MainActor in
                guard isPageVisible, pageGeneration == generation,
                      activeDrag?.token == drag.token, token == drag.token else { return }
                activeDrag = nil
                enqueueLayoutMove(itemID: drag.itemID, to: kind, before: targetID)
            }
        }
        return true
    }

    /// 先更新所有待执行操作的投影，再由一个任务串行修改真实菜单栏。
    private func enqueueLayoutMove(
        itemID: String,
        to requestedKind: MenuBarItemAXDiscovery.SectionKind?,
        before targetID: String?
    ) {
        let layout = displayedSections
        let kind = targetID.flatMap { id in layout.first(where: { $0.value.contains(where: { $0.id == id }) })?.key } ?? requestedKind
        guard let kind, let source = layout.values.flatMap({ $0 }).first(where: { $0.id == itemID }),
              source.isMovable, kind == .visible || source.canBeHidden,
              kind != .alwaysHidden || appState.settingsManager.advancedSettingsManager.enableAlwaysHiddenSection,
              itemID != targetID,
              targetID != nil || !layout[kind, default: []].contains(where: { $0.id == itemID }),
              let preview = makeMovePreview(itemID: itemID, to: kind, before: targetID, from: layout),
              preview.mapValues({ $0.map(\.id) }) != layout.mapValues({ $0.map(\.id) }) else { return }
        moveQueue.append((itemID, kind, targetID))
        withAnimation(.easeInOut(duration: 0.15)) { queuedMovePreview = preview }
        startLayoutMoveQueue()
    }

    /// 每次确认后从真实快照重算剩余预览；失败不会把错误位置传给下一次移动。
    private func startLayoutMoveQueue() {
        guard isPageVisible, moveTask == nil, !moveQueue.isEmpty else { return }
        moveTask = Task {
            defer {
                moveQueue.removeAll()
                queuedMovePreview = nil
                moveTask = nil
            }
            while isPageVisible, !Task.isCancelled, let request = moveQueue.first {
                await moveLayoutItem(itemID: request.itemID, to: request.kind, before: request.targetID)
                guard !Task.isCancelled, isPageVisible else { return }
                moveQueue.removeFirst()
                var preview = sections
                for pending in moveQueue {
                    if let next = makeMovePreview(itemID: pending.itemID, to: pending.kind, before: pending.targetID, from: preview) {
                        preview = next
                    }
                }
                queuedMovePreview = moveQueue.isEmpty ? nil : preview
            }
        }
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
            startLayoutMoveQueue()
        }
    }

    private func announceLayoutResult() {
        let message = moveFailed
            ? L10n.string("Could not move the menu bar item. Its actual position is shown; try again after closing menus.")
            : L10n.string("Layout updated.")
        NSAccessibility.post(
            element: NSApplication.shared,
            notification: .announcementRequested,
            userInfo: [.announcement: message, .priority: NSAccessibilityPriorityLevel.medium.rawValue]
        )
    }

    /// 合成鼠标事件不能触发用户 Command-drag 的“展开全部”逻辑或自动收起。
    private func performDrag(from source: CGPoint, to destination: CGPoint) async -> Bool {
        guard !Task.isCancelled, !MenuInteractionGuard.isInteracting,
              !appState.itemManager.isMovingItem
        else { return false }
        // 用户输入等待不计入系统移动超时；长按下一次拖拽时保留当前操作，离页取消可立即退出。
        while NSEvent.pressedMouseButtons != 0 || !NSEvent.modifierFlags.isDisjoint(with: [.command, .control, .option, .shift]) {
            guard !Task.isCancelled else { return false }
            do { try await Task.sleep(for: .milliseconds(30)) } catch { return false }
        }
        guard !Task.isCancelled, !MenuInteractionGuard.isInteracting,
              !appState.itemManager.isMovingItem else { return false }
        isPostingMove = true
        defer { isPostingMove = false }
        appState.eventManager.stopAll()
        defer { appState.eventManager.startAll() }
        return await MenuBarItemAXMover.commandDrag(from: source, to: destination)
    }

    /// 有 CGS 身份时沿用原生移动接口，避免空分区的几何落点命中分隔符。
    /// AX-only 项才使用屏内坐标；移动是否成功仍由后续新快照确认。
    private func performLayoutMove(_ item: RowItem, to kind: MenuBarItemAXDiscovery.SectionKind, anchorID: String? = nil, destination: CGPoint?) async -> Bool {
        guard !Task.isCancelled, !MenuInteractionGuard.isInteracting else { return false }
        // NSItemProvider 的放下回调可能早于真实鼠标释放；原生路径也必须等待，
        // 避免合成 mouseUp 和指针归位打断用户尚未结束的拖拽或下一次按下。
        // 下一次拖拽可能持续超过两秒，不能把仍在等待用户输入的操作判为失败并移出队列。
        while NSEvent.pressedMouseButtons != 0 {
            guard !Task.isCancelled else { return false }
            do { try await Task.sleep(for: .milliseconds(10)) } catch { return false }
        }
        guard !Task.isCancelled, !MenuInteractionGuard.isInteracting else { return false }
        if item.id.hasPrefix("cgs:"), let id = CGWindowID(item.id.dropFirst(4)),
           anchorID == nil || anchorID?.hasPrefix("cgs:") == true {
            let items = MenuBarItem.getMenuBarItems(onScreenOnly: false, activeSpaceOnly: true)
            guard let source = items.first(where: { $0.windowID == id }), source.isMovable,
                  item.bundleID == nil || source.owningApplication?.bundleIdentifier == item.bundleID else { return false }
            let anchor: MenuBarItem?
            if let anchorID {
                guard anchorID.hasPrefix("cgs:"), let targetID = CGWindowID(anchorID.dropFirst(4)) else { return false }
                anchor = items.first { $0.windowID == targetID }
            } else {
                anchor = items.first { $0.info == (kind == .alwaysHidden ? .alwaysHiddenControlItem : .hiddenControlItem) }
            }
            guard let anchor, source.windowID != anchor.windowID else { return false }
            do {
                let target: MenuBarItemManager.MoveDestination = anchorID == nil && kind == .visible ? .rightOfItem(anchor) : .leftOfItem(anchor)
                defer { isPostingMove = false }
                try await appState.itemManager.move(item: source, to: target, maxAttempts: 1) {
                    isPostingMove = true
                }
                return true
            } catch { return false }
        }
        guard let frame = item.quartzFrame, let destination,
              let screen = NSScreen.screens.first(where: { CGDisplayBounds($0.displayID).contains(CGPoint(x: frame.midX, y: frame.midY)) }),
              CGDisplayBounds(screen.displayID).contains(destination), abs(frame.midY - destination.y) <= 8 else { return false }
        return await performDrag(from: CGPoint(x: frame.midX, y: frame.midY), to: destination)
    }

    /// 分区空白处的落点只改变分区；同区放下不重排已有图标。
    private func drop(itemID: String, to kind: MenuBarItemAXDiscovery.SectionKind) async {
        await moveLayoutItem(itemID: itemID, to: kind)
    }

    /// 显示落点与系统快照分开：界面立即反馈，实际移动和确认仍串行执行。
    private func moveLayoutItem(
        itemID: String,
        to kind: MenuBarItemAXDiscovery.SectionKind,
        before targetID: String? = nil
    ) async {
        guard !isMoving, !Task.isCancelled, let original = findItem(id: itemID) else { return }
        guard original.item.isMovable, kind == .visible || original.item.canBeHidden else {
            moveFailed = true
            return
        }
        if let targetID {
            guard itemID != targetID, findItem(id: targetID)?.kind == kind else { return }
            if original.kind == kind, isImmediatelyBefore(itemID: itemID, targetID: targetID, in: kind) { return }
        } else if original.kind == kind {
            return
        }
        guard let preview = makeMovePreview(itemID: itemID, to: kind, before: targetID) else { return }

        scanGeneration += 1
        dividerPollGeneration += 1
        iconRetryGeneration += 1
        moveFailed = false
        isMoving = true
        appState.itemManager.isEditingLayout = true
        pendingMoves.insert(itemID)
        withAnimation(.easeInOut(duration: 0.15)) { movePreview = preview }

        // 可见区内排序无需展开隐藏区；隐藏项或隐藏落点仍先展开以保证坐标安全。
        let needsReveal = original.kind != .visible || kind != .visible
        let revealed = appState.menuBarManager.sections.compactMap { section -> (MenuBarSection, Int)? in
            guard needsReveal, section.isEnabled, section.controlItem.state == .hideItems else { return nil }
            section.setState(.showItems, persist: false)
            return (section, section.stateRevision)
        }
        defer {
            _ = restoreLayoutSections(revealed)
            appState.itemManager.isEditingLayout = false
            pendingMoves.remove(itemID)
            movePreview = nil
            isMoving = false
            dropTargetID = nil
        }
        if !revealed.isEmpty {
            do { try await Task.sleep(for: .milliseconds(250)) } catch { return }
        }

        // CGS 原生移动按身份即时解析窗口，不需要事先重扫全表；AX 坐标路径才刷新帧。
        let usesNativeMove = itemID.hasPrefix("cgs:") && (targetID == nil || targetID?.hasPrefix("cgs:") == true)
        if !usesNativeMove { await rescanAfterDrag() }
        guard !Task.isCancelled, let item = findItem(id: itemID)?.item else { return }
        let destination: CGPoint?
        if let targetID {
            let items = (sections[kind] ?? []).filter { $0.id != itemID }
            guard let index = items.firstIndex(where: { $0.id == targetID }) else { return }
            let left = index > 0 ? items[index - 1].quartzFrame : nil
            destination = reorderDestination(for: kind, leftFrame: left, rightFrame: items[index].quartzFrame)
        } else {
            destination = destinationPoint(for: kind)
        }
        _ = await performLayoutMove(item, to: kind, anchorID: targetID, destination: destination)
        guard !Task.isCancelled else { return }
        // 一次操作只发一次系统移动；窗口尚未稳定时只读回，不重复抢占鼠标。
        // 事件回执超时不等于系统未移动；失败回执也读回实际位置，不能直接回滚已落地的操作。
        var confirmed = await waitForDropResult(itemID: itemID, to: kind, before: targetID)
        guard !Task.isCancelled else { return }
        let restored = restoreLayoutSections(revealed)
        if confirmed, restored {
            // 收起会再次改变窗口位置；收起后的确认也必须完成，不能留给手动刷新。
            confirmed = await waitForDropResult(itemID: itemID, to: kind, before: targetID)
        } else if !confirmed {
            await refreshAfterDrop()
        }
        guard !Task.isCancelled else { return }
        moveFailed = !confirmed
        if confirmed { appState.itemManager.recordLayoutChoice() }
    }

    /// 预览仅移动指定项；图标落点按目标插入，分区落点匹配原生分隔符两侧的位置。
    private func makeMovePreview(
        itemID: String,
        to kind: MenuBarItemAXDiscovery.SectionKind,
        before targetID: String?,
        from layout: [MenuBarItemAXDiscovery.SectionKind: [RowItem]]? = nil
    ) -> [MenuBarItemAXDiscovery.SectionKind: [RowItem]]? {
        var preview = layout ?? sections
        guard let original = preview.first(where: { $0.value.contains(where: { $0.id == itemID }) }),
              let item = original.value.first(where: { $0.id == itemID }) else { return nil }
        preview[original.key]?.removeAll { $0.id == itemID }
        var target = preview[kind] ?? []
        if let targetID {
            guard let index = target.firstIndex(where: { $0.id == targetID }) else { return nil }
            target.insert(item, at: index)
        } else if kind == .visible {
            // 原生移动放在隐藏分隔符右侧，即可见区最左端。
            target.insert(item, at: 0)
        } else {
            target.append(item)
        }
        preview[kind] = target
        return preview
    }

    /// 仅从系统读回判定成功；正常落点只读一次，帧尚未稳定时做有界的轻量重试。
    private func waitForDropResult(
        itemID: String,
        to kind: MenuBarItemAXDiscovery.SectionKind,
        before targetID: String?
    ) async -> Bool {
        let delays = [0, 80, 160, 320]
        var attempt = 0
        while attempt < delays.count {
            guard !Task.isCancelled else { return false }
            // 下一次原生拖拽占用输入时，旧帧不能耗尽确认次数并让上一项出队回跳。
            // 保留投影和队列，松开后重新读回；离开页面仍通过任务取消立即终止。
            while NSEvent.pressedMouseButtons != 0 {
                do { try await Task.sleep(for: .milliseconds(10)) } catch { return false }
            }
            let delay = delays[attempt]
            if delay > 0 {
                do { try await Task.sleep(for: .milliseconds(delay)) } catch { return false }
            }
            guard !Task.isCancelled else { return false }
            if NSEvent.pressedMouseButtons != 0 { continue }
            await rescanAfterDrag()
            guard !Task.isCancelled else { return false }
            if NSEvent.pressedMouseButtons != 0 { continue }
            if let targetID {
                if hasLanded(itemID: itemID, targetID: targetID, toKind: kind) { return true }
            } else if findItem(id: itemID)?.kind == kind {
                return true
            }
            attempt += 1
        }
        return false
    }

    /// 只恢复本次临时展开且未被用户改动的分区；多次调用不会重复写入状态。
    @discardableResult
    private func restoreLayoutSections(_ revealed: [(MenuBarSection, Int)]) -> Bool {
        var restored = false
        for (section, revision) in revealed where section.stateRevision == revision {
            section.setState(.hideItems, persist: false)
            restored = true
        }
        return restored
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

    /// 图标上的落点插入目标之前；分区、排序共用相同的预览和确认流程。
    private func drop(itemID: String, onto targetID: String) async {
        guard let target = findItem(id: targetID) else { return }
        await moveLayoutItem(itemID: itemID, to: target.kind, before: targetID)
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
    private func refresh(showProgress: Bool = true) async {
        // Guard against overlapping scans when Refresh is tapped repeatedly.
        guard !isRefreshing else {
            return
        }
        isRefreshing = true
        isManualRefresh = showProgress
        defer {
            isManualRefresh = false
            isRefreshing = false
        }
        await scanAndApply()
    }

    /// Settled re-scan after a drag: unlike the Refresh button it must never
    /// be skipped by the `isRefreshing` guard (e.g. the tab-open scan still
    /// running), otherwise the UI stays on the pre-drag snapshot until the
    /// user hits Refresh by hand.
    private func refreshAfterDrop() async {
        // 拖动只需读回实时窗口/分区；不再等待或触发一轮遍历所有应用的 AX 扫描。
        await rescanAfterDrag()
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

        var axFallback = axSnapshot
        if displayableCachedItems.isEmpty, MenuBarItemAXDiscovery.isTrusted() {
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
        return axItems.filter { axItem in
            // 完整 CGS 宿主快照已包含真实状态窗口，不再混入该宿主的 AX 图片/代理节点。
            // AX 仅补充 CGS 尚未发现的宿主；不能把不同坐标系下的两份宿主列表叠加。
            if cached.contains(where: { $0.ownerPID == axItem.pid }) { return false }
            let candidates = cached.indices.filter { index in
                let item = cached[index]
                if let frame = axItem.axFrame, !frame.isEmpty {
                    let other = item.frame
                    let intersection = frame.intersection(other)
                    let area = min(frame.width * frame.height, other.width * other.height)
                    // AX 常返回内部按钮/图片边框，CGS 返回带留白的窗口边框。
                    // 允许内缩但不能靠同名或仅同一进程吞掉相邻的真实图标。
                    let tolerance: CGFloat = axItem.pid == item.ownerPID ? 6 : 1
                    return area > 0 && !intersection.isNull &&
                        intersection.width * intersection.height >= area * 0.8 &&
                        abs(frame.midX - other.midX) <= tolerance &&
                        abs(frame.midY - other.midY) <= (axItem.pid == item.ownerPID ? max(6, max(frame.height, other.height) / 2) : tolerance)
                }
                guard let title = axItem.title, !title.isEmpty else { return false }
                return axItem.pid == item.ownerPID && title == item.title &&
                    axItems.filter { $0.pid == axItem.pid && $0.title == title }.count == 1 &&
                    cached.filter { $0.ownerPID == item.ownerPID && $0.title == title }.count == 1
            }
            return candidates.count != 1
        }
    }

    /// 分区已由项目管理器在完整窗口快照中确认；不能因 UI 的 AX 分隔符缺失而降级为全部可见。
    private func cachedKind(for item: MenuBarItem, hiddenX: CGFloat?, alwaysHiddenX: CGFloat?) -> MenuBarItemAXDiscovery.SectionKind {
        switch appState.itemManager.itemCache.section(for: item) {
        case .visible: return .visible
        case .hidden: return .hidden
        case .alwaysHidden: return .alwaysHidden
        case nil: return MenuBarItemAXDiscovery.classify(centerX: item.frame.midX, hiddenDividerX: hiddenX, alwaysHiddenDividerX: alwaysHiddenX)
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
                let section = cachedKind(for: item, hiddenX: hiddenX, alwaysHiddenX: alwaysHiddenX)
                grouped[section, default: []].append(
                    RowItem(
                        id: stableID(for: "cgs:\(item.windowID)"),
                        title: item.displayName,
                        subtitle: item.subtitle,
                        systemImage: systemImage,
                        appIcon: appIcon,
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
        if displayableCachedItems.isEmpty, isMissingExpectedDivider(hiddenX: hiddenX, alwaysHiddenX: alwaysHiddenX) {
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
        SectionMeta(kind: .alwaysHidden, title: "Always Hidden", icon: "lock", subtitle: "Out of sight until you double-click or ⌥-click the chevron", emptyHint: "No always-hidden icons — drop icons here to hide them"),
    ]
}

// MARK: - FlowLayout

/// 紧凑图标从左向右按真实顺序排列，宽度不足时换行，不压缩命中区域。
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
                    at: CGPoint(x: bounds.minX + row.x[position], y: bounds.minY + row.y),
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
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        let maxWidth = proposal.width ?? .infinity
        var rows = [Row]()
        var current = Row()
        var x: CGFloat = 0
        var y: CGFloat = 0
        func finishRow() {
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
