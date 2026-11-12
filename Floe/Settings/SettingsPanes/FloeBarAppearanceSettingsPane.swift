//
//  FloeBarAppearanceSettingsPane.swift
//  Floe
//

import SwiftUI

struct FloeBarAppearanceSettingsPane: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        FloeBarAppearanceEditor(location: .settings)
            .environmentObject(appState.floeBarAppearanceManager)
    }
}

#Preview {
    FloeBarAppearanceSettingsPane()
        .environmentObject(AppState())
}
