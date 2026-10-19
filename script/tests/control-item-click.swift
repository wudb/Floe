import Foundation
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/ControlItem/ControlItem.swift"), encoding: .utf8)
let start = source.range(of: "    @objc private func performAction()")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end]).replacingOccurrences(of: "@objc private func", with: "func").replacingOccurrences(of: "NSApp", with: "fixtureApp")
let fixture = #"""
import Cocoa
struct Event { var type = NSEvent.EventType.leftMouseUp; var modifierFlags = NSEvent.ModifierFlags() }
final class Application { var currentEvent: Event? = Event() }
let fixtureApp = Application()
final class Section { var isEnabled = true; var toggles = 0; func toggle() { toggles += 1 } }
final class Advanced { var canToggleAlwaysHiddenSection = true }
final class Settings { let advancedSettingsManager = Advanced() }
final class Bar {
    enum Name { case alwaysHidden }
    let always = Section()
    func section(withName name: Name) -> Section? { always }
}
final class AppState { let settingsManager = Settings(); let menuBarManager = Bar() }
final class Status { var menus = 0; func showMenu(_ value: Int) { menus += 1 } }
final class Control {
    var appState: AppState? = AppState()
    let section: Section? = Section()
    let statusItem = Status()
    func createMenu(with appState: AppState) -> Int { 0 }
__METHOD__
}
let control = Control()
control.performAction()
precondition(control.section!.toggles == 1 && control.appState!.menuBarManager.always.toggles == 0, "normal click must reveal Hidden, not Always Hidden")
fixtureApp.currentEvent!.modifierFlags = .option
control.performAction()
precondition(control.section!.toggles == 1 && control.appState!.menuBarManager.always.toggles == 1)
fixtureApp.currentEvent!.modifierFlags = .control
control.performAction()
precondition(control.statusItem.menus == 1 && control.section!.toggles == 1)
print("PASS: production normal click controls Hidden, Option controls Always Hidden, Control opens the context menu")
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-click-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let file = directory.appendingPathComponent("Checks.swift")
try fixture.replacingOccurrences(of: "__METHOD__", with: method).write(to: file, atomically: true, encoding: .utf8)
let runner = Process(); runner.executableURL = URL(fileURLWithPath: "/usr/bin/swift"); runner.arguments = [file.path]
try runner.run(); runner.waitUntilExit(); exit(runner.terminationStatus)
