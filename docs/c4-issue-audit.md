# C4 长期运行与内存增长核对

日期：2026-10-14。范围为 M1/C4 两条报告；主机 GitHub 授权刷新全部原文/评论，见 [核对快照](c4-upstream-review.json) 与 [机器状态](c4-status.json)。两条均 open，未修改上游状态。

## 报告与证据

- [jordanbaird/Ice#530](https://github.com/jordanbaird/Ice/issues/530)：M2 Max/Sequoia 15.3.2 长期运行约 4GB 应用内存。评论涉及多显示器、非官方构建及数日增长，未提供能证明 Floe 中具体对象泄漏的分配栈。须区分缓存、截图峰值、应用内存和系统进程内存。
- [jordanbaird/Ice#819](https://github.com/jordanbaird/Ice/issues/819)：Sequoia 15.7.3 的 WindowServer 每数秒增长约 16KB，报告称取消 Ice 屏幕录制授权并重启 Ice 后停止。评论推测旧截图 API 内部泄漏，并指出新 API 对屏外菜单栏项的捕获限制。这是调查线索，尚无 Floe 同环境因果对照。

## 已有及本批优化

已有优化包括截图指针释放、单一有界执行器、超时/取消不释放仍阻塞的 worker、图片缓存按存活项淘汰，以及隐藏浮栏/无相关页面时不捕获图片。本批保留这些行为。

1. `MenuBarItemImageCache.createImages` 在开始、合成结果、逐项捕获及裁剪前检查取消。取消导致的 nil 不再触发逐项 fallback；取消时返回空局部结果，不继续占用截图调用与裁剪资源。
2. `updateCacheWithoutChecks` 在开始、每个分区及发布前检查取消；不发布已取消请求的局部图片。更新占用标记继续用 defer 释放，之后正常请求可继续工作。
3. `ScreenCaptureExecutor` 在每次同步截图 operation 周围建立显式 autorelease pool，及时回收临时 Objective-C 对象；返回图片仍由调用者持有。没有改变“系统调用未返回时不接受额外工作”的限制，也不宣称此举能修复系统 API 内部泄漏。

## 验证

macOS 15.8.1、Xcode 26.3：Debug、Release 构建通过，21 项 Swift 回归通过，SwiftLint strict 117 个文件 0 violations，`git diff --check` 通过。

新增 `script/tests/image-capture-cancellation.swift` 直接编译生产捕获/发布方法，受控截图替代 WindowServer：预取消不调用捕获；合成捕获取消后无论返回 nil 或迟到图片都不 fallback/裁剪/发布；逐项截图取消后不继续下一项；取消后占用标记释放，正常批次可再次更新。既有缓存淘汰和执行器超时/取消回归通过。

日志：`/tmp/Floe-C4-Debug.log`、`/tmp/Floe-C4-Release.log`、`/tmp/Floe-C4-regression.log`、`/tmp/Floe-C4-lint.log`。

## 长时验收边界

本批未执行 36 小时真机对照，不将受控任务测试当作内存稳定性结果。C4 两条继续保留，M1 70 条、总清单 367 条不变；C3 未提交改动一并保留。

验收应记录系统、硬件、显示器、签名/安装路径、权限、外观及浮栏设置，并覆盖至少 36 小时；相同设置分别记录 Floe 的 RSS/footprint 与 WindowServer 的 footprint（尤其 `untagged (VM_ALLOCATE)` Dirty），窗口数量及截图触发情况。隐藏浮栏、持续打开浮栏/布局页、多显示器与反复打开关闭窗口应分开记录。RSS 不是 footprint，单次截图或主机总内存不能证明泄漏；需要无 Floe 与有 Floe 的同环境对照才能判断 WindowServer 因果。不擅自重启用户系统或重置 TCC。

## 后续优化：提前回收超时协调资源

`ScreenCaptureExecutor` 原来每次截图都提交一个不可取消的 `asyncAfter` 回调，即使截图提前完成，该回调仍保留协调对象直到超时期限。本批使用可取消的 DispatchSourceTimer，正常完成或取消时清除并取消计时器；弱引用 handler 避免超时源形成持有环。超时注册与完成通过原锁保护，注册之前已完成则立即取消新源。系统截图实际返回前仍保留 worker 占用标记，不能以回收超时对象为由放开阻塞调用。

生产执行器回归新增提前完成后协调对象立即释放检查，并通过原有超时/取消/完成竞争和阻塞后拒绝新请求检查。该变化减少短时挂起对象，并不构成长期泄漏已解决的证据。后续日志：`/tmp/Floe-C34-Debug.log`、`/tmp/Floe-C34-Release.log`、`/tmp/Floe-C34-regression.log`、`/tmp/Floe-C34-lint.log`。
