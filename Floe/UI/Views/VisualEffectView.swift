//
//  VisualEffectView.swift
//  Floe
//

import SwiftUI

/// A SwiftUI view that wraps an `NSVisualEffectView`.
struct VisualEffectView: NSViewRepresentable {
    @Environment(\.colorScheme) private var colorScheme
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        visualEffectView.isEmphasized = true
        visualEffectView.appearance = NSAppearance(named: colorScheme == .dark ? .darkAqua : .aqua)
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        // SwiftUI 的局部外观也必须传给 AppKit 材质，尤其是独立浮栏的 NSHostingView。
        visualEffectView.appearance = NSAppearance(named: colorScheme == .dark ? .darkAqua : .aqua)
    }
}
