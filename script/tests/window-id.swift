//
//  window-id.swift
//  Floe
//

import Foundation

// 编译真实 windowID getter，直接复测 jordanbaird/Ice#925 评论中的 UInt32.max + 1。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/ControlItem/ControlItem.swift"), encoding: .utf8)
let start = source.range(of: "    var windowID: CGWindowID?")!.lowerBound
let end = source.range(of: "\n    /// A Boolean value", range: start..<source.endIndex)!.lowerBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-window-id-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
typealias CGWindowID = UInt32
struct Window { let windowNumber: Int }
struct ControlItem {
    let window: Window?
    __GETTER__
}
@main struct Checks {
    static func main() {
        precondition(ControlItem(window: nil).windowID == nil)
        for value in [-1, Int(UInt32.max) + 1, Int.max] {
            precondition(ControlItem(window: Window(windowNumber: value)).windowID == nil)
        }
        for value in [0, 42, Int(UInt32.max)] {
            precondition(ControlItem(window: Window(windowNumber: value)).windowID == UInt32(value))
        }
        print("PASS: production windowID handles absent, negative, overflow and valid window numbers")
        print("PASS: jordanbaird/Ice#925 value 4294967296 becomes nil instead of trapping")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__GETTER__", with: String(source[start..<end])).write(to: fixturePath, atomically: true, encoding: .utf8)
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
