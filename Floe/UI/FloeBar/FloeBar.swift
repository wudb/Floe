//
//  FloeBar.swift
//  Floe
//

import Combine
import SwiftUI
import UniformTypeIdentifiers

// MARK: - FloeBarPanel

final class FloeBarPanel: NSPanel {
    private weak var appState: AppState?

    private(set) var currentSection: MenuBarSection.Name?

    private lazy var colorManager = FloeBarColorManager(floeBarPanel: self)

    private var cancellables = Set<AnyCancellable>()

    private var axActivationTask: Task<Void, Never>?

    /// 同一分区也可能连续请求不同屏幕；异步返回只能发布最新一次显示请求。
    private var presentationGeneration: UUID?
    private var contentDisplayID: CGDirectDisplayID?
    private var windowDragStartOrigin: CGPoint?
    private var reorderController: FloeBarReorderController?

    /// Automatic rehide must not collapse originals while their menu is in use.
    private(set) var isActivatingAXItem = false

    init(appState: AppState) {
        super.init(
            contentRect: .zero,
            styleMask: [.nonactivatingPanel, .fullSizeContentView, .borderless],
            backing: .buffered,
            defer: false
        )
        self.appState = appState
        self.title = "Floe Bar"
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.allowsToolTipsWhenApplicationIsInactive = true
        self.isFloatingPanel = true
        self.animationBehavior = .none
        self.backgroundColor = .clear
        self.hasShadow = false
        self.level = .mainMenu + 1
        self.collectionBehavior = [.fullScreenAuxiliary, .ignoresCycle, .moveToActiveSpace]
    }

