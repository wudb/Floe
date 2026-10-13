# M0 工程与证据基线核对

核对日期：2026-10-13（Asia/Shanghai）。源码基线：`e0001d6`。仅更新本地处理记录，不修改上游状态。

## 处理口径

M0/B1 共 9 条，本轮全部完成正文、后续评论、实时状态及当前实现的初步核对。
**完整修复 0 条；部分修复 1 条（#1006 的本地 ad-hoc 启动）；9 条保留待处理。** 工程基线补齐不代表报告的故障已经消失。
“待实机验证”“待材料”“不采用报告实现”均不能作为已修复标记或删除依据。
采集记录见 [实时核对数据](m0-upstream-review.json)，复现使用 [统一模板](issue-reproduction-template.md)。

## 支持与验证矩阵

| 环境 | 工程范围 | 本轮实际证据 | 验证边界 |
| --- | --- | --- | --- |
| macOS 14/15 | Deployment target 14.0；CGS 发现与 AX fallback | macOS 15.8.1 (24H32)、arm64、Xcode 26.3 (17C529) 的 Debug/Release 构建与受控回归通过 | 14、Intel、真实菜单操作和多屏未验证 |
| macOS 26 | 现有 CGS/AX 路径；不能仅凭 fallback 声称兼容 | 核对 #633/#833 的上游版本及 beta 修复线索 | 当前主机无法运行对应系统；展开崩溃、布局/浮栏需实测 |
| macOS 27 | 有 AX fallback，无 PR #995 的 assessment assertion 和布局实现 | 核对 #954/#991 与 PR #995；源码未检出 Concealer27、MacOS27Layout | 图标发现不等于能够隐藏；不能宣称 27 全功能支持 |
| 本地签名 | `com.wudb.Floe`；ad-hoc 独立于上游身份 | 本轮构建采用 `CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM=`；Debug 自动禁用 runtime；原始 Release 保留 runtime 并复现 dyld 退出，修复后显式关闭 | codesign 验证不证明 dyld 启动或 TCC 授权有效；Developer ID/公证未验证 |

新诊断脚本 `bash script/collect-issue-evidence.sh [/absolute/path/Floe.app]`
采集系统/build、架构、Xcode、提交、工作区、SPM 锁定、Floe 偏好、进程和指定应用签名。
输出使用唯一临时目录，各项退出码独立保留；不启动应用、不更改权限或默认设置。
签名和进程可采集，真实 TCC 检测、发现路径、显示器/菜单交互仍须在模板中填写。

## 逐条标记

下列链接均指向 `jordanbaird/Ice`；本轮实时 API 返回的 9 条 issue 均为 open。

