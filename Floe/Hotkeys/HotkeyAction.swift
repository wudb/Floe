//
//  HotkeyAction.swift
//  Floe
//

enum HotkeyAction: String, Codable, CaseIterable {
    // Menu Bar Sections
    case toggleHiddenSection = "ToggleHiddenSection"
    case toggleAlwaysHiddenSection = "ToggleAlwaysHiddenSection"

    // Other
    case enableFloeBar = "EnableFloeBar"
    case showSectionDividers = "ShowSectionDividers"
    case toggleApplicationMenus = "ToggleApplicationMenus"

    @MainActor
    func perform(appState: AppState) async {
        switch self {
        case .toggleHiddenSection:
            guard let section = appState.menuBarManager.section(withName: .hidden) else {
                return
            }
            section.toggle()
            // Prevent the section from automatically rehiding after mouse movement.
            if !section.isHidden {
                appState.preventShowOnHover()
            }
        case .toggleAlwaysHiddenSection:
            guard let section = appState.menuBarManager.section(withName: .alwaysHidden) else {
                return
            }
            section.toggle()
            // Prevent the section from automatically rehiding after mouse movement.
            if !section.isHidden {
                appState.preventShowOnHover()
            }
        case .enableFloeBar:
            appState.settingsManager.generalSettingsManager.useFloeBar.toggle()
        case .showSectionDividers:
            appState.settingsManager.advancedSettingsManager.showSectionDividers.toggle()
        case .toggleApplicationMenus:
            appState.menuBarManager.toggleApplicationMenus()
        }
    }
}
