# 上游 Issue 修复核对记录

审计时间：2026-10-13T15:17:39+08:00（Asia/Shanghai）。

2026-10-13 M0 补充：[M0 核对与验证](m0-issue-audit.md) 已记录 9 条初审和 #1006 的本地 ad-hoc 启动部分修复（实际启动前后对照通过）。该 issue 的布局要求未整体验收，因此不加入下方删除清单；保留总数仍为 380。后续完整修复继续记录依据与验证边界，再同步清理各索引。

审计对象为当前 Floe 工作区，基线提交 `82be80fea77edd89f34a43ddfbc677234a416dee`，包含尚未提交的 Floe 改名和更新源隔离改动。原始采集时点仍为 2026-10-13T14:04:27+08:00。

## 结果与判定口径

| 仓库 | 审计前 | 已修复/已满足并删除 | 当前保留 |
| --- | ---: | ---: | ---: |
| cavaldos/Ice | 5 | 1 | 4 |
| jordanbaird/Ice | 397 | 34 | 363 |
| 合计 | 402 | 35 | 367 |

删除仅作用于 `docs` 的本地待处理清单、分类总结和 JSON 数据，不更改 GitHub 状态。22 条删除候选已通过主机 GitHub API 再次核对，当前仍全部是 `open`，标题和正文与原始采集一致。它们是在 Floe 中有对应修复或已满足需求，不能据此宣称上游 Ice 已修复。

对照报告的完整标题和正文、当前代码路径及提交记录；只出现相似现象、只找到兜底代码、只改善一个子问题、只绕开了另一条分支，均不足以认定整条已修复。缺少明确复现信息或必须依赖真实应用/显示器/系统版本验证的报告保留。功能请求和使用问答若已被当前界面或文档直接满足，也从本地待处理清单移除。

这里的“已修复”是代码与配置层面的判定；没有对 402 条进行逐条实机复现。现有回归运行的是受控场景；新增迁移核验从生产方法提取，仅替换 macOS availability 条件来检查 26/27 两条逻辑分支，未冒充 macOS 27 实机结果。

## M1 补充归档（2026-10-14）