| Issue | 本地标记 | 调查结论与下一步验收 |
| --- | --- | --- |
| [#633](https://github.com/jordanbaird/Ice/issues/633) | 已核对 · 待 macOS 26 实机验证 | 正文有明确步骤：26 beta5、Ice 0.11.12，启动折叠正常，点击小箭头退出。评论称 0.11.13-dev.1 修复，但不能推断 Floe 已通过。在对应系统保留崩溃 .ips，分别验证原生展开与 Floe Bar；定位后进入 M1/C1。 |
| [#954](https://github.com/jordanbaird/Ice/issues/954) | 已核对 · 待 macOS 27 实机验证 | 27 beta1、0.11.13-dev.2，升级后所有图标可见。当前没有 #995 隐藏方案，不能用 AX 发现测试代替隐藏验收。验证隐藏/显示真实状态、发现列表与权限后进入 M1/C2 或 M2/I2。 |
| [#957](https://github.com/jordanbaird/Ice/issues/957) | 已核对 · 待安装来源与复现材料 | 声称 Brew 版本 3.8.2 与当前工程 0.11.12 不一致；不能直接认定同一应用。补 cask 名称、Bundle ID、实际版本与设置入口操作。当前非阻塞权限 UI 也不能证明此报告已修复。 |
| [#991](https://github.com/jordanbaird/Ice/issues/991) | 已核对 · 待 macOS 27 实机验证 | 只描述系统升级后基本不可用，评论提供 #995 分支。该 PR 当前 open、未合并；先分别记录发现、隐藏、布局与点击失败点，再定位工作包。 |
| [#833](https://github.com/jordanbaird/Ice/issues/833) | 已核对 · 待截图判读及 macOS 26 实机验证 | 正文并非完全无步骤：26.1、0.11.12，设置页与浮栏不可用；评论称 dev.2 可用。图片尚未完成像素判读，需明确空白/加载/点击的具体状态；对应 M1/C2 和 M2/I3 场景分别复测。 |
| [#1006](https://github.com/jordanbaird/Ice/issues/1006) | 部分修复 · ad-hoc 启动；布局实现不采用 | `MacOS27Layout` 迁移仅针对 #995；当前无此存储键。其 ad-hoc Sparkle 启动问题已在本机 Release 复现（dyld different Team IDs、退出 -6）。本地脚本和现有 ad-hoc Release workflow 显式关闭 hardened runtime；dev.sh 缺失证书回退时同步重签身份。布局部分仍不适用，保留条目。评论给出分支修复 `10736eb`/`1a1be7b`，不等于 Floe 修复。 |
| [#1007](https://github.com/jordanbaird/Ice/issues/1007) | 已核对 · 不采用报告实现；现象待实测 | 3 pt 状态项来自 #995 concealment assertion；当前无 Concealer27。评论给出分支修复 `4f1d700`。在 27 上仍应覆盖隐藏期间重启 AlDente，记录真实 AX 宽度；不能把实现不同当作故障不存在。 |
| [#1014](https://github.com/jordanbaird/Ice/issues/1014) | 已核对 · 不采用报告实现；现象待实测 | #995 在解除 assertion 后按原坐标重放系统点击，目标移动导致误点；Floe 无该桥接路径。需要在 27 将 Macs Fan Control 放在电池旁，分别核验 Wi-Fi/电池命中；不能据此改 Floe 的其他点击路径。 |
| [#920](https://github.com/jordanbaird/Ice/issues/920) | 已核对 · 待材料 | 实时正文为 null、无评论，标题为模板检查项，无法建立最小复现。保留条目；至少补现象、系统/应用版本、步骤与日志后再定级。 |

## P0 首轮调查（不计入 M0 的 9 条）

按里程碑要求同时刷新 [#908](https://github.com/jordanbaird/Ice/issues/908)、
[#968](https://github.com/jordanbaird/Ice/issues/968)、[#974](https://github.com/jordanbaird/Ice/issues/974)，均仍 open。
当前没有证据证明 Floe 已复现或导致系统级异常，P0 级别和待调查状态保留。

- #908：26.4，连续约 33 小时后分隔符丢失、scene 循环及冻结；没有可靠最小复现。后续至少 36 小时同环境对照，记录 Floe/WindowServer 内存、窗口、捕获与线程日志。本轮构建/回归不是长时结果。
- #968：26.5.2，HTML select/NSPopUp、Dock 自动隐藏、HideApplicationMenus/hover/AutoRehide 组合。分别在 Floe 退出、开启、逐项关闭配置下对照，记录宿主版本及其他 AX 客户端；不要与应用 File/Edit 菜单混为一项。
- #974：应用菜单残留；作者最新评论纠正了两次非同步快照产生的误报，延迟 2 秒复核后仍有事件，但无法确认移除 Ice 的日期，因此不是已成立的无 Ice 对照。保留因果未证实结论，不降级或标修复。

若出现不可恢复菜单/弹窗，先保存工作与操作时间，退出 Floe，再检查宿主是否恢复；必要时通过系统 Force Quit 处理受影响宿主。不要自动强杀 Finder/Dock 或清除 TCC。系统无响应时终止当前复现，保存可获得的 crash/panic 材料。

## 本轮工程验证

- #1006 本地启动部分：修复前 Release 实际启动退出 -6，dyld 报 Sparkle different Team IDs；修复后 Release 构建通过，签名 flags 从 `adhoc,runtime` 变为 `adhoc`，实际进程存活 5 秒后仅终止测试进程，日志 `/tmp/Floe-M0-launch-fixed.log`。这是启动 smoke 验证，不能代替权限、隐藏/点击或长期稳定性验收。修复构建日志 `/tmp/Floe-M0-Release-fixed.log`。
- Debug/Release：通过；日志 `/tmp/Floe-M0-Debug.log`、`/tmp/Floe-M0-Release.log`；产物 `/tmp/Floe-M0-build/Build/Products/`。临时文件可能被系统清理，结论与环境记录在本文。
- 7 个现有受控脚本全部通过：app-language、ax-activation、ax-item-press、ax-row-filter、floe-bar-position、item-discovery、menu-bar-ax-probe。验证使用受控服务，不冒充真实菜单交互。
- SwiftLint：主机未安装；临时下载官方 portable 0.65.1，与 CI 一致，严格 lint 通过（116 个文件、0 violations），日志 `/tmp/Floe-M0-lint.log`。
- 诊断脚本：`bash -n` 与 Debug 应用采集通过；未安装 SwiftLint、没有 Floe 进程/偏好时保留非零采集状态。
- 构建有既存警告（颜色选择器 switch 穷尽性、overlay 未使用变量、AppIntents metadata 跳过），未在本轮改动无关逻辑。

M0 状态：工程、lint 与材料格式已补齐，逐条初审完成；26/27 实机证据尚缺，阶段保持进行中。
