//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
let start = source.range(of: "    func show(section:")!.lowerBound
let end = source.range(of: "\n}\n", range: start..<source.endIndex)!.lowerBound
let refreshStart = source.range(of: "    private func refreshContent(for screen:")!.lowerBound
let refreshEnd = source.range(of: "\n    }", range: refreshStart..<source.endIndex)!.upperBound
let production = String(source[refreshStart..<refreshEnd]).replacingOccurrences(of: "private func", with: "func") + "\n" + String(source[start..<end])
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-panel-lifecycle-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
struct NSScreen { let id: Int; var displayID: Int { id } }
enum MenuBarSection { enum Name { case hidden, alwaysHidden } }
@MainActor final class Cache {
    var pending: [Int: CheckedContinuation<Void, Never>] = [:]
    var nextID = 0
    func cacheItemsIfNeeded() async {
        let id = nextID; nextID += 1
        await withCheckedContinuation { pending[id] = $0 }
    }
    func updateCache() async { await cacheItemsIfNeeded() }
    func finish(_ id: Int) { pending.removeValue(forKey: id)!.resume() }
}
@MainActor final class Navigation { var isFloeBarPresented = false }
@MainActor final class AppState {
    let navigationState = Navigation()
    let itemManager = Cache()
    let imageCache = Cache()
}
@MainActor enum ScreenCapture {
    static var permissions = false
    static func cachedCheckPermissions() -> Bool { permissions }
}
@MainActor class BasePanel {
    var contentView: FloeBarHostingView?
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var fronts = 0
    var isVisible = true
    func close() {}
    func orderFrontRegardless() { fronts += 1 }
}
@MainActor final class FloeBarHostingView {
    let screenID: Int
    init(appState: AppState, colorManager: ColorManager, screen: NSScreen, section: MenuBarSection.Name, close: () -> Void) {
        screenID = screen.id
    }
}
@MainActor final class ColorManager {
    func updateAllProperties(with: CGRect, screen: NSScreen) {}
    func invalidate() {}
}
@MainActor final class Panel: BasePanel {
    let appState: AppState? = AppState()
    var currentSection: MenuBarSection.Name?
    var presentationGeneration: UUID?
    var contentDisplayID: Int?
    let colorManager = ColorManager()
    func updateOrigin(for screen: NSScreen) {}
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func wait(_ cache: Cache, id: Int) async {
        while cache.pending[id] == nil { await Task.yield() }
    }
    @MainActor static func main() async throws {
        // 若生产等待发生回归，终止测试而非永久挂住验证进程。
        Task.detached {
            try await Task.sleep(for: .seconds(5))
            exit(124)
        }
        let panel = Panel(); let state = panel.appState!; let cache = state.itemManager
        let old = Task { await panel.show(section: .hidden, on: NSScreen(id: 1)) }
        await wait(cache, id: 0)
        panel.close()
        let newest = Task { await panel.show(section: .hidden, on: NSScreen(id: 2)) }
        await wait(cache, id: 1)
        cache.finish(1); await newest.value
        cache.finish(0); await old.value
        precondition(panel.contentView?.screenID == 2 && panel.fronts == 1, "old same-section request must not overwrite new screen")
        let closing = Task { await panel.show(section: .alwaysHidden, on: NSScreen(id: 1)) }
        await wait(cache, id: 2); panel.close(); cache.finish(2); await closing.value
        precondition(panel.contentView == nil && !state.navigationState.isFloeBarPresented && panel.fronts == 1)
        let cancelled = Task { await panel.show(section: .hidden, on: NSScreen(id: 1)) }
        await wait(cache, id: 3); cancelled.cancel(); cache.finish(3); await cancelled.value
        precondition(panel.contentView == nil && !state.navigationState.isFloeBarPresented && panel.fronts == 1)
        ScreenCapture.permissions = true
        let capture = Task { await panel.show(section: .hidden, on: NSScreen(id: 1)) }
        await wait(cache, id: 4); cache.finish(4); await wait(state.imageCache, id: 0)
        panel.close(); state.imageCache.finish(0); await capture.value
        precondition(panel.contentView == nil && panel.fronts == 1, "close during image refresh must not reopen panel")
        ScreenCapture.permissions = false
        let staleCancelled = Task { await panel.show(section: .hidden, on: NSScreen(id: 1)) }
        await wait(cache, id: 5)
        let current = Task { await panel.show(section: .hidden, on: NSScreen(id: 2)) }
        await wait(cache, id: 6)
        staleCancelled.cancel(); cache.finish(6); await current.value
        cache.finish(5); await staleCancelled.value
        precondition(panel.contentView?.screenID == 2 && state.navigationState.isFloeBarPresented && panel.fronts == 2,
                     "cancelled stale request must not close current panel")
        panel.refreshContent(for: NSScreen(id: 3))
        precondition(panel.contentDisplayID == 3 && panel.contentView?.screenID == 3)
        panel.close()
        panel.refreshContent(for: NSScreen(id: 1))
        precondition(panel.contentView == nil && panel.contentDisplayID == nil)
        print("PASS: production panel migration rebinds content to the new display; closed panel cannot revive on screen notification")
        print("PASS: production show/close rejects stale same-section screens, closed and cancelled requests")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: production).write(to: fixturePath, atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("checks")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
compiler.arguments = ["swiftc", "-parse-as-library", fixturePath.path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let checks = Process()
checks.executableURL = binary
try checks.run()
checks.waitUntilExit()
exit(checks.terminationStatus)
