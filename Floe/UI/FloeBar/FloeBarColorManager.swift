//
//  FloeBarColorManager.swift
//  Floe
//

import Cocoa
import Combine

@MainActor
final class FloeBarColorManager: ObservableObject {
    @Published private(set) var colorInfo: MenuBarAverageColorInfo?

    private weak var floeBarPanel: FloeBarPanel?

    private var windowImage: CGImage?

    /// 截图完成前合并重复刷新，避免主线程等待 WindowServer。
    private var captureTask: Task<Void, Never>?
    private var captureGeneration = UUID()
    private var imageDisplayID: CGDirectDisplayID?
    private var requestedDisplayID: CGDirectDisplayID?

    private var cancellables = Set<AnyCancellable>()

    init(floeBarPanel: FloeBarPanel) {
        self.floeBarPanel = floeBarPanel
        configureCancellables()
    }

    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        if let floeBarPanel {
            floeBarPanel.publisher(for: \.screen)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] screen in
                    guard
                        let self,
                        let screen
                    else {
                        return
                    }
                    updateWindowImage(for: screen)
                }
                .store(in: &c)

            Publishers.CombineLatest(
                floeBarPanel.publisher(for: \.frame),
                floeBarPanel.publisher(for: \.isVisible)
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] frame, isVisible in
                guard
                    let self,
                    let screen = floeBarPanel.screen,
                    isVisible
                else {
                    return
                }
                updateColorInfo(with: frame, screen: screen)
            }
            .store(in: &c)

            Publishers.Merge4(
                NSWorkspace.shared.notificationCenter
                    .publisher(for: NSWorkspace.activeSpaceDidChangeNotification)
                    .mapToVoid(),
                NotificationCenter.default
                    .publisher(for: NSApplication.didChangeScreenParametersNotification)
                    .mapToVoid(),
                DistributedNotificationCenter.default()
                    .publisher(for: DistributedNotificationCenter.interfaceThemeChangedNotification)
                    .mapToVoid(),
                Timer.publish(every: 5, on: .main, in: .default)
                    .autoconnect()
                    .mapToVoid()
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self, weak floeBarPanel] in
                guard
                    let self,
                    let floeBarPanel,
                    let screen = floeBarPanel.screen
                else {
                    return
                }
                guard floeBarPanel.isVisible else { return }
                updateWindowImage(for: screen)
                updateColorInfo(with: floeBarPanel.frame, screen: screen)
            }
            .store(in: &c)
        }

        Publishers.Merge3(
            NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.activeSpaceDidChangeNotification).mapToVoid(),
            NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification).mapToVoid(),
            DistributedNotificationCenter.default().publisher(for: DistributedNotificationCenter.interfaceThemeChangedNotification).mapToVoid()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in
            guard let self else { return }
            invalidate()
            if let panel = floeBarPanel, panel.isVisible, let screen = panel.screen {
                updateWindowImage(for: screen)
            }
        }
        .store(in: &c)

        cancellables = c
    }

    /// Space/屏幕/主题变化和面板关闭都立即淘汰旧颜色及未完成截图。
    func invalidate() {
        captureGeneration = UUID()
        captureTask?.cancel()
        captureTask = nil
        requestedDisplayID = nil
        imageDisplayID = nil
        windowImage = nil
        colorInfo = nil
    }

    private func updateWindowImage(for screen: NSScreen) {
        if captureTask != nil {
            guard requestedDisplayID != screen.displayID else { return }
            invalidate()
        }
        if imageDisplayID != screen.displayID {
            windowImage = nil
            colorInfo = nil
        }
        let generation = UUID()
        captureGeneration = generation
        requestedDisplayID = screen.displayID
        captureTask = Task { [weak self] in
            guard let self else { return }
            defer {
                if captureGeneration == generation {
                    captureTask = nil
                    requestedDisplayID = nil
                }
            }
            guard let window = WindowInfo.getMenuBarWindow(for: screen.displayID) else {
                windowImage = nil
                colorInfo = nil
                return
            }
            let image = await ScreenCapture.captureWindow(window.windowID, option: .nominalResolution)
            guard !Task.isCancelled, captureGeneration == generation,
                  let panel = floeBarPanel, panel.screen?.displayID == screen.displayID, panel.isVisible
            else { return }
            imageDisplayID = screen.displayID
            windowImage = image
            updateColorInfo(with: panel.frame, screen: screen)
        }
    }

    private func updateColorInfo(with frame: CGRect, screen: NSScreen) {
        guard imageDisplayID == screen.displayID, let windowImage else {
            colorInfo = nil
            return
        }

        let imageBounds = CGRect(x: 0, y: 0, width: windowImage.width, height: windowImage.height)
        let insetScreenFrame = screen.frame.insetBy(dx: frame.width / 2, dy: 0)
        let percentage = insetScreenFrame.width > 0
            ? ((frame.midX - insetScreenFrame.minX) / insetScreenFrame.width).clamped(to: 0...1)
            : 0.5
        let cropRect = CGRect(x: imageBounds.width * percentage, y: 0, width: 0, height: 1)
            .insetBy(dx: -50, dy: 0)
            .intersection(imageBounds)

        guard
            let croppedImage = windowImage.cropping(to: cropRect),
            let averageColor = croppedImage.averageColor()
        else {
            colorInfo = nil
            return
        }

        colorInfo = MenuBarAverageColorInfo(color: averageColor, source: .menuBarWindow)
    }

    func updateAllProperties(with frame: CGRect, screen: NSScreen) {
        updateWindowImage(for: screen)
        updateColorInfo(with: frame, screen: screen)
    }
}
