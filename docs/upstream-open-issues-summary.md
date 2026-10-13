# 上游待处理 Issues 分类总结

原始采集时间：2026-10-13T14:04:27+08:00（Asia/Shanghai）。本地代码审计时间：2026-10-13T15:17:39+08:00。

原始采集范围为两个上游仓库的全部 open issues（排除 pull requests）。原始共 402 条；现已排除 Floe 中已修复或需求已满足的 22 条，保留 **380** 条。此文件是本项目的待处理清单，不再等同于上游实时 open issues 总数。

删除依据与验证边界见 [修复核对记录](upstream-issue-fix-audit.md)。仅清理本地文档，未关闭或修改 GitHub 上的 issue。

## 总览

| 仓库 | 故障报告 | 功能请求 | 其他反馈 | 当前保留 |
| --- | ---: | ---: | ---: | ---: |
| [cavaldos/Ice](https://github.com/cavaldos/Ice) | 4 | 0 | 0 | 4 |
| [jordanbaird/Ice](https://github.com/jordanbaird/Ice) | 271 | 99 | 6 | 376 |

类型依据原始标题与 GitHub 标签整理；主分类是本地分析，不是上游官方标签。每条只分配一个主分类，跨领域问题仍可能需要多个维度验证。保留表示尚未确认已完整修复，不能直接理解为已在 Floe 复现。

完整标题和正文见 [原文清单](upstream-open-issues.md)，机器可读数据见 [JSON 清单](upstream-open-issues.snapshot.json)。

## 分类数量

| 主分类 | cavaldos/Ice | jordanbaird/Ice | 合计 |
| --- | ---: | ---: | ---: |
| 布局编辑、图标发现与搜索 | 1 | 44 | 45 |
| 分区、排序与状态持久化 | 1 | 39 | 40 |
| 显示器、分辨率与刘海适配 | 1 | 59 | 60 |
| 触发、点击与自动隐藏 | 1 | 56 | 57 |
| Ice Bar 功能与交互 | 0 | 23 | 23 |
| 菜单栏外观与渲染 | 0 | 39 | 39 |
| 崩溃、冻结与资源消耗 | 0 | 37 | 37 |
| 权限、更新、安装与分发 | 0 | 7 | 7 |
| 第三方应用与系统项目兼容 | 0 | 40 | 40 |
| 快捷键、自动化与配置能力 | 0 | 9 | 9 |
| 本地化、文档与项目维护 | 0 | 17 | 17 |
| 系统升级兼容与待澄清反馈 | 0 | 6 | 6 |

## 仍需优先核查的问题

1. **直接上游剩余 4 条。** [#5](https://github.com/cavaldos/Ice/issues/5) 外接屏合盖时隐藏失效、[#9](https://github.com/cavaldos/Ice/issues/9) 布局页空白且无法拖拽、[#12](https://github.com/cavaldos/Ice/issues/12) 展开收起无效、[#24](https://github.com/cavaldos/Ice/issues/24) 拖入隐藏区后又回到可见区。当前代码虽有 AX 发现、拖拽重试、分隔符几何兜底和点击保护，仍需在报告环境中验证真实行为；不能根据提交标题中出现编号就删除。
2. **布局发现与隐藏后的可访问性。** [#716](https://github.com/jordanbaird/Ice/issues/716)、[#1003](https://github.com/jordanbaird/Ice/issues/1003)、[#1009](https://github.com/jordanbaird/Ice/issues/1009) 等有兼容处理，但 CGS 缺失时依赖 AX 节点，源码仍注明深度隐藏的项目可能没有可发现节点，因此保留同类报告。
3. **第三方应用、自动隐藏和窗口生命周期。** [#452](https://github.com/jordanbaird/Ice/issues/452)、[#621](https://github.com/jordanbaird/Ice/issues/621)、[#729](https://github.com/jordanbaird/Ice/issues/729)、[#857](https://github.com/jordanbaird/Ice/issues/857) 涉及具体交互场景。AX 路径回归通过不能证明 CGS 路径、系统 Live Activities 和每个第三方应用的行为均已恢复。
4. **多屏、全屏与渲染。** [#986](https://github.com/jordanbaird/Ice/issues/986)、[#987](https://github.com/jordanbaird/Ice/issues/987)、[#988](https://github.com/jordanbaird/Ice/issues/988) 等需要多屏实机验证。缺少每个报告对应的验证结果，本次不删除。
5. **崩溃、长期运行、性能和资源泄漏。** [#840](https://github.com/jordanbaird/Ice/issues/840)、[#905](https://github.com/jordanbaird/Ice/issues/905)、[#925](https://github.com/jordanbaird/Ice/issues/925) 的 windowNumber 相关代码已有安全转换，但原始报告不足以确认所有崩溃都是该转换导致。[#530](https://github.com/jordanbaird/Ice/issues/530)、[#777](https://github.com/jordanbaird/Ice/issues/777)、[#819](https://github.com/jordanbaird/Ice/issues/819)、[#908](https://github.com/jordanbaird/Ice/issues/908)、[#968](https://github.com/jordanbaird/Ice/issues/968)、[#974](https://github.com/jordanbaird/Ice/issues/974) 也不能用一次构建或短时回归证明已修复。
6. **PR #995 特定实现的问题。** [#1006](https://github.com/jordanbaird/Ice/issues/1006)、[#1007](https://github.com/jordanbaird/Ice/issues/1007)、[#1014](https://github.com/jordanbaird/Ice/issues/1014) 涉及 Concealer27、MacOS27Layout 和点击重放。当前 Floe 没有这套实现，属于不同实现路线；没有该代码不能作为“已经 fix”的依据，仍保留。
7. **功能需求与项目沟通。** 分组/Profiles、按显示器配置、CLI/AppleScript、语言包、图标默认位置、Homebrew 正式提交以及上游维护计划等仍未被当前项目完整满足；感谢、维护询问等也没有“已修复”结论，不因不属于代码 bug 就删掉。

## 相似问题线索

按现象关联，不认定为重复 issue 或共同根因：

| 主题 | 直接上游 | 原始上游示例 |
| --- | --- | --- |
| 布局页空白/加载不结束 | [#9](https://github.com/cavaldos/Ice/issues/9) | [#716](https://github.com/jordanbaird/Ice/issues/716)、[#1003](https://github.com/jordanbaird/Ice/issues/1003)、[#1009](https://github.com/jordanbaird/Ice/issues/1009) |
| 分区拖拽与位置不保持 | [#24](https://github.com/cavaldos/Ice/issues/24) | [#723](https://github.com/jordanbaird/Ice/issues/723)、[#769](https://github.com/jordanbaird/Ice/issues/769)、[#861](https://github.com/jordanbaird/Ice/issues/861) |
| 展开收起无效 | [#12](https://github.com/cavaldos/Ice/issues/12) | [#996](https://github.com/jordanbaird/Ice/issues/996)、[#1008](https://github.com/jordanbaird/Ice/issues/1008) |
| 外接屏隐藏与布局 | [#5](https://github.com/cavaldos/Ice/issues/5) | [#836](https://github.com/jordanbaird/Ice/issues/836)、[#929](https://github.com/jordanbaird/Ice/issues/929)、[#988](https://github.com/jordanbaird/Ice/issues/988) |

## 项目维护信息的解读

[jordanbaird/Ice #993](https://github.com/jordanbaird/Ice/issues/993) 的发帖者介绍 `cavaldos/Ice` 为其维护的 fork；[#1011](https://github.com/jordanbaird/Ice/issues/1011)、[#1015](https://github.com/jordanbaird/Ice/issues/1015) 等是用户询问维护计划。它们不能单独证明原作者正式停止维护或认可某个 fork，因此继续保留为沟通事项。

## 全量分类索引

以下列出保留的全部 **380** 条；已排除本次删除条目。

### 布局编辑、图标发现与搜索

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [cavaldos/Ice #9](https://github.com/cavaldos/Ice/issues/9) | 故障报告 | [Bug]: Nothing is being shown on "Menu Bar Layout" in settings |
| [jordanbaird/Ice #26](https://github.com/jordanbaird/Ice/issues/26) | 功能请求 | [Feature request] Profiles for menubar layout |
| [jordanbaird/Ice #283](https://github.com/jordanbaird/Ice/issues/283) | 故障报告 | [Bug]: Ice's view of the menu bar is missing the icon for AltTab |
| [jordanbaird/Ice #312](https://github.com/jordanbaird/Ice/issues/312) | 故障报告 | [Bug]: No items in Menu Bar |
| [jordanbaird/Ice #497](https://github.com/jordanbaird/Ice/issues/497) | 功能请求 | [Feature Request]: Open 'Menu Bar Layout' from Right-Click |
| [jordanbaird/Ice #516](https://github.com/jordanbaird/Ice/issues/516) | 功能请求 | [Feature Request]: Expose API for searching menu bar items for Launchbar/Alfred/Spotlight/etc |
| [jordanbaird/Ice #617](https://github.com/jordanbaird/Ice/issues/617) | 功能请求 | [Feature Request]: Auto-Sort behavior for "Unrecognized" Apps |
| [jordanbaird/Ice #623](https://github.com/jordanbaird/Ice/issues/623) | 故障报告 | [Bug]:Icons in MenuBar Layout page Disappear After Using ICE Bar in Full-Screen Mode |
| [jordanbaird/Ice #643](https://github.com/jordanbaird/Ice/issues/643) | 故障报告 | [Bug]: Completely lost Stats app when dragging into Menu Bar Layout section |
| [jordanbaird/Ice #655](https://github.com/jordanbaird/Ice/issues/655) | 故障报告 | [Bug]: ICE - Some Apps icons not appearing in the Menu Bar Layout setting |
| [jordanbaird/Ice #664](https://github.com/jordanbaird/Ice/issues/664) | 故障报告 | [Bug]: MacOS Tahoe Breaks Menu Bar Layout Editor |
| [jordanbaird/Ice #668](https://github.com/jordanbaird/Ice/issues/668) | 故障报告 | [Bug]: Search Items issues |
| [jordanbaird/Ice #673](https://github.com/jordanbaird/Ice/issues/673) | 故障报告 | [Bug]: Search Not Working, Mac OS Tahoe |
| [jordanbaird/Ice #677](https://github.com/jordanbaird/Ice/issues/677) | 故障报告 | [Bug]: Ice bar do not work:endless loading menu bar items |
| [jordanbaird/Ice #682](https://github.com/jordanbaird/Ice/issues/682) | 故障报告 | [Bug]: <Menebar Layout Pane> |
| [jordanbaird/Ice #685](https://github.com/jordanbaird/Ice/issues/685) | 故障报告 | Whitened sections in Menu Bar Layout |
| [jordanbaird/Ice #696](https://github.com/jordanbaird/Ice/issues/696) | 故障报告 | [Bug]: nothing showing up in the menu editing |
| [jordanbaird/Ice #716](https://github.com/jordanbaird/Ice/issues/716) | 故障报告 | [Bug]: Menu Bar Layout BLANK (can't see any icons) |
| [jordanbaird/Ice #730](https://github.com/jordanbaird/Ice/issues/730) | 故障报告 | [Bug]: Menu bar layout in settings bug |
| [jordanbaird/Ice #741](https://github.com/jordanbaird/Ice/issues/741) | 故障报告 | [Bug]: Apps gone from Ice Layout |
| [jordanbaird/Ice #743](https://github.com/jordanbaird/Ice/issues/743) | 故障报告 | [Bug]: I cannot see any icons |
| [jordanbaird/Ice #744](https://github.com/jordanbaird/Ice/issues/744) | 故障报告 | [Bug]: Menu Bar Layout settings is empty |
| [jordanbaird/Ice #762](https://github.com/jordanbaird/Ice/issues/762) | 故障报告 | [Bug]: Cannot use Ice Bar nor Menu Bar layout icons |
| [jordanbaird/Ice #769](https://github.com/jordanbaird/Ice/issues/769) | 故障报告 | [Bug]: Menu Bar Layout gets reordered when i close the Ice app |
| [jordanbaird/Ice #773](https://github.com/jordanbaird/Ice/issues/773) | 故障报告 | [Bug]: Menu Bar Layout empty - All icons in hidden section |
| [jordanbaird/Ice #802](https://github.com/jordanbaird/Ice/issues/802) | 故障报告 | [Bug]: After updating the Mac version, the layout settings disappeared. |
| [jordanbaird/Ice #816](https://github.com/jordanbaird/Ice/issues/816) | 故障报告 | [Bug]: Menu Bar Layout does not give option to customize anything |
| [jordanbaird/Ice #818](https://github.com/jordanbaird/Ice/issues/818) | 故障报告 | [Bug]: Menu bar layout editor is just empty/white |
| [jordanbaird/Ice #832](https://github.com/jordanbaird/Ice/issues/832) | 故障报告 | [Bug]: Menu Bar Layout with Tahoe OS |
| [jordanbaird/Ice #846](https://github.com/jordanbaird/Ice/issues/846) | 故障报告 | [Bug]: MenuBar in Settings Is Empty White Space |
| [jordanbaird/Ice #872](https://github.com/jordanbaird/Ice/issues/872) | 故障报告 | [Bug]: Unstable, Layout menu area broken |
| [jordanbaird/Ice #878](https://github.com/jordanbaird/Ice/issues/878) | 故障报告 | [Bug]: Menu bar items are not appearing |
| [jordanbaird/Ice #891](https://github.com/jordanbaird/Ice/issues/891) | 故障报告 | [Bug]: ICons List Blank In Settings |
| [jordanbaird/Ice #913](https://github.com/jordanbaird/Ice/issues/913) | 故障报告 | [Bug]: Settings Menu: Menu Bar Layout Icons Do Not Appear |
| [jordanbaird/Ice #916](https://github.com/jordanbaird/Ice/issues/916) | 故障报告 | [Bug]:  I can't edit my layout, because it's all blank |
| [jordanbaird/Ice #919](https://github.com/jordanbaird/Ice/issues/919) | 故障报告 | [Bug]: Ice icon dissappeared |
| [jordanbaird/Ice #946](https://github.com/jordanbaird/Ice/issues/946) | 故障报告 | [Bug]: MacOS Tahoe 26.5 update broke hidden elements in ice layout |
| [jordanbaird/Ice #951](https://github.com/jordanbaird/Ice/issues/951) | 故障报告 | [Bug]: Can't view the icons on Menu Bar Layout |
| [jordanbaird/Ice #965](https://github.com/jordanbaird/Ice/issues/965) | 故障报告 | [Bug]: Menubar layout broken/spinning in MacOS 27 Public Beta |
| [jordanbaird/Ice #973](https://github.com/jordanbaird/Ice/issues/973) | 故障报告 | [Bug]: Menu bar layout shown nothing on the sections |
| [jordanbaird/Ice #992](https://github.com/jordanbaird/Ice/issues/992) | 故障报告 | [Bug]: unavailable under MacOS27 |
| [jordanbaird/Ice #999](https://github.com/jordanbaird/Ice/issues/999) | 故障报告 | [Bug]: Can't see layout |
| [jordanbaird/Ice #1003](https://github.com/jordanbaird/Ice/issues/1003) | 故障报告 | [Bug]: [Bug]: Updated to MacOS 27.0.1 and cannot customize Menu Bar Layout on Ice |
| [jordanbaird/Ice #1009](https://github.com/jordanbaird/Ice/issues/1009) | 故障报告 | [Bug]: |
| [jordanbaird/Ice #1010](https://github.com/jordanbaird/Ice/issues/1010) | 故障报告 | [Bug]: always loading meum bar items |

### 分区、排序与状态持久化

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [cavaldos/Ice #24](https://github.com/cavaldos/Ice/issues/24) | 故障报告 | [Bug]: Dropping icons to hide has no effect |
| [jordanbaird/Ice #6](https://github.com/jordanbaird/Ice/issues/6) | 功能请求 | [Feature Request] Change the location where new menu bar icons come up. |
| [jordanbaird/Ice #46](https://github.com/jordanbaird/Ice/issues/46) | 功能请求 | [Feature Request]: Menubar groups |
| [jordanbaird/Ice #91](https://github.com/jordanbaird/Ice/issues/91) | 功能请求 | [Feature Request]: Spacers |
| [jordanbaird/Ice #194](https://github.com/jordanbaird/Ice/issues/194) | 故障报告 | [Bug]: Offscreen items are dimmed in interface after being moved |
| [jordanbaird/Ice #209](https://github.com/jordanbaird/Ice/issues/209) | 功能请求 | [Feature Request]: Arrange items directly inside Ice Bar |
| [jordanbaird/Ice #211](https://github.com/jordanbaird/Ice/issues/211) | 故障报告 | [Bug]: Ice Bar shows incorrect item images when moved to another screen |
| [jordanbaird/Ice #233](https://github.com/jordanbaird/Ice/issues/233) | 故障报告 | [Bug]:  Re-arranging/dragging  items  in the "Hidden" settings pane makes them disappear  |
| [jordanbaird/Ice #240](https://github.com/jordanbaird/Ice/issues/240) | 功能请求 | [Feature Request]: Showing hidden items replaces visible items |
| [jordanbaird/Ice #310](https://github.com/jordanbaird/Ice/issues/310) | 功能请求 | [Feature Request]: Allow a section to be hidable to show what's on the left |
| [jordanbaird/Ice #344](https://github.com/jordanbaird/Ice/issues/344) | 故障报告 | [Bug]: Menu bar items move to hidden or always hidden section |
| [jordanbaird/Ice #401](https://github.com/jordanbaird/Ice/issues/401) | 故障报告 | [Bug]: Ice Bar appears and will not disappear when using "Show on hover" with a delay set to 0 |
| [jordanbaird/Ice #416](https://github.com/jordanbaird/Ice/issues/416) | 故障报告 | [Bug]: menubar icons disappear when active app menus extend to the right |
| [jordanbaird/Ice #512](https://github.com/jordanbaird/Ice/issues/512) | 故障报告 | [Bug]: Lack of sync among windows |
| [jordanbaird/Ice #513](https://github.com/jordanbaird/Ice/issues/513) | 故障报告 | [Bug]: Hidden icons end up in the Visible section after some interactions |
| [jordanbaird/Ice #560](https://github.com/jordanbaird/Ice/issues/560) | 功能请求 | [Feature Request]: Automatically sort menu bar items in hidden section by name |
| [jordanbaird/Ice #566](https://github.com/jordanbaird/Ice/issues/566) | 功能请求 | [Feature Request]: Hide/unhide using custom application whitelist |
| [jordanbaird/Ice #589](https://github.com/jordanbaird/Ice/issues/589) | 故障报告 | [Bug]: Menu items disappear when there is no room left |
| [jordanbaird/Ice #661](https://github.com/jordanbaird/Ice/issues/661) | 故障报告 | [Bug]: When visible section application is updated, it will go to hidden section. |
| [jordanbaird/Ice #666](https://github.com/jordanbaird/Ice/issues/666) | 故障报告 | [Bug]: Items that change become hidden |
| [jordanbaird/Ice #675](https://github.com/jordanbaird/Ice/issues/675) | 故障报告 | [Bug]: Always Hidden Icons Disappeared. |
| [jordanbaird/Ice #702](https://github.com/jordanbaird/Ice/issues/702) | 故障报告 | [Bug]: Hidden items randomly moved to always hidden items |
| [jordanbaird/Ice #713](https://github.com/jordanbaird/Ice/issues/713) | 功能请求 | [Feature Request]: Blacklist instead of whitelist strategy |
| [jordanbaird/Ice #723](https://github.com/jordanbaird/Ice/issues/723) | 故障报告 | [Bug]: Icons don’t stay at its place - they flip after restart (Sequoia & Tahoe) |
| [jordanbaird/Ice #753](https://github.com/jordanbaird/Ice/issues/753) | 故障报告 | [Bug]: Always Hidden items are empty under new Tahoe Beta 4 |
| [jordanbaird/Ice #755](https://github.com/jordanbaird/Ice/issues/755) | 故障报告 | [Bug]: Dropped menubar clicks |
| [jordanbaird/Ice #757](https://github.com/jordanbaird/Ice/issues/757) | 故障报告 | [Bug]: Pointer disappearing after clicking on icons in ICE popup bar |
| [jordanbaird/Ice #758](https://github.com/jordanbaird/Ice/issues/758) | 故障报告 | [Bug]: Unable to re-arrange menu bar via Ice app |
| [jordanbaird/Ice #759](https://github.com/jordanbaird/Ice/issues/759) | 故障报告 | [Bug]: Ice Icon Disappearing after Hidden Items are shown |
| [jordanbaird/Ice #767](https://github.com/jordanbaird/Ice/issues/767) | 功能请求 | [Feature Request]: Have new menubar items appear in always shown, or customizable |
| [jordanbaird/Ice #771](https://github.com/jordanbaird/Ice/issues/771) | 故障报告 | [Bug]: Shortcut Gets Hidden After Restart |
| [jordanbaird/Ice #778](https://github.com/jordanbaird/Ice/issues/778) | 功能请求 | [Feature Request]: Add Toggle to expand hidden section to contain always hidden icons |
| [jordanbaird/Ice #781](https://github.com/jordanbaird/Ice/issues/781) | 故障报告 | [Bug]: ICE menu icon non showing anymore |
| [jordanbaird/Ice #799](https://github.com/jordanbaird/Ice/issues/799) | 故障报告 | [Bug]: Menu bar items not disappearing |
| [jordanbaird/Ice #809](https://github.com/jordanbaird/Ice/issues/809) | 功能请求 | [Feature Request]: Always place new icons at the end |
| [jordanbaird/Ice #860](https://github.com/jordanbaird/Ice/issues/860) | 功能请求 | [Feature Request]: Option to re-add the menu bar icon, after manual removal |
| [jordanbaird/Ice #861](https://github.com/jordanbaird/Ice/issues/861) | 故障报告 | [Bug]: unable to move icons to hidden section |
| [jordanbaird/Ice #871](https://github.com/jordanbaird/Ice/issues/871) | 故障报告 | [Bug]: Unable to click on secondary menu bar icons, the bar disappears |
| [jordanbaird/Ice #921](https://github.com/jordanbaird/Ice/issues/921) | 故障报告 | [Bug]: Icons in re-arrange menu in settings aren't visible |
| [jordanbaird/Ice #938](https://github.com/jordanbaird/Ice/issues/938) | 功能请求 | [Feature Request]: Option that lets you choose location of new items |

### 显示器、分辨率与刘海适配

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [cavaldos/Ice #5](https://github.com/cavaldos/Ice/issues/5) | 故障报告 | [Bug]: issue on second screen in clamshell mode |
| [jordanbaird/Ice #53](https://github.com/jordanbaird/Ice/issues/53) | 故障报告 | [Bug]: Any change in monitors while Mac is asleep removes styling |
| [jordanbaird/Ice #94](https://github.com/jordanbaird/Ice/issues/94) | 故障报告 | [Bug]: Icons not hidden in ultra wide screen |
| [jordanbaird/Ice #188](https://github.com/jordanbaird/Ice/issues/188) | 功能请求 | [Feature Request]: Option to only hide on built-in display |
| [jordanbaird/Ice #201](https://github.com/jordanbaird/Ice/issues/201) | 故障报告 | [Bug]: Can't arrange or display menu bar items when the menu bar is automatically hidden |
| [jordanbaird/Ice #223](https://github.com/jordanbaird/Ice/issues/223) | 功能请求 | [Feature Request]: Ability to enable Ice Bar only when on built-in display |
| [jordanbaird/Ice #234](https://github.com/jordanbaird/Ice/issues/234) | 故障报告 | [Bug]: Rapidly switching spaces breaks Ice Bar item display |
| [jordanbaird/Ice #241](https://github.com/jordanbaird/Ice/issues/241) | 故障报告 | [Bug]: Gap in menu bar items on inactive display when showing hidden section |
| [jordanbaird/Ice #242](https://github.com/jordanbaird/Ice/issues/242) | 功能请求 | [Feature Request]: Ability to have unique menubars for each display |
| [jordanbaird/Ice #260](https://github.com/jordanbaird/Ice/issues/260) | 故障报告 | [Bug]: Both inset menu bar shape and Ice Bar are too short on notched display when set to a lower resolution |
| [jordanbaird/Ice #272](https://github.com/jordanbaird/Ice/issues/272) | 故障报告 | [Bug]: Extra spaces in iPad sidecar. |
| [jordanbaird/Ice #299](https://github.com/jordanbaird/Ice/issues/299) | 功能请求 | [Feature Request]: Always show hidden items if monitor screen is larger than <enter resolution> |
| [jordanbaird/Ice #303](https://github.com/jordanbaird/Ice/issues/303) | 功能请求 | [Feature Request]: Use Ice Bar only when screen size is smaller than <enter resolution> |
| [jordanbaird/Ice #331](https://github.com/jordanbaird/Ice/issues/331) | 故障报告 | [Bug]: Hidden icons cannot be displayed when menu bar automatically hidden while in full screen |
| [jordanbaird/Ice #340](https://github.com/jordanbaird/Ice/issues/340) | 功能请求 | [Feature Request]: Show ice bar next to mouse in any screen location with keyboard shortcut |
| [jordanbaird/Ice #342](https://github.com/jordanbaird/Ice/issues/342) | 功能请求 | [Feature Request]: Display menu bar items as a vertical list |
| [jordanbaird/Ice #359](https://github.com/jordanbaird/Ice/issues/359) | 故障报告 | [Bug]: Menubars are not correct with external display on MacBook Pro |
| [jordanbaird/Ice #383](https://github.com/jordanbaird/Ice/issues/383) | 故障报告 | [Bug]: Disabling displays have separate spaces not working |
| [jordanbaird/Ice #406](https://github.com/jordanbaird/Ice/issues/406) | 功能请求 | [Feature Request]: Allow clicks inside the notch |
| [jordanbaird/Ice #445](https://github.com/jordanbaird/Ice/issues/445) | 故障报告 | Menu bar in middle of screen |
| [jordanbaird/Ice #456](https://github.com/jordanbaird/Ice/issues/456) | 故障报告 | [Bug]: Ice interferes with right-click on title bar on display where menu bar is not displayed |
| [jordanbaird/Ice #486](https://github.com/jordanbaird/Ice/issues/486) | 故障报告 | Zoomed-in part of the screen sometimes jumps around when macOS Display Zoom is active (while running Ice) |
| [jordanbaird/Ice #517](https://github.com/jordanbaird/Ice/issues/517) | 故障报告 | [Bug]:Bar in the middle of the screen |
| [jordanbaird/Ice #529](https://github.com/jordanbaird/Ice/issues/529) | 故障报告 | [Bug]: The right bar is longer than expected on ultrawide screen |
| [jordanbaird/Ice #550](https://github.com/jordanbaird/Ice/issues/550) | 故障报告 | [Bug]: <bug title>With VMWare + Windows 11, ICE shows menu bar in the middle of an external monitor |
| [jordanbaird/Ice #555](https://github.com/jordanbaird/Ice/issues/555) | 功能请求 | [Feature Request]: <Disable / alt settings with external monitor> |
| [jordanbaird/Ice #570](https://github.com/jordanbaird/Ice/issues/570) | 功能请求 | [Feature Request]: When bar items pass through the notch |
| [jordanbaird/Ice #573](https://github.com/jordanbaird/Ice/issues/573) | 故障报告 | [Bug]: Widescreen Monitors Hidden Menu Always Visible |
| [jordanbaird/Ice #576](https://github.com/jordanbaird/Ice/issues/576) | 故障报告 | [Bug]: <UI Bar Appearing on Main Display When Playing Fullscreen Video on Extended Display> |
| [jordanbaird/Ice #604](https://github.com/jordanbaird/Ice/issues/604) | 功能请求 | [Feature Request]: Disable functionality behind notch |
| [jordanbaird/Ice #609](https://github.com/jordanbaird/Ice/issues/609) | 故障报告 | Random bar in the middle of the screen |
| [jordanbaird/Ice #627](https://github.com/jordanbaird/Ice/issues/627) | 故障报告 | [Bug]: Menu bar appearance not being displayed |
| [jordanbaird/Ice #636](https://github.com/jordanbaird/Ice/issues/636) | 故障报告 | [Bug]: <bug title> Shows weird bar when connected to monitor |
| [jordanbaird/Ice #639](https://github.com/jordanbaird/Ice/issues/639) | 故障报告 | [Bug]: Menu bar on multiple displays |
| [jordanbaird/Ice #646](https://github.com/jordanbaird/Ice/issues/646) | 故障报告 | [Bug]: Clickable area to activate Ice extends beyond menu bar to blank area of 2nd monitor. |
| [jordanbaird/Ice #657](https://github.com/jordanbaird/Ice/issues/657) | 故障报告 | [Bug]: the Menu Bar's height with "Shape kind = full" is a few pixels too short on second monitor |
| [jordanbaird/Ice #679](https://github.com/jordanbaird/Ice/issues/679) | 故障报告 | [Bug]: "Unable to display menu bar items" on macOS Tahoe/Ice 0.11.13-dev.2 |
| [jordanbaird/Ice #687](https://github.com/jordanbaird/Ice/issues/687) | 故障报告 | [Bug]: Doesn't display menu bar layout |
| [jordanbaird/Ice #691](https://github.com/jordanbaird/Ice/issues/691) | 功能请求 | [Feature Request]: Allow unhide all when the display is larger |
| [jordanbaird/Ice #698](https://github.com/jordanbaird/Ice/issues/698) | 故障报告 | [Bug]: On Tahoe, Items appear different sizes across monitor and laptop screen |
| [jordanbaird/Ice #703](https://github.com/jordanbaird/Ice/issues/703) | 功能请求 | [Feature Request]: Ice Bar only on Macs with a Notch |
| [jordanbaird/Ice #710](https://github.com/jordanbaird/Ice/issues/710) | 故障报告 | [Bug]: Ice shows "Unable to display menu bar item" under macOS 26 Tahoe |
| [jordanbaird/Ice #711](https://github.com/jordanbaird/Ice/issues/711) | 故障报告 | [Bug]: "Unable to display menu bar items" \| macOS Tahoe Version 26.0 (25A354) \| Ice 0.11.13-dev.2 |
| [jordanbaird/Ice #715](https://github.com/jordanbaird/Ice/issues/715) | 故障报告 | [Bug]: If a system menu icon/text winds up in the notch area, it simply disappears! |
| [jordanbaird/Ice #750](https://github.com/jordanbaird/Ice/issues/750) | 故障报告 | [Bug]: Weird line always drawn on secondary monitor |
| [jordanbaird/Ice #780](https://github.com/jordanbaird/Ice/issues/780) | 故障报告 | [Bug]: Bug on Vertical Monitors |
| [jordanbaird/Ice #783](https://github.com/jordanbaird/Ice/issues/783) | 功能请求 | [Feature Request]: Separate sets for laptops when connect to external monitor |
| [jordanbaird/Ice #797](https://github.com/jordanbaird/Ice/issues/797) | 功能请求 | [Feature Request]: only on screens with a notch |
| [jordanbaird/Ice #824](https://github.com/jordanbaird/Ice/issues/824) | 故障报告 | [Bug]: Right-clicking in external monitor opens "Edit menu bar appearance" menu |
| [jordanbaird/Ice #825](https://github.com/jordanbaird/Ice/issues/825) | 故障报告 | [Bug]: "show on click" on secondary screen shows the extra Ice bar in a small resolution |
| [jordanbaird/Ice #829](https://github.com/jordanbaird/Ice/issues/829) | 故障报告 | [Bug]: the ice bar cannot show the proper size when second monitor connected |
| [jordanbaird/Ice #836](https://github.com/jordanbaird/Ice/issues/836) | 故障报告 | [Bug]: Ice didn't work on external monitor menu-bar on auto-hide |
| [jordanbaird/Ice #858](https://github.com/jordanbaird/Ice/issues/858) | 故障报告 | [Bug]: second screen layout wrong display |
| [jordanbaird/Ice #863](https://github.com/jordanbaird/Ice/issues/863) | 故障报告 | [Bug]: Black square appears in bottom-right corner of primary display when secondary display has fullscreen window |
| [jordanbaird/Ice #910](https://github.com/jordanbaird/Ice/issues/910) | 故障报告 | [Bug]: iPad appearance tint shows on main monitor when the iPad is used as an extended display |
| [jordanbaird/Ice #929](https://github.com/jordanbaird/Ice/issues/929) | 故障报告 | [Bug]: Menu bar scaling and layout issues on external/built-in displays (macOS 26.4.1) |
| [jordanbaird/Ice #955](https://github.com/jordanbaird/Ice/issues/955) | 故障报告 | [Bug]: Scale error and auto-deploying |
| [jordanbaird/Ice #986](https://github.com/jordanbaird/Ice/issues/986) | 故障报告 | [Bug]: Ice Bar leaves a ghost/visual artifact on the primary display when a video enters fullscreen on a secondary display |
| [jordanbaird/Ice #987](https://github.com/jordanbaird/Ice/issues/987) | 故障报告 | [Bug]: Ice Bar icons shrink drastically when expanded on an external display |
| [jordanbaird/Ice #988](https://github.com/jordanbaird/Ice/issues/988) | 故障报告 | [Bug]: Ice Bar fullscreen expansion behaves differently depending on which display contains the active window |

### 触发、点击与自动隐藏

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [cavaldos/Ice #12](https://github.com/cavaldos/Ice/issues/12) | 故障报告 | [Bug]: Collapse/Expand button in menu bar is not working |
| [jordanbaird/Ice #62](https://github.com/jordanbaird/Ice/issues/62) | 功能请求 | [Feature Request]: Show menu bar items when trigger condition are met |
| [jordanbaird/Ice #113](https://github.com/jordanbaird/Ice/issues/113) | 功能请求 | [Feature Request]: Scroll again to toggle always-hidden section |
| [jordanbaird/Ice #144](https://github.com/jordanbaird/Ice/issues/144) | 故障报告 | [Bug]: Doing opt click after click does not hide app menus |
| [jordanbaird/Ice #244](https://github.com/jordanbaird/Ice/issues/244) | 故障报告 | [Bug]: App shows up in non-hidden bar even after hidden |
| [jordanbaird/Ice #246](https://github.com/jordanbaird/Ice/issues/246) | 故障报告 | [Bug]: Ice doesn't open its settings when double clicking its app icon on macOS 15 |
| [jordanbaird/Ice #286](https://github.com/jordanbaird/Ice/issues/286) | 故障报告 | [Bug]: Show on click/scroll not working on non-fullscreen, auto-hidden menu bar |
| [jordanbaird/Ice #316](https://github.com/jordanbaird/Ice/issues/316) | 故障报告 | [Bug]: Items rehidden after selecting "Show the Hidden Section" in Ice icon menu with "Show on hover" setting enabled |
| [jordanbaird/Ice #321](https://github.com/jordanbaird/Ice/issues/321) | 功能请求 | [Feature Request]: Animation when showing items |
| [jordanbaird/Ice #378](https://github.com/jordanbaird/Ice/issues/378) | 功能请求 | [Feature Request]: Show all menu bar items as default |
| [jordanbaird/Ice #397](https://github.com/jordanbaird/Ice/issues/397) | 故障报告 | [Bug]: Dock icon appears when using Always hidden feature. |
| [jordanbaird/Ice #403](https://github.com/jordanbaird/Ice/issues/403) | 故障报告 | [Bug]: Make smart mode smarter: Don't collapse the menu bar icons when toggling switches of switch app |
| [jordanbaird/Ice #434](https://github.com/jordanbaird/Ice/issues/434) | 故障报告 | [Bug]: Hide Application Menus doesn't unless Enable always-hidden section is toggled on |
| [jordanbaird/Ice #452](https://github.com/jordanbaird/Ice/issues/452) | 故障报告 | [Bug]: Automatically rehide takes affect even when inside a hidden items menu options |
| [jordanbaird/Ice #463](https://github.com/jordanbaird/Ice/issues/463) | 功能请求 | [Feature Request]: Make the "Use Ice Bar" toggle dynamic |
| [jordanbaird/Ice #481](https://github.com/jordanbaird/Ice/issues/481) | 功能请求 | [Feature Request]: Option to enable showing hidden section when hovering over un-hidden side |
| [jordanbaird/Ice #485](https://github.com/jordanbaird/Ice/issues/485) | 故障报告 | [Bug]: Cannot show any menu bar items in hidden section |
| [jordanbaird/Ice #494](https://github.com/jordanbaird/Ice/issues/494) | 功能请求 | [Feature Request]: Make option for showing hidden items on mouse down, not up |
| [jordanbaird/Ice #515](https://github.com/jordanbaird/Ice/issues/515) | 功能请求 | [Feature Request]: Scrolling through menu bar items |
| [jordanbaird/Ice #519](https://github.com/jordanbaird/Ice/issues/519) | 功能请求 | [Feature Request]: Ability to show all icons in click menu |
| [jordanbaird/Ice #533](https://github.com/jordanbaird/Ice/issues/533) | 功能请求 | [Feature Request]: Make menu bar appear floating versus docked to top of screen |
| [jordanbaird/Ice #544](https://github.com/jordanbaird/Ice/issues/544) | 功能请求 | [Feature Request]: Disable in full screen mode |
| [jordanbaird/Ice #552](https://github.com/jordanbaird/Ice/issues/552) | 功能请求 | [Feature Request]: Option for Double click on ice icon in menu bar to show always hidden menu icons instead of settings |
| [jordanbaird/Ice #554](https://github.com/jordanbaird/Ice/issues/554) | 功能请求 | [Feature Request]: Show menu bar item name on hover |
| [jordanbaird/Ice #567](https://github.com/jordanbaird/Ice/issues/567) | 故障报告 | [Bug]: Clicking on the menus in some apps triggers Ice |
| [jordanbaird/Ice #584](https://github.com/jordanbaird/Ice/issues/584) | 故障报告 | [Bug]: macOS 26 application menu change to ice empty menu when clicking on empty space on menu bar to expand collapse items |
| [jordanbaird/Ice #595](https://github.com/jordanbaird/Ice/issues/595) | 故障报告 | [Bug]: Option-click should expand even when enable always-hidden section is turned off |
| [jordanbaird/Ice #600](https://github.com/jordanbaird/Ice/issues/600) | 功能请求 | [Feature Request]: Open hidden items from the Ice Icon |
| [jordanbaird/Ice #620](https://github.com/jordanbaird/Ice/issues/620) | 故障报告 | [Bug]:Hide application menus when showing menu bar items |
| [jordanbaird/Ice #621](https://github.com/jordanbaird/Ice/issues/621) | 故障报告 | [Bug]: Can't fully interact with hidden menu items |
| [jordanbaird/Ice #634](https://github.com/jordanbaird/Ice/issues/634) | 故障报告 | [Bug]: Option-Click does not work if Show on Click is disabled |
| [jordanbaird/Ice #640](https://github.com/jordanbaird/Ice/issues/640) | 故障报告 | [Bug]: Strange Mouse Behavior After Clicking Hidden Icon |
| [jordanbaird/Ice #644](https://github.com/jordanbaird/Ice/issues/644) | 故障报告 | [Bug]: <Option-Click works randomly> |
| [jordanbaird/Ice #683](https://github.com/jordanbaird/Ice/issues/683) | 故障报告 | [Bug]: (Tahoe Beta) Hover affects across screens |
| [jordanbaird/Ice #694](https://github.com/jordanbaird/Ice/issues/694) | 故障报告 | [Bug]: Once opened does not go back again |
| [jordanbaird/Ice #695](https://github.com/jordanbaird/Ice/issues/695) | 故障报告 | [Bug]: ICE window opens on ICE menubar click + at login |
| [jordanbaird/Ice #714](https://github.com/jordanbaird/Ice/issues/714) | 故障报告 | [Bug]: Show Ice bar on hover should not trigger in Mission Control view |
| [jordanbaird/Ice #717](https://github.com/jordanbaird/Ice/issues/717) | 故障报告 | [Bug]: Show on swipe works but not scroll |
| [jordanbaird/Ice #718](https://github.com/jordanbaird/Ice/issues/718) | 故障报告 | [Bug]: Cannot hide its icon when using game mode |
| [jordanbaird/Ice #724](https://github.com/jordanbaird/Ice/issues/724) | 功能请求 | [Feature Request]: Hide Ice icon from dock |
| [jordanbaird/Ice #725](https://github.com/jordanbaird/Ice/issues/725) | 故障报告 | [Bug]: App icon opens on hover |
| [jordanbaird/Ice #726](https://github.com/jordanbaird/Ice/issues/726) | 功能请求 | [Feature Request]: Clicking on center of menu bar reveals the desktop |
| [jordanbaird/Ice #728](https://github.com/jordanbaird/Ice/issues/728) | 故障报告 | [Bug]: Chevron separator is always shown |
| [jordanbaird/Ice #751](https://github.com/jordanbaird/Ice/issues/751) | 故障报告 | [Bug]: The cursor is not visible after clicking the ICE icon and then selecting a hidden icon from the ICE bar. |
| [jordanbaird/Ice #768](https://github.com/jordanbaird/Ice/issues/768) | 故障报告 | [Bug]: ICE dock icon apeears when clicking on chevron to show menu. |
| [jordanbaird/Ice #808](https://github.com/jordanbaird/Ice/issues/808) | 故障报告 | [Bug]: macOS "Tahoe" - after system restart icon remains in dock |
| [jordanbaird/Ice #845](https://github.com/jordanbaird/Ice/issues/845) | 故障报告 | [Bug]: Hidden menubar items not selectable |
| [jordanbaird/Ice #865](https://github.com/jordanbaird/Ice/issues/865) | 故障报告 | [Bug]: macOS 26.3 beta 3 prevents Ice from expanding |
| [jordanbaird/Ice #879](https://github.com/jordanbaird/Ice/issues/879) | 故障报告 | [Bug]: "hide app menus when showing menu bar items" feature not working |
| [jordanbaird/Ice #899](https://github.com/jordanbaird/Ice/issues/899) | 故障报告 | [Bug]: Ice triggering while clicking just under the menu bar in fullscreen |
| [jordanbaird/Ice #906](https://github.com/jordanbaird/Ice/issues/906) | 故障报告 | [Bug]: App opens in dock when expanding the bar |
| [jordanbaird/Ice #914](https://github.com/jordanbaird/Ice/issues/914) | 故障报告 | [Bug]: Ice Bar auto-hides before cursor reaches it (latest beta) |
| [jordanbaird/Ice #961](https://github.com/jordanbaird/Ice/issues/961) | 功能请求 | [Feature Request]: No dock icon |
| [jordanbaird/Ice #970](https://github.com/jordanbaird/Ice/issues/970) | 故障报告 | [Bug]: Not automatically hiding in MacOS 27 |
| [jordanbaird/Ice #996](https://github.com/jordanbaird/Ice/issues/996) | 故障报告 | [Bug]: Ice not working properly on macOS 27 Golden Gate |
| [jordanbaird/Ice #1008](https://github.com/jordanbaird/Ice/issues/1008) | 故障报告 | [Bug]: Not functioning since MacOS 27 update on my Macbook pro M3 pro |
| [jordanbaird/Ice #1014](https://github.com/jordanbaird/Ice/issues/1014) | 其他反馈 | [macOS 27 / PR #995] With an app item among the system items, clicking the battery opens that app and Wi-Fi does not open |

### Ice Bar 功能与交互

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #208](https://github.com/jordanbaird/Ice/issues/208) | 功能请求 | Feature Request: Adding Ice Bar as an additional layout under Menu Bar Items |
| [jordanbaird/Ice #214](https://github.com/jordanbaird/Ice/issues/214) | 功能请求 | [Feature Request]: Ability to pin Ice Bar |
| [jordanbaird/Ice #227](https://github.com/jordanbaird/Ice/issues/227) | 功能请求 | [Feature Request]: Use Ice Bar as overflow spot for otherwise-hidden menu items |
| [jordanbaird/Ice #243](https://github.com/jordanbaird/Ice/issues/243) | 功能请求 | [Feature Request]: Menu Bar Widget Ideas |
| [jordanbaird/Ice #254](https://github.com/jordanbaird/Ice/issues/254) | 故障报告 | [Bug]: Transparent items in Ice Bar while in fullscreen mode |
| [jordanbaird/Ice #335](https://github.com/jordanbaird/Ice/issues/335) | 功能请求 | [Feature Request]: Ice Bar only for Always Hidden |
| [jordanbaird/Ice #372](https://github.com/jordanbaird/Ice/issues/372) | 功能请求 | [Feature Request]: Ability to see both hidden sections at the same time when using the Ice Bar |
| [jordanbaird/Ice #487](https://github.com/jordanbaird/Ice/issues/487) | 功能请求 | [Feature Request]: Always Hidden Use Ice Bar |
| [jordanbaird/Ice #495](https://github.com/jordanbaird/Ice/issues/495) | 功能请求 | [Feature Request]: Organize hidden icons into multiple rows |
| [jordanbaird/Ice #518](https://github.com/jordanbaird/Ice/issues/518) | 功能请求 | [Feature Request]: Configuration option to Always open Ice as minimized |
| [jordanbaird/Ice #527](https://github.com/jordanbaird/Ice/issues/527) | 功能请求 | [Feature Request]: Allow pinning bar location with hidden ice icon |
| [jordanbaird/Ice #545](https://github.com/jordanbaird/Ice/issues/545) | 故障报告 | [Bug]: ice bar sometimes doesn't show anything |
| [jordanbaird/Ice #551](https://github.com/jordanbaird/Ice/issues/551) | 功能请求 | [Feature Request]: Grid option when using Ice bar |
| [jordanbaird/Ice #625](https://github.com/jordanbaird/Ice/issues/625) | 故障报告 | [Bug]: Oversize hidden bar |
| [jordanbaird/Ice #630](https://github.com/jordanbaird/Ice/issues/630) | 功能请求 | [Feature Request]: Ice Bar under when I'm on one screen. |
| [jordanbaird/Ice #635](https://github.com/jordanbaird/Ice/issues/635) | 故障报告 | Weird behavior under Tahoe MacOS 26 Public Beta 2 |
| [jordanbaird/Ice #665](https://github.com/jordanbaird/Ice/issues/665) | 故障报告 | [Bug]: MacOS Tahoe Makes Ice Bar Invisible |
| [jordanbaird/Ice #686](https://github.com/jordanbaird/Ice/issues/686) | 故障报告 | [Bug]: <bug title>Ice bar won't let me choose app |
| [jordanbaird/Ice #727](https://github.com/jordanbaird/Ice/issues/727) | 功能请求 | [Feature Request]: Bartender 3 mode |
| [jordanbaird/Ice #813](https://github.com/jordanbaird/Ice/issues/813) | 故障报告 | [Bug]: Ice bar closes soon after opening |
| [jordanbaird/Ice #814](https://github.com/jordanbaird/Ice/issues/814) | 故障报告 | [Bug]: "Use Ice Bar" feature does not work |
| [jordanbaird/Ice #888](https://github.com/jordanbaird/Ice/issues/888) | 故障报告 | [Bug]: Cannot use ice bar when which between windows |
| [jordanbaird/Ice #890](https://github.com/jordanbaird/Ice/issues/890) | 故障报告 | [Bug]: Ice Bar |

### 菜单栏外观与渲染

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #58](https://github.com/jordanbaird/Ice/issues/58) | 故障报告 | [Bug]: Menu Bar Flashes |
| [jordanbaird/Ice #186](https://github.com/jordanbaird/Ice/issues/186) | 功能请求 | [Feature Request]: Support GIFs as Ice icon |
| [jordanbaird/Ice #212](https://github.com/jordanbaird/Ice/issues/212) | 故障报告 | [Bug]: Ice Bar doesn't reliably change color when activated on a new desktop |
| [jordanbaird/Ice #216](https://github.com/jordanbaird/Ice/issues/216) | 故障报告 | [Bug]: Menu bar appearance shows above Mission Control after deleting a space |
| [jordanbaird/Ice #239](https://github.com/jordanbaird/Ice/issues/239) | 故障报告 | [Bug]: Some menu bar clip issue while using Menu bar split shape  |
| [jordanbaird/Ice #245](https://github.com/jordanbaird/Ice/issues/245) | 功能请求 | [Feature Request]: Allow setting SF Symbols for when the icon is toggled |
| [jordanbaird/Ice #252](https://github.com/jordanbaird/Ice/issues/252) | 功能请求 | [Feature Request]: RTL support  |
| [jordanbaird/Ice #273](https://github.com/jordanbaird/Ice/issues/273) | 功能请求 | [Feature Request]: Custom refresh rate for menu bar item images |
| [jordanbaird/Ice #336](https://github.com/jordanbaird/Ice/issues/336) | 故障报告 | [Bug]: Split Type Ice Bar keeps the wallpaper from the previous space when switching spaces/screens |
| [jordanbaird/Ice #337](https://github.com/jordanbaird/Ice/issues/337) | 故障报告 | [Bug]: Menu bar appearance uses wallpaper from previous space when swiping through spaces in Mission Control |
| [jordanbaird/Ice #368](https://github.com/jordanbaird/Ice/issues/368) | 功能请求 | [Feature Request]: Menu Bar Appearance for Hidden Sections |
| [jordanbaird/Ice #380](https://github.com/jordanbaird/Ice/issues/380) | 功能请求 | [Feature Request]: Can we send shadow to back? |
| [jordanbaird/Ice #409](https://github.com/jordanbaird/Ice/issues/409) | 故障报告 | [Bug]: macOS Sequoia requires a restart of Ice to render the menubar border |
| [jordanbaird/Ice #435](https://github.com/jordanbaird/Ice/issues/435) | 故障报告 | [Bug]: Glitch when toggle dock |
| [jordanbaird/Ice #451](https://github.com/jordanbaird/Ice/issues/451) | 故障报告 | [Bug]: Unexpected behavior after swiping between desktop and full screen apps |
| [jordanbaird/Ice #468](https://github.com/jordanbaird/Ice/issues/468) | 功能请求 | [Feature Request]: Disable / Customize Menu Bar Appearance in Full Screen Mode |
| [jordanbaird/Ice #472](https://github.com/jordanbaird/Ice/issues/472) | 故障报告 | [Bug]: Menu bar item spacing not applying correctly |
| [jordanbaird/Ice #482](https://github.com/jordanbaird/Ice/issues/482) | 功能请求 | [Feature Request]: Better appearance for rounded menu bar |
| [jordanbaird/Ice #510](https://github.com/jordanbaird/Ice/issues/510) | 故障报告 | [Bug]: Split bar doesn't reach top of scren |
| [jordanbaird/Ice #514](https://github.com/jordanbaird/Ice/issues/514) | 故障报告 | [Bug]: Menu bar shadow issue with single application window |
| [jordanbaird/Ice #521](https://github.com/jordanbaird/Ice/issues/521) | 故障报告 | [Bug]: Background visible when entering fullscreen on video. or other application |
| [jordanbaird/Ice #525](https://github.com/jordanbaird/Ice/issues/525) | 故障报告 | [Bug]: split menu bar and related effects seemingly disabled in macOS 15.3.2 |
| [jordanbaird/Ice #538](https://github.com/jordanbaird/Ice/issues/538) | 功能请求 | [Feature Request]: Round corners of clicked menu bar items |
| [jordanbaird/Ice #541](https://github.com/jordanbaird/Ice/issues/541) | 故障报告 | [Bug]: Split view broke with extended screens |
| [jordanbaird/Ice #606](https://github.com/jordanbaird/Ice/issues/606) | 故障报告 | [Bug]: Ice bar does't leaves artefact behind when auto-hiding in full screen |
| [jordanbaird/Ice #608](https://github.com/jordanbaird/Ice/issues/608) | 故障报告 | [Bug]: Split menu bar holds onto a large amount of blank space to the |
| [jordanbaird/Ice #645](https://github.com/jordanbaird/Ice/issues/645) | 故障报告 | [Bug]: menubar periodical glitch every 'x' minutes |
| [jordanbaird/Ice #649](https://github.com/jordanbaird/Ice/issues/649) | 故障报告 | [Bug]: split menu bar weird behavior when showing the desktop |
| [jordanbaird/Ice #651](https://github.com/jordanbaird/Ice/issues/651) | 功能请求 | [Feature Request]: Allow the tint option to affect the menubar background only and add transparency slider to colour swatch(es) |
| [jordanbaird/Ice #659](https://github.com/jordanbaird/Ice/issues/659) | 故障报告 | [Bug]: <MacOS Tahoe> the bar appearance shows a slight shadow on top on the screen |
| [jordanbaird/Ice #676](https://github.com/jordanbaird/Ice/issues/676) | 故障报告 | [Bug]: Empty space on the left side of the right menu bar when split, MacOS Tahoe |
| [jordanbaird/Ice #705](https://github.com/jordanbaird/Ice/issues/705) | 功能请求 | [Feature Request]: Allow clear shape kind |
| [jordanbaird/Ice #733](https://github.com/jordanbaird/Ice/issues/733) | 故障报告 | [Bug]: Strange rendering issue |
| [jordanbaird/Ice #754](https://github.com/jordanbaird/Ice/issues/754) | 功能请求 | [Feature Request]: Dark icon |
| [jordanbaird/Ice #763](https://github.com/jordanbaird/Ice/issues/763) | 故障报告 | [Bug]: Color Picker is broken for Menu Bar |
| [jordanbaird/Ice #793](https://github.com/jordanbaird/Ice/issues/793) | 故障报告 | [Bug]: White icons on white background |
| [jordanbaird/Ice #835](https://github.com/jordanbaird/Ice/issues/835) | 故障报告 | [Bug]: Ice stopped doing anything other than changing the Bar's appearance |
| [jordanbaird/Ice #943](https://github.com/jordanbaird/Ice/issues/943) | 故障报告 | [Bug]: Ligthing error when enabeling split shape in menu bar appearance |
| [jordanbaird/Ice #959](https://github.com/jordanbaird/Ice/issues/959) | 故障报告 | [Bug]: Split menu bar does not function like expected in full screen |

### 崩溃、冻结与资源消耗

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #329](https://github.com/jordanbaird/Ice/issues/329) | 故障报告 | [Bug]: When turning off "Show ice icon" and the turning it back on, the icon doesn't automatically repopulate |
| [jordanbaird/Ice #334](https://github.com/jordanbaird/Ice/issues/334) | 故障报告 | [Bug]: Ice has noticeable energy impact during mouse movement |
| [jordanbaird/Ice #479](https://github.com/jordanbaird/Ice/issues/479) | 故障报告 | [Bug]: Energy impact |
| [jordanbaird/Ice #530](https://github.com/jordanbaird/Ice/issues/530) | 故障报告 | [Bug]: high memory usage |
| [jordanbaird/Ice #563](https://github.com/jordanbaird/Ice/issues/563) | 故障报告 | [Bug]: Ice occasionally crashes. |
| [jordanbaird/Ice #578](https://github.com/jordanbaird/Ice/issues/578) | 故障报告 | [Bug]: High CPU usage |
| [jordanbaird/Ice #603](https://github.com/jordanbaird/Ice/issues/603) | 故障报告 | [Bug]: App launches, then immediately crashes, on macOS Tahoe Beta 3 |
| [jordanbaird/Ice #647](https://github.com/jordanbaird/Ice/issues/647) | 故障报告 | [Bug]: <MacOS Tahoe app craches> |
| [jordanbaird/Ice #669](https://github.com/jordanbaird/Ice/issues/669) | 故障报告 | [Bug]: <crashes on MACOS  26 tahoe 26> |
| [jordanbaird/Ice #671](https://github.com/jordanbaird/Ice/issues/671) | 故障报告 | [Bug]: unexpected closure |
| [jordanbaird/Ice #721](https://github.com/jordanbaird/Ice/issues/721) | 故障报告 | [Bug]: Latest Tahoe Beta update gives Ice error, Ice freezes |
| [jordanbaird/Ice #740](https://github.com/jordanbaird/Ice/issues/740) | 故障报告 | [Bug]: Crashes every time I use it |
| [jordanbaird/Ice #742](https://github.com/jordanbaird/Ice/issues/742) | 故障报告 | [Bug]: I just installed Tahoe in my Mac and ICE is not working as it used to.  I am attaching the log report sent back form IOS.  Since the principal functionality that stopped work is to have the menu in a separate bar below the menu bar. |
| [jordanbaird/Ice #746](https://github.com/jordanbaird/Ice/issues/746) | 故障报告 | [Bug]: Event operation timed out |
| [jordanbaird/Ice #777](https://github.com/jordanbaird/Ice/issues/777) | 故障报告 | [Bug]:  Ice App Freezes During Screen Capture Operations |
| [jordanbaird/Ice #779](https://github.com/jordanbaird/Ice/issues/779) | 故障报告 | [Bug]: 点击图标自动就退出了.系统崩溃 |
| [jordanbaird/Ice #786](https://github.com/jordanbaird/Ice/issues/786) | 故障报告 | [Bug]:Selecting 'Ice Bar' in settings and then tapping on the Ice icon causes Ice to crash |
| [jordanbaird/Ice #790](https://github.com/jordanbaird/Ice/issues/790) | 故障报告 | [Bug]: Multiple monitors freeze |
| [jordanbaird/Ice #796](https://github.com/jordanbaird/Ice/issues/796) | 故障报告 | [Bug]: App crashes when opening the sub menu |
| [jordanbaird/Ice #807](https://github.com/jordanbaird/Ice/issues/807) | 故障报告 | [Bug]: [Macbook Pro, M4 Pro] Not responding |
| [jordanbaird/Ice #810](https://github.com/jordanbaird/Ice/issues/810) | 故障报告 | [Bug]: Crash on M1 Pro |
| [jordanbaird/Ice #819](https://github.com/jordanbaird/Ice/issues/819) | 故障报告 | [Bug]: memory leak in WindowServer caused by Ice? |
| [jordanbaird/Ice #821](https://github.com/jordanbaird/Ice/issues/821) | 故障报告 | [Bug]: ICE crashes every time on clicking the ICE icon in menubar. iMac, macOS 26.2 (issue identical on 26.1). |
| [jordanbaird/Ice #830](https://github.com/jordanbaird/Ice/issues/830) | 故障报告 | [Bug]: So many bugs |
| [jordanbaird/Ice #838](https://github.com/jordanbaird/Ice/issues/838) | 故障报告 | [Bug]: it seems to be frozen. I have to quit it and re-launch it to get it to function properly. |
| [jordanbaird/Ice #840](https://github.com/jordanbaird/Ice/issues/840) | 其他反馈 | Crash when enabling Ice Bar: EXC_BREAKPOINT in window handling |
| [jordanbaird/Ice #855](https://github.com/jordanbaird/Ice/issues/855) | 故障报告 | [Bug]: Ice keeps crashing after updating to OS26.2 |
| [jordanbaird/Ice #867](https://github.com/jordanbaird/Ice/issues/867) | 故障报告 | [Bug]: Ice crash on macOS 26.2 (25C56) |
| [jordanbaird/Ice #880](https://github.com/jordanbaird/Ice/issues/880) | 故障报告 | [Bug]: not be able to use it on imac today |
| [jordanbaird/Ice #905](https://github.com/jordanbaird/Ice/issues/905) | 故障报告 | [Bug]: |
| [jordanbaird/Ice #908](https://github.com/jordanbaird/Ice/issues/908) | 故障报告 | [Bug]: Ice appears to have caused system-wide freeze & kernel panic after ~33 hours of uptime |
| [jordanbaird/Ice #915](https://github.com/jordanbaird/Ice/issues/915) | 故障报告 | [Bug]: Unsplash client crashes shortly after being hidden by ICE |
| [jordanbaird/Ice #925](https://github.com/jordanbaird/Ice/issues/925) | 故障报告 | [Bug]: Crash when enabling "Use Ice Bar" with Dynamic location |
| [jordanbaird/Ice #947](https://github.com/jordanbaird/Ice/issues/947) | 故障报告 | [Bug]: app crash after click in menubar |
| [jordanbaird/Ice #968](https://github.com/jordanbaird/Ice/issues/968) | 其他反馈 | macOS 26.5.2: Ice stuck / menu bar stays hidden after form dropdown hang (Dock auto-hide also stuck) |
| [jordanbaird/Ice #974](https://github.com/jordanbaird/Ice/issues/974) | 故障报告 | [Bug]: Orphaned application menu-bar windows stuck at CGWindow layer 101, invisible to accessibility (macOS 26.6.1, 0.11.13-dev.2) |
| [jordanbaird/Ice #977](https://github.com/jordanbaird/Ice/issues/977) | 故障报告 | [Bug]: crashes whenever I use the trigger button in the menu bar |

### 权限、更新、安装与分发

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #73](https://github.com/jordanbaird/Ice/issues/73) | 功能请求 | [Feature Request]: Defer recommended payment until once installed |
| [jordanbaird/Ice #210](https://github.com/jordanbaird/Ice/issues/210) | 功能请求 | [Feature Request]: Option to update to beta releases |
| [jordanbaird/Ice #770](https://github.com/jordanbaird/Ice/issues/770) | 故障报告 | [Bug]: App gets stuck when installed |
| [jordanbaird/Ice #834](https://github.com/jordanbaird/Ice/issues/834) | 故障报告 | [Bug]: |
| [jordanbaird/Ice #862](https://github.com/jordanbaird/Ice/issues/862) | 功能请求 | [Feature Request]: submit the app to the homebrew |
| [jordanbaird/Ice #934](https://github.com/jordanbaird/Ice/issues/934) | 故障报告 | [Bug]: Nothing happens when I try to run Ice |
| [jordanbaird/Ice #1006](https://github.com/jordanbaird/Ice/issues/1006) | 其他反馈 | [macOS 27.0.1] What got Ice working with PR #995, plus two things to look into |

### 第三方应用与系统项目兼容

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #300](https://github.com/jordanbaird/Ice/issues/300) | 故障报告 | [Bug]: Rearranging icons with multiple instances of OneDrive |
| [jordanbaird/Ice #330](https://github.com/jordanbaird/Ice/issues/330) | 故障报告 | [Bug]: Can not work with Focus Menu Bar Item (https://heyfocus.com) |
| [jordanbaird/Ice #404](https://github.com/jordanbaird/Ice/issues/404) | 故障报告 | [Bug]: OneDrive changes from "Hidden" to "Visible" on click |
| [jordanbaird/Ice #440](https://github.com/jordanbaird/Ice/issues/440) | 故障报告 | [Bug]: The Shazam (music recognition) icon is invisible all the time |
| [jordanbaird/Ice #462](https://github.com/jordanbaird/Ice/issues/462) | 故障报告 | Keyboard Maestro will not move from hidden to visible |
| [jordanbaird/Ice #467](https://github.com/jordanbaird/Ice/issues/467) | 故障报告 | [Bug]: 1Password menu item weirdness |
| [jordanbaird/Ice #480](https://github.com/jordanbaird/Ice/issues/480) | 故障报告 | [Bug]: Interaction with Alcove |
| [jordanbaird/Ice #526](https://github.com/jordanbaird/Ice/issues/526) | 故障报告 | [Bug]: Ice Causing issues with the behaviour of the Motioncontrol Light app. The brights slider keeps disappearing when trying to adjust screen brightness |
| [jordanbaird/Ice #586](https://github.com/jordanbaird/Ice/issues/586) | 故障报告 | [Bug]: protonvpn app icon presses itself when it hides itself after being opened from ice bar |
| [jordanbaird/Ice #590](https://github.com/jordanbaird/Ice/issues/590) | 故障报告 | App duplicates itself in dock on Tahoe |
| [jordanbaird/Ice #619](https://github.com/jordanbaird/Ice/issues/619) | 故障报告 | [Bug]: Unable to Restore Menu Item After Removing Duplicate Chevron Icon |
| [jordanbaird/Ice #642](https://github.com/jordanbaird/Ice/issues/642) | 故障报告 | [Bug]: Clicking on BusyCal Menu in hidden section opened Apple Menu instead |
| [jordanbaird/Ice #656](https://github.com/jordanbaird/Ice/issues/656) | 故障报告 | [Bug]: <macOS Tahoe> Cannot move live activities across sections |
| [jordanbaird/Ice #658](https://github.com/jordanbaird/Ice/issues/658) | 故障报告 | [Bug]: <Getting focused out while playing league> |
| [jordanbaird/Ice #697](https://github.com/jordanbaird/Ice/issues/697) | 故障报告 | [Bug]: Make Lungo/Dato work with Ice |
| [jordanbaird/Ice #701](https://github.com/jordanbaird/Ice/issues/701) | 故障报告 | [Bug]: Volume UI hidden on change if menu bar icon is hidden |
| [jordanbaird/Ice #704](https://github.com/jordanbaird/Ice/issues/704) | 故障报告 | [Bug]: menu bar items (iphone notifications) cannot be moved |
| [jordanbaird/Ice #707](https://github.com/jordanbaird/Ice/issues/707) | 故障报告 | [Bug]: When using Cloudflare WARP with Ice, the WARP GUI is malfunctioning until iCE is restarted. |
| [jordanbaird/Ice #708](https://github.com/jordanbaird/Ice/issues/708) | 故障报告 | [Bug]: Ice Bar and Show on Hover hovering area detection bug when system menu bar is on auto-hide mode |
| [jordanbaird/Ice #719](https://github.com/jordanbaird/Ice/issues/719) | 故障报告 | [Bug]: Volume/brightness HUD not visible when Ice is running on macOS Tahoe |
| [jordanbaird/Ice #729](https://github.com/jordanbaird/Ice/issues/729) | 故障报告 | [Bug]: Menu Bar Item Stuck After Ice Bar Click When Live Activities are Active |
| [jordanbaird/Ice #731](https://github.com/jordanbaird/Ice/issues/731) | 功能请求 | [Feature Request]: Allow live activities to show |
| [jordanbaird/Ice #732](https://github.com/jordanbaird/Ice/issues/732) | 故障报告 | [Bug]: Docker for Mac ends up in "Always-Hidden Section" over time |
| [jordanbaird/Ice #739](https://github.com/jordanbaird/Ice/issues/739) | 故障报告 | [Bug]: No proper behaviour when multiple bar item of same app |
| [jordanbaird/Ice #748](https://github.com/jordanbaird/Ice/issues/748) | 故障报告 | [Bug]: 1Password |
| [jordanbaird/Ice #766](https://github.com/jordanbaird/Ice/issues/766) | 故障报告 | [Bug]: App with dropdown from menu bar (Mullvad VPN) appears as it auto-hides |
| [jordanbaird/Ice #798](https://github.com/jordanbaird/Ice/issues/798) | 故障报告 | [Bug]: Audio Wrangler Mute Icon Issue |
| [jordanbaird/Ice #806](https://github.com/jordanbaird/Ice/issues/806) | 故障报告 | [Bug]: Razer Synapse icon always hidden on startup |
| [jordanbaird/Ice #817](https://github.com/jordanbaird/Ice/issues/817) | 故障报告 | [Bug]: User (Login) Icon is not customasibale |
| [jordanbaird/Ice #826](https://github.com/jordanbaird/Ice/issues/826) | 故障报告 | [Bug]: Not opening menu item |
| [jordanbaird/Ice #844](https://github.com/jordanbaird/Ice/issues/844) | 故障报告 | [Bug]: System icons set to "Show When Active" don't remember their correct placement in the menubar |
| [jordanbaird/Ice #852](https://github.com/jordanbaird/Ice/issues/852) | 故障报告 | [Bug]: Ice bar cannot hide recording indicator in 15.7.3 |
| [jordanbaird/Ice #853](https://github.com/jordanbaird/Ice/issues/853) | 故障报告 | [Bug]: Cursor IDE icon position is not saved well |
| [jordanbaird/Ice #854](https://github.com/jordanbaird/Ice/issues/854) | 故障报告 | [Bug]: Icons are duplicated in the menu bar |
| [jordanbaird/Ice #857](https://github.com/jordanbaird/Ice/issues/857) | 故障报告 | [Bug]: Multiple identical app icons disappear when one is restored from hidden state (e.g. OneDrive) |
| [jordanbaird/Ice #886](https://github.com/jordanbaird/Ice/issues/886) | 功能请求 | [Feature Request]: Hide screen recording indicator |
| [jordanbaird/Ice #887](https://github.com/jordanbaird/Ice/issues/887) | 故障报告 | [Bug]: some application don't respect visibility section (like HubStuff) |
| [jordanbaird/Ice #909](https://github.com/jordanbaird/Ice/issues/909) | 故障报告 | [Bug]: OneDrive icons |
| [jordanbaird/Ice #918](https://github.com/jordanbaird/Ice/issues/918) | 故障报告 | [Bug]:When icon for Intego One is moved from hidden to visible bar in settings, the icon disappears |
| [jordanbaird/Ice #1007](https://github.com/jordanbaird/Ice/issues/1007) | 其他反馈 | [macOS 27 / PR #995] An app launched while concealed gets a squashed (3 pt) menu bar item that never recovers |

### 快捷键、自动化与配置能力

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #83](https://github.com/jordanbaird/Ice/issues/83) | 功能请求 | [Feature Request]: Organize apps by keyboard shortcuts or in preferences pane |
| [jordanbaird/Ice #95](https://github.com/jordanbaird/Ice/issues/95) | 功能请求 | [Feature Request]: Cross-Device Syncing |
| [jordanbaird/Ice #141](https://github.com/jordanbaird/Ice/issues/141) | 功能请求 | [Feature Request]: x-callback-url for automation |
| [jordanbaird/Ice #148](https://github.com/jordanbaird/Ice/issues/148) | 功能请求 | [Feature Request]: Custom trigger API for applications to implement |
| [jordanbaird/Ice #291](https://github.com/jordanbaird/Ice/issues/291) | 功能请求 | [Feature Request]: Hotkeys for individual menu bar items |
| [jordanbaird/Ice #326](https://github.com/jordanbaird/Ice/issues/326) | 功能请求 | [Feature Request]: Custom configuration path / export settings |
| [jordanbaird/Ice #382](https://github.com/jordanbaird/Ice/issues/382) | 功能请求 | [Feature Request]: Add AppleScript or CLI support |
| [jordanbaird/Ice #501](https://github.com/jordanbaird/Ice/issues/501) | 功能请求 | [Feature Request]: Raycast Integration |
| [jordanbaird/Ice #641](https://github.com/jordanbaird/Ice/issues/641) | 功能请求 | [Feature Request]: Support Ctrl+N and Ctrl+P to navigate down and up in the  menu bar items list |

### 本地化、文档与项目维护

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #601](https://github.com/jordanbaird/Ice/issues/601) | 功能请求 | [Feature Request]: Documentation for hidden and always hidden behavior |
| [jordanbaird/Ice #638](https://github.com/jordanbaird/Ice/issues/638) | 功能请求 | Can it support the multilingual version? |
| [jordanbaird/Ice #712](https://github.com/jordanbaird/Ice/issues/712) | 功能请求 | [Feature Request]: Localize Ice |
| [jordanbaird/Ice #745](https://github.com/jordanbaird/Ice/issues/745) | 故障报告 | [Love]: Thank You For Ice! |
| [jordanbaird/Ice #752](https://github.com/jordanbaird/Ice/issues/752) | 故障报告 | [Bug]: Latest beta update from Sept 16th - when is a new one coming with fixed bugs |
| [jordanbaird/Ice #760](https://github.com/jordanbaird/Ice/issues/760) | 功能请求 | [Feature Request]: Make stable version for Tahoe? |
| [jordanbaird/Ice #774](https://github.com/jordanbaird/Ice/issues/774) | 故障报告 | [Bug]: Website https://icemenubar.app/ appears to be down |
| [jordanbaird/Ice #787](https://github.com/jordanbaird/Ice/issues/787) | 功能请求 | [Feature Request]: need language option，Chinese for example.... |
| [jordanbaird/Ice #801](https://github.com/jordanbaird/Ice/issues/801) | 功能请求 | [Feature Request]: 求中文 |
| [jordanbaird/Ice #823](https://github.com/jordanbaird/Ice/issues/823) | 功能请求 | [Feature Request]: Are we every going to get a stable version for macOS Tahoe, or is the app not in development anymore? |
| [jordanbaird/Ice #877](https://github.com/jordanbaird/Ice/issues/877) | 故障报告 | [Bug]: PROJECT DEAD, no updates in 1.5 years, crashes all the time. |
| [jordanbaird/Ice #935](https://github.com/jordanbaird/Ice/issues/935) | 故障报告 | [Bug]: Website SSL cert expired |
| [jordanbaird/Ice #939](https://github.com/jordanbaird/Ice/issues/939) | 故障报告 | [Bug]: IS THIS PROJECT ABANDONED? |
| [jordanbaird/Ice #966](https://github.com/jordanbaird/Ice/issues/966) | 故障报告 | [Bug]: Unofficial macOS 26-compatible build of Ice (signed and notarized) |
| [jordanbaird/Ice #993](https://github.com/jordanbaird/Ice/issues/993) | 功能请求 | [Feature Request]: This project is no longer maintained by the original author |
| [jordanbaird/Ice #1011](https://github.com/jordanbaird/Ice/issues/1011) | 功能请求 | [Feature Request]: Some Golden Gate Clarity |
| [jordanbaird/Ice #1015](https://github.com/jordanbaird/Ice/issues/1015) | 功能请求 | [Feature Request]: Is the project still alive? |

### 系统升级兼容与待澄清反馈

| Issue | 类型 | 标题原文 |
| --- | --- | --- |
| [jordanbaird/Ice #633](https://github.com/jordanbaird/Ice/issues/633) | 故障报告 | [Bug]:macOS Tahoe 26中ice无法正常使用 |
| [jordanbaird/Ice #833](https://github.com/jordanbaird/Ice/issues/833) | 故障报告 | [Bug]: Cant see anything on |
| [jordanbaird/Ice #920](https://github.com/jordanbaird/Ice/issues/920) | 其他反馈 | I have searched existing issues for similar reports |
| [jordanbaird/Ice #954](https://github.com/jordanbaird/Ice/issues/954) | 故障报告 | [Bug]: Ice in menu bar not working anymore (MacOS Golden Gate 27) |
| [jordanbaird/Ice #957](https://github.com/jordanbaird/Ice/issues/957) | 故障报告 | [Bug]: Starts but nothing much more |
| [jordanbaird/Ice #991](https://github.com/jordanbaird/Ice/issues/991) | 故障报告 | [Bug]: MacOS 27 Update |
