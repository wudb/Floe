import Foundation

// 编译生产落点判定，验证跨分区进入目标组但排序错误时不会提前结束重试。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-drop-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = """
enum MenuBarItemAXDiscovery { enum SectionKind: Hashable { case visible, hidden, alwaysHidden } }
struct RowItem { let id: String }
struct Pane {
    var sections: [MenuBarItemAXDiscovery.SectionKind: [RowItem]] = [:]
    \(method("    private func isImmediatelyBefore("))
    \(method("    private func hasLanded("))
}
var pane = Pane()
for kind in [MenuBarItemAXDiscovery.SectionKind.visible, .hidden, .alwaysHidden] {
    for (ids, expected) in [(["a", "b"], true), (["b", "a"], false), (["a", "c", "b"], false), (["b"], false), (["a"], false), ([], false)] {
        pane.sections = [kind: ids.map { RowItem(id: $0) }]
        precondition(pane.hasLanded(itemID: "a", targetID: "b", toKind: kind) == expected)
    }
    pane.sections = [.visible: [RowItem(id: "a"), RowItem(id: "b")]]
    if kind != .visible { precondition(!pane.hasLanded(itemID: "a", targetID: "b", toKind: kind)) }
}
print("layout-drop-order PASS")
"""
let file = directory.appendingPathComponent("main.swift")
try fixture.write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    precondition(process.terminationStatus == 0)
}
let executable = directory.appendingPathComponent("checks").path
try run(["swiftc", file.path, "-o", executable])
try run([executable])
