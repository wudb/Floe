//
//  MenuBarPresentationController.swift
//  Floe
//

import Cocoa
import Combine

/// 将系统快照与用户覆盖合并为唯一呈现结果，点击、悬停和分区展开共用此入口。
@MainActor
final class MenuBarPresentationController: ObservableObject {
    @Published private(set) var revision = 0
    private weak var appState: AppState?
    private var cancellables = Set<AnyCancellable>()
    private var fullscreenStates = [String: Bool]()
    private var fullscreenSampleDate = Date.distantPast
    private var contexts = [String: AdaptivePresentationPolicy.Context]()
    private var decisions = [String: AdaptivePresentationPolicy.Decision]()

    init(appState: AppState) { self.appState = appState }

    private func key(_ name: MenuBarSection.Name) -> String { name == .alwaysHidden ? "alwaysHidden" : "hidden" }
    private func cacheKey(_ name: MenuBarSection.Name, _ screen: NSScreen) -> String { "\(screen.displayID).\(key(name))" }

    func decision(for name: MenuBarSection.Name, on screen: NSScreen? = nil) -> AdaptivePresentationPolicy.Decision {
        guard let appState else { return .native }
        let settings = appState.settingsManager.generalSettingsManager
        switch settings.barPreferences.presentation(for: key(name)) {
        case .native: return .native
        case .floating: return .floating
        case .inherited: return settings.useFloeBar ? .floating : .native
        case .automatic: break
        }
        guard let screen = screen ?? appState.eventManager.bestScreen else { return .floating }
        guard NSScreen.screens.contains(where: { $0.displayID == screen.displayID }) else { return .floating }
        let identifier = cacheKey(name, screen)
        if contexts[identifier] == nil { sampleContexts() }
        guard let context = contexts[identifier] else { return .floating }
        let preferences = settings.adaptivePresentation
        return AdaptivePresentationPolicy.resolve(
            context, rules: preferences.rules, override: preferences.override(for: screen.persistentDisplayKey), previous: decisions[identifier]
        )
    }

    func usesFloating(for name: MenuBarSection.Name, on screen: NSScreen? = nil) -> Bool {
        decision(for: name, on: screen) == .floating
    }

    /// 浮栏渲染和 AX 过滤也使用目标屏幕状态；未知时不能丢弃可能被隐藏的图标。
    func fullscreenState(on screen: NSScreen) -> Bool? {
        if Date().timeIntervalSince(fullscreenSampleDate) >= 1 {
            fullscreenStates = Bridging.fullscreenDisplayStates()
            fullscreenSampleDate = Date()
        }
        return fullscreenStates[screen.persistentDisplayKey]
    }

    /// 自适应分区统一在抬起时处理，避免指针刚换屏时旧的按下事件掩码触发错误行为。
    func activatesOnMouseDown(for name: MenuBarSection.Name) -> Bool {
        guard let settings = appState?.settingsManager.generalSettingsManager,
              settings.barPreferences.presentation(for: key(name)) != .automatic else { return false }
        return usesFloating(for: name)
    }

