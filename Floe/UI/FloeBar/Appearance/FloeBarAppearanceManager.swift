//
//  FloeBarAppearanceManager.swift
//  Floe
//

import Cocoa
import Combine

/// 浮栏外观独立保存，旧菜单栏外观仅作为首次迁移的数据来源。
@MainActor
final class FloeBarAppearanceManager: ObservableObject {
    @Published var configuration: MenuBarAppearanceConfigurationV2 = .defaultConfiguration

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var cancellables = Set<AnyCancellable>()

    func performSetup() {
        guard cancellables.isEmpty else { return }
        loadInitialState()
        $configuration
            .encode(encoder: encoder)
            .sink { completion in
                if case .failure(let error) = completion {
                    Logger.floeBarAppearance.error("Error encoding Floe Bar appearance: \(error)")
                }
            } receiveValue: { data in
                Defaults.set(data, forKey: .floeBarAppearanceConfiguration)
            }
            .store(in: &cancellables)
    }

    private func loadInitialState() {
        do {
            let data = Defaults.data(forKey: .floeBarAppearanceConfiguration)
                ?? Defaults.data(forKey: .menuBarAppearanceConfigurationV2)
            guard let data else { return }
            var saved = try decoder.decode(MenuBarAppearanceConfigurationV2.self, from: data)
            // 旧 Full/None 形状转换为浮栏的两端形状，保留色调、模糊、边框和圆角参数。
            switch saved.shapeKind {
            case .full:
                saved.splitShapeInfo.trailing = saved.fullShapeInfo
            case .none:
                saved.splitShapeInfo.trailing = .init(leadingEndCap: .square, trailingEndCap: .square)
            case .split:
                break
            }
            saved.shapeKind = .split
            configuration = saved
        } catch {
            Logger.floeBarAppearance.error("Error decoding Floe Bar appearance: \(error)")
        }
    }
}

extension FloeBarAppearanceManager: BindingExposable { }

private extension Logger {
    static let floeBarAppearance = Logger(category: "FloeBarAppearanceManager")
}
