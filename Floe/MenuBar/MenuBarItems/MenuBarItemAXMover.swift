//
//  MenuBarItemAXMover.swift
//  Floe
//

import Cocoa

/// 使用 Quartz 坐标执行 Command-drag；同一时刻只允许一项操作占用鼠标。
@MainActor
enum MenuBarItemAXMover {
    private(set) static var isDragging = false

    /// 取消、事件创建失败及正常结束都释放鼠标/Command，并恢复原指针位置。
    @discardableResult
    static func commandDrag(from source: CGPoint, to destination: CGPoint) async -> Bool {
        guard !isDragging, !Task.isCancelled,
              source.x.isFinite, source.y.isFinite,
              destination.x.isFinite, destination.y.isFinite
        else { return false }
        isDragging = true
        defer { isDragging = false }
        let operation = Task.detached(priority: .userInitiated) { () -> Bool in
            guard let eventSource = CGEventSource(stateID: .hidSystemState) else { return false }
            let originalLocation = CGEvent(source: nil)?.location
            var location = source
            var didPressCommand = false
            var didPressMouse = false
            func post(_ type: CGEventType, at point: CGPoint, flags: CGEventFlags) -> Bool {
                let event: CGEvent?
                if type == .flagsChanged {
                    event = CGEvent(keyboardEventSource: eventSource, virtualKey: 55, keyDown: flags.contains(.maskCommand))
                    event?.type = .flagsChanged
                } else {
                    event = CGEvent(
                        mouseEventSource: eventSource,
                        mouseType: type,
                        mouseCursorPosition: point,
                        mouseButton: .left
                    )
                }
                guard let event else { return false }
                event.flags = flags
                event.location = point
                event.post(tap: .cghidEventTap)
                return true
            }
            defer {
                if didPressMouse { _ = post(.leftMouseUp, at: location, flags: []) }
                if didPressCommand { _ = post(.flagsChanged, at: location, flags: []) }
                if let originalLocation { CGWarpMouseCursorPosition(originalLocation) }
            }
            do {
                try Task.checkCancellation()
                guard post(.mouseMoved, at: source, flags: []) else { return false }
                try await Task.sleep(for: .milliseconds(120))
                guard post(.flagsChanged, at: source, flags: .maskCommand) else { return false }
                didPressCommand = true
                try await Task.sleep(for: .milliseconds(80))
                guard post(.leftMouseDown, at: source, flags: .maskCommand) else { return false }
                didPressMouse = true
                try await Task.sleep(for: .milliseconds(120))
                for index in 1...15 {
                    try Task.checkCancellation()
                    let progress = CGFloat(index) / 15
                    location = CGPoint(
                        x: source.x + (destination.x - source.x) * progress,
                        y: source.y + (destination.y - source.y) * progress
                    )
                    guard post(.leftMouseDragged, at: location, flags: .maskCommand) else { return false }
                    try await Task.sleep(for: .milliseconds(15))
                }
                guard post(.leftMouseUp, at: destination, flags: .maskCommand) else { return false }
                didPressMouse = false
                try await Task.sleep(for: .milliseconds(150))
                guard post(.flagsChanged, at: destination, flags: []) else { return false }
                didPressCommand = false
                try await Task.sleep(for: .milliseconds(350))
                return true
            } catch {
                return false
            }
        }
        return await withTaskCancellationHandler {
            await operation.value
        } onCancel: {
            operation.cancel()
        }
    }
}
