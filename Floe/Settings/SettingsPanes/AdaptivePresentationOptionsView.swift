//
//  AdaptivePresentationOptionsView.swift
//  Floe
//

import SwiftUI

struct AdaptivePresentationOptionsView: View {
    @ObservedObject var preferences: AdaptivePresentationPreferences
    @State private var screens = NSScreen.screens

    private func binding<Value>(_ keyPath: WritableKeyPath<AdaptivePresentationPolicy.Rules, Value>) -> Binding<Value> {
        Binding(get: { preferences.rules[keyPath: keyPath] }, set: {
            var rules = preferences.rules
            rules[keyPath: keyPath] = $0
            preferences.rules = rules
        })
    }

    var body: some View {
        DisclosureGroup("Adaptive presentation rules") {
            Text("Rules affect only Adaptive sections. Fixed section choices take priority, then display overrides, full-screen rules, display scope and available space.")
                .font(.caption).foregroundStyle(.secondary)
            Picker("Apply Floe Bar on", selection: binding(\.display)) {
                ForEach(AdaptivePresentationPolicy.DisplayRule.allCases, id: \.self) { rule in
                    Text(LocalizedStringKey(rule.title)).tag(rule)
                }
            }
            Picker("Connected displays", selection: binding(\.count)) {
                ForEach(AdaptivePresentationPolicy.CountRule.allCases, id: \.self) { rule in
                    Text(LocalizedStringKey(rule.title)).tag(rule)
                }
            }
            Toggle("Only use Floe Bar when space is limited", isOn: binding(\.onlyWhenCrowded))
                .annotation("Measures the continuous space beside application menus and the notch. Unknown measurements use Floe Bar; displays outside the selected scope use the native menu bar.")
            if preferences.rules.onlyWhenCrowded {
                Stepper(value: binding(\.reserveSpace), in: 0...300, step: 12) {
                    Text("Reserve menu bar space: \(Int(preferences.rules.reserveSpace)) pt")
                }
            }
            Picker("In full screen", selection: binding(\.fullscreen)) {
                ForEach(AdaptivePresentationPolicy.FullscreenRule.allCases, id: \.self) { rule in
                    Text(LocalizedStringKey(rule.title)).tag(rule)
                }
            }
            Text("Display overrides")
                .font(.caption).foregroundStyle(.secondary)
            ForEach(screens, id: \.persistentDisplayKey) { screen in
                Picker(screen.localizedName, selection: Binding(
                    get: { preferences.override(for: screen.persistentDisplayKey) },
                    set: { preferences.setOverride($0, for: screen.persistentDisplayKey) }
                )) {
                    ForEach(AdaptivePresentationPolicy.Override.allCases, id: \.self) { value in
                        Text(LocalizedStringKey(value.title)).tag(value)
                    }
                }
            }
            Text("Rules change presentation, not which icons are hidden. Display overrides are remembered after reconnecting.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)) { _ in
            screens = NSScreen.screens
        }
    }
}