    func performSetup() {
        configureCancellables()
    }

    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        // Close the panel when the active space changes, or when the screen parameters change.
        Publishers.Merge(
            NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.activeSpaceDidChangeNotification),
            NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
        )
        .sink { [weak self] _ in
            self?.close()
        }
        .store(in: &c)

        // 手动把浮栏拖到另一屏后，根视图的屏幕尺寸/数据来源也必须重新绑定。
        publisher(for: \.screen)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] screen in
                guard let self, let screen else { return }
                refreshContent(for: screen)
            }
            .store(in: &c)

        // Update the panel's origin whenever its size changes.
        publisher(for: \.frame)
            .map(\.size)
            .removeDuplicates()
            .sink { [weak self] _ in
                guard
                    let self,
                    let screen
                else {
                    return
                }
                positionPanel(for: screen)
            }
            .store(in: &c)

        if let appState {
            let preferences = appState.settingsManager.generalSettingsManager.barPreferences
            preferences.$presentationRevision.dropFirst()
                .sink { [weak self, weak appState] _ in
                    self?.close()
                    guard let appState else { return }
                    if let changed = preferences.changedSection {
                        let name: MenuBarSection.Name = changed == "alwaysHidden" ? .alwaysHidden : .hidden
                        self?.collapseNativeHierarchy(for: name, in: appState)
                    }
                }
                .store(in: &c)
        }

        if let appState {
            appState.settingsManager.generalSettingsManager.$useFloeBar.dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { [weak self, weak appState] _ in
                    self?.close()
                    guard let appState else { return }
                    let preferences = appState.settingsManager.generalSettingsManager.barPreferences
                    for section in appState.menuBarManager.sections {
                        let key = section.name == .alwaysHidden ? "alwaysHidden" : "hidden"
                        if preferences.presentation(for: key) == .inherited {
                            self?.collapseNativeHierarchy(for: section.name, in: appState)
                        }
                    }
                }
                .store(in: &c)
        }

        if let preferences = appState?.settingsManager.generalSettingsManager.barPreferences {
            preferences.$revision.dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self, isVisible, let screen else { return }
                    positionPanel(for: screen)
                }
                .store(in: &c)
        }

        cancellables = c
    }

    /// 普通隐藏层收起时，其左侧的始终隐藏层也会被遮住，逻辑状态必须一并收起。
    /// 这里只重置当前展开状态，保留两个分区各自的呈现规则和下次启动偏好。
    private func collapseNativeHierarchy(for name: MenuBarSection.Name, in appState: AppState) {
        let names: [MenuBarSection.Name] = name == .alwaysHidden ? [.alwaysHidden] : [.visible, .hidden, .alwaysHidden]
        for name in names { appState.menuBarManager.section(withName: name)?.setState(.hideItems, persist: false) }
    }

    private func refreshContent(for screen: NSScreen) {
        guard isVisible, contentDisplayID != screen.displayID,
              let appState, let section = currentSection
        else { return }
        contentDisplayID = screen.displayID
        reorderController?.cancel()
        let reorder = FloeBarReorderController()
        reorder.activate()
        reorderController = reorder
        isMovableByWindowBackground = true
        contentView = FloeBarHostingView(appState: appState, colorManager: colorManager, reorder: reorder, screen: screen, section: section) { [weak self] in
            self?.close()
        }
        colorManager.invalidate()
        colorManager.updateAllProperties(with: frame, screen: screen)
    }

    private func positionPanel(for screen: NSScreen) {
        if let preferences = appState?.settingsManager.generalSettingsManager.barPreferences,
           let origin = preferences.fixedOrigin(size: frame.size, bounds: screen.visibleFrame, display: screen.persistentDisplayKey) {
            setFrameOrigin(origin)
        } else {
            updateOrigin(for: screen)
        }
    }

    func toggleFixedPosition() {
        guard let screen, let preferences = appState?.settingsManager.generalSettingsManager.barPreferences else { return }
        if preferences.fixedPosition { preferences.fixedPosition = false } else {
            preferences.pin(origin: frame.origin, size: frame.size, bounds: screen.visibleFrame, display: screen.persistentDisplayKey)
        }
    }

    override func sendEvent(_ event: NSEvent) {
        if event.type == .leftMouseDown { windowDragStartOrigin = frame.origin }
        super.sendEvent(event)
        // AppKit 的窗口背景拖拽可在 mouseDown 内完成跟踪；仅在实际拖动后更新该屏锚点。
        if event.type == .leftMouseDown || event.type == .leftMouseUp,
           windowDragStartOrigin != nil, windowDragStartOrigin != frame.origin, let screen,
           let preferences = appState?.settingsManager.generalSettingsManager.barPreferences, preferences.fixedPosition {
            preferences.pin(origin: frame.origin, size: frame.size, bounds: screen.visibleFrame, display: screen.persistentDisplayKey)
        }
        if event.type == .leftMouseUp { windowDragStartOrigin = nil }
    }

    private func updateOrigin(for screen: NSScreen) {
        guard let appState else {
            return
        }

        func getOrigin(for floeBarLocation: FloeBarLocation) -> CGPoint {
            let menuBarHeight = screen.getMenuBarHeight() ?? 0
            let originY = ((screen.frame.maxY - 1) - menuBarHeight) - frame.height

            var originForRightOfScreen: CGPoint {
                CGPoint(x: screen.frame.maxX - frame.width, y: originY)
            }

            switch floeBarLocation {
            case .dynamic:
                if appState.eventManager.isMouseInsideEmptyMenuBarSpace {
                    return getOrigin(for: .mousePointer)
                }
                return getOrigin(for: .floeIcon)
            case .mousePointer:
                guard let location = MouseCursor.locationAppKit else {
                    return getOrigin(for: .floeIcon)
                }

                let lowerBound = screen.frame.minX
                let upperBound = screen.frame.maxX - frame.width

                guard lowerBound <= upperBound else {
                    return originForRightOfScreen
                }

                return CGPoint(x: (location.x - frame.width / 2).clamped(to: lowerBound...upperBound), y: originY)
            case .floeIcon:
                let lowerBound = screen.frame.minX
                let upperBound = screen.frame.maxX - frame.width

                guard
                    lowerBound <= upperBound,
                    let section = appState.menuBarManager.section(withName: .visible),
                    // Bridging.getWindowFrame is more reliable than ControlItem.windowFrame,
                    // i.e. if the control item is offscreen. Fall back to our own window's
                    // frame when the system no longer exposes a per-item window ID.
                    let itemFrame = section.controlItem.windowID.flatMap({ Bridging.getWindowFrame(for: $0) })
                        ?? section.controlItem.windowFrame
                else {
                    return originForRightOfScreen
                }

                return CGPoint(x: (itemFrame.midX - frame.width / 2).clamped(to: lowerBound...upperBound), y: originY)
            }
        }

        setFrameOrigin(getOrigin(for: appState.settingsManager.generalSettingsManager.floeBarLocation))
    }

    /// Restores hidden originals before AXPress; parked status items may acknowledge a press
    /// without opening anything. Only transient state is changed, and menus stay revealed
    /// until they close. A later activation waits for the previous reveal to clean up.
    func activateAXItem(_ item: MenuBarItemAXDiscovery.AXMenuBarItem) {
        guard let appState else {
            return
        }
        close()
        let previous = axActivationTask
        previous?.cancel()
        axActivationTask = Task { @MainActor in
            await previous?.value
            guard !Task.isCancelled else {
                return
            }

            isActivatingAXItem = true
            let sections = appState.menuBarManager.sections.filter {
                $0.isEnabled && $0.controlItem.state == .hideItems
            }
            let revealed = sections.map { section in
                section.setState(.showItems, persist: false)
                return (section: section, revision: section.stateRevision)
            }
            defer {
                for entry in revealed where entry.section.stateRevision == entry.revision {
                    entry.section.setState(.hideItems, persist: false)
                }
                isActivatingAXItem = false
                for section in appState.menuBarManager.sections where !section.isHidden {
                    section.startRehideChecks()
                }
            }

            do {
                // Match the native section toggle's animation interval before pressing.
                try await Task.sleep(for: .milliseconds(250))
                try Task.checkCancellation()

                // Once a press is committed, cancellation must not restore the originals
                // beneath its popup. This unstructured task owns the press and menu lifetime;
                // cancelling the outer task only supersedes a request still waiting to press.
                try await Task { @MainActor in
                    let previousWindows = Set(WindowInfo.getOnScreenWindows().map(\.windowID))
                    let acknowledged = await Task.detached(priority: .userInitiated) {
                        MenuBarItemAXDiscovery.press(item)
                    }.value

                    // AX success alone is not evidence of a menu. Conversely, a modal menu
                    // can open while the request times out, so check even after an AX error.
                    func hasOpenMenu() -> Bool {
                        WindowInfo.getOnScreenWindows().contains { window in
                            !previousWindows.contains(window.windowID) &&
                                !window.frame.isEmpty && !window.isMenuBarItem &&
                                window.layer >= CGWindowLevelForKey(.mainMenuWindow) &&
                                (window.ownerPID == item.pid ||
                                    NSRunningApplication(processIdentifier: window.ownerPID)?.bundleIdentifier == "com.apple.controlcenter")
                        }
                    }
                    var observedMenu = false
                    for _ in 0..<10 {
                        if hasOpenMenu() {
                            observedMenu = true
                            break
                        }
                        try await Task.sleep(for: .milliseconds(100))
                    }
                    guard observedMenu else {
                        Logger.floeBar.error("axActivation no visible menu pid=\(item.pid) acknowledged=\(acknowledged)")
                        return
                    }
                    Logger.floeBar.info("axActivation observed menu pid=\(item.pid)")
                    // Keep the reveal while any popup remains, including a parent whose
                    // frontmost submenu closed or a replacement popup with a new window ID.
                    while hasOpenMenu() {
                        try await Task.sleep(for: .milliseconds(150))
                    }
                }.value
            } catch {
                // Cancellation before the press restores the reveal without clicking.
            }
        }
    }

    func show(section: MenuBarSection.Name, on screen: NSScreen) async {
        guard let appState else {
            return
        }

        // Important that we set the navigation state and current section before updating the cache.
        let generation = UUID()
        presentationGeneration = generation
        appState.navigationState.isFloeBarPresented = true
        currentSection = section

        await appState.itemManager.cacheItemsIfNeeded()

        if ScreenCapture.cachedCheckPermissions() {
            await appState.imageCache.updateCache()
        }

        // 分区名相同不代表同一次请求；关闭、重新打开和换屏都会淘汰旧请求。
        guard presentationGeneration == generation else {
            return
        }
        guard !Task.isCancelled else {
            close()
            return
        }

        contentDisplayID = screen.displayID
        reorderController?.cancel()
        let reorder = FloeBarReorderController()
        reorder.activate()
        reorderController = reorder
        isMovableByWindowBackground = true
        contentView = FloeBarHostingView(appState: appState, colorManager: colorManager, reorder: reorder, screen: screen, section: section) { [weak self] in
            self?.close()
        }

        positionPanel(for: screen)

        // 先使用已有颜色显示面板，新颜色异步更新；同步截图可能永久阻塞主线程。
        colorManager.updateAllProperties(with: frame, screen: screen)

        orderFrontRegardless()
    }

    override func close() {
        reorderController?.cancel()
        reorderController = nil
        isMovableByWindowBackground = true
        presentationGeneration = nil
        contentDisplayID = nil
        colorManager.invalidate()
        super.close()
        contentView = nil
        currentSection = nil
        appState?.navigationState.isFloeBarPresented = false
    }
}

