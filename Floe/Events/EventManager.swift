//
//  EventManager.swift
//  Floe
//

import AXSwift
import Cocoa
import Combine

/// Manager for the various event monitors maintained by the app.
@MainActor
final class EventManager {
    /// The shared app state.
    private weak var appState: AppState?

    /// Storage for internal observers.
    private var cancellables = Set<AnyCancellable>()

    /// 延迟交互只保留当前请求；停止监视后不能再改变分区。
    private var clickTask: Task<Void, Never>?
    private var smartRehideTask: Task<Void, Never>?
    private var hoverTask: Task<Void, Never>?
    private var hoverIntent: Bool?
    private var isMonitoring = false
    private var isUserDraggingItem = false

    /// Cached menu bar window frames per display.
    ///
    /// `isMouseInsideMenuBar` runs on every mouse-move/scroll event, and the
    /// auto-hide/fullscreen branch lists every on-screen window via
    /// `CGWindowListCopyWindowInfo`. The frame only moves on space/display
    /// transitions (observed below to invalidate), so a short-TTL cache keeps
    /// the hot path off WindowServer IPC.
    private var cachedMenuBarFrames = [CGDirectDisplayID: (frame: CGRect, date: Date)]()

    /// Last time a hover/scroll check ran the expensive branch.
    private var lastHoverCheck = Date.distantPast
    private var lastScrollCheck = Date.distantPast

    /// How long a cached menu bar frame is trusted.
    private static let menuBarFrameTTL: TimeInterval = 2

    /// Minimum gap between hover/scroll checks that may hit WindowServer/AX.
    private static let hoverThrottleInterval: TimeInterval = 0.05
    private static let scrollThrottleInterval: TimeInterval = 0.05

    /// Height of the generous top-strip pre-check. The real bar is ~24-33pt;
    /// anything below this can never be inside it, so the check only skips
    /// work it would have done anyway.
    private static let menuBarStripHeight: CGFloat = 40

    // MARK: Monitors

    /// Monitor for mouse down events.
    private(set) lazy var mouseDownMonitor = UniversalEventMonitor(
        mask: [.leftMouseDown, .rightMouseDown]
    ) { [weak self] event in
        guard let self else {
            return event
        }
        switch event.type {
        case .leftMouseDown:
            if event.modifierFlags.contains(.command),
               let point = MouseCursor.locationCoreGraphics,
               let item = appState?.itemManager.itemCache.allItems.first(where: { $0.frame.contains(point) }) {
                // 明确用户拖拽取消该项的自动归位，保留用户的新选择。
                appState?.itemManager.removeTempShownItemFromCache(windowID: item.windowID)
            }
            handleShowOnClick(with: event)
            handleSmartRehide(with: event)
        case .rightMouseDown:
            handleShowRightClickMenu()
        default:
            break
        }
        handlePreventShowOnHover(with: event)
        return event
    }

    /// Monitor for mouse up events.
    private(set) lazy var mouseUpMonitor = UniversalEventMonitor(
        mask: .leftMouseUp
    ) { [weak self] event in
        self?.handleLeftMouseUp()
        return event
    }

    /// Monitor for mouse dragged events.
    private(set) lazy var mouseDraggedMonitor = UniversalEventMonitor(
        mask: .leftMouseDragged
    ) { [weak self] event in
        self?.handleLeftMouseDragged(with: event)
        return event
    }

    /// Monitor for mouse moved events.
    private(set) lazy var mouseMovedMonitor = UniversalEventMonitor(
        mask: .mouseMoved
    ) { [weak self] event in
        self?.handleShowOnHover()
        return event
    }

    /// Monitor for scroll wheel events.
    private(set) lazy var scrollWheelMonitor = UniversalEventMonitor(
        mask: .scrollWheel
    ) { [weak self] event in
        self?.handleShowOnScroll(with: event)
        return event
    }

    // MARK: All Monitors

    /// All monitors maintained by the app.
    private lazy var allMonitors = [
        mouseDownMonitor,
        mouseUpMonitor,
        mouseDraggedMonitor,
        mouseMovedMonitor,
        scrollWheelMonitor,
    ]

