# M2 逐条核对与代码优化

日期：2026-10-14。M2 保留 63 条（I1 17、I2 31、I3 13、I4 2）。使用主机 GitHub 授权刷新全部 issue 原文及完整分页评论，均为 open，见 [核对快照](m2-upstream-review.json)。不以 open 状态证明 Floe 存在同一缺陷，不修改上游状态，不移除尚未完成原场景验收的条目。

## 首轮分析与实施顺序（后续结果见下文）

| 批次 | 工作包 | 源码事实与风险 | 实施目标 | 验收门槛 |
| --- | --- | --- | --- | --- |
| 1 | I1 拖拽结果 | 布局页通过 Command-drag 改动真实位置，重扫并最多重试 3 次；跨分区原先只验证归属，未验证插入顺序。 | 首批修复跨分区排序判定；后续处理拖拽失败反馈、页面离开后的任务取消和扫描与拖拽互斥。 | 不只观察 UI；核对真实图标位置、稳定后快照和指定邻接顺序。 |
| 2 | I2/I3 延迟交互 | EventManager 点击、智能收起、悬停有延迟 Task；已有菜单保护，但延迟期间设置、位置和用户意图可能改变。 | 审计触发时快照、执行时复核及取消；同类请求协调，避免旧任务覆盖新选择。 | 延迟期间手动展开/收起、切换设置、移动指针、打开菜单和停用监视器；延迟为 0 及快速重复操作。 |
| 3 | I3 菜单完整生命周期 | FloeBar AX 激活与 itemManager CGS 临时显示是不同路径；M0/M1 已有恢复与有界等待保护。 | 分别核验菜单、子菜单、自定义弹窗、无菜单应用、失败及取消后的恢复。 | 菜单操作期间不收起；鼠标位置/可见性恢复；用户的新分区选择不被旧恢复操作覆盖。 |
| 4 | I1 重建与持久化 | 现有页面快照与扫描 ID 不能直接当作跨进程稳定身份；系统菜单栏排序与分区展开偏好是不同状态。 | 先复现退出/登录/宿主更新后的归属变化，再确定稳定身份和恢复策略，避免盲目自动拖拽。 | 应用更新重建状态项、多状态项同名、启停 always-hidden、退出/重启 Floe 及宿主应用，均记录前后真实位置。 |
| 5 | I4 能力范围 | 首轮核对时源码未找到独立搜索入口；#668 同时报告名称为 Item-0 和浅色图标对比度，#673 为搜索列表空白。 | 名称识别纳入发现链路；独立搜索能力另行确定范围，图标对比度联动 M4。 | 先明确可用入口，再验证 AX/CGS 名称与空结果；不能用布局页非空宣布搜索修复。 |

建议优先保证一次交互的真实结果，再处理自动触发之间的竞争，最后处理跨重启恢复。M1 的发现链路已有改进，但 M1 整体尚未完成；M2 测试应明确发现是否成功，避免把扫描失败误归为移动失败。系统模式与多屏的公共修复留在 M3，M2 的核心复现可以提前核验。

## 首批代码修复

`MenuBarLayoutSettingsPane.hasLanded` 对所有目标分区统一验证源项目紧邻目标项之前。以前跨分区落在组尾也会返回成功，导致剩余重试被跳过；现在排序不符继续使用已有重扫/重试流程。同分区已有邻接检查保持一致。此项仅修复成功判定，不证明 Command-drag 在所有系统版本能成功，也不解决宿主重建后的布局保存。

相关报告为 cavaldos/Ice#24 及 I1 排序/归属问题；#24 原文为拖到 Hidden 后回到 Visible，并非本批错误排序判定的精确复现，因此继续待真机验证。

## 验证与边界

- `swift script/tests/layout-drop-order.swift` 通过：直接编译生产判定，覆盖三个目标分区、正确邻接、逆序、间隔其他项、缺失源/目标、空组及错误分区。
- `swift script/tests/layout-cache-fallback.swift` 通过：既有生产布局缓存合并与迟到扫描保护回归。
- Debug 构建通过（关闭签名，仅验证编译），日志 `/tmp/Floe-M2-Debug.log`。
- 首轮未找到 PATH 中的 SwiftLint；后续找到并使用主机现有 `/tmp/floe-swiftlint/swiftlint`，strict 检查已通过。沙箱内 Swift 缓存不可写，回归已使用主机环境重新执行。
- 本批未执行真实鼠标拖拽、退出/重启、宿主更新或不同系统版本验收；未宣称 M2 完成，63 条数量不变。