    func performSetup() {
        guard let appState else { return }
        let settings = appState.settingsManager.generalSettingsManager
        Publishers.Merge3(
            settings.barPreferences.$presentationRevision.mapToVoid(),
            settings.adaptivePresentation.$revision.mapToVoid(),
            settings.$useFloeBar.mapToVoid()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in self?.refresh() }
        .store(in: &cancellables)

        Publishers.Merge3(
            NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.activeSpaceDidChangeNotification).mapToVoid(),
            NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification).mapToVoid(),
            NSWorkspace.shared.publisher(for: \.frontmostApplication).mapToVoid()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.fullscreenSampleDate = .distantPast
            self?.refresh()
        }
        .store(in: &cancellables)

        // 容量按一秒周期刷新，环境变更立即重算；事件热路径只查快照。
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
        refresh()
    }

    private func refresh() {
        guard let appState else { return }
        let preferences = appState.settingsManager.generalSettingsManager.barPreferences
        guard ["hidden", "alwaysHidden"].contains(where: { preferences.presentation(for: $0) == .automatic }) else {
            contexts.removeAll()
            if !decisions.isEmpty { decisions.removeAll(); revision += 1 }
            return
        }
        // 菜单、拖拽、临时显示期间延后协调；保留旧决策，下一次刷新仍能检测变化。
        guard !appState.itemManager.isEditingLayout, !appState.itemManager.isMovingItem,
              !appState.itemManager.hasTemporarilyShownItems, !MenuInteractionGuard.isInteracting,
              !appState.menuBarManager.floeBarPanel.isActivatingAXItem else { return }
        let old = decisions
        sampleContexts()
        var next = [String: AdaptivePresentationPolicy.Decision]()
        for screen in NSScreen.screens {
            for name in [MenuBarSection.Name.hidden, .alwaysHidden] {
                next[cacheKey(name, screen)] = decision(for: name, on: screen)
            }
        }
        let panel = appState.menuBarManager.floeBarPanel
        let targetScreen = panel.currentSection != nil ? panel.screen : appState.eventManager.bestScreen
        if let screen = targetScreen {
            for name in [MenuBarSection.Name.hidden, .alwaysHidden] {
                let identifier = cacheKey(name, screen)
                if let previous = old[identifier], let current = next[identifier], previous != current {
                    // 规则变化只收起过时呈现，下一次用户触发才展开；不覆盖持久显隐偏好。
                    appState.menuBarManager.section(withName: name)?.hide(persistState: false)
                }
            }
        }
        decisions = next
        if old != next { revision += 1 }
    }

    private func sampleContexts() {
        guard let appState else { return }
        let settings = appState.settingsManager.generalSettingsManager
        // 未选自适应时不增加 AX 和 Space 扫描成本。
        guard ["hidden", "alwaysHidden"].contains(where: { settings.barPreferences.presentation(for: $0) == .automatic }) else {
            contexts.removeAll()
            return
        }
        fullscreenStates = Bridging.fullscreenDisplayStates()
        fullscreenSampleDate = Date()
        let screens = NSScreen.screens
        var result = [String: AdaptivePresentationPolicy.Context]()
        let deadline = Date().addingTimeInterval(0.15)
        for screen in screens {
            let menu = appState.menuBarManager.getApplicationMenuFrame(for: screen.displayID, deadline: deadline)
            let available = AdaptivePresentationPolicy.availableWidth(bounds: CGDisplayBounds(screen.displayID), rightSafeArea: screen.auxiliaryTopRightArea, applicationMenu: menu)
            for name in [MenuBarSection.Name.hidden, .alwaysHidden] {
                // 原生始终隐藏层会连同普通隐藏层展开，必须计算整段需要的总宽度。
                let names: [MenuBarSection.Name] = name == .alwaysHidden ? [.visible, .hidden, .alwaysHidden] : [.visible, .hidden]
                let items = names.flatMap { appState.itemManager.itemCache[$0] }
                    .filter { $0.info != .hiddenControlItem && $0.info != .alwaysHiddenControlItem }
                let widths = items.map { $0.frame.width }
                let valid = !appState.itemManager.isItemDiscoveryUnavailable && !items.isEmpty && widths.allSatisfy { $0.isFinite && $0 > 0 }
                result[cacheKey(name, screen)] = AdaptivePresentationPolicy.Context(
                    builtIn: CGDisplayIsBuiltin(screen.displayID) != 0,
                    notched: screen.hasNotch,
                    displayCount: screens.count,
                    fullscreen: fullscreenStates[screen.persistentDisplayKey],
                    autoHiddenMenuBar: appState.menuBarManager.isMenuBarHiddenBySystemUserDefaults,
                    availableWidth: available,
                    requiredWidth: valid ? Double(widths.reduce(0, +)) : nil
                )
            }
        }
        contexts = result
    }
}