    // MARK: Initializers

    /// Creates an event manager with the given app state.
    init(appState: AppState) {
        self.appState = appState
    }

    /// Sets up the manager.
    func performSetup() {
        startAll()
        configureCancellables()
    }

    /// Configures the internal observers for the manager.
    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        if let appState {
            appState.settingsManager.generalSettingsManager.$showOnHover
                .removeDuplicates()
                .sink { [weak self] enabled in
                    self?.updateMouseMovedMonitor(showOnHover: enabled)
                }
                .store(in: &c)

            if let hiddenSection = appState.menuBarManager.section(withName: .hidden) {
                // In fullscreen mode, the menu bar slides down from the top on hover. Observe
                // the frame of the hidden section's control item, which we know will always be
                // in the menu bar, and run the show-on-hover check when it changes.
                Publishers.CombineLatest(
                    hiddenSection.controlItem.$windowFrame,
                    appState.$isActiveSpaceFullscreen
                )
                .sink { [weak self] _, isFullscreen in
                    guard
                        let self,
                        isFullscreen
                    else {
                        return
                    }
                    handleShowOnHover()
                }
                .store(in: &c)
            }
        }

        // The cached menu bar frame only moves on space/display transitions.
        Publishers.Merge(
            NSWorkspace.shared.notificationCenter
                .publisher(for: NSWorkspace.activeSpaceDidChangeNotification)
                .mapToVoid(),
            NotificationCenter.default
                .publisher(for: NSApplication.didChangeScreenParametersNotification)
                .mapToVoid()
        )
        .sink { [weak self] _ in
            self?.cachedMenuBarFrames.removeAll()
        }
        .store(in: &c)

        if let appState {
            // Showing/hiding the system menu bar (or entering/leaving a
            // fullscreen space) slides the menu bar window, so drop the cache.
            appState.menuBarManager.$isMenuBarHiddenBySystem
                .mapToVoid()
                .merge(with: appState.$isActiveSpaceFullscreen.mapToVoid())
                .sink { [weak self] _ in
                    self?.cachedMenuBarFrames.removeAll()
                }
                .store(in: &c)
        }

        cancellables = c
    }

    // MARK: Start/Stop

    /// Starts all monitors.
    func startAll() {
        isMonitoring = true
        for monitor in allMonitors where monitor !== mouseMovedMonitor {
            monitor.start()
        }
        updateMouseMovedMonitor(showOnHover: appState?.settingsManager.generalSettingsManager.showOnHover ?? false)
    }

    /// 悬停关闭时注销高频 mouseMoved 监听，而不是每个事件进来后再返回。
    /// 点击、滚动、拖动监视独立保留；停止管理器后设置变化不能重新启动监听。
    private func updateMouseMovedMonitor(showOnHover: Bool) {
        if isMonitoring && showOnHover {
            mouseMovedMonitor.start()
        } else {
            mouseMovedMonitor.stop()
            hoverTask?.cancel()
            hoverTask = nil
            hoverIntent = nil
        }
    }

    /// Stops all monitors.
    func stopAll() {
        isMonitoring = false
        cancelDelayedInteractions()
        for monitor in allMonitors {
            monitor.stop()
        }
    }
    /// 手动操作优先于悬停/智能隐藏，取消等待中的旧意图。
    func cancelDelayedInteractions() {
        clickTask?.cancel()
        smartRehideTask?.cancel()
        hoverTask?.cancel()
        clickTask = nil
        smartRehideTask = nil
        hoverTask = nil
        hoverIntent = nil
    }
}

// MARK: - Handlers

extension EventManager {

    // MARK: Handle Show On Click

