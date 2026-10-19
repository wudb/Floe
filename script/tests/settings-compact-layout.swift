import Foundation

// 渲染生产紧凑图标与换行布局，验证大量项目在窄窗口下仍保留完整点击区域。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift"), encoding: .utf8)
func member(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    return String(source[start..<end])
}
let layoutStart = source.range(of: "private struct FlowLayout:")!.lowerBound
let layoutEnd = source.range(of: "// MARK: - Subtitle", range: layoutStart..<source.endIndex)!.lowerBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-compact-layout-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import AppKit
import SwiftUI
struct RowItem {
    let id: String
    let title: String
    let systemImage: String? = "wifi"
    let appIcon: NSImage? = nil
}
__LAYOUT__
struct Gallery: View {
    @State private var hoveredItemID: String?
    @FocusState private var focusedItemID: String?
    let count: Int
    __ICON__
    __VISUAL__
    var body: some View {
        FlowLayout(spacing: 4) {
            ForEach(0..<count, id: \.self) { index in
                itemVisual(RowItem(id: "\(index)", title: "很长的应用名称 Long application name \(index)"))
            }
        }
    }
}
@main struct Checks {
    @MainActor static func main() throws {
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
        for width: CGFloat in [240, 360, 600] {
            for count in [1, 12, 44, 100] {
                let host = NSHostingView(rootView: Gallery(count: count).frame(width: width))
                let size = host.fittingSize
                let columns = Int((width + 4) / 40)
                let rows = (count + columns - 1) / columns
                let expectedHeight = CGFloat(rows * 40 - 4)
                precondition(abs(size.width - width) < 0.5 && abs(size.height - expectedHeight) < 0.5,
                             "Compact layout clipped or compressed items: width=\(width), count=\(count), size=\(size)")
            }
        }
        // 仅生成自己的离屏视图图像，不读取桌面或申请屏幕录制权限。
        for (name, scheme) in [("light", ColorScheme.light), ("dark", .dark)] {
            NSApp.appearance = NSAppearance(named: scheme == .dark ? .darkAqua : .aqua)
            let host = NSHostingView(rootView:
                Gallery(count: 100).frame(width: 360).padding(16)
                    .background(Color(nsColor: .windowBackgroundColor))
                    .environment(\.colorScheme, scheme)
            )
            host.setFrameSize(host.fittingSize)
            let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
            window.contentView = host
            host.layoutSubtreeIfNeeded()
            RunLoop.main.run(until: Date().addingTimeInterval(0.1))
            guard let bitmap = host.bitmapImageRepForCachingDisplay(in: host.bounds) else { fatalError("Missing bitmap") }
            host.cacheDisplay(in: host.bounds, to: bitmap)
            guard let png = bitmap.representation(using: .png, properties: [:]) else { fatalError("Missing PNG") }
            try png.write(to: URL(fileURLWithPath: "/tmp/Floe-V2-compact-\(name).png"))
            window.orderOut(nil)
        }
        print("PASS: production compact icons retain 36pt hit targets, preserve 100 long-named items and wrap at 240/360/600pt widths in both appearances")
    }
}
"""#
let generated = fixture
    .replacingOccurrences(of: "__LAYOUT__", with: String(source[layoutStart..<layoutEnd]))
    .replacingOccurrences(of: "__ICON__", with: member("    private func compactIcon("))
    .replacingOccurrences(of: "__VISUAL__", with: member("    private func itemVisual("))
let file = directory.appendingPathComponent("Tests.swift")
let executable = directory.appendingPathComponent("checks")
try generated.write(to: file, atomically: true, encoding: .utf8)
func run(_ executable: URL, arguments: [String] = []) throws {
    let process = Process()
    process.executableURL = executable
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    precondition(process.terminationStatus == 0)
}
try run(URL(fileURLWithPath: "/usr/bin/env"), arguments: ["swiftc", "-parse-as-library", file.path, "-o", executable.path])
try run(executable)
