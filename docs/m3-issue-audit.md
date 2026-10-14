# M3 持续优化与逐条验收记录

日期：2026-10-14。M3 94 条（S1 41、S2 15、S3 38）。使用主机 GitHub 授权刷新全部 issue 与完整分页评论，94 条均为 open，见 [原文及评论快照](m3-upstream-review.json)；[逐条状态](m3-status.json) 区分本批代码改进和待复现报告。未修改上游状态，未删除条目，M3 与总清单数量不变。

## 本批定位与实现

### S1/S2：多屏和系统模式命中

原 EventManager 普通桌面模式只比较 AppKit Y 坐标，且非全屏默认 NSScreen.main。不同高度/横向摆放的副屏窗口顶端可误触发 Floe，尤其关闭 Displays have separate Spaces 后副屏没有菜单栏。关联 jordanbaird/Ice#456、#639、#646、#824。

现在统一使用鼠标所在显示器，将 Quartz 点与该显示器 CGDisplayBounds 的横纵范围一起检查；之后核实该屏真实 on-screen 菜单栏窗口。无菜单栏时返回 false，不用可见工作区的高度差推断。自动隐藏和全屏不复用菜单栏帧缓存，避免滑动/收起后沿旧帧误命中（#286、#708、#899）。普通固定菜单栏保留既有缓存与顶部预筛选。

外观面板刷新时若对应屏已没有真实菜单栏，立即 orderOut，避免保留上一 Space/屏幕的旧面板。

Floe Bar 的目标屏也采用该选择；内容宽度、菜单栏高度与滚动约束采用目标显示器，而非缓存截图所属屏。该改动不把全局系统状态项改为每屏独立分区；跨屏共享展开状态的产品行为仍需单独确认。

### S1：混合 DPI 的截图与显示

原逐项 fallback 按猜测的屏幕倍率裁剪，显示阶段再按屏幕倍率换算 NSImage，混合 DPI 或截图 API 返回不同倍率时可能裁剪失败或尺寸减半。关联 #698、#825、#829、#929、#955、#987；#211 还涉及非活动屏项目身份和颜色，不能由尺寸修复推广为全部解决。

逐项截图改为按返回图片宽度/项目逻辑宽度推导实际倍率，裁剪高度不超出图片范围。图片显示按项目逻辑宽度与图片纵横比换算，不再借用其他屏的 backingScaleFactor。取消保护和缓存存活项淘汰保持有效。

### S3：同名多实例身份

原 ItemCache.section、返回目标索引、临时显示缓存及归位查找使用 MenuBarItemInfo；多个实例同名时可能选择第一个兄弟项。关联 #300、#404、#739、#854、#857、#909。

本批优先使用 windowID 区分存活窗口；临时显示上下文保留原 windowID。宿主重建窗口后仅在 info 唯一时回退；多个同名候选不猜测，保留归位记录等待恢复。图片缓存仍以 info 为键，多实例图片冲突和动态标识持久化尚需继续处理，不能宣布这些报告已完全解决。

## 后续代码优化与完整核对

本轮逐条阅读全部 94 条原文与评论；[机器状态](m3-status.json) 分别列出代码改进和剩余验收，不把已登记等同于已解决。M3 的原场景验收尚未完成，清单仍为 94 条。

### 已继续实施

1. 图片缓存改为 windowID 索引，同名兄弟项不覆盖图片，移除一项不会淘汰另一项。用户拖拽取消归位、临时选择代次也使用窗口 ID。
2. Space/显示器切换立即清空旧图片并增加环境代次；捕获/裁剪/fallback/发布复核代次。忙碌时合并一次新环境刷新。浮栏颜色独立维护截图代次与 displayID，旧任务不能清除新任务句柄；关闭、主题/Space/屏幕变化淘汰旧颜色。所有屏幕可更新颜色，全宽面板颜色采样避免除零。
3. 外观 show 原来绕过 validate，现首次显示与更新都校验系统隐藏、全屏、真实菜单栏和显示器存活；失败立即 orderOut。屏幕移除/重建时取消旧轮询及通知，睡眠关闭，唤醒重建；配置不再需要外观时关闭旧面板。
4. 浮栏屏幕改变时重建根视图并重绑定颜色，跨屏或截图失败时优先使用 AX，自动隐藏模式也可进入 AX 权限/访问流程；移除“原状态项隐藏即强制关浮栏”的旧分支。AX 列表可见期间每五秒刷新，动态宿主不必重开浮栏才出现。计时收起改用真实指针屏菜单栏/浮栏命中，低分辨率刘海屏内缩高度不小于系统图标厚度。
5. 布局持久化观察每次退出快照，识别再出现时复用窗口 ID；失败不再视为恢复成功，退避 30 秒后可重试。普通缓存未改变时也可触发廉价重试判定，用户新选择仍淘汰旧恢复。布局页拖拽遵守 CGS 已知不可移动/不可隐藏系统项标记。

