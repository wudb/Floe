//
//  ScreenCaptureExecutor.swift
//  Floe
//

import Foundation

/// 隔离无法取消的同步截图：调用者可以超时返回，但系统调用结束前不接受新任务。
/// 可跨线程共享；可变运行标记只通过 NSLock 访问。
final class ScreenCaptureExecutor: @unchecked Sendable {
    private let queue = DispatchQueue(label: "com.wudb.Floe.screen-capture", qos: .utility)
    private let lock = NSLock()
    private var isRunning = false

    private func begin() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        guard !isRunning else { return false }
        isRunning = true
        return true
    }

    private func end() {
        lock.lock()
        isRunning = false
        lock.unlock()
    }

    /// 忙时直接返回 nil；不能通过超时释放运行标记，否则卡住的截图会持续占用线程。
    func run<Value: Sendable>(timeout: TimeInterval = 2, operation: @escaping @Sendable () -> Value?) async -> Value? {
        guard !Task.isCancelled, begin() else { return nil }
        return await withCheckedContinuation { continuation in
            let result = CaptureResult(continuation)
            DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + timeout) {
                result.finish(nil)
            }
            queue.async {
                let value = operation()
                self.end()
                result.finish(value)
            }
        }
    }
}

/// 超时和截图完成可能同时发生，continuation 必须只恢复一次。
private final class CaptureResult<Value: Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var continuation: CheckedContinuation<Value?, Never>?

    init(_ continuation: CheckedContinuation<Value?, Never>) {
        self.continuation = continuation
    }

    func finish(_ value: Value?) {
        lock.lock()
        let pending = continuation
        continuation = nil
        lock.unlock()
        pending?.resume(returning: value)
    }
}
