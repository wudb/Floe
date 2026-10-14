//
//  window-id.swift
//  Floe
//

import Foundation

// 浮栏的旧转换分支已移除；编译存活的生产 getter，复测原报告的溢出值。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/ControlItem/ControlItem.swift"), encoding: .utf8)
let start = source.range(of: "    var windowID: CGWindowID?")!.lowerBound
let end = source.range(of: "\n    /// A Boolean value", range: start..<source.endIndex)!.lowerBound
let signaturesData = try Data(contentsOf: repo.appendingPathComponent("docs/c1-evidence/window-id-crash-signatures.json"))
let signatures = try JSONSerialization.jsonObject(with: signaturesData) as! [String: Any]
let reports = signatures["reports"] as! [[String: Any]]
let reportValues = reports.map { "(\($0["number"] as! Int), \($0["window_number"] as! Int))" }.joined(separator: ", ")
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
        for (number, value) in [__REPORT_VALUES__] {
            precondition(ControlItem(window: Window(windowNumber: value)).windowID == nil)
            print("PASS: jordanbaird/Ice#\(number) exact crash value is rejected by the production conversion")
        }
        for value in [0, 42, Int(UInt32.max)] {
        }
        print("PASS: production windowID handles absent, negative, overflow and valid window numbers")
        print("PASS: jordanbaird/Ice#925 value 4294967296 becomes nil instead of trapping")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__GETTER__", with: String(source[start..<end])).replacingOccurrences(of: "__REPORT_VALUES__", with: reportValues).write(to: fixturePath, atomically: true, encoding: .utf8)
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
