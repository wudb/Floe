//
//  PermissionsWindow.swift
//  Floe
//

import SwiftUI

struct PermissionsWindow: Scene {
    @ObservedObject private var languageManager = LanguageManager.shared
    @ObservedObject var appState: AppState

    var body: some Scene {
        Window(L10n.string("Permissions"), id: Constants.permissionsWindowID) {
            PermissionsView()
                .appLanguage()
                .appAppearance()
                .readWindow { window in
                    guard let window else {
                        return
                    }
                    appState.assignPermissionsWindow(window)
                }
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .environmentObject(appState.permissionsManager)
    }
}
