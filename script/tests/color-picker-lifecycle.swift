import Foundation

// 编译真实 SwiftUI/AppKit 选择器，通过 NSColorWell 的 target/action 验证用户写入。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = repo.appendingPathComponent("Floe/UI/Pickers/CustomColorPicker/CustomColorPicker.swift")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-color-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import AppKit
import SwiftUI
@main struct ColorTests {
    @MainActor static func main() {
        _ = NSApplication.shared
        var first = NSColor.red.cgColor, second = NSColor.blue.cgColor
        var firstWrites = 0, secondWrites = 0
        let original = Binding<CGColor>(get: { first }, set: { first = $0; firstWrites += 1 })
        let replacement = Binding<CGColor>(get: { second }, set: { second = $0; secondWrites += 1 })
        let coordinator = CustomColorPicker.Coordinator(selection: original, supportsOpacity: false, mode: .wheel)
        let well = NSColorWell()
        coordinator.configure(with: well)
        well.color = .green
        RunLoop.main.run(until: Date().addingTimeInterval(0.02))
        precondition(first == NSColor.red.cgColor && firstWrites == 0, "initial/programmatic color must not write back")
        NSApp.sendAction(well.action!, to: well.target, from: well)
        precondition(first == well.color.cgColor && firstWrites == 1)
        coordinator.update(selection: replacement, supportsOpacity: true, mode: .RGB)
        well.color = .yellow
        NSApp.sendAction(well.action!, to: well.target, from: well)
        precondition(second == well.color.cgColor && secondWrites == 1 && firstWrites == 1)
        precondition(coordinator.supportsOpacity && coordinator.mode == .RGB)
        coordinator.dismantle(well)
        precondition(well.target == nil && well.action == nil)
        well.color = .black
        RunLoop.main.run(until: Date().addingTimeInterval(0.02))
        precondition(firstWrites == 1 && secondWrites == 1)
        print("PASS: native color well ignores initialization/programmatic updates, writes user action to current binding, releases target on teardown")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env")
compiler.arguments = ["swiftc", source.path, file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
