import Foundation

// 编译生产名称回退和检索过滤方法，不依赖系统窗口或用户权限。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
func property(_ file: String, _ marker: String, indent: String) throws -> String {
    let source = try String(contentsOf: repo.appendingPathComponent(file), encoding: .utf8)
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n" + indent + "}", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private var", with: "var")
}
let name = try property("Floe/MenuBar/MenuBarItems/MenuBarItemAXDiscovery.swift", "        var displayName:", indent: "        ")
let matches = try property("Floe/UI/MenuBarSearchPanel.swift", "    private var matches:", indent: "    ")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-search-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = """
import Foundation
struct Item {
    let title: String?, identifier: String?
    let appName: String
    \(name)
}
struct Row { let name: String, detail: String }
struct Search {
    var query = ""
    var rows: [Row] = []
    \(matches)
}
precondition(Item(title: "Item-0", identifier: nil, appName: "SwiftBar").displayName == "SwiftBar")
precondition(Item(title: " ", identifier: "wifi", appName: "Control Center").displayName == "wifi")
precondition(Item(title: "Battery", identifier: "wifi", appName: "Control Center").displayName == "Battery")
precondition(Item(title: nil, identifier: "Item-2", appName: "App").displayName == "App")
var search = Search(rows: [Row(name: "Battery", detail: "com.apple.controlcenter"), Row(name: "微信", detail: "com.tencent")])
precondition(search.matches.count == 2)
search.query = "BAT"; precondition(search.matches.map(\\.name) == ["Battery"])
search.query = "tencent"; precondition(search.matches.map(\\.name) == ["微信"])
search.query = "微"; precondition(search.matches.count == 1)
search.query = "missing"; precondition(search.matches.isEmpty)
search.query = " "; precondition(search.matches.count == 2)
print("PASS: production search filters names/bundles, handles empty/changed queries and avoids AX placeholder names")
"""
let file = directory.appendingPathComponent("main.swift")
try fixture.write(to: file, atomically: true, encoding: .utf8)
let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = ["swift", file.path]
try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
