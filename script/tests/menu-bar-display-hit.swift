import Foundation

// 使用虚拟显示器及窗口编译生产命中方法，不访问 WindowServer。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let source = try String(contentsOf: repo.appendingPathComponent("Floe/Events/EventManager.swift"), encoding: .utf8)
let start = source.range(of: "    var isMouseInsideMenuBar: Bool")!.lowerBound
let end = source.range(of: "\n    }", range: start..<source.endIndex)!.upperBound
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-display-hit-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let fixture = """
import Foundation
import CoreGraphics
struct NSScreen { let displayID: UInt32 }
struct MouseCursor { static var locationCoreGraphics: CGPoint? = CGPoint(x: 100, y: 10) }
struct WindowInfo {
    let frame: CGRect; var isOnScreen = true
    static var windows: [UInt32: WindowInfo] = [:]
    static func getMenuBarWindow(for id: UInt32) -> WindowInfo? { windows[id] }
}
func CGDisplayBounds(_ id: UInt32) -> CGRect { id == 1 ? CGRect(x: 0,y: 0,width: 1000,height: 800) : CGRect(x: -1000,y: -200,width: 1000,height: 1000) }
final class Bar { var isMenuBarHiddenBySystem = false }
final class AppState { let menuBarManager = Bar(); var isActiveSpaceFullscreen = false }
final class Manager {
    var bestScreen: NSScreen? = NSScreen(displayID: 1)
    var appState: AppState? = AppState()
    static let menuBarStripHeight: CGFloat = 40
    static let menuBarFrameTTL: TimeInterval = 2
    var cachedMenuBarFrames: [UInt32: (frame: CGRect, date: Date)] = [:]
    \(String(source[start..<end]))
}
let manager = Manager()
WindowInfo.windows[1] = WindowInfo(frame: CGRect(x: 0,y: 0,width: 1000,height: 24))
precondition(manager.isMouseInsideMenuBar)
MouseCursor.locationCoreGraphics = CGPoint(x: -100, y: 10)
precondition(!manager.isMouseInsideMenuBar)
manager.bestScreen = NSScreen(displayID: 2)
MouseCursor.locationCoreGraphics = CGPoint(x: -100,y: -190)
precondition(!manager.isMouseInsideMenuBar) // 副屏没有菜单栏。
WindowInfo.windows[2] = WindowInfo(frame: CGRect(x: -1000,y: -200,width: 1000,height: 24))
precondition(manager.isMouseInsideMenuBar)
manager.appState!.menuBarManager.isMenuBarHiddenBySystem = true
WindowInfo.windows.removeValue(forKey: 2)
precondition(!manager.isMouseInsideMenuBar) // 隐藏后不能使用旧帧。
WindowInfo.windows[2] = WindowInfo(frame: CGRect(x: -1000,y: -195,width: 1000,height: 24))
precondition(manager.isMouseInsideMenuBar)
MouseCursor.locationCoreGraphics = CGPoint(x: -100,y: -170)
precondition(!manager.isMouseInsideMenuBar)
print("PASS: production display hit testing rejects cross-screen and absent/hidden bars, handles negative coordinates and follows sliding frames")
"""
let file = directory.appendingPathComponent("main.swift")
try fixture.write(to: file, atomically: true, encoding: .utf8)
let process = Process();process.executableURL = URL(fileURLWithPath: "/usr/bin/env");process.arguments = ["swift",file.path]
try process.run();process.waitUntilExit();precondition(process.terminationStatus == 0)
