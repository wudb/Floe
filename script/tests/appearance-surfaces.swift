import Foundation

// 用真实材质及图片分类器验证浅色/深色，不读取桌面图像或用户偏好。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-surfaces-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let paths = ["Floe/UI/Views/VisualEffectView.swift", "Floe/UI/FloeUI/FloeSurface.swift", "Floe/UI/FloeBar/FloeBarImageAppearance.swift"]
let production = try paths.map { try String(contentsOf: repo.appendingPathComponent($0), encoding: .utf8) }.joined(separator: "\n")
let fixture = #"""
@MainActor func image(color: NSColor, scale: Int = 1, opaque: Bool = false, detail: NSColor? = nil) -> CGImage {
    let context = CGContext(data: nil, width: 32 * scale, height: 24 * scale, bitsPerComponent: 8,
        bytesPerRow: 32 * scale * 4, space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    context.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
    context.setFillColor(color.cgColor)
    if opaque {
        context.fill(CGRect(x: 0, y: 0, width: 32, height: 24))
    } else {
        context.fillEllipse(in: CGRect(x: 8, y: 4, width: 16, height: 16))
    }
    if let detail {
        context.setFillColor(detail.cgColor)
        context.fill(CGRect(x: 14, y: 8, width: 6, height: 8))
    }
    return context.makeImage()!
}
@MainActor func shadowedGlyph(light: Bool, scale: Int) -> CGImage {
    let context = CGContext(data: nil, width: 32 * scale, height: 24 * scale, bitsPerComponent: 8,
        bytesPerRow: 32 * scale * 4, space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    context.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
    context.setFillColor((light ? NSColor.black : .white).withAlphaComponent(0.3).cgColor)
    context.fill(CGRect(x: 4, y: 4, width: 24, height: 16))
    let ink = NSColor(white: light ? 0.88 : 0.12, alpha: 1)
    context.setFillColor(ink.cgColor)
    context.fill(CGRect(x: 8, y: 8, width: 16, height: 8))
    context.setFillColor(ink.withAlphaComponent(0.4).cgColor)
    context.fill(CGRect(x: 7, y: 8, width: 1, height: 8))
    return context.makeImage()!
}
func alpha(_ image: CGImage, x: Int, y: Int) -> Int {
    let bitmap = NSBitmapImageRep(cgImage: image)
    return Int((bitmap.colorAt(x: x, y: y)!.alphaComponent * 255).rounded())
}
@MainActor func capturedSymbol(_ name: String) -> CGImage {
    let context = CGContext(data: nil, width: 64, height: 48, bitsPerComponent: 8,
        bytesPerRow: 256, space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    context.scaleBy(x: 2, y: 2)
    let symbol = NSImage(systemSymbolName: name, accessibilityDescription: nil)!
        .withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: 16, weight: .regular))!
    let original = symbol.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    // 使用符号原始覆盖率制作白色字形，再模拟系统菜单栏截图自带的暗色投影。
    let glyphContext = CGContext(data: nil, width: original.width, height: original.height, bitsPerComponent: 8,
        bytesPerRow: original.width * 4, space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let bounds = CGRect(x: 0, y: 0, width: original.width, height: original.height)
    glyphContext.clip(to: bounds, mask: original)
    glyphContext.setFillColor(NSColor.white.cgColor)
    glyphContext.fill(bounds)
    let ratio = CGFloat(original.width) / CGFloat(original.height)
    let width = min(18, 18 * ratio)
    let height = width / ratio
    context.setShadow(offset: CGSize(width: 0, height: -0.5), blur: 1.2, color: NSColor.black.withAlphaComponent(0.4).cgColor)
    context.draw(glyphContext.makeImage()!, in: CGRect(x: (32 - width) / 2, y: (24 - height) / 2, width: width, height: height))
    return context.makeImage()!
}
struct BarClaritySample: View {
    let icons: [CGImage]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("调整前 · 图标周围有灰色光晕").font(.caption).foregroundStyle(.secondary)
            row(cleaned: false).floeGlassSurface(in: Capsule()).clipShape(Capsule())
                .shadow(color: .black.opacity(0.14), radius: 5, y: 2)
            Text("调整后 · 浅银灰底色，图标轮廓更清晰").font(.caption).foregroundStyle(.secondary)
            row(cleaned: true).floeFloatingBarSurface(in: Capsule()).clipShape(Capsule())
                .compositingGroup().shadow(color: .black.opacity(0.09), radius: 3, y: 1)
        }.padding(24).background(Color(nsColor: .windowBackgroundColor))
    }
    private func row(cleaned: Bool) -> some View {
        HStack(spacing: 4) {
            ForEach(icons, id: \.self) { icon in
                Image(nsImage: NSImage(cgImage: cleaned ? (FloeBarImageAppearance.templateImage(for: icon) ?? icon) : icon, size: CGSize(width: 32, height: 24)))
                    .renderingMode(.template)
            }
        }.foregroundStyle(.primary).padding(.horizontal, 12).padding(.vertical, 6)
    }
}
struct Sample: View {
    let white: CGImage
    let black: CGImage
    let colored: CGImage
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: "cube.fill").font(.system(size: 32)).foregroundStyle(.blue)
                Text("Floe").font(.title2.bold())
                Label("General", systemImage: "gearshape")
                Label("Menu Bar Layout", systemImage: "rectangle.topthird.inset.filled")
                    .foregroundStyle(.blue)
                Spacer()
            }.padding(20).frame(width: 180).floeSidebarSurface()
            VStack(alignment: .leading, spacing: 22) {
                Text("Menu Bar Layout").font(.title2.bold())
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Floe").fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "wifi")
                    Image(systemName: "battery.75")
                }.padding(.horizontal, 16).frame(height: 44)
                    .floeGlassSurface(in: RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 12) {
                    Text("Floating bar · captured icon fixtures").font(.caption).foregroundStyle(.secondary)
                    HStack(spacing: 10) {
                        ForEach([white, black, colored], id: \.self) { value in
                            Image(nsImage: NSImage(cgImage: FloeBarImageAppearance.templateImage(for: value) ?? value, size: CGSize(width: 32, height: 24)))
                                .renderingMode(FloeBarImageAppearance.isTemplate(value) ? .template : .original)
                        }
                        Image(systemName: "magnifyingglass")
                    }.foregroundStyle(.primary).padding(10).floeFloatingBarSurface(in: Capsule()).clipShape(Capsule())
                }.padding(16).frame(maxWidth: .infinity, alignment: .leading).floeCardSurface()
                Spacer()
            }.padding(24).frame(width: 440)
                .background(Color(nsColor: .windowBackgroundColor))
        }.frame(height: 360)
    }
}
@main struct Checks {
    @MainActor static func main() throws {
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
        for scale in [1, 2, 3] {
            let white = image(color: .white, scale: scale)
            let black = image(color: .black, scale: scale)
            precondition(FloeBarImageAppearance.isTemplate(white))
            precondition(FloeBarImageAppearance.isTemplate(black))
            precondition(FloeBarImageAppearance.isTemplate(white), "Repeated lookup must preserve classification")
            for light in [false, true] {
                let source = shadowedGlyph(light: light, scale: scale)
                let mask = FloeBarImageAppearance.templateImage(for: source)!
                precondition(mask.width == source.width && mask.height == source.height)
                precondition(alpha(source, x: 5 * scale, y: 5 * scale) > 60)
                precondition(alpha(mask, x: 5 * scale, y: 5 * scale) <= 2, "Opposite-color shadow must disappear")
                precondition(alpha(mask, x: 12 * scale, y: 10 * scale) >= 253, "Solid strokes must stay opaque")
                precondition(abs(alpha(mask, x: 7 * scale, y: 10 * scale) - 102) <= 3, "Antialiased edges must keep their coverage")
            }
            for value in [image(color: .systemBlue, scale: scale), image(color: .white, scale: scale, opaque: true),
                          image(color: .gray, scale: scale), image(color: .clear, scale: scale),
                          image(color: .white, scale: scale, detail: .black),
                          image(color: .white, scale: scale, detail: .red)] {
                precondition(!FloeBarImageAppearance.isTemplate(value))
            }
        }
        print("PASS: 1x/2x/3x white/black glyphs adapt; colored, grayscale-detail, opaque and empty images retain their appearance")
        print("PASS: opposite-color capture shadows removed at 1x/2x/3x without softening solid strokes or expanding antialiased edges")
        for (name, scheme) in [("light", ColorScheme.light), ("dark", .dark)] {
            // 故意让原生应用与 SwiftUI 的主题相反，检查原生材质也按局部颜色环境更新。
            NSApp.appearance = NSAppearance(named: scheme == .light ? .darkAqua : .aqua)
            let root = Sample(white: image(color: .white), black: image(color: .black), colored: image(color: .systemBlue))
                .environment(\.colorScheme, scheme)
            let host = NSHostingView(rootView: root)
            host.setFrameSize(CGSize(width: 620, height: 360))
            let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
            window.contentView = host
            host.layoutSubtreeIfNeeded()
            RunLoop.main.run(until: Date().addingTimeInterval(0.1))
            func checkMaterials(_ view: NSView) {
                if let effect = view as? NSVisualEffectView {
                    precondition(effect.appearance?.name == (scheme == .light ? .aqua : .darkAqua))
                }
                view.subviews.forEach(checkMaterials)
            }
            checkMaterials(host)
            let bitmap = host.bitmapImageRepForCachingDisplay(in: host.bounds)!
            host.cacheDisplay(in: host.bounds, to: bitmap)
            try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "/tmp/Floe-surfaces-\(name).png"))
            window.orderOut(nil)
            print("Rendered production surfaces and classified icon fixtures: \(name)")
        }
        let symbols = ["gearshape", "square.stack.fill", "bolt.fill", "clock", "music.note", "paintbrush.pointed", "shield.lefthalf.filled", "magnifyingglass"]
        let icons = symbols.map(capturedSymbol)
        precondition(icons.allSatisfy(FloeBarImageAppearance.isTemplate))
        NSApp.appearance = NSAppearance(named: .aqua)
        let host = NSHostingView(rootView: BarClaritySample(icons: icons).environment(\.colorScheme, .light))
        host.setFrameSize(host.fittingSize)
        let window = NSWindow(contentRect: host.frame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = host
        host.layoutSubtreeIfNeeded()
        RunLoop.main.run(until: Date().addingTimeInterval(0.1))
        let bitmap = host.bitmapImageRepForCachingDisplay(in: host.bounds)!
        host.cacheDisplay(in: host.bounds, to: bitmap)
        try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "/tmp/Floe-bar-clarity-light.png"))
        window.orderOut(nil)
        print("Rendered production floating-bar surfaces with shadowed symbol fixtures: before/after light")
    }
}
"""#
let file = directory.appendingPathComponent("main.swift")
try (production + "\n" + fixture).write(to: file, atomically: true, encoding: .utf8)
let compiler = Process()
compiler.executableURL = URL(fileURLWithPath: "/usr/bin/env")
compiler.arguments = ["swiftc", "-parse-as-library", file.path, "-o", directory.appendingPathComponent("check").path]
try compiler.run(); compiler.waitUntilExit(); precondition(compiler.terminationStatus == 0)
let check = Process()
check.executableURL = directory.appendingPathComponent("check")
try check.run(); check.waitUntilExit(); precondition(check.terminationStatus == 0)
