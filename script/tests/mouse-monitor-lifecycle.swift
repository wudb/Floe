import Foundation

// 编译生产监听启停，验证关闭悬停后没有高频 mouseMoved 订阅。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Events/EventManager.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let methods = [method("    func startAll()"), method("    func stopAll()"), method("    private func updateMouseMovedMonitor(")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-mouse-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import Foundation
final class Monitor { var active = false; func start() { active = true }; func stop() { active = false } }
final class Settings { var showOnHover = false }
final class SettingsManager { let generalSettingsManager = Settings() }
final class AppState { let settingsManager = SettingsManager() }
final class Manager {
    var appState: AppState? = AppState(), isMonitoring = false
    let mouseMovedMonitor = Monitor(), click = Monitor(), drag = Monitor(), scroll = Monitor()
    var allMonitors: [Monitor] { [mouseMovedMonitor, click, drag, scroll] }
    var hoverTask: Task<Void, Never>?, hoverIntent: Bool?
    func cancelDelayedInteractions() { hoverTask?.cancel(); hoverTask = nil; hoverIntent = nil }
    __PRODUCTION__
}
let manager = Manager()
manager.startAll()
precondition(!manager.mouseMovedMonitor.active && manager.click.active && manager.drag.active && manager.scroll.active)
manager.updateMouseMovedMonitor(showOnHover: true); precondition(manager.mouseMovedMonitor.active)
manager.hoverIntent = true
manager.updateMouseMovedMonitor(showOnHover: false)
precondition(!manager.mouseMovedMonitor.active && manager.hoverIntent == nil && manager.click.active)
manager.appState!.settingsManager.generalSettingsManager.showOnHover = true
manager.startAll(); precondition(manager.mouseMovedMonitor.active)
manager.stopAll(); precondition(manager.allMonitors.allSatisfy { !$0.active })
manager.updateMouseMovedMonitor(showOnHover: true); precondition(!manager.mouseMovedMonitor.active)
manager.startAll(); precondition(manager.mouseMovedMonitor.active)
print("PASS: production monitors unsubscribe mouse movement when hover is off, keep click/drag/scroll, handle dynamic settings and stopped state")
"""#
let file = directory.appendingPathComponent("main.swift")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
let runner = Process(); runner.executableURL = URL(fileURLWithPath: "/usr/bin/env"); runner.arguments = ["swift", file.path]
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