    private func handleShowOnClick(with event: NSEvent) {
        guard
            let appState,
            isMonitoring,
            appState.settingsManager.generalSettingsManager.showOnClick || event.modifierFlags.contains(.option),
            isMouseInsideEmptyMenuBarSpace
        else {
            return
        }

        cancelDelayedInteractions()
        // 使用点击当时的修饰键；释放 Option 不应把同一次点击改为普通切换。
        let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        clickTask = Task {
            do { try await Task.sleep(for: .milliseconds(50)) } catch { return }
            guard isMonitoring,
                  appState.settingsManager.generalSettingsManager.showOnClick || modifiers.contains(.option)
            else { return }

            // Re-verify at fire time: the click may have hit an icon whose AX
            // state lagged at mouse-down, or opened a menu since. Never toggle
            // into an interaction.
            guard !isMenuOpenGlobally(), isMouseInsideEmptyMenuBarSpace else {
                return
            }

            if modifiers == .control {
                handleShowRightClickMenu()
            } else if
                modifiers == .option,
                appState.settingsManager.advancedSettingsManager.canToggleAlwaysHiddenSection,
                let alwaysHiddenSection = appState.menuBarManager.section(withName: .alwaysHidden),
                alwaysHiddenSection.isEnabled
            {
                alwaysHiddenSection.toggle()
            } else {
                if let hiddenSection = appState.menuBarManager.section(withName: .hidden) {
                    hiddenSection.toggle()
                }
            }
        }
    }

    // MARK: Handle Smart Rehide

    private func handleSmartRehide(with event: NSEvent) {
        guard
            let appState,
            isMonitoring,
            appState.settingsManager.generalSettingsManager.autoRehide,
            case .smart = appState.settingsManager.generalSettingsManager.rehideStrategy
        else {
            return
        }

        if let visibleSection = appState.menuBarManager.section(withName: .visible) {
            guard event.window !== visibleSection.controlItem.window else {
                return
            }
        }

        // Make sure clicking the Floe Bar doesn't trigger rehide.
        guard event.window !== appState.menuBarManager.floeBarPanel else {
            return
        }

        // Only continue if a section is currently visible.
        guard appState.menuBarManager.sections.contains(where: { !$0.isHidden }) else {
            return
        }

        // Make sure the mouse is not in the menu bar.
        guard !isMouseInsideMenuBar else {
            return
        }

        smartRehideTask?.cancel()
        let revisions = appState.menuBarManager.sections.map { $0.stateRevision }
        let initialSpaceID = Bridging.activeSpaceID
        smartRehideTask = Task {
            do { try await Task.sleep(for: .seconds(0.25)) } catch { return }
            // 延迟期间的新选择、菜单和设置优先于旧点击触发的收起。
            guard isMonitoring,
                  appState.settingsManager.generalSettingsManager.autoRehide,
                  case .smart = appState.settingsManager.generalSettingsManager.rehideStrategy,
                  revisions == appState.menuBarManager.sections.map({ $0.stateRevision }),
                  !isMouseInsideMenuBar, !isMouseInsideFloeBar,
                  !isMenuOpenGlobally()
            else { return }

            // If clicking caused a space change, don't bother with the window check.
            if Bridging.activeSpaceID != initialSpaceID {
                for section in appState.menuBarManager.sections {
                    section.hide(persistState: false)
                }
                return
            }

            // A tracked menu means the user is mid-interaction (e.g. picking
            // from a dropdown) — never collapse into it. This also spares a
            // window-list fetch while menus are open.
            guard !isMenuOpenGlobally() else {
                return
            }

            // Get the window that the user has clicked into.
            guard let mouseLocation = MouseCursor.locationCoreGraphics else {
                return
            }
            let windowsBelowCursor = WindowInfo.getOnScreenWindows(excludeDesktopWindows: false)
                .filter({ $0.layer < CGWindowLevelForKey(.cursorWindow) })

            // A dropdown/panel hanging from the menu bar: interacting with it
            // must not collapse the sections — only its closing (a click
            // elsewhere) may. Checked before the title filter because panels
            // often have no window title. Regular apps can own status items too.
            if let topmost = windowsBelowCursor.first(where: { $0.frame.contains(mouseLocation) }),
               isMenuBarDropdownWindow(topmost) {
                return
            }

            guard
                let windowUnderMouse = windowsBelowCursor
                    .first(where: { $0.frame.contains(mouseLocation) && $0.title?.isEmpty == false }),
                let owningApplication = windowUnderMouse.owningApplication
            else {
                return
            }

            // The dock is an exception to the following check.
            if owningApplication.bundleIdentifier != "com.apple.dock" {
                // Only continue if the user has clicked into an active window with
                // a regular activation policy.
                guard
                    owningApplication.isActive,
                    owningApplication.activationPolicy == .regular
                else {
                    return
                }
            }

            // If all the above checks have passed, hide all sections.
            for section in appState.menuBarManager.sections {
                section.hide(persistState: false)
            }
        }
    }

