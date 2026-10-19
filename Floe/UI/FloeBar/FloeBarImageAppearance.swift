//
//  FloeBarImageAppearance.swift
//  Floe
//

import AppKit

/// 识别可随主题着色的菜单栏字形；按原图缓存，避免鼠标和布局更新时重复扫描像素。
@MainActor
enum FloeBarImageAppearance {
    private final class PreparedImage {
        let mask: CGImage?

        init(mask: CGImage?) {
            self.mask = mask
        }
    }

    private static let cache: NSCache<CGImage, PreparedImage> = {
        let cache = NSCache<CGImage, PreparedImage>()
        cache.countLimit = 128
        cache.totalCostLimit = 8 * 1024 * 1024
        return cache
    }()

    static func isTemplate(_ image: CGImage) -> Bool {
        templateImage(for: image) != nil
    }

    /// 只保留字形的覆盖率，去掉截图中与字形颜色相反的阴影，避免模板着色后出现黑色光晕。
    static func templateImage(for image: CGImage) -> CGImage? {
        if let result = cache.object(forKey: image) {
            return result.mask
        }
        let result = prepare(image)
        let cost = image.bytesPerRow * image.height + (result.map { $0.bytesPerRow * $0.height } ?? 0)
        cache.setObject(PreparedImage(mask: result), forKey: image, cost: cost)
        return result
    }

    private static func prepare(_ image: CGImage) -> CGImage? {
        let width = image.width
        let height = image.height
        // 这里只处理小型状态栏图标；异常大图直接保留原貌。
        guard width > 0, height > 0, width <= 1024, height <= 256 else { return nil }
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        return pixels.withUnsafeMutableBytes { bytes in
            guard let context = CGContext(
                data: bytes.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
            ) else { return nil }
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
            let values = bytes.bindMemory(to: UInt8.self)
            var transparent = 0
            var solid = 0
            var light = 0
            var dark = 0
            var lightLuminance = 0.0
            var darkLuminance = 0.0
            for offset in stride(from: 0, to: values.count, by: 4) {
                let alpha = Double(values[offset + 3]) / 255
                if alpha < 0.05 { transparent += 1 }
                guard alpha >= 0.2 else { continue }
                // 还原预乘颜色，抗锯齿边缘不会被误判为灰色或彩色。
                let red = Double(values[offset]) / (255 * alpha)
                let green = Double(values[offset + 1]) / (255 * alpha)
                let blue = Double(values[offset + 2]) / (255 * alpha)
                guard max(red, green, blue) - min(red, green, blue) < 0.08 else { return nil }
                if alpha >= 0.6 {
                    solid += 1
                    if min(red, green, blue) > 0.72 {
                        light += 1
                        lightLuminance += (red + green + blue) / 3
                    }
                    if max(red, green, blue) < 0.28 {
                        dark += 1
                        darkLuminance += (red + green + blue) / 3
                    }
                }
            }
            // 不把实底图、空图或有明显明暗细节的灰度应用图标压成一块剪影。
            guard transparent > 0, solid > 0, Double(max(light, dark)) / Double(solid) >= 0.95 else { return nil }
            let isLight = light >= dark
            let foreground = isLight ? lightLuminance / Double(light) : 1 - darkLuminance / Double(dark)
            for offset in stride(from: 0, to: values.count, by: 4) {
                let alpha = Double(values[offset + 3])
                let luminance = (Double(values[offset]) + Double(values[offset + 1]) + Double(values[offset + 2])) / 3
                let signal = isLight ? luminance : alpha - luminance
                // 按实心字形的颜色归一化，保留抗锯齿覆盖率，不阈值化或放大轮廓。
                let coverage = UInt8(min(alpha, max(0, signal / foreground)).rounded())
                values[offset] = coverage
                values[offset + 1] = coverage
                values[offset + 2] = coverage
                values[offset + 3] = coverage
            }
            return context.makeImage()
        }
    }
}
