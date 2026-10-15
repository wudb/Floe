//
//  FloeBarPreferences.swift
//  Floe
//

import Combine
import CoreGraphics
import Foundation

/// 分区呈现独立于用户已保存的显隐状态；继承模式兼容原有浮栏开关和快捷键。
@MainActor
final class FloeBarPreferences: ObservableObject {
    enum Presentation: String, CaseIterable {
        case inherited, native, floating
        var title: String {
            switch self {
            case .inherited: "Follow Use Floe Bar"
            case .native: "Native menu bar"
            case .floating: "Floe Bar"
            }
        }
    }

    enum Layout: String, CaseIterable {
        case icons, list, grid
        var title: String {
            switch self {
            case .icons: "Horizontal icons"
            case .list: "Names list"
            case .grid: "Icon grid"
            }
        }
    }

    /// 保存相对于可用移动范围的位置，而非像素坐标；尺寸和缩放改变后仍留在屏内。
    struct RelativePosition: Codable, Equatable {
        var x: Double
        var y: Double

        init(origin: CGPoint, size: CGSize, bounds: CGRect) {
            let width = max(0, bounds.width - size.width), height = max(0, bounds.height - size.height)
            x = width > 0 ? min(1, max(0, (origin.x - bounds.minX) / width)) : 0
            y = height > 0 ? min(1, max(0, (origin.y - bounds.minY) / height)) : 0
        }

        func origin(size: CGSize, bounds: CGRect) -> CGPoint {
            let horizontal = x.isFinite ? min(1, max(0, x)) : 1
            let vertical = y.isFinite ? min(1, max(0, y)) : 1
            return CGPoint(
                x: bounds.minX + max(0, bounds.width - size.width) * horizontal,
                y: bounds.minY + max(0, bounds.height - size.height) * vertical
            )
        }
    }

    private struct State: Codable {
        var hidden = Presentation.inherited.rawValue
        var alwaysHidden = Presentation.inherited.rawValue
        var layout = Layout.icons.rawValue
        var columns = 6
        var fixedPosition = false
        var positions = [String: RelativePosition]()
    }

    private static let key = "FloeBarPreferences.v1"
    private var state: State
    @Published private(set) var revision = 0
    @Published private(set) var presentationRevision = 0
    private(set) var changedSection: String?

    init() {
        state = UserDefaults.standard.data(forKey: Self.key)
            .flatMap { try? JSONDecoder().decode(State.self, from: $0) } ?? State()
    }

    func presentation(for section: String) -> Presentation {
        Presentation(rawValue: section == "alwaysHidden" ? state.alwaysHidden : state.hidden) ?? .inherited
    }

    func usesFloating(section: String, legacy: Bool) -> Bool {
        switch presentation(for: section) {
        case .inherited: legacy
        case .native: false
        case .floating: true
        }
    }

    func setPresentation(_ mode: Presentation, for section: String) {
        guard presentation(for: section) != mode else { return }
        if section == "alwaysHidden" { state.alwaysHidden = mode.rawValue } else { state.hidden = mode.rawValue }
        changedSection = section
        save(presentationChanged: true)
    }

    var layout: Layout {
        get { Layout(rawValue: state.layout) ?? .icons }
        set { state.layout = newValue.rawValue; changedSection = nil; save(presentationChanged: true) }
    }

    var columns: Int {
        get { min(12, max(2, state.columns)) }
        set { state.columns = min(12, max(2, newValue)); changedSection = nil; save(presentationChanged: true) }
    }

    var fixedPosition: Bool {
        get { state.fixedPosition }
        set { state.fixedPosition = newValue; save() }
    }

    func pin(origin: CGPoint, size: CGSize, bounds: CGRect, display: String) {
        state.positions[display] = RelativePosition(origin: origin, size: size, bounds: bounds)
        state.fixedPosition = true
        save()
    }

    func fixedOrigin(size: CGSize, bounds: CGRect, display: String) -> CGPoint? {
        guard fixedPosition else { return nil }
        // 尚无该屏记录时停靠右上角，不借用另一个显示器的绝对位置。
        let position = state.positions[display] ?? RelativePosition(origin: CGPoint(x: bounds.maxX, y: bounds.maxY), size: size, bounds: bounds)
        return position.origin(size: size, bounds: bounds)
    }

    private func save(presentationChanged: Bool = false) {
        if let data = try? JSONEncoder().encode(state) { UserDefaults.standard.set(data, forKey: Self.key) }
        revision += 1
        if presentationChanged { presentationRevision += 1 }
    }
}
