//
//  menu-bar-ax-probe.swift
//  Floe
//

import Foundation

// 编译实际探测实现，用受控 AX 服务确认命中测试和属性读取均发生在主线程。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/Appearance/MenuBarAXProbe.swift"), encoding: .utf8)
    .replacingOccurrences(of: "import AXSwift\n", with: "")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-ax-probe-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }

let fixtures = #"""
import Cocoa

enum FixtureError: Error { case unavailable }
struct FixtureElement {
    let x: Float
    func attribute<T>(_ name: String) throws -> T {
        precondition(Thread.isMainThread, "AX attributes must be read on the main thread")
        if name == "AXRole" {
            return (x == 0 ? "AXMenuBar" : "AXMenuBarItem") as! T
        }
        precondition(x != 0, "The menu bar does not need a frame query")
        guard x != 2 else { throw FixtureError.unavailable }
        return CGRect(x: 40, y: 0, width: 24, height: 24) as! T
    }
    func pid() throws -> pid_t {
        precondition(Thread.isMainThread, "The AX element must stay on the main thread")
        return 42
    }
}
struct FixtureSystemWideElement {
    func elementAtPosition(_ x: Float, _ y: Float) throws -> FixtureElement {
        precondition(Thread.isMainThread, "Hit testing can enter the local NSMenu")
        guard x >= 0 else { throw FixtureError.unavailable }
        return FixtureElement(x: x)
    }
}
let systemWideElement = FixtureSystemWideElement()

@main
struct ProbeTests {
    static func checkSnapshots() {
        precondition(MenuBarAXProbe.snapshot(atX: -1, y: 16) == nil)
        let menu = MenuBarAXProbe.snapshot(atX: 0, y: 16)!
        precondition(menu.role == "AXMenuBar" && menu.pid == 42 && menu.frame == nil)
        let item = MenuBarAXProbe.snapshot(atX: 1, y: 16)!
        precondition(item.role == "AXMenuBarItem" && item.pid == 42)
        precondition(item.frame == CGRect(x: 40, y: 0, width: 24, height: 24))
        let missingFrame = MenuBarAXProbe.snapshot(atX: 2, y: 16)!
        precondition(missingFrame.pid == 42 && missingFrame.frame == nil)
    }
    static func main() {
        precondition(Thread.isMainThread)
        checkSnapshots()
        print("PASS: main-thread calls, missing elements/frames and value snapshots")
        var completed = false
        DispatchQueue.global(qos: .userInitiated).async {
            precondition(!Thread.isMainThread)
            for _ in 0..<25 { checkSnapshots() }
            DispatchQueue.main.async { completed = true }
        }
        let deadline = Date().addingTimeInterval(10)
        while !completed && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.01))
        }
        precondition(completed, "Background probes must finish without deadlocking")
        print("PASS: background scans marshal all AX access to the main thread without deadlocking")
    }
}
"""#

let generated = directory.appendingPathComponent("ProbeTests.swift")
try (source + "\n" + fixtures).write(to: generated, atomically: true, encoding: .utf8)
let binary = directory.appendingPathComponent("ProbeTests")
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/swiftc")
compiler.arguments = ["-parse-as-library", generated.path, "-o", binary.path]
try compiler.run()
compiler.waitUntilExit()
guard compiler.terminationStatus == 0 else { exit(compiler.terminationStatus) }
let runner = Process()
runner.executableURL = binary
try runner.run()
runner.waitUntilExit()
exit(runner.terminationStatus)
