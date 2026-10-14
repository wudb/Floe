//
//  RuntimeDiagnostics.swift
//  Floe
//

#if DEBUG
import AppKit
import ApplicationServices
import CoreGraphics

/// 以 Floe 自身身份只读检查权限与显示器，不启动管理、不截图、不申请授权。
enum RuntimeDiagnostics {
    static func run() -> Never {
        let trusted = AXIsProcessTrusted()
        let captureAllowed = CGPreflightScreenCaptureAccess()
        let windows = WindowInfo.getOnScreenWindows(excludeDesktopWindows: true)
        let displays: [[String: Any]] = NSScreen.screens.map { screen in
            [
                "displayID": screen.displayID,
                "frame": NSStringFromRect(screen.frame),
                "quartzBounds": NSStringFromRect(CGDisplayBounds(screen.displayID)),
                "scale": screen.backingScaleFactor,
                "visibleMenuBar": WindowInfo.getMenuBarWindow(from: windows, for: screen.displayID) != nil,
            ]
        }
        let report: [String: Any] = [
            "bundleIdentifier": Bundle.main.bundleIdentifier ?? "",
            "accessibilityTrusted": trusted,
            "screenCaptureAllowed": captureAllowed,
            "displays": displays,
        ]
        if let data = try? JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys]),
           let text = String(data: data, encoding: .utf8) {
            print(text)
        }
        exit(0)
    }
}
#endif
