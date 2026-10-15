//
//  FloeBarReorderController.swift
//  Floe
//

import Cocoa
import Combine
import UniformTypeIdentifiers

/// 浮栏拖拽只接受本次编辑会话自己的载荷；迟到回调和关闭后的任务不能操纵真实图标。
@MainActor
final class FloeBarReorderController: ObservableObject {
    enum Item {
        case cgs(MenuBarItem)
        case ax(MenuBarItemAXDiscovery.AXMenuBarItem)
    }

    @Published var isEditing = false {
        didSet { token = nil; source = nil }
    }
    @Published private(set) var isMoving = false
    @Published private(set) var failed = false
    private var source: Item?
    private var token: String?
    private var active = false
    private var task: Task<Void, Never>?

    func activate() { active = true }

    func cancel() {
        active = false
        token = nil
        source = nil
        task?.cancel()
    }

    func provider(for item: Item) -> NSItemProvider {
        guard active, isEditing, !isMoving else { return NSItemProvider() }
        source = item
        let value = UUID().uuidString
        token = value
        return NSItemProvider(object: value as NSString)
    }

    func accept(_ providers: [NSItemProvider], before target: Item, after: Bool = false, section: MenuBarSection.Name, appState: AppState) -> Bool {
        guard active, isEditing, !isMoving, let token, let source,
              let provider = providers.first, provider.canLoadObject(ofClass: NSString.self) else { return false }
        provider.loadObject(ofClass: NSString.self) { [weak self] value, _ in
            guard let value = value as? String else { return }
            Task { @MainActor in
                guard let self, self.active, self.isEditing, !self.isMoving, self.token == token, value == token else { return }
                self.token = nil
                self.isMoving = true
                self.failed = false
                self.task = Task {
                    let success = await Self.move(source, before: target, after: after, section: section, appState: appState)
                    if self.active, !Task.isCancelled { self.failed = !success }
                    self.isMoving = false
                    self.task = nil
                }
            }
        }
        return true
    }

    /// 等待用户释放真实拖拽和修饰键，避免合成 Command-drag 与 NSDraggingSession 竞争。
    private static func waitForDropToFinish() async throws {
        let deadline = ContinuousClock.now.advanced(by: .seconds(2))
        while NSEvent.pressedMouseButtons != 0 || !NSEvent.modifierFlags.isDisjoint(with: [.command, .control, .option, .shift]) {
            guard ContinuousClock.now < deadline else { throw CancellationError() }
            try await Task.sleep(for: .milliseconds(30))
        }
        try Task.checkCancellation()
    }

    private static func move(_ source: Item, before target: Item, after: Bool, section: MenuBarSection.Name, appState: AppState) async -> Bool {
        let manager = appState.itemManager
        guard !manager.isEditingLayout, !manager.isMovingItem, !manager.hasTemporarilyShownItems,
              !MenuInteractionGuard.isInteracting else { return false }
        manager.isEditingLayout = true
        defer { manager.isEditingLayout = false }
        do {
            try await waitForDropToFinish()
            let success: Bool
            switch (source, target) {
            case let (.cgs(original), .cgs(originalTarget)):
                let sourceID = original.windowID, targetID = originalTarget.windowID
                guard sourceID != targetID else { return true }
                await manager.cacheItemsIfNeeded(force: true)
                let items = manager.itemCache.managedItems(for: section)
                guard let item = items.first(where: { $0.windowID == sourceID }), item.isMovable,
                      item.ownerPID == original.ownerPID, item.info == original.info,
                      let anchor = items.first(where: { $0.windowID == targetID }),
                      anchor.ownerPID == originalTarget.ownerPID, anchor.info == originalTarget.info else { return false }
                try await manager.move(item: item, to: after ? .rightOfItem(anchor) : .leftOfItem(anchor))
                var landed = false
                for _ in 0..<3 {
                    try await Task.sleep(for: .milliseconds(200))
                    await manager.cacheItemsIfNeeded(force: true)
                    let ids = manager.itemCache.managedItems(for: section).sorted { $0.frame.minX < $1.frame.minX }.map(\.windowID)
                    if Self.isAdjacent(source: sourceID, target: targetID, in: ids, after: after) {
                        landed = true
                        break
                    }
                }
                success = landed
            case let (.ax(item), .ax(anchor)):
                success = try await moveUsingAX(item, before: anchor, after: after, appState: appState)
            default:
                return false
            }
            try Task.checkCancellation()
            await manager.cacheItemsIfNeeded(force: true)
            if success { manager.recordLayoutChoice() }
            return success
        } catch {
            return false
        }
    }