## 后续完整审计与实施

本轮逐条核对 63 份原文及评论，将代码防护与原场景验收分别登记在 [机器状态](m2-status.json)。没有将缺少原场景验收的条目移出清单，M2 仍为 63 条；该数量不能用来判断本轮没有代码改进，也不能将一次构建通过等同于 63 条报告均解决。

### 交互与浮栏

- EventManager 保存点击时的修饰键；Option-click 在 Show on Click 关闭时仍可用，always-hidden 禁用时回退 Hidden。控制图标同样使用当前事件的修饰键。
- 点击、智能隐藏和悬停任务有取消句柄；停止监视及手动操作取消旧请求。智能隐藏延迟结束时重新核实设置、指针、菜单和分区代次，Space 变化分支也遵守菜单保护。悬停同方向事件不重置倒计时，方向改变/离开时取消。
- 聚焦收起检查 autoRehide 与分区代次；计时收起执行时重新核实策略。浮栏与菜单栏之间的访问通道不触发收起。浮栏尚未完成的 show Task 能被 hide 取消，避免关闭后迟到重开。
- 关闭 always-hidden 时不再过滤正在显示的 Hidden 项；系统菜单隐藏观察改用常驻 Hidden 控制项。禁用应用菜单避让时恢复原宿主。再次从 Finder 打开运行中的 Floe 进入设置，保留控制图标丢失后的恢复入口。

### 拖拽、鼠标与临时归位

- 合成 Command-drag 期间停止 Floe 交互监视，避免触发原生拖拽的展开全部逻辑；独立执行器拒绝重入，传播取消，用键盘事件产生 Command flagsChanged。任意失败/取消都释放鼠标与 Command，恢复原指针位置。
- 布局拖拽先临时展开隐藏分区并等待位置稳定，再扫描源帧，避免向屏外负坐标发送拖拽；结束/取消按状态代次恢复，不改变启动偏好。编辑期间不执行自动布局恢复。
- 页面离开取消拖拽；provider 迟到回调不启动新操作；拖拽淘汰旧扫描。无法确定目标时还原被修改的本地快照，失败显示已本地化反馈。
- CGS 临时显示拒绝并发鼠标操作，归位等待准备完成与菜单关闭；用户原生拖拽取消旧归位记录，包括等待任务结束后补回记录及失败快照补回两种路径。移除 CGS 异步移动/点击/归位中的隐藏指针操作，避免将不可预测等待期间的光标隐藏带到宿主菜单。

### 持久化与搜索

- 新增 MenuBarLayoutStore：只保存确认的页面拖拽与原生拖拽快照，不保存自动临时显示。单状态项使用宿主 namespace，多状态项要求非占位且唯一 title；歧义项不猜测。保存缺席宿主选择，首次发现/窗口重建时恢复；普通扫描不反复移动存活项。菜单、临时显示及近期鼠标操作时延后恢复，用户新选择使待执行恢复步骤失效。
- 该恢复当前依赖 CGS 窗口与已有 move 方法；AX-only 系统不保存空 CGS 快照，不宣称 macOS 27 的跨重启归属问题已解决。多状态项且标识不稳定的报告仍需宿主级别身份方案。
- 新增独立搜索面板，右键菜单与可配置快捷键打开；AX 名称优先、CGS 几何补入去重。名称和 bundle 可过滤，Return 激活首项，Escape 关闭；每五秒刷新，销毁面板取消视图扫描。AX 占位 Item-N/空名称回退到宿主，图标使用应用图标/SF Symbol，不依赖白色截图背景。布局页同时支持筛选。英文/简体中文及 README 同步。

### 验证边界

当前主机 macOS 15.8.1。受控回归直接编译生产方法，不投递真实鼠标事件、不写用户偏好。新增拖拽取消、延迟交互、布局持久化和搜索回归；既有 AX 激活、浮栏代次、发现和临时归位回归继续执行。最终结果见下方验证记录。

没有可用的 macOS 26/27 同环境，也未安装报告中的所有第三方应用，无法完成全部报告的原场景真机验收。#675 的后续评论指向系统状态项移除，#694 还包含上游旧版本崩溃线索，均不能因为名字相近就宣布同一根因修复。真实菜单避让、系统更新、登录重启及 Tahoe 光标状态必须保留未验收状态。

