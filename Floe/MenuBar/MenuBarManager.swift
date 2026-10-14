//
//  MenuBarManager.swift
//  Floe
//

import AXSwift
import Combine
import SwiftUI

/// Manager for the state of the menu bar.
@MainActor
final class MenuBarManager: ObservableObject {
    /// Information for the menu bar's average color.
    @Published private(set) var averageColorInfo: MenuBarAverageColorInfo?

    /// 异步采样期间跳过重复触发，主线程只发布最终颜色。
    private var isSamplingAverageColor = false

    /// 自动隐藏应用菜单前的宿主；恢复时回到原应用，避免切到无关进程。
    private var applicationBeforeHidingMenus: NSRunningApplication?

    /// A Boolean value that indicates whether the menu bar is either always hidden
    /// by the system, or automatically hidden and shown by the system based on the
    /// location of the mouse.
    @Published private(set) var isMenuBarHiddenBySystem = false

    /// A Boolean value that indicates whether the menu bar is hidden by the system
    /// according to a value stored in UserDefaults.
    @Published private(set) var isMenuBarHiddenBySystemUserDefaults = false

    /// The shared app state.
    private weak var appState: AppState?

    /// Storage for internal observers.
    private var cancellables = Set<AnyCancellable>()

    /// A Boolean value that indicates whether the application menus are hidden.
    private var isHidingApplicationMenus = false

    /// The managed sections in the menu bar.
    private(set) var sections = [MenuBarSection]()

    /// The panel that contains the Floe Bar interface.
    let floeBarPanel: FloeBarPanel

    /// A Boolean value that indicates whether the manager can update its stored
    /// information for the menu bar's average color.
    private var canUpdateAverageColorInfo: Bool {
        appState?.settingsWindow?.isVisible == true
    }

    /// Initializes a new menu bar manager instance.
    init(appState: AppState) {
        self.floeBarPanel = FloeBarPanel(appState: appState)
        self.appState = appState
    }

    private var searchPanel: MenuBarSearchPanel?

    /// 菜单与快捷键共用独立搜索面板。
    func showSearchPanel() {
        guard let appState else { return }
        if searchPanel == nil { searchPanel = MenuBarSearchPanel(appState: appState) }
        searchPanel?.show()
    }

    /// Performs the initial setup of the menu bar manager.
    func performSetup() {
        initializeSections()
        configureCancellables()
        floeBarPanel.performSetup()
    }

    /// Performs the initial setup of the menu bar manager's sections.
    private func initializeSections() {
        // Make sure initialization can only happen once.
        guard sections.isEmpty else {
            Logger.menuBarManager.warning("Sections already initialized")
            return
        }

        guard let appState else {
            Logger.menuBarManager.error("Error initializing menu bar sections: Missing app state")
            return
        }

        sections = [
            MenuBarSection(name: .visible, appState: appState),
            MenuBarSection(name: .hidden, appState: appState),
            MenuBarSection(name: .alwaysHidden, appState: appState),
        ]
    }

