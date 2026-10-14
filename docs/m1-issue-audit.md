# M1 首批稳定性修复

日期：2026-10-14（Asia/Shanghai）。源码基线：`d19e5a9`，包括本轮工作区改动。
M1 原 83 条，本轮归档 `jordanbaird/Ice#925` 后待处理 **82 条**，整个 M1 尚未完成。
不修改上游 issue 状态；不要求取得 macOS 26/27 环境后才继续源码开发。

C1 后续核对、事件超时修复与验证见 [C1 专项记录](c1-issue-audit.md)。第五批 #563 和第六批 7 条溢出崩溃签名已归档，第七批继续归档 #796/#905，第八批归档 #603/#742，当前 C1 17 条、M1 70 条、总清单 367 条；其余保留报告级验收。

C0 后续防护与回归见 [C0 专项记录](c0-issue-audit.md)。三个 P0 仍保留，更新状态为防护已实现、系统级根因待调查。

## 实现与因果边界

### 截图阻塞隔离

`ScreenCapture.captureWindows/captureWindow` 改为异步接口，共用 `ScreenCaptureExecutor`。
同步 CG 截图只在专用后台队列执行，颜色采样和图片缓存都 await 结果，不再在主线程等待。
两秒未返回时调用者得到 nil；实际系统调用尚未结束时，后续请求直接跳过，不追加任务或线程。
完成与超时竞争由锁保护，continuation 只恢复一次；迟到图像不会重新发布。

该隔离解决代码内的主线程等待和重复截图堆积风险，但**不能取消或修复卡住的系统 API**。
若系统调用永久不返回，该执行器保持占用，本进程后续 CG 截图会跳过，需重启 Floe 恢复截图。
AX fallback 与已有图像不依赖该阻塞队列继续响应；同步权限探测/其他 AX 路径仍有各自验证边界。

`MenuBarManager` 的平均颜色采样合并重复触发，异步返回后核对当前屏幕与设置可见性。
`FloeBarColorManager` 不再阻塞面板显示，截图结束后使用当前面板位置更新颜色；浮栏隐藏时不再周期性截图。

### 内存与缓存生命周期

原截图方法每次 `UnsafeMutablePointer.allocate` 后没有释放；加入 `defer { pointer.deallocate() }`，
包括 CFArray 创建失败和截图失败路径。空窗口列表直接返回，避免无意义的系统调用。
这修复的是进程内明确的指针泄漏，**不是证明 WindowServer 的增长已经解决**。

图片缓存统一在 MainActor 读取 UI 状态并发布结果，同时合并并发刷新。
发现列表变化/定时触发时清理已消失状态项的图片，即使浮栏隐藏也能释放。
新结果发布前再次核对当前屏幕和项身份，屏幕已切换则丢弃旧结果。
未变化的项集合不额外发布清理事件，当前有效项继续保留图片。

## Issue 标记

本轮通过主机 GitHub 授权刷新正文、状态和评论；实时状态索引见 [核对数据](m1-upstream-review.json)。

| Issue | 标记 | 依据与剩余范围 |
| --- | --- | --- |
| [jordanbaird/Ice#925](https://github.com/jordanbaird/Ice/issues/925) | 已修复（已继承、代码层归档） | 后续评论已符号化确认 4294967296 → UInt32 溢出，当前两个转换点均为 failable initializer；生产 getter 回归与 nil-ID 浮栏定位通过。未做 26 实机，不将同签名推及所有崩溃。 |
| [jordanbaird/Ice#777](https://github.com/jordanbaird/Ice/issues/777) | 部分修复 | 截图工作移出主线程、调用者超时且后台并发有界；系统 CG API 卡住的根因未修复，对应系统复测待补。 |
| [jordanbaird/Ice#530](https://github.com/jordanbaird/Ice/issues/530) | 部分修复 | 修复指针泄漏与旧图片持续保留；尚无相同设置下长时内存曲线，不宣称原报告全部解决。 |
| [jordanbaird/Ice#819](https://github.com/jordanbaird/Ice/issues/819) | 调查中 | 减少隐藏浮栏截图并限制重叠；WindowServer 每页增长的因果未确认，不能用本进程指针修复代替系统测量。 |
| [jordanbaird/Ice#840](https://github.com/jordanbaird/Ice/issues/840)、[#905](https://github.com/jordanbaird/Ice/issues/905) | 相关防护已继承，保留报告验收 | 已有安全 ID 转换，本轮又移除浮栏颜色采样的同步等待；各报告不同崩溃/冻结范围不能仅按相似签名删除。 |
| [cavaldos/Ice#9](https://github.com/cavaldos/Ice/issues/9) | 已核对，保留报告验收 | 当前布局与浮栏具备 CGS 缺失后的 AX fallback，已有发现/分区/准确点击回归；未确认报告具体 27 环境的所有缺失与拖动症状已消失。 |
| [jordanbaird/Ice#908](https://github.com/jordanbaird/Ice/issues/908) | 调查中（P0） | 分隔符失效恢复已有受控回归；至少 36 小时的系统冻结对照未执行，未确定 Floe 因果。 |
| [jordanbaird/Ice#968](https://github.com/jordanbaird/Ice/issues/968) | 调查中（P0） | 原生表单弹窗与宿主/Dock 卡死仍需要对应应用对照；不将浮栏生命周期测试视为全部验收。 |
| [jordanbaird/Ice#974](https://github.com/jordanbaird/Ice/issues/974) | 调查中（P0） | 作者已纠正 CG/AX 非同步快照误报，因果仍未确定；保持 P0 和独立调查。 |

## 验证

- macOS 15.8.1 / Xcode 26.3：最终 Debug、Release 构建通过。
- 严格 SwiftLint 0.65.1：117 个源文件，0 violations。
- 原 7 个受控脚本通过，新增 3 个回归通过：
  - `screen-capture-executor.swift`：后台执行、系统阻塞时有界返回、200 次重复请求不运行、迟到完成后恢复、100 次超时竞态。
  - `image-cache-retention.swift`：编译生产清理方法，验证失效项释放、有效项保留、200 次项重建不增长、空发现清理及无变化不发布。
  - `window-id.swift`：编译生产 getter，验证 nil、负数、4294967296、Int.max、正常值和 UInt32.max。
- 日志：`/tmp/Floe-M1-Debug.log`、`/tmp/Floe-M1-Release.log`、`/tmp/Floe-M1-regression.log`、`/tmp/Floe-M1-window-test.log`、`/tmp/Floe-M1-lint.log`。临时文件可能被系统清理。

本轮没有操作真实菜单栏、清理 TCC、修改系统语言或执行长时资源实验。
M1 后续仍包括其他 C1/C2 报告、C3 权限与 C4 长时测量；未定位的报告保持原范围，不猜补丁。