[jordanbaird/Ice#925](https://github.com/jordanbaird/Ice/issues/925) 的 [符号化根因评论](https://github.com/jordanbaird/Ice/issues/925#issuecomment-5325109637) 明确定位 `ControlItem.windowID` 将 4294967296 转为 UInt32 的溢出 trap，而不是已确认的并发 race。当前 `ControlItem.swift:98` 已采用 `CGWindowID(exactly:)`，浮栏另一转换点也采用 failable initializer；Dynamic/图标定位在 nil ID 时走已有 frame fallback。新增 `script/tests/window-id.swift` 编译生产 getter，验证缺失/负值/UInt32.max+1/Int.max/正常值；现有 `floe-bar-position.swift` 验证 nil ID 定位。代码层确认该特定根因已解决，从本地清单删除；未执行 macOS 26 实机验收，不推广为 #840/#905 或全部启动崩溃已修复。累计删除 23、保留 379；完整 M1 记录见 [M1 审计](m1-issue-audit.md)。

## C1 补充归档（2026-10-14）

[jordanbaird/Ice#563](https://github.com/jordanbaird/Ice/issues/563) 已通过匹配的 0.11.12 发布产物 UUID、470828 偏移指令与标签源码确认空数组 `removeFirst()` 根因；缺失隐藏分隔符时临时显示列表会被 trimPrefix 清空。Floe 修复为先确认分隔符边界，缺失则安全结束，正常排序保留。生产方法回归通过。详细 [C1 审计](c1-issue-audit.md) 与 [静态证据](c1-evidence/jordanbaird-Ice-563-static-audit.md) 保存原文入口、UUID、哈希和验证边界；未运行上游应用或完成 macOS 26/27 实机验收。累计本地删除 **24**、当前保留 **378**，GitHub 状态不修改。

## C1 窗口 ID 溢出补充归档（2026-10-14）

[jordanbaird/Ice#669](https://github.com/jordanbaird/Ice/issues/669)、[jordanbaird/Ice#779](https://github.com/jordanbaird/Ice/issues/779)、[jordanbaird/Ice#810](https://github.com/jordanbaird/Ice/issues/810)、[jordanbaird/Ice#821](https://github.com/jordanbaird/Ice/issues/821)、[jordanbaird/Ice#867](https://github.com/jordanbaird/Ice/issues/867)、[jordanbaird/Ice#880](https://github.com/jordanbaird/Ice/issues/880)、[jordanbaird/Ice#947](https://github.com/jordanbaird/Ice/issues/947) 的原报告正文各自包含匹配官方 0.11.12 的 arm64 UUID、51508/0xC934 崩溃偏移、x19=4294967296。匹配指令明确在读取 windowNumber 后因高 32 位非零而 trap，根因为 Int→UInt32 非安全转换。Floe 两个转换点已继承 `CGWindowID(exactly:)`；新增针对原始报告值的生产 getter 与浮栏 observer 表达式回归均通过，nil-ID 定位 fallback 通过。不是新增 7 个补丁，而是确认已有修复完整覆盖这 7 条具体崩溃签名。逐条原文/评论保留在 C1 核对快照，[静态证据](c1-evidence/window-id-static-audit.md) 与 [机器签名](c1-evidence/window-id-crash-signatures.json) 可复核。未运行上游应用或宣称 macOS 26/27 全系统验收。当前累计删除 **31**、保留 **371**；其余 C1 **21** 仍独立调查。

## C1 附件核对补充归档（2026-10-14）

[jordanbaird/Ice#796](https://github.com/jordanbaird/Ice/issues/796) 与 [jordanbaird/Ice#905](https://github.com/jordanbaird/Ice/issues/905) 的原始崩溃附件均匹配官方 binary UUID、0xC934 与 x19=4294967296。两个生产窗口 ID 转换点的原值回归及 nil-ID 定位通过，按相同代码层口径确认已继承修复并归档。#905 的并发 race 推断不由原始指令支持；本次明确记录实际整数溢出根因。证据保留于 [C1 审计](c1-issue-audit.md) 和附件/机器签名。当前累计本地删除 **33**、保留 **369**，C1 **19**。未更改上游状态或完成 macOS 26/27 全场景验收。

## C1 启动/浮栏溢出补充归档（2026-10-14）

[jordanbaird/Ice#603](https://github.com/jordanbaird/Ice/issues/603) 作者提供的 dev.1 原始附件与官方产物 UUID 3781D582-B6AF-366C-B5A0-266BF26B7919 匹配；744444/0xB5BFC 首帧由 windowNumber 高 32 位非零检查触发，x0=8589934592。[#742](https://github.com/jordanbaird/Ice/issues/742) 原报告则精确匹配 0.11.12 的 0xC934/x19=4294967296。两个生产转换点和 nil-ID 定位回归通过，确认已继承修复并归档。详细 [静态证据](c1-evidence/jordanbaird-Ice-603-static-audit.md) 和 [C1 审计](c1-issue-audit.md) 保存版本区别，不混用地址。当前累计删除 **35**、保留 **367**，C1 **17**；没有新增生产补丁或 macOS 26/27 全场景验收结论。

## 删除依据

| Issue | 问题/需求 | 当前覆盖与删除理由 | 证据入口 | 验证 |
| --- | --- | --- | --- | --- |
| [cavaldos/Ice #17](https://github.com/cavaldos/Ice/issues/17) | 启动时图标消失 | MigrationManager.seedRevealSections27 在分区构造前同步显示三个分区；旧迁移标志的纠正分支补救历史状态，已完成迁移后不覆盖用户选择。 | [Floe/Utilities/MigrationManager.swift:375](../Floe/Utilities/MigrationManager.swift#L375)：`seedRevealSections27` | 源码路径核对；5 个提取自生产方法的迁移行为场景通过。 |
| [jordanbaird/Ice #38](https://github.com/jordanbaird/Ice/issues/38) | 可调整圆角半径 | Corner Radius 滑块范围为 0...1，绑定配置并传入预览和实际形状绘制；支持从直角到完全圆角。 | [Floe/MenuBar/Appearance/MenuBarAppearanceEditor/MenuBarShapePicker.swift:34](../Floe/MenuBar/Appearance/MenuBarAppearanceEditor/MenuBarShapePicker.swift#L34)：`cornerRadiusSlider` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #82](https://github.com/jordanbaird/Ice/issues/82) | 纯黑菜单栏背景 | Tint Opacity 可设到 100%；solid 分支使用选定颜色按全不透明度填充，选择黑色和 Full 形状即可提供纯黑背景。覆盖层位于菜单栏背景之上、状态图标之下。 | [Floe/MenuBar/Appearance/MenuBarOverlayPanel.swift:2021](../Floe/MenuBar/Appearance/MenuBarOverlayPanel.swift#L2021)：`MenuBarTintView.draw / updateChrome` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #392](https://github.com/jordanbaird/Ice/issues/392) | 间距设置重新打开后显示错误 | GeneralSettingsManager 从偏好设置加载 itemSpacingOffset；界面 onAppear 将临时滑块值同步为已保存值，并在管理器变化时同步，修复重新打开界面后回到 0 的显示问题。 | [Floe/Settings/SettingsPanes/GeneralSettingsPane.swift:340](../Floe/Settings/SettingsPanes/GeneralSettingsPane.swift#L340)：`itemSpacingOptions onAppear` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #444](https://github.com/jordanbaird/Ice/issues/444) | 布局页图标异常放大 | 布局页改用系统符号或应用图标；应用图标通过 resizable/scaledToFit 限制在 26×26 点，外围单元格固定尺寸，消除了按原始图片尺寸放大的旧布局路径。 | [Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift:188](../Floe/Settings/SettingsPanes/MenuBarLayoutSettingsPane.swift#L188)：`itemView` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #610](https://github.com/jordanbaird/Ice/issues/610) | 较小圆角菜单栏样式 | Corner Radius 滑块可选择 0...1 的中间值，实际绘制用该比例乘以高度的一半，满足较小圆角或自行设定半径的需求。 | [Floe/MenuBar/Appearance/MenuBarAppearanceEditor/MenuBarShapePicker.swift:34](../Floe/MenuBar/Appearance/MenuBarAppearanceEditor/MenuBarShapePicker.swift#L34)：`cornerRadiusSlider` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #681](https://github.com/jordanbaird/Ice/issues/681) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #688](https://github.com/jordanbaird/Ice/issues/688) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #699](https://github.com/jordanbaird/Ice/issues/699) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #785](https://github.com/jordanbaird/Ice/issues/785) | Sparkle 版本过旧 | Package.resolved 已锁定 Sparkle 2.9.6，当前构建解析版本也是 2.9.6，不再使用报告中的 2.6.4。此结论仅确认版本更新，不宣称该依赖不存在任何安全问题。 | [Floe.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved:23](../Floe.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved#L23)：`sparkle pin` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #837](https://github.com/jordanbaird/Ice/issues/837) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #881](https://github.com/jordanbaird/Ice/issues/881) | 更换应用名 | 工程、Target、Scheme、应用可执行文件、显示文案和发布产物均已改名为 Floe；构建产物 CFBundleName/CFBundleExecutable 为 Floe。 | [Floe.xcodeproj/project.pbxproj:83](../Floe.xcodeproj/project.pbxproj#L83)：`Floe target / productName` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #882](https://github.com/jordanbaird/Ice/issues/882) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #892](https://github.com/jordanbaird/Ice/issues/892) | 关闭菜单栏右键浮层 | Advanced 界面提供 Show context menu on right click 开关，值被持久化；handleShowRightClickMenu 在开关关闭时直接返回，事件监视器仍原样返回事件。 | [Floe/Events/EventManager.swift:335](../Floe/Events/EventManager.swift#L335)：`handleShowRightClickMenu` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #912](https://github.com/jordanbaird/Ice/issues/912) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #926](https://github.com/jordanbaird/Ice/issues/926) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #931](https://github.com/jordanbaird/Ice/issues/931) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #932](https://github.com/jordanbaird/Ice/issues/932) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #937](https://github.com/jordanbaird/Ice/issues/937) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #949](https://github.com/jordanbaird/Ice/issues/949) | 卸载说明 | README 的 Uninstall 已提供退出 Floe、删除 Floe.app 及可选删除 com.wudb.Floe.plist 的说明；该使用问答在当前项目文档中已满足。 | [README.md:64](../README.md#L64)：`Uninstall` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |
| [jordanbaird/Ice #969](https://github.com/jordanbaird/Ice/issues/969) | 更新弹窗不响应或反复出现 | 当前 Floe 未配置更新源和公钥，performSetup/checkForUpdates 均提前返回，不启动 Sparkle；即使将来启用更新，权限提示委托明确返回 false，交互式更新前先激活应用。删除的是当前构建中已消除的弹窗入口，不代表未来更新分发流程已经实机验证。 | [Floe/Updates/UpdatesManager.swift:22](../Floe/Updates/UpdatesManager.swift#L22)：`isUpdateFeedConfigured / updaterShouldPromptForPermissionToCheck` | 源码控制流核对；上轮构建产物 Info.plist 无 SUFeedURL/SUPublicEDKey，SUEnableAutomaticChecks 为 false。 |
| [jordanbaird/Ice #1004](https://github.com/jordanbaird/Ice/issues/1004) | 权限窗口阻塞启动 | 启动时先完成 AppState.performSetup，再显示非阻塞权限窗口；窗口允许关闭，Continue/Continue in Limited Mode/Skip for Now 均可进入设置。屏幕录制为可选权限，授权检测不再阻止整个应用启动。这里确认解除启动阻塞，不代表自动修复 TCC 签名失配或替用户授予权限。 | [Floe/Permissions/PermissionsView.swift:134](../Floe/Permissions/PermissionsView.swift#L134)：`continueButton / continueButtonText` | 完整报告与源码/UI/配置逐项核对；上轮 Debug 构建成功。 |

## 验证结果

- 5 个现有回归脚本全部通过：item-discovery、floe-bar-position、ax-row-filter、ax-item-press、ax-activation。验证空缓存恢复、分隔符缺失、定位、选择准确性以及激活/重新隐藏生命周期。
- 启动迁移的 5 个受控场景通过：首次启动、已存旧隐藏状态、错误旧迁移标志、完成迁移后的用户选择不被覆盖，以及低于 macOS 27 时不触发恢复。
- Floe Debug 构建成功；提交前 Release 构建及 SwiftLint 0.65.1 严格检查也通过。SwiftLint 使用临时目录中的官方二进制，不安装到系统。
- JSON、原文清单和分类索引的数量及 issue 身份一致；保留条目的原始 JSON 对象、标题和正文不变。

## 已有改善但仍保留的代表条目

| Issue/主题 | 保留原因 |
| --- | --- |
| cavaldos/Ice #5 | 仍缺少外接屏合盖模式的真实隐藏行为验证；单个 NSStatusItem 的长度和屏幕选择不能证明所有屏幕正常。 |
| cavaldos/Ice #9、#12、#24 | AX 发现、拖拽重试和点击保护是改善，但分隔符位置和实际隐藏仍依赖系统行为；无法从提交标题推断全部复现场景已解决。 |
| jordanbaird/Ice #452、#621、#729、#857 | AX 受控测试不覆盖所有 CGS 分支、Live Activities、第三方自定义弹窗和多实例应用。 |
| jordanbaird/Ice #38/#610 以外的外观报告 | 可调整半径并不能证明多屏/全屏渲染、阴影、Mission Control 和截图里的所有像素问题均已修复。 |
| jordanbaird/Ice #651 | 透明度和背景层已有实现，但其额外 Mission Control 行为等要求未完整确认，不能整条删除。 |
| jordanbaird/Ice #840、#905、#925 等崩溃报告 | CGWindowID(exactly:) 避免整数转换陷阱，但缺少足够的符号化栈或实机结果证明报告中的所有崩溃都是该根因。 |
| jordanbaird/Ice #530、#777、#819、#908、#968、#974 | 长时内存增长、系统冻结与窗口残留需要对应环境验证；源码中的缓存节流不是完整修复证据。 |
| jordanbaird/Ice #1006、#1007、#1014 | 报告绑定 PR #995 的另一套实现；当前没有其类名不等于修复了其缺陷。 |
| 本地化、Profiles/分组、按屏幕配置、CLI/API、默认图标位置、Homebrew 提交等 | 未找到完整实现，或只存在占位、部分能力/配置入口，继续保留。 |
| 感谢、项目维护状态、上游网站/证书反馈 | 不属于可由本地源码认定已 fix 的报告，不因改名或换链接就当作原报告解决。 |

## 后续刷新

新收集上游 open issues 时，应先对照本记录，避免把本项目已满足的相同条目重新放入待处理清单；代码或更新配置发生变化后重新复核。当前被保留的条目有了明确复现与修复证据后，再同时更新三份清单数据及本记录。
