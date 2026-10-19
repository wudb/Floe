import Foundation

// 使用生产控制器、命中及定位代码，检查即时切换、移出、拖拽和滚动裁剪。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeUI/FloeTooltip.swift"), encoding: .utf8)
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-instant-tooltip-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
struct Sample: View {
    let controller: FloeTooltipController
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(systemName: "sparkles").frame(width: 36, height: 36)
                    .background(.blue.opacity(0.2))
                    .floeTooltip("ChatGPT", viewport: "icons")
                Image(systemName: "shippingbox").frame(width: 36, height: 36)
                    .floeTooltip("一个较长的应用名称 Long application name", viewport: "icons")
            }
            .floeTooltipViewport("icons")
            .padding(.top, 20).padding(.leading, 20)
            Spacer()
        }
        .frame(width: 320, height: 180, alignment: .topLeading)
        .background(Color(nsColor: .windowBackgroundColor))
        .floeTooltips(controller)
    }
}
@main struct Checks {
    @MainActor static func main() throws {
        let controller = FloeTooltipController()
        let first = CGPoint(x: 38, y: 38), second = CGPoint(x: 78, y: 38)
        for _ in 0..<1000 {
            controller.update(location: first)
            precondition(controller.pointerLocation == first, "First entry must be synchronous")
            controller.update(location: second)
            precondition(controller.pointerLocation == second, "Adjacent icon must replace the old location immediately")
            controller.dismiss()
            precondition(controller.pointerLocation == nil, "Exit must clear synchronously")
            controller.update(location: first, pressedMouseButtons: 1)
            precondition(controller.pointerLocation == nil, "Dragging must suppress the tooltip")
        }
        let viewport = CGRect(x: 20, y: 20, width: 100, height: 36)
        let clipped = CGRect(x: 20, y: 4, width: 36, height: 36)
        precondition(!FloeTooltipGeometry.contains(CGPoint(x: 38, y: 10), target: clipped, viewport: viewport))
        precondition(FloeTooltipGeometry.contains(CGPoint(x: 38, y: 25), target: clipped, viewport: viewport))
        precondition(!FloeTooltipGeometry.contains(CGPoint(x: 200, y: 25), target: clipped, viewport: viewport))
        let size = CGSize(width: 120, height: 32), container = CGSize(width: 320, height: 180)
        for anchor in [CGRect(x: 0, y: 0, width: 36, height: 36), CGRect(x: 284, y: 144, width: 36, height: 36)] {
            let point = FloeTooltipGeometry.origin(size: size, anchor: anchor, container: container)
            precondition(point.x >= 8 && point.y >= 8 && point.x + size.width <= 312 && point.y + size.height <= 172)
        }
        let lower = CGRect(x: 100, y: 144, width: 36, height: 36)
        precondition(FloeTooltipGeometry.origin(size: size, anchor: lower, container: container).y + size.height < lower.minY)

        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
        let host = NSHostingView(rootView: Sample(controller: controller))
        host.setFrameSize(host.fittingSize)
        let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = host
        host.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        for (name, point) in [("chatgpt", first), ("long-name", second), ("outside", CGPoint(x: 200, y: 100))] {
            controller.update(location: point)
            host.layoutSubtreeIfNeeded()
            RunLoop.main.run(until: Date().addingTimeInterval(0.05))
            guard let bitmap = host.bitmapImageRepForCachingDisplay(in: host.bounds) else { fatalError("Missing bitmap") }
            host.cacheDisplay(in: host.bounds, to: bitmap)
            guard let png = bitmap.representation(using: .png, properties: [:]) else { fatalError("Missing PNG") }
            try png.write(to: URL(fileURLWithPath: "/tmp/Floe-tooltip-\(name).png"))
        }
        controller.dismiss()
        precondition(controller.pointerLocation == nil)
        window.orderOut(nil)
        print("PASS: 1000 synchronous enter/switch/exit/drag sequences, viewport clipping, edge clamping and upward placement; rendered production tooltip layer with controlled pointer locations")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift")
let executable = directory.appendingPathComponent("checks")
try (source + "\n" + fixture).write(to: file, atomically: true, encoding: .utf8)
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