// MARK: - FloeBarHostingView

private final class FloeBarHostingView: NSHostingView<AnyView> {
    override var safeAreaInsets: NSEdgeInsets {
        NSEdgeInsets()
    }

    init(
        appState: AppState,
        colorManager: FloeBarColorManager,
        reorder: FloeBarReorderController,
        screen: NSScreen,
        section: MenuBarSection.Name,
        closePanel: @escaping () -> Void
    ) {
        super.init(
            rootView: FloeBarContentView(screen: screen, section: section, closePanel: closePanel)
                .appLanguage()
                .environmentObject(appState)
                .environmentObject(appState.imageCache)
                .environmentObject(appState.itemManager)
                .environmentObject(appState.menuBarManager)
                .environmentObject(colorManager)
                .environmentObject(reorder)
                .environmentObject(appState.settingsManager.generalSettingsManager.barPreferences)
                .erasedToAnyView()
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable)
    required init(rootView: AnyView) {
        fatalError("init(rootView:) has not been implemented")
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
}

// MARK: - SplitPillShape

/// Stadium pill mirroring the split-shape trailing pill geometry in
/// `shapePath` (rect body + oval/square end caps), so the Floe Bar clips and
/// borders exactly like the menu bar pill.
private struct SplitPillShape: InsettableShape {
    var leadingEndCap: MenuBarEndCap
    var trailingEndCap: MenuBarEndCap
    var cornerRadiusFactor: Double = 1
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        guard r.height > 0, r.width > 0 else {
            return Path()
        }
        let factor = CGFloat(cornerRadiusFactor).clamped(to: 0...1)
        // Partial rounding: per-side radii via uneven rounded rect.
        if factor < 0.999 {
            let radius = r.height / 2 * factor
            let leadingRadius: CGFloat = leadingEndCap == .round ? radius : 0
            let trailingRadius: CGFloat = trailingEndCap == .round ? radius : 0
            return UnevenRoundedRectangle(
                topLeadingRadius: leadingRadius,
                bottomLeadingRadius: leadingRadius,
                bottomTrailingRadius: trailingRadius,
                topTrailingRadius: trailingRadius,
                style: .circular
            ).path(in: r)
        }
        var path = Path()
        path.addRect(CGRect(x: r.minX + r.height / 2, y: r.minY, width: max(0, r.width - r.height), height: r.height))
        switch leadingEndCap {
        case .square:
            path.addRect(CGRect(origin: r.origin, size: CGSize(width: r.height, height: r.height)))
        case .round:
            path.addEllipse(in: CGRect(origin: r.origin, size: CGSize(width: r.height, height: r.height)))
        }
        switch trailingEndCap {
        case .square:
            path.addRect(CGRect(x: r.maxX - r.height, y: r.minY, width: r.height, height: r.height))
        case .round:
            path.addEllipse(in: CGRect(x: r.maxX - r.height, y: r.minY, width: r.height, height: r.height))
        }
        return path
    }

    func inset(by amount: CGFloat) -> SplitPillShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }
}