## 逐条核对与剩余验收

| 工作包 | issue | 本轮处理依据 | 仍需验收 |
| --- | --- | --- | --- |
| I1 | [cavaldos/Ice#24](https://github.com/cavaldos/Ice/issues/24) | 拖拽互斥、取消清理、扫描代次失效、真实落点/顺序验证和失败反馈 | 真实 Command-drag、不可移动系统项及对应 macOS 版本 |
| I1 | [jordanbaird/Ice#233](https://github.com/jordanbaird/Ice/issues/233) | 拖拽互斥、取消清理、扫描代次失效、真实落点/顺序验证和失败反馈 | 真实 Command-drag、不可移动系统项及对应 macOS 版本 |
| I1 | [jordanbaird/Ice#344](https://github.com/jordanbaird/Ice/issues/344) | 保存明确拖拽选择；CGS 唯一身份窗口重建恢复；原生拖拽展开不写入下次启动偏好 | 退出/登录及宿主更新；AX-only 与多状态项身份仍受限制 |
| I1 | [jordanbaird/Ice#512](https://github.com/jordanbaird/Ice/issues/512) | 分区真值重扫；临时归位互斥及新选择优先；未将 UI 乐观位置当作真实结果 | 对应系统、多窗口切换和分区重建原场景 |
| I1 | [jordanbaird/Ice#513](https://github.com/jordanbaird/Ice/issues/513) | 分区真值重扫；临时归位互斥及新选择优先；未将 UI 乐观位置当作真实结果 | 对应系统、多窗口切换和分区重建原场景 |
| I1 | [jordanbaird/Ice#661](https://github.com/jordanbaird/Ice/issues/661) | 保存明确拖拽选择；CGS 唯一身份窗口重建恢复；原生拖拽展开不写入下次启动偏好 | 退出/登录及宿主更新；AX-only 与多状态项身份仍受限制 |
| I1 | [jordanbaird/Ice#666](https://github.com/jordanbaird/Ice/issues/666) | 保存明确拖拽选择；CGS 唯一身份窗口重建恢复；原生拖拽展开不写入下次启动偏好 | 退出/登录及宿主更新；AX-only 与多状态项身份仍受限制 |
| I1 | [jordanbaird/Ice#675](https://github.com/jordanbaird/Ice/issues/675) | 报告者后续说明为 macOS 状态项移除行为；保留为外部原因线索 | 确认 Floe 中是否仍可复现，不能以评论推论直接删单 |
| I1 | [jordanbaird/Ice#702](https://github.com/jordanbaird/Ice/issues/702) | 分区真值重扫；临时归位互斥及新选择优先；未将 UI 乐观位置当作真实结果 | 对应系统、多窗口切换和分区重建原场景 |
| I1 | [jordanbaird/Ice#723](https://github.com/jordanbaird/Ice/issues/723) | 保存明确拖拽选择；CGS 唯一身份窗口重建恢复；原生拖拽展开不写入下次启动偏好 | 退出/登录及宿主更新；AX-only 与多状态项身份仍受限制 |
| I1 | [jordanbaird/Ice#769](https://github.com/jordanbaird/Ice/issues/769) | 保存明确拖拽选择；CGS 唯一身份窗口重建恢复；原生拖拽展开不写入下次启动偏好 | 退出/登录及宿主更新；AX-only 与多状态项身份仍受限制 |
| I1 | [jordanbaird/Ice#771](https://github.com/jordanbaird/Ice/issues/771) | 保存明确拖拽选择；CGS 唯一身份窗口重建恢复；原生拖拽展开不写入下次启动偏好 | 退出/登录及宿主更新；AX-only 与多状态项身份仍受限制 |
| I1 | [jordanbaird/Ice#781](https://github.com/jordanbaird/Ice/issues/781) | 已有显示图标开关与位置保留；补充再次打开应用进入设置的恢复入口 | 系统移除图标、显示开关及再次打开应用的真实验收 |
| I1 | [jordanbaird/Ice#799](https://github.com/jordanbaird/Ice/issues/799) | 延迟智能/悬停/聚焦收起重新核实设置、位置、状态代次；菜单保护和计时器策略复核 | 特定系统/自定义宿主菜单与崩溃导致无法收起的区别 |
| I1 | [jordanbaird/Ice#861](https://github.com/jordanbaird/Ice/issues/861) | 拖拽互斥、取消清理、扫描代次失效、真实落点/顺序验证和失败反馈 | 真实 Command-drag、不可移动系统项及对应 macOS 版本 |
| I1 | [jordanbaird/Ice#946](https://github.com/jordanbaird/Ice/issues/946) | 分区真值重扫；临时归位互斥及新选择优先；未将 UI 乐观位置当作真实结果 | 对应系统、多窗口切换和分区重建原场景 |
| I2 | [cavaldos/Ice#12](https://github.com/cavaldos/Ice/issues/12) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#403](https://github.com/jordanbaird/Ice/issues/403) | 延迟智能/悬停/聚焦收起重新核实设置、位置、状态代次；菜单保护和计时器策略复核 | 特定系统/自定义宿主菜单与崩溃导致无法收起的区别 |
| I2 | [jordanbaird/Ice#434](https://github.com/jordanbaird/Ice/issues/434) | 修正关闭 always-hidden 后误过滤已显示 Hidden 项；关闭菜单避让设置时恢复宿主 | 对应硬件菜单空间不足与 Option 组合的真实菜单避让 |
| I2 | [jordanbaird/Ice#452](https://github.com/jordanbaird/Ice/issues/452) | 延迟智能/悬停/聚焦收起重新核实设置、位置、状态代次；菜单保护和计时器策略复核 | 特定系统/自定义宿主菜单与崩溃导致无法收起的区别 |
| I2 | [jordanbaird/Ice#485](https://github.com/jordanbaird/Ice/issues/485) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#545](https://github.com/jordanbaird/Ice/issues/545) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#619](https://github.com/jordanbaird/Ice/issues/619) | 已有显示图标开关与位置保留；补充再次打开应用进入设置的恢复入口 | 系统移除图标、显示开关及再次打开应用的真实验收 |
| I2 | [jordanbaird/Ice#620](https://github.com/jordanbaird/Ice/issues/620) | 修正关闭 always-hidden 后误过滤已显示 Hidden 项；关闭菜单避让设置时恢复宿主 | 对应硬件菜单空间不足与 Option 组合的真实菜单避让 |
| I2 | [jordanbaird/Ice#694](https://github.com/jordanbaird/Ice/issues/694) | 延迟智能/悬停/聚焦收起重新核实设置、位置、状态代次；菜单保护和计时器策略复核 | 特定系统/自定义宿主菜单与崩溃导致无法收起的区别 |
| I2 | [jordanbaird/Ice#717](https://github.com/jordanbaird/Ice/issues/717) | 滚轮使用主轴位移，避免单轴减半或双轴抵消 | 鼠标滚轮、触控板横纵滑动及惯性输入 |
| I2 | [jordanbaird/Ice#759](https://github.com/jordanbaird/Ice/issues/759) | 已有显示图标开关与位置保留；补充再次打开应用进入设置的恢复入口 | 系统移除图标、显示开关及再次打开应用的真实验收 |
| I2 | [jordanbaird/Ice#813](https://github.com/jordanbaird/Ice/issues/813) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#814](https://github.com/jordanbaird/Ice/issues/814) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#865](https://github.com/jordanbaird/Ice/issues/865) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#871](https://github.com/jordanbaird/Ice/issues/871) | 悬停任务按意图合并/取消；浮栏通道保护；手动展开优先于旧悬停任务 | 真实指针跨越菜单栏/浮栏间隙、0 延迟和快速重复展开 |
| I2 | [jordanbaird/Ice#879](https://github.com/jordanbaird/Ice/issues/879) | 修正关闭 always-hidden 后误过滤已显示 Hidden 项；关闭菜单避让设置时恢复宿主 | 对应硬件菜单空间不足与 Option 组合的真实菜单避让 |
| I2 | [jordanbaird/Ice#888](https://github.com/jordanbaird/Ice/issues/888) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#890](https://github.com/jordanbaird/Ice/issues/890) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#906](https://github.com/jordanbaird/Ice/issues/906) | 再次打开仅显式请求设置；自动避让已有 accessory/无 Dock 激活保护；修正错误避让范围 | 登录启动、Finder 重开、自动避让与设置窗口激活分别验收 |
| I2 | [jordanbaird/Ice#970](https://github.com/jordanbaird/Ice/issues/970) | 延迟智能/悬停/聚焦收起重新核实设置、位置、状态代次；菜单保护和计时器策略复核 | 特定系统/自定义宿主菜单与崩溃导致无法收起的区别 |
| I2 | [jordanbaird/Ice#996](https://github.com/jordanbaird/Ice/issues/996) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I2 | [jordanbaird/Ice#1008](https://github.com/jordanbaird/Ice/issues/1008) | 浮栏请求取消与代次淘汰、发现链路已有 AX fallback、有界等待与截图保护 | 原系统的浮栏显示/切换 Space；macOS 26/27 不可在当前主机验收 |
| I3 | [jordanbaird/Ice#316](https://github.com/jordanbaird/Ice/issues/316) | 手动展开取消延迟自动操作；执行前复核菜单命中；临时点击互斥与菜单生命周期保护 | 原应用菜单、子菜单、自定义窗口及 AX/CGS 真实点击 |
| I3 | [jordanbaird/Ice#567](https://github.com/jordanbaird/Ice/issues/567) | 手动展开取消延迟自动操作；执行前复核菜单命中；临时点击互斥与菜单生命周期保护 | 原应用菜单、子菜单、自定义窗口及 AX/CGS 真实点击 |
| I3 | [jordanbaird/Ice#584](https://github.com/jordanbaird/Ice/issues/584) | 再次打开仅显式请求设置；自动避让已有 accessory/无 Dock 激活保护；修正错误避让范围 | 登录启动、Finder 重开、自动避让与设置窗口激活分别验收 |
| I3 | [jordanbaird/Ice#621](https://github.com/jordanbaird/Ice/issues/621) | 手动展开取消延迟自动操作；执行前复核菜单命中；临时点击互斥与菜单生命周期保护 | 原应用菜单、子菜单、自定义窗口及 AX/CGS 真实点击 |
| I3 | [jordanbaird/Ice#640](https://github.com/jordanbaird/Ice/issues/640) | 移除 CGS 移动/点击/归位期间的隐藏指针调用；AX 拖拽取消释放 Command/鼠标并恢复位置 | Tahoe 指针尺寸/形状和系统光标状态原场景 |
| I3 | [jordanbaird/Ice#686](https://github.com/jordanbaird/Ice/issues/686) | 悬停任务按意图合并/取消；浮栏通道保护；手动展开优先于旧悬停任务 | 真实指针跨越菜单栏/浮栏间隙、0 延迟和快速重复展开 |
| I3 | [jordanbaird/Ice#751](https://github.com/jordanbaird/Ice/issues/751) | 移除 CGS 移动/点击/归位期间的隐藏指针调用；AX 拖拽取消释放 Command/鼠标并恢复位置 | Tahoe 指针尺寸/形状和系统光标状态原场景 |
| I3 | [jordanbaird/Ice#755](https://github.com/jordanbaird/Ice/issues/755) | 手动展开取消延迟自动操作；执行前复核菜单命中；临时点击互斥与菜单生命周期保护 | 原应用菜单、子菜单、自定义窗口及 AX/CGS 真实点击 |
| I3 | [jordanbaird/Ice#757](https://github.com/jordanbaird/Ice/issues/757) | 移除 CGS 移动/点击/归位期间的隐藏指针调用；AX 拖拽取消释放 Command/鼠标并恢复位置 | Tahoe 指针尺寸/形状和系统光标状态原场景 |
| I3 | [jordanbaird/Ice#768](https://github.com/jordanbaird/Ice/issues/768) | 再次打开仅显式请求设置；自动避让已有 accessory/无 Dock 激活保护；修正错误避让范围 | 登录启动、Finder 重开、自动避让与设置窗口激活分别验收 |
| I3 | [jordanbaird/Ice#826](https://github.com/jordanbaird/Ice/issues/826) | 手动展开取消延迟自动操作；执行前复核菜单命中；临时点击互斥与菜单生命周期保护 | 原应用菜单、子菜单、自定义窗口及 AX/CGS 真实点击 |
| I3 | [jordanbaird/Ice#845](https://github.com/jordanbaird/Ice/issues/845) | 手动展开取消延迟自动操作；执行前复核菜单命中；临时点击互斥与菜单生命周期保护 | 原应用菜单、子菜单、自定义窗口及 AX/CGS 真实点击 |
| I3 | [jordanbaird/Ice#914](https://github.com/jordanbaird/Ice/issues/914) | 悬停任务按意图合并/取消；浮栏通道保护；手动展开优先于旧悬停任务 | 真实指针跨越菜单栏/浮栏间隙、0 延迟和快速重复展开 |
| I1 | [jordanbaird/Ice#808](https://github.com/jordanbaird/Ice/issues/808) | 再次打开仅显式请求设置；自动避让已有 accessory/无 Dock 激活保护；修正错误避让范围 | 登录启动、Finder 重开、自动避让与设置窗口激活分别验收 |
| I2 | [jordanbaird/Ice#144](https://github.com/jordanbaird/Ice/issues/144) | 修正关闭 always-hidden 后误过滤已显示 Hidden 项；关闭菜单避让设置时恢复宿主 | 对应硬件菜单空间不足与 Option 组合的真实菜单避让 |
| I2 | [jordanbaird/Ice#246](https://github.com/jordanbaird/Ice/issues/246) | 已有显示图标开关与位置保留；补充再次打开应用进入设置的恢复入口 | 系统移除图标、显示开关及再次打开应用的真实验收 |
| I2 | [jordanbaird/Ice#329](https://github.com/jordanbaird/Ice/issues/329) | 已有显示图标开关与位置保留；补充再次打开应用进入设置的恢复入口 | 系统移除图标、显示开关及再次打开应用的真实验收 |
| I2 | [jordanbaird/Ice#401](https://github.com/jordanbaird/Ice/issues/401) | 悬停任务按意图合并/取消；浮栏通道保护；手动展开优先于旧悬停任务 | 真实指针跨越菜单栏/浮栏间隙、0 延迟和快速重复展开 |
| I2 | [jordanbaird/Ice#595](https://github.com/jordanbaird/Ice/issues/595) | 点击时修饰键快照；Option 不依赖 Show on Click；always-hidden 关闭时回退 Hidden | 真实修饰键事件与快速组合点击 |
| I2 | [jordanbaird/Ice#634](https://github.com/jordanbaird/Ice/issues/634) | 点击时修饰键快照；Option 不依赖 Show on Click；always-hidden 关闭时回退 Hidden | 真实修饰键事件与快速组合点击 |
| I2 | [jordanbaird/Ice#644](https://github.com/jordanbaird/Ice/issues/644) | 点击时修饰键快照；Option 不依赖 Show on Click；always-hidden 关闭时回退 Hidden | 真实修饰键事件与快速组合点击 |
| I2 | [jordanbaird/Ice#695](https://github.com/jordanbaird/Ice/issues/695) | 再次打开仅显式请求设置；自动避让已有 accessory/无 Dock 激活保护；修正错误避让范围 | 登录启动、Finder 重开、自动避让与设置窗口激活分别验收 |
| I2 | [jordanbaird/Ice#725](https://github.com/jordanbaird/Ice/issues/725) | 再次打开仅显式请求设置；自动避让已有 accessory/无 Dock 激活保护；修正错误避让范围 | 登录启动、Finder 重开、自动避让与设置窗口激活分别验收 |
| I4 | [jordanbaird/Ice#668](https://github.com/jordanbaird/Ice/issues/668) | 恢复独立搜索菜单/快捷键入口；AX+CGS 合并、名称/宿主筛选、占位名回退、Return 激活和 Escape 关闭 | 真机键盘焦点、浅深色图标与 AX/CGS 项目激活 |
| I4 | [jordanbaird/Ice#673](https://github.com/jordanbaird/Ice/issues/673) | 恢复独立搜索菜单/快捷键入口；AX+CGS 合并、名称/宿主筛选、占位名回退、Return 激活和 Escape 关闭 | 真机键盘焦点、浅深色图标与 AX/CGS 项目激活 |

## 最终验证记录

Debug 与 Release 最新构建通过（CODE_SIGNING_ALLOWED=NO），SwiftLint strict 0 violations，`git diff --check` 通过。26 项全量 Swift 回归通过，后续新增 `layout-drag-reveal.swift` 通过，共 27 项。该新增回归直接编译完整生产分区拖拽方法，核验屏外源项先展开、成功/取消恢复、偏好不写入及编辑占用释放。

日志：`/tmp/Floe-M2-Debug.log`、`/tmp/Floe-M2-Release.log`、`/tmp/Floe-M2-regression.log`、`/tmp/Floe-M2-lint.log`。未做真实鼠标/菜单与系统重启验收，未提交或推送。本记录确认代码层改进，M2 整体仍未达到全部原场景验收完成的门槛。
