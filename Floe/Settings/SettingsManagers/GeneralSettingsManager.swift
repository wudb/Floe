//
//  GeneralSettingsManager.swift
//  Floe
//

import Combine
import Foundation

@MainActor
final class GeneralSettingsManager: ObservableObject {
    /// A Boolean value that indicates whether the Floe icon
    /// should be shown.
    @Published var showFloeIcon = true

    /// An icon to show in the menu bar, with a different image
    /// for when items are visible or hidden.
    @Published var floeIcon: ControlItemImageSet = .defaultFloeIcon

    /// A Boolean value that indicates whether the Floe icon's
    /// hidden and visible images should be swapped, so the
    /// arrow points the opposite way when hidden.
    @Published var reverseFloeIcon = false

    /// The last user-selected custom Floe icon.
    @Published var lastCustomFloeIcon: ControlItemImageSet?

    /// A Boolean value that indicates whether custom Floe icons
    /// should be rendered as template images.
    @Published var customFloeIconIsTemplate = false

    /// A Boolean value that indicates whether to show hidden items
    /// in a separate bar below the menu bar.
    @Published var useFloeBar = false

    /// The location where the Floe Bar appears.
    @Published var floeBarLocation: FloeBarLocation = .dynamic

    /// A Boolean value that indicates whether the hidden section
    /// should be shown when the mouse pointer clicks in an empty
    /// area of the menu bar.
    @Published var showOnClick = true

    /// A Boolean value that indicates whether the hidden section
    /// should be shown when the mouse pointer hovers over an
    /// empty area of the menu bar.
    @Published var showOnHover = false

    /// A Boolean value that indicates whether the hidden section
    /// should be shown or hidden when the user scrolls in the
    /// menu bar.
    @Published var showOnScroll = true

    /// The offset to apply to the menu bar item spacing and padding.
    @Published var itemSpacingOffset: Double = 0

    /// A Boolean value that indicates whether the hidden section
    /// should automatically rehide.
    @Published var autoRehide = true

    /// A strategy that determines how the auto-rehide feature works.
    @Published var rehideStrategy: RehideStrategy = .smart

    /// A time interval for the auto-rehide feature when its rule
    /// is ``RehideStrategy/timed``.
    @Published var rehideInterval: TimeInterval = 15

    /// Encoder for properties.
    private let encoder = JSONEncoder()

    /// Decoder for properties.
    private let decoder = JSONDecoder()

    /// Storage for internal observers.
    private var cancellables = Set<AnyCancellable>()

    /// The shared app state.
    private(set) weak var appState: AppState?

    init(appState: AppState) {
        self.appState = appState
    }

    func performSetup() {
        loadInitialState()
        configureCancellables()
        // The $itemSpacingOffset sink only fires on change, and loading runs
        // before it subscribes — sync once so spacingManager never starts at
        // a stale 0 while a stored offset exists.
        appState?.spacingManager.offset = Int(itemSpacingOffset)
    }

    private func loadInitialState() {
        Defaults.ifPresent(key: .showFloeIcon, assign: &showFloeIcon)
        Defaults.ifPresent(key: .reverseFloeIcon, assign: &reverseFloeIcon)
        Defaults.ifPresent(key: .customFloeIconIsTemplate, assign: &customFloeIconIsTemplate)
        Defaults.ifPresent(key: .useFloeBar, assign: &useFloeBar)
        Defaults.ifPresent(key: .showOnClick, assign: &showOnClick)
        Defaults.ifPresent(key: .showOnHover, assign: &showOnHover)
        Defaults.ifPresent(key: .showOnScroll, assign: &showOnScroll)
        Defaults.ifPresent(key: .itemSpacingOffset, assign: &itemSpacingOffset)
        Defaults.ifPresent(key: .autoRehide, assign: &autoRehide)
        Defaults.ifPresent(key: .rehideInterval, assign: &rehideInterval)

        Defaults.ifPresent(key: .floeBarLocation) { rawValue in
            if let location = FloeBarLocation(rawValue: rawValue) {
                floeBarLocation = location
            }
        }
        Defaults.ifPresent(key: .rehideStrategy) { rawValue in
            if let strategy = RehideStrategy(rawValue: rawValue) {
                rehideStrategy = strategy
            }
        }

        if let data = Defaults.data(forKey: .floeIcon) {
            do {
                floeIcon = try decoder.decode(ControlItemImageSet.self, from: data)
            } catch {
                Logger.generalSettingsManager.error("Error decoding Floe icon: \(error)")
            }
            if case .custom = floeIcon.name {
                lastCustomFloeIcon = floeIcon
            }
        }
    }

    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        $showFloeIcon
            .receive(on: DispatchQueue.main)
            .sink { showFloeIcon in
                Defaults.set(showFloeIcon, forKey: .showFloeIcon)
            }
            .store(in: &c)