// MARK: - FloeBarContentView

private struct FloeBarContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var colorManager: FloeBarColorManager
    @EnvironmentObject var itemManager: MenuBarItemManager
    @EnvironmentObject var imageCache: MenuBarItemImageCache
    @EnvironmentObject var menuBarManager: MenuBarManager
    @EnvironmentObject var preferences: FloeBarPreferences
    @EnvironmentObject var reorder: FloeBarReorderController
    @State private var frame = CGRect.zero
    @State private var scrollIndicatorsFlashTrigger = 0
    @State private var axRows = [AXRowItem]()
    @State private var hasAXPermission = MenuBarItemAXDiscovery.isTrusted()
    @State private var isLoadingAXRows = false

    let screen: NSScreen
    let section: MenuBarSection.Name
    let closePanel: () -> Void

    private var items: [MenuBarItem] {
        itemManager.itemCache.managedItems(for: section)
    }

    private var configuration: MenuBarAppearanceConfigurationV2 {
        appState.appearanceManager.configuration
    }

    private var horizontalPadding: CGFloat {
        configuration.hasRoundedShape ? 7 : 5
    }

    private var verticalPadding: CGFloat {
        screen.hasNotch ? 0 : 2
    }

    private var contentHeight: CGFloat? {
        guard let menuBarHeight = screen.getMenuBarHeight() ?? imageCache.menuBarHeight else {
            return nil
        }
        if configuration.shapeKind != .none && configuration.isInset && screen.hasNotch {
            // 低分辨率刘海屏扣除内缩后仍必须容纳完整图标/点击区域。
            return max(NSStatusBar.system.thickness, menuBarHeight - appState.appearanceManager.menuBarInsetAmount * 2)
        }
        return menuBarHeight
    }

    private var clipShape: AnyInsettableShape {
        barShape
    }

    /// Whether the bar mirrors the split-shape trailing pill (same end caps,
    /// tint opacity, inside border and shadow).
    private var isSplitPill: Bool {
        configuration.shapeKind == .split
    }

    private var barShape: AnyInsettableShape {
        if preferences.layout != .icons || reorder.isEditing {
            return AnyInsettableShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        // Same stadium shape as the split's trailing pill: rectangular body
        // plus 2 oval/rectangular end caps (mirror `shapePath`).
        let trailing = configuration.splitShapeInfo.trailing
        if isSplitPill {
            return AnyInsettableShape(
                SplitPillShape(
                    leadingEndCap: trailing.leadingEndCap,
                    trailingEndCap: trailing.trailingEndCap,
                    cornerRadiusFactor: configuration.cornerRadius
                )
            )
        } else if configuration.hasRoundedShape {
            if configuration.cornerRadius >= 0.999 {
                return AnyInsettableShape(Capsule())
            }
            return AnyInsettableShape(
                RoundedRectangle(
                    cornerRadius: max(0, frame.height / 2 * CGFloat(configuration.cornerRadius)),
                    style: .continuous
                )
            )
        } else {
            return AnyInsettableShape(RoundedRectangle(cornerRadius: frame.height / 5, style: .continuous))
        }
    }

    /// Bar tint opacity: matches the split, otherwise keeps the old 0.2.
    private var barTintOpacity: Double {
        isSplitPill ? configuration.current.tintOpacity : 0.2
    }

    @ViewBuilder
    private var splitBorderOverlay: some View {
        // Mirror MenuBarTintView HACK: stroke at double width then trim the outer half
        // via the clipShape right after → border sits neatly inside the pill.
        if isSplitPill, configuration.current.hasBorder {
            barShape.stroke(
                Color(cgColor: configuration.current.borderColor),
                lineWidth: CGFloat(configuration.current.borderWidth) * 2
            )
        }
    }

    private var barShadowColor: Color {
        if isSplitPill {
            configuration.current.hasShadow ? .black.opacity(0.5) : .clear
        } else {
            .black.opacity(shadowOpacity)
        }
    }

    private var barShadowRadius: CGFloat {
        isSplitPill ? 5 : 2.5
    }

    private var shadowOpacity: CGFloat {
        configuration.current.hasShadow ? 0.5 : 0.33
    }

    var body: some View {
        VStack(spacing: 4) {
            // 日常展示只保留图标栏，整理时才显示操作和反馈。
            if reorder.isEditing {
                toolbar
            }
            ZStack {
                content
                    .frame(height: preferences.layout == .icons ? contentHeight : nil)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, verticalPadding)
                    .layoutBarStyle(appState: appState, averageColorInfo: colorManager.colorInfo, tintOpacity: barTintOpacity, useLiveBlur: isSplitPill, isFullscreen: menuBarManager.presentationController.fullscreenState(on: screen) == true)
                    .foregroundStyle(colorManager.colorInfo?.color.brightness ?? 0 > 0.67 ? .black : .white)
                    .overlay(splitBorderOverlay)
                    .clipShape(clipShape)
                    .shadow(color: barShadowColor, radius: barShadowRadius)

                if configuration.current.hasBorder, !isSplitPill {
                    clipShape
                        .inset(by: configuration.current.borderWidth / 2)
                        .stroke(lineWidth: configuration.current.borderWidth)
                        .foregroundStyle(Color(cgColor: configuration.current.borderColor))
                }
            }
        }
        .padding(5)
        .contextMenu {
            Button(LocalizedStringKey(reorder.isEditing ? "Done" : "Reorder")) {
                toggleReordering()
            }
            .disabled(reorder.isMoving)
            Button(LocalizedStringKey(preferences.fixedPosition ? "Unpin position" : "Pin position")) {
                menuBarManager.floeBarPanel.toggleFixedPosition()
            }
            Button("Close", action: closePanel)
        }
        .frame(maxWidth: screen.visibleFrame.width)
        .fixedSize()
        .onFrameChange(update: $frame)
        .onAppear { reorder.activate() }
        .onDisappear { reorder.cancel() }
    }

    private func toggleReordering() {
        reorder.isEditing.toggle()
        // 整理时把拖拽交给图标，退出后恢复拖动浮栏背景。
        menuBarManager.floeBarPanel.isMovableByWindowBackground = !reorder.isEditing
    }

    private var toolbar: some View {
        VStack(spacing: 4) {
            HStack(spacing: 10) {
                Text(LocalizedStringKey(section == .alwaysHidden ? "Always Hidden" : "Hidden"))
                Spacer(minLength: 8)
                Button(LocalizedStringKey(reorder.isEditing ? "Done" : "Reorder")) {
                    toggleReordering()
                }
                    .disabled(reorder.isMoving)
                Button(LocalizedStringKey(preferences.fixedPosition ? "Unpin position" : "Pin position")) {
                    menuBarManager.floeBarPanel.toggleFixedPosition()
                }
                Button(action: closePanel) { Image(systemName: "xmark") }.accessibilityLabel("Close")
            }
            .font(.caption)
            .padding(8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
            if reorder.isMoving { ProgressView().controlSize(.small) }
            if reorder.failed {
                Text("Could not reorder the icon. Its actual position is shown; close other menus and try again.")
                    .font(.caption).fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(width: min(340, max(1, screen.visibleFrame.width - 20)))
    }

    private var gridColumns: Int {
        max(1, min(preferences.columns, Int(max(1, screen.visibleFrame.width - 24) / 84)))
    }

    /// 两条发现路径复用相同布局，列表/网格不会因截图失败而退回不可读的横排。
    @ViewBuilder
    private func arrangedRows<Content: View>(count: Int, @ViewBuilder rows: () -> Content) -> some View {
        switch preferences.layout {
        case .icons:
            ScrollView(.horizontal) { HStack(spacing: 4, content: rows) }
                .frame(maxWidth: max(1, screen.visibleFrame.width - 24))
                .defaultScrollAnchor(.trailing)
        case .list:
            ScrollView(.vertical) { LazyVStack(alignment: .leading, spacing: 4, content: rows) }
                .frame(width: min(340, max(1, screen.visibleFrame.width - 24)), height: min(CGFloat(count) * 44 + 8, screen.visibleFrame.height * 0.6))
        case .grid:
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: gridColumns), spacing: 6, content: rows)
            }
            .frame(
                width: min(CGFloat(gridColumns) * 84, max(1, screen.visibleFrame.width - 24)),
                height: min(CGFloat((count + gridColumns - 1) / gridColumns) * 68 + 8, screen.visibleFrame.height * 0.6)
            )
        }
    }

    @ViewBuilder
    private func tile<Icon: View>(name: String, @ViewBuilder icon: () -> Icon) -> some View {
        if preferences.layout == .list {
            HStack(spacing: 10) { icon().frame(width: 28, height: 28); Text(name).lineLimit(1); Spacer(minLength: 4) }
                .padding(6).frame(maxWidth: .infinity, minHeight: 40)
        } else if preferences.layout == .grid {
            VStack(spacing: 3) { icon().frame(width: 28, height: 28); Text(name).font(.caption).lineLimit(2) }
                .frame(maxWidth: .infinity, minHeight: 62)
        } else {
            icon().frame(minWidth: 28, minHeight: 22)
        }
    }

    private func endDropZone(_ last: FloeBarReorderController.Item) -> some View {
        Text("Drop at end")
            .font(.caption).padding(8)
            .frame(minWidth: 28, minHeight: 24)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
            .onDrop(of: [UTType.text], isTargeted: .constant(false)) { providers in
                reorder.accept(providers, before: last, after: true, section: section, appState: appState)
            }
    }

    private func cgsIcon(_ item: MenuBarItem) -> some View {
        Group {
            if let image = item.owningApplication?.icon {
                Image(nsImage: image).resizable().scaledToFit()
            } else { Image(systemName: "menubar.rectangle") }
        }
        .frame(width: 24, height: 22)
    }

    @ViewBuilder
    private func cgsRow(_ item: MenuBarItem) -> some View {
        if reorder.isEditing {
            tile(name: item.displayName) { cgsIcon(item) }
                .contentShape(Rectangle())
                .accessibilityLabel(item.displayName)
                .onDrag { item.isMovable ? reorder.provider(for: .cgs(item)) : NSItemProvider() }
                .onDrop(of: [UTType.text], isTargeted: .constant(false)) { providers in
                    reorder.accept(providers, before: .cgs(item), section: section, appState: appState)
                }
                .help("Drag an icon onto another to place it before that icon.")
        } else {
            Button {
                activateCGS(item, button: .left)
            } label: { tile(name: item.displayName) { cgsIcon(item) } }
            .buttonStyle(.plain)
            .help(item.displayName)
            .accessibilityLabel(item.displayName)
            .contextMenu {
                Button("Right click") {
                    closePanel()
                    itemManager.tempShowItem(item, clickWhenFinished: true, mouseButton: .right)
                }
            }
        }
    }

    private func activateCGS(_ item: MenuBarItem, button: CGMouseButton) {
        closePanel()
        Task {
            // 先完成浮栏/右键菜单的关闭，再让真实宿主接收点击。
            do { try await Task.sleep(for: .milliseconds(25)) } catch { return }
            itemManager.tempShowItem(item, clickWhenFinished: true, mouseButton: button)
        }
    }

    /// 自动隐藏和跨屏截图不适合 CGS 临时移动，优先提供可访问的 AX 项目列表。
    private var usesAXFallback: Bool {
        itemManager.isItemDiscoveryUnavailable || menuBarManager.isMenuBarHiddenBySystemUserDefaults ||
            (MenuBarItemAXDiscovery.isTrusted() &&
                (imageCache.cacheFailed(for: section) || imageCache.screen?.displayID != screen.displayID))
    }

    @ViewBuilder
    private var content: some View {
        if usesAXFallback {
            // macOS 27+: CGS no longer has per-item windows — show the app icon and
            // press via Accessibility instead of window snapshots + temp-show.
            axFallbackView
                .task {
                    await loadAXRows()
                    while !Task.isCancelled {
                        do { try await Task.sleep(for: .seconds(5)) } catch { return }
                        await loadAXRows()
                    }
                }
        } else if preferences.layout != .icons || reorder.isEditing, items.isEmpty {
            Text("No menu bar items").padding(8)
        } else if preferences.layout != .icons || reorder.isEditing {
            arrangedRows(count: items.count + (reorder.isEditing ? 1 : 0)) {
                ForEach(items, id: \.windowID) { cgsRow($0) }
                if reorder.isEditing, let last = items.last { endDropZone(.cgs(last)) }
            }
        } else if !ScreenCapture.cachedCheckPermissions() {
            HStack {
                Text("The Floe Bar requires screen recording permissions.")

                Button {
                    closePanel()
                    appState.navigationState.settingsNavigationIdentifier = .advanced
                    appState.appDelegate?.openSettingsWindow()
                } label: {
                    Text("Open Floe Settings")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.link)
            }
            .padding(.horizontal, 10)
        } else if imageCache.cacheFailed(for: section) {
            Text("Unable to display menu bar items")
                .padding(.horizontal, 10)
        } else {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(items, id: \.windowID) { item in
                        FloeBarItemView(item: item, closePanel: closePanel)
                    }
                }
            }
            .environment(\.isScrollEnabled, frame.width >= screen.frame.width)
            .defaultScrollAnchor(.trailing)
            .scrollIndicatorsFlash(trigger: scrollIndicatorsFlashTrigger)
            .task {
                scrollIndicatorsFlashTrigger += 1
            }
        }
    }

    // MARK: - AX fallback (macOS 27+)

    /// Icon row for the Floe Bar when CGS no longer has per-item windows.
    private struct AXRowItem: Identifiable {
        /// Stable ID across scans (not a random UUID) so
        /// SwiftUI diffs smoothly.
        let id: String
        let item: MenuBarItemAXDiscovery.AXMenuBarItem
        let title: String?
        let displayName: String
        let systemImage: String?
        let appIcon: NSImage?
        /// X center (AX coordinates) for visibility filtering, nil when the frame is unreadable.
        let midX: CGFloat?
    }

    private static let accessibilitySettingsURL = URL(
        string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
    )!

    @ViewBuilder
    private var axFallbackView: some View {
        if !hasAXPermission {
            HStack {
                Text("The Floe Bar requires accessibility permission.")

                Button {
                    NSWorkspace.shared.open(Self.accessibilitySettingsURL)
                } label: {
                    Text("Open System Settings")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.link)

                Button {
                    hasAXPermission = MenuBarItemAXDiscovery.isTrusted()
                    if hasAXPermission {
                        Task {
                            await loadAXRows()
                        }
                    }
                } label: {
                    Text("Check Again")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.link)
            }
            .padding(.horizontal, 10)
        } else if isLoadingAXRows && axRows.isEmpty {
            ProgressView()
                .padding(.horizontal, 10)
        } else if axRows.isEmpty {
            Text("Unable to display menu bar items")
                .padding(.horizontal, 10)
        } else {
            arrangedRows(count: axRows.count + (reorder.isEditing ? 1 : 0)) {
                ForEach(axRows) { axRowView($0) }
                if reorder.isEditing, let last = axRows.last { endDropZone(.ax(last.item)) }
            }
        }
    }

    @ViewBuilder
    private func axIcon(_ row: AXRowItem) -> some View {
        if let systemName = row.systemImage {
            Image(systemName: systemName)
                .font(.system(size: 16))
                .frame(minWidth: 28, minHeight: 22)
        } else if let icon = row.appIcon {
            Image(nsImage: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 22)
        } else if let title = row.title, !title.isEmpty {
            Text(title)
                .lineLimit(1)
                .padding(.horizontal, 6)
        } else {
            Text(row.displayName)
                .lineLimit(1)
                .padding(.horizontal, 6)
        }
    }

    @ViewBuilder
    private func axRowView(_ row: AXRowItem) -> some View {
        if reorder.isEditing {
            tile(name: row.displayName) { axIcon(row) }
                .contentShape(Rectangle())
                .accessibilityLabel(row.displayName)
                .onDrag { reorder.provider(for: .ax(row.item)) }
                .onDrop(of: [UTType.text], isTargeted: .constant(false)) { providers in
                    reorder.accept(providers, before: .ax(row.item), section: section, appState: appState)
                }
                .help("Drag an icon onto another to place it before that icon.")
        } else {
            Button { press(row) } label: { tile(name: row.displayName) { axIcon(row) } }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .help(row.displayName)
                .accessibilityLabel(row.displayName)
                .accessibilityAction(named: "press") { press(row) }
        }
    }

    /// Scans AX for the open section, filtering with the same divider-based
    /// classification as Menu Bar Layout. If the dividers haven't laid out yet
    /// (all nil), shows everything instead of returning an empty bar.
    ///
    /// Scans up to 3 times, ~0.8s apart: on macOS 27 the menubar layout needs
    /// time for the dividers to settle after showing a section; the first scan
    /// may hit the garbage frame of a parking spacer.
    @MainActor
    private func loadAXRows() async {
        guard !Task.isCancelled, !isLoadingAXRows else {
            return
        }
        isLoadingAXRows = true
        defer {
            isLoadingAXRows = false
        }

        hasAXPermission = MenuBarItemAXDiscovery.isTrusted()
        guard hasAXPermission else {
            return
        }

        for attempt in 0..<3 {
            await scanAXRowsOnce(attempt: attempt)
            if !axRows.isEmpty || Task.isCancelled {
                return
            }
            try? await Task.sleep(for: .milliseconds(800))
        }
    }

    /// One AX scan: lists items, filters by section, builds rows.
    @MainActor
    private func scanAXRowsOnce(attempt: Int) async {
        // NSWorkspace must be read on main; heavy discovery runs in the background. Divider
        // positions are also looked up in the background via AX (same coordinate space as axFrame).
        let apps = NSWorkspace.shared.runningApplications
        let wantedSection = section

        let (found, axDividers) = await Task.detached(priority: .userInitiated) {
            (
                MenuBarItemAXDiscovery.discoverItems(in: apps),
                MenuBarItemAXDiscovery.dividerFrames()
            )
        }.value

        guard !Task.isCancelled else { return }

        // Prefer dividers via AX, but EXCLUDE the garbage frame of a parking spacer
        // (hundreds of pt wide at the bottom of the screen) — if its minX (e.g. 7.0) leaks
        // into classification, every item drifts to Visible and the bar ends up empty.
        // button.window.frame on macOS 27 also returns the spacer rect (minX = 0),
        // so only use it as a fallback when AX is missing and the value is valid (minX > 0).
        func settledMinX(_ frame: CGRect?) -> CGFloat? {
            frame.flatMap { MenuBarItemAXDiscovery.isSettledDividerFrame($0) ? $0.minX : nil }
        }
        func saneMinX(_ value: CGFloat?) -> CGFloat? {
            value.flatMap { $0 > 0 ? $0 : nil }
        }
        let hiddenX = settledMinX(axDividers.hidden)
            ?? saneMinX(menuBarManager.section(withName: .hidden)?.controlItem.window?.frame.minX)
        let alwaysHiddenX = settledMinX(axDividers.alwaysHidden)
            ?? saneMinX(menuBarManager.section(withName: .alwaysHidden)?.controlItem.window?.frame.minX)

        func kind(centerX: CGFloat?) -> MenuBarItemAXDiscovery.SectionKind {
            MenuBarItemAXDiscovery.classify(centerX: centerX, hiddenDividerX: hiddenX, alwaysHiddenDividerX: alwaysHiddenX)
        }
        // The always-hidden divider alone cannot separate hidden from visible items.
        let hiddenBoundaryMissing = hiddenX == nil

        // Stable IDs across scans so SwiftUI doesn't redraw the whole list.
        var idCounts = [String: Int]()
        func stableID(for base: String) -> String {
            let n = idCounts[base, default: 0]
            idCounts[base] = n + 1
            return n == 0 ? base : "\(base)#\(n)"
        }

        // Discovery returns items by name; re-sort left→right as on the menubar.
        let ordered = found.sorted {
            ($0.axFrame?.midX ?? .greatestFiniteMagnitude) < ($1.axFrame?.midX ?? .greatestFiniteMagnitude)
        }
        var icons = [pid_t: NSImage]()
        var rows = [AXRowItem]()
        for item in ordered {
            // 与布局页分区一一对应；普通隐藏浮栏不混入始终隐藏项。
            if !hiddenBoundaryMissing {
                let actual = kind(centerX: item.axFrame?.midX)
                let matches = wantedSection == .alwaysHidden ? actual == .alwaysHidden : actual == .hidden
                if !matches { continue }
            }
            // Same icon selection as Menu Bar Layout: familiar system extras
            // use SF Symbols (a PID-based icon would yield the generic MenuBarAgent icon).
            let systemImage = MenuBarItemAXDiscovery.systemImageName(forIdentifier: item.identifier)
            if systemImage == nil, icons[item.pid] == nil {
                if item.bundleID == "com.apple.TextInputMenuAgent" {
                    icons[item.pid] = MenuBarItemAXDiscovery.inputSourceIcon()
                } else {
                    icons[item.pid] = NSRunningApplication(processIdentifier: item.pid)?.icon
                }
            }
            rows.append(
                AXRowItem(
                    id: stableID(for: "ax:\(item.pid):\(CFHash(item.element))"),
                    item: item,
                    title: item.title,
                    displayName: item.displayName,
                    systemImage: systemImage,
                    appIcon: icons[item.pid],
                    midX: item.axFrame?.midX
                )
            )
        }
        // Expanding spacer (garbage divider frames): drop items already visible in the
        // trailing pill region — the user already sees them on the menubar. Only filter
        // when the hidden/visible boundary is missing, even if always-hidden is readable.
        // Skip fullscreen (pill isn't drawn, width is stale).
        if hiddenBoundaryMissing,
           menuBarManager.presentationController.fullscreenState(on: screen) == false,
           let trailingWidth = MenuBarOverlayPanelContentView.currentTrailingVisibleWidth(for: screen.displayID),
           trailingWidth > 0, trailingWidth < screen.frame.width
        {
            let visibleMinX = screen.frame.maxX - trailingWidth
            rows.removeAll { ($0.midX ?? .greatestFiniteMagnitude) >= visibleMinX - 4 }
        }
        axRows = rows
        Logger.floeBar.info("axScan done wanted=\(wantedSection) attempt=\(attempt) found=\(found.count) rows=\(rows.count) hiddenBoundaryMissing=\(hiddenBoundaryMissing)")
    }

    /// The panel owns the activation task after closing and releasing this view.
    private func press(_ row: AXRowItem) {
        Logger.floeBar.info("axPress requested pid=\(row.item.pid) element=\(CFHash(row.item.element)) hasIdentifier=\(row.item.identifier != nil) hasTitle=\(row.item.title != nil)")
        menuBarManager.floeBarPanel.activateAXItem(row.item)
    }
}