    // MARK: Handle Show Right Click Menu

    private func handleShowRightClickMenu() {
        guard
            let appState,
            appState.settingsManager.advancedSettingsManager.showContextMenuOnRightClick,
            isMouseInsideEmptyMenuBarSpace,
            let mouseLocation = MouseCursor.locationAppKit
        else {
            return
        }
        appState.menuBarManager.showRightClickMenu(at: mouseLocation)
    }

    // MARK: Handle Prevent Show On Hover

    private func handlePreventShowOnHover(with event: NSEvent) {
        guard
            let appState,
            appState.settingsManager.generalSettingsManager.showOnHover,
            !appState.settingsManager.generalSettingsManager.barPreferences.usesFloating(
                section: "hidden", legacy: appState.settingsManager.generalSettingsManager.useFloeBar
            ),
            isMouseInsideMenuBar
        else {
            return
        }

        if isMouseInsideMenuBarItem {
            switch event.type {
            case .leftMouseDown:
                if appState.menuBarManager.sections.contains(where: { !$0.isHidden }) || isMouseInsideFloeIcon {
                    // We have a left click that is inside the menu bar while at least one
                    // section is visible or the mouse is inside the Floe icon.
                    appState.preventShowOnHover()
                }
            case .rightMouseDown:
                if appState.menuBarManager.sections.contains(where: { !$0.isHidden }) {
                    // We have a right click that is inside the menu bar while at least one
                    // section is visible.
                    appState.preventShowOnHover()
                }
            default:
                break
            }
        } else if !isMouseInsideApplicationMenu {
            // We have a left or right click that is inside the menu bar, outside
            // a menu bar item, and outside the application menu, so it _must_ be
            // inside an empty menu bar space.
            appState.preventShowOnHover()
        }
    }

    // MARK: Handle Left Mouse Up

    private func handleLeftMouseUp() {
        guard let appearanceManager = appState?.appearanceManager else {
            return
        }
        appearanceManager.setIsDraggingMenuBarItem(false)
        if isUserDraggingItem, let appState {
            isUserDraggingItem = false
            Task {
                do { try await Task.sleep(for: .milliseconds(350)) } catch { return }
                await appState.itemManager.cacheItemsIfNeeded(force: true)
                appState.itemManager.recordLayoutChoice()
            }
        }
    }

    // MARK: Handle Left Mouse Dragged

    private func handleLeftMouseDragged(with event: NSEvent) {
        guard
            let appState,
            event.modifierFlags.contains(.command),
            !MenuBarItemAXMover.isDragging,
            isMouseInsideMenuBar
        else {
            return
        }

        // Notify each overlay panel that a menu bar item is being dragged.
        isUserDraggingItem = true
        cancelDelayedInteractions()
        appState.appearanceManager.setIsDraggingMenuBarItem(true)

        // Don't continue if the setting to show the sections is disabled.
        guard appState.settingsManager.advancedSettingsManager.showAllSectionsOnUserDrag else {
            return
        }

        // Show all items, including section dividers.
        for section in appState.menuBarManager.sections {
            section.setState(.showItems, persist: false)
            guard
                section.controlItem.isSectionDivider,
                !section.controlItem.isVisible
            else {
                continue
            }
            section.controlItem.isVisible = true
        }
    }

    // MARK: Handle Show On Hover

