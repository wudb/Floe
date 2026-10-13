//
//  AppNavigationState.swift
//  Floe
//

import Combine

/// The model for app-wide navigation.
@MainActor
final class AppNavigationState: ObservableObject {
    @Published var isAppFrontmost = false
    @Published var isSettingsPresented = false
    @Published var isFloeBarPresented = false
    @Published var settingsNavigationIdentifier: SettingsNavigationIdentifier = .general
}
