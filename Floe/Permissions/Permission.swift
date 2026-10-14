//
//  Permission.swift
//  Floe
//

import AXSwift
import Combine
import Cocoa
import ScreenCaptureKit

// MARK: - Permission

/// An object that encapsulates the behavior of checking for and requesting
/// a specific permission for the app.
@MainActor
class Permission: ObservableObject, Identifiable {
    /// A Boolean value that indicates whether the app has this permission.
    @Published private(set) var hasPermission = false

    /// The title of the permission.
    let title: String
    /// Descriptive details for the permission.
    let details: [String]
    /// A Boolean value that indicates if the app can work without this permission.
    let isRequired: Bool

    /// The URL of the settings pane to open.
    private let settingsURL: URL?
    /// The function that checks permissions.
    private let check: () -> Bool
    /// The function that requests permissions.
    private let request: () -> Void

    /// Observer that runs on a timer to check permissions.
    private var timerCancellable: AnyCancellable?
    /// 所有等待者共享检测结果，使用独立标识支持取消。
    private var waiters = [UUID: CheckedContinuation<Void, Error>]()
    /// 返回应用时重新读取真实授权状态，覆盖停止轮询后的权限变更。
    private var activationCancellable: AnyCancellable?

    /// Creates a permission.
    ///
    /// - Parameters:
    ///   - title: The title of the permission.
    ///   - details: Descriptive details for the permission.
    ///   - isRequired: A Boolean value that indicates if the app can work without this permission.
    ///   - settingsURL: The URL of the settings pane to open.
    ///   - check: A function that checks permissions.
    ///   - request: A function that requests permissions.
    init(
        title: String,
        details: [String],
        isRequired: Bool,
        settingsURL: URL?,
        check: @escaping () -> Bool,
        request: @escaping () -> Void
    ) {
        self.title = title
        self.details = details
        self.isRequired = isRequired
        self.settingsURL = settingsURL
        self.check = check
        self.request = request
        self.hasPermission = check()
        configureCancellables()
        activationCancellable = NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.refreshPermission()
            }
    }

    /// Sets up the internal observers for the permission.
    private func configureCancellables() {
        guard timerCancellable == nil else { return }
        // ponytail: no Just(.now) — init already did one sync check(); an immediate
        // second scan (a TCC lookup plus a window-server walk for Screen Recording)
        // doubles boot cost. The timer itself is cancelled for required
        // permissions once they are granted; optional ones keep polling at this
        // rate, with each check rate limited inside ScreenCapture.
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                refreshPermission()
            }
    }

    /// Performs the request and opens the System Settings app to the appropriate pane.
    func performRequest() {
        // 页面状态可能尚未刷新，先核实授权，避免重复请求或打开已无需处理的设置。
        refreshPermission()
        guard !hasPermission else { return }
        request()
        if let settingsURL {
            NSWorkspace.shared.open(settingsURL)
        }
    }

    /// 只在实际变化时发布；撤权后恢复共享轮询，获准时唤醒全部等待者。
    private func refreshPermission() {
        let isGranted = check()
        if isGranted != hasPermission {
            hasPermission = isGranted
        }
        if isGranted {
            let pending = waiters.values
            waiters.removeAll()
            for continuation in pending {
                continuation.resume()
            }
        } else {
            configureCancellables()
        }
    }

    /// 多个调用共享检测，不为每个调用建立轮询；取消只移除当前等待者。
    func waitForPermission() async throws {
        try Task.checkCancellation()
        if waiters.isEmpty {
            refreshPermission()
        }
        guard !hasPermission else { return }
        let id = UUID()
        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                // 取消可能先于注册发生，必须在登记时再次检查。
                if Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                } else {
                    waiters[id] = continuation
                }
            }
        } onCancel: {
            Task { @MainActor [weak self] in
                self?.waiters.removeValue(forKey: id)?.resume(throwing: CancellationError())
            }
        }
        // 授权与取消同时发生时，取消的调用不能继续打开窗口。
        try Task.checkCancellation()
    }

    /// Stops the periodic permission check, keeping one-shot observers alive.
    ///
    /// Called automatically once required permissions are sufficient, so a
    /// skipped launch still notices a later grant from Settings.
    func stopTimerCheck() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

// MARK: - AccessibilityPermission

final class AccessibilityPermission: Permission {
    init() {
        super.init(
            title: "Accessibility",
            details: [
                "Get real-time information about the menu bar.",
                "Arrange menu bar items.",
            ],
            isRequired: true,
            settingsURL: nil,
            check: {
                checkIsProcessTrusted()
            },
            request: {
                checkIsProcessTrusted(prompt: true)
            }
        )
    }
}

// MARK: - ScreenRecordingPermission

final class ScreenRecordingPermission: Permission {
    init() {
        super.init(
            title: "Screen Recording",
            details: [
                "Edit the menu bar's appearance.",
                "Display images of individual menu bar items.",
            ],
            isRequired: false,
            settingsURL: URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"),
            check: {
                ScreenCapture.checkPermissions()
            },
            request: {
                ScreenCapture.requestPermissions()
            }
        )
    }
}
