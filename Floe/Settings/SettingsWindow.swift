//
//  SettingsWindow.swift
//  Floe
//

import SwiftUI

struct SettingsWindow: Scene {
    @ObservedObject var appState: AppState

    var body: some Scene {
        Window("", id: Constants.settingsWindowID) {
            SettingsView()
                .appLanguage()
                .appAppearance()
                .tint(.blue)
                .readWindow { window in
                    guard let window else {
                        return
                    }
                    window.titlebarAppearsTransparent = true
                    window.titlebarSeparatorStyle = .none
                    appState.assignSettingsWindow(window)
                }
                .frame(minWidth: 860, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .defaultSize(width: 960, height: 720)
        .environmentObject(appState)
        .environmentObject(appState.navigationState)
    }
}
