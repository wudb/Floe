import Foundation

// 使用内存偏好与受控移动服务编译生产布局存储，不写用户偏好、不操作系统图标。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarLayoutStore.swift"), encoding: .utf8)
    .replacingOccurrences(of: "UserDefaults.standard", with: "MemoryDefaults.shared")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-persist-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
@MainActor final class MemoryDefaults {
    static let shared = MemoryDefaults()
    var value: Data?
    func data(forKey: String) -> Data? { value }
    func set(_ data: Data, forKey: String) { value = data }
}
struct MenuBarItemInfo: Equatable {
    struct Namespace: Hashable { let rawValue: String; static let floe = Namespace(rawValue: "floe") }
    let namespace: Namespace; let title: String
    static let hiddenControlItem = MenuBarItemInfo(namespace: .floe, title: "hidden")
    static let alwaysHiddenControlItem = MenuBarItemInfo(namespace: .floe, title: "alwaysHidden")
}
struct MenuBarItem {
    let info: MenuBarItemInfo; let windowID: UInt32
    var frame: CGRect { CGRect(x: CGFloat(windowID), y: 0, width: 1, height: 10) }
    var isMovable = true; var canBeHidden = true
    var logString: String { info.title }
    @MainActor static var live = [MenuBarItem]()
    @MainActor static func getMenuBarItems(onScreenOnly: Bool, activeSpaceOnly: Bool) -> [MenuBarItem] { live }
}
@MainActor final class MenuBarSection {
    enum Name: CaseIterable { case visible, hidden, alwaysHidden }
    var isEnabled = true
}
@MainActor final class BarManager {
    let section = MenuBarSection()
    func section(withName: MenuBarSection.Name) -> MenuBarSection? { section }
}
@MainActor final class AppState { let menuBarManager = BarManager() }
@MainActor enum MenuInteractionGuard { static var isInteracting = false }
@MainActor final class MenuBarItemManager {
    struct ItemCache {
        var groups: [MenuBarSection.Name: [MenuBarItem]] = [:]
        var allItems: [MenuBarItem] { MenuBarSection.Name.allCases.flatMap { groups[$0] ?? [] } }
        subscript(_ section: MenuBarSection.Name) -> [MenuBarItem] { groups[section] ?? [] }
    }
    enum MoveDestination { case leftOfItem(MenuBarItem), rightOfItem(MenuBarItem) }
    var isEditingLayout = false
    var isMovingItem = false; var mouseHasRecentlyMoved = false; var hasTemporarilyShownItems = false
    var appState: AppState? = AppState()
    var itemCache = ItemCache()
    var moves = [UInt32]()
    func move(item: MenuBarItem, to: MoveDestination) async throws { moves.append(item.windowID) }
}
struct Logger {
    init(category: String) {}
    func error(_ message: String) {}
}
__PRODUCTION__
@main struct Checks {
    @MainActor static func main() async {
        func item(_ bundle: String, _ title: String, _ id: UInt32) -> MenuBarItem {
            MenuBarItem(info: MenuBarItemInfo(namespace: .init(rawValue: bundle), title: title), windowID: id)
        }
        let store = MenuBarLayoutStore()
        let a = item("app.a", "song 1", 1), b = item("app.b", "", 2)
        let ambiguous = [item("app.multi", "Item-0", 3), item("app.multi", "Item-0", 4)]
        let known = [item("app.known", "one", 5), item("app.known", "two", 6)]
        let identities = store.identifiedItems([a, b] + ambiguous + known)
        precondition(Set(identities.keys) == ["app.a", "app.b", "app.known:one", "app.known:two"])
        let manager = MenuBarItemManager()
        manager.itemCache.groups = [.hidden: [a], .visible: [b]]
        store.record(manager.itemCache)
        precondition(MemoryDefaults.shared.value != nil)
        // 新实例模拟重启，窗口及动态标题改变仍能以唯一宿主身份恢复。
        let restored = MenuBarLayoutStore()
        let newA = item("app.a", "song 2", 11), newB = item("app.b", "", 12)
        manager.itemCache.groups = [.visible: [newA, newB]]
        MenuBarItem.live = [MenuBarItem(info: .hiddenControlItem, windowID: 100), newA, newB]
        MenuInteractionGuard.isInteracting = true
        await restored.restoreIfNeeded(manager: manager)
        precondition(manager.moves.isEmpty)
        MenuInteractionGuard.isInteracting = false
        manager.hasTemporarilyShownItems = true
        await restored.restoreIfNeeded(manager: manager)
        precondition(manager.moves.isEmpty)
        manager.hasTemporarilyShownItems = false
        await restored.restoreIfNeeded(manager: manager)
        precondition(Set(manager.moves) == [11, 12])
        await restored.restoreIfNeeded(manager: manager)
        precondition(manager.moves.count == 2)
        // 普通存活项目的重新排序不触发自动恢复；不会每五秒拉回用户位置。
        manager.itemCache.groups = [.visible: [newB, newA]]
        await restored.restoreIfNeeded(manager: manager)
        precondition(manager.moves.count == 2)
        // 空缓存不能删除保存的选择，退出的宿主保留并可再次出现。
        let before = MemoryDefaults.shared.value
        restored.record(.init())
        precondition(MemoryDefaults.shared.value == before)
        print("PASS: production layout persists unique identities, rejects ambiguous items, restores recreated windows, protects menus/temporary reveals and does not repeatedly reorder live items")
    }
}
"""#
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: source).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
let executable = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", file.path, "-o", executable])
try run([executable])