    private func handleShowOnHover() {
        guard let appState, isMonitoring,
              appState.settingsManager.generalSettingsManager.showOnHover,
              !appState.isShowOnHoverPrevented,
              let hiddenSection = appState.menuBarManager.section(withName: .hidden)
        else {
            hoverTask?.cancel()
            hoverTask = nil
            hoverIntent = nil
            return
        }
        guard Date().timeIntervalSince(lastHoverCheck) >= Self.hoverThrottleInterval else { return }
        lastHoverCheck = Date()

        let shouldShow = hiddenSection.isHidden
        let eligible = shouldShow ? isMouseInsideEmptyMenuBarSpace : (!isMouseInsideMenuBar && !isMouseInsideFloeBar)
        guard eligible else {
            hoverTask?.cancel()
            hoverTask = nil
            hoverIntent = nil
            return
        }
        // 同方向 mouseMoved 不重置倒计时，否则持续移动永远无法触发。
        guard hoverIntent != shouldShow else { return }
        hoverTask?.cancel()
        hoverIntent = shouldShow
        let revision = hiddenSection.stateRevision
        let delay = appState.settingsManager.advancedSettingsManager.showOnHoverDelay
        hoverTask = Task {
            do { try await Task.sleep(for: .seconds(max(0, delay))) } catch { return }
            guard !Task.isCancelled else { return }
            hoverTask = nil
            hoverIntent = nil
            guard isMonitoring,
                  appState.settingsManager.generalSettingsManager.showOnHover,
                  !appState.isShowOnHoverPrevented,
                  hiddenSection.stateRevision == revision,
                  hiddenSection.isHidden == shouldShow,
                  !isMenuOpenGlobally()
            else { return }
            if shouldShow {
                guard isMouseInsideEmptyMenuBarSpace else { return }
                hiddenSection.show(persistState: false)
            } else {
                guard !isMouseInsideMenuBar, !isMouseInsideFloeBar else { return }
                hiddenSection.hide(persistState: false)
            }
        }
    }

    // MARK: Handle Show On Scroll

    private func handleShowOnScroll(with event: NSEvent) {
        guard let appState else {
            return
        }

        // Make sure the "ShowOnScroll" feature is enabled.
        guard appState.settingsManager.generalSettingsManager.showOnScroll else {
            return
        }

        // ponytail: scroll momentum bursts; same coalescing as hover.
        guard Date().timeIntervalSince(lastScrollCheck) >= Self.scrollThrottleInterval else {
            return
        }
        lastScrollCheck = Date()

        // Make sure the mouse is inside the menu bar.
        guard isMouseInsideMenuBar else {
            return
        }

        // Only continue if we have a hidden section (we should).
        guard let hiddenSection = appState.menuBarManager.section(withName: .hidden) else {
            return
        }

        // 单轴滚轮不能被另一轴的零值减半；横纵方向相反也不能互相抵消。
        let delta = abs(event.scrollingDeltaY) >= abs(event.scrollingDeltaX)
            ? event.scrollingDeltaY : event.scrollingDeltaX
        guard abs(delta) > 5 else { return }
        cancelDelayedInteractions()
        if delta > 5 {
            hiddenSection.show()
        } else if delta < -5 {
            hiddenSection.hide()
        }
    }
}

// MARK: - Helpers