    /// Configures the internal observers for the manager.
    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        NSApp.publisher(for: \.currentSystemPresentationOptions)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] options in
                guard let self else {
                    return
                }
                let hidden = options.contains(.hideMenuBar) || options.contains(.autoHideMenuBar)
                isMenuBarHiddenBySystem = hidden
            }
            .store(in: &c)

        if
            let hiddenSection = section(withName: .hidden),
            let window = hiddenSection.controlItem.window
        {
            window.publisher(for: \.frame)
                .map { $0.origin.y }
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard
                        let self,
                        let isMenuBarHidden = Defaults.globalDomain["_HIHideMenuBar"] as? Bool
                    else {
                        return
                    }
                    isMenuBarHiddenBySystemUserDefaults = isMenuBarHidden
                }
                .store(in: &c)
        }

        // Handle the `focusedApp` rehide strategy.
        NSWorkspace.shared.publisher(for: \.frontmostApplication)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if
                    let self,
                    let appState,
                    appState.settingsManager.generalSettingsManager.autoRehide,
                    case .focusedApp = appState.settingsManager.generalSettingsManager.rehideStrategy,
                    let hiddenSection = section(withName: .hidden),
                    !appState.eventManager.isMouseInsideMenuBar
                {
                    let revision = hiddenSection.stateRevision
                    Task {
                        do { try await Task.sleep(for: .seconds(0.1)) } catch { return }
                        guard appState.settingsManager.generalSettingsManager.autoRehide,
                              case .focusedApp = appState.settingsManager.generalSettingsManager.rehideStrategy,
                              hiddenSection.stateRevision == revision,
                              !appState.eventManager.isMouseInsideMenuBar,
                              !appState.eventManager.isMouseInsideFloeBar
                        else { return }
                        hiddenSection.hide(persistState: false)
                    }
                }
            }
            .store(in: &c)

        appState?.settingsWindow?.publisher(for: \.isVisible)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.updateAverageColorInfo() }
            }
            .store(in: &c)

        Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                Task { await self?.updateAverageColorInfo() }
            }
            .store(in: &c)

        appState?.settingsManager.advancedSettingsManager.$hideApplicationMenus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                if !enabled { self?.showApplicationMenus() }
            }
            .store(in: &c)

        // Hide application menus when a section is shown (if applicable).
        Publishers.MergeMany(sections.map { $0.controlItem.$state.mapToVoid() })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    let self,
                    let appState
                else {
                    return
                }

                // Don't continue if:
                //   * The "HideApplicationMenus" setting isn't enabled.
                //   * The menu bar is hidden by the system.
                //   * The active space is fullscreen.
                //   * The settings window is visible.
                guard
                    appState.settingsManager.advancedSettingsManager.hideApplicationMenus,
                    !isMenuBarHiddenBySystem,
                    !appState.isActiveSpaceFullscreen,
                    appState.settingsWindow?.isVisible == false
                else {
                    return
                }

                if sections.contains(where: { $0.isEnabled && $0.controlItem.state == .showItems }) {
                    guard let screen = NSScreen.main else {
                        return
                    }

                    let displayID = screen.displayID

                    // Get the application menu frame for the display.
                    guard let applicationMenuFrame = getApplicationMenuFrame(for: displayID) else {
                        return
                    }

                    // Get all items.
                    var items = MenuBarItem.getMenuBarItems(on: displayID, onScreenOnly: false, activeSpaceOnly: true)

                    // Filter the items down according to the currently enabled/shown sections.
                    if
                        let alwaysHiddenSection = section(withName: .alwaysHidden),
                        alwaysHiddenSection.isEnabled
                    {
                        if alwaysHiddenSection.controlItem.state == .hideItems {
                            if let alwaysHiddenControlItem = items.firstIndex(matching: .alwaysHiddenControlItem).map({ items.remove(at: $0) }) {
                                items.trimPrefix { $0.frame.maxX <= alwaysHiddenControlItem.frame.minX }
                            }
                        }
                    } else if section(withName: .hidden)?.controlItem.state == .hideItems {
                        if let hiddenControlItem = items.firstIndex(matching: .hiddenControlItem).map({ items.remove(at: $0) }) {
                            items.trimPrefix { $0.frame.maxX <= hiddenControlItem.frame.minX }
                        }
                    }

                    // Get the leftmost item on the screen.
                    guard let leftmostItem = items.min(by: { $0.frame.minX < $1.frame.minX }) else {
                        return
                    }

                    // If the minX of the item is less than or equal to the maxX of the
                    // application menu frame, activate the app to hide the menu.
                    if leftmostItem.frame.minX <= applicationMenuFrame.maxX {
                        hideApplicationMenus()
                    }
                } else if isHidingApplicationMenus {
                    showApplicationMenus()
                }
            }
            .store(in: &c)

        cancellables = c
    }

    /// Updates the ``averageColorInfo`` property with the current average color
    /// of the menu bar.
    func updateAverageColorInfo() async {
        guard
            !isSamplingAverageColor,
            canUpdateAverageColorInfo,
            let screen = appState?.settingsWindow?.screen
        else {
            return
        }
        isSamplingAverageColor = true
        defer { isSamplingAverageColor = false }

        let image: CGImage?
        let source: MenuBarAverageColorInfo.Source

        let windows = WindowInfo.getOnScreenWindows(excludeDesktopWindows: false)
        let displayID = screen.displayID

        if let window = WindowInfo.getMenuBarWindow(from: windows, for: displayID) {
            var bounds = window.frame
            bounds.size.height = 1
            bounds.origin.x = bounds.maxX - (bounds.width / 4)
            bounds.size.width /= 4

            image = await ScreenCapture.captureWindow(window.windowID, screenBounds: bounds, option: .nominalResolution)
            source = .menuBarWindow
        } else if let window = WindowInfo.getWallpaperWindow(from: windows, for: displayID) {
            var bounds = window.frame
            bounds.size.height = 1
            bounds.origin.x = bounds.midX
            bounds.size.width /= 2

            image = await ScreenCapture.captureWindow(window.windowID, screenBounds: bounds, option: .nominalResolution)
            source = .desktopWallpaper
        } else {
            return
        }

        guard
            canUpdateAverageColorInfo,
            appState?.settingsWindow?.screen == screen,
            let image,
            let color = image.averageColor(makeOpaque: true)
        else {
            return
        }

        let info = MenuBarAverageColorInfo(color: color, source: source)

        if averageColorInfo != info {
            averageColorInfo = info
        }
    }

    /// Returns the Accessibility menu bar element for the given display.
    ///
    /// On macOS 27 the exact top-left point can hit the WindowManager glass
    /// container instead of the menu bar, so probe a few points inside the bar.
    private func menuBarElement(for displayID: CGDirectDisplayID) -> UIElement? {
        let displayBounds = CGDisplayBounds(displayID)
        let candidates: [CGPoint] = [
            CGPoint(x: displayBounds.origin.x + 2, y: displayBounds.origin.y + 2),
            CGPoint(x: displayBounds.origin.x + 5, y: displayBounds.origin.y + 5),
            CGPoint(x: displayBounds.origin.x + 1, y: displayBounds.origin.y + 1),
            CGPoint(x: displayBounds.origin.x, y: displayBounds.origin.y),
        ]
        for point in candidates {
            if
                let element = try? systemWideElement.elementAtPosition(Float(point.x), Float(point.y)),
                let role = try? element.role(),
                role == .menuBar
            {
                return element
            }
        }
        return nil
    }

    /// Returns a Boolean value that indicates whether the given display
    /// has a valid menu bar.
    func hasValidMenuBar(in windows: [WindowInfo], for display: CGDirectDisplayID) -> Bool {
        guard WindowInfo.getMenuBarWindow(from: windows, for: display) != nil else {
            return false
        }
        return menuBarElement(for: display) != nil
    }

    /// Returns the frame of the application menu for the given display.
    func getApplicationMenuFrame(for displayID: CGDirectDisplayID) -> CGRect? {
        guard
            let menuBar = menuBarElement(for: displayID),
            let items: [UIElement] = try? menuBar.arrayAttribute(.children)?.filter({ (try? $0.attribute(.enabled)) == true })
        else {
            return nil
        }

        let itemFrames = items.lazy.compactMap { try? $0.attribute(.frame) as CGRect? }
        let applicationMenuFrame = itemFrames.reduce(.null, CGRectUnion)

        if applicationMenuFrame.width <= 0 {
            return nil
        }

        // The Accessibility API returns the menu bar for the active screen, regardless of the
        // display origin used. This workaround prevents an incorrect frame from being returned
        // for inactive displays in multi-display setups where one display has a notch.
        if
            let mainScreen = NSScreen.main,
            let thisScreen = NSScreen.screens.first(where: { $0.displayID == displayID }),
            thisScreen != mainScreen,
            let notchedScreen = NSScreen.screens.first(where: { $0.hasNotch }),
            let leftArea = notchedScreen.auxiliaryTopLeftArea,
            applicationMenuFrame.width >= leftArea.maxX
        {
            return nil
        }

        return applicationMenuFrame
    }

    /// Shows the right-click menu.
    func showRightClickMenu(at point: CGPoint) {
        let menu = NSMenu(title: "Floe")

        let editItem = NSMenuItem(
            title: L10n.string("Edit Menu Bar Appearance…"),
            action: #selector(showAppearanceEditorPopover),
            keyEquivalent: ""
        )
        editItem.target = self
        menu.addItem(editItem)

        menu.addItem(.separator())

        let settingsItem = NSMenuItem(
            title: L10n.string("Floe Settings…"),
            action: #selector(AppDelegate.openSettingsWindow),
            keyEquivalent: ","
        )
        menu.addItem(settingsItem)

        menu.popUp(positioning: nil, at: point, in: nil)
    }

    /// Hides the application menus.
    func hideApplicationMenus() {
        guard !isHidingApplicationMenus, !MenuInteractionGuard.isInteracting else { return }
        guard let appState else {
            Logger.menuBarManager.error("Error hiding application menus: Missing app state")
            return
        }
        Logger.menuBarManager.info("Hiding application menus")
        applicationBeforeHidingMenus = NSWorkspace.shared.frontmostApplication
        // 自动腾出菜单栏不使用首次激活的 Dock 绕行，避免中断宿主菜单跟踪。
        appState.activate(withPolicy: .regular, usingDock: false)
        isHidingApplicationMenus = true
    }

    /// Shows the application menus.
    func showApplicationMenus() {
        guard isHidingApplicationMenus else { return }
        guard let appState else {
            Logger.menuBarManager.error("Error showing application menus: Missing app state")
            return
        }
        Logger.menuBarManager.info("Showing application menus")
        appState.deactivate(withPolicy: .accessory, yieldingTo: applicationBeforeHidingMenus)
        applicationBeforeHidingMenus = nil
        isHidingApplicationMenus = false
    }

    /// Toggles the visibility of the application menus.
    func toggleApplicationMenus() {
        if isHidingApplicationMenus {
            showApplicationMenus()
        } else {
            hideApplicationMenus()
        }
    }

    /// Shows the appearance editor popover, centered under the menu bar.
    @objc private func showAppearanceEditorPopover() {
        guard let appState else {
            Logger.menuBarManager.error("Error showing appearance editor popover: Missing app state")
            return
        }
        let panel = MenuBarAppearanceEditorPanel(appState: appState)
        panel.orderFrontRegardless()
        panel.showAppearanceEditorPopover()
    }

    /// Returns the menu bar section with the given name.
    func section(withName name: MenuBarSection.Name) -> MenuBarSection? {
        sections.first { $0.name == name }
    }
}

// MARK: MenuBarManager: BindingExposable
extension MenuBarManager: BindingExposable { }

// MARK: - MenuBarAverageColorInfo

/// Information for the menu bar's average color.
struct MenuBarAverageColorInfo: Hashable {
    enum Source: Hashable {
        case menuBarWindow
        case desktopWallpaper
    }

    var color: CGColor
    var source: Source
}

// MARK: - Logger
private extension Logger {
    /// Logger to use for the menu bar manager.
    static let menuBarManager = Logger(category: "MenuBarManager")
}
