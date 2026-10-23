import Foundation

// 使用内存偏好与受控移动服务编译生产布局存储，不写用户偏好、不操作系统图标。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarLayoutStore.swift"), encoding: .utf8)
    .replacingOccurrences(of: "UserDefaults.standard", with: "MemoryDefaults.shared")
    .replacingOccurrences(of: "Date()", with: "Clock.now")
// 恢复入口与环境协调同样取自生产方法，验证真实的状态发布和任务取消边界。
let managerSource = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift"), encoding: .utf8)
func managerMethod(_ marker: String) -> String {
    let start = managerSource.range(of: marker)!.lowerBound
    let end = managerSource.range(of: "\n    }", range: start..<managerSource.endIndex)!.upperBound
    return String(managerSource[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let importTypes = String(managerSource[managerSource.range(of: "    struct ImportSnapshot {")!.lowerBound..<managerSource.range(of: "    var hasLayoutImportBackup:")!.lowerBound])
let importSources = try ["LayoutImportDocument", "LayoutImportPlan"].map {
    try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/LayoutImport/\($0).swift"), encoding: .utf8)
}.joined(separator: "\n")
let recoveryMethods = [
    "    private func checkImportAvailability()",
    "    func layoutImportSnapshot()",
    "    private func readImportSnapshot()",
    "    func knownImportBundles(",
    "    func captureIceLayout()",
    "    func importLayout(",
    "    func undoLayoutImport()",
    "    func restoreSavedLayout()",
    "    private func scheduleLayoutReconciliation()",
    "    private func invalidateLayoutEnvironment(",
].map(managerMethod).joined(separator: "\n") + "\n" + importTypes
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-persist-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
@MainActor enum Clock { static var now = Date(timeIntervalSince1970: 100) }
enum L10n { static func string(_ key: String, _ args: CVarArg...) -> String { String(format: key, arguments: args) } }
@MainActor final class MemoryDefaults {
    static let shared = MemoryDefaults()
    var values = [String: Data]()
    var value: Data? {
        get { values["MenuBarLayoutChoices.v1"] }
        set { values["MenuBarLayoutChoices.v1"] = newValue }
    }
    func data(forKey key: String) -> Data? { values[key] }
    func set(_ data: Data, forKey key: String) { values[key] = data }
}
struct MenuBarItemInfo: Equatable {
    struct Namespace: Hashable { let rawValue: String; static let floe = Namespace(rawValue: "floe") }
    let namespace: Namespace; let title: String
    var description: String { namespace.rawValue + ":" + title }
    static let hiddenControlItem = MenuBarItemInfo(namespace: .floe, title: "hidden")
    static let alwaysHiddenControlItem = MenuBarItemInfo(namespace: .floe, title: "alwaysHidden")
}
struct MenuBarItem {
    let info: MenuBarItemInfo; let windowID: UInt32
    var ownerPID: Int32 = 1
    var position: CGFloat?
    var frame: CGRect { CGRect(x: position ?? (info.namespace == .floe ? 0 : CGFloat(windowID) * 10), y: 0, width: 1, height: 10) }
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
@MainActor final class NSWorkspace {
    static let shared = NSWorkspace()
    func urlForApplication(withBundleIdentifier: String) -> URL? { nil }
}
@MainActor final class ImportRules {
    var alwaysVisibleApplications = Set<String>()
    func alwaysShows(_ bundle: String) -> Bool { alwaysVisibleApplications.contains(bundle) }
}
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
    let layoutStore = MenuBarLayoutStore()
    let newItemRules = ImportRules()
    var isRecoveringLayout = false
    var layoutRecoveryStatus: String?
    var isLayoutRecoverySuspended = false
    var layoutEnvironmentRevision = 0
    var completedCacheReadGeneration = 0
    var layoutEnvironmentTask: Task<Void, Never>?
    var layoutReconciliationTask: Task<Void, Never>?
    var cachedItemWindowIDs: [UInt32]? = [100]
    var isItemDiscoveryUnavailable = false
    var reads = 0, reconciliations = 0
    var failRead = false
    func cacheItemsIfNeeded(force: Bool = false) async { reads += 1; if !failRead { completedCacheReadGeneration += 1 } }
    func reconcileLayout() async { reconciliations += 1 }
    __RECOVERY_METHODS__
    func itemHasCorrectPosition(item: MenuBarItem, for destination: MoveDestination) throws -> Bool {
        switch destination {
        case .leftOfItem(let target): return item.frame.maxX == target.frame.minX
        case .rightOfItem(let target): return item.frame.minX == target.frame.maxX
        }
    }
    var fail = false
    var beforeMove: (() async -> Void)?
    var moves = [UInt32]()
    func move(item: MenuBarItem, to: MoveDestination, beforePostingEvents: (() throws -> Void)? = nil) async throws { await beforeMove?(); try Task.checkCancellation(); try beforePostingEvents?(); moves.append(item.windowID); if fail { throw CancellationError() } }
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
        let failedStore = MenuBarLayoutStore()
        manager.fail = true; manager.moves = []
        await failedStore.restoreIfNeeded(manager: manager)
        let failedCount = manager.moves.count
        precondition(failedCount > 0)
        manager.fail = false
        await failedStore.restoreIfNeeded(manager: manager)
        precondition(manager.moves.count == failedCount)
        Clock.now = Clock.now.addingTimeInterval(31)
        await failedStore.restoreIfNeeded(manager: manager)
        precondition(manager.moves.count > failedCount)
        let retryCount = manager.moves.count
        manager.itemCache.groups = [.visible: [newB]]
        await failedStore.restoreIfNeeded(manager: manager)
        manager.itemCache.groups = [.visible: [newB, newA]]
        await failedStore.restoreIfNeeded(manager: manager)
        precondition(manager.moves.count > retryCount)

        func save(_ values: [MenuBarLayoutStore.Entry]) {
            MemoryDefaults.shared.value = try! JSONEncoder().encode(values)
        }
        let divider = MenuBarItem(info: .hiddenControlItem, windowID: 100)
        let first = item("first", "one", 21), second = item("second", "two", 22)
        let twoChoices = [MenuBarLayoutStore.Entry(key: "first", section: "hidden"), .init(key: "second", section: "hidden")]

        // 取消发生在输入等待中：未完成项目仍可用相同窗口编号继续恢复。
        save(twoChoices)
        let interrupted = MenuBarLayoutStore(), interruptedManager = MenuBarItemManager()
        interruptedManager.itemCache.groups = [.visible: [first, second]]
        MenuBarItem.live = [divider, first, second]
        var waiting = false
        interruptedManager.beforeMove = { waiting = true; try? await Task.sleep(for: .seconds(10)) }
        let cancelled = Task { await interrupted.restoreIfNeeded(manager: interruptedManager) }
        while !waiting { await Task.yield() }
        cancelled.cancel(); _ = await cancelled.value
        precondition(interruptedManager.moves.isEmpty)
        interruptedManager.beforeMove = nil
        let resumed = await interrupted.restoreIfNeeded(manager: interruptedManager)
        precondition(resumed.remaining == 0 && resumed.restored == 2)

        // 等待期间新的用户布局优先，旧恢复不能在松开鼠标后覆盖它。
        save(twoChoices)
        let superseded = MenuBarLayoutStore(), userManager = MenuBarItemManager()
        userManager.itemCache.groups = [.visible: [first, second]]
        userManager.beforeMove = { superseded.record(userManager.itemCache) }
        _ = await superseded.restoreIfNeeded(manager: userManager)
        precondition(userManager.moves.isEmpty)
        userManager.beforeMove = nil
        _ = await superseded.restoreIfNeeded(manager: userManager)
        precondition(userManager.moves.isEmpty)

        // 第一项未进入目标分区时，后续项目不能把它当锚点继续移动。
        save(twoChoices)
        let blocked = MenuBarLayoutStore(), blockedManager = MenuBarItemManager()
        blockedManager.itemCache.groups = [.visible: [first, second]]
        blockedManager.fail = true
        let blockedResult = await blocked.restoreIfNeeded(manager: blockedManager)
        precondition(blockedManager.moves == [second.windowID] && blockedResult.remaining == 2)
        Clock.now = Clock.now.addingTimeInterval(31)
        blockedManager.fail = false
        let unblocked = await blocked.restoreIfNeeded(manager: blockedManager)
        precondition(unblocked.remaining == 0)

        // PID 已变但窗口 ID 复用，仍必须视为重建宿主。
        save([.init(key: "first", section: "hidden")])
        let reused = MenuBarLayoutStore(), reusedManager = MenuBarItemManager()
        reusedManager.itemCache.groups = [.hidden: [first]]
        reused.record(reusedManager.itemCache)
        var newProcess = first; newProcess.ownerPID = 999
        reusedManager.itemCache.groups = [.visible: [newProcess]]
        MenuBarItem.live = [divider, newProcess]
        _ = await reused.restoreIfNeeded(manager: reusedManager)
        precondition(reusedManager.moves == [first.windowID])

        // 缺少分隔符时保留待办；稍后分隔符返回，不依赖窗口 ID 再次变化。
        save([.init(key: "first", section: "hidden")])
        let missingDivider = MenuBarLayoutStore(), missingManager = MenuBarItemManager()
        missingManager.itemCache.groups = [.visible: [first]]
        MenuBarItem.live = [first]
        let missing = await missingDivider.restoreIfNeeded(manager: missingManager)
        precondition(missing.remaining == 1 && missingManager.moves.isEmpty)
        Clock.now = Clock.now.addingTimeInterval(31)
        MenuBarItem.live = [divider, first]
        let found = await missingDivider.restoreIfNeeded(manager: missingManager)
        precondition(found.remaining == 0 && missingManager.moves == [first.windowID])

        // 相同窗口也能显式重放；显式取消后定时协调不再继续这一批。
        missingManager.moves = []
        missingDivider.requestRestore()
        _ = await missingDivider.restoreIfNeeded(manager: missingManager)
        precondition(missingManager.moves == [first.windowID])
        missingManager.moves = []
        missingDivider.requestRestore(); missingDivider.cancelExplicitRestore()
        _ = await missingDivider.restoreIfNeeded(manager: missingManager)
        precondition(missingManager.moves.isEmpty)

        // 宿主退出期间整理其他图标，保留退出项的分区与原有邻项。
        MemoryDefaults.shared.value = nil
        let absent = MenuBarLayoutStore(), absentManager = MenuBarItemManager()
        let third = item("third", "three", 23)
        absentManager.itemCache.groups = [.visible: [first, second, third]]
        absent.record(absentManager.itemCache)
        absentManager.itemCache.groups = [.visible: [first, third]]
        absent.record(absentManager.itemCache)
        let retained = try! JSONDecoder().decode([MenuBarLayoutStore.Entry].self, from: MemoryDefaults.shared.value!)
        precondition(retained.map(\.key) == ["first", "second", "third"])

        // 损坏/重复身份记录不会被后台基线和新项目规则覆盖。
        save([.init(key: "first", section: "hidden"), .init(key: "first", section: "visible")])
        let damagedData = MemoryDefaults.shared.value
        let damaged = MenuBarLayoutStore()
        precondition(!damaged.isSavedLayoutValid)
        damaged.seedMissingChoices(absentManager.itemCache)
        damaged.assign(key: "first", section: "visible", atEnd: true)
        precondition(MemoryDefaults.shared.value == damagedData)
        precondition(damaged.identifiedItems([first, first]).isEmpty)

        // 无需移动的系统保护项应直接确认，不能产生永远待恢复的假失败。
        save([.init(key: "first", section: "visible")])
        let protectedStore = MenuBarLayoutStore(), protectedManager = MenuBarItemManager()
        var protectedItem = first; protectedItem.isMovable = false; protectedItem.position = 1
        protectedManager.itemCache.groups = [.visible: [protectedItem]]
        MenuBarItem.live = [divider, protectedItem]
        let protectedResult = await protectedStore.restoreIfNeeded(manager: protectedManager)
        precondition(protectedResult.remaining == 0 && protectedManager.moves.isEmpty)

        // 手动恢复入口使用生产方法，验证进度与失败消息不会把不可用路径说成成功。
        save([.init(key: "first", section: "hidden")])
        let manual = MenuBarItemManager()
        manual.itemCache.groups = [.visible: [first]]
        MenuBarItem.live = [divider, first]
        await manual.restoreSavedLayout()
        precondition(!manual.isRecoveringLayout && manual.moves == [first.windowID] && manual.layoutRecoveryStatus?.hasPrefix("Saved positions") == true)
        let unavailable = MenuBarItemManager()
        unavailable.isItemDiscoveryUnavailable = true
        await unavailable.restoreSavedLayout()
        precondition(unavailable.moves.isEmpty && unavailable.layoutRecoveryStatus?.contains("not available in this mode") == true)
        let failedRead = MenuBarItemManager()
        failedRead.failRead = true
        await failedRead.restoreSavedLayout()
        precondition(failedRead.moves.isEmpty && failedRead.layoutRecoveryStatus?.contains("fresh layout") == true,
                     "an old successful cache must not make a failed forced read look like recovery success")
        let busy = MenuBarItemManager()
        busy.isEditingLayout = true
        await busy.restoreSavedLayout()
        precondition(busy.reads == 0 && busy.layoutRecoveryStatus?.contains("Close menus") == true)

        let manualCancel = MenuBarItemManager()
        manualCancel.itemCache.groups = [.visible: [first]]
        waiting = false
        manualCancel.beforeMove = { waiting = true; try? await Task.sleep(for: .seconds(10)) }
        let manualTask = Task { await manualCancel.restoreSavedLayout() }
        while !waiting { await Task.yield() }
        precondition(manualCancel.isRecoveringLayout)
        manualTask.cancel(); await manualTask.value
        precondition(!manualCancel.isRecoveringLayout && manualCancel.moves.isEmpty && manualCancel.layoutRecoveryStatus?.contains("cancelled") == true)
        manualCancel.beforeMove = nil
        _ = await manualCancel.layoutStore.restoreIfNeeded(manager: manualCancel)
        precondition(manualCancel.moves.isEmpty, "explicit cancellation must not leave a hidden automatic batch")

        let lifecycle = MenuBarItemManager()
        lifecycle.invalidateLayoutEnvironment()
        lifecycle.invalidateLayoutEnvironment()
        try? await Task.sleep(for: .milliseconds(850))
        precondition(lifecycle.reads == 1 && lifecycle.reconciliations == 1)
        lifecycle.invalidateLayoutEnvironment()
        lifecycle.invalidateLayoutEnvironment(suspended: true)
        try? await Task.sleep(for: .milliseconds(850))
        precondition(lifecycle.reads == 1 && lifecycle.isLayoutRecoverySuspended)
        lifecycle.invalidateLayoutEnvironment()
        try? await Task.sleep(for: .milliseconds(850))
        precondition(lifecycle.reads == 2 && !lifecycle.isLayoutRecoverySuspended)
        print("PASS: production recovery entry reports success/busy/unavailable/cancelled, cancellation clears explicit work, environment bursts coalesce, sleep cancels and wake resumes")

        print("PASS: cancelled recovery resumes, newer choices win, failed anchors stop the chain, PID reuse and missing dividers recover, explicit cancellation stops the batch, absent hosts retain order and damaged data is preserved")

        // 导入整批提交，备份跨实例保留；无效输入不能覆盖主布局或撤销备份。
        save([.init(key: "keep.a", section: "visible"), .init(key: "move.b", section: "hidden"), .init(key: "keep.c", section: "visible")])
        let imported = MenuBarLayoutStore()
        let original = MemoryDefaults.shared.value!
        precondition(imported.importEntries([.init(key: "move.b", section: "visible"), .init(key: "offline.d", section: "hidden")]))
        let afterImport = try! JSONDecoder().decode([MenuBarLayoutStore.Entry].self, from: MemoryDefaults.shared.value!)
        precondition(afterImport.filter { $0.section == "visible" }.map(\.key) == ["move.b", "keep.a", "keep.c"])
        let importedData = MemoryDefaults.shared.value!
        precondition(!imported.importEntries([.init(key: "duplicate", section: "hidden"), .init(key: "duplicate", section: "visible")]))
        precondition(!imported.importEntries([.init(key: "invalid", section: "unknown")]))
        precondition(MemoryDefaults.shared.value == importedData)
        let restart = MenuBarLayoutStore()
        precondition(restart.hasImportBackup && restart.undoImport())
        precondition(try! JSONDecoder().decode([MenuBarLayoutStore.Entry].self, from: MemoryDefaults.shared.value!) == JSONDecoder().decode([MenuBarLayoutStore.Entry].self, from: original))
        print("PASS: atomic import preserves unmentioned app order, rejects duplicate/invalid batches and restores the previous layout across restart")
        // 提交前的新读回必须与预览一致，规则变化、原生顺序变化和取消均不写入。
        let importer = MenuBarItemManager()
        importer.itemCache.groups = [.visible: [first]]
        MenuBarItem.live = [divider, first]
        let proposal = [LayoutImportDocument.Item(identity: "first", section: .hidden)]
        let selected = Set(proposal.map(\.id))
        let snapshot = try! await importer.layoutImportSnapshot()
        importer.newItemRules.alwaysVisibleApplications.insert("first")
        do { try await importer.importLayout(items: proposal, selected: selected, snapshot: snapshot); preconditionFailure("stale rule accepted") }
        catch LayoutImportDocument.Failure.stale {} catch { preconditionFailure("wrong error: \(error)") }
        importer.newItemRules.alwaysVisibleApplications = []
        importer.itemCache.groups = [.hidden: [first]]
        do { try await importer.importLayout(items: proposal, selected: selected, snapshot: snapshot); preconditionFailure("stale section accepted") }
        catch LayoutImportDocument.Failure.stale {} catch { preconditionFailure("wrong error: \(error)") }
        let beforeManagerImport = MemoryDefaults.shared.value!
        importer.itemCache.groups = [.visible: [first]]
        do { try await importer.importLayout(items: proposal, selected: [], snapshot: snapshot); preconditionFailure("empty selection accepted") }
        catch LayoutImportDocument.Failure.invalidSelection {} catch { preconditionFailure("wrong error: \(error)") }
        precondition(MemoryDefaults.shared.value == beforeManagerImport)
        importer.itemCache.groups = [.visible: [first]]
        try! await importer.importLayout(items: proposal, selected: selected, snapshot: snapshot)
        precondition(!importer.isRecoveringLayout)
        precondition(importer.moves == [first.windowID])
        let managerBackup = MemoryDefaults.shared.values["MenuBarLayoutImportBackup.v1"]!
        try! await importer.undoLayoutImport()
        precondition(MemoryDefaults.shared.value == managerBackup)
        let undoEntries = try! JSONDecoder().decode([MenuBarLayoutStore.Entry].self, from: managerBackup)
        precondition(undoEntries.contains { $0.key == "first" && $0.section == "visible" })
        let previousManagerEntries = try! JSONDecoder().decode([MenuBarLayoutStore.Entry].self, from: beforeManagerImport)
        for section in ["visible", "hidden", "alwaysHidden"] {
            precondition(undoEntries.filter { $0.key != "first" && $0.section == section } == previousManagerEntries.filter { $0.section == section })
        }

        let iceManager = MenuBarItemManager()
        var h = item("com.jordanbaird.Ice", "HItem", 801); h.position = 100
        var ah = item("com.jordanbaird.Ice", "AHItem", 802); ah.position = 50
        var visible = item("com.example.visible", "", 803); visible.position = 110
        var hidden = item("com.example.hidden", "", 804); hidden.position = 60
        var always = item("com.example.always", "", 805); always.position = 30
        MenuBarItem.live = [visible, h, hidden, ah, always, divider]
        let captured = try! iceManager.captureIceLayout()
        precondition(captured.map(\.identity) == ["com.example.always", "com.example.hidden", "com.example.visible"])
        precondition(captured.map(\.section) == [.alwaysHidden, .hidden, .visible])
        MenuBarItem.live = [visible, hidden]
        do { _ = try iceManager.captureIceLayout(); preconditionFailure("missing Ice dividers accepted") }
        catch LayoutImportDocument.Failure.iceNotFound {} catch { preconditionFailure("wrong error: \(error)") }
        // 取消的强制扫描与不可用发现都不能改写布局；损坏记录只有显式手动整理才能替换。
        let rejected = MenuBarItemManager()
        rejected.itemCache.groups = [.visible: [first]]
        let rejectedSnapshot = try! await rejected.layoutImportSnapshot()
        let unchanged = MemoryDefaults.shared.value!
        rejected.failRead = true
        do { try await rejected.importLayout(items: proposal, selected: selected, snapshot: rejectedSnapshot); preconditionFailure("failed fresh read accepted") }
        catch LayoutImportDocument.Failure.stale {} catch { preconditionFailure("wrong error: \(error)") }
        precondition(MemoryDefaults.shared.value == unchanged)
        rejected.failRead = false
        rejected.isItemDiscoveryUnavailable = true
        do { _ = try await rejected.layoutImportSnapshot(); preconditionFailure("AX-only import accepted") }
        catch LayoutImportDocument.Failure.discoveryUnavailable {} catch { preconditionFailure("wrong error: \(error)") }
        precondition(MemoryDefaults.shared.value == unchanged)
        rejected.isItemDiscoveryUnavailable = false
        let cancelledImport = Task { @MainActor in
            withUnsafeCurrentTask { $0?.cancel() }
            do { try await rejected.importLayout(items: proposal, selected: selected, snapshot: rejectedSnapshot); preconditionFailure("cancelled import accepted") }
            catch is CancellationError {} catch { preconditionFailure("wrong error: \(error)") }
        }
        await cancelledImport.value
        precondition(MemoryDefaults.shared.value == unchanged && !rejected.isRecoveringLayout)
        let corrupt = Data("damaged".utf8)
        MemoryDefaults.shared.value = corrupt
        let invalidImporter = MenuBarItemManager()
        invalidImporter.itemCache.groups = [.visible: [first]]
        let invalidSnapshot = try! await invalidImporter.layoutImportSnapshot()
        do { try await invalidImporter.importLayout(items: proposal, selected: selected, snapshot: invalidSnapshot); preconditionFailure("damaged baseline overwritten") }
        catch LayoutImportDocument.Failure.damagedLayout {} catch { preconditionFailure("wrong error: \(error)") }
        precondition(MemoryDefaults.shared.value == corrupt)
        print("PASS: production importer rejects stale/empty/cancelled/failed/damaged submissions, commits and undoes through recovery, captures Ice dividers and rejects absent Ice")

        print("PASS: failed restoration backs off and retries; disappearance/reappearance with reused window ID is restored")
        print("PASS: production layout persists unique identities, rejects ambiguous items, restores recreated windows, protects menus/temporary reveals and does not repeatedly reorder live items")
    }
}
"""#
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: source + "\n" + importSources).replacingOccurrences(of: "__RECOVERY_METHODS__", with: recoveryMethods).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
let executable = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", file.path, "-o", executable])
try run([executable])
