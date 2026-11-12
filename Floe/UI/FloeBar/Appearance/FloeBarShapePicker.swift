//
//  FloeBarShapePicker.swift
//  Floe
//

import SwiftUI

struct FloeBarShapePicker: View {
    @EnvironmentObject var appearanceManager: FloeBarAppearanceManager

    var body: some View {
        FloeLabeledContent("Leading End Cap") {
            FloePicker("Leading End Cap", selection: appearanceManager.bindings.configuration.splitShapeInfo.trailing.leadingEndCap) {
                Text("Round Cap").tag(MenuBarEndCap.round)
                Text("Square Cap").tag(MenuBarEndCap.square)
            }
        }
        FloeLabeledContent("Trailing End Cap") {
            FloePicker("Trailing End Cap", selection: appearanceManager.bindings.configuration.splitShapeInfo.trailing.trailingEndCap) {
                Text("Round Cap").tag(MenuBarEndCap.round)
                Text("Square Cap").tag(MenuBarEndCap.square)
            }
        }
        FloeLabeledContent("Corner Radius") {
            HStack {
                Slider(value: appearanceManager.bindings.configuration.cornerRadius, in: 0...1)
                Text("\(Int((appearanceManager.configuration.cornerRadius * 100).rounded()))%")
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 40, alignment: .trailing)
            }
        }
    }
}
