//
//  MenuBarItemImageCache.swift
//  Floe
//

import Cocoa
import Combine

/// Cache for menu bar item images.
@MainActor
final class MenuBarItemImageCache: ObservableObject {
    /// The cached item images.
    @Published private(set) var images = [CGWindowID: CGImage]()

    /// The screen of the cached item images.
    private(set) var screen: NSScreen?

    /// The height of the menu bar of the cached item images.
    private(set) var menuBarHeight: CGFloat?

    /// The shared app state.
    private weak var appState: AppState?

    /// Storage for internal observers.
    private var cancellables = Set<AnyCancellable>()

    /// 多个 UI/定时器触发共用一次更新，避免重复截图及较旧结果覆盖新缓存。
    private var isUpdating = false
    /// Space/显示器改变淘汰旧截图；忙碌时合并一次新环境刷新。
    private var captureGeneration = 0
    private var needsRefresh = false

    /// Creates a cache with the given app state.
    init(appState: AppState) {
        self.appState = appState
    }

    /// Sets up the cache.
    @MainActor
    func performSetup() {
        configureCancellables()
    }

    /// Configures the internal observers for the cache.
    @MainActor
    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        if let appState {
            Publishers.Merge3(
                // Update every 5 seconds at minimum (was 3s: each tick did a
                // full menu-bar CG walk even when the Floe Bar was hidden).
                Timer.publish(every: 5, on: .main, in: .default).autoconnect().mapToVoid(),

                // Update when the active space or screen parameters change.
                Publishers.Merge(
                    NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.activeSpaceDidChangeNotification),
                    NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
                )
                .mapToVoid(),

                // Update when the average menu bar color or cached items change.
                Publishers.Merge(
                    appState.menuBarManager.$averageColorInfo.removeDuplicates().mapToVoid(),
                    appState.itemManager.$itemCache.removeDuplicates().mapToVoid()
                )
            )
            .throttle(for: 0.5, scheduler: DispatchQueue.main, latest: false)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                discardRemovedImages()
                // ponytail: updateCache() gates on Floe Bar/settings visibility
                // first; only then does it pay for the ScreenCapture permission scan.
                Task.detached {
                    await self.updateCache()
                }
            }
            .store(in: &c)
        }

        Publishers.Merge(
            NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.activeSpaceDidChangeNotification),
            NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _ in
            self?.invalidate()
            Task { await self?.updateCache() }
        }
        .store(in: &c)

        cancellables = c
    }

    /// 立即撤下旧环境图片；尚未返回的捕获只能完成资源清理，不能发布。
    func invalidate() {
        captureGeneration += 1
        images.removeAll()
        screen = nil
        menuBarHeight = nil
        needsRefresh = isUpdating
    }

    /// Logs a reason for skipping the cache.
    private func logSkippingCache(reason: String) {
        Logger.imageCache.debug("Skipping menu bar item image cache as \(reason)")
    }

    /// 无需重新截图也能释放已退出应用的图片，隐藏浮栏时同样执行。
    private func discardRemovedImages() {
        let liveInfos = Set(appState?.itemManager.itemCache.allItems.map(\.windowID) ?? [])
        let retainedImages = images.filter { liveInfos.contains($0.key) }
        if retainedImages.count != images.count { images = retainedImages }
    }

    /// Returns a Boolean value that indicates whether caching menu bar items failed for
    /// the given section.
    @MainActor
    func cacheFailed(for section: MenuBarSection.Name) -> Bool {
        guard ScreenCapture.cachedCheckPermissions() else {
            return true
        }
        let items = appState?.itemManager.itemCache[section] ?? []
        guard !items.isEmpty else {
            return false
        }
        let keys = Set(images.keys)
        for item in items where keys.contains(item.windowID) {
            return false
        }
        return true
    }

    /// Captures the images of the current menu bar items and returns a dictionary containing
    /// the images, keyed by the current menu bar window identifiers.
    func createImages(for section: MenuBarSection.Name, screen: NSScreen) async -> [CGWindowID: CGImage] {
        guard !Task.isCancelled, let appState else {
            return [:]
        }

        let generation = captureGeneration
        let items = appState.itemManager.itemCache[section]

        var images = [CGWindowID: CGImage]()
        let backingScaleFactor = screen.backingScaleFactor
        let displayBounds = CGDisplayBounds(screen.displayID)
        let option: CGWindowImageOption = [.boundsIgnoreFraming, .bestResolution]

        var itemFrames = [CGWindowID: CGRect]()
        var windowIDs = [CGWindowID]()
        var frame = CGRect.null

        for item in items {
            let windowID = item.windowID
            guard
                // Use the most up-to-date window frame.
                let itemFrame = Bridging.getWindowFrame(for: windowID),
                itemFrame.minY == displayBounds.minY
            else {
                continue
            }
            itemFrames[windowID] = itemFrame
            windowIDs.append(windowID)
            frame = frame.union(itemFrame)
        }

        if
            let compositeImage = await ScreenCapture.captureWindows(windowIDs, option: option),
            CGFloat(compositeImage.width) == frame.width * backingScaleFactor
        {
            guard !Task.isCancelled, generation == captureGeneration else { return [:] }
            for windowID in windowIDs {
                guard !Task.isCancelled, generation == captureGeneration else { return [:] }
                guard
                    let itemFrame = itemFrames[windowID]
                else {
                    continue
                }

                let frame = CGRect(
                    x: (itemFrame.origin.x - frame.origin.x) * backingScaleFactor,
                    y: (itemFrame.origin.y - frame.origin.y) * backingScaleFactor,
                    width: itemFrame.width * backingScaleFactor,
                    height: itemFrame.height * backingScaleFactor
                )

                guard let itemImage = compositeImage.cropping(to: frame) else {
                    continue
                }

                images[windowID] = itemImage
            }
        } else {
            // 取消导致的 nil 不能触发逐项截图，否则关闭窗口后仍持续请求 WindowServer。
            guard !Task.isCancelled, generation == captureGeneration else { return [:] }
            Logger.imageCache.warning("Composite image capture failed. Attempting to capturing items individually.")

            for windowID in windowIDs {
                guard !Task.isCancelled, generation == captureGeneration else { return [:] }
                guard
                    let itemFrame = itemFrames[windowID]
                else {
                    continue
                }

                guard let itemImage = await ScreenCapture.captureWindow(windowID, option: option),
                      !Task.isCancelled, generation == captureGeneration, itemFrame.width > 0
                else { continue }
                // bestResolution 的像素倍率可能来自另一个显示器，按返回图片推导实际倍率。
                let actualScale = CGFloat(itemImage.width) / itemFrame.width
                let pixelHeight = min(CGFloat(itemImage.height), NSStatusBar.system.thickness * actualScale)
                guard actualScale.isFinite, actualScale > 0, pixelHeight > 0 else { continue }
                let cropFrame = CGRect(
                    x: 0,
                    y: (CGFloat(itemImage.height) - pixelHeight) / 2,
                    width: CGFloat(itemImage.width),
                    height: pixelHeight
                )
                guard let croppedImage = itemImage.cropping(to: cropFrame) else { continue }

                images[windowID] = croppedImage
            }
        }

        return Task.isCancelled || generation != captureGeneration ? [:] : images
    }

    /// Updates the cache for the given sections, without checking whether caching is necessary.
    func updateCacheWithoutChecks(sections: [MenuBarSection.Name]) async {
        guard !Task.isCancelled else { return }
        guard !isUpdating else {
            needsRefresh = true
            return
        }
        guard
            let appState,
            let screen = NSScreen.main
        else {
            return
        }
        isUpdating = true
        let generation = captureGeneration
        defer {
            isUpdating = false
            if needsRefresh {
                needsRefresh = false
                Task { await updateCache() }
            }
        }

        var newImages = [CGWindowID: CGImage]()

        for section in sections {
            guard !Task.isCancelled else { return }
            guard !appState.itemManager.itemCache[section].isEmpty else {
                continue
            }
            let sectionImages = await createImages(for: section, screen: screen)
            guard !sectionImages.isEmpty else {
                Logger.imageCache.warning("Update image cache failed for \(section.logString)")
                continue
            }
            newImages.merge(sectionImages) { (_, new) in new }
        }

        // 取消后丢弃局部结果，避免已关闭的 UI 请求重新持有图片。
        guard !Task.isCancelled, generation == captureGeneration, NSScreen.main == screen else { return }
        // 状态项重建后身份会改变；移除已消失的项，避免图片缓存随运行时间不断增长。
        let liveInfos = Set(appState.itemManager.itemCache.allItems.map(\.windowID))
        images = screen == self.screen ? images.filter { liveInfos.contains($0.key) } : [:]
        images.merge(newImages.filter { liveInfos.contains($0.key) }) { (_, new) in new }
        self.screen = screen
        self.menuBarHeight = screen.getMenuBarHeight()
    }

    /// Updates the cache for the given sections, if necessary.
    func updateCache(sections: [MenuBarSection.Name]) async {
        guard let appState else {
            return
        }

        let isFloeBarPresented = appState.navigationState.isFloeBarPresented

        if !isFloeBarPresented {
            guard appState.navigationState.isAppFrontmost else {
                logSkippingCache(reason: "Floe Bar not visible, app not frontmost")
                return
            }
            guard appState.navigationState.isSettingsPresented else {
                logSkippingCache(reason: "Floe Bar not visible, Settings not visible")
                return
            }
            guard case .menuBarLayout = appState.navigationState.settingsNavigationIdentifier else {
                logSkippingCache(reason: "Floe Bar not visible, Settings visible but not on Menu Bar Layout")
                return
            }
        }

        guard !appState.itemManager.isMovingItem else {
            logSkippingCache(reason: "an item is currently being moved")
            return
        }

        guard !appState.itemManager.itemHasRecentlyMoved else {
            logSkippingCache(reason: "an item was recently moved")
            return
        }

        guard ScreenCapture.cachedCheckPermissions() else {
            logSkippingCache(reason: "missing Screen Recording permission")
            return
        }

        await updateCacheWithoutChecks(sections: sections)
    }

    /// Updates the cache for all sections, if necessary.
    func updateCache() async {
        guard let appState else {
            return
        }

        let isFloeBarPresented = appState.navigationState.isFloeBarPresented
        let isSettingsPresented = appState.navigationState.isSettingsPresented

        var sectionsNeedingDisplay = [MenuBarSection.Name]()
        if isSettingsPresented {
            sectionsNeedingDisplay = MenuBarSection.Name.allCases
        } else if
            isFloeBarPresented,
            let section = appState.menuBarManager.floeBarPanel.currentSection
        {
            sectionsNeedingDisplay.append(section)
        }

        await updateCache(sections: sectionsNeedingDisplay)
    }
}

// MARK: - Logger

private extension Logger {
    static let imageCache = Logger(category: "MenuBarItemImageCache")
}
