import Foundation

// 使用当前图标资源构造独立应用包，模拟系统仍缓存旧图标的启动场景。
// 不安装应用、不重启 Dock，也不修改正在运行的 Floe。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-icon-\(UUID().uuidString)")
let contents = directory.appendingPathComponent("IconCheck.app/Contents")
let resources = contents.appendingPathComponent("Resources")
let executable = contents.appendingPathComponent("MacOS/check")
try FileManager.default.createDirectory(at: resources, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: executable.deletingLastPathComponent(), withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }

func run(_ command: String, _ arguments: [String]) throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: command)
    process.arguments = arguments
    var environment = ProcessInfo.processInfo.environment
    environment["CLANG_MODULE_CACHE_PATH"] = "/tmp/Floe-icon-modules"
    process.environment = environment
    try process.run()
    process.waitUntilExit()
    precondition(process.terminationStatus == 0, "Failed: \(command)")
}

let iconset = directory.appendingPathComponent("Fixture.iconset")
try FileManager.default.createDirectory(at: iconset, withIntermediateDirectories: true)
let assets = repo.appendingPathComponent("Floe/Assets.xcassets/AppIcon.appiconset")
for file in try FileManager.default.contentsOfDirectory(at: assets, includingPropertiesForKeys: nil) where file.pathExtension == "png" {
    try FileManager.default.copyItem(at: file, to: iconset.appendingPathComponent(file.lastPathComponent))
}
try run("/usr/bin/iconutil", ["-c", "icns", iconset.path, "-o", resources.appendingPathComponent("AppIcon.icns").path])
let info: [String: Any] = [
    "CFBundleIdentifier": "com.wudb.FloeIconCheck",
    "CFBundleExecutable": "check",
    "CFBundlePackageType": "APPL",
    "CFBundleIconFile": "AppIcon",
]
try PropertyListSerialization.data(fromPropertyList: info, format: .xml, options: 0)
    .write(to: contents.appendingPathComponent("Info.plist"))

let checks = #"""
@main struct Checks {
    @MainActor static func pixels(_ image: NSImage) -> Data {
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 128, pixelsHigh: 128,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 512, bitsPerPixel: 32)!
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
        NSColor.clear.setFill()
        NSRect(x: 0, y: 0, width: 128, height: 128).fill()
        image.draw(in: NSRect(x: 0, y: 0, width: 128, height: 128))
        NSGraphicsContext.restoreGraphicsState()
        return Data(bytes: bitmap.bitmapData!, count: 128 * 512)
    }

    @MainActor static func main() throws {
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
        let iconURL = Bundle.main.url(forResource: "AppIcon", withExtension: "icns")!
        let expected = pixels(NSImage(contentsOf: iconURL)!)
        let stale = NSImage(size: NSSize(width: 128, height: 128), flipped: false) { rect in
            NSColor.red.setFill()
            rect.fill()
            return true
        }
        NSApp.applicationIconImage = stale
        precondition(pixels(NSApp.applicationIconImage) != expected)
        precondition(pixels(ApplicationIcon.image) == expected, "UI must bypass the stale application icon")
        ApplicationIcon.apply()
        let received = NSApp.applicationIconImage!
        let actual = pixels(received)
        // AppKit 会复制并重新绘制图标，允许 8 位通道中最多两级的舍入误差。
        let errors = zip(actual, expected).map { abs(Int($0) - Int($1)) }
        precondition(actual != pixels(stale) && errors.allSatisfy { $0 <= 2 }, "Dock must receive the bundled icon")

        let alternate = Bundle.main.bundleURL.deletingLastPathComponent().appendingPathComponent("WithExtension.app")
        let alternateResources = alternate.appendingPathComponent("Contents/Resources")
        try FileManager.default.createDirectory(at: alternateResources, withIntermediateDirectories: true)
        try FileManager.default.copyItem(at: iconURL, to: alternateResources.appendingPathComponent("AppIcon.icns"))
        let alternateInfo: [String: Any] = ["CFBundleIconFile": "AppIcon.icns"]
        try PropertyListSerialization.data(fromPropertyList: alternateInfo, format: .xml, options: 0)
            .write(to: alternate.appendingPathComponent("Contents/Info.plist"))
        precondition(pixels(ApplicationIcon.load(from: Bundle(url: alternate)!)!) == expected)
        precondition(ApplicationIcon.load(from: Bundle(for: NSObject.self)) == nil)
        print("PASS: bundled icon bypasses stale UI cache, updates NSApp for Dock, accepts icon names with/without extension, and handles missing resources")
    }
}
"""#
let production = try String(contentsOf: repo.appendingPathComponent("Floe/Utilities/ApplicationIcon.swift"), encoding: .utf8)
let source = directory.appendingPathComponent("Checks.swift")
try (production + "\n" + checks).write(to: source, atomically: true, encoding: .utf8)
try run("/usr/bin/xcrun", ["swiftc", "-parse-as-library", source.path, "-o", executable.path])
try run(executable.path, [])
