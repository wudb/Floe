import Foundation

// 编译真实外观枚举、管理器和窗口桥接，用内存偏好验证持久化及多个窗口同步。
// 所有窗口只离屏渲染，不修改用户偏好、系统外观或正在运行的 Floe。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-appearance-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let files = [
    "Floe/Utilities/AppAppearance.swift",
    "Floe/Utilities/SystemAppearance.swift",
    "Floe/UI/ViewModifiers/ReadWindow.swift",
    "Floe/Settings/SettingsManagers/AppAppearanceManager.swift",
    "Floe/UI/Pickers/AppAppearancePicker.swift",
]
let production = try files.map { try String(contentsOf: repo.appendingPathComponent($0), encoding: .utf8) }.joined(separator: "\n")
let fixture = #"""
enum Defaults {
    enum Key { case appAppearance }
    static var saved: String?
    static func string(forKey key: Key) -> String? { saved }
    static func set(_ value: String, forKey key: Key) { saved = value }
}
@MainActor final class SchemeCapture {
    var value: ColorScheme?
}
struct SchemeProbe: View {
    @Environment(\.colorScheme) private var scheme
    let capture: SchemeCapture
    var body: some View {
        Color.clear.onChange(of: scheme, initial: true) { _, value in capture.value = value }
    }
}
struct AppearanceSample: View {
    @ObservedObject private var manager = AppAppearanceManager.shared
    let capture: SchemeCapture
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Appearance").fontWeight(.medium)
                Spacer()
                AppAppearancePicker(selection: $manager.selection)
            }
            Label(manager.selection.statusTitleKey, systemImage: manager.selection.symbolName)
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(24).frame(width: 360, height: 130)
        .background(Color(nsColor: .windowBackgroundColor))
        .background { SchemeProbe(capture: capture) }
        .appAppearance()
    }
}
@main struct Checks {
    @MainActor static func main() throws {
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
        let originalAppAppearance = NSApp.appearance?.name
        let originalSystemAppearance = SystemAppearance.current
        Defaults.saved = nil
        let manager = AppAppearanceManager()
        precondition(manager.selection == .system && Defaults.saved == nil)
        precondition(manager.selection.colorScheme == nil && manager.selection.nativeAppearance == nil)
        let first = NSWindow(contentRect: CGRect(x: 0, y: 0, width: 200, height: 100), styleMask: [.titled], backing: .buffered, defer: false)
        let second = NSWindow(contentRect: first.frame, styleMask: [.titled], backing: .buffered, defer: false)
        first.isReleasedWhenClosed = false
        second.isReleasedWhenClosed = false
        manager.register(first)
        manager.register(second)
        manager.register(nil)
        for (selection, name) in [(AppAppearance.dark, NSAppearance.Name.darkAqua), (.light, .aqua)] {
            manager.selection = selection
            precondition(Defaults.saved == selection.rawValue)
            precondition(first.appearance?.name == name && second.appearance?.name == name)
            precondition(AppAppearanceManager().selection == selection, "Selection must survive manager recreation")
        }
        manager.selection = .system
        precondition(first.appearance == nil && second.appearance == nil && Defaults.saved == "system")
        Defaults.saved = "invalid"
        precondition(AppAppearanceManager().selection == .system)
        Defaults.saved = "dark"
        let restored = AppAppearanceManager()
        let lateWindow = NSWindow(contentRect: first.frame, styleMask: [.titled], backing: .buffered, defer: false)
        lateWindow.isReleasedWhenClosed = false
        restored.register(lateWindow)
        precondition(lateWindow.appearance?.name == .darkAqua, "New windows must receive the saved appearance")
        precondition(NSApp.appearance?.name == originalAppAppearance && SystemAppearance.current == originalSystemAppearance)
        print("PASS: default/system fallback, persisted light/dark, invalid preference recovery, existing/new native windows, and unchanged app/system appearance")

        Defaults.saved = "system"
        let shared = AppAppearanceManager.shared
        let capture = SchemeCapture()
        let host = NSHostingView(rootView: AppearanceSample(capture: capture))
        host.setFrameSize(host.fittingSize)
        let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.contentView = host
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))
        for selection in [AppAppearance.dark, .light, .system] {
            shared.selection = selection
            host.layoutSubtreeIfNeeded()
            RunLoop.main.run(until: Date().addingTimeInterval(0.1))
            let systemScheme: ColorScheme = originalSystemAppearance == .dark ? .dark : .light
            precondition(capture.value == (selection.colorScheme ?? systemScheme), "SwiftUI environment did not follow \(selection.rawValue)")
            precondition(window.appearance?.name == selection.nativeAppearance?.name, "AppKit window did not follow \(selection.rawValue)")
            guard let bitmap = host.bitmapImageRepForCachingDisplay(in: host.bounds) else { fatalError("Missing bitmap") }
            host.cacheDisplay(in: host.bounds, to: bitmap)
            guard let png = bitmap.representation(using: .png, properties: [:]) else { fatalError("Missing PNG") }
            try png.write(to: URL(fileURLWithPath: "/tmp/Floe-appearance-\(selection.rawValue).png"))
        }
        // 只在隔离测试进程中模拟原生宿主的外观变化，不修改 macOS 系统偏好。
        for (name, expected) in [(NSAppearance.Name.aqua, ColorScheme.light), (.darkAqua, .dark)] {
            NSApp.appearance = NSAppearance(named: name)
            host.layoutSubtreeIfNeeded()
            RunLoop.main.run(until: Date().addingTimeInterval(0.1))
            precondition(capture.value == expected && window.appearance == nil, "System mode must keep following native host changes")
        }
        NSApp.appearance = originalAppAppearance.flatMap(NSAppearance.init(named:))
        window.close()
        first.close()
        second.close()
        lateWindow.close()
        print("PASS: production appearance picker and SwiftUI/AppKit bridge render dark, light and system transitions without recreating the host")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift")
let executable = directory.appendingPathComponent("checks")
try (production + "\n" + fixture).write(to: file, atomically: true, encoding: .utf8)
func run(_ executable: URL, arguments: [String]) throws {
    let process = Process()
    process.executableURL = executable
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    precondition(process.terminationStatus == 0)
}
try run(URL(fileURLWithPath: "/usr/bin/env"), arguments: ["swiftc", "-parse-as-library", file.path, "-o", executable.path])
try run(executable, arguments: [])