### 当前真机条件与阻塞

此前只有系统版本记录，不能据此推断没有外接屏。本轮只读探针确认主机有三屏：内屏 1728×1117/2x，左外屏 1920×1080/1x（x=-1920），右外屏 1920×1080/1x（x=1728）。AppKit 外屏 y=37 对应 Quartz y=0，已保留 [几何证据](m3-evidence/display-geometry.json)。

主机仍为 macOS 15.8.1，探针 AXIsProcessTrusted 和 CGPreflightScreenCaptureAccess 均 false，Floe 未运行。通用探针最初误用了 WindowServer 名称过滤；修正为生产代码使用的 Window Server 后确认三屏原生菜单栏，高度分别为 37/24/24 pt。没有把初始空数组解释为菜单栏缺失。新增仅 Debug 可用的 `--diagnose-runtime`：签名构建以 com.wudb.Floe 自身身份只读核验后立即退出，不执行图标管理。确认 Floe 自身 AX 与屏幕录制权限均 false，三屏菜单栏均可发现，见 [Floe 运行身份诊断](m3-evidence/floe-runtime-diagnostics.json)。没有触发隐私授权申请、修改显示器设置或启动报告中的第三方宿主；常规 /Applications 路径未找到本次检查的报告宿主。上述条件不能代替 macOS 26/27、合盖/睡眠、7680×2160、Sidecar、Mission Control、对应应用、Live Activities/HUD 的原场景验证。

#94/#573 超宽屏隐藏、#486 Display Zoom、#714/#216 Mission Control、#683 每屏独立展开、#656/#704/#731 实时活动、#718 Game Mode、#817 用户项、#915 Unsplash 崩溃等仍有明确未解决范围。系统录屏指示器相关 #852/#886 不能通过重复拖拽或绕过系统保护“解决”。全量剩余条件见下表；不会把通用菜单保护当作这些宿主的根因结论。

## 全量处理与剩余验收索引

