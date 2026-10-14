# M1 C2 全量核对与连续修复记录

日期：2026-10-14（Asia/Shanghai）。基线 `8d657fe`，首批开始工作区干净，连续处理承接首批未提交改动。C2 **45** 条，M1 **70** 条，总清单 **367** 条。本批不归档完整原报告、不改变 GitHub 状态。

## 首批布局空白修复（后续已扩展为混合发现）

布局页 `scanAndApply` 与 `rescanAfterDrag` 原先仅在 `itemCache.allItems.isEmpty` 时请求 AX fallback；但 `buildSections` 会过滤 Floe 自身的状态项和分隔符。缓存只有 Floe 项时，“缓存非空”阻止 AX 扫描，而“展示过滤”又没有剩余项目，导致布局空白。多次普通刷新或拖动后刷新仍走相同分支。

新增 `displayableCachedItems`，复用原展示过滤规则。两个扫描入口按过滤后的列表判断是否需要 AX，分区构建也使用同一列表，避免条件和展示规则分离。有效外国应用 CGS 项存在时仍优先使用 CGS；AX 未授权时不进入该扫描。缓存完全空时保留原 fallback。

不推断所有缺失图标都由这一个条件造成；CGS 部分可用但遗漏其他应用、AX 访问本身失败、分隔符未就绪、多屏坐标和拖拽操作仍是独立范围。

## 首批原报告与状态

通过主机已有 GitHub 授权刷新三条正文、状态与评论，均 open；证据保存于 [核对数据](c2-upstream-review.json)。

