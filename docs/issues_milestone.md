# Floe Issues Milestone

编制时间：2026-10-13T15:45:45+08:00（Asia/Shanghai）。代码参考：`e247351`。

范围：当前本地待处理清单 **367 条**，其中 `cavaldos/Ice` 4 条、`jordanbaird/Ice` 363 条。原始 402 条中已经清理的 35 条不重新纳入。本次只规划本地优先级与里程碑，不修改上游 GitHub 标签、状态或 Milestones。

依据：[原文清单](upstream-open-issues.md)、[分类总结](upstream-open-issues-summary.md)、[JSON 数据](upstream-open-issues.snapshot.json)、[修复核对记录](upstream-issue-fix-audit.md)。优先级是基于已有报告与当前实现的建议，不等于已在 Floe 实机复现；上游状态以原始采集时点为准，本次未重新抓取全部上游 issues。

## 开始修复前：多语言基础

按当前执行顺序，先完成英语/简体中文与 General → Language 的基础能力，
再进入下面的缺陷工作包。默认跟随系统首选语言，未支持时回退英语；显式
选择保存并即时刷新界面。README 默认英语，同时提供简体中文版本。

这一项属于 F2 的首批交付，不代表日语、RTL、VoiceOver/键盘导航等请求全部完成。
现有 issue 仍保留原始范围与状态，后续按每条具体要求验证后再清理。

## 执行顺序与排序原则

**先调查 P0 → 处理 P1 核心阻塞 → 完成 P2 兼容与体验 → 选择 P3 扩展。** 先确认问题适用于 Floe，再进入修复。工程已有基线，因此 M0 以复现材料和适用性补齐为主，不能把它当成重新搭建工程或延期调查 P0 的理由。

同级排序依次考虑：是否影响其他应用/系统、是否阻塞核心操作、是否来自当前直接上游、是否覆盖多个使用场景、复现证据与依赖是否充分。直接上游的 4 条 P1 是首批核心复现场景；macOS 27 的 AX 路径和 macOS 14/15/26 的 CGS 路径都应覆盖。

相似报告按工作包一起复现、定位和验证，**不视为已确认重复**；报告条数不等于独立用户数、实际发生频率或预估工时。不指定交付日期：目前没有人员、设备和复现成本信息。

## 优先级总览

| 优先级 | 当前数量 | 含义 | 判断口径 |
| --- | ---: | --- | --- |
| P0 | 3 | 立即调查/阻断风险确认 | 报告涉及系统卡死、内核 panic 或无法恢复的 UI 状态；潜在影响最大，但当前因果未确认。 |
| P1 | 186 | 核心可用性 | 启动、崩溃、长期资源增长、发现/隐藏/拖拽/点击，以及干扰其他应用操作。 |
| P2 | 114 | 重要兼容与体验 | 特定组合行为、外观/常态性能、语言/无障碍及高价值功能需求；安排在适用的核心阻塞问题之后。 |
| P3 | 64 | 后续增强或待澄清事项 | 装饰、较大的新能力、上游沟通与缺乏描述的报告；有新证据可调整。 |
| 合计 | 367 | | |

