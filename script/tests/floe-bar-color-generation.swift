import Foundation

// 编译生产颜色捕获/失效方法，以可控迟到截图验证跨屏与关闭后的代次隔离。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBarColorManager.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let methods = [method("    func invalidate()"), method("    private func updateWindowImage("), method("    private func updateColorInfo(")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-color-generation-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
import CoreGraphics
typealias CGDirectDisplayID = UInt32
extension CGFloat { func clamped(to range: ClosedRange<CGFloat>) -> CGFloat { Swift.min(Swift.max(self, range.lowerBound), range.upperBound) } }
struct NSScreen { let displayID: UInt32; var frame: CGRect { CGRect(x: 0, y: 0, width: 100, height: 100) } }
struct CGImage {
    let id: Int
    var width: Int { 100 }; var height: Int { 24 }
    func cropping(to frame: CGRect) -> CGImage? { self }
    func averageColor() -> Int? { id }
}
struct MenuBarAverageColorInfo { enum Source { case menuBarWindow }; let color: Int; let source: Source }
struct WindowInfo { let windowID: UInt32; static func getMenuBarWindow(for id: UInt32) -> WindowInfo? { WindowInfo(windowID: id) } }
@MainActor enum ScreenCapture {
    enum Option { case nominalResolution }
    static var next = 0
    static var pending: [Int: CheckedContinuation<CGImage?, Never>] = [:]
    static func captureWindow(_ id: UInt32, option: Option) async -> CGImage? {
        let request = next; next += 1
        return await withCheckedContinuation { pending[request] = $0 }
    }
    static func finish(_ request: Int, id: Int) { pending.removeValue(forKey: request)!.resume(returning: CGImage(id: id)) }
}
@MainActor final class Panel { var screen: NSScreen? = NSScreen(displayID: 1); var isVisible = true; let frame = CGRect(x: 0, y: 0, width: 100, height: 40) }
@MainActor final class Manager {
    var floeBarPanel: Panel? = Panel()
    var captureTask: Task<Void, Never>?
    var captureGeneration = UUID()
    var imageDisplayID: UInt32?, requestedDisplayID: UInt32?
    var windowImage: CGImage?
    var colorInfo: MenuBarAverageColorInfo?
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func wait(_ id: Int) async { while ScreenCapture.pending[id] == nil { await Task.yield() } }
    @MainActor static func main() async {
        Task.detached { try await Task.sleep(for: .seconds(10)); exit(124) }
        let manager = Manager()
        manager.updateWindowImage(for: NSScreen(displayID: 1))
        await wait(0)
        let old = manager.captureTask!
        manager.invalidate()
        manager.floeBarPanel?.screen = NSScreen(displayID: 2)
        manager.updateWindowImage(for: NSScreen(displayID: 2))
        await wait(1)
        ScreenCapture.finish(0, id: 1); await old.value
        precondition(manager.captureTask != nil && manager.colorInfo == nil)
        let current = manager.captureTask!
        ScreenCapture.finish(1, id: 2); await current.value
        precondition(manager.colorInfo?.color == 2 && manager.captureTask == nil)
        manager.updateColorInfo(with: CGRect(x: 0, y: 0, width: 200, height: 40), screen: NSScreen(displayID: 2))
        precondition(manager.colorInfo?.color == 2) // 面板宽度不小于屏幕时不除以零。
        manager.updateWindowImage(for: NSScreen(displayID: 2))
        await wait(2)
        let closed = manager.captureTask!
        manager.floeBarPanel?.isVisible = false
        manager.invalidate()
        ScreenCapture.finish(2, id: 3); await closed.value
        precondition(manager.windowImage == nil && manager.colorInfo == nil)
        print("PASS: production color generations discard old-screen/closed-panel captures, preserve newer task ownership and handle full-width color sampling")
    }
}
"""#
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
let executable = directory.appendingPathComponent("checks").path
try run(["swiftc", "-parse-as-library", file.path, "-o", executable])
try run([executable])
