import Foundation

// 编译生产规则和恢复逻辑，使用内存偏好与模拟状态项，不移动用户图标。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
func read(_ name: String) throws -> String {
    try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/" + name + ".swift"), encoding: .utf8)
        .replacingOccurrences(of: "UserDefaults.standard", with: "MemoryDefaults.shared")
        .replacingOccurrences(of: "Date()", with: "Clock.now")
}
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-new-rules-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
@MainActor enum Clock { static var now = Date(timeIntervalSince1970: 100) }
@MainActor final class MemoryDefaults {
    static let shared = MemoryDefaults()
    var values = [String: Data]()
    func data(forKey key: String) -> Data? { values[key] }
    func set(_ data: Data, forKey key: String) { values[key] = data }
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
    var fail = false
    var moves = [UInt32]()
    var destinations = [String]()
    func move(item: MenuBarItem, to: MoveDestination) async throws { moves.append(item.windowID); switch to { case .leftOfItem(let i): destinations.append("left:\(i.windowID)"); case .rightOfItem(let i): destinations.append("right:\(i.windowID)") }; if fail { throw CancellationError() } }
}
struct Logger {
    init(category: String) {}
    func error(_ message: String) {}
}
__STORE__
__RULES__

@main struct Checks {
    @MainActor static func main() async {
        func item(_ bundle: String, _ id: UInt32) -> MenuBarItem {
            MenuBarItem(info: .init(namespace: .init(rawValue: bundle), title: "icon"), windowID: id)
        }
        func choices() -> [MenuBarLayoutStore.Entry] {
            try! JSONDecoder().decode([MenuBarLayoutStore.Entry].self, from: MemoryDefaults.shared.data(forKey: "MenuBarLayoutChoices.v1")!)
        }
        let a = item("app.a", 1), b = item("app.b", 2), c = item("app.c", 3)
        let divider = MenuBarItem(info: .hiddenControlItem, windowID: 100)
        let manager = MenuBarItemManager(), store = MenuBarLayoutStore(), rules = MenuBarNewItemRules()
        manager.itemCache.groups = [.hidden: [a], .visible: [b]]
        MenuBarItem.live = [divider, a, b]
        rules.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        await store.restoreIfNeeded(manager: manager)
        precondition(manager.moves.isEmpty, "baseline must never migrate existing items")
        manager.itemCache.groups[.hidden] = [a, c]; MenuBarItem.live.append(c)
        rules.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        await store.restoreIfNeeded(manager: manager)
        precondition(manager.moves == [3] && manager.destinations.last == "right:2", "new item belongs after existing visible item")
        let restarted = MenuBarNewItemRules(); restarted.destination = .hidden
        let rebuilt = item("app.c", 13)
        manager.itemCache.groups = [.hidden: [a, rebuilt], .visible: [b]]
        MenuBarItem.live = [divider, a, rebuilt, b]
        restarted.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        await store.restoreIfNeeded(manager: manager)
        precondition(manager.moves.last == 13 && choices().first(where: { $0.key == "app.c" })?.section == "visible")
        let d = item("app.d", 4)
        restarted.destination = .alwaysHidden
        manager.itemCache.groups[.visible, default: []].append(d)
        restarted.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: false)
        precondition(choices().first(where: { $0.key == "app.d" })?.section == "hidden")
        let e = item("app.e", 5)
        restarted.destination = .system
        manager.itemCache.groups[.visible, default: []].append(e)
        restarted.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        precondition(choices().first(where: { $0.key == "app.e" })?.section == "visible")
        restarted.destination = .visible; restarted.insertAtEnd = false
        let f = item("app.f", 6)
        manager.itemCache.groups[.hidden, default: []].append(f)
        restarted.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        precondition(choices().first?.key == "app.f", "beginning must precede existing members")
        // 自身身份统一后，不能被添加成普通应用的常显规则。
        restarted.setAlwaysShown("com.float.floe", enabled: true)
        precondition(!restarted.alwaysShows("com.float.floe"))
        restarted.setAlwaysShown("app.a", enabled: true)
        restarted.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        precondition(choices().first(where: { $0.key == "app.a" })?.section == "visible")
        restarted.setAlwaysShown("app.a", enabled: false)
        store.assign(key: "app.a", section: "hidden", atEnd: true)
        restarted.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        precondition(choices().first(where: { $0.key == "app.a" })?.section == "hidden")
        let siblings = [MenuBarItem(info: .init(namespace: .init(rawValue: "app.b"), title: "one"), windowID: 21),
                        MenuBarItem(info: .init(namespace: .init(rawValue: "app.b"), title: "two"), windowID: 22)]
        manager.itemCache.groups = [.hidden: siblings]
        restarted.prepare(cache: manager.itemCache, store: store, alwaysHiddenEnabled: true)
        precondition(choices().first(where: { $0.key == "app.b:one" })?.section == "hidden")
        precondition(choices().first(where: { $0.key == "app.b:two" })?.section == "hidden")
        print("PASS: production new-item rules preserve baseline and saved choices, persist discovery, implement section/endpoints/fallback/system placement, application rules and identity-shape safety")
    }
}
"""#
let code = try fixture.replacingOccurrences(of: "__STORE__", with: read("MenuBarLayoutStore"))
    .replacingOccurrences(of: "__RULES__", with: read("MenuBarNewItemRules"))
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try code.write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env")
compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
