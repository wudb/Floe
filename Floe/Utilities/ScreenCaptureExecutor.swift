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
        let result = CaptureResult<Value>()
        return await withTaskCancellationHandler {
            await withCheckedContinuation { continuation in
                result.install(continuation)
                DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + timeout) {
                    result.finish(nil)
                }
                queue.async {
                    // 取消/超时早于队列执行时无需再调用系统 API；占用标记由队列负责释放。
                    guard !result.isFinished else {
                        self.end()
                        return
                    }
                    // 每次同步截图及时释放临时 Objective-C 对象，避免串行后台队列延后回收。
                    let value = autoreleasepool { operation() }
                    self.end()
                    result.finish(value)
                }
            }
        } onCancel: {
            // 只能结束调用者等待，不能提前释放正在执行且无法取消的系统截图。
            result.finish(nil)
        }
    }
}

/// 超时和截图完成可能同时发生，continuation 必须只恢复一次。
private final class CaptureResult<Value: Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var continuation: CheckedContinuation<Value?, Never>?

    private var finished = false

    var isFinished: Bool {
        lock.lock()
        defer { lock.unlock() }
        return finished
    }

    /// 取消可能早于 continuation 注册；记住完成状态，注册后立即恢复而不是漏掉取消。
    func install(_ continuation: CheckedContinuation<Value?, Never>) {
        lock.lock()
        if finished {
            lock.unlock()
            continuation.resume(returning: nil)
        } else {
            self.continuation = continuation
            lock.unlock()
        }
    }

    func finish(_ value: Value?) {
        lock.lock()
        guard !finished else {
            lock.unlock()
            return
        }
        finished = true
        let pending = continuation
        continuation = nil
        lock.unlock()
        pending?.resume(returning: value)
    }
}
