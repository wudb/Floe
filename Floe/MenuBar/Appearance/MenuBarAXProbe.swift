//
//  MenuBarAXProbe.swift
//  Floe
//

import AXSwift
import Cocoa

/// 菜单栏外观扫描只传递值快照，避免后台线程持有并访问 Floe 自己的 AppKit 菜单。
enum MenuBarAXProbe {
    struct Snapshot {
        let role: String?
        let pid: pid_t?
        let frame: CGRect?
    }

    static func snapshot(atX x: Float, y: Float) -> Snapshot? {
        // 系统级 AX 命中测试也可能命中本进程，并同步进入 NSMenu 的辅助功能实现。
        // 单个探测在主线程完成；扫描循环和宽度计算仍在后台执行。
        if Thread.isMainThread {
            return readSnapshot(atX: x, y: y)
        }
        return DispatchQueue.main.sync {
            readSnapshot(atX: x, y: y)
        }
    }

    private static func readSnapshot(atX x: Float, y: Float) -> Snapshot? {
        guard let element = try? systemWideElement.elementAtPosition(x, y) else {
            return nil
        }
        let role: String? = try? element.attribute("AXRole")
        let pid: pid_t? = try? element.pid()
        // 裸菜单栏不属于状态图标，无需额外查询其整条菜单栏的几何信息。
        let frame: CGRect? = role == "AXMenuBar" ? nil : try? element.attribute("AXFrame")
        return Snapshot(role: role, pid: pid, frame: frame)
    }
}