extension EventManager {
    /// Returns the best screen to use for event manager calculations.
    var bestScreen: NSScreen? {
        // 指针操作属于指针所在屏，不依赖前台窗口所在的 NSScreen.main。
        NSScreen.screenWithMouse ?? NSScreen.main
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of the menu bar.
    var isMouseInsideMenuBar: Bool {
        guard let screen = bestScreen, let appState,
              let mouseLocation = MouseCursor.locationCoreGraphics
        else { return false }
        let bounds = CGDisplayBounds(screen.displayID)
        // 同时检查横纵边界；副屏窗口顶部不能借用主屏菜单栏的 Y 范围。
        guard bounds.contains(mouseLocation),
              mouseLocation.y <= bounds.minY + Self.menuBarStripHeight
        else { return false }
        let displayID = screen.displayID
        let isSliding = appState.menuBarManager.isMenuBarHiddenBySystem || appState.isActiveSpaceFullscreen
        // 自动隐藏/全屏的菜单栏会滑动，不能沿用旧帧，否则隐藏后仍拦截顶部点击。
        if !isSliding, let cached = cachedMenuBarFrames[displayID],
           Date().timeIntervalSince(cached.date) < Self.menuBarFrameTTL {
            return cached.frame.contains(mouseLocation)
        }
        guard let window = WindowInfo.getMenuBarWindow(for: displayID), window.isOnScreen else {
            cachedMenuBarFrames.removeValue(forKey: displayID)
            return false
        }
        if !isSliding {
            cachedMenuBarFrames[displayID] = (window.frame, Date())
        }
        return window.frame.contains(mouseLocation)
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of the current application menu.
    var isMouseInsideApplicationMenu: Bool {
        guard
            let mouseLocation = MouseCursor.locationCoreGraphics,
            let screen = bestScreen,
            let appState,
            var applicationMenuFrame = appState.menuBarManager.getApplicationMenuFrame(for: screen.displayID)
        else {
            return false
        }
        applicationMenuFrame.size.width += applicationMenuFrame.origin.x - screen.frame.origin.x
        applicationMenuFrame.origin.x = screen.frame.origin.x
        return applicationMenuFrame.contains(mouseLocation)
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of a menu bar item.
    var isMouseInsideMenuBarItem: Bool {
        guard
            let screen = bestScreen,
            let mouseLocation = MouseCursor.locationCoreGraphics
        else {
            return false
        }
        if isMouseInsideOwnControlItem {
            return true
        }
        let menuBarItems = MenuBarItem.getMenuBarItems(on: screen.displayID, onScreenOnly: true, activeSpaceOnly: true)
        if menuBarItems.contains(where: { $0.frame.contains(mouseLocation) }) {
            return true
        }
        // On macOS 27 the window server vends no per-item windows, so the
        // lookup above is always empty and clicks on third-party icons look
        // like clicks on empty space — collapsing the sections mid-interaction
        // (e.g. just as the icon's dropdown opens). Fall back to a single AX
        // hit test, using the same trailing-cluster roles as the overlay.
        if let appState, appState.itemManager.isItemDiscoveryUnavailable {
            return isMouseInsideAXMenuBarItem(at: mouseLocation)
        }
        return false
    }

    /// AX hit test for a menu bar item at the given CoreGraphics point.
    ///
    /// `AXGroup` covers the MenuBarAgent/ControlCenter cluster;
    /// `AXMenuBarItem`/`AXButton`/`AXImage` cover third-party extras, excluding
    /// the frontmost app's own menus. An open menu over the bar (`AXMenu` /
    /// `AXMenuItem`) also counts: the user is interacting with it, so the spot
    /// is not empty space. Anything without AX permission, or any other role
    /// (bare `AXMenuBar` background, wallpaper, …), reads as empty.
    private func isMouseInsideAXMenuBarItem(at point: CGPoint) -> Bool {
        guard
            let element = try? systemWideElement.elementAtPosition(Float(point.x), Float(point.y)),
            let role: String = try? element.attribute("AXRole")
        else {
            return false
        }
        switch role {
        case "AXGroup", "AXMenu", "AXMenuItem":
            return true
        case "AXMenuBarItem", "AXButton", "AXImage":
            guard let pid: pid_t = try? element.pid() else {
                // A status-looking element we can't attribute is more likely
                // an icon than empty space, and a missed toggle beats a
                // mid-interaction collapse.
                return true
            }
            return pid != NSWorkspace.shared.frontmostApplication?.processIdentifier
        default:
            return false
        }
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of one of Floe's own section control items.
    ///
    /// On macOS 27 the window server no longer vends per-item windows, so the
    /// lookup above is always empty and every click looks like a click on empty
    /// menu bar space — including clicks on Floe's own controls, which then
    /// toggle twice (once from the control itself, once from the delayed
    /// empty-space handler) and land wherever the timing race leaves them.
    /// Floe's own control windows always exist, so check those directly. The Floe
    /// icon always counts; section dividers only count when actually drawn as
    /// chevrons (shown with dividers enabled) — an expanded hiding spacer is
    /// blank space and must stay clickable-as-empty.
    private var isMouseInsideOwnControlItem: Bool {
        guard
            let appState,
            let mouseLocation = MouseCursor.locationAppKit
        else {
            return false
        }
        return appState.menuBarManager.sections.contains { section in
            let controlItem = section.controlItem
            if controlItem.isSectionDivider {
                guard controlItem.state == .showItems, controlItem.isVisible else {
                    return false
                }
            }
            guard let window = controlItem.window else {
                return false
            }
            return window.frame.contains(mouseLocation)
        }
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of the screen's notch, if it has one.
    ///
    /// If the screen returned from ``bestScreen`` does not have a notch,
    /// this property returns `false`.
    var isMouseInsideNotch: Bool {
        guard
            let screen = bestScreen,
            let mouseLocation = MouseCursor.locationAppKit,
            let frameOfNotch = screen.frameOfNotch
        else {
            return false
        }
        return frameOfNotch.contains(mouseLocation)
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of an empty space in the menu bar.
    var isMouseInsideEmptyMenuBarSpace: Bool {
        isMouseInsideMenuBar &&
        !isMouseInsideApplicationMenu &&
        !isMouseInsideMenuBarItem &&
        !isMouseInsideNotch
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of the Floe Bar panel.
    var isMouseInsideFloeBar: Bool {
        guard
            let appState,
            let mouseLocation = MouseCursor.locationAppKit
        else {
            return false
        }
        let panel = appState.menuBarManager.floeBarPanel
        // Pad the frame to be more forgiving if the user accidentally
        // moves their mouse outside of the Floe Bar.
        guard panel.currentSection != nil else { return false }
        var paddedFrame = panel.frame.insetBy(dx: -10, dy: -10)
        // 菜单栏到浮栏之间的小间隙也属于访问通道，避免向下移动时立即收起。
        if let screen = panel.screen {
            paddedFrame.size.height = max(paddedFrame.height, screen.frame.maxY - paddedFrame.minY)
        }
        return paddedFrame.contains(mouseLocation)
    }

    /// A Boolean value that indicates whether the mouse pointer is within
    /// the bounds of the Floe icon.
    var isMouseInsideFloeIcon: Bool {
        guard
            let appState,
            let visibleSection = appState.menuBarManager.section(withName: .visible),
            let floeIconFrame = visibleSection.controlItem.windowFrame,
            let mouseLocation = MouseCursor.locationAppKit
        else {
            return false
        }
        return floeIconFrame.contains(mouseLocation)
    }

    /// Whether the user is currently interacting with an open menu, globally.
    ///
    /// Standard menus take keyboard focus while tracking, so a focused menu
    /// element (or one nested inside a menu/popover) means a dropdown is open
    /// somewhere — even below the menu bar, where geometry checks can't see
    /// it. The shared guard also checks foreground popup-layer windows when
    /// Accessibility focus is unavailable or has not followed menu tracking.
    private func isMenuOpenGlobally() -> Bool {
        MenuInteractionGuard.isInteracting
    }

    /// Whether the given window looks like a dropdown/panel hanging from the
    /// menu bar: a smallish window near the bar's bottom edge.
    ///
    /// Standard menus hang just below the bar; custom panels may start a bit
    /// lower. Anything clearly larger or lower is treated as a regular window.
    /// A false spare only keeps the sections open until the next outside
    /// click, while a false hide collapses them mid-interaction.
    private func isMenuBarDropdownWindow(_ window: WindowInfo) -> Bool {
        guard let screen = bestScreen else {
            return false
        }
        let bounds = CGDisplayBounds(screen.displayID)
        let barHeight = screen.frame.maxY - screen.visibleFrame.maxY
        let barBottom = bounds.minY + barHeight
        let frame = window.frame
        return frame.minY <= barBottom + 120 && frame.height <= 500 && frame.width <= 700
    }
}

// MARK: - Logger
private extension Logger {
    static let eventManager = Logger(category: "EventManager")
}