// MARK: - FloeBarItemView

private struct FloeBarItemView: View {
    @EnvironmentObject var imageCache: MenuBarItemImageCache
    @EnvironmentObject var itemManager: MenuBarItemManager

    let item: MenuBarItem
    let closePanel: () -> Void

    private var leftClickAction: () -> Void {
        return { [weak itemManager] in
            guard let itemManager else {
                return
            }
            closePanel()
            Task {
                try? await Task.sleep(for: .milliseconds(25))
                itemManager.tempShowItem(item, clickWhenFinished: true, mouseButton: .left)
            }
        }
    }

    private var rightClickAction: () -> Void {
        return { [weak itemManager] in
            guard let itemManager else {
                return
            }
            closePanel()
            Task {
                try? await Task.sleep(for: .milliseconds(25))
                itemManager.tempShowItem(item, clickWhenFinished: true, mouseButton: .right)
            }
        }
    }

    private var image: NSImage? {
        guard
            let image = imageCache.images[item.windowID],
            image.width > 0, item.frame.width > 0
        else {
            return nil
        }
        let size = CGSize(
            width: item.frame.width,
            height: CGFloat(image.height) * item.frame.width / CGFloat(image.width)
        )
        return NSImage(cgImage: image, size: size)
    }

    var body: some View {
        if let image {
            Image(nsImage: image)
                .contentShape(Rectangle())
                .overlay {
                    FloeBarItemClickView(item: item, leftClickAction: leftClickAction, rightClickAction: rightClickAction)
                }
                .accessibilityLabel(item.displayName)
                .accessibilityAction(named: "left click", leftClickAction)
                .accessibilityAction(named: "right click", rightClickAction)
        }
    }
}

