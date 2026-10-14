import Foundation

// 编译生产图片显示方法：逻辑尺寸由项目帧决定，不借用另一屏幕的 Retina 倍率。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/UI/FloeBar/FloeBar.swift"), encoding: .utf8)
let start = source.range(of: "    private var image: NSImage?")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let method = String(source[start..<end]).replacingOccurrences(of: "private var", with: "var")
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-image-scale-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = """
import Foundation
import CoreGraphics
struct PixelImage { let width: Int; let height: Int }
struct NSImage { let size: CGSize; init(cgImage: PixelImage, size: CGSize) { self.size = size } }
struct Item { let info = 1; let windowID = 1; var frame = CGRect(x: 0,y: 0,width: 24,height: 22) }
final class Cache { var images: [Int: PixelImage] = [:] }
struct View {
    var item = Item()
    let imageCache = Cache()
    \(method)
}
var view = View()
for scale in [1,2,3] {
    view.imageCache.images[1] = PixelImage(width: 24*scale,height: 22*scale)
    precondition(view.image?.size == CGSize(width: 24,height: 22))
}
view.imageCache.images[1] = PixelImage(width: 0,height: 22)
precondition(view.image == nil)
print("PASS: production Floe Bar image keeps identical logical dimensions for 1x/2x/3x captures and rejects invalid widths")
"""
let file = directory.appendingPathComponent("main.swift")
try fixture.write(to: file, atomically: true, encoding: .utf8)
let process = Process();process.executableURL = URL(fileURLWithPath: "/usr/bin/env");process.arguments = ["swift",file.path]
try process.run();process.waitUntilExit();precondition(process.terminationStatus == 0)
