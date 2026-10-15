//
//  AdaptivePresentationPreferences.swift
//  Floe
//

import Combine
import Foundation

/// 自适应规则独立保存，升级不会改变旧分区模式、布局或固定位置。
@MainActor
final class AdaptivePresentationPreferences: ObservableObject {
    private struct State: Codable {
        var rules = AdaptivePresentationPolicy.Rules()
        var overrides = [String: AdaptivePresentationPolicy.Override]()
    }

    private static let key = "AdaptivePresentation.v1"
    private var state: State
    @Published private(set) var revision = 0

    init() {
        state = UserDefaults.standard.data(forKey: Self.key)
            .flatMap { try? JSONDecoder().decode(State.self, from: $0) } ?? State()
    }

    var rules: AdaptivePresentationPolicy.Rules {
        get { state.rules }
        set { state.rules = newValue; save() }
    }

    func override(for display: String) -> AdaptivePresentationPolicy.Override {
        state.overrides[display] ?? .automatic
    }

    func setOverride(_ value: AdaptivePresentationPolicy.Override, for display: String) {
        guard override(for: display) != value else { return }
        if value == .automatic { state.overrides.removeValue(forKey: display) } else { state.overrides[display] = value }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(state) { UserDefaults.standard.set(data, forKey: Self.key) }
        revision += 1
    }
}
