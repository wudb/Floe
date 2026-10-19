//
//  AppAppearancePicker.swift
//  Floe
//

import SwiftUI

struct AppAppearancePicker: View {
    @Binding var selection: AppAppearance

    var body: some View {
        Picker("Appearance", selection: $selection) {
            ForEach(AppAppearance.allCases) { appearance in
                Text(appearance.titleKey).tag(appearance)
            }
        }
        .pickerStyle(.menu)
        .buttonStyle(.bordered)
        .controlSize(.regular)
        .tint(.primary)
        .font(.callout)
        .labelsHidden()
        .fixedSize()
    }
}