| 工作包 | issue | 本轮处理依据 | 剩余验收/未解决范围 |
| --- | --- | --- | --- |
| S1 | [cavaldos/Ice#5](https://github.com/cavaldos/Ice/issues/5) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | macOS 27 合盖外接屏隐藏失效的原系统场景未复现 |
| S1 | [jordanbaird/Ice#94](https://github.com/jordanbaird/Ice/issues/94) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 超宽屏隐藏长度/系统布局原场景未复现；当前外屏 1920×1080 无法替代 7680×2160 |
| S1 | [jordanbaird/Ice#260](https://github.com/jordanbaird/Ice/issues/260) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S1 | [jordanbaird/Ice#383](https://github.com/jordanbaird/Ice/issues/383) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S1 | [jordanbaird/Ice#416](https://github.com/jordanbaird/Ice/issues/416) | 截图不可用/跨屏时 AX 项目访问回退与独立搜索入口；现有应用菜单避让保护 | 刘海/空间不足时原宿主 AX 可见性与真实点击 |
| S1 | [jordanbaird/Ice#456](https://github.com/jordanbaird/Ice/issues/456) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S1 | [jordanbaird/Ice#486](https://github.com/jordanbaird/Ice/issues/486) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 系统 Display Zoom 视野跟随合成鼠标场景未验收；未读取不受支持的 Zoom 偏好猜测状态 |
| S1 | [jordanbaird/Ice#573](https://github.com/jordanbaird/Ice/issues/573) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 同 #94 的 7680×2160 超宽屏场景，不能以调整截图倍率当作隐藏已修复 |
| S1 | [jordanbaird/Ice#589](https://github.com/jordanbaird/Ice/issues/589) | 截图不可用/跨屏时 AX 项目访问回退与独立搜索入口；现有应用菜单避让保护 | 刘海/空间不足时原宿主 AX 可见性与真实点击 |
| S1 | [jordanbaird/Ice#639](https://github.com/jordanbaird/Ice/issues/639) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S1 | [jordanbaird/Ice#646](https://github.com/jordanbaird/Ice/issues/646) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S1 | [jordanbaird/Ice#698](https://github.com/jordanbaird/Ice/issues/698) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S1 | [jordanbaird/Ice#715](https://github.com/jordanbaird/Ice/issues/715) | 截图不可用/跨屏时 AX 项目访问回退与独立搜索入口；现有应用菜单避让保护 | 刘海/空间不足时原宿主 AX 可见性与真实点击 |
| S1 | [jordanbaird/Ice#824](https://github.com/jordanbaird/Ice/issues/824) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S1 | [jordanbaird/Ice#825](https://github.com/jordanbaird/Ice/issues/825) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S1 | [jordanbaird/Ice#829](https://github.com/jordanbaird/Ice/issues/829) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S1 | [jordanbaird/Ice#836](https://github.com/jordanbaird/Ice/issues/836) | 自动隐藏菜单栏下提供 AX 访问回退，不再因原状态项隐藏强制关闭浮栏 | 系统自动隐藏下真实 AX 节点及点击行为 |
| S1 | [jordanbaird/Ice#929](https://github.com/jordanbaird/Ice/issues/929) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S1 | [jordanbaird/Ice#955](https://github.com/jordanbaird/Ice/issues/955) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S1 | [jordanbaird/Ice#987](https://github.com/jordanbaird/Ice/issues/987) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S2 | [jordanbaird/Ice#201](https://github.com/jordanbaird/Ice/issues/201) | 自动隐藏菜单栏下提供 AX 访问回退，不再因原状态项隐藏强制关闭浮栏 | 系统自动隐藏下真实 AX 节点及点击行为 |
| S2 | [jordanbaird/Ice#234](https://github.com/jordanbaird/Ice/issues/234) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S2 | [jordanbaird/Ice#254](https://github.com/jordanbaird/Ice/issues/254) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S2 | [jordanbaird/Ice#286](https://github.com/jordanbaird/Ice/issues/286) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S2 | [jordanbaird/Ice#331](https://github.com/jordanbaird/Ice/issues/331) | 自动隐藏菜单栏下提供 AX 访问回退，不再因原状态项隐藏强制关闭浮栏 | 系统自动隐藏下真实 AX 节点及点击行为 |
| S2 | [jordanbaird/Ice#708](https://github.com/jordanbaird/Ice/issues/708) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S2 | [jordanbaird/Ice#714](https://github.com/jordanbaird/Ice/issues/714) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Mission Control 悬停误触发仍待可靠可见性信号及真机复现，未加入未经证实的 Dock 标题启发式 |
| S2 | [jordanbaird/Ice#899](https://github.com/jordanbaird/Ice/issues/899) | 指针所属显示器、真实菜单栏命中、滑动菜单栏不用旧帧；计时收起也按实际菜单栏/浮栏判断 | 原模式真实点击/悬停/滚轮验收 |
| S3 | [jordanbaird/Ice#244](https://github.com/jordanbaird/Ice/issues/244) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#300](https://github.com/jordanbaird/Ice/issues/300) | 图片、分区、临时显示/归位、用户取消均按窗口 ID；歧义重建不猜测 | OneDrive 等多实例实际交互；#854 需区分重复安装/正常多账号 |
| S3 | [jordanbaird/Ice#330](https://github.com/jordanbaird/Ice/issues/330) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#404](https://github.com/jordanbaird/Ice/issues/404) | 图片、分区、临时显示/归位、用户取消均按窗口 ID；歧义重建不猜测 | OneDrive 等多实例实际交互；#854 需区分重复安装/正常多账号 |
| S3 | [jordanbaird/Ice#440](https://github.com/jordanbaird/Ice/issues/440) | CGS 布局拖拽遵守已有不可移动/不可隐藏名单，不对受保护项目盲目重试 | 系统约束待原生对照；没有绕过系统保护实现隐藏 |
| S3 | [jordanbaird/Ice#462](https://github.com/jordanbaird/Ice/issues/462) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#467](https://github.com/jordanbaird/Ice/issues/467) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#480](https://github.com/jordanbaird/Ice/issues/480) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Alcove 特定设置交互需该应用原场景对照 |
| S3 | [jordanbaird/Ice#526](https://github.com/jordanbaird/Ice/issues/526) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#586](https://github.com/jordanbaird/Ice/issues/586) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#642](https://github.com/jordanbaird/Ice/issues/642) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#656](https://github.com/jordanbaird/Ice/issues/656) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Live Activities 的真实移动能力/标识需要 macOS 26 原生对照 |
| S3 | [jordanbaird/Ice#658](https://github.com/jordanbaird/Ice/issues/658) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 尚未定位并验证原场景根因；不能因其他代码改进归档 |
| S3 | [jordanbaird/Ice#697](https://github.com/jordanbaird/Ice/issues/697) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#701](https://github.com/jordanbaird/Ice/issues/701) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 尚未定位并验证原场景根因；不能因其他代码改进归档 |
| S3 | [jordanbaird/Ice#704](https://github.com/jordanbaird/Ice/issues/704) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | iPhone 实时通知移动能力需要原系统与设备对照 |
| S3 | [jordanbaird/Ice#707](https://github.com/jordanbaird/Ice/issues/707) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#718](https://github.com/jordanbaird/Ice/issues/718) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Game Mode 状态项与游戏全屏需要原系统对照 |
| S3 | [jordanbaird/Ice#719](https://github.com/jordanbaird/Ice/issues/719) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 尚未定位并验证原场景根因；不能因其他代码改进归档 |
| S3 | [jordanbaird/Ice#729](https://github.com/jordanbaird/Ice/issues/729) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#732](https://github.com/jordanbaird/Ice/issues/732) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#739](https://github.com/jordanbaird/Ice/issues/739) | 图片、分区、临时显示/归位、用户取消均按窗口 ID；歧义重建不猜测 | OneDrive 等多实例实际交互；#854 需区分重复安装/正常多账号 |
| S3 | [jordanbaird/Ice#748](https://github.com/jordanbaird/Ice/issues/748) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#766](https://github.com/jordanbaird/Ice/issues/766) | 现有菜单保护、点击/移动有界等待；本轮增加窗口身份和自动隐藏/截图失败 AX 回退 | 对应宿主菜单/子菜单/自定义弹窗；不是所有报告同一根因 |
| S3 | [jordanbaird/Ice#798](https://github.com/jordanbaird/Ice/issues/798) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#806](https://github.com/jordanbaird/Ice/issues/806) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#817](https://github.com/jordanbaird/Ice/issues/817) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 系统用户切换项发现与移动，需要原系统 AX/CGS 对照 |
| S3 | [jordanbaird/Ice#844](https://github.com/jordanbaird/Ice/issues/844) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#852](https://github.com/jordanbaird/Ice/issues/852) | CGS 布局拖拽遵守已有不可移动/不可隐藏名单，不对受保护项目盲目重试 | 系统约束待原生对照；没有绕过系统保护实现隐藏 |
| S3 | [jordanbaird/Ice#853](https://github.com/jordanbaird/Ice/issues/853) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#854](https://github.com/jordanbaird/Ice/issues/854) | 图片、分区、临时显示/归位、用户取消均按窗口 ID；歧义重建不猜测 | OneDrive 等多实例实际交互；#854 需区分重复安装/正常多账号 |
| S3 | [jordanbaird/Ice#857](https://github.com/jordanbaird/Ice/issues/857) | 图片、分区、临时显示/归位、用户取消均按窗口 ID；歧义重建不猜测 | OneDrive 等多实例实际交互；#854 需区分重复安装/正常多账号 |
| S3 | [jordanbaird/Ice#887](https://github.com/jordanbaird/Ice/issues/887) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S3 | [jordanbaird/Ice#909](https://github.com/jordanbaird/Ice/issues/909) | 图片、分区、临时显示/归位、用户取消均按窗口 ID；歧义重建不猜测 | OneDrive 等多实例实际交互；#854 需区分重复安装/正常多账号 |
| S3 | [jordanbaird/Ice#915](https://github.com/jordanbaird/Ice/issues/915) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Unsplash 宿主崩溃缺少 Floe 同环境堆栈/因果证据，未定位根因 |
| S3 | [jordanbaird/Ice#918](https://github.com/jordanbaird/Ice/issues/918) | 布局恢复识别宿主退出/窗口 ID 复用；失败退避后重试；明确用户选择优先 | 唯一身份宿主重建、更新与启动；多状态项无稳定标识仍未解决 |
| S1 | [jordanbaird/Ice#53](https://github.com/jordanbaird/Ice/issues/53) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#211](https://github.com/jordanbaird/Ice/issues/211) | 浮栏拖到另一屏后重绑定内容与颜色；跨屏图片来源不可靠时用 AX | 非活动屏真实项目颜色和 AX 激活 |
| S1 | [jordanbaird/Ice#241](https://github.com/jordanbaird/Ice/issues/241) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 副屏分隔符占位仍需原模式真实布局验证 |
| S1 | [jordanbaird/Ice#272](https://github.com/jordanbaird/Ice/issues/272) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Sidecar 原生状态项额外间距仍需 iPad 设备对照 |
| S1 | [jordanbaird/Ice#359](https://github.com/jordanbaird/Ice/issues/359) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 每屏菜单栏 AX 几何与刘海外观需要实际截图对照 |
| S1 | [jordanbaird/Ice#445](https://github.com/jordanbaird/Ice/issues/445) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#517](https://github.com/jordanbaird/Ice/issues/517) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#529](https://github.com/jordanbaird/Ice/issues/529) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 超宽屏右侧外观宽度需原分辨率截图/AX 对照 |
| S1 | [jordanbaird/Ice#550](https://github.com/jordanbaird/Ice/issues/550) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#576](https://github.com/jordanbaird/Ice/issues/576) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#609](https://github.com/jordanbaird/Ice/issues/609) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#636](https://github.com/jordanbaird/Ice/issues/636) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#657](https://github.com/jordanbaird/Ice/issues/657) | 实际像素倍率/逻辑尺寸；目标屏布局；低分辨率内缩高度下限 | 真机截图及图标/外观像素高度；#657 还需原生外观对照 |
| S1 | [jordanbaird/Ice#683](https://github.com/jordanbaird/Ice/issues/683) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | 全局状态项展开会跨屏共享，尚未实现每屏独立分区策略 |
| S1 | [jordanbaird/Ice#750](https://github.com/jordanbaird/Ice/issues/750) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#780](https://github.com/jordanbaird/Ice/issues/780) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#858](https://github.com/jordanbaird/Ice/issues/858) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#863](https://github.com/jordanbaird/Ice/issues/863) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#910](https://github.com/jordanbaird/Ice/issues/910) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#986](https://github.com/jordanbaird/Ice/issues/986) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S1 | [jordanbaird/Ice#988](https://github.com/jordanbaird/Ice/issues/988) | 外观显示/更新统一校验；全屏/隐藏/断屏撤下旧面板；睡眠清理及唤醒重建 | 原显示器布局、合盖/睡眠、VMWare/Sidecar 原场景 |
| S2 | [jordanbaird/Ice#216](https://github.com/jordanbaird/Ice/issues/216) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Mission Control 删除 Space 后的排序仍待真机复现；全屏/隐藏撤下不是该场景的完成证据 |
| S2 | [jordanbaird/Ice#336](https://github.com/jordanbaird/Ice/issues/336) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S2 | [jordanbaird/Ice#337](https://github.com/jordanbaird/Ice/issues/337) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S2 | [jordanbaird/Ice#451](https://github.com/jordanbaird/Ice/issues/451) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S2 | [jordanbaird/Ice#521](https://github.com/jordanbaird/Ice/issues/521) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S2 | [jordanbaird/Ice#606](https://github.com/jordanbaird/Ice/issues/606) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S2 | [jordanbaird/Ice#959](https://github.com/jordanbaird/Ice/issues/959) | 图片与颜色环境代次失效；迟到结果不可发布；全屏旧外观撤下 | 真实 Spaces 快速切换与壁纸/颜色/全屏视觉验收 |
| S3 | [jordanbaird/Ice#731](https://github.com/jordanbaird/Ice/issues/731) | 已刷新上游原文及评论；原显示器/系统/宿主组合待复现 | Live Activities 默认显示是产品需求，尚未实现每项稳定策略 |
| S3 | [jordanbaird/Ice#886](https://github.com/jordanbaird/Ice/issues/886) | CGS 布局拖拽遵守已有不可移动/不可隐藏名单，不对受保护项目盲目重试 | 系统约束待原生对照；没有绕过系统保护实现隐藏 |

## 最终验证

33 项 Swift 生产回归通过；包含图片环境失效、多实例图片淘汰、跨屏颜色迟到结果、外观显示校验、浮栏跨屏重绑定/数据来源策略、低分辨率内容高度、布局恢复退避与窗口 ID 复用。Debug（无签名编译）和本地 ad-hoc Debug 只读诊断通过，SwiftLint strict 0 violations，git diff --check 通过；最新 Release 构建通过，机器状态已同步。构建发生过并发数据库锁冲突，已等待旧构建结束并串行重跑，不把该环境错误归为产品失败。

日志：`/tmp/Floe-M3-regression.log`、`/tmp/Floe-M3-Debug.log`、`/tmp/Floe-M3-Diagnostic-build.log`、`/tmp/Floe-M3-native-diagnostics.json`、`/tmp/Floe-M3-Release.log`、`/tmp/Floe-M3-lint.log`。本轮未提交或推送。

M3 仍未完成全部原场景验收：33 项受控回归不等于 94 条 issue 修复完成。原生点击/截图受 Floe 自身授权阻塞；macOS 26/27、报告指定系统/宿主、超宽屏、Display Zoom、Mission Control、Live Activities、系统 HUD 等尚有单独未解决范围。
