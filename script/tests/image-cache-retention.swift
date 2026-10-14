//
//  image-cache-retention.swift
//  Floe
//

import Foundation

// 抽取真实清理方法，验证浮栏隐藏时的缓存淘汰，不调用截图或 WindowServer。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemImageCache.swift"), encoding: .utf8)
let start = source.range(of: "    private func discardRemovedImages()")!.lowerBound
let end = source.range(of: "\n    /// Returns", range: start..<source.endIndex)!.lowerBound
let method = String(source[start..<end])
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-image-cache-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation

struct Item { let info: Int }
struct ItemCache { var allItems: [Item] = [] }
struct ItemManager { var itemCache = ItemCache() }
struct AppState { var itemManager = ItemManager() }
final class Image {}
@MainActor final class Cache {
    var appState: AppState? = AppState()
    var updates = 0
    var images: [Int: Image] = [:] { didSet { updates += 1 } }
    func prune() { discardRemovedImages() }
    __METHOD__
}
@main struct Checks {
    @MainActor static func main() {
        let cache = Cache()
        cache.images = [1: Image(), 2: Image()]
        weak var removed = cache.images[1]
        weak var retained = cache.images[2]
        cache.appState?.itemManager.itemCache.allItems = [Item(info: 2)]
        cache.prune()
        precondition(removed == nil && retained != nil && cache.images.count == 1)
        print("PASS: removed items release their images; live items keep cached icons")
        let updates = cache.updates
        cache.prune()
        precondition(cache.updates == updates)
        print("PASS: unchanged membership does not republish the cache")
        for id in 3..<203 {
            cache.images[id] = Image()
            cache.appState?.itemManager.itemCache.allItems = [Item(info: id)]
            cache.prune()
            precondition(cache.images.count == 1)
        }
        precondition(retained == nil)
        print("PASS: repeated status-item recreation cannot grow the retained cache")
        cache.appState?.itemManager.itemCache.allItems = []
        cache.prune()
        precondition(cache.images.isEmpty)
        print("PASS: empty discovery releases all stale icons")
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