**P0 仅有 3 条：** [jordanbaird/Ice #908](https://github.com/jordanbaird/Ice/issues/908)、[jordanbaird/Ice #968](https://github.com/jordanbaird/Ice/issues/968)、[jordanbaird/Ice #974](https://github.com/jordanbaird/Ice/issues/974)。它们是需要立即查证的高影响报告，不能写成“已确认 Floe 导致系统崩溃”。若在当前实现复现，先提供可回退的隔离/恢复方案，再修复根因；若证据证明不适用，再调整级别并记录依据。

## 里程碑与依赖

| 里程碑 | 目标 | 条目数 | 阶段状态 | 前置依赖 |
| --- | --- | ---: | --- | --- |
| M0 | 工程与证据基线 | 9 | 工程/适配继承已核对；报告级验收未完成 | 无；P0 调查立即开始 |
| M1 | 稳定性与基础图标发现 | 70 | 首批截图/缓存修复完成；其余继续调查 | M0 可复现基线 |
| M2 | 分区管理与完整交互 | 63 | 核心链路第二批 | M1 的发现与稳定性 |
| M3 | 多屏、系统模式与应用兼容 | 94 | 核心链路第三批 | M1 + M2；可独立复现的缺陷可提前处理 |
| M4 | 外观与常态性能 | 40 | 可用性稳定后 | M1；外观依赖 M3 的坐标/屏幕行为 |
| M5 | 产品能力扩展 | 79 | 候选需求池，按价值拆批 | M2 + M3；具体子项另设范围 |
| Triage | 上游沟通与外部事项 | 12 | 持续整理，不排开发工期 | 无 |

依赖主线：`M0 → M1 → M2 → M3`；`M4` 的外观部分跟随 `M3`，性能调查可独立开展；`M5` 按子项依赖安排；`Triage` 持续进行。P0 调查与 M0 并行开始。优先级与里程碑是两个维度：里程碑不覆盖风险等级，也不意味着要等某阶段所有旧报告处理完才能开始下一阶段。

### 优先级与里程碑分布

| 里程碑 | P0 | P1 | P2 | P3 | 合计 |
| --- | ---: | ---: | ---: | ---: | ---: |
| M0 | 0 | 4 | 4 | 1 | 9 |
| M1 | 3 | 67 | 0 | 0 | 70 |
| M2 | 0 | 51 | 12 | 0 | 63 |
| M3 | 0 | 64 | 30 | 0 | 94 |
| M4 | 0 | 0 | 29 | 11 | 40 |
| M5 | 0 | 0 | 39 | 40 | 79 |
| Triage | 0 | 0 | 0 | 12 | 12 |

## 首批执行清单

以下是首批工作包顺序，并非已有修复结论。每个工作包开始时先复核相关 issue 的实时状态和关联修复，不按这里的日期假设上游没有变化。

| 顺序 | 优先级 | 工作包 | 首批关联报告 | 先做什么 |
| --- | --- | --- | --- | --- |
| 1 | P0 | C0 | [jordanbaird/Ice #908](https://github.com/jordanbaird/Ice/issues/908)、[jordanbaird/Ice #968](https://github.com/jordanbaird/Ice/issues/968)、[jordanbaird/Ice #974](https://github.com/jordanbaird/Ice/issues/974) | 立即保留日志、时间线与设置，在隔离环境做开启/关闭 Floe 及关键设置的对照；分别验证系统冻结、表单下拉框、应用菜单残留三个表面。 |
| 2 | P1 | C1 | [jordanbaird/Ice #777](https://github.com/jordanbaird/Ice/issues/777)、[jordanbaird/Ice #840](https://github.com/jordanbaird/Ice/issues/840)、[jordanbaird/Ice #905](https://github.com/jordanbaird/Ice/issues/905) | 定位捕获阻塞与启用 Floe Bar 时的崩溃；保留符号化栈、线程与窗口生命周期，不能只检查 windowNumber 的整数转换。 |
| 3 | P1 | C2 | [cavaldos/Ice #9](https://github.com/cavaldos/Ice/issues/9) | 复现布局空白和无法整理图标；对照原始上游 #716/#1003/#1009，检查权限、CGS/AX 项目列表、分隔符及缓存恢复。 |
| 4 | P1 | I2 | [cavaldos/Ice #12](https://github.com/cavaldos/Ice/issues/12) | 复现展开/收起入口，逐项覆盖显示分隔符、always-hidden、鼠标事件与快捷键，核对单次操作的真实状态。 |
| 5 | P1 | I1 | [cavaldos/Ice #24](https://github.com/cavaldos/Ice/issues/24) | 核对拖拽的实际目标、Quartz/屏幕坐标、分隔符、落点和重扫；不能只以 SwiftUI 乐观列表位置作为成功。 |
| 6 | P1 | S1 | [cavaldos/Ice #5](https://github.com/cavaldos/Ice/issues/5) | 提前建立外接屏合盖案例；在主/副屏及合盖/开盖切换时核对真实隐藏与点击范围。无需等待所有其他多屏问题处理完。 |
| 7 | P1 | C4 | [jordanbaird/Ice #530](https://github.com/jordanbaird/Ice/issues/530)、[jordanbaird/Ice #819](https://github.com/jordanbaird/Ice/issues/819) | 开始长时资源测量；记录 Floe 与 WindowServer 的内存、窗口数量和捕获频率，区分一般内存增长与系统资源泄漏。 |
| 8 | P1 | I3 / I2 | [jordanbaird/Ice #452](https://github.com/jordanbaird/Ice/issues/452)、[jordanbaird/Ice #621](https://github.com/jordanbaird/Ice/issues/621)、[jordanbaird/Ice #914](https://github.com/jordanbaird/Ice/issues/914) | 验证菜单、子菜单和自定义弹窗操作期间不误隐藏；现有 AX 测试通过后仍需真实应用和旧系统 CGS 路径复测。 |
| 9 | P1 | S3 | [jordanbaird/Ice #729](https://github.com/jordanbaird/Ice/issues/729)、[jordanbaird/Ice #857](https://github.com/jordanbaird/Ice/issues/857)、[jordanbaird/Ice #719](https://github.com/jordanbaird/Ice/issues/719) | 分别覆盖 Live Activities、多 OneDrive 实例、音量/亮度 HUD，确认选择一个项目不会改变其他项目的状态。 |
| 10 | P1/P2 | S1 / S2 | [jordanbaird/Ice #986](https://github.com/jordanbaird/Ice/issues/986)、[jordanbaird/Ice #987](https://github.com/jordanbaird/Ice/issues/987)、[jordanbaird/Ice #988](https://github.com/jordanbaird/Ice/issues/988) | 复现主副屏全屏残影、图标缩小和活动屏改变后布局差异，分别给出尺寸与截图对照。 |

## 各阶段工作包与验收

### M0：工程与证据基线

2026-10-13 处理记录：[M0 核对与验证](m0-issue-audit.md)。9 条已逐条初审，完整修复 **0** 条，部分修复 **1** 条（#1006 本地启动），待处理仍为 **9** 条；状态已在索引标记。Debug/Release、严格 lint 与 7 个受控回归通过；直接上游 26/27 适配已确认继承，但未确认每条旧报告已消失。无需以具备对应系统环境作为继续开发的前置条件。

范围：明确支持矩阵、签名与权限、复现数据格式；判断 PR #995 报告的实现适用性。

| 工作包 | 内容 | 条目数 | 排期考虑 |
| --- | --- | ---: | --- |
| B1 | 工程、复现材料与实现适用性 | 9 | 补齐系统/应用版本、设置、复现步骤、日志，并判断当前实现是否适用。 |

**验收条件：** 现有 Debug/Release、lint 和受控回归作为起点；每个拟修复任务有版本、配置、最小步骤与日志。不可用截图/笼统报告先补信息，不直接猜补丁。

工程基线包括现有 `Floe.xcodeproj`、SPM 锁定版本、独立 Bundle ID、构建/lint/受控回归。待补充的是实机环境与报告证据。PR #995 的 Concealer27/MacOS27Layout/点击重放报告先做适用性判断；当前代码没有相关类，不作为“已修复”或默认需要移植的依据。

### M1：稳定性与基础图标发现

2026-10-14 C0 实施见 [C0 防护与验证记录](c0-issue-audit.md)：菜单交互保护、自动焦点切换防重入、原宿主恢复、计时器恢复与重复状态项长度更新去重均已实现；3 条报告仍保留 P0 和待调查范围，不将受控回归视为系统卡死/残留根因已消除。

2026-10-14 首批实施见 [M1 核对与修复记录](m1-issue-audit.md)：截图主线程隔离、有界等待、指针释放与旧图片淘汰已实现。`jordanbaird/Ice#925` 的已定位溢出根因通过生产 getter 与浮栏定位回归，移入已修复审计；M1 待处理 83 → 82，总清单 380 → 379。其余部分修复/调查条目继续保留，不将首批交付视为整个 M1 已完成。

2026-10-14 C1 后续见 [C1 核对与修复记录](c1-issue-audit.md)：29 条状态/评论已刷新，修复事件 tap 失效后的永久等待、输入等待的取消/超时，同分区显示请求的重入覆盖，CGS 窗口数量/列表边界导致的 trap，以及移动到位忙轮询和取消失效；原报告仍需对应系统验证，第五批 #563 和第六批 7 条窗口 ID 溢出精确签名均已按代码层归档，第七批再归档 #796/#905，第八批归档 #603/#742，当前 C1 17 条、M1 70 条、总清单 367 条。

2026-10-14 C2 首批见 [C2 核对与修复](c2-issue-audit.md)：全部 45 条已刷新并逐条审计；修复缓存 fallback、CGS/AX 合并、每宿主 AX 预算、扫描生命周期及页面持续刷新。原场景尚未全部验收，逐条条件见审计。C2 45 条与总清单数量不变。

2026-10-14 C3 核对见 [C3 核对与修复](c3-issue-audit.md)：三条状态/评论已刷新；修复授权等待重入、窗口关闭后的任务遗留及应用重新激活时的权限状态刷新；等待者共享检测，撤权后恢复轮询；申请前核实当前授权，避免重复请求。原报告验收条件尚未满足，C3 3 条与总清单数量不变。

2026-10-14 C4 核对见 [C4 核对与优化](c4-issue-audit.md)：两条状态/评论已刷新；修复图片批次取消后继续截图/发布，后台截图增加显式临时对象回收，提前完成/取消时回收超时源。36 小时对照尚未完成，C4 2 条与总清单数量不变。

范围：系统级异常调查、崩溃/冻结、权限阻塞、布局空白/持续加载及长时内存增长。

| 工作包 | 内容 | 条目数 | 排期考虑 |
| --- | --- | ---: | --- |
| C0 | 系统级异常与不可恢复状态 | 3 | 影响范围超出 Floe；优先隔离、查证因果并建立恢复办法。 |
| C1 | 崩溃、无响应与启动失败 | 17 | 基本可用性阻塞；先定位堆栈、卡住的线程及生命周期。 |
| C2 | 布局发现、空白与持续加载 | 45 | 基础图标管理不可用，后续分区和交互工作依赖发现链路。 |
| C3 | 权限检测与启动授权 | 3 | 权限状态冲突或启动无法完成，需要核实真实 TCC 状态。 |
| C4 | 长期运行与内存增长 | 2 | 资源持续增长影响长期稳定性，需长时对照测量。 |

**验收条件：** 可用环境中不再有启动/常规操作崩溃或无限等待；布局能显示可发现的项目，缺失时有明确诊断；适用的 P0 风险有调查结论和恢复策略，内存问题有长时对照结果。

长时稳定性至少覆盖 #908 报告约 33 小时的观察窗口，建议同环境连续记录不少于 36 小时。时间长度本身不保证复现，必须同时保留实际设置与对照组。P0 调查未完结时，不把其他测试通过当作其完成证据。

### M2：分区管理与完整交互

2026-10-14 完整核对与代码优化见 [M2 核对与优化](m2-issue-audit.md) 和 [逐条状态](m2-status.json)：63 条原文/评论已刷新并逐条登记。实施拖拽取消与落点核验、延迟交互协调、菜单/浮栏生命周期、CGS 唯一身份布局恢复、独立搜索与名称回退；修正 always-hidden 禁用时的菜单避让及 Option-click 组合。原场景真机验收与 AX-only 持久化仍未完成，M2 63 条与总清单数量不变。

范围：拖拽真实结果、排序/归属持久化、展开收起、点击命中、菜单操作期间不误隐藏。

| 工作包 | 内容 | 条目数 | 排期考虑 |
| --- | --- | ---: | --- |
| I1 | 分区拖拽、排序与持久化 | 17 | 图标进入错误分区或位置不保留，影响隐藏管理的可信度。 |
| I2 | 展开收起、悬停与重新隐藏 | 31 | 展开收起或交互时机异常，影响隐藏项目的实际访问。 |
| I3 | 点击命中与菜单生命周期 | 13 | 误点、无法打开菜单或操作中菜单消失，必须覆盖真实点击链路。 |
| I4 | 搜索与项目识别 | 2 | 搜索/项目名称影响定位效率，需确认当前功能入口和数据来源。 |

**验收条件：** UI 分区与真实菜单栏一致；拖拽、退出/重启、更新应用后仍可核验；AX 与 CGS 两条路径都验证菜单/子菜单/自定义弹窗以及取消、快速重复操作。

拖拽与持久化要验证：重启、应用重新生成状态项、启用/关闭 always-hidden、快速重复点击、打开菜单后取消、子菜单关闭及用户在暂时显示期间改变选择。测试需要区分 AX 与 CGS，不把一条分支的测试结果推广到另一条。

### M3：多屏、系统模式与应用兼容

2026-10-14 持续优化见 [M3 核对与优化](m3-issue-audit.md) 和 [逐条状态](m3-status.json)：94 条原文/评论已核对；修正多屏命中、图片实例身份、屏幕/Space/颜色代次、外观显示校验与睡眠唤醒清理、浮栏跨屏重绑定和自动隐藏 AX 回退、宿主恢复重试。三屏实际几何已只读确认；探针权限、macOS 26/27 和特定宿主原场景仍阻塞整体验收，M3 94 条与总清单数量不变。

范围：合盖、外接屏、缩放、全屏/Spaces、系统自动隐藏、重复实例、Live Activities 和系统 HUD。

| 工作包 | 内容 | 条目数 | 排期考虑 |
| --- | --- | ---: | --- |
| S1 | 多显示器、合盖与缩放 | 41 | 依赖屏幕布局和活动屏，需要外接屏及不同缩放实测。 |
| S2 | 全屏、自动隐藏与 Spaces | 15 | 需验证菜单栏显示时机、切换空间和全屏交互。 |
| S3 | 第三方应用、多实例与系统项目 | 38 | 应用/系统项目有特殊行为，通用测试不能替代对应宿主验证。 |

**验收条件：** 相关报告分别在其显示器/系统/应用组合中复测；非菜单栏区域不拦截其他应用点击；主副屏缩放正确，特殊项目仍可访问且不丢失。

### M4：外观与常态性能

2026-10-14 优化见 [M4 审计](m4-issue-audit.md) 和 [逐条状态](m4-status.json)：40 条上游原文/分页评论已刷新；修正颜色选择器反馈、吸管外部点击中断、背景 tint、鼠标订阅启停、隐藏外观周期工作及间距退出超时。原系统视觉和真实能耗对照未完成，40 条与总清单数量不变。

范围：样式、色彩、透明度、阴影、边界、颜色选择器以及常态 CPU/能耗。

| 工作包 | 内容 | 条目数 | 排期考虑 |
| --- | --- | ---: | --- |
| V1 | 菜单栏外观、颜色与渲染 | 36 | 核心功能可用后处理样式、像素边界和视觉一致性。 |
| V2 | CPU、能耗与常态性能 | 4 | 已有节流不能代替测量，应以真实能耗和线程采样决定改动。 |

**验收条件：** 主题/壁纸/Spaces 切换和外观操作有截图/视频对照，样式不遮挡图标；性能用同环境启停对照和线程采样验证，不能以“加了缓存”作为完成结论。

### M5：产品能力扩展

范围：默认图标规则、中文/其他本地化、VoiceOver、按屏幕策略、配置管理、Floe Bar 增强和自动化。

| 工作包 | 内容 | 条目数 | 排期考虑 |
| --- | --- | ---: | --- |
| F1 | 默认位置、分组、Profiles 与同步 | 14 | 需要产品规则和存储模型，避免扩展需求打断核心缺陷修复。 |
| F2 | 本地化、RTL 与无障碍 | 7 | 明确语言/辅助交互覆盖面，先设计可验证的最小范围。 |
| F3 | 快捷键、自动化与对外 API | 8 | 需要定义入口和兼容契约；在核心模型稳定后扩展。 |
| F4 | Floe Bar 布局及操作增强 | 31 | 属于体验/功能扩展，应先确认必要性和可访问性。 |
| F5 | 按显示器自适应与布局规则 | 16 | 依赖多屏基础行为稳定，再引入自动策略和配置。 |
| F6 | 安装分发、更新策略与帮助 | 3 | 区分本项目可建设的分发能力与上游网站/发布诉求。 |

**验收条件：** 先明确产品行为及测试范围，再选择最小实现；每个纳入的需求有独立验收。不把全部功能请求绑定成一次发布。

建议先选择 P2 中的默认图标规则、VoiceOver/键盘可访问性、中文与按屏幕策略；Profiles/分组、同步、Widgets、GIF 和自动化接口等 P3 需求再独立评估。Floe 自动更新依然需要自己的真实更新源和公钥，不能复用上游 Ice 的发布渠道或虚构已存在的 Homebrew tap。

### Triage：上游沟通与外部事项

范围：上游网站/维护状态/感谢/第三方分发信息，识别是否需要转换为 Floe 自己的任务。

| 工作包 | 内容 | 条目数 | 排期考虑 |
| --- | --- | ---: | --- |
| T1 | 上游沟通、网站与社区信息 | 12 | 主要是上游维护/网站/社区事项，先确认可行动性与责任范围。 |

**验收条件：** 得到可行动结论后新建本地任务或转入其他里程碑；保持与纯源码缺陷的边界。

## 统一验证矩阵

| 维度 | 必要场景 | 证据 |
| --- | --- | --- |
| 系统与数据来源 | 支持范围内的 macOS 14/15、26、27；CGS 正常与 AX 兜底；版本升级 | 版本、签名、权限、发现数量、分隔符状态与日志 |
| 显示器 | 单内屏、单外屏、多屏；合盖、主副屏切换；不同缩放、竖屏、刘海及 Sidecar | 屏幕坐标/缩放数据与截图；未具备的设备明确记为未验证 |
| 系统显示模式 | 自动隐藏关闭/开启；全屏视频/应用；Spaces/Mission Control；独立 Spaces 开关 | 操作录屏、实际点击命中与窗口层级 |
| 应用与状态项 | 系统 HUD/Live Activities；同一应用多个图标；图标重新生成/应用重启；自定义弹窗 | 对应应用名称和版本、项身份、菜单生命周期 |
| 权限与启动 | 新授权、已授权、拒绝、运行中补授权；重新签名；登录启动 | 真实 TCC 状态与设置 UI，不以 Skip 代替权限功能验收 |
| 长期与资源 | 持续运行，重复捕获/切换屏幕/显示隐藏；关闭 Floe 的同环境对照 | 内存/CPU/WindowServer/窗口数量时间序列与采样 |

验证前先保留受控回归结果；实机组合没执行就是未验证。设备不足的场景不应靠一次本机编译替代，也不因此自动标记为已修复。

## 全量优先级索引

以下包含全部 380 条，每条只出现一次；按 P0→P3、里程碑、工作包及仓库/编号排序。原始标题不改写，每条附上游链接。理由是排期依据，不是已确认根因。

### P0（3 条）

| 里程碑 | 工作包 | Issue | 标题原文 | 安排理由 | 状态 |
| --- | --- | --- | --- | --- | --- |
| M1 | C0 | [jordanbaird/Ice #908](https://github.com/jordanbaird/Ice/issues/908) | [Bug]: Ice appears to have caused system-wide freeze & kernel panic after ~33 hours of uptime | 报告涉及系统卡死、Dock/前台应用异常或无法关闭的窗口；先调查因果，不预设 Floe 是原因。 | 防护已实现 · 扫描合并/状态项去重；系统因果未确认 |
| M1 | C0 | [jordanbaird/Ice #968](https://github.com/jordanbaird/Ice/issues/968) | macOS 26.5.2: Ice stuck / menu bar stays hidden after form dropdown hang (Dock auto-hide also stuck) | 报告涉及系统卡死、Dock/前台应用异常或无法关闭的窗口；先调查因果，不预设 Floe 是原因。 | 防护已实现 · popup/焦点保护；系统复测待补 |
| M1 | C0 | [jordanbaird/Ice #974](https://github.com/jordanbaird/Ice/issues/974) | [Bug]: Orphaned application menu-bar windows stuck at CGWindow layer 101, invisible to accessibility (macOS 26.6.1, 0.11.13-dev.2) | 报告涉及系统卡死、Dock/前台应用异常或无法关闭的窗口；先调查因果，不预设 Floe 是原因。 | 防护已实现 · 跟踪期间避免干预；残留因果未确认 |

### P1（198 条）

| 里程碑 | 工作包 | Issue | 标题原文 | 安排理由 | 状态 |
| --- | --- | --- | --- | --- | --- |
| M0 | B1 | [jordanbaird/Ice #633](https://github.com/jordanbaird/Ice/issues/633) | [Bug]:macOS Tahoe 26中ice无法正常使用 | 正文已明确展开后退出；评论有上游 beta 修复线索，需保留崩溃栈并在对应系统复测。 | 适配已继承 · 报告级修复未确认 |
| M0 | B1 | [jordanbaird/Ice #954](https://github.com/jordanbaird/Ice/issues/954) | [Bug]: Ice in menu bar not working anymore (MacOS Golden Gate 27) | 报告基本功能异常但根因/场景不清晰，优先补最小复现后转入对应工作包。 | 适配已继承 · 报告级修复未确认 |
| M0 | B1 | [jordanbaird/Ice #957](https://github.com/jordanbaird/Ice/issues/957) | [Bug]: Starts but nothing much more | 报告基本功能异常但根因/场景不清晰，优先补最小复现后转入对应工作包。 | 材料不足 · 安装来源不明 |
| M0 | B1 | [jordanbaird/Ice #991](https://github.com/jordanbaird/Ice/issues/991) | [Bug]: MacOS 27 Update | 报告系统升级后基本不可用，但缺少具体链路；优先补证据，随后转入对应缺陷里程碑。 | 适配已继承 · 报告级修复未确认 |
| M1 | C1 | [jordanbaird/Ice #590](https://github.com/jordanbaird/Ice/issues/590) | App duplicates itself in dock on Tahoe | 重复 Dock 实例且无法强制退出，先查生命周期和无响应。 | 相关防护已实现 · 显示请求重入隔离；Dock 症状待定位 |
| M1 | C1 | [jordanbaird/Ice #635](https://github.com/jordanbaird/Ice/issues/635) | Weird behavior under Tahoe MacOS 26 Public Beta 2 | 正文同时有空白浮栏和点击崩溃，先处理崩溃，再分别验证空白。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #647](https://github.com/jordanbaird/Ice/issues/647) | [Bug]: <MacOS Tahoe app craches> | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 相关防护已继承 · 评论确认整数溢出；完整报告待验证 |
| M1 | C1 | [jordanbaird/Ice #665](https://github.com/jordanbaird/Ice/issues/665) | [Bug]: MacOS Tahoe Makes Ice Bar Invisible | 正文包含选择 icon 位置后崩溃，不能只按 invisible 归为样式问题。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #671](https://github.com/jordanbaird/Ice/issues/671) | [Bug]: unexpected closure | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #721](https://github.com/jordanbaird/Ice/issues/721) | [Bug]: Latest Tahoe Beta update gives Ice error, Ice freezes | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #740](https://github.com/jordanbaird/Ice/issues/740) | [Bug]: Crashes every time I use it | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #746](https://github.com/jordanbaird/Ice/issues/746) | [Bug]: Event operation timed out | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 部分修复 · 移动/恢复生命周期；拖动失败根因待复测 |
| M1 | C1 | [jordanbaird/Ice #777](https://github.com/jordanbaird/Ice/issues/777) | [Bug]:  Ice App Freezes During Screen Capture Operations | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 部分修复 · 截图超时/取消收尾；系统阻塞待定位 |
| M1 | C1 | [jordanbaird/Ice #786](https://github.com/jordanbaird/Ice/issues/786) | [Bug]:Selecting 'Ice Bar' in settings and then tapping on the Ice icon causes Ice to crash | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #790](https://github.com/jordanbaird/Ice/issues/790) | [Bug]: Multiple monitors freeze | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 相关防护已实现 · 跨屏旧显示请求淘汰；冻结因果待定位 |
| M1 | C1 | [jordanbaird/Ice #807](https://github.com/jordanbaird/Ice/issues/807) | [Bug]: [Macbook Pro, M4 Pro] Not responding | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 调查中 · 已读布局递归日志；无响应线程待定位 |
| M1 | C1 | [jordanbaird/Ice #838](https://github.com/jordanbaird/Ice/issues/838) | [Bug]: it seems to be frozen. I have to quit it and re-launch it to get it to function properly. | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #840](https://github.com/jordanbaird/Ice/issues/840) | Crash when enabling Ice Bar: EXC_BREAKPOINT in window handling | 报告 Floe Bar 启用路径崩溃；安全整数转换只排除一个候选根因，仍需定位。 | 相关防护已继承 · 保留原报告验收 |
| M1 | C1 | [jordanbaird/Ice #855](https://github.com/jordanbaird/Ice/issues/855) | [Bug]: Ice keeps crashing after updating to OS26.2 | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #877](https://github.com/jordanbaird/Ice/issues/877) | [Bug]: PROJECT DEAD, no updates in 1.5 years, crashes all the time. | 正文含更新阻塞、Floe Bar 崩溃和图标缺失，不能只当作维护状态询问；拆分验证各子问题。 | 待复现/验证 |
| M1 | C1 | [jordanbaird/Ice #977](https://github.com/jordanbaird/Ice/issues/977) | [Bug]: crashes whenever I use the trigger button in the menu bar | 崩溃或无响应阻塞基本使用；优先确认堆栈和最小复现。 | 已核对 · 点击崩溃栈未符号化；保留报告验收 |
| M1 | C2 | [cavaldos/Ice #9](https://github.com/cavaldos/Ice/issues/9) | [Bug]: Nothing is being shown on "Menu Bar Layout" in settings | 当前直接上游：布局空白同时阻塞查看与分区拖拽。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #283](https://github.com/jordanbaird/Ice/issues/283) | [Bug]: Ice's view of the menu bar is missing the icon for AltTab | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #312](https://github.com/jordanbaird/Ice/issues/312) | [Bug]: No items in Menu Bar | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #623](https://github.com/jordanbaird/Ice/issues/623) | [Bug]:Icons in MenuBar Layout page Disappear After Using ICE Bar in Full-Screen Mode | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 迟到扫描/快照恢复 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #643](https://github.com/jordanbaird/Ice/issues/643) | [Bug]: Completely lost Stats app when dragging into Menu Bar Layout section | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 已核对 · 系统允许列表线索，未修改第三方设置 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #655](https://github.com/jordanbaird/Ice/issues/655) | [Bug]: ICE - Some Apps icons not appearing in the Menu Bar Layout setting | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #664](https://github.com/jordanbaird/Ice/issues/664) | [Bug]: MacOS Tahoe Breaks Menu Bar Layout Editor | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #677](https://github.com/jordanbaird/Ice/issues/677) | [Bug]: Ice bar do not work:endless loading menu bar items | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描生命周期 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #679](https://github.com/jordanbaird/Ice/issues/679) | [Bug]: "Unable to display menu bar items" on macOS Tahoe/Ice 0.11.13-dev.2 | 已授权后布局与浮栏都无法展示，先查发现/缓存链路。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #682](https://github.com/jordanbaird/Ice/issues/682) | [Bug]: <Menebar Layout Pane> | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #685](https://github.com/jordanbaird/Ice/issues/685) | Whitened sections in Menu Bar Layout | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #687](https://github.com/jordanbaird/Ice/issues/687) | [Bug]: Doesn't display menu bar layout | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描生命周期 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #696](https://github.com/jordanbaird/Ice/issues/696) | [Bug]: nothing showing up in the menu editing | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 已核对 · 发现与布局路径修复，缺少具体根因 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #710](https://github.com/jordanbaird/Ice/issues/710) | [Bug]: Ice shows "Unable to display menu bar item" under macOS 26 Tahoe | Unable to display 指无法显示菜单栏项目，属于基础发现/展示问题。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #711](https://github.com/jordanbaird/Ice/issues/711) | [Bug]: "Unable to display menu bar items" \| macOS Tahoe Version 26.0 (25A354) \| Ice 0.11.13-dev.2 | 布局与浮栏均无法显示且已授权，属于基础数据链路阻塞。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #716](https://github.com/jordanbaird/Ice/issues/716) | [Bug]: Menu Bar Layout BLANK (can't see any icons) | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #730](https://github.com/jordanbaird/Ice/issues/730) | [Bug]: Menu bar layout in settings bug | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #741](https://github.com/jordanbaird/Ice/issues/741) | [Bug]: Apps gone from Ice Layout | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #743](https://github.com/jordanbaird/Ice/issues/743) | [Bug]: I cannot see any icons | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #744](https://github.com/jordanbaird/Ice/issues/744) | [Bug]: Menu Bar Layout settings is empty | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #753](https://github.com/jordanbaird/Ice/issues/753) | [Bug]: Always Hidden items are empty under new Tahoe Beta 4 | 隐藏区没有可显示项目，先确认发现与分区数据来源。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #758](https://github.com/jordanbaird/Ice/issues/758) | [Bug]: Unable to re-arrange menu bar via Ice app | 正文指出布局页面无项目，先解决发现和展示再验证拖拽。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #762](https://github.com/jordanbaird/Ice/issues/762) | [Bug]: Cannot use Ice Bar nor Menu Bar layout icons | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #773](https://github.com/jordanbaird/Ice/issues/773) | [Bug]: Menu Bar Layout empty - All icons in hidden section | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #802](https://github.com/jordanbaird/Ice/issues/802) | [Bug]: After updating the Mac version, the layout settings disappeared. | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 已核对 · 发现与布局路径修复，缺少具体根因 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #816](https://github.com/jordanbaird/Ice/issues/816) | [Bug]: Menu Bar Layout does not give option to customize anything | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #818](https://github.com/jordanbaird/Ice/issues/818) | [Bug]: Menu bar layout editor is just empty/white | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #832](https://github.com/jordanbaird/Ice/issues/832) | [Bug]: Menu Bar Layout with Tahoe OS | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #835](https://github.com/jordanbaird/Ice/issues/835) | [Bug]: Ice stopped doing anything other than changing the Bar's appearance | 正文同时描述隐藏失效和布局页空白，先查核心发现链路。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #846](https://github.com/jordanbaird/Ice/issues/846) | [Bug]: MenuBar in Settings Is Empty White Space | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #872](https://github.com/jordanbaird/Ice/issues/872) | [Bug]: Unstable, Layout menu area broken | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #878](https://github.com/jordanbaird/Ice/issues/878) | [Bug]: Menu bar items are not appearing | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #891](https://github.com/jordanbaird/Ice/issues/891) | [Bug]: ICons List Blank In Settings | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · AX 独立额度/混合补充/持续刷新 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #913](https://github.com/jordanbaird/Ice/issues/913) | [Bug]: Settings Menu: Menu Bar Layout Icons Do Not Appear | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #916](https://github.com/jordanbaird/Ice/issues/916) | [Bug]:  I can't edit my layout, because it's all blank | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 已核对 · 发现与布局路径修复，缺少具体根因 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #919](https://github.com/jordanbaird/Ice/issues/919) | [Bug]: Ice icon dissappeared | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描取消 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #921](https://github.com/jordanbaird/Ice/issues/921) | [Bug]: Icons in re-arrange menu in settings aren't visible | 设置中的整理列表没有可见图标，阻塞布局编辑。 | 已核对 · 发现与布局路径修复，缺少具体根因 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #951](https://github.com/jordanbaird/Ice/issues/951) | [Bug]: Can't view the icons on Menu Bar Layout | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 已核对 · 发现与布局路径修复，缺少具体根因 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #965](https://github.com/jordanbaird/Ice/issues/965) | [Bug]: Menubar layout broken/spinning in MacOS 27 Public Beta | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描生命周期 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #973](https://github.com/jordanbaird/Ice/issues/973) | [Bug]: Menu bar layout shown nothing on the sections | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · fallback/合并/刷新/快照 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #992](https://github.com/jordanbaird/Ice/issues/992) | [Bug]: unavailable under MacOS27 | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描生命周期 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #999](https://github.com/jordanbaird/Ice/issues/999) | [Bug]: Can't see layout | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 已核对 · 发现与布局路径修复，缺少具体根因 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #1003](https://github.com/jordanbaird/Ice/issues/1003) | [Bug]: [Bug]: Updated to MacOS 27.0.1 and cannot customize Menu Bar Layout on Ice | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描生命周期 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #1009](https://github.com/jordanbaird/Ice/issues/1009) | [Bug]: | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描生命周期 · 完整报告保留 |
| M1 | C2 | [jordanbaird/Ice #1010](https://github.com/jordanbaird/Ice/issues/1010) | [Bug]: always loading meum bar items | 布局页/发现链路不可用，阻塞图标管理；先确认缺失数据、权限和分隔符。 | 相关代码已修复 · 发现预算/扫描生命周期 · 完整报告保留 |
| M1 | C3 | [jordanbaird/Ice #770](https://github.com/jordanbaird/Ice/issues/770) | [Bug]: App gets stuck when installed | 权限、启动或安装路径可能阻塞应用使用；先核实实际权限及签名状态。 | 已有防护 · 禁用 Sparkle 首启询问；原场景待验收 |
| M1 | C3 | [jordanbaird/Ice #834](https://github.com/jordanbaird/Ice/issues/834) | [Bug]: | 已授权但仍出现权限/对话框异常，存在启动与使用阻塞。 | 相关代码已修复 · 授权等待与返回应用刷新 |
| M1 | C3 | [jordanbaird/Ice #934](https://github.com/jordanbaird/Ice/issues/934) | [Bug]: Nothing happens when I try to run Ice | 权限、启动或安装路径可能阻塞应用使用；先核实实际权限及签名状态。 | 已核对 · 外接屏线索；根因未确认 |
| M1 | C4 | [jordanbaird/Ice #530](https://github.com/jordanbaird/Ice/issues/530) | [Bug]: high memory usage | 报告持续内存增长或 WindowServer 泄漏，需要长时对照定位，不能仅凭短时回归排除。 | 部分修复 · 截图取消收尾/临时对象释放；长时验收待补 |
| M1 | C4 | [jordanbaird/Ice #819](https://github.com/jordanbaird/Ice/issues/819) | [Bug]: memory leak in WindowServer caused by Ice? | 报告持续内存增长或 WindowServer 泄漏，需要长时对照定位，不能仅凭短时回归排除。 | 部分修复 · 截图取消收尾/临时对象释放；长时验收待补 |
| M2 | I1 | [cavaldos/Ice #24](https://github.com/cavaldos/Ice/issues/24) | [Bug]: Dropping icons to hide has no effect | 当前直接上游：拖拽后回弹，UI 与实际隐藏状态不一致。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #233](https://github.com/jordanbaird/Ice/issues/233) | [Bug]:  Re-arranging/dragging  items  in the "Hidden" settings pane makes them disappear  | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #344](https://github.com/jordanbaird/Ice/issues/344) | [Bug]: Menu bar items move to hidden or always hidden section | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #512](https://github.com/jordanbaird/Ice/issues/512) | [Bug]: Lack of sync among windows | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #513](https://github.com/jordanbaird/Ice/issues/513) | [Bug]: Hidden icons end up in the Visible section after some interactions | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #661](https://github.com/jordanbaird/Ice/issues/661) | [Bug]: When visible section application is updated, it will go to hidden section. | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #666](https://github.com/jordanbaird/Ice/issues/666) | [Bug]: Items that change become hidden | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #675](https://github.com/jordanbaird/Ice/issues/675) | [Bug]: Always Hidden Icons Disappeared. | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #702](https://github.com/jordanbaird/Ice/issues/702) | [Bug]: Hidden items randomly moved to always hidden items | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #723](https://github.com/jordanbaird/Ice/issues/723) | [Bug]: Icons don’t stay at its place - they flip after restart (Sequoia & Tahoe) | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #769](https://github.com/jordanbaird/Ice/issues/769) | [Bug]: Menu Bar Layout gets reordered when i close the Ice app | 关闭应用后布局重排，需验证排序和退出/重启持久化。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #771](https://github.com/jordanbaird/Ice/issues/771) | [Bug]: Shortcut Gets Hidden After Restart | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #781](https://github.com/jordanbaird/Ice/issues/781) | [Bug]: ICE menu icon non showing anymore | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #799](https://github.com/jordanbaird/Ice/issues/799) | [Bug]: Menu bar items not disappearing | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #861](https://github.com/jordanbaird/Ice/issues/861) | [Bug]: unable to move icons to hidden section | 实际分区或顺序与用户选择不一致，需验证拖拽结果和重启后的状态。 | 待复现/验证 |
| M2 | I1 | [jordanbaird/Ice #946](https://github.com/jordanbaird/Ice/issues/946) | [Bug]: MacOS Tahoe 26.5 update broke hidden elements in ice layout | 系统升级后隐藏项目错误进入 always-hidden，先验证归属与持久化。 | 待复现/验证 |
| M2 | I2 | [cavaldos/Ice #12](https://github.com/cavaldos/Ice/issues/12) | [Bug]: Collapse/Expand button in menu bar is not working | 当前直接上游：展开/收起失效，影响核心访问入口。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #403](https://github.com/jordanbaird/Ice/issues/403) | [Bug]: Make smart mode smarter: Don't collapse the menu bar icons when toggling switches of switch app | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #434](https://github.com/jordanbaird/Ice/issues/434) | [Bug]: Hide Application Menus doesn't unless Enable always-hidden section is toggled on | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #452](https://github.com/jordanbaird/Ice/issues/452) | [Bug]: Automatically rehide takes affect even when inside a hidden items menu options | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #485](https://github.com/jordanbaird/Ice/issues/485) | [Bug]: Cannot show any menu bar items in hidden section | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #545](https://github.com/jordanbaird/Ice/issues/545) | [Bug]: ice bar sometimes doesn't show anything | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #619](https://github.com/jordanbaird/Ice/issues/619) | [Bug]: Unable to Restore Menu Item After Removing Duplicate Chevron Icon | 移除重复主控制图标后无法恢复，需提供可恢复的访问路径。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #620](https://github.com/jordanbaird/Ice/issues/620) | [Bug]:Hide application menus when showing menu bar items | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #694](https://github.com/jordanbaird/Ice/issues/694) | [Bug]: Once opened does not go back again | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #717](https://github.com/jordanbaird/Ice/issues/717) | [Bug]: Show on swipe works but not scroll | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #759](https://github.com/jordanbaird/Ice/issues/759) | [Bug]: Ice Icon Disappearing after Hidden Items are shown | 显示隐藏项后主控制图标消失且须重新打开，阻塞常规收起流程。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #813](https://github.com/jordanbaird/Ice/issues/813) | [Bug]: Ice bar closes soon after opening | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #814](https://github.com/jordanbaird/Ice/issues/814) | [Bug]: "Use Ice Bar" feature does not work | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #865](https://github.com/jordanbaird/Ice/issues/865) | [Bug]: macOS 26.3 beta 3 prevents Ice from expanding | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #871](https://github.com/jordanbaird/Ice/issues/871) | [Bug]: Unable to click on secondary menu bar icons, the bar disappears | secondary menu 指浮栏，正文为移动鼠标时立即关闭，不假定是第二显示器。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #879](https://github.com/jordanbaird/Ice/issues/879) | [Bug]: "hide app menus when showing menu bar items" feature not working | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #888](https://github.com/jordanbaird/Ice/issues/888) | [Bug]: Cannot use ice bar when which between windows | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #890](https://github.com/jordanbaird/Ice/issues/890) | [Bug]: Ice Bar | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #906](https://github.com/jordanbaird/Ice/issues/906) | [Bug]: App opens in dock when expanding the bar | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #970](https://github.com/jordanbaird/Ice/issues/970) | [Bug]: Not automatically hiding in MacOS 27 | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #996](https://github.com/jordanbaird/Ice/issues/996) | [Bug]: Ice not working properly on macOS 27 Golden Gate | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #1008](https://github.com/jordanbaird/Ice/issues/1008) | [Bug]: Not functioning since MacOS 27 update on my Macbook pro M3 pro | 展开、隐藏或 Floe Bar 基本使用异常，优先验证触发与生命周期。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #316](https://github.com/jordanbaird/Ice/issues/316) | [Bug]: Items rehidden after selecting "Show the Hidden Section" in Ice icon menu with "Show on hover" setting enabled | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #567](https://github.com/jordanbaird/Ice/issues/567) | [Bug]: Clicking on the menus in some apps triggers Ice | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #584](https://github.com/jordanbaird/Ice/issues/584) | [Bug]: macOS 26 application menu change to ice empty menu when clicking on empty space on menu bar to expand collapse items | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #621](https://github.com/jordanbaird/Ice/issues/621) | [Bug]: Can't fully interact with hidden menu items | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #640](https://github.com/jordanbaird/Ice/issues/640) | [Bug]: Strange Mouse Behavior After Clicking Hidden Icon | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #686](https://github.com/jordanbaird/Ice/issues/686) | [Bug]: <bug title>Ice bar won't let me choose app | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #751](https://github.com/jordanbaird/Ice/issues/751) | [Bug]: The cursor is not visible after clicking the ICE icon and then selecting a hidden icon from the ICE bar. | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #755](https://github.com/jordanbaird/Ice/issues/755) | [Bug]: Dropped menubar clicks | 菜单栏点击被丢弃，直接影响图标交互。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #757](https://github.com/jordanbaird/Ice/issues/757) | [Bug]: Pointer disappearing after clicking on icons in ICE popup bar | 选择浮栏图标后鼠标指针消失，影响后续交互。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #768](https://github.com/jordanbaird/Ice/issues/768) | [Bug]: ICE dock icon apeears when clicking on chevron to show menu. | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #826](https://github.com/jordanbaird/Ice/issues/826) | [Bug]: Not opening menu item | 正文为电池菜单点击后不打开，属于点击链路问题，不是应用启动失败。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #845](https://github.com/jordanbaird/Ice/issues/845) | [Bug]: Hidden menubar items not selectable | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M2 | I3 | [jordanbaird/Ice #914](https://github.com/jordanbaird/Ice/issues/914) | [Bug]: Ice Bar auto-hides before cursor reaches it (latest beta) | 真实点击、选择或菜单操作受影响，需要同时覆盖 AX 和 CGS 路径。 | 待复现/验证 |
| M3 | S1 | [cavaldos/Ice #5](https://github.com/cavaldos/Ice/issues/5) | [Bug]: issue on second screen in clamshell mode | 当前直接上游的合盖外接屏隐藏失效；优先覆盖实际使用场景。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #94](https://github.com/jordanbaird/Ice/issues/94) | [Bug]: Icons not hidden in ultra wide screen | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #260](https://github.com/jordanbaird/Ice/issues/260) | [Bug]: Both inset menu bar shape and Ice Bar are too short on notched display when set to a lower resolution | 降低分辨率后形状过短并裁切项目，需验证实际访问与尺寸。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #383](https://github.com/jordanbaird/Ice/issues/383) | [Bug]: Disabling displays have separate spaces not working | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #416](https://github.com/jordanbaird/Ice/issues/416) | [Bug]: menubar icons disappear when active app menus extend to the right | 应用菜单过长使图标不可访问，需验证空间不足和刘海边界。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #456](https://github.com/jordanbaird/Ice/issues/456) | [Bug]: Ice interferes with right-click on title bar on display where menu bar is not displayed | 无菜单栏显示器上的窗口标题栏右键被干扰，影响其他应用操作。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #486](https://github.com/jordanbaird/Ice/issues/486) | Zoomed-in part of the screen sometimes jumps around when macOS Display Zoom is active (while running Ice) | Display Zoom 用户视野随模拟鼠标跳动，影响无障碍使用。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #573](https://github.com/jordanbaird/Ice/issues/573) | [Bug]: Widescreen Monitors Hidden Menu Always Visible | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #589](https://github.com/jordanbaird/Ice/issues/589) | [Bug]: Menu items disappear when there is no room left | 空间不足时图标丢失，涉及实际可访问性而非纯视觉样式。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #639](https://github.com/jordanbaird/Ice/issues/639) | [Bug]: Menu bar on multiple displays | 无菜单栏显示器上的 Chrome 右键被拦截，影响其他应用操作。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #646](https://github.com/jordanbaird/Ice/issues/646) | [Bug]: Clickable area to activate Ice extends beyond menu bar to blank area of 2nd monitor. | 第二屏无菜单栏区域仍触发展开，事件命中区域不正确。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #698](https://github.com/jordanbaird/Ice/issues/698) | [Bug]: On Tahoe, Items appear different sizes across monitor and laptop screen | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #715](https://github.com/jordanbaird/Ice/issues/715) | [Bug]: If a system menu icon/text winds up in the notch area, it simply disappears! | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #824](https://github.com/jordanbaird/Ice/issues/824) | [Bug]: Right-clicking in external monitor opens "Edit menu bar appearance" menu | 非主屏窗口中的右键触发 Floe 菜单，干扰其他应用。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #825](https://github.com/jordanbaird/Ice/issues/825) | [Bug]: "show on click" on secondary screen shows the extra Ice bar in a small resolution | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #829](https://github.com/jordanbaird/Ice/issues/829) | [Bug]: the ice bar cannot show the proper size when second monitor connected | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #836](https://github.com/jordanbaird/Ice/issues/836) | [Bug]: Ice didn't work on external monitor menu-bar on auto-hide | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #929](https://github.com/jordanbaird/Ice/issues/929) | [Bug]: Menu bar scaling and layout issues on external/built-in displays (macOS 26.4.1) | 正文包含外接屏/内屏图标缩放异常，需验证尺寸和实际可操作性。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #955](https://github.com/jordanbaird/Ice/issues/955) | [Bug]: Scale error and auto-deploying | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #987](https://github.com/jordanbaird/Ice/issues/987) | [Bug]: Ice Bar icons shrink drastically when expanded on an external display | 多屏导致核心隐藏/访问或尺寸可用性异常，优先做场景复现。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #201](https://github.com/jordanbaird/Ice/issues/201) | [Bug]: Can't arrange or display menu bar items when the menu bar is automatically hidden | 系统菜单栏自动隐藏时编辑与点击异常，验证 auto-hide 模式。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #234](https://github.com/jordanbaird/Ice/issues/234) | [Bug]: Rapidly switching spaces breaks Ice Bar item display | 快速切换 Spaces 后浮栏图标透明，实际项目访问受影响。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #254](https://github.com/jordanbaird/Ice/issues/254) | [Bug]: Transparent items in Ice Bar while in fullscreen mode | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #286](https://github.com/jordanbaird/Ice/issues/286) | [Bug]: Show on click/scroll not working on non-fullscreen, auto-hidden menu bar | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #331](https://github.com/jordanbaird/Ice/issues/331) | [Bug]: Hidden icons cannot be displayed when menu bar automatically hidden while in full screen | 全屏菜单栏自动隐藏时无法显示隐藏图标，属于特定系统显示模式。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #708](https://github.com/jordanbaird/Ice/issues/708) | [Bug]: Ice Bar and Show on Hover hovering area detection bug when system menu bar is on auto-hide mode | 系统自动隐藏模式中浮栏立即关闭且悬停失败，验证 auto-hide 交互。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #714](https://github.com/jordanbaird/Ice/issues/714) | [Bug]: Show Ice bar on hover should not trigger in Mission Control view | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #899](https://github.com/jordanbaird/Ice/issues/899) | [Bug]: Ice triggering while clicking just under the menu bar in fullscreen | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #244](https://github.com/jordanbaird/Ice/issues/244) | [Bug]: App shows up in non-hidden bar even after hidden | CleanShot 重开后偏离隐藏分区，需要对应应用的状态项生命周期验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #300](https://github.com/jordanbaird/Ice/issues/300) | [Bug]: Rearranging icons with multiple instances of OneDrive | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #330](https://github.com/jordanbaird/Ice/issues/330) | [Bug]: Can not work with Focus Menu Bar Item (https://heyfocus.com) | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #404](https://github.com/jordanbaird/Ice/issues/404) | [Bug]: OneDrive changes from "Hidden" to "Visible" on click | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #440](https://github.com/jordanbaird/Ice/issues/440) | [Bug]: The Shazam (music recognition) icon is invisible all the time | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #462](https://github.com/jordanbaird/Ice/issues/462) | Keyboard Maestro will not move from hidden to visible | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #467](https://github.com/jordanbaird/Ice/issues/467) | [Bug]: 1Password menu item weirdness | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #480](https://github.com/jordanbaird/Ice/issues/480) | [Bug]: Interaction with Alcove | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #526](https://github.com/jordanbaird/Ice/issues/526) | [Bug]: Ice Causing issues with the behaviour of the Motioncontrol Light app. The brights slider keeps disappearing when trying to adjust screen brightness | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #586](https://github.com/jordanbaird/Ice/issues/586) | [Bug]: protonvpn app icon presses itself when it hides itself after being opened from ice bar | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #642](https://github.com/jordanbaird/Ice/issues/642) | [Bug]: Clicking on BusyCal Menu in hidden section opened Apple Menu instead | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #656](https://github.com/jordanbaird/Ice/issues/656) | [Bug]: <macOS Tahoe> Cannot move live activities across sections | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #658](https://github.com/jordanbaird/Ice/issues/658) | [Bug]: <Getting focused out while playing league> | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #697](https://github.com/jordanbaird/Ice/issues/697) | [Bug]: Make Lungo/Dato work with Ice | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #701](https://github.com/jordanbaird/Ice/issues/701) | [Bug]: Volume UI hidden on change if menu bar icon is hidden | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #704](https://github.com/jordanbaird/Ice/issues/704) | [Bug]: menu bar items (iphone notifications) cannot be moved | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #707](https://github.com/jordanbaird/Ice/issues/707) | [Bug]: When using Cloudflare WARP with Ice, the WARP GUI is malfunctioning until iCE is restarted. | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #718](https://github.com/jordanbaird/Ice/issues/718) | [Bug]: Cannot hide its icon when using game mode | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #719](https://github.com/jordanbaird/Ice/issues/719) | [Bug]: Volume/brightness HUD not visible when Ice is running on macOS Tahoe | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #729](https://github.com/jordanbaird/Ice/issues/729) | [Bug]: Menu Bar Item Stuck After Ice Bar Click When Live Activities are Active | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #732](https://github.com/jordanbaird/Ice/issues/732) | [Bug]: Docker for Mac ends up in "Always-Hidden Section" over time | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #739](https://github.com/jordanbaird/Ice/issues/739) | [Bug]: No proper behaviour when multiple bar item of same app | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #748](https://github.com/jordanbaird/Ice/issues/748) | [Bug]: 1Password | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #766](https://github.com/jordanbaird/Ice/issues/766) | [Bug]: App with dropdown from menu bar (Mullvad VPN) appears as it auto-hides | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #798](https://github.com/jordanbaird/Ice/issues/798) | [Bug]: Audio Wrangler Mute Icon Issue | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #806](https://github.com/jordanbaird/Ice/issues/806) | [Bug]: Razer Synapse icon always hidden on startup | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #817](https://github.com/jordanbaird/Ice/issues/817) | [Bug]: User (Login) Icon is not customasibale | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #844](https://github.com/jordanbaird/Ice/issues/844) | [Bug]: System icons set to "Show When Active" don't remember their correct placement in the menubar | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #852](https://github.com/jordanbaird/Ice/issues/852) | [Bug]: Ice bar cannot hide recording indicator in 15.7.3 | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #853](https://github.com/jordanbaird/Ice/issues/853) | [Bug]: Cursor IDE icon position is not saved well | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #854](https://github.com/jordanbaird/Ice/issues/854) | [Bug]: Icons are duplicated in the menu bar | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #857](https://github.com/jordanbaird/Ice/issues/857) | [Bug]: Multiple identical app icons disappear when one is restored from hidden state (e.g. OneDrive) | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #887](https://github.com/jordanbaird/Ice/issues/887) | [Bug]: some application don't respect visibility section (like HubStuff) | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #909](https://github.com/jordanbaird/Ice/issues/909) | [Bug]: OneDrive icons | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #915](https://github.com/jordanbaird/Ice/issues/915) | [Bug]: Unsplash client crashes shortly after being hidden by ICE | 隐藏后第三方应用崩溃，需对应应用复现并排查状态项生命周期。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #918](https://github.com/jordanbaird/Ice/issues/918) | [Bug]:When icon for Intego One is moved from hidden to visible bar in settings, the icon disappears | 具体宿主应用/系统项目的可见性或交互异常，需在该应用中验证。 | 待复现/验证 |

### P2（114 条）

| 里程碑 | 工作包 | Issue | 标题原文 | 安排理由 | 状态 |
| --- | --- | --- | --- | --- | --- |
| M0 | B1 | [jordanbaird/Ice #833](https://github.com/jordanbaird/Ice/issues/833) | [Bug]: Cant see anything on | 只有图片且标题称看不到内容；先补可判读现象，确认核心阻塞后升到 P1。 | 适配已继承 · 报告级修复未确认 |
| M0 | B1 | [jordanbaird/Ice #1006](https://github.com/jordanbaird/Ice/issues/1006) | [macOS 27.0.1] What got Ice working with PR #995, plus two things to look into | 报告绑定 PR #995 的另一套实现，先判断适用性；不能直接移植其根因或补丁。 | 部分修复 · ad-hoc 启动；布局实现不采用 |
| M0 | B1 | [jordanbaird/Ice #1007](https://github.com/jordanbaird/Ice/issues/1007) | [macOS 27 / PR #995] An app launched while concealed gets a squashed (3 pt) menu bar item that never recovers | 报告绑定 PR #995 的另一套实现，先判断适用性；不能直接移植其根因或补丁。 | 报告特定根因不适用 · 非已修复 |
| M0 | B1 | [jordanbaird/Ice #1014](https://github.com/jordanbaird/Ice/issues/1014) | [macOS 27 / PR #995] With an app item among the system items, clicking the battery opens that app and Wi-Fi does not open | 报告绑定 PR #995 的另一套实现，先判断适用性；不能直接移植其根因或补丁。 | 报告特定根因不适用 · 非已修复 |
| M2 | I1 | [jordanbaird/Ice #808](https://github.com/jordanbaird/Ice/issues/808) | [Bug]: macOS "Tahoe" - after system restart icon remains in dock | 主要为登录后的 Dock 图标，正文还提到图标重排；先拆分两个现象。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #144](https://github.com/jordanbaird/Ice/issues/144) | [Bug]: Doing opt click after click does not hide app menus | 特定 Option-click 或设置组合失效；普通点击可另行验证，作为组合行为回归。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #246](https://github.com/jordanbaird/Ice/issues/246) | [Bug]: Ice doesn't open its settings when double clicking its app icon on macOS 15 | 再次打开应用未进入设置；已有右键入口，优先级低于核心隐藏访问阻塞。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #329](https://github.com/jordanbaird/Ice/issues/329) | [Bug]: When turning off "Show ice icon" and the turning it back on, the icon doesn't automatically repopulate | 显示图标开关后的即时刷新异常；先确保常规设置入口可用。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #401](https://github.com/jordanbaird/Ice/issues/401) | [Bug]: Ice Bar appears and will not disappear when using "Show on hover" with a delay set to 0 | 悬停延迟为 0 时无法自动消失，仍可手动关闭；验证特殊设置组合。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #595](https://github.com/jordanbaird/Ice/issues/595) | [Bug]: Option-click should expand even when enable always-hidden section is turned off | 特定 Option-click 或设置组合失效；普通点击可另行验证，作为组合行为回归。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #634](https://github.com/jordanbaird/Ice/issues/634) | [Bug]: Option-Click does not work if Show on Click is disabled | 特定 Option-click 或设置组合失效；普通点击可另行验证，作为组合行为回归。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #644](https://github.com/jordanbaird/Ice/issues/644) | [Bug]: <Option-Click works randomly> | 特定 Option-click 或设置组合失效；普通点击可另行验证，作为组合行为回归。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #695](https://github.com/jordanbaird/Ice/issues/695) | [Bug]: ICE window opens on ICE menubar click + at login | 菜单栏点击及登录时弹出设置，需调整窗口激活/重新打开策略。 | 待复现/验证 |
| M2 | I2 | [jordanbaird/Ice #725](https://github.com/jordanbaird/Ice/issues/725) | [Bug]: App icon opens on hover | 悬停导致应用菜单隐藏与 Dock 图标显现，验证激活策略与设置组合。 | 待复现/验证 |
| M2 | I4 | [jordanbaird/Ice #668](https://github.com/jordanbaird/Ice/issues/668) | [Bug]: Search Items issues | 搜索/项目识别异常；先确认当前搜索入口和 AX/CGS 数据链路。 | 待复现/验证 |
| M2 | I4 | [jordanbaird/Ice #673](https://github.com/jordanbaird/Ice/issues/673) | [Bug]: Search Not Working, Mac OS Tahoe | 搜索/项目识别异常；先确认当前搜索入口和 AX/CGS 数据链路。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #53](https://github.com/jordanbaird/Ice/issues/53) | [Bug]: Any change in monitors while Mac is asleep removes styling | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #211](https://github.com/jordanbaird/Ice/issues/211) | [Bug]: Ice Bar shows incorrect item images when moved to another screen | 移动到另一屏后图像仍来自活动屏；核查屏幕与图像缓存的关联。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #241](https://github.com/jordanbaird/Ice/issues/241) | [Bug]: Gap in menu bar items on inactive display when showing hidden section | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #272](https://github.com/jordanbaird/Ice/issues/272) | [Bug]: Extra spaces in iPad sidecar. | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #359](https://github.com/jordanbaird/Ice/issues/359) | [Bug]: Menubars are not correct with external display on MacBook Pro | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #445](https://github.com/jordanbaird/Ice/issues/445) | Menu bar in middle of screen | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #517](https://github.com/jordanbaird/Ice/issues/517) | [Bug]:Bar in the middle of the screen | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #529](https://github.com/jordanbaird/Ice/issues/529) | [Bug]: The right bar is longer than expected on ultrawide screen | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #550](https://github.com/jordanbaird/Ice/issues/550) | [Bug]: <bug title>With VMWare + Windows 11, ICE shows menu bar in the middle of an external monitor | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #576](https://github.com/jordanbaird/Ice/issues/576) | [Bug]: <UI Bar Appearing on Main Display When Playing Fullscreen Video on Extended Display> | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #609](https://github.com/jordanbaird/Ice/issues/609) | Random bar in the middle of the screen | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #636](https://github.com/jordanbaird/Ice/issues/636) | [Bug]: <bug title> Shows weird bar when connected to monitor | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #657](https://github.com/jordanbaird/Ice/issues/657) | [Bug]: the Menu Bar's height with "Shape kind = full" is a few pixels too short on second monitor | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #683](https://github.com/jordanbaird/Ice/issues/683) | [Bug]: (Tahoe Beta) Hover affects across screens | 跨屏悬停会同步展开，需先明确共享状态与独立显示器行为的产品规则。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #750](https://github.com/jordanbaird/Ice/issues/750) | [Bug]: Weird line always drawn on secondary monitor | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #780](https://github.com/jordanbaird/Ice/issues/780) | [Bug]: Bug on Vertical Monitors | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #858](https://github.com/jordanbaird/Ice/issues/858) | [Bug]: second screen layout wrong display | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #863](https://github.com/jordanbaird/Ice/issues/863) | [Bug]: Black square appears in bottom-right corner of primary display when secondary display has fullscreen window | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #910](https://github.com/jordanbaird/Ice/issues/910) | [Bug]: iPad appearance tint shows on main monitor when the iPad is used as an extended display | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #986](https://github.com/jordanbaird/Ice/issues/986) | [Bug]: Ice Bar leaves a ghost/visual artifact on the primary display when a video enters fullscreen on a secondary display | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S1 | [jordanbaird/Ice #988](https://github.com/jordanbaird/Ice/issues/988) | [Bug]: Ice Bar fullscreen expansion behaves differently depending on which display contains the active window | 多屏外观/坐标问题需场景验证，在核心单屏行为稳定后处理。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #216](https://github.com/jordanbaird/Ice/issues/216) | [Bug]: Menu bar appearance shows above Mission Control after deleting a space | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #336](https://github.com/jordanbaird/Ice/issues/336) | [Bug]: Split Type Ice Bar keeps the wallpaper from the previous space when switching spaces/screens | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #337](https://github.com/jordanbaird/Ice/issues/337) | [Bug]: Menu bar appearance uses wallpaper from previous space when swiping through spaces in Mission Control | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #451](https://github.com/jordanbaird/Ice/issues/451) | [Bug]: Unexpected behavior after swiping between desktop and full screen apps | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #521](https://github.com/jordanbaird/Ice/issues/521) | [Bug]: Background visible when entering fullscreen on video. or other application | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #606](https://github.com/jordanbaird/Ice/issues/606) | [Bug]: Ice bar does't leaves artefact behind when auto-hiding in full screen | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S2 | [jordanbaird/Ice #959](https://github.com/jordanbaird/Ice/issues/959) | [Bug]: Split menu bar does not function like expected in full screen | 全屏、Spaces 或自动隐藏场景改变显示和交互时机，需要组合回归。 | 待复现/验证 |
| M3 | S3 | [jordanbaird/Ice #731](https://github.com/jordanbaird/Ice/issues/731) | [Feature Request]: Allow live activities to show | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 候选需求待评估 |
| M3 | S3 | [jordanbaird/Ice #886](https://github.com/jordanbaird/Ice/issues/886) | [Feature Request]: Hide screen recording indicator | 系统项目、Live Activities 或 HUD 行为有特殊约束，需要原生菜单栏对照。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #58](https://github.com/jordanbaird/Ice/issues/58) | [Bug]: Menu Bar Flashes | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #194](https://github.com/jordanbaird/Ice/issues/194) | [Bug]: Offscreen items are dimmed in interface after being moved | 拖拽后图标暂时变淡，属于反馈/渲染异常，不等同于真实分区丢失。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #212](https://github.com/jordanbaird/Ice/issues/212) | [Bug]: Ice Bar doesn't reliably change color when activated on a new desktop | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #239](https://github.com/jordanbaird/Ice/issues/239) | [Bug]: Some menu bar clip issue while using Menu bar split shape  | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #397](https://github.com/jordanbaird/Ice/issues/397) | [Bug]: Dock icon appears when using Always hidden feature. | 展开 always-hidden 时 Dock 图标显现，属于激活策略/界面体验问题。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #409](https://github.com/jordanbaird/Ice/issues/409) | [Bug]: macOS Sequoia requires a restart of Ice to render the menubar border | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #435](https://github.com/jordanbaird/Ice/issues/435) | [Bug]: Glitch when toggle dock | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #472](https://github.com/jordanbaird/Ice/issues/472) | [Bug]: Menu bar item spacing not applying correctly | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 代码改进 · 待原场景验收 |
| M4 | V1 | [jordanbaird/Ice #510](https://github.com/jordanbaird/Ice/issues/510) | [Bug]: Split bar doesn't reach top of scren | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #514](https://github.com/jordanbaird/Ice/issues/514) | [Bug]: Menu bar shadow issue with single application window | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #525](https://github.com/jordanbaird/Ice/issues/525) | [Bug]: split menu bar and related effects seemingly disabled in macOS 15.3.2 | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #541](https://github.com/jordanbaird/Ice/issues/541) | [Bug]: Split view broke with extended screens | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #608](https://github.com/jordanbaird/Ice/issues/608) | [Bug]: Split menu bar holds onto a large amount of blank space to the | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #625](https://github.com/jordanbaird/Ice/issues/625) | [Bug]: Oversize hidden bar | 少量图标时浮栏宽度过大，先验证尺寸约束与反馈。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #627](https://github.com/jordanbaird/Ice/issues/627) | [Bug]: Menu bar appearance not being displayed | 所有样式不显示，但未报告核心图标访问失效，先核查外观路径。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #645](https://github.com/jordanbaird/Ice/issues/645) | [Bug]: menubar periodical glitch every 'x' minutes | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #649](https://github.com/jordanbaird/Ice/issues/649) | [Bug]: split menu bar weird behavior when showing the desktop | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #651](https://github.com/jordanbaird/Ice/issues/651) | [Feature Request]: Allow the tint option to affect the menubar background only and add transparency slider to colour swatch(es) | 透明度已有部分实现；剩余背景/文字对比和 Mission Control 要求需逐项确认。 | 代码改进 · 待原场景验收 |
| M4 | V1 | [jordanbaird/Ice #659](https://github.com/jordanbaird/Ice/issues/659) | [Bug]: <MacOS Tahoe> the bar appearance shows a slight shadow on top on the screen | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #676](https://github.com/jordanbaird/Ice/issues/676) | [Bug]: Empty space on the left side of the right menu bar when split, MacOS Tahoe | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #728](https://github.com/jordanbaird/Ice/issues/728) | [Bug]: Chevron separator is always shown | 分隔符图标显示时机与样式耦合，属于视觉/显示策略问题。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #733](https://github.com/jordanbaird/Ice/issues/733) | [Bug]: Strange rendering issue | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #763](https://github.com/jordanbaird/Ice/issues/763) | [Bug]: Color Picker is broken for Menu Bar | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 代码改进 · 待原场景验收 |
| M4 | V1 | [jordanbaird/Ice #793](https://github.com/jordanbaird/Ice/issues/793) | [Bug]: White icons on white background | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V1 | [jordanbaird/Ice #943](https://github.com/jordanbaird/Ice/issues/943) | [Bug]: Ligthing error when enabeling split shape in menu bar appearance | 主要是样式/渲染一致性问题，先确认不遮挡真实图标或阻塞点击。 | 待复现/验证 |
| M4 | V2 | [jordanbaird/Ice #334](https://github.com/jordanbaird/Ice/issues/334) | [Bug]: Ice has noticeable energy impact during mouse movement | 常态性能或能耗反馈，需采样和对照；出现长期资源增长/卡死时上调到 P1。 | 代码改进 · 待原场景验收 |
| M4 | V2 | [jordanbaird/Ice #479](https://github.com/jordanbaird/Ice/issues/479) | [Bug]: Energy impact | 常态性能或能耗反馈，需采样和对照；出现长期资源增长/卡死时上调到 P1。 | 代码改进 · 待原场景验收 |
| M4 | V2 | [jordanbaird/Ice #578](https://github.com/jordanbaird/Ice/issues/578) | [Bug]: High CPU usage | 常态性能或能耗反馈，需采样和对照；出现长期资源增长/卡死时上调到 P1。 | 代码改进 · 待原场景验收 |
| M4 | V2 | [jordanbaird/Ice #830](https://github.com/jordanbaird/Ice/issues/830) | [Bug]: So many bugs | 常态性能或能耗反馈，需采样和对照；出现长期资源增长/卡死时上调到 P1。 | 代码改进 · 待原场景验收 |
| M5 | F1 | [jordanbaird/Ice #6](https://github.com/jordanbaird/Ice/issues/6) | [Feature Request] Change the location where new menu bar icons come up. | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #326](https://github.com/jordanbaird/Ice/issues/326) | [Feature Request]: Custom configuration path / export settings | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #378](https://github.com/jordanbaird/Ice/issues/378) | [Feature Request]: Show all menu bar items as default | 请求默认全部可见，先明确默认分区与新项目规则。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #566](https://github.com/jordanbaird/Ice/issues/566) | [Feature Request]: Hide/unhide using custom application whitelist | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #617](https://github.com/jordanbaird/Ice/issues/617) | [Feature Request]: Auto-Sort behavior for "Unrecognized" Apps | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #713](https://github.com/jordanbaird/Ice/issues/713) | [Feature Request]: Blacklist instead of whitelist strategy | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #767](https://github.com/jordanbaird/Ice/issues/767) | [Feature Request]: Have new menubar items appear in always shown, or customizable | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #809](https://github.com/jordanbaird/Ice/issues/809) | [Feature Request]: Always place new icons at the end | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #938](https://github.com/jordanbaird/Ice/issues/938) | [Feature Request]: Option that lets you choose location of new items | 需要明确默认分区/排序、配置或同步规则，先定最小产品范围。 | 候选需求待评估 |
| M5 | F2 | [jordanbaird/Ice #83](https://github.com/jordanbaird/Ice/issues/83) | [Feature Request]: Organize apps by keyboard shortcuts or in preferences pane | VoiceOver 用户无法使用仅拖拽的整理入口；无障碍是可用性需求，优先于纯装饰扩展。 | 候选需求待评估 |
| M5 | F2 | [jordanbaird/Ice #252](https://github.com/jordanbaird/Ice/issues/252) | [Feature Request]: RTL support  | 语言和阅读方向影响使用覆盖面；在核心交互稳定后提供可验收的首批语言支持。 | 候选需求待评估 |
| M5 | F2 | [jordanbaird/Ice #638](https://github.com/jordanbaird/Ice/issues/638) | Can it support the multilingual version? | 语言和阅读方向影响使用覆盖面；在核心交互稳定后提供可验收的首批语言支持。 | 候选需求待评估 |
| M5 | F2 | [jordanbaird/Ice #641](https://github.com/jordanbaird/Ice/issues/641) | [Feature Request]: Support Ctrl+N and Ctrl+P to navigate down and up in the  menu bar items list | 标准键盘导航有无障碍价值，先确认搜索/列表入口再补交互。 | 候选需求待评估 |
| M5 | F2 | [jordanbaird/Ice #712](https://github.com/jordanbaird/Ice/issues/712) | [Feature Request]: Localize Ice | 语言和阅读方向影响使用覆盖面；在核心交互稳定后提供可验收的首批语言支持。 | 候选需求待评估 |
| M5 | F2 | [jordanbaird/Ice #787](https://github.com/jordanbaird/Ice/issues/787) | [Feature Request]: need language option，Chinese for example.... | 语言和阅读方向影响使用覆盖面；在核心交互稳定后提供可验收的首批语言支持。 | 候选需求待评估 |
| M5 | F2 | [jordanbaird/Ice #801](https://github.com/jordanbaird/Ice/issues/801) | [Feature Request]: 求中文 | 语言和阅读方向影响使用覆盖面；在核心交互稳定后提供可验收的首批语言支持。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #291](https://github.com/jordanbaird/Ice/issues/291) | [Feature Request]: Hotkeys for individual menu bar items | 单个项目快捷键可减少鼠标操作，依赖稳定项目身份与暂时显示生命周期。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #227](https://github.com/jordanbaird/Ice/issues/227) | [Feature Request]: Use Ice Bar as overflow spot for otherwise-hidden menu items | 溢出项目应仍可访问，需要明确定义菜单栏与浮栏的分工。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #495](https://github.com/jordanbaird/Ice/issues/495) | [Feature Request]: Organize hidden icons into multiple rows | 多行布局用于访问拥挤的隐藏图标，优先于纯动画装饰。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #515](https://github.com/jordanbaird/Ice/issues/515) | [Feature Request]: Scrolling through menu bar items | 需求包含系统自动隐藏与滚动访问全部项目，已有横向滚动不能证明完整满足。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #519](https://github.com/jordanbaird/Ice/issues/519) | [Feature Request]: Ability to show all icons in click menu | 要求访问刘海遮住的项目，应验证发现范围后评估补充入口。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #551](https://github.com/jordanbaird/Ice/issues/551) | [Feature Request]: Grid option when using Ice bar | 网格用于容纳大量项目，需要可访问性和点击目标的验收。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #860](https://github.com/jordanbaird/Ice/issues/860) | [Feature Request]: Option to re-add the menu bar icon, after manual removal | 误移除主控制图标后的恢复入口有明确使用价值，应先定义恢复行为。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #188](https://github.com/jordanbaird/Ice/issues/188) | [Feature Request]: Option to only hide on built-in display | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #223](https://github.com/jordanbaird/Ice/issues/223) | [Feature Request]: Ability to enable Ice Bar only when on built-in display | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #242](https://github.com/jordanbaird/Ice/issues/242) | [Feature Request]: Ability to have unique menubars for each display | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #299](https://github.com/jordanbaird/Ice/issues/299) | [Feature Request]: Always show hidden items if monitor screen is larger than <enter resolution> | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #303](https://github.com/jordanbaird/Ice/issues/303) | [Feature Request]: Use Ice Bar only when screen size is smaller than <enter resolution> | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #406](https://github.com/jordanbaird/Ice/issues/406) | [Feature Request]: Allow clicks inside the notch | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #463](https://github.com/jordanbaird/Ice/issues/463) | [Feature Request]: Make the "Use Ice Bar" toggle dynamic | 正文请求空间不足时自动使用浮栏，依赖屏幕空间测量。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #544](https://github.com/jordanbaird/Ice/issues/544) | [Feature Request]: Disable in full screen mode | 请求按全屏状态关闭功能，属于自适应行为规则。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #555](https://github.com/jordanbaird/Ice/issues/555) | [Feature Request]: <Disable / alt settings with external monitor> | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #570](https://github.com/jordanbaird/Ice/issues/570) | [Feature Request]: When bar items pass through the notch | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #604](https://github.com/jordanbaird/Ice/issues/604) | [Feature Request]: Disable functionality behind notch | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #630](https://github.com/jordanbaird/Ice/issues/630) | [Feature Request]: Ice Bar under when I'm on one screen. | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #691](https://github.com/jordanbaird/Ice/issues/691) | [Feature Request]: Allow unhide all when the display is larger | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #703](https://github.com/jordanbaird/Ice/issues/703) | [Feature Request]: Ice Bar only on Macs with a Notch | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #783](https://github.com/jordanbaird/Ice/issues/783) | [Feature Request]: Separate sets for laptops when connect to external monitor | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |
| M5 | F5 | [jordanbaird/Ice #797](https://github.com/jordanbaird/Ice/issues/797) | [Feature Request]: only on screens with a notch | 按屏幕自适应有使用价值，但依赖基础多屏行为稳定。 | 候选需求待评估 |

### P3（64 条）

| 里程碑 | 工作包 | Issue | 标题原文 | 安排理由 | 状态 |
| --- | --- | --- | --- | --- | --- |
| M0 | B1 | [jordanbaird/Ice #920](https://github.com/jordanbaird/Ice/issues/920) | I have searched existing issues for similar reports | 缺少可判读的故障描述或只有图片；先补全现象与复现材料再定级。 | 材料不足 · 无正文或步骤 |
| M4 | V1 | [jordanbaird/Ice #186](https://github.com/jordanbaird/Ice/issues/186) | [Feature Request]: Support GIFs as Ice icon | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #245](https://github.com/jordanbaird/Ice/issues/245) | [Feature Request]: Allow setting SF Symbols for when the icon is toggled | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #273](https://github.com/jordanbaird/Ice/issues/273) | [Feature Request]: Custom refresh rate for menu bar item images | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #368](https://github.com/jordanbaird/Ice/issues/368) | [Feature Request]: Menu Bar Appearance for Hidden Sections | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #380](https://github.com/jordanbaird/Ice/issues/380) | [Feature Request]: Can we send shadow to back? | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #468](https://github.com/jordanbaird/Ice/issues/468) | [Feature Request]: Disable / Customize Menu Bar Appearance in Full Screen Mode | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #482](https://github.com/jordanbaird/Ice/issues/482) | [Feature Request]: Better appearance for rounded menu bar | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #533](https://github.com/jordanbaird/Ice/issues/533) | [Feature Request]: Make menu bar appear floating versus docked to top of screen | 请求菜单栏顶部留空形成悬浮外观，是可选样式扩展。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #538](https://github.com/jordanbaird/Ice/issues/538) | [Feature Request]: Round corners of clicked menu bar items | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #705](https://github.com/jordanbaird/Ice/issues/705) | [Feature Request]: Allow clear shape kind | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M4 | V1 | [jordanbaird/Ice #754](https://github.com/jordanbaird/Ice/issues/754) | [Feature Request]: Dark icon | 可选外观扩展，排在阻塞性缺陷和主要可访问性问题之后。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #26](https://github.com/jordanbaird/Ice/issues/26) | [Feature request] Profiles for menubar layout | 多 Profiles 需要切换与持久化模型，排在核心状态一致性之后。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #46](https://github.com/jordanbaird/Ice/issues/46) | [Feature Request]: Menubar groups | 自定义分组需要新的组织模型和交互设计，先稳定已有三分区。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #91](https://github.com/jordanbaird/Ice/issues/91) | [Feature Request]: Spacers | 间隔项目用于视觉分组，属于可选组织能力。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #95](https://github.com/jordanbaird/Ice/issues/95) | [Feature Request]: Cross-Device Syncing | 跨设备同步需冲突规则与稳定配置模型，不作为核心修复的前置。 | 候选需求待评估 |
| M5 | F1 | [jordanbaird/Ice #560](https://github.com/jordanbaird/Ice/issues/560) | [Feature Request]: Automatically sort menu bar items in hidden section by name | 按名称自动排序是可选组织能力，应保留用户手动顺序。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #62](https://github.com/jordanbaird/Ice/issues/62) | [Feature Request]: Show menu bar items when trigger condition are met | 按电量、脚本或图像状态触发显示，需要定义自动化契约。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #141](https://github.com/jordanbaird/Ice/issues/141) | [Feature Request]: x-callback-url for automation | 扩展集成或快捷键能力；先稳定内部状态和交互契约。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #148](https://github.com/jordanbaird/Ice/issues/148) | [Feature Request]: Custom trigger API for applications to implement | 扩展集成或快捷键能力；先稳定内部状态和交互契约。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #340](https://github.com/jordanbaird/Ice/issues/340) | [Feature Request]: Show ice bar next to mouse in any screen location with keyboard shortcut | 扩展集成或快捷键能力；先稳定内部状态和交互契约。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #382](https://github.com/jordanbaird/Ice/issues/382) | [Feature Request]: Add AppleScript or CLI support | 扩展集成或快捷键能力；先稳定内部状态和交互契约。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #501](https://github.com/jordanbaird/Ice/issues/501) | [Feature Request]: Raycast Integration | 扩展集成或快捷键能力；先稳定内部状态和交互契约。 | 候选需求待评估 |
| M5 | F3 | [jordanbaird/Ice #516](https://github.com/jordanbaird/Ice/issues/516) | [Feature Request]: Expose API for searching menu bar items for Launchbar/Alfred/Spotlight/etc | 扩展集成或快捷键能力；先稳定内部状态和交互契约。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #113](https://github.com/jordanbaird/Ice/issues/113) | [Feature Request]: Scroll again to toggle always-hidden section | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #208](https://github.com/jordanbaird/Ice/issues/208) | Feature Request: Adding Ice Bar as an additional layout under Menu Bar Items | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #209](https://github.com/jordanbaird/Ice/issues/209) | [Feature Request]: Arrange items directly inside Ice Bar | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #214](https://github.com/jordanbaird/Ice/issues/214) | [Feature Request]: Ability to pin Ice Bar | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #240](https://github.com/jordanbaird/Ice/issues/240) | [Feature Request]: Showing hidden items replaces visible items | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #243](https://github.com/jordanbaird/Ice/issues/243) | [Feature Request]: Menu Bar Widget Ideas | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #310](https://github.com/jordanbaird/Ice/issues/310) | [Feature Request]: Allow a section to be hidable to show what's on the left | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #321](https://github.com/jordanbaird/Ice/issues/321) | [Feature Request]: Animation when showing items | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #335](https://github.com/jordanbaird/Ice/issues/335) | [Feature Request]: Ice Bar only for Always Hidden | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #342](https://github.com/jordanbaird/Ice/issues/342) | [Feature Request]: Display menu bar items as a vertical list | Display 在标题中为显示动作，需求是带名称的纵向列表，不是按显示器配置。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #372](https://github.com/jordanbaird/Ice/issues/372) | [Feature Request]: Ability to see both hidden sections at the same time when using the Ice Bar | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #481](https://github.com/jordanbaird/Ice/issues/481) | [Feature Request]: Option to enable showing hidden section when hovering over un-hidden side | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #487](https://github.com/jordanbaird/Ice/issues/487) | [Feature Request]: Always Hidden Use Ice Bar | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #494](https://github.com/jordanbaird/Ice/issues/494) | [Feature Request]: Make option for showing hidden items on mouse down, not up | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #497](https://github.com/jordanbaird/Ice/issues/497) | [Feature Request]: Open 'Menu Bar Layout' from Right-Click | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #518](https://github.com/jordanbaird/Ice/issues/518) | [Feature Request]: Configuration option to Always open Ice as minimized | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #527](https://github.com/jordanbaird/Ice/issues/527) | [Feature Request]: Allow pinning bar location with hidden ice icon | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #552](https://github.com/jordanbaird/Ice/issues/552) | [Feature Request]: Option for Double click on ice icon in menu bar to show always hidden menu icons instead of settings | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #554](https://github.com/jordanbaird/Ice/issues/554) | [Feature Request]: Show menu bar item name on hover | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #600](https://github.com/jordanbaird/Ice/issues/600) | [Feature Request]: Open hidden items from the Ice Icon | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #724](https://github.com/jordanbaird/Ice/issues/724) | [Feature Request]: Hide Ice icon from dock | 已有 LSUIElement，但窗口激活策略会影响 Dock；先明确用户希望隐藏的时机再设计选项。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #726](https://github.com/jordanbaird/Ice/issues/726) | [Feature Request]: Clicking on center of menu bar reveals the desktop | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #727](https://github.com/jordanbaird/Ice/issues/727) | [Feature Request]: Bartender 3 mode | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #778](https://github.com/jordanbaird/Ice/issues/778) | [Feature Request]: Add Toggle to expand hidden section to contain always hidden icons | 额外操作或布局能力，先确认需求和验收范围再进入实现。 | 候选需求待评估 |
| M5 | F4 | [jordanbaird/Ice #961](https://github.com/jordanbaird/Ice/issues/961) | [Feature Request]: No dock icon | 已有 LSUIElement，但窗口激活策略会影响 Dock；先明确用户希望隐藏的时机再设计选项。 | 候选需求待评估 |
| M5 | F6 | [jordanbaird/Ice #210](https://github.com/jordanbaird/Ice/issues/210) | [Feature Request]: Option to update to beta releases | 分发/帮助需求，先明确 Floe 的渠道、更新源及支持范围。 | 候选需求待评估 |
| M5 | F6 | [jordanbaird/Ice #601](https://github.com/jordanbaird/Ice/issues/601) | [Feature Request]: Documentation for hidden and always hidden behavior | 分发/帮助需求，先明确 Floe 的渠道、更新源及支持范围。 | 候选需求待评估 |
| M5 | F6 | [jordanbaird/Ice #862](https://github.com/jordanbaird/Ice/issues/862) | [Feature Request]: submit the app to the homebrew | 分发/帮助需求，先明确 Floe 的渠道、更新源及支持范围。 | 候选需求待评估 |
| Triage | T1 | [jordanbaird/Ice #73](https://github.com/jordanbaird/Ice/issues/73) | [Feature Request]: Defer recommended payment until once installed | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #745](https://github.com/jordanbaird/Ice/issues/745) | [Love]: Thank You For Ice! | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #752](https://github.com/jordanbaird/Ice/issues/752) | [Bug]: Latest beta update from Sept 16th - when is a new one coming with fixed bugs | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #760](https://github.com/jordanbaird/Ice/issues/760) | [Feature Request]: Make stable version for Tahoe? | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #774](https://github.com/jordanbaird/Ice/issues/774) | [Bug]: Website https://icemenubar.app/ appears to be down | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #823](https://github.com/jordanbaird/Ice/issues/823) | [Feature Request]: Are we every going to get a stable version for macOS Tahoe, or is the app not in development anymore? | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #935](https://github.com/jordanbaird/Ice/issues/935) | [Bug]: Website SSL cert expired | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #939](https://github.com/jordanbaird/Ice/issues/939) | [Bug]: IS THIS PROJECT ABANDONED? | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #966](https://github.com/jordanbaird/Ice/issues/966) | [Bug]: Unofficial macOS 26-compatible build of Ice (signed and notarized) | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #993](https://github.com/jordanbaird/Ice/issues/993) | [Feature Request]: This project is no longer maintained by the original author | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #1011](https://github.com/jordanbaird/Ice/issues/1011) | [Feature Request]: Some Golden Gate Clarity | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |
| Triage | T1 | [jordanbaird/Ice #1015](https://github.com/jordanbaird/Ice/issues/1015) | [Feature Request]: Is the project still alive? | 上游维护、网站或社区/发布信息；先明确本项目可行动部分，不直接计入缺陷开发。 | 外部事项待整理 |

## 维护规则

新证据到来时先更新单条优先级和适用性，再检查工作包、阶段和数量统计。复现系统级影响可升 P0；确定只影响视觉且有正常访问路径可降到 P2。涉及第三方实现但不适用于当前 Floe 的条目先记录适用性结论，不把“未采用该实现”自动等同于“已 fix”。

开始处理时刷新 GitHub 状态；完成后按原复现步骤、对应系统和两类数据路径复测，记录源码/验证依据，再按现有审计规则同步移除本地清单、总结、JSON 和本文索引。功能请求须先有确定范围和验收条件；相似现象只能批量验证，未经确认不合并或删除原条目。
