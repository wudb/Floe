import Foundation

// 从生产桥接层提取字典解析，覆盖各屏独立 Space、共享 Space 与未知格式。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Bridging/Bridging.swift"), encoding: .utf8)
let start = source.range(of: "    static func fullscreenDisplayStates(from ")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end])
let fixture = #"""
import Foundation
enum CGSSpaceType: UInt32 { case user = 0, system = 2, fullscreen = 4 }
enum Bridging {
__METHOD__
}
let states = Bridging.fullscreenDisplayStates(from: [
    ["Display Identifier": "laptop", "Current Space": ["type": NSNumber(value: 0)]],
    ["Display Identifier": "external", "Current Space": ["type": NSNumber(value: 4)]],
    ["Display Identifier": "Main", "Current Space": ["type": 4]],
    ["Display Identifier": "unknown", "Current Space": ["type": "unexpected"]],
    ["Display Identifier": "invalidType", "Current Space": ["type": 999]],
    ["Display Identifier": "missing"],
    ["Current Space": ["type": 4]]
], mainDisplayKey: "primary")
precondition(states == ["laptop": false, "external": true, "primary": true])
precondition(Bridging.fullscreenDisplayStates(from: [["Display Identifier": "Main", "Current Space": ["type": 4]]], mainDisplayKey: nil).isEmpty)
precondition(Bridging.fullscreenDisplayStates(from: [], mainDisplayKey: "primary").isEmpty)
print("PASS: production per-display Space parsing isolates fullscreen states, maps shared Main only to primary and omits unknown metadata")
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-spaces-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__METHOD__", with: method).write(to: file, atomically: true, encoding: .utf8)
let runner = Process(); runner.executableURL = URL(fileURLWithPath: "/usr/bin/env"); runner.arguments = ["swift", file.path]
try runner.run(); runner.waitUntilExit(); exit(runner.terminationStatus)
