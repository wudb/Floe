//
//  FloeBarAppearanceEditor.swift
//  Floe
//

import SwiftUI

struct FloeBarAppearanceEditor: View {
    enum Location {
        case settings
        case popover(closePopover: () -> Void)
    }

    @EnvironmentObject var appearanceManager: FloeBarAppearanceManager
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if case .popover(let closePopover) = location {
                HStack {
                    Text("Floe Bar Appearance").font(.title2)
                    Spacer()
                    Button("Done", action: closePopover).buttonStyle(FloeButtonStyle())
                }
                .padding(20)
            }
            FloeForm(padding: EdgeInsets(all: 20)) {
                FloeSection {
                    Toggle("Use dynamic appearance", isOn: appearanceManager.bindings.configuration.isDynamic)
                        .annotation("Apply different settings based on the current system appearance")
                }
                if appearanceManager.configuration.isDynamic {
                    FloeSection("Light Appearance", options: .plain) {}
                    UnlabeledPartialEditor(configuration: appearanceManager.bindings.configuration.lightModeConfiguration)
                    FloeSection("Dark Appearance", options: .plain) {}
                    UnlabeledPartialEditor(configuration: appearanceManager.bindings.configuration.darkModeConfiguration)
                } else {
                    UnlabeledPartialEditor(configuration: appearanceManager.bindings.configuration.staticConfiguration)
                }
                FloeSection("Floe Bar Shape") {
                    FloeBarShapePicker()
                }
                if appearanceManager.configuration != .defaultConfiguration {
                    Button("Reset") {
                        appearanceManager.configuration = .defaultConfiguration
                    }
                    .buttonStyle(FloeButtonStyle())
                }
            }
        }
    }
}

private struct UnlabeledPartialEditor: View {
    @Binding var configuration: MenuBarAppearancePartialConfiguration

    var body: some View {
        FloeSection {
            tintPicker
            tintOpacity
            blurToggle
            shadowToggle
        }
        FloeSection {
            borderToggle
            borderColor
            borderWidth
        }
    }

    @ViewBuilder
    private var tintPicker: some View {
        FloeLabeledContent("Tint") {
            HStack {
                FloePicker("Tint", selection: $configuration.tintKind) {
                    ForEach(MenuBarTintKind.allCases) { tintKind in
                        Text(tintKind.localized).tag(tintKind)
                    }
                }
                .labelsHidden()

                switch configuration.tintKind {
                case .none:
                    EmptyView()
                case .solid:
                    CustomColorPicker(
                        selection: $configuration.tintColor,
                        supportsOpacity: false,
                        mode: .crayon
                    )
                case .gradient:
                    CustomGradientPicker(
                        gradient: $configuration.tintGradient,
                        supportsOpacity: false,
                        allowsEmptySelections: false,
                        mode: .crayon
                    )
                }
            }
            .frame(height: 24)
        }
    }

    @ViewBuilder
    private var tintOpacity: some View {
        if configuration.tintKind != .none {
            FloeLabeledContent("Tint Opacity") {
                HStack {
                    Slider(value: $configuration.tintOpacity, in: 0...1)
                    Text("\(Int((configuration.tintOpacity * 100).rounded()))%")
                        .foregroundStyle(.secondary)
                        .frame(minWidth: 40, alignment: .trailing)
                }
            }
        }
    }

    @ViewBuilder
    private var blurToggle: some View {
        FloeLabeledContent("Blur") {
            HStack {
                Slider(value: $configuration.blurAmount, in: 0...1)
                Text("\(Int((configuration.blurAmount * 100).rounded()))%")
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 40, alignment: .trailing)
            }
        }
    }

    @ViewBuilder
    private var shadowToggle: some View {
        Toggle("Shadow", isOn: $configuration.hasShadow)
    }

    @ViewBuilder
    private var borderToggle: some View {
        Toggle("Border", isOn: $configuration.hasBorder)
    }

    @ViewBuilder
    private var borderColor: some View {
        if configuration.hasBorder {
            FloeLabeledContent("Border Color") {
                CustomColorPicker(
                    selection: $configuration.borderColor,
                    supportsOpacity: true,
                    mode: .crayon
                )
            }
        }
    }

    @ViewBuilder
    private var borderWidth: some View {
        if configuration.hasBorder {
            FloePicker(
                "Border Width",
                selection: $configuration.borderWidth
            ) {
                Text("1").tag(1.0)
                Text("2").tag(2.0)
                Text("3").tag(3.0)
            }
        }
    }
}
