# M1 / C0 系统级异常防护

日期：2026-10-14（Asia/Shanghai）。承接 [M1 首批记录](m1-issue-audit.md)，包含当前未提交工作区。
范围：`jordanbaird/Ice#908`、`jordanbaird/Ice#968`、`jordanbaird/Ice#974`。
**3 条均保留 P0；完整确认修复 0 条。** 本轮修复可定位的交互/重复更新风险，不将它们直接写成上游系统冻结、panic 或残留窗口的确定根因。

## 实时证据

通过主机 GitHub API 刷新报告和全部评论：三条仍 open，更新时间未变化。
#908 无可靠最小复现、观察约 33 小时；#968 涉及原生表单 popup 而非 File/Edit 菜单；
#974 作者已更正非同时 CG/AX 快照的误报，其现有证据仍不能确定 Ice 的因果。
本轮没有修改上游标签或状态，没有运行会故意触发系统卡死的实验。

## 已实施修复

### 菜单交互期间避免自动干预（#968 / #974 风险链路）

- `MenuInteractionGuard` 在主线程读取聚焦元素及其最多六层祖先，识别 Menu/MenuItem/Popover。
- 采用独立 AX 引用、20 ms 消息超时及 100 ms 遍历时间预算，避免用默认长超时访问无响应宿主。
- AX 焦点未跟随 popup 或无法读取时，检查前台宿主的可见 popup-menu 层窗口。
  这是保守的“先不自动干预”信号，不是孤儿菜单诊断；不关闭、不点击、不修改其他应用的窗口。
- 自动 hover/智能/计时重新隐藏统一经过保护，显式用户隐藏仍可执行。
- 被保护拒绝隐藏时也清除已触发计时器，使弹窗关闭后的鼠标移动能够重新调度。
- 自动隐藏应用菜单的入口同样经过保护，已隐藏时不重复激活 Floe。
- 该自动激活路径直接激活 Floe，不经过首次激活时的 Dock 绕行；设置/权限等显式 UI 激活仍保留原默认流程。
- 恢复应用菜单时优先把焦点交还此前的宿主；宿主已退出时使用原 fallback。

当前保护覆盖标准 AX 菜单和前台原生 popup 层。未移动 AX 焦点、未使用 popup 层的第三方自定义面板可能仍需独立适配。
CG 窗口列表本身是同步系统查询，AX 时间预算不等于整个方法严格实时上限。

### 降低重复发现和辅助 scene 更新（#908 风险链路）

- 菜单项发现扫描跨 await 防重入，同一时刻只运行一轮；期间的强制刷新合并后补做，普通重复触发直接合并。
- `ControlItem` 比较实际状态项长度，仅在长度变化时写给 AppKit，避免相同状态重复发布后反复提交长度更新。
- 保留既有分隔符失效 → 清空 CGS 缓存 → AX fallback，不盲目重建状态项或向 Control Center 反复发送激活事件。
- 已有安全窗口 ID 转换和前一批有界后台截图继续保留。

这些变化减少代码里的重入与重复更新，但没有证明 #908 的 FrontBoard scene 循环就是上述写入触发。
因此没有降级、删除报告，也没有宣称 kernel panic 已修复。

## 逐条状态

| Issue | 本地标记 | 尚未完成 |
| --- | --- | --- |
| [jordanbaird/Ice#908](https://github.com/jordanbaird/Ice/issues/908) | 防护已实现 · 扫描合并/状态项更新去重 | 相同配置至少 36 小时启停对照，Floe/WindowServer 资源、线程及 scene 时间线；系统冻结因果未确认。 |
| [jordanbaird/Ice#968](https://github.com/jordanbaird/Ice/issues/968) | 防护已实现 · popup 跟踪/焦点切换保护 | Helium 等真实 HTML select/NSPopUp 与 Dock 自动隐藏场景、其他 AX 客户端组合复测；宿主自身崩溃因果未确认。 |
| [jordanbaird/Ice#974](https://github.com/jordanbaird/Ice/issues/974) | 防护已实现 · 菜单跟踪期间避免自动干预 | 同环境菜单跟踪对照；CG/AX 两次快照至少间隔 2 秒复核，不能把两次采样间正常关闭当作孤儿菜单。 |

没有 macOS 26/27 实机环境不阻止继续源码开发，但相应系统级结论保持未验证。
发生异常时先保存其他应用工作和时间线，退出 Floe 后对照；本轮不自动强杀 Finder/Dock 或修改 TCC。

## 验证

- Debug/Release 构建通过；严格 SwiftLint 0.65.1 通过。
- 新增 `menu-interaction-safety.swift` 编译生产 guard 与实际隐藏/恢复、长度设置方法：
  菜单/子菜单/Popover、AX 不可用时前台 popup、普通窗口和其他进程过滤、100 次重复隐藏只激活一次且不经过 Dock、原宿主恢复、500 次相同长度仅写一次。
- `ax-activation.swift` 扩展并通过：其他应用 popup 防止自动隐藏、被保护的计时器可恢复、显式隐藏可用；原浮栏激活/菜单生命周期全部通过。
- `item-discovery.swift` 扩展并通过：50 次重入触发不重叠，强制刷新在当前扫描结束后补做；原发现恢复全部通过。
- 前一批其他受控回归结果见 M1 记录；本轮未操作真实系统菜单、未执行长时资源对照。
- 日志：`/tmp/Floe-C0-Debug.log`、`/tmp/Floe-C0-Release.log`、`/tmp/Floe-C0-regression.log`、`/tmp/Floe-C0-lint.log`。

待处理数量保持：C0 **3**、M1 **82**、总清单 **379**。
