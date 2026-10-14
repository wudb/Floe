//
//  MenuInteractionGuard.swift
//  Floe
//

import AXSwift
import Cocoa

/// 自动焦点切换和重新隐藏共用的菜单跟踪保护；所有 AX 查询留在主线程。
@MainActor
enum MenuInteractionGuard {
    static var isInteracting: Bool {
        // 使用独立 AX 引用和短超时，不能让卡住的宿主拖住 Floe 的自动行为。
        let probe = UIElement(AXUIElementCreateSystemWide())
        AXUIElementSetMessagingTimeout(probe.element, 0.02)
        let deadline = Date().addingTimeInterval(0.1)
        var current: UIElement? = (try? probe.attribute("AXFocusedUIElement")) ?? nil
        for _ in 0..<6 {
            guard let element = current, Date() < deadline else { break }
            AXUIElementSetMessagingTimeout(element.element, 0.02)
            if let role: String = try? element.attribute("AXRole"),
               role == "AXMenu" || role == "AXMenuItem" || role == "AXPopover" {
                return true
            }
            current = (try? element.attribute("AXParent")) ?? nil
        }
        // 菜单跟踪中 AX 焦点可能仍在网页/宿主窗口；前台应用的 popup 层提供第二信号。
        // 只读窗口元数据，不点击、关闭或修改宿主菜单，也不判断它是否为“孤儿窗口”。
        guard let pid = NSWorkspace.shared.frontmostApplication?.processIdentifier else { return false }
        return WindowInfo.getOnScreenWindows().contains {
            $0.ownerPID == pid && $0.layer == CGWindowLevelForKey(.popUpMenuWindow) &&
                $0.alpha > 0 && $0.frame.width > 0 && $0.frame.height > 0
        }
    }
}
