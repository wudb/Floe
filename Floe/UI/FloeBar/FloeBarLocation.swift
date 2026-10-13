//
//  FloeBarLocation.swift
//  Floe
//

import SwiftUI

/// Locations where the Floe Bar can appear.
enum FloeBarLocation: Int, CaseIterable, Identifiable {
    /// The Floe Bar will appear in different locations based on context.
    case dynamic = 0

    /// The Floe Bar will appear centered below the mouse pointer.
    case mousePointer = 1

    /// The Floe Bar will appear centered below the Floe icon.
    case floeIcon = 2

    var id: Int { rawValue }

    /// Localized string key representation.
    var localized: LocalizedStringKey {
        switch self {
        case .dynamic: "Dynamic"
        case .mousePointer: "Mouse pointer"
        case .floeIcon: "Floe icon"
        }
    }
}