// MARK: - FloeBarItemClickView

private struct FloeBarItemClickView: NSViewRepresentable {
    private final class Represented: NSView {
        let item: MenuBarItem

        let leftClickAction: () -> Void
        let rightClickAction: () -> Void

        private var lastLeftMouseDownDate = Date.now
        private var lastRightMouseDownDate = Date.now

        private var lastLeftMouseDownLocation = CGPoint.zero
        private var lastRightMouseDownLocation = CGPoint.zero

        init(item: MenuBarItem, leftClickAction: @escaping () -> Void, rightClickAction: @escaping () -> Void) {
            self.item = item
            self.leftClickAction = leftClickAction
            self.rightClickAction = rightClickAction
            super.init(frame: .zero)
            self.toolTip = item.displayName
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func absoluteDistance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
            hypot(p1.x - p2.x, p1.y - p2.y).magnitude
        }

        override func mouseDown(with event: NSEvent) {
            super.mouseDown(with: event)
            lastLeftMouseDownDate = .now
            lastLeftMouseDownLocation = NSEvent.mouseLocation
        }

        override func rightMouseDown(with event: NSEvent) {
            super.rightMouseDown(with: event)
            lastRightMouseDownDate = .now
            lastRightMouseDownLocation = NSEvent.mouseLocation
        }

        override func mouseUp(with event: NSEvent) {
            super.mouseUp(with: event)
            guard
                Date.now.timeIntervalSince(lastLeftMouseDownDate) < 0.5,
                absoluteDistance(lastLeftMouseDownLocation, NSEvent.mouseLocation) < 5
            else {
                return
            }
            leftClickAction()
        }

        override func rightMouseUp(with event: NSEvent) {
            super.rightMouseUp(with: event)
            guard
                Date.now.timeIntervalSince(lastRightMouseDownDate) < 0.5,
                absoluteDistance(lastRightMouseDownLocation, NSEvent.mouseLocation) < 5
            else {
                return
            }
            rightClickAction()
        }
    }

    let item: MenuBarItem

    let leftClickAction: () -> Void
    let rightClickAction: () -> Void

    func makeNSView(context: Context) -> NSView {
        Represented(item: item, leftClickAction: leftClickAction, rightClickAction: rightClickAction)
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}

// MARK: - Logger

private extension Logger {
    static let floeBar = Logger(category: "FloeBar")
}
