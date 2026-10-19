import Foundation

// 编译生产端帽路径，避免玻璃材质/描边把重叠子路径画成两端的内圈。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
let start = source.range(of: "private struct SplitPillShape:")!.lowerBound
let end = source.range(of: "// MARK: - FloeBarContentView", range: start..<source.endIndex)!.lowerBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-pill-shape-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = #"""
import AppKit
import SwiftUI
enum MenuBarEndCap: CaseIterable { case square, round }
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self { min(max(self, limits.lowerBound), limits.upperBound) }
}
__PRODUCTION__
struct Sample: View {
    var body: some View {
        HStack(spacing: 14) {
            ForEach(["sparkles", "doc", "keyboard", "clock", "computermouse", "shippingbox", "eyedropper", "magnifyingglass"], id: \.self) { name in
                Image(systemName: name).font(.system(size: 16)).frame(width: 20, height: 22)
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background(.gray.opacity(0.65))
        .overlay {
            SplitPillShape(leadingEndCap: .round, trailingEndCap: .round)
                .stroke(.white.opacity(0.5), lineWidth: 1)
        }
        .clipShape(SplitPillShape(leadingEndCap: .round, trailingEndCap: .round))
        .padding(20)
        .background(Color(red: 0.14, green: 0.17, blue: 0.23))
    }
}
@main struct Checks {
    @MainActor static func main() throws {
        let baseline = CommandLine.arguments.contains("--baseline")
        var cases = 0
        for leading in MenuBarEndCap.allCases {
            for trailing in MenuBarEndCap.allCases {
                for factor in [-0.5, 0, 0.5, 1, 1.5] {
                    for size in [CGSize(width: 600, height: 36), CGSize(width: 80, height: 36), CGSize(width: 24, height: 36), CGSize(width: 36, height: 36)] {
                        for inset: CGFloat in [0, 1, 3] {
                            let rect = CGRect(origin: CGPoint(x: 11, y: 17), size: size)
                            let bounds = rect.insetBy(dx: inset, dy: inset)
                            let path = SplitPillShape(leadingEndCap: leading, trailingEndCap: trailing, cornerRadiusFactor: factor)
                                .inset(by: inset).path(in: rect)
                            var moves = 0, closes = 0
                            path.cgPath.applyWithBlock { element in
                                if element.pointee.type == .moveToPoint { moves += 1 }
                                if element.pointee.type == .closeSubpath { closes += 1 }
                            }
                            if !baseline {
                                precondition(moves == 1 && closes == 1, "Internal cap contours: \(moves) moves, \(closes) closures")
                                let actual = path.boundingRect
                                precondition(abs(actual.minX - bounds.minX) < 0.001 && abs(actual.maxX - bounds.maxX) < 0.001 &&
                                             abs(actual.minY - bounds.minY) < 0.001 && abs(actual.maxY - bounds.maxY) < 0.001,
                                             "Cap exceeds the bar bounds: \(actual) versus \(bounds)")
                                precondition(path.contains(CGPoint(x: bounds.midX, y: bounds.midY)))
                                let corner = CGPoint(x: bounds.minX + 0.1, y: bounds.minY + 0.1)
                                precondition(path.contains(corner) == (leading == .square || factor <= 0))
                            }
                            cases += 1
                        }
                    }
                }
            }
        }
        var contours = 0
        SplitPillShape(leadingEndCap: .round, trailingEndCap: .round)
            .path(in: CGRect(x: 0, y: 0, width: 400, height: 36)).cgPath.applyWithBlock { element in
                if element.pointee.type == .moveToPoint { contours += 1 }
            }
        if !baseline {
            precondition(SplitPillShape(leadingEndCap: .round, trailingEndCap: .round)
                .inset(by: 30).path(in: CGRect(x: 0, y: 0, width: 20, height: 36)).isEmpty)
        }
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
        let host = NSHostingView(rootView: Sample())
        host.setFrameSize(host.fittingSize)
        let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = host
        host.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))
        guard let bitmap = host.bitmapImageRepForCachingDisplay(in: host.bounds) else { fatalError("Missing bitmap") }
        host.cacheDisplay(in: host.bounds, to: bitmap)
        guard let png = bitmap.representation(using: .png, properties: [:]) else { fatalError("Missing PNG") }
        let name = baseline ? "before" : "after"
        try png.write(to: URL(fileURLWithPath: "/tmp/Floe-pill-\(name).png"))
        window.orderOut(nil)
        print("\(baseline ? "BASELINE" : "PASS"): \(cases) production end-cap cases, default round pill has \(contours) closed contour(s)")
    }
}
"""#
let file = directory.appendingPathComponent("Tests.swift")
let executable = directory.appendingPathComponent("checks")
try fixture.replacingOccurrences(of: "__PRODUCTION__", with: String(source[start..<end])).write(to: file, atomically: true, encoding: .utf8)
func run(_ executable: URL, arguments: [String]) throws {
    let process = Process()
    process.executableURL = executable
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    precondition(process.terminationStatus == 0)
}
try run(URL(fileURLWithPath: "/usr/bin/env"), arguments: ["swiftc", "-parse-as-library", file.path, "-o", executable.path])
try run(executable, arguments: CommandLine.arguments.contains("--baseline") ? ["--baseline"] : [])