| Issue | 状态 | 尚未确认范围 |
| --- | --- | --- |
| [cavaldos/Ice#9](https://github.com/cavaldos/Ice/issues/9) | 部分修复 · own-only 缓存触发 AX fallback | 原报告包含布局空白及无法拖入隐藏/永久隐藏分区，未证明对应 macOS 27 配置已全部恢复。 |
| [jordanbaird/Ice#716](https://github.com/jordanbaird/Ice/issues/716) | 部分修复 · 同一布局空白路径 | 未确定该报告的真实缓存就是 only-own 状态，仍需原场景验证。 |
| [jordanbaird/Ice#677](https://github.com/jordanbaird/Ice/issues/677) | 已核对 · 持续加载继续调查 | 本批改布局页判断，未改浮栏 AX 请求生命周期；不能宣称浮栏持续加载已解决。 |

## 验证

新增 `layout-cache-fallback.swift` 编译生产有效缓存过滤、普通扫描与拖动后扫描方法，替换系统权限、AX 发现和分区展示依赖为受控夹具：

- 只有 Floe 项：两个入口均获得 AX 项目。
- 完全空缓存：原 AX fallback 保留。
- Floe + 外部应用缓存：保留外部 CGS 项优先级且过滤自身项。
- AX 未授权：不凭空加载 AX 项。

对照原扫描条件，同一回归在 only-own 普通刷新检查失败，修复后通过；日志 `/tmp/Floe-C2-fallback-before.log`。这验证扫描决策和数据传播，不代替真实 SwiftUI 布局渲染、AX 宿主或拖拽验收。

最终验证日志：`/tmp/Floe-C2-Debug.log`、`/tmp/Floe-C2-Release.log`、`/tmp/Floe-C2-regression.log`、`/tmp/Floe-C2-lint.log`。临时日志可能被清理。

macOS 15.8.1 / Xcode 26.3：Debug、Release 构建通过；全部 19 个回归脚本通过；SwiftLint 0.65.1 严格检查 117 个文件，0 violations；`git diff --check` 通过。

## 全量处理（45 条）

用户授权连续处理整个 C2 后，已通过主机 GitHub 授权刷新全部 45 条 issue 和评论，均仍 open，原文/评论存于核对数据。不是只核对首批 3 条；[机器状态索引](c2-status.json) 和下表逐条保留原问题范围与剩余条件。

### 本轮连续源码修复

1. **缓存有效性**：仅有 Floe 自身状态项不能阻止 AX fallback；展示与发现共用过滤规则。
2. **部分发现合并**：授权时同时发现 AX 项，保留 CGS 行并补入 AX 独有项；几何匹配去重，缺少坐标时只合并双方唯一的 PID/标题。多个同名项不会被吞掉，最终按实际位置排序。
3. **AX 预算公平与耗时**：256 节点改为每应用独立额度；项目发现单条 AX 消息超时 0.1 秒、每宿主遍历时间预算 1 秒。一个大树/慢宿主不消耗后续应用的额度。预算在树遍历检查点执行，最后一项的属性读取可能超过预算；不能取消卡住的系统 API，也不承诺整轮严格 1 秒。
4. **请求生命周期**：普通扫描、拖动后扫描使用请求代数；缓存/AX await 后和等待分隔符期间核对代数及取消状态；离开页面淘汰未完成请求。浮栏 AX 扫描取消后不发布旧行。
5. **AX-only 更新**：缓存重分类保留最近 AX 快照，页面可见时每 5 秒刷新，移动期间暂停此刷新，页面任务取消时退出。新启动/退出应用不再只能依靠 CGS 发事件或手动刷新。
6. **真实刷新与过期行**：布局刷新强制更新同 window ID 的元数据；完整扫描得到空结果时清除旧分组。同步首屏缓存阶段仍可保留既有行，避免扫描前闪烁。

### 源码调查中的独立条件

- #643 评论提供系统 Menu Bar → Allow in Menu Bar 的恢复线索，涉及 Stats 自己的系统可见性；本轮不重置第三方偏好、TCC 或宿主进程。
- #832/#891/#913 评论给出上游菜单栏 XPC 服务同 Team 签名回归。已搜索工程与源码，当前 Floe 没有 MenuBarItemService、Connection.sourcePID 或该 isFromSameTeam 发现路径；不照搬降低签名限制的补丁，更不因此判定所有空白已经解决。
- #623 全屏、#919 移除触发图标、#835 隐藏失效、#846/#872 退出/崩溃仍有独立验收范围。
- 只有图片或描述相似的报告，无法从截图确认具体 CGS/AX 返回。macOS 26/27、特定应用与真实多屏场景没有在当前 macOS 15 环境逐条复现。

### 逐条结果

下表“相关代码已修复”指对应共享路径的已验证缺陷，并非证明原报告全部由它造成。当前**完整确认归档 0 条，C2 保留 45 条**；已完成 45 条的实时核对、源码适用性检查与可验证的批量修复，未把无法复现的报告虚标为完成。

| Issue | 范围 | 本地状态 | 剩余条件 |
| --- | --- | --- | --- |
| [cavaldos/Ice#9](https://github.com/cavaldos/Ice/issues/9) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 布局空白与拖入隐藏/永久隐藏区须分别验收。 |
| [jordanbaird/Ice#283](https://github.com/jordanbaird/Ice/issues/283) | 部分/新应用图标缺失 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 | 需指定宿主的真实 CGS、AX、系统菜单栏允许状态与位置；未确认原报告属于预算耗尽或部分 CGS 状态。 |
| [jordanbaird/Ice#312](https://github.com/jordanbaird/Ice/issues/312) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#623](https://github.com/jordanbaird/Ice/issues/623) | 全屏与生命周期 | 相关代码已修复 · 迟到扫描/快照恢复 | 需全屏开关浮栏、返回设置的真实空间/屏幕时间线及宿主图标复测。 |
| [jordanbaird/Ice#643](https://github.com/jordanbaird/Ice/issues/643) | 系统菜单栏可见性 | 已核对 · 系统允许列表线索，未修改第三方设置 | 评论给出 System Settings → Menu Bar → Allow in Menu Bar 恢复线索；需 Stats 进程/系统可见性状态复现，Floe 无法凭空重建宿主状态项。 |
| [jordanbaird/Ice#655](https://github.com/jordanbaird/Ice/issues/655) | 部分/新应用图标缺失 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 | 需指定宿主的真实 CGS、AX、系统菜单栏允许状态与位置；未确认原报告属于预算耗尽或部分 CGS 状态。 |
| [jordanbaird/Ice#664](https://github.com/jordanbaird/Ice/issues/664) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#677](https://github.com/jordanbaird/Ice/issues/677) | 持续加载 | 相关代码已修复 · 发现预算/扫描生命周期 | 需原系统上 AX 消息耗时、CGS/AX 返回及权限快照；每宿主时间预算不能中断不遵守消息超时的系统 API，也不是整轮硬截止时间。 |
| [jordanbaird/Ice#679](https://github.com/jordanbaird/Ice/issues/679) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 同时包含浮栏症状，不能只验收布局页。 |
| [jordanbaird/Ice#682](https://github.com/jordanbaird/Ice/issues/682) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#685](https://github.com/jordanbaird/Ice/issues/685) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#687](https://github.com/jordanbaird/Ice/issues/687) | 持续加载 | 相关代码已修复 · 发现预算/扫描生命周期 | 需原系统上 AX 消息耗时、CGS/AX 返回及权限快照；每宿主时间预算不能中断不遵守消息超时的系统 API，也不是整轮硬截止时间。 |
| [jordanbaird/Ice#696](https://github.com/jordanbaird/Ice/issues/696) | 图片为主要证据 | 已核对 · 发现与布局路径修复，缺少具体根因 | 已有原图链接和版本信息；缺少可定位的发现/权限/线程数据，不从截图直接认定具体根因。 |
| [jordanbaird/Ice#710](https://github.com/jordanbaird/Ice/issues/710) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 同时包含浮栏症状，不能只验收布局页。 |
| [jordanbaird/Ice#711](https://github.com/jordanbaird/Ice/issues/711) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 同时包含浮栏症状，不能只验收布局页。 |
| [jordanbaird/Ice#716](https://github.com/jordanbaird/Ice/issues/716) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#730](https://github.com/jordanbaird/Ice/issues/730) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#741](https://github.com/jordanbaird/Ice/issues/741) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#743](https://github.com/jordanbaird/Ice/issues/743) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#744](https://github.com/jordanbaird/Ice/issues/744) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#753](https://github.com/jordanbaird/Ice/issues/753) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 永久隐藏项与权限重置场景需实际分区/授权快照。 |
| [jordanbaird/Ice#758](https://github.com/jordanbaird/Ice/issues/758) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#762](https://github.com/jordanbaird/Ice/issues/762) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 同时包含浮栏症状，不能只验收布局页。 |
| [jordanbaird/Ice#773](https://github.com/jordanbaird/Ice/issues/773) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#802](https://github.com/jordanbaird/Ice/issues/802) | 图片为主要证据 | 已核对 · 发现与布局路径修复，缺少具体根因 | 已有原图链接和版本信息；缺少可定位的发现/权限/线程数据，不从截图直接认定具体根因。 |
| [jordanbaird/Ice#816](https://github.com/jordanbaird/Ice/issues/816) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#818](https://github.com/jordanbaird/Ice/issues/818) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#832](https://github.com/jordanbaird/Ice/issues/832) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 评论指向上游 MenuBarItemService XPC 签名限制；当前 Floe 工程无该菜单栏 XPC 服务或 isFromSameTeam 路径，不能直接套用或降低安全要求。 |
| [jordanbaird/Ice#835](https://github.com/jordanbaird/Ice/issues/835) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 隐藏失效与布局空白需分开复现。 |
| [jordanbaird/Ice#846](https://github.com/jordanbaird/Ice/issues/846) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 点击后图标消失/退出仍需崩溃或控件生命周期证据。 |
| [jordanbaird/Ice#872](https://github.com/jordanbaird/Ice/issues/872) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 正文包含反复崩溃；需原始符号化栈，不能用布局修复替代。 |
| [jordanbaird/Ice#878](https://github.com/jordanbaird/Ice/issues/878) | 部分/新应用图标缺失 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 | 需指定宿主的真实 CGS、AX、系统菜单栏允许状态与位置；未确认原报告属于预算耗尽或部分 CGS 状态。 |
| [jordanbaird/Ice#891](https://github.com/jordanbaird/Ice/issues/891) | 部分/新应用图标缺失 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 | 需指定宿主的真实 CGS、AX、系统菜单栏允许状态与位置；未确认原报告属于预算耗尽或部分 CGS 状态。 |
| [jordanbaird/Ice#913](https://github.com/jordanbaird/Ice/issues/913) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 评论指向上游 MenuBarItemService XPC 签名限制；当前 Floe 工程无该菜单栏 XPC 服务或 isFromSameTeam 路径，不能直接套用或降低安全要求。 |
| [jordanbaird/Ice#916](https://github.com/jordanbaird/Ice/issues/916) | 图片为主要证据 | 已核对 · 发现与布局路径修复，缺少具体根因 | 已有原图链接和版本信息；缺少可定位的发现/权限/线程数据，不从截图直接认定具体根因。 |
| [jordanbaird/Ice#919](https://github.com/jordanbaird/Ice/issues/919) | 持续加载及控件移除 | 相关代码已修复 · 发现预算/扫描取消 | 除页面加载外，还需确认用户移除 Floe 图标后的控件、设置和发现状态；未以页面修复代替图标恢复。 |
| [jordanbaird/Ice#921](https://github.com/jordanbaird/Ice/issues/921) | 图片为主要证据 | 已核对 · 发现与布局路径修复，缺少具体根因 | 已有原图链接和版本信息；缺少可定位的发现/权限/线程数据，不从截图直接认定具体根因。 |
| [jordanbaird/Ice#951](https://github.com/jordanbaird/Ice/issues/951) | 图片为主要证据 | 已核对 · 发现与布局路径修复，缺少具体根因 | 已有原图链接和版本信息；缺少可定位的发现/权限/线程数据，不从截图直接认定具体根因。 |
| [jordanbaird/Ice#965](https://github.com/jordanbaird/Ice/issues/965) | 持续加载 | 相关代码已修复 · 发现预算/扫描生命周期 | 需原系统上 AX 消息耗时、CGS/AX 返回及权限快照；每宿主时间预算不能中断不遵守消息超时的系统 API，也不是整轮硬截止时间。 |
| [jordanbaird/Ice#973](https://github.com/jordanbaird/Ice/issues/973) | 布局空白/无法展示 | 相关代码已修复 · fallback/合并/刷新/快照 | 需原环境完整的 CGS/AX/分隔符/权限快照；相似空白现象不能直接认定同一根因。 |
| [jordanbaird/Ice#992](https://github.com/jordanbaird/Ice/issues/992) | 持续加载 | 相关代码已修复 · 发现预算/扫描生命周期 | 需原系统上 AX 消息耗时、CGS/AX 返回及权限快照；每宿主时间预算不能中断不遵守消息超时的系统 API，也不是整轮硬截止时间。 |
| [jordanbaird/Ice#999](https://github.com/jordanbaird/Ice/issues/999) | 图片为主要证据 | 已核对 · 发现与布局路径修复，缺少具体根因 | 已有原图链接和版本信息；缺少可定位的发现/权限/线程数据，不从截图直接认定具体根因。 |
| [jordanbaird/Ice#1003](https://github.com/jordanbaird/Ice/issues/1003) | 持续加载 | 相关代码已修复 · 发现预算/扫描生命周期 | 需原系统上 AX 消息耗时、CGS/AX 返回及权限快照；每宿主时间预算不能中断不遵守消息超时的系统 API，也不是整轮硬截止时间。 |
| [jordanbaird/Ice#1009](https://github.com/jordanbaird/Ice/issues/1009) | 持续加载 | 相关代码已修复 · 发现预算/扫描生命周期 | 需原系统上 AX 消息耗时、CGS/AX 返回及权限快照；每宿主时间预算不能中断不遵守消息超时的系统 API，也不是整轮硬截止时间。 |
| [jordanbaird/Ice#1010](https://github.com/jordanbaird/Ice/issues/1010) | 持续加载 | 相关代码已修复 · 发现预算/扫描生命周期 | 需原系统上 AX 消息耗时、CGS/AX 返回及权限快照；每宿主时间预算不能中断不遵守消息超时的系统 API，也不是整轮硬截止时间。 |

## 批量回归与边界

- `layout-cache-fallback.swift` 编译生产扫描/缓存过滤/补充合并方法：only-own/空缓存/部分缓存、CGS 优先保留、位置相同的代理去重、同名不同位置和无坐标歧义保留、AX 未授权、AX 快照重分类、同 ID 强制刷新、空结果清除、旧请求迟到及取消后不发布。
- `ax-item-press.swift` 编译完整生产 AX 发现/按压代码：前宿主 300 节点耗尽自己的额度后仍发现下一宿主；慢宿主时间预算后仍发现后宿主；原有精确按压/同名/匿名/过期项目测试保留。
- `ax-row-filter.swift` 编译生产浮栏扫描：取消扫描不发布行，原分隔符/全屏/parking spacer 分类回归保留。
- 夹具替换系统边界、发现响应和分区展示依赖；没有把夹具输出当作真实 SwiftUI 渲染、macOS 26/27 AX 行为或用户的原应用验收。
- 当前数量：C2 **45**、M1 **70**、总清单 **367**。未提交、未推送；不更改任何上游 issue 状态。

最终验证：当前 macOS 15.8.1 / Xcode 26.3 的 Debug、Release 构建通过；最终全部 19 个回归脚本通过；SwiftLint 0.65.1 严格检查 117 个文件，0 violations；`git diff --check`、45 条状态/原文/索引一致性及本地审计链接核验通过。AX 截断树回归同时确认不会把未读完的根 wrapper 当作图标。
