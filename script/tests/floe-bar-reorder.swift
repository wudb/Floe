import Foundation

// 编译生产 CGS 排序事务，受控移动服务验证读回、末尾落点、菜单保护和取消清理。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBarReorderController.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private static func", with: "static func")
}
let methods = [method("    private static func waitForDropToFinish()"), method("    private static func move("), method("    static func isAdjacent(")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-bar-reorder-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
typealias CGWindowID = UInt32
enum MenuBarSection { enum Name { case hidden } }
struct AXItem {}
struct Item { let windowID: UInt32; var frame: CGRect; var isMovable = true; var ownerPID: Int32 = 1; var info = 0 }
typealias MenuBarItem = Item
enum MenuInteractionGuard { static var isInteracting = false }
enum NSEvent {
    struct Flags: OptionSet { let rawValue: Int; static let command = Flags(rawValue: 1), control = Flags(rawValue: 2), option = Flags(rawValue: 4), shift = Flags(rawValue: 8) }
    static var pressedMouseButtons = 0
    static var modifierFlags = Flags()
}
final class Cache {
    var items = [Item(windowID: 1, frame: CGRect(x: 10, y: 0, width: 5, height: 20)), Item(windowID: 2, frame: CGRect(x: 20, y: 0, width: 5, height: 20)), Item(windowID: 3, frame: CGRect(x: 30, y: 0, width: 5, height: 20))]
    func managedItems(for: MenuBarSection.Name) -> [Item] { items }
}
@MainActor final class Manager {
    enum Destination { case leftOfItem(Item), rightOfItem(Item) }
    var isEditingLayout = false, isMovingItem = false, hasTemporarilyShownItems = false
    var apply = true, moves = 0, records = 0, delay = false
    let itemCache = Cache()
    func cacheItemsIfNeeded(force: Bool) async {}
    func recordLayoutChoice() { records += 1 }
    func move(item: Item, to destination: Destination) async throws {
        moves += 1
        if delay { try await Task.sleep(for: .seconds(1)) }
        guard apply else { return }
        var ids = itemCache.items.map(\.windowID).filter { $0 != item.windowID }
        let target: Item; let after: Bool
        switch destination { case .leftOfItem(let i): target = i; after = false; case .rightOfItem(let i): target = i; after = true }
        let index = ids.firstIndex(of: target.windowID)!
        ids.insert(item.windowID, at: index + (after ? 1 : 0))
        itemCache.items = ids.enumerated().map { Item(windowID: $0.element, frame: CGRect(x: $0.offset * 10, y: 0, width: 5, height: 20)) }
    }
}
@MainActor final class AppState { let itemManager = Manager() }
@MainActor enum Reorder {
    enum Item { case cgs(MenuBarItem), ax(AXItem) }
    static func moveUsingAX(_ item: AXItem, before anchor: AXItem, after: Bool, appState: AppState) async throws -> Bool { false }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async {
        let state = AppState(), manager = state.itemManager
        func ref(_ id: UInt32) -> Reorder.Item { .cgs(manager.itemCache.items.first { $0.windowID == id }!) }
        precondition(await Reorder.move(ref(3), before: ref(1), after: false, section: .hidden, appState: state))
        precondition(manager.itemCache.items.map(\.windowID) == [3,1,2] && manager.records == 1 && !manager.isEditingLayout)
        precondition(await Reorder.move(ref(3), before: ref(2), after: true, section: .hidden, appState: state))
        precondition(manager.itemCache.items.map(\.windowID) == [1,2,3] && manager.records == 2)
        let stale = ref(3)
        manager.itemCache.items[2].ownerPID = 99
        check(!(await Reorder.move(stale, before: ref(1), after: false, section: .hidden, appState: state)))
        precondition(manager.moves == 2)
        manager.itemCache.items[2].ownerPID = 1
        manager.apply = false
        precondition(!(await Reorder.move(ref(3), before: ref(1), after: false, section: .hidden, appState: state)))
        precondition(manager.records == 2 && !manager.isEditingLayout)
        MenuInteractionGuard.isInteracting = true
        let before = manager.moves
        precondition(!(await Reorder.move(ref(1), before: ref(2), after: false, section: .hidden, appState: state)))
        precondition(manager.moves == before)
        MenuInteractionGuard.isInteracting = false
        manager.delay = true
        let task = Task { await Reorder.move(ref(3), before: ref(1), after: false, section: .hidden, appState: state) }
        while !manager.isEditingLayout { await Task.yield() }
        task.cancel(); precondition(!(await task.value))
        precondition(!manager.isEditingLayout && manager.records == 2)
        print("PASS: production reorder validates actual adjacency and end placement, refuses false success/protected menus and cleans up cancellation")
    }
}
"""#
// precondition 的 autoclosure 不接受 await；先将结果求值再断言。
let prepared = fixture.replacingOccurrences(of: "precondition(await Reorder.move", with: "check(await Reorder.move")
    .replacingOccurrences(of: "precondition(!(await", with: "check(!(await")
    .replacingOccurrences(of: "@main struct Checks", with: "func check(_ value: Bool) { precondition(value) }\n@main struct Checks")
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try prepared.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
