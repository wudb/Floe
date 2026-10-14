//
//  image-cache-retention.swift
//  Floe
//

import Foundation

// 编译生产图片捕获/发布方法，用受控截图验证取消后不继续消耗资源。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemImageCache.swift"), encoding: .utf8)
let start = source.range(of: "    func createImages(")!.lowerBound
let end = source.range(of: "    /// Updates the cache for the given sections, if", range: start..<source.endIndex)!.lowerBound
let method = String(source[start..<end])
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-capture-cancel-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""

import Foundation
import CoreGraphics
struct MenuBarItemInfo: Hashable { let id: Int }
typealias CGWindowID = UInt32
struct CGWindowImageOption: OptionSet {
    let rawValue: Int
    static let boundsIgnoreFraming = Self(rawValue: 1)
    static let bestResolution = Self(rawValue: 2)
}
@MainActor final class CGImage {
    static var crops = 0
    var width = 20
    func cropping(to: CGRect) -> CGImage? { Self.crops += 1; return CGImage() }
}
@MainActor final class NSScreen: Equatable {
    static var main: NSScreen? = NSScreen()
    let backingScaleFactor: CGFloat = 1
    let displayID: UInt32 = 1
    func getMenuBarHeight() -> CGFloat { 20 }
    nonisolated static func == (lhs: NSScreen, rhs: NSScreen) -> Bool { lhs === rhs }
}
@MainActor enum NSStatusBar { static let system = Bar(); struct Bar { let thickness: CGFloat = 20 } }
func CGDisplayBounds(_ id: UInt32) -> CGRect { CGRect(x: 0, y: 0, width: 100, height: 100) }
enum Bridging { static func getWindowFrame(for id: UInt32) -> CGRect? { CGRect(x: Int(id - 1) * 10, y: 0, width: 10, height: 20) } }
enum MenuBarSection { enum Name: Hashable { case hidden; var logString: String { "hidden" } } }
struct Item { let windowID: UInt32; var info: MenuBarItemInfo { .init(id: Int(windowID)) } }
struct ItemCache {
    var allItems = [Item(windowID: 1), Item(windowID: 2)]
    subscript(_ section: MenuBarSection.Name) -> [Item] { allItems }
}
@MainActor final class AppState { var itemManager = Manager(); struct Manager { var itemCache = ItemCache() } }
struct Log { func warning(_ text: String) {} }
enum Logger { static let imageCache = Log() }
@MainActor enum ScreenCapture {
    static var compositeCalls = 0
    static var individualCalls = 0
    static var cancelComposite = false
    static var cancelIndividual = false
    static var returnCancelledImage = false
    static func captureWindows(_ ids: [UInt32], option: CGWindowImageOption) async -> CGImage? {
        compositeCalls += 1
        if cancelComposite { withUnsafeCurrentTask { $0?.cancel() }; return returnCancelledImage ? CGImage() : nil }
        return nil
    }
    static func captureWindow(_ id: UInt32, option: CGWindowImageOption) async -> CGImage? {
        individualCalls += 1
        if cancelIndividual { withUnsafeCurrentTask { $0?.cancel() } }
        return CGImage()
    }
}
@MainActor final class Cache {
    var appState: AppState? = AppState()
    var isUpdating = false
    var images: [MenuBarItemInfo: CGImage] = [:]
    var screen: NSScreen?
    var menuBarHeight: CGFloat?
    __METHOD__
}
@main struct Checks {
    @MainActor static func main() async {
        let cache = Cache()
        let screen = NSScreen.main!
        let cancelled = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            return await cache.createImages(for: .hidden, screen: screen)
        }
        let empty = await cancelled.value
        precondition(empty.isEmpty && ScreenCapture.compositeCalls == 0)
        ScreenCapture.cancelComposite = true
        let composite = Task { await cache.updateCacheWithoutChecks(sections: [.hidden]) }
        await composite.value
        precondition(cache.images.isEmpty && ScreenCapture.individualCalls == 0 && CGImage.crops == 0)
        ScreenCapture.returnCancelledImage = true
        let lateImage = Task { await cache.updateCacheWithoutChecks(sections: [.hidden]) }
        await lateImage.value
        precondition(cache.images.isEmpty && ScreenCapture.individualCalls == 0 && CGImage.crops == 0)
        ScreenCapture.cancelComposite = false
        ScreenCapture.cancelIndividual = true
        let individual = Task { await cache.updateCacheWithoutChecks(sections: [.hidden]) }
        await individual.value
        precondition(cache.images.isEmpty && ScreenCapture.individualCalls == 1 && CGImage.crops == 0)
        precondition(!cache.isUpdating)
        ScreenCapture.cancelIndividual = false
        await cache.updateCacheWithoutChecks(sections: [.hidden])
        precondition(cache.images.count == 2 && CGImage.crops == 2)
        print("PASS: cancelled image batches skip fallback/cropping/publication; normal captures remain usable")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__METHOD__", with: method).write(to: fixturePath, atomically: true, encoding: .utf8)
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
