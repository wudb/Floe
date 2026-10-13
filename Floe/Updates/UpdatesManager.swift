//
//  UpdatesManager.swift
//  Floe
//

import Sparkle
import SwiftUI

/// Manager for app updates.
@MainActor
final class UpdatesManager: NSObject, ObservableObject {
    /// A Boolean value that indicates whether the user can check for updates.
    @Published var canCheckForUpdates = false

    /// The date of the last update check.
    @Published var lastUpdateCheckDate: Date?

    /// The shared app state.
    private(set) weak var appState: AppState?

    /// 仅在配置 Floe 自己的更新源后启用 Sparkle，避免安装上游 Ice 的更新。
    var isUpdateFeedConfigured: Bool {
        guard
            let feed = Bundle.main.object(forInfoDictionaryKey: "SUFeedURL") as? String,
            let url = URL(string: feed),
            url.scheme == "https",
            url.host != nil,
            let publicKey = Bundle.main.object(forInfoDictionaryKey: "SUPublicEDKey") as? String,
            !publicKey.isEmpty
        else {
            return false
        }
        return true
    }

    /// The underlying updater controller.
    private(set) lazy var updaterController = SPUStandardUpdaterController(
        startingUpdater: isUpdateFeedConfigured,
        updaterDelegate: self,
        userDriverDelegate: self
    )

    /// The underlying updater.
    var updater: SPUUpdater {
        updaterController.updater
    }

    /// A Boolean value that indicates whether to automatically check for updates.
    var automaticallyChecksForUpdates: Bool {
        get {
            isUpdateFeedConfigured && updater.automaticallyChecksForUpdates
        }
        set {
            guard isUpdateFeedConfigured else { return }
            objectWillChange.send()
            updater.automaticallyChecksForUpdates = newValue
        }
    }

    /// A Boolean value that indicates whether to automatically download updates.
    var automaticallyDownloadsUpdates: Bool {
        get {
            isUpdateFeedConfigured && updater.automaticallyDownloadsUpdates
        }
        set {
            guard isUpdateFeedConfigured else { return }
            objectWillChange.send()
            updater.automaticallyDownloadsUpdates = newValue
        }
    }

    /// Creates an updates manager with the given app state.
    init(appState: AppState) {
        self.appState = appState
        super.init()
    }

    /// Sets up the manager.
    func performSetup() {
        guard isUpdateFeedConfigured else { return }
        _ = updaterController
        configureCancellables()
    }

    /// Configures the internal observers for the manager.
    private func configureCancellables() {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
        updater.publisher(for: \.lastUpdateCheckDate)
            .assign(to: &$lastUpdateCheckDate)
    }

    /// Checks for app updates.
    @objc func checkForUpdates() {
        guard isUpdateFeedConfigured else { return }
        #if DEBUG
        // Checking for updates hangs in debug mode.
        let alert = NSAlert()
        alert.messageText = "Checking for updates is not supported in debug mode."
        alert.runModal()
        #else
        guard let appState else {
            return
        }
        // Activate the app in case an alert needs to be displayed.
        appState.activate(withPolicy: .regular)
        appState.openSettingsWindow()
        updater.checkForUpdates()
        #endif
    }
}

// MARK: UpdatesManager: SPUUpdaterDelegate
extension UpdatesManager: SPUUpdaterDelegate {
    /// Never show Sparkle's "check for updates automatically?" permission prompt.
    ///
    /// Floe runs as a background app (LSUIElement), so it is not active when
    /// Sparkle presents that dialog and the dialog can never process the
    /// response: its buttons and checkbox stay frozen, the choice is never
    /// saved, and the prompt reappears on every launch until the user force
    /// quits (jordanbaird/Ice#681). Floe already exposes the same choice with
    /// its "Automatically check/download updates" toggles in Settings, so the
    /// prompt is redundant as well as broken.
    @objc(updaterShouldPromptForPermissionToCheckForUpdates:)
    func updaterShouldPromptForPermissionToCheck(forUpdates updater: SPUUpdater) -> Bool {
        false
    }

    func updater(_ updater: SPUUpdater, willScheduleUpdateCheckAfterDelay delay: TimeInterval) {
        guard let appState else {
            return
        }
        appState.userNotificationManager.requestAuthorization()
    }
}

// MARK: UpdatesManager: SPUStandardUserDriverDelegate
extension UpdatesManager: @preconcurrency SPUStandardUserDriverDelegate {
    var supportsGentleScheduledUpdateReminders: Bool { true }

    func standardUserDriverShouldHandleShowingScheduledUpdate(
        _ update: SUAppcastItem,
        andInImmediateFocus immediateFocus: Bool
    ) -> Bool {
        if NSApp.isActive {
            return immediateFocus
        } else {
            // Sparkle cannot present interactive UI while Floe sits in the
            // background (LSUIElement): the dialog shows but never dismisses
            // (jordanbaird/Ice#681). Activate first so the update alert works.
            appState?.activate(withPolicy: .regular)
            return true
        }
    }

    func standardUserDriverWillHandleShowingUpdate(
        _ handleShowingUpdate: Bool,
        forUpdate update: SUAppcastItem,
        state: SPUUserUpdateState
    ) {
        guard let appState else {
            return
        }
        if handleShowingUpdate {
            // Sparkle is presenting the update alert itself, so activate for
            // the same reason as above.
            appState.activate(withPolicy: .regular)
        } else if !state.userInitiated {
            appState.userNotificationManager.addRequest(
                with: .updateCheck,
                title: "A new update is available",
                body: "Version \(update.displayVersionString) is now available"
            )
        }
    }

    func standardUserDriverDidReceiveUserAttention(forUpdate update: SUAppcastItem) {
        guard let appState else {
            return
        }
        appState.userNotificationManager.removeDeliveredNotifications(with: [.updateCheck])
    }
}

// MARK: UpdatesManager: BindingExposable
extension UpdatesManager: BindingExposable { }
