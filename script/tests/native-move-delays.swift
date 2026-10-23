import Foundation

// 编译原生事件回执的生产方法；延迟由内存 EventTap 模拟，不发送系统输入。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/MenuBarItems/MenuBarItemManager.swift"), encoding: .utf8)
func method(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end]).replacingOccurrences(of: "private func", with: "func")
}
let methods = ["    private func postEventAndWaitToReceive(", "    private func scrombleEvent(\n        _ event: CGEvent,\n        from firstLocation: EventTap.Location,\n        to secondLocation: EventTap.Location,\n        item:"].map(method).joined(separator: "\n")
let fixture = #"""
import Cocoa
struct MenuBarItem { let logString = "fixture" }
struct EventError: Error {
    enum Code { case eventCreationFailure, eventOperationTimeout }
    let code: Code
    let item: MenuBarItem
}
struct Log { func debug(_ text: String) {}; func error(_ text: String) {} }
enum Logger { static let itemManager = Log() }
extension CGEventType { var logString: String { "event" } }
extension CGEventField { static let menuBarItemEventFields: [CGEventField] = [.eventSourceUserData] }
@MainActor final class EventTap {
    enum Location: Equatable { case first, second; var logString: String { "location" } }
    @MainActor struct Proxy {
        let tap: EventTap
        var label: String { tap.label }
        var isEnabled: Bool { tap.isEnabled }
        func disable() { tap.disable() }
        func enable() { tap.enable() }
    }
    static var taps = [EventTap]()
    static var deliveryDelay: Duration = .milliseconds(5)
    static var dropEvents = false
    let label: String, location: Location, types: [CGEventType]
    let callback: (Proxy, CGEventType, CGEvent) -> Unmanaged<CGEvent>?
    var isEnabled = false, generation = 0
    init(label: String = "fixture", options: CGEventTapOptions, location: Location, place: CGEventTapPlacement,
         types: [CGEventType], callback: @escaping (Proxy, CGEventType, CGEvent) -> Unmanaged<CGEvent>?) {
        self.label = label; self.location = location; self.types = types; self.callback = callback
        Self.taps.append(self)
    }
    func enable() { generation += 1; isEnabled = true }
    func disable() { generation += 1; isEnabled = false }
    func enable(timeout: Duration, onTimeout: @escaping () -> Void) {
        enable()
        let current = generation
        Task {
            try await Task.sleep(for: timeout)
            if generation == current && isEnabled { onTimeout() }
        }
    }
    static func deliver(_ event: CGEvent, to location: Location) {
        guard !dropEvents else { return }
        for tap in taps where tap.isEnabled && tap.location == location && tap.types.contains(event.type) {
            let current = tap.generation, delay = deliveryDelay
            Task {
                try await Task.sleep(for: delay)
                if tap.isEnabled && tap.generation == current { _ = tap.callback(Proxy(tap: tap), event.type, event) }
            }
        }
    }
}
@MainActor final class Manager {
    func eventsMatch(_ events: [CGEvent], by fields: [CGEventField]) -> Bool {
        Set(events.map { event in fields.map { event.getIntegerValueField($0) } }).count == 1
    }
    func postEvent(_ event: CGEvent, to location: EventTap.Location) { EventTap.deliver(event, to: location) }
    __PRODUCTION__
}
@main struct Checks {
    @MainActor static func main() async throws {
        Task.detached { try await Task.sleep(for: .seconds(8)); exit(124) }
        let manager = Manager(), item = MenuBarItem()
        let event = CGEvent(source: nil)!
        event.type = .leftMouseUp
        event.setIntegerValueField(.eventSourceUserData, value: 1234)
        for delay: Duration in [.milliseconds(5), .milliseconds(80)] {
            EventTap.deliveryDelay = delay
            try await manager.postEventAndWaitToReceive(event, to: .second, item: item)
            precondition(EventTap.taps.allSatisfy { !$0.isEnabled })
            EventTap.taps.removeAll()
            try await manager.scrombleEvent(event, from: .first, to: .second, item: item)
            precondition(EventTap.taps.allSatisfy { !$0.isEnabled })
            EventTap.taps.removeAll()
        }
        // 真正丢失回执仍需有界失败并清理两个 tap，迟到投递不能再次恢复 continuation。
        EventTap.deliveryDelay = .milliseconds(400)
        let start = ContinuousClock.now
        do {
            try await manager.scrombleEvent(event, from: .first, to: .second, item: item)
            preconditionFailure("missing acknowledgement must time out")
        } catch let error as EventError { precondition(error.code == .eventOperationTimeout) }
        precondition(start.duration(to: .now) < .seconds(1))
        precondition(EventTap.taps.allSatisfy { !$0.isEnabled })
        try await Task.sleep(for: .milliseconds(450))
        precondition(EventTap.taps.allSatisfy { !$0.isEnabled })
        print("PASS: native event acknowledgements tolerate delayed delivery, return on receipt, and clean up on bounded timeout/late events")
    }
}
"""#
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-native-delays-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let file = directory.appendingPathComponent("Checks.swift"), binary = directory.appendingPathComponent("checks")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
func run(_ arguments: [String]) throws {
    let process = Process(); process.executableURL = URL(fileURLWithPath: "/usr/bin/env"); process.arguments = arguments
    try process.run(); process.waitUntilExit(); precondition(process.terminationStatus == 0)
}
try run(["swiftc", "-parse-as-library", file.path, "-o", binary.path])
try run([binary.path])
