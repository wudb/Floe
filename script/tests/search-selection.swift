import Foundation

// 编译生产列表选择算法，验证过滤、刷新、边界和空列表，不依赖真实 AX 权限。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/MenuBarSearchPanel.swift"), encoding: .utf8)
let start = source.range(of: "enum MenuBarListSelection {")!.lowerBound
let production = String(source[start...])
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-selection-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let checks = #"""
let ids = ["one", "two", "three"]
precondition(MenuBarListSelection.moving(nil, in: ids, by: 1) == "one")
precondition(MenuBarListSelection.moving(nil, in: ids, by: -1) == "three")
precondition(MenuBarListSelection.moving("one", in: ids, by: 1) == "two")
precondition(MenuBarListSelection.moving("three", in: ids, by: 1) == "three")
precondition(MenuBarListSelection.moving("one", in: ids, by: -1) == "one")
precondition(MenuBarListSelection.moving("two", in: ["two"], by: 1) == "two")
precondition(MenuBarListSelection.moving("removed", in: ids, by: 1) == "one")
precondition(MenuBarListSelection.moving("one", in: [], by: 1) == nil)
print("PASS: production search selection handles navigation, boundaries, removed results, filtering and empty lists")
"""#
let file = directory.appendingPathComponent("main.swift")
try (production + "\n" + checks).write(to: file, atomically: true, encoding: .utf8)
let runner = Process(); runner.executableURL = URL(fileURLWithPath: "/usr/bin/env"); runner.arguments = ["swift", file.path]
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
