//
//  ControlItem.swift
//  Floe
//

import Cocoa
import Combine

/// A status item that controls a section in the menu bar.
@MainActor
final class ControlItem {
    /// Possible identifiers for control items.
    enum Identifier: String, CaseIterable {
        case floeIcon = "SItem"
        case hidden = "HItem"
        case alwaysHidden = "AHItem"
    }

    /// Possible hiding states for control items.
    enum HidingState {
        case hideItems, showItems
    }

    /// Possible lengths for control items.
    enum Lengths {
        static let standard: CGFloat = NSStatusItem.variableLength
        static let expanded: CGFloat = 10_000
    }

    /// 新系统使用屏幕点宽度限制占位项；缺失几何时不继续发送固定 1,000 点的隐藏宽度。
    private func expandedHidingLength() -> CGFloat {
        if #available(macOS 27, *) {
            return MenuBarControlLayout.hidingLength(for: NSScreen.screens.map { screen in
                MenuBarControlLayout.Region(
                    displayWidth: screen.frame.width,
                    statusRegionWidth: screen.auxiliaryTopRightArea?.width ?? screen.frame.width
                )
            })
        }
        return Lengths.expanded
    }

    private static var usesModernMenuBar: Bool {
        if #available(macOS 27, *) { return true }
        return false
    }

    /// The control item's hiding state (`@Published`).
    @Published var state = HidingState.hideItems

    /// A Boolean value that indicates whether the control item is visible (`@Published`).
    @Published var isVisible = true

    /// The frame of the control item's window (`@Published`).
    @Published private(set) var windowFrame: CGRect?

    /// The shared app state.
    private weak var appState: AppState?

    /// The control item's underlying status item.
    private let statusItem: NSStatusItem

    /// A horizontal constraint for the control item's content view.
    private let constraint: NSLayoutConstraint?

    /// The control item's identifier.
    private let identifier: Identifier

    /// Storage for internal observers.
    private var cancellables = Set<AnyCancellable>()

    /// The menu bar section associated with the control item.
    private weak var section: MenuBarSection? {
        appState?.menuBarManager.sections.first { $0.controlItem === self }
    }

    /// The control item's window.
    var window: NSWindow? {
        statusItem.button?.window
    }

    /// The identifier of the control item's window.
    var windowID: CGWindowID? {
        guard let window else {
            return nil
        }
        // windowNumber is Int and traps on overflow with the non-failable
        // initializer on macOS 26 (see jordanbaird/Ice#580, #977).
        return CGWindowID(exactly: window.windowNumber)
    }

    /// A Boolean value that indicates whether the control item serves as
    /// a divider between sections.
    var isSectionDivider: Bool {
        identifier != .floeIcon
    }

    /// A Boolean value that indicates whether the control item is currently
    /// displayed in the menu bar.
    var isAddedToMenuBar: Bool {
        statusItem.isVisible
    }

    /// Creates a control item with the given identifier and app state.
    init(identifier: Identifier, appState: AppState) {
        let autosaveName = identifier.rawValue

        // 旧系统使用 0/1/2；27 的新顺序键让分隔符初次放在应用左侧，避免首次收起就隐藏整个菜单栏。
        // 已有位置属于用户选择，只在记录缺失时初始化。
        if StatusItemDefaults[.preferredPosition, autosaveName] == nil {
            StatusItemDefaults[.preferredPosition, autosaveName] = MenuBarControlLayout.initialPosition(
                for: autosaveName,
                modernMenuBar: Self.usesModernMenuBar
            )
        }

        self.statusItem = NSStatusBar.system.statusItem(withLength: 0)
        self.statusItem.autosaveName = autosaveName
        self.identifier = identifier
        self.appState = appState

        // This could break in a new macOS release, but we need this constraint in order to be
        // able to hide the control item when the `ShowSectionDividers` setting is disabled. A
        // previous implementation used the status item's `isVisible` property, which was more
        // robust, but would completely remove the control item. With the current set of
        // features, we need to be able to accurately retrieve the items for each section, so
        // we need the control item to always be present to act as a delimiter. The new solution
        // is to remove the constraint that prevents status items from having a length of zero,
        // then resize the content view. FIXME: Find a replacement for this.
        if #available(macOS 27, *) {
            // 新菜单栏的窗口不再属于单个状态项，不能修改共享窗口的私有布局约束。
            self.constraint = nil
        } else if
            let button = statusItem.button,
            let constraints = button.window?.contentView?.constraintsAffectingLayout(for: .horizontal),
            let constraint = constraints.first(where: Predicates.controlItemConstraint(button: button))
        {
            assert(constraints.filter(Predicates.controlItemConstraint(button: button)).count == 1)
            self.constraint = constraint
        } else {
            self.constraint = nil
        }

        configureStatusItem()
    }

    /// Removes the status item without clearing its stored position.
    deinit {
        // Removing the status item has the unwanted side effect of deleting
        // the preferredPosition. Cache and restore it.
        let autosaveName = statusItem.autosaveName as String
        let cached = StatusItemDefaults[.preferredPosition, autosaveName]
        NSStatusBar.system.removeStatusItem(statusItem)
        StatusItemDefaults[.preferredPosition, autosaveName] = cached
    }

    /// 相同长度不重复提交给 AppKit，避免状态发布造成不必要的辅助 scene 更新。
    private func applyStatusItemLength(_ length: CGFloat) {
        guard statusItem.length != length else { return }
        statusItem.length = length
    }

    /// 恢复模式先释放所有隐藏占位；macOS 27 全程只使用公开长度，不调整共享窗口大小。
    private func applyStatusItemLayout(isVisible: Bool, state: HidingState) {
        guard let section else { return }
        if isSectionDivider, appState?.menuBarManager.isPreparingInitialAXSnapshot == true {
            applyStatusItemLength(Lengths.standard)
            return
        }
        if isSectionDivider, appState?.menuBarManager.isMenuBarRecoveryActive == true {
            applyStatusItemLength(1)
            return
        }
        let length: CGFloat
        if !isVisible {
            length = 0
        } else if section.name == .visible || state == .showItems {
            length = Lengths.standard
        } else {
            length = expandedHidingLength()
        }
        if #available(macOS 27, *) {
            applyStatusItemLength(isVisible ? length : 1)
            return
        }
        applyStatusItemLength(length)
        constraint?.isActive = isVisible
        if !isVisible, let window {
            var size = window.frame.size
            size.width = 1
            window.setContentSize(size)
        }
    }

    /// Configures the internal observers for the control item.
    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        $state
            .sink { [weak self] state in
                self?.updateStatusItem(with: state)
            }
            .store(in: &c)

        Publishers.CombineLatest($isVisible, $state)
            .sink { [weak self] (isVisible, state) in
                self?.applyStatusItemLayout(isVisible: isVisible, state: state)
            }
            .store(in: &c)

        constraint?.publisher(for: \.isActive)
            .removeDuplicates()
            .sink { [weak self] isActive in
                self?.isVisible = isActive
            }
            .store(in: &c)

        statusItem.publisher(for: \.isVisible)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                guard
                    let self,
                    let appState,
                    let section
                else {
                    return
                }

                let manager = appState.settingsManager.hotkeySettingsManager

                let hotkey: Hotkey? = switch section.name {
                case .visible: nil
                case .hidden: manager.hotkey(withAction: .toggleHiddenSection)
                case .alwaysHidden: manager.hotkey(withAction: .toggleAlwaysHiddenSection)
                }

                guard let hotkey else {
                    return
                }

                if isVisible {
                    hotkey.enable()
                } else {
                    hotkey.disable()
                }
            }
            .store(in: &c)

        window?.publisher(for: \.frame)
            .sink { [weak self] frame in
                guard
                    let self,
                    let screen = window?.screen,
                    screen.frame.intersects(frame)
                else {
                    return
                }
                windowFrame = frame
            }
            .store(in: &c)

        if let appState {
            appState.settingsManager.generalSettingsManager.$showFloeIcon
                .receive(on: DispatchQueue.main)
                .sink { [weak self] showFloeIcon in
                    guard
                        let self,
                        !isSectionDivider
                    else {
                        return
                    }
                    if showFloeIcon {
                        addToMenuBar()
                    } else {
                        removeFromMenuBar()
                    }
                }
                .store(in: &c)

            appState.settingsManager.generalSettingsManager.$floeIcon
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }
                    updateStatusItem(with: state)
                }
                .store(in: &c)

            appState.settingsManager.generalSettingsManager.$customFloeIconIsTemplate
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }
                    updateStatusItem(with: state)
                }
                .store(in: &c)

            appState.settingsManager.generalSettingsManager.$reverseFloeIcon
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self else {
                        return
                    }
                    updateStatusItem(with: state)
                }
                .store(in: &c)

            Publishers.Merge3(
                appState.settingsManager.generalSettingsManager.$useFloeBar.mapToVoid(),
                appState.settingsManager.generalSettingsManager.barPreferences.$presentationRevision.mapToVoid(),
                appState.menuBarManager.presentationController.$revision.mapToVoid()
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self, weak appState] _ in
                guard let self, let appState, let button = statusItem.button else { return }
                let mouseDown = appState.menuBarManager.presentationController.activatesOnMouseDown(for: section?.name ?? .hidden)
                button.sendAction(on: mouseDown ? [.leftMouseDown, .rightMouseUp] : [.leftMouseUp, .rightMouseUp])
            }
            .store(in: &c)

            appState.settingsManager.advancedSettingsManager.$showSectionDividers
                .receive(on: DispatchQueue.main)
                .sink { [weak self] shouldShow in
                    guard
                        let self,
                        isSectionDivider,
                        state == .showItems
                    else {
                        return
                    }
                    // ponytail: the divider collapses to a 1pt sliver instead of
                    // disappearing, so it stays in the bar as the section
                    // boundary (AX lookup still finds it) without holding a slot.
                    isVisible = shouldShow
                }
                .store(in: &c)

            appState.settingsManager.advancedSettingsManager.$enableAlwaysHiddenSection
                .receive(on: DispatchQueue.main)
                .sink { [weak self] enable in
                    guard
                        let self,
                        identifier == .alwaysHidden,
                        let visibleSection = appState.menuBarManager.section(withName: .visible)
                    else {
                        return
                    }
                    if enable {
                        addToMenuBar()
                    } else {
                        removeFromMenuBar()
                    }
                    // The Floe icon mirrors this section; repaint its arrow
                    // now that the source has changed.
                    visibleSection.controlItem.updateStatusItem(with: visibleSection.controlItem.state)
                }
                .store(in: &c)
        }

        Publishers.Merge3(
            NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification),
            NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didWakeNotification),
            NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.activeSpaceDidChangeNotification)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            guard #available(macOS 27, *), let self, isSectionDivider else { return }
            applyStatusItemLayout(isVisible: isVisible, state: state)
        }
        .store(in: &c)

        cancellables = c
    }

    /// Sets the initial configuration for the status item.
    private func configureStatusItem() {
        defer {
            configureCancellables()
            updateStatusItem(with: state)
        }
        guard let button = statusItem.button else {
            return
        }
        button.target = self
        button.action = #selector(performAction)
        // AX identifier for the divider so its position can be looked up via
        // Accessibility (MenuBarItemAXDiscovery.dividerFrames): on macOS 27
        // button.window.frame returns the spacer's rect, not the chevron's
        // position, so the Floe Bar can't use it to classify sections.
        switch identifier {
        case .hidden:
            button.setAccessibilityIdentifier("FloeHiddenDivider")
            button.setAccessibilityLabel(L10n.string("Hidden"))
        case .alwaysHidden:
            button.setAccessibilityIdentifier("FloeAlwaysHiddenDivider")
            button.setAccessibilityLabel(L10n.string("Always Hidden"))
        case .floeIcon:
            button.setAccessibilityIdentifier("FloeIcon")
            button.setAccessibilityLabel("Floe")
            button.toolTip = "Floe"
        }
    }

    /// Updates the appearance of the status item using the given hiding state.
    func updateStatusItem(with state: HidingState) {
        guard
            let appState,
            let section,
            let button = statusItem.button
        else {
            return
        }

        let preparingSnapshot = appState.menuBarManager.isPreparingInitialAXSnapshot
        let displayState: HidingState = appState.menuBarManager.isMenuBarRecoveryActive || preparingSnapshot ? .showItems : state
        switch section.name {
        case .visible:
            isVisible = true
            // Enable the cell, as it may have been previously disabled.
            button.cell?.isEnabled = true
            let icon = appState.settingsManager.generalSettingsManager.floeIcon
            let reversed = appState.settingsManager.generalSettingsManager.reverseFloeIcon
            let hiddenImage = reversed ? icon.visible : icon.hidden
            let visibleImage = reversed ? icon.hidden : icon.visible
            // Closed points right like a collapsed disclosure; open points
            // left toward the revealed items, matching the section dividers.
            // 普通点击控制隐藏区，始终隐藏区保留给 Option 点击。
            let showsOpenArrow = displayState == .showItems
            // 恢复期间固定使用内置图形，也能排除透明自定义图片；原图和偏好不变。
            let selectedImage = appState.menuBarManager.isMenuBarRecoveryActive
                ? ControlItemImage.builtin(.chevronLarge).nsImage(for: appState)
                : (showsOpenArrow ? hiddenImage.nsImage(for: appState) : visibleImage.nsImage(for: appState))
            if let selectedImage, selectedImage.size.width.isFinite, selectedImage.size.height.isFinite,
               selectedImage.size.width > 0, selectedImage.size.height > 0 {
                button.image = selectedImage
            } else {
                // 损坏/空白尺寸的自定义图像不能让恢复入口继续成为零宽状态项；不覆盖用户的图像配置。
                button.image = ControlItemImage.builtin(.chevronLarge).nsImage(for: appState)
            }
            if
                case .custom = icon.name,
                let originalImage = button.image
            {
                // Custom icons need to be resized to fit inside the button.
                let originalWidth = originalImage.size.width
                let originalHeight = originalImage.size.height
                let ratio = max(originalWidth / 25, originalHeight / 17)
                let newSize = CGSize(width: originalWidth / ratio, height: originalHeight / ratio)
                button.image = originalImage.resized(to: newSize)
            }
        case .hidden, .alwaysHidden:
            switch displayState {
            case .hideItems:
                isVisible = true
                // Prevent the cell from highlighting while expanded.
                button.cell?.isEnabled = false
                // Cell still sometimes briefly flashes on expansion unless manually unhighlighted.
                button.isHighlighted = false
                button.image = nil
            case .showItems:
                let shouldShowDivider = preparingSnapshot || appState.settingsManager.advancedSettingsManager.showSectionDividers
                // ponytail: same sliver collapse as the $showSectionDividers sink
                // — a `Lengths.standard` item with no image left a ~40pt gap
                // between the revealed section and the next one.
                isVisible = shouldShowDivider
                // Enable the cell, as it may have been previously disabled.
                button.cell?.isEnabled = true
                // Set the image based on the section name and the hiding state.
                switch section.name {
                case .hidden:
                    button.image = shouldShowDivider
                        ? ControlItemImage.builtin(.chevronLarge).nsImage(for: appState)
                        : nil
                case .alwaysHidden:
                    button.image = shouldShowDivider
                        ? ControlItemImage.builtin(.chevronSmall).nsImage(for: appState)
                        : nil
                case .visible: break
                }
            }
        }
    }

    /// Performs the control item's action.
    @objc private func performAction() {
        guard let appState else { return }
        // target/action 本身代表按钮激活；MenuBarAgent 转发、键盘和 AXPress 不保证有本进程鼠标事件。
        // 按钮的 sendAction 掩码已限制鼠标边沿，不能再因 currentEvent 缺失而丢弃一次有效激活。
        let event = NSApp.currentEvent
        let modifiers = (event?.modifierFlags ?? NSEvent.modifierFlags).intersection(.deviceIndependentFlagsMask)
        if event?.type == .rightMouseUp || modifiers == .control {
            statusItem.showMenu(createMenu(with: appState))
        } else if
            modifiers == .option,
            appState.settingsManager.advancedSettingsManager.canToggleAlwaysHiddenSection,
            let alwaysHiddenSection = appState.menuBarManager.section(withName: .alwaysHidden),
            alwaysHiddenSection.isEnabled
        {
            alwaysHiddenSection.toggle()
        } else {
            section?.toggle()
        }
    }

    /// Creates a menu to show under the control item.
    private func createMenu(with appState: AppState) -> NSMenu {
        func hotkey(withAction action: HotkeyAction) -> Hotkey? {
            let hotkeySettingsManager = appState.settingsManager.hotkeySettingsManager
            return hotkeySettingsManager.hotkey(withAction: action)
        }

        let menu = NSMenu(title: "Floe")

        let settingsItem = NSMenuItem(
            title: L10n.string("Floe Settings…"),
            action: #selector(AppDelegate.openSettingsWindow),
            keyEquivalent: ","
        )
        settingsItem.keyEquivalentModifierMask = .command
        menu.addItem(settingsItem)

        let searchItem = NSMenuItem(
            title: L10n.string("Search menu bar items"),
            action: #selector(showSearchPanel),
            keyEquivalent: ""
        )
        searchItem.target = self
        menu.addItem(searchItem)

        menu.addItem(.separator())

        // Add menu items to toggle the hidden and always-hidden sections.
        let sectionNames: [MenuBarSection.Name] = [.hidden, .alwaysHidden]
        for name in sectionNames {
            guard
                let section = appState.menuBarManager.section(withName: name),
                section.controlItem.isAddedToMenuBar
            else {
                // Section doesn't exist, or is disabled.
                continue
            }
            let item = NSMenuItem(
                title: L10n.string(section.isHidden ? "Show the %@ Section" : "Hide the %@ Section", L10n.string(name.displayString)),
                action: #selector(toggleMenuBarSection),
                keyEquivalent: ""
            )
            item.target = self
            Self.sectionStorage.weakSet(section, for: item)
            switch name {
            case .visible:
                break
            case .hidden:
                if
                    let hotkey = hotkey(withAction: .toggleHiddenSection),
                    let keyCombination = hotkey.keyCombination
                {
                    item.keyEquivalent = keyCombination.key.keyEquivalent
                    item.keyEquivalentModifierMask = keyCombination.modifiers.nsEventFlags
                }
            case .alwaysHidden:
                if
                    let hotkey = hotkey(withAction: .toggleAlwaysHiddenSection),
                    let keyCombination = hotkey.keyCombination
                {
                    item.keyEquivalent = keyCombination.key.keyEquivalent
                    item.keyEquivalentModifierMask = keyCombination.modifiers.nsEventFlags
                }
            }
            menu.addItem(item)
        }

        menu.addItem(.separator())

        let checkForUpdatesItem = NSMenuItem(
            title: L10n.string("Check for Updates…"),
            action: #selector(checkForUpdates),
            keyEquivalent: ""
        )
        checkForUpdatesItem.target = self
        menu.addItem(checkForUpdatesItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: L10n.string("Quit Floe"),
            action: #selector(NSApp.terminate),
            keyEquivalent: "q"
        )
        quitItem.keyEquivalentModifierMask = .command
        menu.addItem(quitItem)

        return menu
    }

    @objc private func showSearchPanel() {
        appState?.menuBarManager.showSearchPanel()
    }

    /// Toggles the menu bar section associated with the given menu item.
    @objc private func toggleMenuBarSection(for menuItem: NSMenuItem) {
        Self.sectionStorage.value(for: menuItem)?.toggle()
    }

    /// Opens the settings window and checks for app updates.
    @objc private func checkForUpdates() {
        guard let appState else {
            return
        }
        appState.updatesManager.checkForUpdates()
    }

    /// Adds the control item to the menu bar.
    func addToMenuBar() {
        guard !isAddedToMenuBar else {
            return
        }
        statusItem.isVisible = true
    }

    /// 显式恢复入口也重置屏外位置；不修改其他应用和两个分隔符的位置。
    func restoreToMenuBar() {
        guard !isSectionDivider else { return }
        statusItem.isVisible = false
        StatusItemDefaults[.preferredPosition, statusItem.autosaveName as String] = MenuBarControlLayout.initialPosition(
            for: statusItem.autosaveName as String,
            modernMenuBar: Self.usesModernMenuBar
        )
        updateStatusItem(with: state)
        applyStatusItemLayout(isVisible: true, state: state)
        statusItem.isVisible = true
    }

    /// Removes the control item from the menu bar.
    func removeFromMenuBar() {
        guard isAddedToMenuBar else {
            return
        }
        // Setting `statusItem.isVisible` to `false` has the unwanted side
        // effect of deleting the preferredPosition. Cache and restore it.
        let autosaveName = statusItem.autosaveName as String
        let cached = StatusItemDefaults[.preferredPosition, autosaveName]
        statusItem.isVisible = false
        StatusItemDefaults[.preferredPosition, autosaveName] = cached
    }
}

private extension ControlItem {
    /// Storage for menu items that toggle a menu bar section.
    ///
    /// When one of these menu items is created, its section is stored here.
    /// When its action is invoked, the section is retrieved from storage.
    static let sectionStorage = ObjectStorage<MenuBarSection>()
}

// MARK: - Logger
private extension Logger {
    /// The logger to use for control items.
    static let controlItem = Logger(category: "ControlItem")
}
