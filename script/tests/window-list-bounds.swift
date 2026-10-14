//
//  window-id.swift
//  Floe
//

import Foundation

// 验证事件投递的有界等待。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Bridging/Bridging.swift"), encoding: .utf8)
let start = source.range(of: "    private static func getWindowCount()")!.lowerBound
let end = source.range(of: "\n    private static func getOnScreenMenuBarWindowList()", range: start..<source.endIndex)!.lowerBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-window-list-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
// 编译生产 CGS 数量/列表方法，模拟非原子查询和私有 API 异常输出。
let fixture = #"""
import Foundation
typealias CGWindowID = UInt32
enum Result { case success, failure; var logString: String { String(describing: self) } }
struct Log { func error(_ message: String) {} }
enum Logger { static let bridging = Log() }
enum Stub {
    static var count: Int32 = 3
    static var returned: Int32 = 3
    static var countResult = Result.success
    static var listResult = Result.success
    static var listCalls = 0
}
func CGSMainConnectionID() -> Int { 0 }
func CGSGetWindowCount(_ connection: Int, _ owner: Int, _ count: inout Int32) -> Result {
    count = Stub.count; return Stub.countResult
}
func CGSGetOnScreenWindowCount(_ connection: Int, _ owner: Int, _ count: inout Int32) -> Result {
    CGSGetWindowCount(connection, owner, &count)
}
func fill(_ capacity: Int32, _ list: inout [UInt32], _ count: inout Int32) -> Result {
    precondition(capacity == Int32(list.count) && capacity > 0)
    Stub.listCalls += 1
    for index in list.indices { list[index] = UInt32(index + 1) }
    count = Stub.returned
    return Stub.listResult
}
func CGSGetWindowList(_ connection: Int, _ owner: Int, _ capacity: Int32, _ list: inout [UInt32], _ count: inout Int32) -> Result { fill(capacity, &list, &count) }
func CGSGetOnScreenWindowList(_ connection: Int, _ owner: Int, _ capacity: Int32, _ list: inout [UInt32], _ count: inout Int32) -> Result { fill(capacity, &list, &count) }
func CGSGetProcessMenuBarWindowList(_ connection: Int, _ owner: Int, _ capacity: Int32, _ list: inout [UInt32], _ count: inout Int32) -> Result { fill(capacity, &list, &count) }
enum Bridging {
    __PRODUCTION__
}
@main struct Checks {
    static func main() {
        let lists = [Bridging.getWindowList, Bridging.getOnScreenWindowList, Bridging.getMenuBarWindowList]
        for list in lists {
            for count: Int32 in [-1, Int32.min, 0] {
                Stub.count = count; Stub.listCalls = 0
                precondition(list().isEmpty && Stub.listCalls == 0)
            }
            Stub.count = 3; Stub.countResult = .failure; Stub.listCalls = 0
            precondition(list().isEmpty && Stub.listCalls == 0, "failed count must not be consumed")
            Stub.countResult = .success
            for count: Int32 in [-1, Int32.min, 4, Int32.max] {
                Stub.returned = count
                precondition(list().isEmpty, "invalid real count must not trap or vend uninitialized IDs")
            }
            for count: Int32 in [0, 1, 3] {
                Stub.returned = count
                precondition(list() == Array([UInt32(1), 2, 3].prefix(Int(count))))
            }
            Stub.listResult = .failure
            precondition(list().isEmpty)
            Stub.listResult = .success
        }
        print("PASS: three production CGS lists reject failed/negative counts and out-of-bounds results; valid prefixes preserved")
    }
}
"""#
let fixturePath = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: String(source[start..<end]).replacingOccurrences(of: "private static", with: "static")).write(to: fixturePath, atomically: true, encoding: .utf8)
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