    /// 使用读回的相邻身份验证结果，不以鼠标事件投递成功判断排序成功。
    static func isAdjacent(source: CGWindowID, target: CGWindowID, in ids: [CGWindowID], after: Bool) -> Bool {
        guard let sourceIndex = ids.firstIndex(of: source), let targetIndex = ids.firstIndex(of: target) else { return false }
        return after ? sourceIndex == targetIndex + 1 : sourceIndex + 1 == targetIndex
    }

    /// AX 路径先临时展开，再用最新帧拖动并读回顺序；不把临时展开保存为用户选择。
    private static func moveUsingAX(_ item: MenuBarItemAXDiscovery.AXMenuBarItem, before anchor: MenuBarItemAXDiscovery.AXMenuBarItem, after: Bool, appState: AppState) async throws -> Bool {
        if CFEqual(item.element, anchor.element) { return true }
        guard MenuBarItemAXDiscovery.isTrusted() else { return false }
        let revealed = appState.menuBarManager.sections.compactMap { section -> (MenuBarSection, Int)? in
            guard section.isEnabled, section.controlItem.state == .hideItems else { return nil }
            section.setState(.showItems, persist: false)
            return (section, section.stateRevision)
        }
        defer {
            for (section, revision) in revealed where section.stateRevision == revision {
                section.setState(.hideItems, persist: false)
            }
        }
        try await Task.sleep(for: .milliseconds(250))
        func snapshot() async -> [MenuBarItemAXDiscovery.AXMenuBarItem] {
            let apps = NSWorkspace.shared.runningApplications
            return await Task.detached(priority: .userInitiated) { MenuBarItemAXDiscovery.discoverItems(in: apps) }.value
        }
        let items = await snapshot()
        try Task.checkCancellation()
        guard !MenuInteractionGuard.isInteracting,
              let from = items.first(where: { CFEqual($0.element, item.element) })?.axFrame,
              let to = items.first(where: { CFEqual($0.element, anchor.element) })?.axFrame,
              !from.isEmpty, !to.isEmpty else { return false }
        let start = CGPoint(x: from.midX, y: from.midY)
        let end = CGPoint(x: after ? to.maxX - min(2, to.width / 4) : to.minX + min(2, to.width / 4), y: to.midY)
        guard let display = NSScreen.screens.first(where: { CGDisplayBounds($0.displayID).contains(start) }),
              CGDisplayBounds(display.displayID).contains(end), abs(start.y - end.y) < 8 else { return false }
        appState.eventManager.stopAll()
        defer { appState.eventManager.startAll() }
        guard await MenuBarItemAXMover.commandDrag(from: start, to: end) else { return false }
        let result = await snapshot()
        try Task.checkCancellation()
        guard let sourceFrame = result.first(where: { CFEqual($0.element, item.element) })?.axFrame,
              let targetFrame = result.first(where: { CFEqual($0.element, anchor.element) })?.axFrame,
              after ? sourceFrame.midX > targetFrame.midX : sourceFrame.midX < targetFrame.midX else { return false }
        return !result.contains {
            guard let frame = $0.axFrame else { return false }
            return abs(frame.midY - sourceFrame.midY) < 2 && frame.midX > min(sourceFrame.midX, targetFrame.midX) && frame.midX < max(sourceFrame.midX, targetFrame.midX)
        }
    }
}