        $floeIcon
            .receive(on: DispatchQueue.main)
            .sink { [weak self] floeIcon in
                guard let self else {
                    return
                }
                if case .custom = floeIcon.name {
                    lastCustomFloeIcon = floeIcon
                }
                do {
                    let data = try encoder.encode(floeIcon)
                    Defaults.set(data, forKey: .floeIcon)
                } catch {
                    Logger.generalSettingsManager.error("Error encoding Floe icon: \(error)")
                }
            }
            .store(in: &c)

        $customFloeIconIsTemplate
            .receive(on: DispatchQueue.main)
            .sink { isTemplate in
                Defaults.set(isTemplate, forKey: .customFloeIconIsTemplate)
            }
            .store(in: &c)

        $reverseFloeIcon
            .receive(on: DispatchQueue.main)
            .sink { reverseFloeIcon in
                Defaults.set(reverseFloeIcon, forKey: .reverseFloeIcon)
            }
            .store(in: &c)

        $useFloeBar
            .receive(on: DispatchQueue.main)
            .sink { useFloeBar in
                Defaults.set(useFloeBar, forKey: .useFloeBar)
            }
            .store(in: &c)

        $floeBarLocation
            .receive(on: DispatchQueue.main)
            .sink { location in
                Defaults.set(location.rawValue, forKey: .floeBarLocation)
            }
            .store(in: &c)

        $showOnClick
            .receive(on: DispatchQueue.main)
            .sink { showOnClick in
                Defaults.set(showOnClick, forKey: .showOnClick)
            }
            .store(in: &c)

        $showOnHover
            .receive(on: DispatchQueue.main)
            .sink { showOnHover in
                Defaults.set(showOnHover, forKey: .showOnHover)
            }
            .store(in: &c)

        $showOnScroll
            .receive(on: DispatchQueue.main)
            .sink { showOnScroll in
                Defaults.set(showOnScroll, forKey: .showOnScroll)
            }
            .store(in: &c)

        $itemSpacingOffset
            .receive(on: DispatchQueue.main)
            .sink { [weak appState] offset in
                Defaults.set(offset, forKey: .itemSpacingOffset)
                appState?.spacingManager.offset = Int(offset)
            }
            .store(in: &c)

        $autoRehide
            .receive(on: DispatchQueue.main)
            .sink { autoRehide in
                Defaults.set(autoRehide, forKey: .autoRehide)
            }
            .store(in: &c)

        $rehideStrategy
            .receive(on: DispatchQueue.main)
            .sink { strategy in
                Defaults.set(strategy.rawValue, forKey: .rehideStrategy)
            }
            .store(in: &c)

        $rehideInterval
            .receive(on: DispatchQueue.main)
            .sink { interval in
                Defaults.set(interval, forKey: .rehideInterval)
            }
            .store(in: &c)

        cancellables = c
    }
}

// MARK: GeneralSettingsManager: BindingExposable
extension GeneralSettingsManager: BindingExposable { }

// MARK: - Logger
private extension Logger {
    static let generalSettingsManager = Logger(category: "GeneralSettingsManager")
}
