import Foundation

// 使用原生 NSHostingView 渲染生产布局片段，验证窄屏列表/网格尺寸，不申请屏幕录制权限。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
func member(_ marker: String) -> String {
    let start = source.range(of: marker)!.lowerBound
    let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
    let declaration = String(source[start..<end]).replacingOccurrences(of: "private var", with: "var").replacingOccurrences(of: "private func", with: "func")
    return marker.contains("func") ? "@ViewBuilder\n" + declaration : declaration
}
let methods = [member("    private var gridColumns:"), member("    private func arrangedRows<"), member("    private func tile<")].joined(separator: "\n")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-layout-render-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import AppKit
import SwiftUI
struct Screen { var visibleFrame = CGRect(x: -1920, y: 37, width: 320, height: 600) }
struct Preferences {
    enum Layout { case icons, list, grid }
    var layout: Layout, columns = 12
}
struct Gallery: View {
    let screen = Screen()
    let preferences: Preferences
    __PRODUCTION__
    var body: some View {
        arrangedRows(count: 40) {
            ForEach(0..<40, id: \.self) { index in
                tile(name: index.isMultiple(of: 2) ? "中文菜单应用名称 \(index)" : "Long application name \(index)") {
                    Image(systemName: "menubar.rectangle").resizable().scaledToFit()
                }
            }
        }
        .padding(8).background(.black).foregroundStyle(.white)
    }
}
@main struct Checks {
    @MainActor static func main() throws {
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
        for (name, layout) in [("list", Preferences.Layout.list), ("grid", .grid)] {
            let host = NSHostingView(rootView: Gallery(preferences: Preferences(layout: layout)))
            let size = host.fittingSize
            precondition(size.width > 100 && size.width <= 320 && size.height > 100 && size.height <= 600)
            host.setFrameSize(size)
            let window = NSWindow(contentRect: CGRect(origin: .zero, size: size), styleMask: [.borderless], backing: .buffered, defer: false)
            window.contentView = host
            host.layoutSubtreeIfNeeded()
            RunLoop.main.run(until: Date().addingTimeInterval(0.05))
            if let bitmap = host.bitmapImageRepForCachingDisplay(in: host.bounds) {
                host.cacheDisplay(in: host.bounds, to: bitmap)
                if let png = bitmap.representation(using: .png, properties: [:]) {
                    try png.write(to: URL(fileURLWithPath: "/tmp/Floe-M5B-\(name).png"))
                }
            }
            window.orderOut(nil)
            print("PASS: production \(name) layout fits 320pt display: \(size)")
        }
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift"), executable = directory.appendingPathComponent("tests")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: methods).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process(); compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env"); compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", executable.path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let runner = Process(); runner.executableURL = executable
try runner.run(); runner.waitUntilExit(); precondition(runner.terminationStatus == 0)
