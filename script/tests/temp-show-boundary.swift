//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift"), encoding: .utf8)
let start = source.range(of: "    private func itemsAfterHiddenControlItem(")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-temp-show-boundary-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
struct MenuBarItem: Equatable {
    enum Info { case hiddenControlItem, icon, alwaysHidden }
    let info: Info
    let id: Int
}
struct Manager {
    __PRODUCTION__
}
@main struct Checks {
    static func main() {
        let manager = Manager()
        let hidden = MenuBarItem(info: .hiddenControlItem, id: 10)
        let icon = MenuBarItem(info: .icon, id: 11)
        let alwaysHidden = MenuBarItem(info: .alwaysHidden, id: 12)
        precondition(manager.itemsAfterHiddenControlItem(in: []) == nil)
        precondition(manager.itemsAfterHiddenControlItem(in: [icon, alwaysHidden]) == nil)
        precondition(manager.itemsAfterHiddenControlItem(in: [hidden]) == [])
        precondition(manager.itemsAfterHiddenControlItem(in: [alwaysHidden, hidden]) == [])
        precondition(manager.itemsAfterHiddenControlItem(in: [hidden, icon]) == [icon])
        precondition(manager.itemsAfterHiddenControlItem(in: [alwaysHidden, hidden, icon]) == [icon])
        for count in 0...200 {
            let icons = (0..<count).map { MenuBarItem(info: .icon, id: $0) }
            precondition(manager.itemsAfterHiddenControlItem(in: icons) == nil)
            precondition(manager.itemsAfterHiddenControlItem(in: icons + [hidden] + icons) == icons)
        }
        print("PASS: production temporary-show boundary tolerates absent divider and preserves only items after actual divider")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")).write(to: fixturePath, atomically: true, encoding: .utf8)
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
