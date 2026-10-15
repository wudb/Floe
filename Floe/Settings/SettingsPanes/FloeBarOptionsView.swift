//
//  FloeBarOptionsView.swift
//  Floe
//

import SwiftUI

struct FloeBarOptionsView: View {
    @ObservedObject var preferences: FloeBarPreferences
    @ObservedObject var adaptivePreferences: AdaptivePresentationPreferences

    var body: some View {
        ForEach(["hidden", "alwaysHidden"], id: \.self) { section in
            Picker(
                LocalizedStringKey(section == "hidden" ? "Hidden section display" : "Always Hidden section display"),
                selection: Binding(get: { preferences.presentation(for: section) }, set: { preferences.setPresentation($0, for: section) })
            ) {
                ForEach(FloeBarPreferences.Presentation.allCases, id: \.self) { mode in
                    Text(LocalizedStringKey(mode.title)).tag(mode)
                }
            }
        }
        Text("Use Floe Bar applies only to sections set to Follow Use Floe Bar.")
            .font(.caption).foregroundStyle(.secondary)
        AdaptivePresentationOptionsView(preferences: adaptivePreferences)
        Picker("Floe Bar layout", selection: Binding(get: { preferences.layout }, set: { preferences.layout = $0 })) {
            ForEach(FloeBarPreferences.Layout.allCases, id: \.self) { layout in
                Text(LocalizedStringKey(layout.title)).tag(layout)
            }
        }
        if preferences.layout == .grid {
            Stepper(value: Binding(get: { preferences.columns }, set: { preferences.columns = $0 }), in: 2...12) {
                Text("Grid columns: \(preferences.columns)")
            }
        }
        Toggle("Fixed Floe Bar position", isOn: Binding(get: { preferences.fixedPosition }, set: { preferences.fixedPosition = $0 }))
            .annotation("Right-click the Floe Bar background to pin its position or reorder icons. Pinning does not prevent automatic rehide.")
        Text("Showing Always Hidden in the native menu bar also reveals Hidden because the native sections share one row.")
            .font(.caption).foregroundStyle(.secondary)
    }
}
