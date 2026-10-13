# 上游待处理 Issues 原文清单

原始采集时间：2026-10-13T14:04:27+08:00（Asia/Shanghai）。本地代码审计时间：2026-10-13T15:17:39+08:00。

原始采集范围为两个上游仓库的全部 open issues（排除 pull requests）。原始共 402 条；现已排除 Floe 中已修复或需求已满足的 22 条，保留 **380** 条。此文件是本项目的待处理清单，不再等同于上游实时 open issues 总数。

删除依据与验证边界见 [修复核对记录](upstream-issue-fix-audit.md)。仅清理本地文档，未关闭或修改 GitHub 上的 issue。

## 数量与来源

| 仓库 | 原始 open 数量 | 本次删除 | 当前保留 | 来源 |
| --- | ---: | ---: | ---: | --- |
| cavaldos/Ice | 5 | 1 | 4 | [GitHub Issues](https://github.com/cavaldos/Ice/issues?q=is%3Aissue%20is%3Aopen) |
| jordanbaird/Ice | 397 | 21 | 376 | [GitHub Issues](https://github.com/jordanbaird/Ice/issues?q=is%3Aissue%20is%3Aopen) |

其余每条独立保留，不合并疑似重复问题。标题与正文原样保存于代码块；附件链接保留，但未下载附件、识别图片或转录视频。空正文明确标注；不包含评论区。

机器可读保留数据：[upstream-open-issues.snapshot.json](upstream-open-issues.snapshot.json)。分类与分析见 [upstream-open-issues-summary.md](upstream-open-issues-summary.md)。

## cavaldos/Ice

| 编号 | 标题原文 | 主分类 |
| --- | --- | --- |
| [#5](https://github.com/cavaldos/Ice/issues/5) | [Bug]: issue on second screen in clamshell mode | 显示器、分辨率与刘海适配 |
| [#9](https://github.com/cavaldos/Ice/issues/9) | [Bug]: Nothing is being shown on "Menu Bar Layout" in settings | 布局编辑、图标发现与搜索 |
| [#12](https://github.com/cavaldos/Ice/issues/12) | [Bug]: Collapse/Expand button in menu bar is not working | 触发、点击与自动隐藏 |
| [#24](https://github.com/cavaldos/Ice/issues/24) | [Bug]: Dropping icons to hide has no effect | 分区、排序与状态持久化 |

### cavaldos/Ice #5

- 链接：https://github.com/cavaldos/Ice/issues/5
- 作者：[aroom](https://github.com/aroom)
- 状态：open
- 创建时间：2026-09-16T11:54:57Z（UTC）
- 更新时间：2026-09-18T15:29:28Z（UTC）
- 标签：bug
- 评论数：10（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: issue on second screen in clamshell mode
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

all the icons are visible when on an external screen

### Steps to Reproduce

1. connect an external screen
2. close the laptop
3. check the menu bar

### App Version

0.11.18

### macOS Version

27

### Additional Information

_No response_
```

### cavaldos/Ice #9

- 链接：https://github.com/cavaldos/Ice/issues/9
- 作者：[nycoagung](https://github.com/nycoagung)
- 状态：open
- 创建时间：2026-09-17T03:55:48Z（UTC）
- 更新时间：2026-10-02T21:01:43Z（UTC）
- 标签：无
- 评论数：12（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Nothing is being shown on "Menu Bar Layout" in settings
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Unable to move items to "Always-Hidden Section" nor to "Hidden Section".
No item is shown in "Menu Bar Layout".

Both permissions have already been granted.

### Steps to Reproduce

1. Launch app
2. Open Menu Bar Layout
3. Nothing is shown in the 3 sections

### App Version

0.11.20

### macOS Version

27.0

### Additional Information

<img width="896" height="625" alt="Image" src="https://github.com/user-attachments/assets/9d3070af-7b82-4186-89ba-33a4c980ba84" />

<img width="862" height="29" alt="Image" src="https://github.com/user-attachments/assets/bed75725-3a8b-4aaa-bdd7-a5d63533ad5c" />

<img width="824" height="31" alt="Image" src="https://github.com/user-attachments/assets/b1dd8050-187a-4a24-b3f1-a9f8fcbcd6cf" />
```

### cavaldos/Ice #12

- 链接：https://github.com/cavaldos/Ice/issues/12
- 作者：[ldngoc-misa](https://github.com/ldngoc-misa)
- 状态：open
- 创建时间：2026-09-17T06:01:39Z（UTC）
- 更新时间：2026-10-11T05:57:57Z（UTC）
- 标签：无
- 评论数：8（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Collapse/Expand button in menu bar is not working
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Collapse/Expand button in menu bar is not working

### Steps to Reproduce

1. Click in Ice button
2. Items are not expand/collapse (always expanded)

### App Version

1.11.22

### macOS Version

27.0

### Additional Information

<!-- Failed to upload "Screen Recording 2026-09-17 at 12.55.20.mov" -->

<!-- Failed to upload "Screen Recording 2026-09-17 at 12.55.20.mov" -->

<!-- Failed to upload "Screen Recording 2026-09-17 at 12.55.20.mov" -->

<!-- Failed to upload "Screen Recording 2026-09-17 at 12.55.20.mov" -->

<!-- Failed to upload "Screen Recording 2026-09-17 at 12.55.20.mov" -->

<!-- Failed to upload "Screen Recording 2026-09-17 at 12.55.20.mov" -->

https://github.com/user-attachments/assets/2eb0ccf0-a6fd-4550-a8dd-fa081f8afb7c
```

### cavaldos/Ice #24

- 链接：https://github.com/cavaldos/Ice/issues/24
- 作者：[pzelnip](https://github.com/pzelnip)
- 状态：open
- 创建时间：2026-10-04T21:38:42Z（UTC）
- 更新时间：2026-10-12T02:29:30Z（UTC）
- 标签：无
- 评论数：3（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Dropping icons to hide has no effect
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When I pull an icon down to the hide list, it disappears from the source list for a second (remains in the menubar) and then re-appears in the Visible list.

Screencap showing this: https://cdn.zappy.app/v1cc80ccaef538ca26a0267e93a1748e2.mp4

### Steps to Reproduce

1. Open settings
2. Go to Menu Bar Layout
3. Drag icon from Visible to hidden

Wait a sec and it moves back to the Visible list, and nothing is hidden from the menubar.

### App Version

0.11.29

### macOS Version

27.0.1 (26A434)

### Additional Information

https://cdn.zappy.app/v1cc80ccaef538ca26a0267e93a1748e2.mp4
```

## jordanbaird/Ice

| 编号 | 标题原文 | 主分类 |
| --- | --- | --- |
| [#6](https://github.com/jordanbaird/Ice/issues/6) | [Feature Request] Change the location where new menu bar icons come up. | 分区、排序与状态持久化 |
| [#26](https://github.com/jordanbaird/Ice/issues/26) | [Feature request] Profiles for menubar layout | 布局编辑、图标发现与搜索 |
| [#46](https://github.com/jordanbaird/Ice/issues/46) | [Feature Request]: Menubar groups | 分区、排序与状态持久化 |
| [#53](https://github.com/jordanbaird/Ice/issues/53) | [Bug]: Any change in monitors while Mac is asleep removes styling | 显示器、分辨率与刘海适配 |
| [#58](https://github.com/jordanbaird/Ice/issues/58) | [Bug]: Menu Bar Flashes | 菜单栏外观与渲染 |
| [#62](https://github.com/jordanbaird/Ice/issues/62) | [Feature Request]: Show menu bar items when trigger condition are met | 触发、点击与自动隐藏 |
| [#73](https://github.com/jordanbaird/Ice/issues/73) | [Feature Request]: Defer recommended payment until once installed | 权限、更新、安装与分发 |
| [#83](https://github.com/jordanbaird/Ice/issues/83) | [Feature Request]: Organize apps by keyboard shortcuts or in preferences pane | 快捷键、自动化与配置能力 |
| [#91](https://github.com/jordanbaird/Ice/issues/91) | [Feature Request]: Spacers | 分区、排序与状态持久化 |
| [#94](https://github.com/jordanbaird/Ice/issues/94) | [Bug]: Icons not hidden in ultra wide screen | 显示器、分辨率与刘海适配 |
| [#95](https://github.com/jordanbaird/Ice/issues/95) | [Feature Request]: Cross-Device Syncing | 快捷键、自动化与配置能力 |
| [#113](https://github.com/jordanbaird/Ice/issues/113) | [Feature Request]: Scroll again to toggle always-hidden section | 触发、点击与自动隐藏 |
| [#141](https://github.com/jordanbaird/Ice/issues/141) | [Feature Request]: x-callback-url for automation | 快捷键、自动化与配置能力 |
| [#144](https://github.com/jordanbaird/Ice/issues/144) | [Bug]: Doing opt click after click does not hide app menus | 触发、点击与自动隐藏 |
| [#148](https://github.com/jordanbaird/Ice/issues/148) | [Feature Request]: Custom trigger API for applications to implement | 快捷键、自动化与配置能力 |
| [#186](https://github.com/jordanbaird/Ice/issues/186) | [Feature Request]: Support GIFs as Ice icon | 菜单栏外观与渲染 |
| [#188](https://github.com/jordanbaird/Ice/issues/188) | [Feature Request]: Option to only hide on built-in display | 显示器、分辨率与刘海适配 |
| [#194](https://github.com/jordanbaird/Ice/issues/194) | [Bug]: Offscreen items are dimmed in interface after being moved | 分区、排序与状态持久化 |
| [#201](https://github.com/jordanbaird/Ice/issues/201) | [Bug]: Can't arrange or display menu bar items when the menu bar is automatically hidden | 显示器、分辨率与刘海适配 |
| [#208](https://github.com/jordanbaird/Ice/issues/208) | Feature Request: Adding Ice Bar as an additional layout under Menu Bar Items | Ice Bar 功能与交互 |
| [#209](https://github.com/jordanbaird/Ice/issues/209) | [Feature Request]: Arrange items directly inside Ice Bar | 分区、排序与状态持久化 |
| [#210](https://github.com/jordanbaird/Ice/issues/210) | [Feature Request]: Option to update to beta releases | 权限、更新、安装与分发 |
| [#211](https://github.com/jordanbaird/Ice/issues/211) | [Bug]: Ice Bar shows incorrect item images when moved to another screen | 分区、排序与状态持久化 |
| [#212](https://github.com/jordanbaird/Ice/issues/212) | [Bug]: Ice Bar doesn't reliably change color when activated on a new desktop | 菜单栏外观与渲染 |
| [#214](https://github.com/jordanbaird/Ice/issues/214) | [Feature Request]: Ability to pin Ice Bar | Ice Bar 功能与交互 |
| [#216](https://github.com/jordanbaird/Ice/issues/216) | [Bug]: Menu bar appearance shows above Mission Control after deleting a space | 菜单栏外观与渲染 |
| [#223](https://github.com/jordanbaird/Ice/issues/223) | [Feature Request]: Ability to enable Ice Bar only when on built-in display | 显示器、分辨率与刘海适配 |
| [#227](https://github.com/jordanbaird/Ice/issues/227) | [Feature Request]: Use Ice Bar as overflow spot for otherwise-hidden menu items | Ice Bar 功能与交互 |
| [#233](https://github.com/jordanbaird/Ice/issues/233) | [Bug]:  Re-arranging/dragging  items  in the "Hidden" settings pane makes them disappear  | 分区、排序与状态持久化 |
| [#234](https://github.com/jordanbaird/Ice/issues/234) | [Bug]: Rapidly switching spaces breaks Ice Bar item display | 显示器、分辨率与刘海适配 |
| [#239](https://github.com/jordanbaird/Ice/issues/239) | [Bug]: Some menu bar clip issue while using Menu bar split shape  | 菜单栏外观与渲染 |
| [#240](https://github.com/jordanbaird/Ice/issues/240) | [Feature Request]: Showing hidden items replaces visible items | 分区、排序与状态持久化 |
| [#241](https://github.com/jordanbaird/Ice/issues/241) | [Bug]: Gap in menu bar items on inactive display when showing hidden section | 显示器、分辨率与刘海适配 |
| [#242](https://github.com/jordanbaird/Ice/issues/242) | [Feature Request]: Ability to have unique menubars for each display | 显示器、分辨率与刘海适配 |
| [#243](https://github.com/jordanbaird/Ice/issues/243) | [Feature Request]: Menu Bar Widget Ideas | Ice Bar 功能与交互 |
| [#244](https://github.com/jordanbaird/Ice/issues/244) | [Bug]: App shows up in non-hidden bar even after hidden | 触发、点击与自动隐藏 |
| [#245](https://github.com/jordanbaird/Ice/issues/245) | [Feature Request]: Allow setting SF Symbols for when the icon is toggled | 菜单栏外观与渲染 |
| [#246](https://github.com/jordanbaird/Ice/issues/246) | [Bug]: Ice doesn't open its settings when double clicking its app icon on macOS 15 | 触发、点击与自动隐藏 |
| [#252](https://github.com/jordanbaird/Ice/issues/252) | [Feature Request]: RTL support  | 菜单栏外观与渲染 |
| [#254](https://github.com/jordanbaird/Ice/issues/254) | [Bug]: Transparent items in Ice Bar while in fullscreen mode | Ice Bar 功能与交互 |
| [#260](https://github.com/jordanbaird/Ice/issues/260) | [Bug]: Both inset menu bar shape and Ice Bar are too short on notched display when set to a lower resolution | 显示器、分辨率与刘海适配 |
| [#272](https://github.com/jordanbaird/Ice/issues/272) | [Bug]: Extra spaces in iPad sidecar. | 显示器、分辨率与刘海适配 |
| [#273](https://github.com/jordanbaird/Ice/issues/273) | [Feature Request]: Custom refresh rate for menu bar item images | 菜单栏外观与渲染 |
| [#283](https://github.com/jordanbaird/Ice/issues/283) | [Bug]: Ice's view of the menu bar is missing the icon for AltTab | 布局编辑、图标发现与搜索 |
| [#286](https://github.com/jordanbaird/Ice/issues/286) | [Bug]: Show on click/scroll not working on non-fullscreen, auto-hidden menu bar | 触发、点击与自动隐藏 |
| [#291](https://github.com/jordanbaird/Ice/issues/291) | [Feature Request]: Hotkeys for individual menu bar items | 快捷键、自动化与配置能力 |
| [#299](https://github.com/jordanbaird/Ice/issues/299) | [Feature Request]: Always show hidden items if monitor screen is larger than <enter resolution> | 显示器、分辨率与刘海适配 |
| [#300](https://github.com/jordanbaird/Ice/issues/300) | [Bug]: Rearranging icons with multiple instances of OneDrive | 第三方应用与系统项目兼容 |
| [#303](https://github.com/jordanbaird/Ice/issues/303) | [Feature Request]: Use Ice Bar only when screen size is smaller than <enter resolution> | 显示器、分辨率与刘海适配 |
| [#310](https://github.com/jordanbaird/Ice/issues/310) | [Feature Request]: Allow a section to be hidable to show what's on the left | 分区、排序与状态持久化 |
| [#312](https://github.com/jordanbaird/Ice/issues/312) | [Bug]: No items in Menu Bar | 布局编辑、图标发现与搜索 |
| [#316](https://github.com/jordanbaird/Ice/issues/316) | [Bug]: Items rehidden after selecting "Show the Hidden Section" in Ice icon menu with "Show on hover" setting enabled | 触发、点击与自动隐藏 |
| [#321](https://github.com/jordanbaird/Ice/issues/321) | [Feature Request]: Animation when showing items | 触发、点击与自动隐藏 |
| [#326](https://github.com/jordanbaird/Ice/issues/326) | [Feature Request]: Custom configuration path / export settings | 快捷键、自动化与配置能力 |
| [#329](https://github.com/jordanbaird/Ice/issues/329) | [Bug]: When turning off "Show ice icon" and the turning it back on, the icon doesn't automatically repopulate | 崩溃、冻结与资源消耗 |
| [#330](https://github.com/jordanbaird/Ice/issues/330) | [Bug]: Can not work with Focus Menu Bar Item (https://heyfocus.com) | 第三方应用与系统项目兼容 |
| [#331](https://github.com/jordanbaird/Ice/issues/331) | [Bug]: Hidden icons cannot be displayed when menu bar automatically hidden while in full screen | 显示器、分辨率与刘海适配 |
| [#334](https://github.com/jordanbaird/Ice/issues/334) | [Bug]: Ice has noticeable energy impact during mouse movement | 崩溃、冻结与资源消耗 |
| [#335](https://github.com/jordanbaird/Ice/issues/335) | [Feature Request]: Ice Bar only for Always Hidden | Ice Bar 功能与交互 |
| [#336](https://github.com/jordanbaird/Ice/issues/336) | [Bug]: Split Type Ice Bar keeps the wallpaper from the previous space when switching spaces/screens | 菜单栏外观与渲染 |
| [#337](https://github.com/jordanbaird/Ice/issues/337) | [Bug]: Menu bar appearance uses wallpaper from previous space when swiping through spaces in Mission Control | 菜单栏外观与渲染 |
| [#340](https://github.com/jordanbaird/Ice/issues/340) | [Feature Request]: Show ice bar next to mouse in any screen location with keyboard shortcut | 显示器、分辨率与刘海适配 |
| [#342](https://github.com/jordanbaird/Ice/issues/342) | [Feature Request]: Display menu bar items as a vertical list | 显示器、分辨率与刘海适配 |
| [#344](https://github.com/jordanbaird/Ice/issues/344) | [Bug]: Menu bar items move to hidden or always hidden section | 分区、排序与状态持久化 |
| [#359](https://github.com/jordanbaird/Ice/issues/359) | [Bug]: Menubars are not correct with external display on MacBook Pro | 显示器、分辨率与刘海适配 |
| [#368](https://github.com/jordanbaird/Ice/issues/368) | [Feature Request]: Menu Bar Appearance for Hidden Sections | 菜单栏外观与渲染 |
| [#372](https://github.com/jordanbaird/Ice/issues/372) | [Feature Request]: Ability to see both hidden sections at the same time when using the Ice Bar | Ice Bar 功能与交互 |
| [#378](https://github.com/jordanbaird/Ice/issues/378) | [Feature Request]: Show all menu bar items as default | 触发、点击与自动隐藏 |
| [#380](https://github.com/jordanbaird/Ice/issues/380) | [Feature Request]: Can we send shadow to back? | 菜单栏外观与渲染 |
| [#382](https://github.com/jordanbaird/Ice/issues/382) | [Feature Request]: Add AppleScript or CLI support | 快捷键、自动化与配置能力 |
| [#383](https://github.com/jordanbaird/Ice/issues/383) | [Bug]: Disabling displays have separate spaces not working | 显示器、分辨率与刘海适配 |
| [#397](https://github.com/jordanbaird/Ice/issues/397) | [Bug]: Dock icon appears when using Always hidden feature. | 触发、点击与自动隐藏 |
| [#401](https://github.com/jordanbaird/Ice/issues/401) | [Bug]: Ice Bar appears and will not disappear when using "Show on hover" with a delay set to 0 | 分区、排序与状态持久化 |
| [#403](https://github.com/jordanbaird/Ice/issues/403) | [Bug]: Make smart mode smarter: Don't collapse the menu bar icons when toggling switches of switch app | 触发、点击与自动隐藏 |
| [#404](https://github.com/jordanbaird/Ice/issues/404) | [Bug]: OneDrive changes from "Hidden" to "Visible" on click | 第三方应用与系统项目兼容 |
| [#406](https://github.com/jordanbaird/Ice/issues/406) | [Feature Request]: Allow clicks inside the notch | 显示器、分辨率与刘海适配 |
| [#409](https://github.com/jordanbaird/Ice/issues/409) | [Bug]: macOS Sequoia requires a restart of Ice to render the menubar border | 菜单栏外观与渲染 |
| [#416](https://github.com/jordanbaird/Ice/issues/416) | [Bug]: menubar icons disappear when active app menus extend to the right | 分区、排序与状态持久化 |
| [#434](https://github.com/jordanbaird/Ice/issues/434) | [Bug]: Hide Application Menus doesn't unless Enable always-hidden section is toggled on | 触发、点击与自动隐藏 |
| [#435](https://github.com/jordanbaird/Ice/issues/435) | [Bug]: Glitch when toggle dock | 菜单栏外观与渲染 |
| [#440](https://github.com/jordanbaird/Ice/issues/440) | [Bug]: The Shazam (music recognition) icon is invisible all the time | 第三方应用与系统项目兼容 |
| [#445](https://github.com/jordanbaird/Ice/issues/445) | Menu bar in middle of screen | 显示器、分辨率与刘海适配 |
| [#451](https://github.com/jordanbaird/Ice/issues/451) | [Bug]: Unexpected behavior after swiping between desktop and full screen apps | 菜单栏外观与渲染 |
| [#452](https://github.com/jordanbaird/Ice/issues/452) | [Bug]: Automatically rehide takes affect even when inside a hidden items menu options | 触发、点击与自动隐藏 |
| [#456](https://github.com/jordanbaird/Ice/issues/456) | [Bug]: Ice interferes with right-click on title bar on display where menu bar is not displayed | 显示器、分辨率与刘海适配 |
| [#462](https://github.com/jordanbaird/Ice/issues/462) | Keyboard Maestro will not move from hidden to visible | 第三方应用与系统项目兼容 |
| [#463](https://github.com/jordanbaird/Ice/issues/463) | [Feature Request]: Make the "Use Ice Bar" toggle dynamic | 触发、点击与自动隐藏 |
| [#467](https://github.com/jordanbaird/Ice/issues/467) | [Bug]: 1Password menu item weirdness | 第三方应用与系统项目兼容 |
| [#468](https://github.com/jordanbaird/Ice/issues/468) | [Feature Request]: Disable / Customize Menu Bar Appearance in Full Screen Mode | 菜单栏外观与渲染 |
| [#472](https://github.com/jordanbaird/Ice/issues/472) | [Bug]: Menu bar item spacing not applying correctly | 菜单栏外观与渲染 |
| [#479](https://github.com/jordanbaird/Ice/issues/479) | [Bug]: Energy impact | 崩溃、冻结与资源消耗 |
| [#480](https://github.com/jordanbaird/Ice/issues/480) | [Bug]: Interaction with Alcove | 第三方应用与系统项目兼容 |
| [#481](https://github.com/jordanbaird/Ice/issues/481) | [Feature Request]: Option to enable showing hidden section when hovering over un-hidden side | 触发、点击与自动隐藏 |
| [#482](https://github.com/jordanbaird/Ice/issues/482) | [Feature Request]: Better appearance for rounded menu bar | 菜单栏外观与渲染 |
| [#485](https://github.com/jordanbaird/Ice/issues/485) | [Bug]: Cannot show any menu bar items in hidden section | 触发、点击与自动隐藏 |
| [#486](https://github.com/jordanbaird/Ice/issues/486) | Zoomed-in part of the screen sometimes jumps around when macOS Display Zoom is active (while running Ice) | 显示器、分辨率与刘海适配 |
| [#487](https://github.com/jordanbaird/Ice/issues/487) | [Feature Request]: Always Hidden Use Ice Bar | Ice Bar 功能与交互 |
| [#494](https://github.com/jordanbaird/Ice/issues/494) | [Feature Request]: Make option for showing hidden items on mouse down, not up | 触发、点击与自动隐藏 |
| [#495](https://github.com/jordanbaird/Ice/issues/495) | [Feature Request]: Organize hidden icons into multiple rows | Ice Bar 功能与交互 |
| [#497](https://github.com/jordanbaird/Ice/issues/497) | [Feature Request]: Open 'Menu Bar Layout' from Right-Click | 布局编辑、图标发现与搜索 |
| [#501](https://github.com/jordanbaird/Ice/issues/501) | [Feature Request]: Raycast Integration | 快捷键、自动化与配置能力 |
| [#510](https://github.com/jordanbaird/Ice/issues/510) | [Bug]: Split bar doesn't reach top of scren | 菜单栏外观与渲染 |
| [#512](https://github.com/jordanbaird/Ice/issues/512) | [Bug]: Lack of sync among windows | 分区、排序与状态持久化 |
| [#513](https://github.com/jordanbaird/Ice/issues/513) | [Bug]: Hidden icons end up in the Visible section after some interactions | 分区、排序与状态持久化 |
| [#514](https://github.com/jordanbaird/Ice/issues/514) | [Bug]: Menu bar shadow issue with single application window | 菜单栏外观与渲染 |
| [#515](https://github.com/jordanbaird/Ice/issues/515) | [Feature Request]: Scrolling through menu bar items | 触发、点击与自动隐藏 |
| [#516](https://github.com/jordanbaird/Ice/issues/516) | [Feature Request]: Expose API for searching menu bar items for Launchbar/Alfred/Spotlight/etc | 布局编辑、图标发现与搜索 |
| [#517](https://github.com/jordanbaird/Ice/issues/517) | [Bug]:Bar in the middle of the screen | 显示器、分辨率与刘海适配 |
| [#518](https://github.com/jordanbaird/Ice/issues/518) | [Feature Request]: Configuration option to Always open Ice as minimized | Ice Bar 功能与交互 |
| [#519](https://github.com/jordanbaird/Ice/issues/519) | [Feature Request]: Ability to show all icons in click menu | 触发、点击与自动隐藏 |
| [#521](https://github.com/jordanbaird/Ice/issues/521) | [Bug]: Background visible when entering fullscreen on video. or other application | 菜单栏外观与渲染 |
| [#525](https://github.com/jordanbaird/Ice/issues/525) | [Bug]: split menu bar and related effects seemingly disabled in macOS 15.3.2 | 菜单栏外观与渲染 |
| [#526](https://github.com/jordanbaird/Ice/issues/526) | [Bug]: Ice Causing issues with the behaviour of the Motioncontrol Light app. The brights slider keeps disappearing when trying to adjust screen brightness | 第三方应用与系统项目兼容 |
| [#527](https://github.com/jordanbaird/Ice/issues/527) | [Feature Request]: Allow pinning bar location with hidden ice icon | Ice Bar 功能与交互 |
| [#529](https://github.com/jordanbaird/Ice/issues/529) | [Bug]: The right bar is longer than expected on ultrawide screen | 显示器、分辨率与刘海适配 |
| [#530](https://github.com/jordanbaird/Ice/issues/530) | [Bug]: high memory usage | 崩溃、冻结与资源消耗 |
| [#533](https://github.com/jordanbaird/Ice/issues/533) | [Feature Request]: Make menu bar appear floating versus docked to top of screen | 触发、点击与自动隐藏 |
| [#538](https://github.com/jordanbaird/Ice/issues/538) | [Feature Request]: Round corners of clicked menu bar items | 菜单栏外观与渲染 |
| [#541](https://github.com/jordanbaird/Ice/issues/541) | [Bug]: Split view broke with extended screens | 菜单栏外观与渲染 |
| [#544](https://github.com/jordanbaird/Ice/issues/544) | [Feature Request]: Disable in full screen mode | 触发、点击与自动隐藏 |
| [#545](https://github.com/jordanbaird/Ice/issues/545) | [Bug]: ice bar sometimes doesn't show anything | Ice Bar 功能与交互 |
| [#550](https://github.com/jordanbaird/Ice/issues/550) | [Bug]: <bug title>With VMWare + Windows 11, ICE shows menu bar in the middle of an external monitor | 显示器、分辨率与刘海适配 |
| [#551](https://github.com/jordanbaird/Ice/issues/551) | [Feature Request]: Grid option when using Ice bar | Ice Bar 功能与交互 |
| [#552](https://github.com/jordanbaird/Ice/issues/552) | [Feature Request]: Option for Double click on ice icon in menu bar to show always hidden menu icons instead of settings | 触发、点击与自动隐藏 |
| [#554](https://github.com/jordanbaird/Ice/issues/554) | [Feature Request]: Show menu bar item name on hover | 触发、点击与自动隐藏 |
| [#555](https://github.com/jordanbaird/Ice/issues/555) | [Feature Request]: <Disable / alt settings with external monitor> | 显示器、分辨率与刘海适配 |
| [#560](https://github.com/jordanbaird/Ice/issues/560) | [Feature Request]: Automatically sort menu bar items in hidden section by name | 分区、排序与状态持久化 |
| [#563](https://github.com/jordanbaird/Ice/issues/563) | [Bug]: Ice occasionally crashes. | 崩溃、冻结与资源消耗 |
| [#566](https://github.com/jordanbaird/Ice/issues/566) | [Feature Request]: Hide/unhide using custom application whitelist | 分区、排序与状态持久化 |
| [#567](https://github.com/jordanbaird/Ice/issues/567) | [Bug]: Clicking on the menus in some apps triggers Ice | 触发、点击与自动隐藏 |
| [#570](https://github.com/jordanbaird/Ice/issues/570) | [Feature Request]: When bar items pass through the notch | 显示器、分辨率与刘海适配 |
| [#573](https://github.com/jordanbaird/Ice/issues/573) | [Bug]: Widescreen Monitors Hidden Menu Always Visible | 显示器、分辨率与刘海适配 |
| [#576](https://github.com/jordanbaird/Ice/issues/576) | [Bug]: <UI Bar Appearing on Main Display When Playing Fullscreen Video on Extended Display> | 显示器、分辨率与刘海适配 |
| [#578](https://github.com/jordanbaird/Ice/issues/578) | [Bug]: High CPU usage | 崩溃、冻结与资源消耗 |
| [#584](https://github.com/jordanbaird/Ice/issues/584) | [Bug]: macOS 26 application menu change to ice empty menu when clicking on empty space on menu bar to expand collapse items | 触发、点击与自动隐藏 |
| [#586](https://github.com/jordanbaird/Ice/issues/586) | [Bug]: protonvpn app icon presses itself when it hides itself after being opened from ice bar | 第三方应用与系统项目兼容 |
| [#589](https://github.com/jordanbaird/Ice/issues/589) | [Bug]: Menu items disappear when there is no room left | 分区、排序与状态持久化 |
| [#590](https://github.com/jordanbaird/Ice/issues/590) | App duplicates itself in dock on Tahoe | 第三方应用与系统项目兼容 |
| [#595](https://github.com/jordanbaird/Ice/issues/595) | [Bug]: Option-click should expand even when enable always-hidden section is turned off | 触发、点击与自动隐藏 |
| [#600](https://github.com/jordanbaird/Ice/issues/600) | [Feature Request]: Open hidden items from the Ice Icon | 触发、点击与自动隐藏 |
| [#601](https://github.com/jordanbaird/Ice/issues/601) | [Feature Request]: Documentation for hidden and always hidden behavior | 本地化、文档与项目维护 |
| [#603](https://github.com/jordanbaird/Ice/issues/603) | [Bug]: App launches, then immediately crashes, on macOS Tahoe Beta 3 | 崩溃、冻结与资源消耗 |
| [#604](https://github.com/jordanbaird/Ice/issues/604) | [Feature Request]: Disable functionality behind notch | 显示器、分辨率与刘海适配 |
| [#606](https://github.com/jordanbaird/Ice/issues/606) | [Bug]: Ice bar does't leaves artefact behind when auto-hiding in full screen | 菜单栏外观与渲染 |
| [#608](https://github.com/jordanbaird/Ice/issues/608) | [Bug]: Split menu bar holds onto a large amount of blank space to the | 菜单栏外观与渲染 |
| [#609](https://github.com/jordanbaird/Ice/issues/609) | Random bar in the middle of the screen | 显示器、分辨率与刘海适配 |
| [#617](https://github.com/jordanbaird/Ice/issues/617) | [Feature Request]: Auto-Sort behavior for "Unrecognized" Apps | 布局编辑、图标发现与搜索 |
| [#619](https://github.com/jordanbaird/Ice/issues/619) | [Bug]: Unable to Restore Menu Item After Removing Duplicate Chevron Icon | 第三方应用与系统项目兼容 |
| [#620](https://github.com/jordanbaird/Ice/issues/620) | [Bug]:Hide application menus when showing menu bar items | 触发、点击与自动隐藏 |
| [#621](https://github.com/jordanbaird/Ice/issues/621) | [Bug]: Can't fully interact with hidden menu items | 触发、点击与自动隐藏 |
| [#623](https://github.com/jordanbaird/Ice/issues/623) | [Bug]:Icons in MenuBar Layout page Disappear After Using ICE Bar in Full-Screen Mode | 布局编辑、图标发现与搜索 |
| [#625](https://github.com/jordanbaird/Ice/issues/625) | [Bug]: Oversize hidden bar | Ice Bar 功能与交互 |
| [#627](https://github.com/jordanbaird/Ice/issues/627) | [Bug]: Menu bar appearance not being displayed | 显示器、分辨率与刘海适配 |
| [#630](https://github.com/jordanbaird/Ice/issues/630) | [Feature Request]: Ice Bar under when I'm on one screen. | Ice Bar 功能与交互 |
| [#633](https://github.com/jordanbaird/Ice/issues/633) | [Bug]:macOS Tahoe 26中ice无法正常使用 | 系统升级兼容与待澄清反馈 |
| [#634](https://github.com/jordanbaird/Ice/issues/634) | [Bug]: Option-Click does not work if Show on Click is disabled | 触发、点击与自动隐藏 |
| [#635](https://github.com/jordanbaird/Ice/issues/635) | Weird behavior under Tahoe MacOS 26 Public Beta 2 | Ice Bar 功能与交互 |
| [#636](https://github.com/jordanbaird/Ice/issues/636) | [Bug]: <bug title> Shows weird bar when connected to monitor | 显示器、分辨率与刘海适配 |
| [#638](https://github.com/jordanbaird/Ice/issues/638) | Can it support the multilingual version? | 本地化、文档与项目维护 |
| [#639](https://github.com/jordanbaird/Ice/issues/639) | [Bug]: Menu bar on multiple displays | 显示器、分辨率与刘海适配 |
| [#640](https://github.com/jordanbaird/Ice/issues/640) | [Bug]: Strange Mouse Behavior After Clicking Hidden Icon | 触发、点击与自动隐藏 |
| [#641](https://github.com/jordanbaird/Ice/issues/641) | [Feature Request]: Support Ctrl+N and Ctrl+P to navigate down and up in the  menu bar items list | 快捷键、自动化与配置能力 |
| [#642](https://github.com/jordanbaird/Ice/issues/642) | [Bug]: Clicking on BusyCal Menu in hidden section opened Apple Menu instead | 第三方应用与系统项目兼容 |
| [#643](https://github.com/jordanbaird/Ice/issues/643) | [Bug]: Completely lost Stats app when dragging into Menu Bar Layout section | 布局编辑、图标发现与搜索 |
| [#644](https://github.com/jordanbaird/Ice/issues/644) | [Bug]: <Option-Click works randomly> | 触发、点击与自动隐藏 |
| [#645](https://github.com/jordanbaird/Ice/issues/645) | [Bug]: menubar periodical glitch every 'x' minutes | 菜单栏外观与渲染 |
| [#646](https://github.com/jordanbaird/Ice/issues/646) | [Bug]: Clickable area to activate Ice extends beyond menu bar to blank area of 2nd monitor. | 显示器、分辨率与刘海适配 |
| [#647](https://github.com/jordanbaird/Ice/issues/647) | [Bug]: <MacOS Tahoe app craches> | 崩溃、冻结与资源消耗 |
| [#649](https://github.com/jordanbaird/Ice/issues/649) | [Bug]: split menu bar weird behavior when showing the desktop | 菜单栏外观与渲染 |
| [#651](https://github.com/jordanbaird/Ice/issues/651) | [Feature Request]: Allow the tint option to affect the menubar background only and add transparency slider to colour swatch(es) | 菜单栏外观与渲染 |
| [#655](https://github.com/jordanbaird/Ice/issues/655) | [Bug]: ICE - Some Apps icons not appearing in the Menu Bar Layout setting | 布局编辑、图标发现与搜索 |
| [#656](https://github.com/jordanbaird/Ice/issues/656) | [Bug]: <macOS Tahoe> Cannot move live activities across sections | 第三方应用与系统项目兼容 |
| [#657](https://github.com/jordanbaird/Ice/issues/657) | [Bug]: the Menu Bar's height with "Shape kind = full" is a few pixels too short on second monitor | 显示器、分辨率与刘海适配 |
| [#658](https://github.com/jordanbaird/Ice/issues/658) | [Bug]: <Getting focused out while playing league> | 第三方应用与系统项目兼容 |
| [#659](https://github.com/jordanbaird/Ice/issues/659) | [Bug]: <MacOS Tahoe> the bar appearance shows a slight shadow on top on the screen | 菜单栏外观与渲染 |
| [#661](https://github.com/jordanbaird/Ice/issues/661) | [Bug]: When visible section application is updated, it will go to hidden section. | 分区、排序与状态持久化 |
| [#664](https://github.com/jordanbaird/Ice/issues/664) | [Bug]: MacOS Tahoe Breaks Menu Bar Layout Editor | 布局编辑、图标发现与搜索 |
| [#665](https://github.com/jordanbaird/Ice/issues/665) | [Bug]: MacOS Tahoe Makes Ice Bar Invisible | Ice Bar 功能与交互 |
| [#666](https://github.com/jordanbaird/Ice/issues/666) | [Bug]: Items that change become hidden | 分区、排序与状态持久化 |
| [#668](https://github.com/jordanbaird/Ice/issues/668) | [Bug]: Search Items issues | 布局编辑、图标发现与搜索 |
| [#669](https://github.com/jordanbaird/Ice/issues/669) | [Bug]: <crashes on MACOS  26 tahoe 26> | 崩溃、冻结与资源消耗 |
| [#671](https://github.com/jordanbaird/Ice/issues/671) | [Bug]: unexpected closure | 崩溃、冻结与资源消耗 |
| [#673](https://github.com/jordanbaird/Ice/issues/673) | [Bug]: Search Not Working, Mac OS Tahoe | 布局编辑、图标发现与搜索 |
| [#675](https://github.com/jordanbaird/Ice/issues/675) | [Bug]: Always Hidden Icons Disappeared. | 分区、排序与状态持久化 |
| [#676](https://github.com/jordanbaird/Ice/issues/676) | [Bug]: Empty space on the left side of the right menu bar when split, MacOS Tahoe | 菜单栏外观与渲染 |
| [#677](https://github.com/jordanbaird/Ice/issues/677) | [Bug]: Ice bar do not work:endless loading menu bar items | 布局编辑、图标发现与搜索 |
| [#679](https://github.com/jordanbaird/Ice/issues/679) | [Bug]: "Unable to display menu bar items" on macOS Tahoe/Ice 0.11.13-dev.2 | 显示器、分辨率与刘海适配 |
| [#682](https://github.com/jordanbaird/Ice/issues/682) | [Bug]: <Menebar Layout Pane> | 布局编辑、图标发现与搜索 |
| [#683](https://github.com/jordanbaird/Ice/issues/683) | [Bug]: (Tahoe Beta) Hover affects across screens | 触发、点击与自动隐藏 |
| [#685](https://github.com/jordanbaird/Ice/issues/685) | Whitened sections in Menu Bar Layout | 布局编辑、图标发现与搜索 |
| [#686](https://github.com/jordanbaird/Ice/issues/686) | [Bug]: <bug title>Ice bar won't let me choose app | Ice Bar 功能与交互 |
| [#687](https://github.com/jordanbaird/Ice/issues/687) | [Bug]: Doesn't display menu bar layout | 显示器、分辨率与刘海适配 |
| [#691](https://github.com/jordanbaird/Ice/issues/691) | [Feature Request]: Allow unhide all when the display is larger | 显示器、分辨率与刘海适配 |
| [#694](https://github.com/jordanbaird/Ice/issues/694) | [Bug]: Once opened does not go back again | 触发、点击与自动隐藏 |
| [#695](https://github.com/jordanbaird/Ice/issues/695) | [Bug]: ICE window opens on ICE menubar click + at login | 触发、点击与自动隐藏 |
| [#696](https://github.com/jordanbaird/Ice/issues/696) | [Bug]: nothing showing up in the menu editing | 布局编辑、图标发现与搜索 |
| [#697](https://github.com/jordanbaird/Ice/issues/697) | [Bug]: Make Lungo/Dato work with Ice | 第三方应用与系统项目兼容 |
| [#698](https://github.com/jordanbaird/Ice/issues/698) | [Bug]: On Tahoe, Items appear different sizes across monitor and laptop screen | 显示器、分辨率与刘海适配 |
| [#701](https://github.com/jordanbaird/Ice/issues/701) | [Bug]: Volume UI hidden on change if menu bar icon is hidden | 第三方应用与系统项目兼容 |
| [#702](https://github.com/jordanbaird/Ice/issues/702) | [Bug]: Hidden items randomly moved to always hidden items | 分区、排序与状态持久化 |
| [#703](https://github.com/jordanbaird/Ice/issues/703) | [Feature Request]: Ice Bar only on Macs with a Notch | 显示器、分辨率与刘海适配 |
| [#704](https://github.com/jordanbaird/Ice/issues/704) | [Bug]: menu bar items (iphone notifications) cannot be moved | 第三方应用与系统项目兼容 |
| [#705](https://github.com/jordanbaird/Ice/issues/705) | [Feature Request]: Allow clear shape kind | 菜单栏外观与渲染 |
| [#707](https://github.com/jordanbaird/Ice/issues/707) | [Bug]: When using Cloudflare WARP with Ice, the WARP GUI is malfunctioning until iCE is restarted. | 第三方应用与系统项目兼容 |
| [#708](https://github.com/jordanbaird/Ice/issues/708) | [Bug]: Ice Bar and Show on Hover hovering area detection bug when system menu bar is on auto-hide mode | 第三方应用与系统项目兼容 |
| [#710](https://github.com/jordanbaird/Ice/issues/710) | [Bug]: Ice shows "Unable to display menu bar item" under macOS 26 Tahoe | 显示器、分辨率与刘海适配 |
| [#711](https://github.com/jordanbaird/Ice/issues/711) | [Bug]: "Unable to display menu bar items" \| macOS Tahoe Version 26.0 (25A354) \| Ice 0.11.13-dev.2 | 显示器、分辨率与刘海适配 |
| [#712](https://github.com/jordanbaird/Ice/issues/712) | [Feature Request]: Localize Ice | 本地化、文档与项目维护 |
| [#713](https://github.com/jordanbaird/Ice/issues/713) | [Feature Request]: Blacklist instead of whitelist strategy | 分区、排序与状态持久化 |
| [#714](https://github.com/jordanbaird/Ice/issues/714) | [Bug]: Show Ice bar on hover should not trigger in Mission Control view | 触发、点击与自动隐藏 |
| [#715](https://github.com/jordanbaird/Ice/issues/715) | [Bug]: If a system menu icon/text winds up in the notch area, it simply disappears! | 显示器、分辨率与刘海适配 |
| [#716](https://github.com/jordanbaird/Ice/issues/716) | [Bug]: Menu Bar Layout BLANK (can't see any icons) | 布局编辑、图标发现与搜索 |
| [#717](https://github.com/jordanbaird/Ice/issues/717) | [Bug]: Show on swipe works but not scroll | 触发、点击与自动隐藏 |
| [#718](https://github.com/jordanbaird/Ice/issues/718) | [Bug]: Cannot hide its icon when using game mode | 触发、点击与自动隐藏 |
| [#719](https://github.com/jordanbaird/Ice/issues/719) | [Bug]: Volume/brightness HUD not visible when Ice is running on macOS Tahoe | 第三方应用与系统项目兼容 |
| [#721](https://github.com/jordanbaird/Ice/issues/721) | [Bug]: Latest Tahoe Beta update gives Ice error, Ice freezes | 崩溃、冻结与资源消耗 |
| [#723](https://github.com/jordanbaird/Ice/issues/723) | [Bug]: Icons don’t stay at its place - they flip after restart (Sequoia & Tahoe) | 分区、排序与状态持久化 |
| [#724](https://github.com/jordanbaird/Ice/issues/724) | [Feature Request]: Hide Ice icon from dock | 触发、点击与自动隐藏 |
| [#725](https://github.com/jordanbaird/Ice/issues/725) | [Bug]: App icon opens on hover | 触发、点击与自动隐藏 |
| [#726](https://github.com/jordanbaird/Ice/issues/726) | [Feature Request]: Clicking on center of menu bar reveals the desktop | 触发、点击与自动隐藏 |
| [#727](https://github.com/jordanbaird/Ice/issues/727) | [Feature Request]: Bartender 3 mode | Ice Bar 功能与交互 |
| [#728](https://github.com/jordanbaird/Ice/issues/728) | [Bug]: Chevron separator is always shown | 触发、点击与自动隐藏 |
| [#729](https://github.com/jordanbaird/Ice/issues/729) | [Bug]: Menu Bar Item Stuck After Ice Bar Click When Live Activities are Active | 第三方应用与系统项目兼容 |
| [#730](https://github.com/jordanbaird/Ice/issues/730) | [Bug]: Menu bar layout in settings bug | 布局编辑、图标发现与搜索 |
| [#731](https://github.com/jordanbaird/Ice/issues/731) | [Feature Request]: Allow live activities to show | 第三方应用与系统项目兼容 |
| [#732](https://github.com/jordanbaird/Ice/issues/732) | [Bug]: Docker for Mac ends up in "Always-Hidden Section" over time | 第三方应用与系统项目兼容 |
| [#733](https://github.com/jordanbaird/Ice/issues/733) | [Bug]: Strange rendering issue | 菜单栏外观与渲染 |
| [#739](https://github.com/jordanbaird/Ice/issues/739) | [Bug]: No proper behaviour when multiple bar item of same app | 第三方应用与系统项目兼容 |
| [#740](https://github.com/jordanbaird/Ice/issues/740) | [Bug]: Crashes every time I use it | 崩溃、冻结与资源消耗 |
| [#741](https://github.com/jordanbaird/Ice/issues/741) | [Bug]: Apps gone from Ice Layout | 布局编辑、图标发现与搜索 |
| [#742](https://github.com/jordanbaird/Ice/issues/742) | [Bug]: I just installed Tahoe in my Mac and ICE is not working as it used to.  I am attaching the log report sent back form IOS.  Since the principal functionality that stopped work is to have the menu in a separate bar below the menu bar. | 崩溃、冻结与资源消耗 |
| [#743](https://github.com/jordanbaird/Ice/issues/743) | [Bug]: I cannot see any icons | 布局编辑、图标发现与搜索 |
| [#744](https://github.com/jordanbaird/Ice/issues/744) | [Bug]: Menu Bar Layout settings is empty | 布局编辑、图标发现与搜索 |
| [#745](https://github.com/jordanbaird/Ice/issues/745) | [Love]: Thank You For Ice! | 本地化、文档与项目维护 |
| [#746](https://github.com/jordanbaird/Ice/issues/746) | [Bug]: Event operation timed out | 崩溃、冻结与资源消耗 |
| [#748](https://github.com/jordanbaird/Ice/issues/748) | [Bug]: 1Password | 第三方应用与系统项目兼容 |
| [#750](https://github.com/jordanbaird/Ice/issues/750) | [Bug]: Weird line always drawn on secondary monitor | 显示器、分辨率与刘海适配 |
| [#751](https://github.com/jordanbaird/Ice/issues/751) | [Bug]: The cursor is not visible after clicking the ICE icon and then selecting a hidden icon from the ICE bar. | 触发、点击与自动隐藏 |
| [#752](https://github.com/jordanbaird/Ice/issues/752) | [Bug]: Latest beta update from Sept 16th - when is a new one coming with fixed bugs | 本地化、文档与项目维护 |
| [#753](https://github.com/jordanbaird/Ice/issues/753) | [Bug]: Always Hidden items are empty under new Tahoe Beta 4 | 分区、排序与状态持久化 |
| [#754](https://github.com/jordanbaird/Ice/issues/754) | [Feature Request]: Dark icon | 菜单栏外观与渲染 |
| [#755](https://github.com/jordanbaird/Ice/issues/755) | [Bug]: Dropped menubar clicks | 分区、排序与状态持久化 |
| [#757](https://github.com/jordanbaird/Ice/issues/757) | [Bug]: Pointer disappearing after clicking on icons in ICE popup bar | 分区、排序与状态持久化 |
| [#758](https://github.com/jordanbaird/Ice/issues/758) | [Bug]: Unable to re-arrange menu bar via Ice app | 分区、排序与状态持久化 |
| [#759](https://github.com/jordanbaird/Ice/issues/759) | [Bug]: Ice Icon Disappearing after Hidden Items are shown | 分区、排序与状态持久化 |
| [#760](https://github.com/jordanbaird/Ice/issues/760) | [Feature Request]: Make stable version for Tahoe? | 本地化、文档与项目维护 |
| [#762](https://github.com/jordanbaird/Ice/issues/762) | [Bug]: Cannot use Ice Bar nor Menu Bar layout icons | 布局编辑、图标发现与搜索 |
| [#763](https://github.com/jordanbaird/Ice/issues/763) | [Bug]: Color Picker is broken for Menu Bar | 菜单栏外观与渲染 |
| [#766](https://github.com/jordanbaird/Ice/issues/766) | [Bug]: App with dropdown from menu bar (Mullvad VPN) appears as it auto-hides | 第三方应用与系统项目兼容 |
| [#767](https://github.com/jordanbaird/Ice/issues/767) | [Feature Request]: Have new menubar items appear in always shown, or customizable | 分区、排序与状态持久化 |
| [#768](https://github.com/jordanbaird/Ice/issues/768) | [Bug]: ICE dock icon apeears when clicking on chevron to show menu. | 触发、点击与自动隐藏 |
| [#769](https://github.com/jordanbaird/Ice/issues/769) | [Bug]: Menu Bar Layout gets reordered when i close the Ice app | 布局编辑、图标发现与搜索 |
| [#770](https://github.com/jordanbaird/Ice/issues/770) | [Bug]: App gets stuck when installed | 权限、更新、安装与分发 |
| [#771](https://github.com/jordanbaird/Ice/issues/771) | [Bug]: Shortcut Gets Hidden After Restart | 分区、排序与状态持久化 |
| [#773](https://github.com/jordanbaird/Ice/issues/773) | [Bug]: Menu Bar Layout empty - All icons in hidden section | 布局编辑、图标发现与搜索 |
| [#774](https://github.com/jordanbaird/Ice/issues/774) | [Bug]: Website https://icemenubar.app/ appears to be down | 本地化、文档与项目维护 |
| [#777](https://github.com/jordanbaird/Ice/issues/777) | [Bug]:  Ice App Freezes During Screen Capture Operations | 崩溃、冻结与资源消耗 |
| [#778](https://github.com/jordanbaird/Ice/issues/778) | [Feature Request]: Add Toggle to expand hidden section to contain always hidden icons | 分区、排序与状态持久化 |
| [#779](https://github.com/jordanbaird/Ice/issues/779) | [Bug]: 点击图标自动就退出了.系统崩溃 | 崩溃、冻结与资源消耗 |
| [#780](https://github.com/jordanbaird/Ice/issues/780) | [Bug]: Bug on Vertical Monitors | 显示器、分辨率与刘海适配 |
| [#781](https://github.com/jordanbaird/Ice/issues/781) | [Bug]: ICE menu icon non showing anymore | 分区、排序与状态持久化 |
| [#783](https://github.com/jordanbaird/Ice/issues/783) | [Feature Request]: Separate sets for laptops when connect to external monitor | 显示器、分辨率与刘海适配 |
| [#786](https://github.com/jordanbaird/Ice/issues/786) | [Bug]:Selecting 'Ice Bar' in settings and then tapping on the Ice icon causes Ice to crash | 崩溃、冻结与资源消耗 |
| [#787](https://github.com/jordanbaird/Ice/issues/787) | [Feature Request]: need language option，Chinese for example.... | 本地化、文档与项目维护 |
| [#790](https://github.com/jordanbaird/Ice/issues/790) | [Bug]: Multiple monitors freeze | 崩溃、冻结与资源消耗 |
| [#793](https://github.com/jordanbaird/Ice/issues/793) | [Bug]: White icons on white background | 菜单栏外观与渲染 |
| [#796](https://github.com/jordanbaird/Ice/issues/796) | [Bug]: App crashes when opening the sub menu | 崩溃、冻结与资源消耗 |
| [#797](https://github.com/jordanbaird/Ice/issues/797) | [Feature Request]: only on screens with a notch | 显示器、分辨率与刘海适配 |
| [#798](https://github.com/jordanbaird/Ice/issues/798) | [Bug]: Audio Wrangler Mute Icon Issue | 第三方应用与系统项目兼容 |
| [#799](https://github.com/jordanbaird/Ice/issues/799) | [Bug]: Menu bar items not disappearing | 分区、排序与状态持久化 |
| [#801](https://github.com/jordanbaird/Ice/issues/801) | [Feature Request]: 求中文 | 本地化、文档与项目维护 |
| [#802](https://github.com/jordanbaird/Ice/issues/802) | [Bug]: After updating the Mac version, the layout settings disappeared. | 布局编辑、图标发现与搜索 |
| [#806](https://github.com/jordanbaird/Ice/issues/806) | [Bug]: Razer Synapse icon always hidden on startup | 第三方应用与系统项目兼容 |
| [#807](https://github.com/jordanbaird/Ice/issues/807) | [Bug]: [Macbook Pro, M4 Pro] Not responding | 崩溃、冻结与资源消耗 |
| [#808](https://github.com/jordanbaird/Ice/issues/808) | [Bug]: macOS "Tahoe" - after system restart icon remains in dock | 触发、点击与自动隐藏 |
| [#809](https://github.com/jordanbaird/Ice/issues/809) | [Feature Request]: Always place new icons at the end | 分区、排序与状态持久化 |
| [#810](https://github.com/jordanbaird/Ice/issues/810) | [Bug]: Crash on M1 Pro | 崩溃、冻结与资源消耗 |
| [#813](https://github.com/jordanbaird/Ice/issues/813) | [Bug]: Ice bar closes soon after opening | Ice Bar 功能与交互 |
| [#814](https://github.com/jordanbaird/Ice/issues/814) | [Bug]: "Use Ice Bar" feature does not work | Ice Bar 功能与交互 |
| [#816](https://github.com/jordanbaird/Ice/issues/816) | [Bug]: Menu Bar Layout does not give option to customize anything | 布局编辑、图标发现与搜索 |
| [#817](https://github.com/jordanbaird/Ice/issues/817) | [Bug]: User (Login) Icon is not customasibale | 第三方应用与系统项目兼容 |
| [#818](https://github.com/jordanbaird/Ice/issues/818) | [Bug]: Menu bar layout editor is just empty/white | 布局编辑、图标发现与搜索 |
| [#819](https://github.com/jordanbaird/Ice/issues/819) | [Bug]: memory leak in WindowServer caused by Ice? | 崩溃、冻结与资源消耗 |
| [#821](https://github.com/jordanbaird/Ice/issues/821) | [Bug]: ICE crashes every time on clicking the ICE icon in menubar. iMac, macOS 26.2 (issue identical on 26.1). | 崩溃、冻结与资源消耗 |
| [#823](https://github.com/jordanbaird/Ice/issues/823) | [Feature Request]: Are we every going to get a stable version for macOS Tahoe, or is the app not in development anymore? | 本地化、文档与项目维护 |
| [#824](https://github.com/jordanbaird/Ice/issues/824) | [Bug]: Right-clicking in external monitor opens "Edit menu bar appearance" menu | 显示器、分辨率与刘海适配 |
| [#825](https://github.com/jordanbaird/Ice/issues/825) | [Bug]: "show on click" on secondary screen shows the extra Ice bar in a small resolution | 显示器、分辨率与刘海适配 |
| [#826](https://github.com/jordanbaird/Ice/issues/826) | [Bug]: Not opening menu item | 第三方应用与系统项目兼容 |
| [#829](https://github.com/jordanbaird/Ice/issues/829) | [Bug]: the ice bar cannot show the proper size when second monitor connected | 显示器、分辨率与刘海适配 |
| [#830](https://github.com/jordanbaird/Ice/issues/830) | [Bug]: So many bugs | 崩溃、冻结与资源消耗 |
| [#832](https://github.com/jordanbaird/Ice/issues/832) | [Bug]: Menu Bar Layout with Tahoe OS | 布局编辑、图标发现与搜索 |
| [#833](https://github.com/jordanbaird/Ice/issues/833) | [Bug]: Cant see anything on | 系统升级兼容与待澄清反馈 |
| [#834](https://github.com/jordanbaird/Ice/issues/834) | [Bug]: | 权限、更新、安装与分发 |
| [#835](https://github.com/jordanbaird/Ice/issues/835) | [Bug]: Ice stopped doing anything other than changing the Bar's appearance | 菜单栏外观与渲染 |
| [#836](https://github.com/jordanbaird/Ice/issues/836) | [Bug]: Ice didn't work on external monitor menu-bar on auto-hide | 显示器、分辨率与刘海适配 |
| [#838](https://github.com/jordanbaird/Ice/issues/838) | [Bug]: it seems to be frozen. I have to quit it and re-launch it to get it to function properly. | 崩溃、冻结与资源消耗 |
| [#840](https://github.com/jordanbaird/Ice/issues/840) | Crash when enabling Ice Bar: EXC_BREAKPOINT in window handling | 崩溃、冻结与资源消耗 |
| [#844](https://github.com/jordanbaird/Ice/issues/844) | [Bug]: System icons set to "Show When Active" don't remember their correct placement in the menubar | 第三方应用与系统项目兼容 |
| [#845](https://github.com/jordanbaird/Ice/issues/845) | [Bug]: Hidden menubar items not selectable | 触发、点击与自动隐藏 |
| [#846](https://github.com/jordanbaird/Ice/issues/846) | [Bug]: MenuBar in Settings Is Empty White Space | 布局编辑、图标发现与搜索 |
| [#852](https://github.com/jordanbaird/Ice/issues/852) | [Bug]: Ice bar cannot hide recording indicator in 15.7.3 | 第三方应用与系统项目兼容 |
| [#853](https://github.com/jordanbaird/Ice/issues/853) | [Bug]: Cursor IDE icon position is not saved well | 第三方应用与系统项目兼容 |
| [#854](https://github.com/jordanbaird/Ice/issues/854) | [Bug]: Icons are duplicated in the menu bar | 第三方应用与系统项目兼容 |
| [#855](https://github.com/jordanbaird/Ice/issues/855) | [Bug]: Ice keeps crashing after updating to OS26.2 | 崩溃、冻结与资源消耗 |
| [#857](https://github.com/jordanbaird/Ice/issues/857) | [Bug]: Multiple identical app icons disappear when one is restored from hidden state (e.g. OneDrive) | 第三方应用与系统项目兼容 |
| [#858](https://github.com/jordanbaird/Ice/issues/858) | [Bug]: second screen layout wrong display | 显示器、分辨率与刘海适配 |
| [#860](https://github.com/jordanbaird/Ice/issues/860) | [Feature Request]: Option to re-add the menu bar icon, after manual removal | 分区、排序与状态持久化 |
| [#861](https://github.com/jordanbaird/Ice/issues/861) | [Bug]: unable to move icons to hidden section | 分区、排序与状态持久化 |
| [#862](https://github.com/jordanbaird/Ice/issues/862) | [Feature Request]: submit the app to the homebrew | 权限、更新、安装与分发 |
| [#863](https://github.com/jordanbaird/Ice/issues/863) | [Bug]: Black square appears in bottom-right corner of primary display when secondary display has fullscreen window | 显示器、分辨率与刘海适配 |
| [#865](https://github.com/jordanbaird/Ice/issues/865) | [Bug]: macOS 26.3 beta 3 prevents Ice from expanding | 触发、点击与自动隐藏 |
| [#867](https://github.com/jordanbaird/Ice/issues/867) | [Bug]: Ice crash on macOS 26.2 (25C56) | 崩溃、冻结与资源消耗 |
| [#871](https://github.com/jordanbaird/Ice/issues/871) | [Bug]: Unable to click on secondary menu bar icons, the bar disappears | 分区、排序与状态持久化 |
| [#872](https://github.com/jordanbaird/Ice/issues/872) | [Bug]: Unstable, Layout menu area broken | 布局编辑、图标发现与搜索 |
| [#877](https://github.com/jordanbaird/Ice/issues/877) | [Bug]: PROJECT DEAD, no updates in 1.5 years, crashes all the time. | 本地化、文档与项目维护 |
| [#878](https://github.com/jordanbaird/Ice/issues/878) | [Bug]: Menu bar items are not appearing | 布局编辑、图标发现与搜索 |
| [#879](https://github.com/jordanbaird/Ice/issues/879) | [Bug]: "hide app menus when showing menu bar items" feature not working | 触发、点击与自动隐藏 |
| [#880](https://github.com/jordanbaird/Ice/issues/880) | [Bug]: not be able to use it on imac today | 崩溃、冻结与资源消耗 |
| [#886](https://github.com/jordanbaird/Ice/issues/886) | [Feature Request]: Hide screen recording indicator | 第三方应用与系统项目兼容 |
| [#887](https://github.com/jordanbaird/Ice/issues/887) | [Bug]: some application don't respect visibility section (like HubStuff) | 第三方应用与系统项目兼容 |
| [#888](https://github.com/jordanbaird/Ice/issues/888) | [Bug]: Cannot use ice bar when which between windows | Ice Bar 功能与交互 |
| [#890](https://github.com/jordanbaird/Ice/issues/890) | [Bug]: Ice Bar | Ice Bar 功能与交互 |
| [#891](https://github.com/jordanbaird/Ice/issues/891) | [Bug]: ICons List Blank In Settings | 布局编辑、图标发现与搜索 |
| [#899](https://github.com/jordanbaird/Ice/issues/899) | [Bug]: Ice triggering while clicking just under the menu bar in fullscreen | 触发、点击与自动隐藏 |
| [#905](https://github.com/jordanbaird/Ice/issues/905) | [Bug]: | 崩溃、冻结与资源消耗 |
| [#906](https://github.com/jordanbaird/Ice/issues/906) | [Bug]: App opens in dock when expanding the bar | 触发、点击与自动隐藏 |
| [#908](https://github.com/jordanbaird/Ice/issues/908) | [Bug]: Ice appears to have caused system-wide freeze & kernel panic after ~33 hours of uptime | 崩溃、冻结与资源消耗 |
| [#909](https://github.com/jordanbaird/Ice/issues/909) | [Bug]: OneDrive icons | 第三方应用与系统项目兼容 |
| [#910](https://github.com/jordanbaird/Ice/issues/910) | [Bug]: iPad appearance tint shows on main monitor when the iPad is used as an extended display | 显示器、分辨率与刘海适配 |
| [#913](https://github.com/jordanbaird/Ice/issues/913) | [Bug]: Settings Menu: Menu Bar Layout Icons Do Not Appear | 布局编辑、图标发现与搜索 |
| [#914](https://github.com/jordanbaird/Ice/issues/914) | [Bug]: Ice Bar auto-hides before cursor reaches it (latest beta) | 触发、点击与自动隐藏 |
| [#915](https://github.com/jordanbaird/Ice/issues/915) | [Bug]: Unsplash client crashes shortly after being hidden by ICE | 崩溃、冻结与资源消耗 |
| [#916](https://github.com/jordanbaird/Ice/issues/916) | [Bug]:  I can't edit my layout, because it's all blank | 布局编辑、图标发现与搜索 |
| [#918](https://github.com/jordanbaird/Ice/issues/918) | [Bug]:When icon for Intego One is moved from hidden to visible bar in settings, the icon disappears | 第三方应用与系统项目兼容 |
| [#919](https://github.com/jordanbaird/Ice/issues/919) | [Bug]: Ice icon dissappeared | 布局编辑、图标发现与搜索 |
| [#920](https://github.com/jordanbaird/Ice/issues/920) | I have searched existing issues for similar reports | 系统升级兼容与待澄清反馈 |
| [#921](https://github.com/jordanbaird/Ice/issues/921) | [Bug]: Icons in re-arrange menu in settings aren't visible | 分区、排序与状态持久化 |
| [#925](https://github.com/jordanbaird/Ice/issues/925) | [Bug]: Crash when enabling "Use Ice Bar" with Dynamic location | 崩溃、冻结与资源消耗 |
| [#929](https://github.com/jordanbaird/Ice/issues/929) | [Bug]: Menu bar scaling and layout issues on external/built-in displays (macOS 26.4.1) | 显示器、分辨率与刘海适配 |
| [#934](https://github.com/jordanbaird/Ice/issues/934) | [Bug]: Nothing happens when I try to run Ice | 权限、更新、安装与分发 |
| [#935](https://github.com/jordanbaird/Ice/issues/935) | [Bug]: Website SSL cert expired | 本地化、文档与项目维护 |
| [#938](https://github.com/jordanbaird/Ice/issues/938) | [Feature Request]: Option that lets you choose location of new items | 分区、排序与状态持久化 |
| [#939](https://github.com/jordanbaird/Ice/issues/939) | [Bug]: IS THIS PROJECT ABANDONED? | 本地化、文档与项目维护 |
| [#943](https://github.com/jordanbaird/Ice/issues/943) | [Bug]: Ligthing error when enabeling split shape in menu bar appearance | 菜单栏外观与渲染 |
| [#946](https://github.com/jordanbaird/Ice/issues/946) | [Bug]: MacOS Tahoe 26.5 update broke hidden elements in ice layout | 布局编辑、图标发现与搜索 |
| [#947](https://github.com/jordanbaird/Ice/issues/947) | [Bug]: app crash after click in menubar | 崩溃、冻结与资源消耗 |
| [#951](https://github.com/jordanbaird/Ice/issues/951) | [Bug]: Can't view the icons on Menu Bar Layout | 布局编辑、图标发现与搜索 |
| [#954](https://github.com/jordanbaird/Ice/issues/954) | [Bug]: Ice in menu bar not working anymore (MacOS Golden Gate 27) | 系统升级兼容与待澄清反馈 |
| [#955](https://github.com/jordanbaird/Ice/issues/955) | [Bug]: Scale error and auto-deploying | 显示器、分辨率与刘海适配 |
| [#957](https://github.com/jordanbaird/Ice/issues/957) | [Bug]: Starts but nothing much more | 系统升级兼容与待澄清反馈 |
| [#959](https://github.com/jordanbaird/Ice/issues/959) | [Bug]: Split menu bar does not function like expected in full screen | 菜单栏外观与渲染 |
| [#961](https://github.com/jordanbaird/Ice/issues/961) | [Feature Request]: No dock icon | 触发、点击与自动隐藏 |
| [#965](https://github.com/jordanbaird/Ice/issues/965) | [Bug]: Menubar layout broken/spinning in MacOS 27 Public Beta | 布局编辑、图标发现与搜索 |
| [#966](https://github.com/jordanbaird/Ice/issues/966) | [Bug]: Unofficial macOS 26-compatible build of Ice (signed and notarized) | 本地化、文档与项目维护 |
| [#968](https://github.com/jordanbaird/Ice/issues/968) | macOS 26.5.2: Ice stuck / menu bar stays hidden after form dropdown hang (Dock auto-hide also stuck) | 崩溃、冻结与资源消耗 |
| [#970](https://github.com/jordanbaird/Ice/issues/970) | [Bug]: Not automatically hiding in MacOS 27 | 触发、点击与自动隐藏 |
| [#973](https://github.com/jordanbaird/Ice/issues/973) | [Bug]: Menu bar layout shown nothing on the sections | 布局编辑、图标发现与搜索 |
| [#974](https://github.com/jordanbaird/Ice/issues/974) | [Bug]: Orphaned application menu-bar windows stuck at CGWindow layer 101, invisible to accessibility (macOS 26.6.1, 0.11.13-dev.2) | 崩溃、冻结与资源消耗 |
| [#977](https://github.com/jordanbaird/Ice/issues/977) | [Bug]: crashes whenever I use the trigger button in the menu bar | 崩溃、冻结与资源消耗 |
| [#986](https://github.com/jordanbaird/Ice/issues/986) | [Bug]: Ice Bar leaves a ghost/visual artifact on the primary display when a video enters fullscreen on a secondary display | 显示器、分辨率与刘海适配 |
| [#987](https://github.com/jordanbaird/Ice/issues/987) | [Bug]: Ice Bar icons shrink drastically when expanded on an external display | 显示器、分辨率与刘海适配 |
| [#988](https://github.com/jordanbaird/Ice/issues/988) | [Bug]: Ice Bar fullscreen expansion behaves differently depending on which display contains the active window | 显示器、分辨率与刘海适配 |
| [#991](https://github.com/jordanbaird/Ice/issues/991) | [Bug]: MacOS 27 Update | 系统升级兼容与待澄清反馈 |
| [#992](https://github.com/jordanbaird/Ice/issues/992) | [Bug]: unavailable under MacOS27 | 布局编辑、图标发现与搜索 |
| [#993](https://github.com/jordanbaird/Ice/issues/993) | [Feature Request]: This project is no longer maintained by the original author | 本地化、文档与项目维护 |
| [#996](https://github.com/jordanbaird/Ice/issues/996) | [Bug]: Ice not working properly on macOS 27 Golden Gate | 触发、点击与自动隐藏 |
| [#999](https://github.com/jordanbaird/Ice/issues/999) | [Bug]: Can't see layout | 布局编辑、图标发现与搜索 |
| [#1003](https://github.com/jordanbaird/Ice/issues/1003) | [Bug]: [Bug]: Updated to MacOS 27.0.1 and cannot customize Menu Bar Layout on Ice | 布局编辑、图标发现与搜索 |
| [#1006](https://github.com/jordanbaird/Ice/issues/1006) | [macOS 27.0.1] What got Ice working with PR #995, plus two things to look into | 权限、更新、安装与分发 |
| [#1007](https://github.com/jordanbaird/Ice/issues/1007) | [macOS 27 / PR #995] An app launched while concealed gets a squashed (3 pt) menu bar item that never recovers | 第三方应用与系统项目兼容 |
| [#1008](https://github.com/jordanbaird/Ice/issues/1008) | [Bug]: Not functioning since MacOS 27 update on my Macbook pro M3 pro | 触发、点击与自动隐藏 |
| [#1009](https://github.com/jordanbaird/Ice/issues/1009) | [Bug]: | 布局编辑、图标发现与搜索 |
| [#1010](https://github.com/jordanbaird/Ice/issues/1010) | [Bug]: always loading meum bar items | 布局编辑、图标发现与搜索 |
| [#1011](https://github.com/jordanbaird/Ice/issues/1011) | [Feature Request]: Some Golden Gate Clarity | 本地化、文档与项目维护 |
| [#1014](https://github.com/jordanbaird/Ice/issues/1014) | [macOS 27 / PR #995] With an app item among the system items, clicking the battery opens that app and Wi-Fi does not open | 触发、点击与自动隐藏 |
| [#1015](https://github.com/jordanbaird/Ice/issues/1015) | [Feature Request]: Is the project still alive? | 本地化、文档与项目维护 |

### jordanbaird/Ice #6

- 链接：https://github.com/jordanbaird/Ice/issues/6
- 作者：[y-u-s-u-f](https://github.com/y-u-s-u-f)
- 状态：open
- 创建时间：2024-02-04T21:14:08Z（UTC）
- 更新时间：2025-04-09T17:36:17Z（UTC）
- 标签：Feature, Layout
- 评论数：15（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request] Change the location where new menu bar icons come up.
```

**正文原文**

```markdown
It would be awesome if we could change where new icons come up.
```

### jordanbaird/Ice #26

- 链接：https://github.com/jordanbaird/Ice/issues/26
- 作者：[rebdeg](https://github.com/rebdeg)
- 状态：open
- 创建时间：2024-03-10T15:20:29Z（UTC）
- 更新时间：2026-01-26T09:27:31Z（UTC）
- 标签：Feature, Profiles
- 评论数：14（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Feature request] Profiles for menubar layout
```

**正文原文**

```markdown
Profiles with specific settings/layout of the menubar for different tasks (work, personal) etc would be a nice feature
```

### jordanbaird/Ice #46

- 链接：https://github.com/jordanbaird/Ice/issues/46
- 作者：[Xytronix](https://github.com/Xytronix)
- 状态：open
- 创建时间：2024-04-10T09:29:10Z（UTC）
- 更新时间：2026-09-07T14:17:12Z（UTC）
- 标签：Feature, Groups
- 评论数：7（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Menubar groups
```

**正文原文**

```markdown
### Description

You could be able to set up groups with an icon, when clicked assigned menu bar items should appear. 



### Screenshots

_No response_
```

### jordanbaird/Ice #53

- 链接：https://github.com/jordanbaird/Ice/issues/53
- 作者：[fastnlight0](https://github.com/fastnlight0)
- 状态：open
- 创建时间：2024-04-11T23:45:08Z（UTC）
- 更新时间：2024-07-13T12:44:34Z（UTC）
- 标签：Bug
- 评论数：7（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Any change in monitors while Mac is asleep removes styling
```

**正文原文**

```markdown
### Check existing issues

- [X] I have checked existing issues and believe that my issue is not a duplicate

### Description

I have my menu bar styled. When I put my Mac to sleep, change my monitor configuration (close Mac lid, unplug a monitor, etc), then wake it up again (eg. by re-opening the lid), my menu bar is back to normal (unstyled). When I restart the Ice app, or do something to re-trigger the menu bar style (eg. enter and exit full screen on an app or change monitor count), the menu bar re-styles itself.

Even if the monitors are the same when I turn off my Mac and turn it back on (eg. sleep mac, unplug monitor, replug same monitor, wake up Mac), the issue still occurs. If no change in monitors occurs, Ice keeps it's styling when I wake my Mac back up. Closing or opening the lid counts as a monitor change.

### Steps to Reproduce

1. Style your menu bar
2. Put Mac to sleep
3. Make any change to monitor setup (you can even go back to the original setup before waking your Mac back up)
4. Observe your unstyled menu bar

### Ice Version

0.8.0 (latest version at time of writing)

### macOS Version

14.4.1 (23E224) (latest version at time of writing)

### Screenshots

_No response_
```

### jordanbaird/Ice #58

- 链接：https://github.com/jordanbaird/Ice/issues/58
- 作者：[Haadi-Khan](https://github.com/Haadi-Khan)
- 状态：open
- 创建时间：2024-05-09T21:09:05Z（UTC）
- 更新时间：2024-09-16T01:22:10Z（UTC）
- 标签：Bug, Improvement
- 评论数：5（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Menu Bar Flashes
```

**正文原文**

```markdown
### Check existing issues

- [X] I have checked existing issues and believe that my issue is not a duplicate

### Description

Upon switching workspaces, the menu bar flashes as it appears to refresh. This is consistent w/ different methods to switch the workspace (i.e. swipe gestures/keybinds). It is present for both split and standard menu bars.

I am using Yabai, but the bug persists with it disabled.

### Steps to Reproduce

Switch workspaces and there's a flash.

### Ice Version

0.8.0

### macOS Version

14.4.1

### Screenshots


https://github.com/jordanbaird/Ice/assets/44217975/a48f3af0-af38-4035-ba36-03405c5412fc


```

### jordanbaird/Ice #62

- 链接：https://github.com/jordanbaird/Ice/issues/62
- 作者：[leodbrs](https://github.com/leodbrs)
- 状态：open
- 创建时间：2024-05-21T07:58:23Z（UTC）
- 更新时间：2026-05-05T17:32:44Z（UTC）
- 标签：Feature, Triggers
- 评论数：5（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Show menu bar items when trigger condition are met
```

**正文原文**

```markdown
### Description

Like Bartender, for example, when the battery level is under 50% (or custom value), display the battery icon.
Depending on a script result, show or not an item.

The trigger action can also be an image comparison to a specific state of a menu bar item.

### Screenshots

_No response_
```

### jordanbaird/Ice #73

- 链接：https://github.com/jordanbaird/Ice/issues/73
- 作者：[pjlsergeant](https://github.com/pjlsergeant)
- 状态：open
- 创建时间：2024-06-05T08:54:22Z（UTC）
- 更新时间：2024-08-04T14:22:11Z（UTC）
- 标签：Feature, Improvement
- 评论数：9（本清单不采集评论正文）
- 主分类：权限、更新、安装与分发

**标题原文**

```text
[Feature Request]: Defer recommended payment until once installed
```

**正文原文**

```markdown
### Description

I think you're well on your way to becoming a replacement for Bartender, so, congrats.

I think you'll get paid more for your efforts if you find a way to defer the request for payment until after a user is setup and it's working. Unwilling to pay for an app I haven't used before at download time, because I've no idea if it will work, but a few days into it being useful and installed, I'm absolutely willing to pay. But having downloaded it for free, it's now pretty unintuitive how to give you some $$.

I can find the Support link in About, although I don't especially want to set up a recurring donation, so actually I have to go back to the website, click Download again, and fill out the payment again, which I've now done, although presumably I've also screwed up any analytics you have on how much people are willing to pay by creating both a $0 and a $25 entry

I think it would be worth considering selling an optional nagware license instead so you're asking people for money a few days after they've used it.

Anyway, great work.

### Screenshots

_No response_
```

### jordanbaird/Ice #83

- 链接：https://github.com/jordanbaird/Ice/issues/83
- 作者：[heyRDK](https://github.com/heyRDK)
- 状态：open
- 创建时间：2024-06-05T18:55:16Z（UTC）
- 更新时间：2024-09-02T09:51:15Z（UTC）
- 标签：Feature, Improvement, Accessibility
- 评论数：9（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Organize apps by keyboard shortcuts or in preferences pane
```

**正文原文**

```markdown
### Description

I'm a screen reader (VoiceOver) user. Therefore, it is almost impossible for me to drag and drop icons in the menubar to hide them. Would it be possible to organize apps—hidden or not—by keyboard shortcuts or by having a dedicated pane in preferences where you can select which apps are hidden, always hidden, etc.?

### Screenshots

_No response_
```

### jordanbaird/Ice #91

- 链接：https://github.com/jordanbaird/Ice/issues/91
- 作者：[tylersticka](https://github.com/tylersticka)
- 状态：open
- 创建时间：2024-06-05T22:16:46Z（UTC）
- 更新时间：2026-01-23T19:55:41Z（UTC）
- 标签：Feature
- 评论数：9（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Spacers
```

**正文原文**

```markdown
### Description

Thank you so much for making this, Jordan! I was really down after hearing the news about Bartender's mysterious new ownership, was so relieved to find an open source alternative.

This may sound silly and cosmetic, but I'd love to see support for spacers to add between menu bar items. I used this with Bartender to loosely group related icons. Not a deal-breaker, just figured I'd share!

### Screenshots

<img width="404" alt="Screenshot 2024-06-05 at 8 46 36 AM copy" src="https://github.com/jordanbaird/Ice/assets/69633/0ecfc3c5-6e11-4f65-9546-5883487f9d0a">

```

### jordanbaird/Ice #94

- 链接：https://github.com/jordanbaird/Ice/issues/94
- 作者：[GeekNOmore](https://github.com/GeekNOmore)
- 状态：open
- 创建时间：2024-06-06T04:51:51Z（UTC）
- 更新时间：2025-06-25T19:42:32Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Icons not hidden in ultra wide screen
```

**正文原文**

```markdown
### Check existing issues

- [X] I have checked existing issues and believe that my issue is not a duplicate

### Description

The icons are just pushed to the left on an ultra wide screen, not really hidden.
The resolution is 7680 x 2160.

### Steps to Reproduce

The icons are just pushed to the left on an ultra wide screen, not really hidden.
The resolution is 7680 x 2160.

### Ice Version

Version 0.8.0

### macOS Version

Sonoma 14.4.1

### Screenshots

![CleanShot 2024-06-06 at 14 50 37](https://github.com/jordanbaird/Ice/assets/24734519/f45ee1bb-0110-4cf3-8464-f3cb700d105b)
```

### jordanbaird/Ice #95

- 链接：https://github.com/jordanbaird/Ice/issues/95
- 作者：[doug-stewart](https://github.com/doug-stewart)
- 状态：open
- 创建时间：2024-06-06T05:51:54Z（UTC）
- 更新时间：2025-11-06T21:20:29Z（UTC）
- 标签：Feature
- 评论数：4（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Cross-Device Syncing
```

**正文原文**

```markdown
### Description

I have a personal Mac and a work Mac. A great feature would be settings syncing via iCloud.

### Screenshots

_No response_
```

### jordanbaird/Ice #113

- 链接：https://github.com/jordanbaird/Ice/issues/113
- 作者：[zmkstn](https://github.com/zmkstn)
- 状态：open
- 创建时间：2024-06-07T03:06:11Z（UTC）
- 更新时间：2024-07-10T18:23:22Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Scroll again to toggle always-hidden section
```

**正文原文**

```markdown
### Description

Scroll is an absolute game changer for me.

What would make it even better is if it could show the always-hidden section after the initial scroll toggles the hidden section. 

Flow:
1. Scroll on menu bar to unhide hidden section.
2. Pause
3. Scroll once more on menu bar to unhide the always-hidden section.

And if it could also work in reverse too, that would be amazing.

### Screenshots

_No response_
```

### jordanbaird/Ice #141

- 链接：https://github.com/jordanbaird/Ice/issues/141
- 作者：[andrewcrook](https://github.com/andrewcrook)
- 状态：open
- 创建时间：2024-06-11T12:06:03Z（UTC）
- 更新时间：2025-07-03T10:45:43Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: x-callback-url for automation
```

**正文原文**

```markdown
### Description

I am a huge fan of automation and integrations. I can see ICE being able to add a lot to this area.

My first draft of this request was huge full of ideas for several interfaces for automation.
This would probably have required a whole team if developed :-)

I since , I tried to greatly simplify the idea. I came to the conclusion that x-callback-url would be the best solution or best to begin with. This would open the opportunity for developers to write code to automate Ice to add support  for many other languages, tools and apps. 

API feature ideas:
- Get list of app icons
- Filter by section  i.e hidden, always hidden and always show.
- The ability to move apps between sections.
- hide and show sections 
- ability to load and change different layouts of icons and settings
- ability  change order of icons by placement number  
       (would have to keep a list on previously seen apps and their positions. order per section?)
- change other options for example menubar colour so could be used as feedback in scripts etc.

example (one way communication)
`“ice://x-callback-url/show?always-hidden=true” `

Actually I don't think it needs bidirectional communications via callbacks which kind of makes things simpler.
However, I feel  x-callback-url  would still give a good standard to follow.


### Screenshots

_No response_
```

### jordanbaird/Ice #144

- 链接：https://github.com/jordanbaird/Ice/issues/144
- 作者：[gingerbeardman](https://github.com/gingerbeardman)
- 状态：open
- 创建时间：2024-06-11T13:04:07Z（UTC）
- 更新时间：2024-10-09T22:08:45Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Doing opt click after click does not hide app menus
```

**正文原文**

```markdown
### Check existing issues

- [X] I have checked existing issues and believe that my issue is not a duplicate

### Description

Doing opt click after click (opt-click to show always hidden icons whilst hidden icons are already shown) does not hide app menus

Seems a like a simple state tracking logic problem, should be an easy fix.

### Steps to Reproduce

1. first: click ice icon
(hidden icons are shown)
2. whilst hidden icons are shown: opt-click ice icon
(always hidden icons are shown in addition to hidden icons)

**Expected**
- app menus should be hidden

**Actual**
- app menus are not hidden

**Workaround**
- do opt-click in isolation
- (do not do opt-click after normal click)

### Ice Version

- 0.9.0

### macOS Version

- 14.5.0

### Screenshots


https://github.com/jordanbaird/Ice/assets/49612/8aaa07ab-c0f9-4478-b5ab-bb31148f6a19


```

### jordanbaird/Ice #148

- 链接：https://github.com/jordanbaird/Ice/issues/148
- 作者：[core-code](https://github.com/core-code)
- 状态：open
- 创建时间：2024-06-12T10:38:23Z（UTC）
- 更新时间：2024-08-09T11:44:50Z（UTC）
- 标签：Feature, Triggers
- 评论数：1（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Custom trigger API for applications to implement
```

**正文原文**

````markdown
### Description

are there any plans of supporting Bartender's "API" that apps like ours have implemented so that the menubar item will only be displayed if there is something important to display?
it boils down to two things:
• setting the accessibility value of the menubar item to the numeric value of "important items". presumably the item is hidden of the accessibility value is empty or '0'
• sending global notifications to let menubar manager apps know when the value changes
here is how we've implemented that API:

```
if (appsWithUpdatesCount)
_visibilityManager.statusItem.button.accessibilityValue = @(appsWithUpdatesCount).stringValue;
else
_visibilityManager.statusItem.button.accessibilityValue = nil;
[distributedNotificationCenter postNotificationName:@"Bartender.MenuBarItemStateUpdated" object:appBundleIdentifier userInfo:nil];
```

in our case (MacUpdater) this has resulted in the menubar item being shown when there are updates-to-install but hidden if all apps are up-to-date.

obviously the notification name can/should be changed to something more vendor-neutral

### Screenshots

_No response_
````

### jordanbaird/Ice #186

- 链接：https://github.com/jordanbaird/Ice/issues/186
- 作者：[alt-jurk](https://github.com/alt-jurk)
- 状态：open
- 创建时间：2024-06-29T15:57:40Z（UTC）
- 更新时间：2024-10-16T10:21:13Z（UTC）
- 标签：Feature, Improvement
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Support GIFs as Ice icon
```

**正文原文**

```markdown
### Description

I'd like to have the option to use a GIF as the Ice icon. It's currently possible to choose one, however it only animates in the icon picker, but not in the menu bar itself.

### Screenshots

https://github.com/jordanbaird/Ice/assets/90331934/4c379b34-afaf-4897-936c-d54c0ad2146a


```

### jordanbaird/Ice #188

- 链接：https://github.com/jordanbaird/Ice/issues/188
- 作者：[tigattack](https://github.com/tigattack)
- 状态：open
- 创建时间：2024-07-01T11:38:26Z（UTC）
- 更新时间：2024-10-28T20:27:27Z（UTC）
- 标签：Feature
- 评论数：4（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Option to only hide on built-in display
```

**正文原文**

```markdown
### Description

I use Ice to stop icons flowing across the notch on my Mac. However, I also often have external displays connected, where it isn't necessary to hide icons. I'd like an option to disable Ice for external displays//only enable for the built-in display.

### Screenshots

_No response_
```

### jordanbaird/Ice #194

- 链接：https://github.com/jordanbaird/Ice/issues/194
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-02T07:28:25Z（UTC）
- 更新时间：2024-08-16T21:30:33Z（UTC）
- 标签：Bug, Layout, Screen Capture
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Offscreen items are dimmed in interface after being moved
```

**正文原文**

```markdown
### Check existing and frequent issues

- [X] I have checked existing issues and believe that my issue is not a duplicate
- [X] I have read the [Frequent Issues](https://github.com/jordanbaird/Ice/blob/main/Documentation/FREQUENT_ISSUES.md) document, and my issue is not included there

### Description

After moving an item that is offscreen, its image representation in Ice's interface becomes translucent until another item is moved, after which the newly moved item becomes translucent and the initial item fixes itself.

### Steps to Reproduce

1. Go to the `Menu Bar Items` settings pane
2. Move an offscreen item
3. The item will become translucent
4. Move a second item
5. The first item will be back to normal
6. The second item will now be translucent

### Ice Version

0.10.0-beta.6

### macOS Version

14.5

### Screenshots

<img width="1012" alt="image" src="https://github.com/jordanbaird/Ice/assets/90936861/68d19226-bb46-4945-b30b-76694c40aa9d">
```

### jordanbaird/Ice #201

- 链接：https://github.com/jordanbaird/Ice/issues/201
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-03T21:35:59Z（UTC）
- 更新时间：2025-06-11T02:11:09Z（UTC）
- 标签：Bug, Ice Bar
- 评论数：4（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Can't arrange or display menu bar items when the menu bar is automatically hidden
```

**正文原文**

```markdown
### Check existing and frequent issues

- [X] I have checked existing issues and believe that my issue is not a duplicate
- [X] I have read the [Frequent Issues](https://github.com/jordanbaird/Ice/blob/main/Documentation/FREQUENT_ISSUES.md) document, and my issue is not included there

### Description

When the menu bar is set to automatically hide and show in macOS System Settings (see screenshots), Ice can't capture their offscreen images. Trying to arrange items in the "Menu Bar Items" settings pane _does_ result in them being moved, but for some reason, they no longer show whatever content is supposed to be displayed inside them, and they longer accept clicks or drags. Showing the menu bar on another display seems to reset the items, and they display normally until they are moved again.

The current solution is to disable both the Ice Bar and item arranging when the menu bar is automatically hidden, but it's always possible there are workarounds for this.

### Steps to Reproduce

### Displaying Items:
1. Open System Settings > Control Center
2. Set automatically hide and show the menu bar to "Always"
3. Open Ice with the Ice Bar enabled, and a hotkey set to show the hidden section
4. Show the Ice Bar with the hotkey
5. Items will not display
6. Hover over the menu bar to automatically show it
7. Items will now display in the Ice Bar

### Arranging Items:
1. In the "Menu Bar Items" settings pane, move an item in the visible section with the menu bar hidden
2. Hover over the menu bar to automatically show it
3. There is now a blank space where the item should be that cannot be interacted with
4. Hover over the menu bar on another display
5. Note how the item now shows and behaves normally

### Ice Version

0.10.0-beta.6

### macOS Version

14.5

### Screenshots

#### The setting that causes the bug:
<img width="827" alt="image" src="https://github.com/jordanbaird/Ice/assets/90936861/2f9244c9-d7a5-401b-adec-01d1ef9167fb">

#### Before arranging:
<img width="511" alt="image" src="https://github.com/jordanbaird/Ice/assets/90936861/68275a0d-cb7e-47e3-bf28-b71dcf938de5">

#### After arranging:
<img width="521" alt="image" src="https://github.com/jordanbaird/Ice/assets/90936861/6cd83f02-7c0b-457b-aeb5-97cd1b2df7cb">
```

### jordanbaird/Ice #208

- 链接：https://github.com/jordanbaird/Ice/issues/208
- 作者：[Xytronix](https://github.com/Xytronix)
- 状态：open
- 创建时间：2024-07-05T16:39:38Z（UTC）
- 更新时间：2024-07-07T13:02:11Z（UTC）
- 标签：Feature, Ice Bar
- 评论数：0（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
Feature Request: Adding Ice Bar as an additional layout under Menu Bar Items
```

**正文原文**

```markdown
An additional layout under Menu Bar Items for Ice Bar:
![image](https://github.com/jordanbaird/Ice/assets/32957125/b28f80bf-d118-4364-9140-3a0d5ee56078)
If users do want to set up the Ice Bar individually from the rest of the layouts.

_Originally posted by @Xytronix in https://github.com/jordanbaird/Ice/discussions/192#discussioncomment-9969335_
```

### jordanbaird/Ice #209

- 链接：https://github.com/jordanbaird/Ice/issues/209
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-05T22:36:11Z（UTC）
- 更新时间：2024-07-07T13:02:24Z（UTC）
- 标签：Feature, Ice Bar
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Arrange items directly inside Ice Bar
```

**正文原文**

```markdown
### Check existing feature requests

- [X] I have checked existing issues and believe that my feature request is not a duplicate

### Description

Users should be able to Command + drag items in the Ice Bar, just like they can in the menu bar. If just one or two items need to be arranged, it would be much more convenient to be able to do it immediately instead of having to go into the "Menu Bar Items" settings.

### Screenshots

_No response_
```

### jordanbaird/Ice #210

- 链接：https://github.com/jordanbaird/Ice/issues/210
- 作者：[theschles](https://github.com/theschles)
- 状态：open
- 创建时间：2024-07-06T15:55:21Z（UTC）
- 更新时间：2025-09-17T10:40:32Z（UTC）
- 标签：Feature, Improvement
- 评论数：3（本清单不采集评论正文）
- 主分类：权限、更新、安装与分发

**标题原文**

```text
[Feature Request]: Option to update to beta releases
```

**正文原文**

```markdown
### Check existing feature requests

- [X] I have checked existing issues and believe that my feature request is not a duplicate

### Description

Hi! Thank you for putting into place #1 (notch macbook support)! Can't wait for when `0.10.0` is officially released.

Your users are interested in trying out beta releases.  I suggest adding another toggle swtich in the "Updates" section for "include beta releases".  

That way -- with the options that are currently there for "Automatically check for updates" and "Automatically download updates" -- and if users are interested -- users will additionally have the option to be, respectively:
* informed when a beta release is available for download
* have that beta release automatically downloaded to their computer

Please keep up the good work!

### Screenshots

_No response_
```

### jordanbaird/Ice #211

- 链接：https://github.com/jordanbaird/Ice/issues/211
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-07T12:49:25Z（UTC）
- 更新时间：2024-07-07T13:02:38Z（UTC）
- 标签：Bug, Ice Bar
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Ice Bar shows incorrect item images when moved to another screen
```

**正文原文**

```markdown
### Check existing and frequent issues

- [X] I have checked existing issues and believe that my issue is not a duplicate
- [X] I have read the [Frequent Issues](https://github.com/jordanbaird/Ice/blob/main/Documentation/FREQUENT_ISSUES.md) document, and my issue is not included there

### Description

When dragging the Ice Bar from one screen to another, the item images shown in the bar are those of the active screen, _not_ the screen the bar is currently on. This is because, so far, we don't have a way to reliably identify the individual items in inactive menu bars. We can get the window id and owning application, but the crucial missing piece is the title.

As a temporary workaround, the Ice Bar only updates its color while on the active screen. This way, the color of the items at least matches the color of the bar. Attached is a video showing what happens if we don't do this.

### Steps to Reproduce

1. Show the Ice Bar.
2. Drag the Ice Bar onto another screen with a different desktop background.

### Ice Version

0.10.0

### macOS Version

14.5

### Screenshots

https://github.com/jordanbaird/Ice/assets/90936861/a4ba00b4-7611-481b-9272-d552dd0a9ca5

The bottom half of the recording is on the primary screen, while the top half is on the secondary screen. The items on the primary screen are tinted white, and the items on the secondary screen are tinted black. The images in the Ice Bar should change when dragged to the secondary screen, but they remain those of the primary screen.
```

### jordanbaird/Ice #212

- 链接：https://github.com/jordanbaird/Ice/issues/212
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-07T12:56:03Z（UTC）
- 更新时间：2024-07-07T13:02:48Z（UTC）
- 标签：Bug, Ice Bar
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Ice Bar doesn't reliably change color when activated on a new desktop
```

**正文原文**

```markdown
### Check existing and frequent issues

- [X] I have checked existing issues and believe that my issue is not a duplicate
- [X] I have read the [Frequent Issues](https://github.com/jordanbaird/Ice/blob/main/Documentation/FREQUENT_ISSUES.md) document, and my issue is not included there

### Description

When dragging the Ice Bar from one desktop to another, it doesn't update its color. This is expected, and is a workaround to ensure the Ice Bar's background matches the color of its icons (see #211).

However, if the Ice Bar is dragged onto another desktop, closed, then immediately opened again, it still shows the color of the previous desktop's menu bar. This is resolved after a few seconds, but it can be somewhat jarring.

### Steps to Reproduce

1. Drag the Ice Bar onto another desktop.
2. Close the Ice Bar and immediately reopen it.

### Ice Version

0.10.0

### macOS Version

14.5

### Screenshots

https://github.com/jordanbaird/Ice/assets/90936861/279887dc-0a7d-4ed6-a1a5-c7c95ccc8bcb
```

### jordanbaird/Ice #214

- 链接：https://github.com/jordanbaird/Ice/issues/214
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-07T20:01:46Z（UTC）
- 更新时间：2024-07-07T20:01:46Z（UTC）
- 标签：Feature, Ice Bar
- 评论数：0（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Ability to pin Ice Bar
```

**正文原文**

```markdown
### Check existing feature requests

- [X] I have checked existing issues and believe that my feature request is not a duplicate

### Description

Users should be able to pin the Ice Bar to various locations on the screen.

For example:

- Horizontal center
- Vertical center
- Center of screen
- Left of screen
- Right of screen
- Top of screen
- Bottom of screen
- Current location

The pinned position of the bar should be calculated based on a percentage of the screen dimensions, not as an absolute point. This way, it will appear in the same relative position on all screens.

### Screenshots

_No response_
```

### jordanbaird/Ice #216

- 链接：https://github.com/jordanbaird/Ice/issues/216
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-08T10:04:50Z（UTC）
- 更新时间：2024-07-08T10:10:37Z（UTC）
- 标签：Bug, Appearance
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Menu bar appearance shows above Mission Control after deleting a space
```

**正文原文**

```markdown
### Check existing and frequent issues

- [X] I have checked existing issues and believe that my issue is not a duplicate
- [X] I have read the [Frequent Issues](https://github.com/jordanbaird/Ice/blob/main/Documentation/FREQUENT_ISSUES.md) document, and my issue is not included there

### Description

In Mission Control, after a space is deleted, the menu bar appearance overlay is ordered to the front, above the space switcher interface.

### Steps to Reproduce

1. Set a menu bar appearance
2. Open Mission Control
3. Delete the current space

### Ice Version

0.10.0-beta.6

### macOS Version

14.5

### Screenshots

https://github.com/jordanbaird/Ice/assets/90936861/dd74a14d-9f9c-4c35-bc58-160119dee0fa
```

### jordanbaird/Ice #223

- 链接：https://github.com/jordanbaird/Ice/issues/223
- 作者：[kemayo](https://github.com/kemayo)
- 状态：open
- 创建时间：2024-07-09T14:01:18Z（UTC）
- 更新时间：2026-06-21T12:02:55Z（UTC）
- 标签：Feature, Ice Bar
- 评论数：21（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Ability to enable Ice Bar only when on built-in display
```

**正文原文**

```markdown
### CHECK EXISTING ISSUES

- [X] I have searched existing issues, and this feature has not been requested

### Description

The new Ice Bar feature in 0.10 is a great way to avoid icons getting hidden under the notch. However, I only care about that when I'm using my laptop's built-in display -- when I'm using an external monitor I will almost-never have to worry about icons colliding with the application menus.

It would be nice if the Ice Bar setting could be made conditional -- "Use Ice Bar: Yes / No / Only on built-in display". (Or "only when there's a notch", but the built-in displays are generally smaller anyway, so...)

This is similar to #188, in that it's a "depending on whether we're on a screen with a notch" behavior-change. It's possible that a more-comprehensive solution would be to duplicate a large chunk of the behavior / appearance settings into two separate "built-in" / "external" sections.

### Screenshots

_No response_
```

### jordanbaird/Ice #227

- 链接：https://github.com/jordanbaird/Ice/issues/227
- 作者：[kemayo](https://github.com/kemayo)
- 状态：open
- 创建时间：2024-07-09T18:33:41Z（UTC）
- 更新时间：2024-08-18T23:30:26Z（UTC）
- 标签：Feature, Ice Bar
- 评论数：5（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Use Ice Bar as overflow spot for otherwise-hidden menu items
```

**正文原文**

```markdown
### CHECK EXISTING ISSUES

- [X] I have searched existing issues, and this feature has not been requested

### Description

Rather than having the Ice Bar be an all-or-nothing place to show hidden menu items, it would be useful it if could instead be an overflow spot for items that lack room to be displayed -- whether because of the notch or because of application menus.

### Screenshots

_No response_
```

### jordanbaird/Ice #233

- 链接：https://github.com/jordanbaird/Ice/issues/233
- 作者：[fnsign](https://github.com/fnsign)
- 状态：open
- 创建时间：2024-07-10T21:24:02Z（UTC）
- 更新时间：2024-10-09T08:23:12Z（UTC）
- 标签：Bug, Layout
- 评论数：17（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]:  Re-arranging/dragging  items  in the "Hidden" settings pane makes them disappear 
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

When I re-arrange the order of item in the "Hidden" settings pane, it happens that items randomly disappear completely.
This also happens when I drag e.g. an item from the "Visible" to the "Hidden" pane. It disappears completely. Qitting and restarting Ice  don't help.
Might be worth checking this in the "Always-Hidden" pane, too, and dragging item across the panes.
See also attached screenshots of the settings menu and the Ice Bar.


### Steps to Reproduce

1. Open Ice settings an go to "Menu Bar Items"
2. Pick a random item from the "Hidden" pane and drag it to another position.
3. After a few re-arrangemnts randomly a number of items disappear.
4. Pick a random item from the "Visible" pane and drag it to the "hidden" pane, that ten disappears, too.

### Ice Version

0.10.1

### macOS Version

14.5

### Screenshots

![CleanShot 2024-07-10 at 23 00 31](https://github.com/jordanbaird/Ice/assets/25816647/0cecee22-1ac4-49ca-9248-a0acadc44fab)
![CleanShot 2024-07-10 at 23 01 00@2x](https://github.com/jordanbaird/Ice/assets/25816647/2080ae1e-c13b-4bd9-87c8-813f9138d0f3)

```

### jordanbaird/Ice #234

- 链接：https://github.com/jordanbaird/Ice/issues/234
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-10T23:42:27Z（UTC）
- 更新时间：2024-08-16T21:28:31Z（UTC）
- 标签：Bug, Ice Bar, Screen Capture
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Rapidly switching spaces breaks Ice Bar item display
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

Rapidly switching spaces causes the capture of menu bar item images to fail. The images are still being captured, as the Ice Bar is the correct size, but they appear to be transparent. Switching to another space fixes the issue, even when switching back to the space that image capture was breaking on.

### Steps to Reproduce

1. Open and close Ice Bar to verify the presence of item images
2. Switch two spaces over in rapid succession
3. Open the Ice Bar and note the empty space

### Ice Version

0.10.1

### macOS Version

14.5

### Screenshots

https://github.com/jordanbaird/Ice/assets/90936861/ca3c8cc5-04cc-4e90-883e-48c35740455f
```

### jordanbaird/Ice #239

- 链接：https://github.com/jordanbaird/Ice/issues/239
- 作者：[AiHMin](https://github.com/AiHMin)
- 状态：open
- 创建时间：2024-07-12T06:45:58Z（UTC）
- 更新时间：2024-07-13T07:39:03Z（UTC）
- 标签：Bug, Appearance
- 评论数：3（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Some menu bar clip issue while using Menu bar split shape 
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

There are some shape bug in menu bar while using Menu Bar Shape "Split".
- Menu items clipped on screen with a notch when menu items exceeds the left half area.
- Menu items clipped in fullscreen mode on screen with a notch (I think the "split" shape should be disabled when switch to a fullscreen app will be great.)
- Menu bar mistakenly clipped when enter to mission control by using trackpad from a fullscreen app.

### Steps to Reproduce

Just look at the video and follow the cursor

### Ice Version

0.10.2

### macOS Version

14.5 (23F79)

### Screenshots


https://github.com/user-attachments/assets/3c33906d-2f27-4b53-af51-7bf1c09752d0

![CleanShot 2024-07-12 at 14 48 12@2x](https://github.com/user-attachments/assets/896b0f83-7682-4362-8ab2-590901e0adab)


```

### jordanbaird/Ice #240

- 链接：https://github.com/jordanbaird/Ice/issues/240
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-13T15:14:16Z（UTC）
- 更新时间：2025-09-18T11:27:10Z（UTC）
- 标签：Feature
- 评论数：7（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Showing hidden items replaces visible items
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

Opening this issue to merge multiple similar issues (#45 and #68).

With this feature enabled, showing the hidden section (no matter the method) should hide the visible section, effectively swapping their positions. This feature could also be extended to the always-hidden section, although we'd need to decide the exact behavior there.

### Screenshots

_No response_
```

### jordanbaird/Ice #241

- 链接：https://github.com/jordanbaird/Ice/issues/241
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-13T16:06:31Z（UTC）
- 更新时间：2024-07-13T16:06:32Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Gap in menu bar items on inactive display when showing hidden section
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

When the hidden section is shown with the "Show section dividers" setting disabled, there is a gap where the section divider otherwise would be. The bug does not appear on the active screen.

### Steps to Reproduce

1. Disable "Show section dividers"
2. Show the hidden section while using two displays
3. Note the gap between sections on the inactive display

### Ice Version

0.10.2

### macOS Version

14.5

### Screenshots

![SCR-20240713-izqa](https://github.com/user-attachments/assets/7ecb1006-60c1-4907-af4e-dcb341d3e867)
```

### jordanbaird/Ice #242

- 链接：https://github.com/jordanbaird/Ice/issues/242
- 作者：[Xytronix](https://github.com/Xytronix)
- 状态：open
- 创建时间：2024-07-13T16:16:47Z（UTC）
- 更新时间：2024-07-13T16:34:58Z（UTC）
- 标签：Feature, Profiles
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Ability to have unique menubars for each display
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

When using two monitors, there could be an option to show different menubars on each display.
I don't know if this would be possible.

This could be handy in combination with menubar widgets.

### Screenshots

_No response_
```

### jordanbaird/Ice #243

- 链接：https://github.com/jordanbaird/Ice/issues/243
- 作者：[Xytronix](https://github.com/Xytronix)
- 状态：open
- 创建时间：2024-07-13T16:31:34Z（UTC）
- 更新时间：2024-09-07T18:36:23Z（UTC）
- 标签：Feature, Widgets
- 评论数：3（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Menu Bar Widget Ideas
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

I didn't find the menu bar widgets thread if there was any.

Ideas would be:
- Time (dropdown or different menu bar icons) 
- Example: Menu World Time
- Temperature ( Temperature for different areas)
- Is it raining today (similar to ios lock screen widget), if not when next?
(- A lot of widgets from ios lockscreen could be an idea)
- System information (CPU, RAM, Storage etc.)
- Calendar events
- Meeting information
- Timer, clock, countdown, stopwatch
- How long is the display active? How long are you working on X application?
-  Reminders
- Create Text field, option to color it
- Music info, what is playing right now
- Focus mode how long active
- Battery (if so perhaps accessory too)
- Shortcuts quick launch
- Ice quick actions
- Open App X
- Stocks
- Route to destination
- X new emails
- X new messages

A lot of these things have already been done by third party authors.




### Screenshots

_No response_
```

### jordanbaird/Ice #244

- 链接：https://github.com/jordanbaird/Ice/issues/244
- 作者：[allyson-c](https://github.com/allyson-c)
- 状态：open
- 创建时间：2024-07-16T00:19:01Z（UTC）
- 更新时间：2024-08-12T09:49:38Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: App shows up in non-hidden bar even after hidden
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

Cleanshot app shows up in the Non-Hidden Ice bar even after hidden once opened again

### Steps to Reproduce

1. Hide Cleanshot in the Ice Bar settings
2. Open Cleanshot through any means (Alfred, Mac Search Bar, Applications)
3. Cleanshot will now show up in the non-hidden bar permanently again

### Ice Version

0.10.2

### macOS Version

Version 14.5 (23F79)

### Screenshots



https://github.com/user-attachments/assets/4328c052-3d99-4712-aa8e-67d108b90b79



```

### jordanbaird/Ice #245

- 链接：https://github.com/jordanbaird/Ice/issues/245
- 作者：[YousufSSyed](https://github.com/YousufSSyed)
- 状态：open
- 创建时间：2024-07-16T17:48:52Z（UTC）
- 更新时间：2024-07-16T17:48:52Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Allow setting SF Symbols for when the icon is toggled
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

https://developer.apple.com/sf-symbols/

Right now you can only select from preset images and image files. It would be nice if users could enter in SF Symbol names when the icon is enabled or not.

### Screenshots

![CleanShot 2024-07-16 at 13 47 59@2x](https://github.com/user-attachments/assets/7215942c-0466-4777-9529-938d14b672ee)

```

### jordanbaird/Ice #246

- 链接：https://github.com/jordanbaird/Ice/issues/246
- 作者：[YousufSSyed](https://github.com/YousufSSyed)
- 状态：open
- 创建时间：2024-07-16T17:50:45Z（UTC）
- 更新时间：2024-08-26T04:40:24Z（UTC）
- 标签：Bug
- 评论数：7（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Ice doesn't open its settings when double clicking its app icon on macOS 15
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

Right now the only way to open Ice's settings is to right click on the icon which isn't intuitive. What some Mac apps do is show the settings for their app after the user double click's / "opens" the app while the app is already opened.

### Screenshots

_No response_
```

### jordanbaird/Ice #252

- 链接：https://github.com/jordanbaird/Ice/issues/252
- 作者：[pitzaman](https://github.com/pitzaman)
- 状态：open
- 创建时间：2024-07-18T06:29:18Z（UTC）
- 更新时间：2024-08-08T08:23:44Z（UTC）
- 标签：Feature, Improvement
- 评论数：2（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: RTL support 
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

Please consider adding support for rtl languages. When macOS is set to Hebrew, the OS is aligned to the right.
That means that ice is flipped...

### Screenshots

![Screenshot of Safari at 18 Jul 2024 at 9_28_04](https://github.com/user-attachments/assets/93da8543-0a3a-4eba-bbac-565023ddce3d)

```

### jordanbaird/Ice #254

- 链接：https://github.com/jordanbaird/Ice/issues/254
- 作者：[ReagentX](https://github.com/ReagentX)
- 状态：open
- 创建时间：2024-07-19T19:52:15Z（UTC）
- 更新时间：2024-08-16T21:26:20Z（UTC）
- 标签：Bug, Ice Bar, Screen Capture
- 评论数：3（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: Transparent items in Ice Bar while in fullscreen mode
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

Image: 

<img width="436" alt="image" src="https://github.com/user-attachments/assets/0b338002-0604-4713-9709-a6c7583ea0b5">

Video: 

https://github.com/user-attachments/assets/3d89bb29-4da7-4354-9657-d3eff7f1c9ae

The buttons still work, the images/icons just disappear.

### Steps to Reproduce

1. Open an app in full screen mode 
2. Activate the Ice Bar

### Ice Version

0.10.2

### macOS Version

14.5 (23F79)

### Screenshots

_No response_
```

### jordanbaird/Ice #260

- 链接：https://github.com/jordanbaird/Ice/issues/260
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-21T19:04:49Z（UTC）
- 更新时间：2024-07-21T19:04:49Z（UTC）
- 标签：Bug, Ice Bar, Appearance
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Both inset menu bar shape and Ice Bar are too short on notched display when set to a lower resolution
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

When using the inset shape on a display with a notch, with the resolution set to a smaller size, (i.e. 1168x755), the menu bar appearance overlay is drawn too short, to the point where it cuts off the items. This also affects the Ice Bar.

### Steps to Reproduce

1. Enable the split shape menu bar appearance.
2. Check "Use inset shape on screens with notch".
3. Set resolution of notched display to a lower resolution.
4. Note the vertically cut off menu bar items.
5. Open the Ice Bar.
6. Note the vertically cut off menu bar items.

### Ice Version

0.10.3

### macOS Version

14.5

### Screenshots

<img width="1167" alt="image" src="https://github.com/user-attachments/assets/dacac751-c48a-425b-9716-269a01eb4d2a">
```

### jordanbaird/Ice #272

- 链接：https://github.com/jordanbaird/Ice/issues/272
- 作者：[nasyxx](https://github.com/nasyxx)
- 状态：open
- 创建时间：2024-07-27T06:01:13Z（UTC）
- 更新时间：2024-07-27T07:00:38Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Extra spaces in iPad sidecar.
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

There are lots of extra spaces in iPad sidecar display.

<img width="720" alt="Screenshot 2024-07-27 at 12 56 45 AM" src="https://github.com/user-attachments/assets/d4086662-323e-483f-9faa-d6befb95ec98">


### Steps to Reproduce

Simply use a iPad pro the macOS second display.

And the issue comes out.

### Ice Version

0.10.3

### macOS Version

macOS 15 beta 4

### Screenshots

_No response_
```

### jordanbaird/Ice #273

- 链接：https://github.com/jordanbaird/Ice/issues/273
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-07-27T07:04:17Z（UTC）
- 更新时间：2024-08-16T21:25:46Z（UTC）
- 标签：Feature, Screen Capture
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Custom refresh rate for menu bar item images
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

Currently, images of menu bar items in the Ice Bar, and Menu Bar Items settings refresh at a rate of once every 3 seconds. Ice should have a setting to change this so users can customize the accuracy of the images that are displayed.

### Screenshots

_No response_
```

### jordanbaird/Ice #283

- 链接：https://github.com/jordanbaird/Ice/issues/283
- 作者：[ilyagr](https://github.com/ilyagr)
- 状态：open
- 创建时间：2024-08-01T00:01:15Z（UTC）
- 更新时间：2024-08-02T20:31:41Z（UTC）
- 标签：Bug, Layout
- 评论数：6（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Ice's view of the menu bar is missing the icon for AltTab
```

**正文原文**

```markdown
**Update:** A new version of Ice dropped 🎉 as I was writing this with some promising changes in the changelog. Feel free to close this if you know it's fixed; I'll reopen it if I see the problem with the new version. Thanks for the continued improvements :) 👍 

### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

There is an icon in my menu bar that is not in Ice's view of the menu bar or the hidden bar. My goal was to move the icon to the menu bar, but I can't do it.

I'm assuming restarting Ice will solve this.


### Steps to Reproduce

I am not sure how to reliably reproduce this, but here is a screenshot:

<img width="900" alt="image" src="https://github.com/user-attachments/assets/eac5a8c5-6ef4-4e65-98d0-cdac0cbcb1d0">

I read somewhere that the Ice view is supposed to refresh every 3 seconds, but this discrepancy seems permanent.

**Update:** Moreover, the Steam icon in the hidden bar does not work, and I don't think Steam is running (it was running previously, but I quit it). That's another discrepancy that's probably related.

### Ice Version

0.10.3

### macOS Version

14.5

### Screenshots

_No response_
```

### jordanbaird/Ice #286

- 链接：https://github.com/jordanbaird/Ice/issues/286
- 作者：[kappesante](https://github.com/kappesante)
- 状态：open
- 创建时间：2024-08-02T04:24:50Z（UTC）
- 更新时间：2024-08-02T05:56:49Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Show on click/scroll not working on non-fullscreen, auto-hidden menu bar
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have searched existing issues, and this issue is not a duplicate

### Description

I can see the scroll and the click triggers only working if the focus application is fullscreen. If not, i have to click on the ice menu item to show the hidden items.
At this point it may not be a bug, it may work as intended, but it was working until 0.10.2 maybe.

### Steps to Reproduce

1. having the focus application not in fullscreen
2. having the menubar auto hidden

### Ice Version

0.10.4

### macOS Version

14.5

### Screenshots

[https://www.loom.com/share/58bdb6fdec894daf88414cc10d656966?sid=d8283df9-164d-46aa-bf90-74d9d389890f](url)
```

### jordanbaird/Ice #291

- 链接：https://github.com/jordanbaird/Ice/issues/291
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-08-03T04:55:51Z（UTC）
- 更新时间：2025-01-06T14:49:32Z（UTC）
- 标签：Feature, Hotkeys
- 评论数：2（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Hotkeys for individual menu bar items
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Ice should have the ability to temporarily show individual items when the user presses a custom hotkey that they choose. Groups (once we have them) could also be shown using this approach.

### Screenshots

_No response_
```

### jordanbaird/Ice #299

- 链接：https://github.com/jordanbaird/Ice/issues/299
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-08-06T02:25:17Z（UTC）
- 更新时间：2025-05-23T18:23:18Z（UTC）
- 标签：Feature
- 评论数：7（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Always show hidden items if monitor screen is larger than <enter resolution>
```

**正文原文**

```markdown
### Discussed in https://github.com/jordanbaird/Ice/discussions/294

<div type='discussions-op-text'>

<sup>Originally posted by **jalurgemilang** August  3, 2024</sup>
I feel that this feature is very useful for users who have ultrawide monitors or, using multiple monitors of different sizes. In ultrawide monitors, the hidden items are always shown. On the secondary, smaller monitor, they are hidden.</div>
```

### jordanbaird/Ice #300

- 链接：https://github.com/jordanbaird/Ice/issues/300
- 作者：[clesenski](https://github.com/clesenski)
- 状态：open
- 创建时间：2024-08-06T12:20:25Z（UTC）
- 更新时间：2025-09-23T05:47:13Z（UTC）
- 标签：Bug, Layout
- 评论数：3（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Rearranging icons with multiple instances of OneDrive
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When using multiple instances of Microsoft OneDrive, intermittently, one of the OneDrive menu bar items will disappear from Menu Bar Items.

### Steps to Reproduce

1. Install OneDrive
2. Sign in to a Personal account
3. Sign in to a second account such as a Business account
4. Add both items to the Hidden menu
5. Attempt to rearrange icons from Ice > Menu Bar Items

You will note that intermittently, one of the two icons will disappear when rearranging. Navigating to a different tab like General or About and navigating back to Menu Bar Items will result in both icons reappearing.

### Ice Version

0.10.4

### macOS Version

14.6

### Screenshots

<img width="900" alt="Screenshot 2024-08-06 at 8 02 45 AM" src="https://github.com/user-attachments/assets/1d5bce64-917c-4e0f-9f84-e7f63825b80a">

```

### jordanbaird/Ice #303

- 链接：https://github.com/jordanbaird/Ice/issues/303
- 作者：[rowesk](https://github.com/rowesk)
- 状态：open
- 创建时间：2024-08-07T09:17:39Z（UTC）
- 更新时间：2024-11-14T12:19:49Z（UTC）
- 标签：Feature, Ice Bar
- 评论数：3（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Use Ice Bar only when screen size is smaller than <enter resolution>
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Similar to #299 - Would be very useful for those of us that switch between Macbooks and larger screen sizes.

On a laptop screen (especially with a notch), I have just enough apps that when the always-hidden icons are shown some get cut off, the Ice Bar works perfectly for this use case, but the hidden apps (IMO) looks more aesthetically pleasing on larger screens when expanded inside the menu bar.

If new default/size settings aren't possible or this is an edge case, a keyboard shortcut to toggle the Ice Bar would allow similar functionality when combined with BTT/KM.

### Screenshots

_No response_
```

### jordanbaird/Ice #310

- 链接：https://github.com/jordanbaird/Ice/issues/310
- 作者：[pskowronek](https://github.com/pskowronek)
- 状态：open
- 创建时间：2024-08-10T23:01:32Z（UTC）
- 更新时间：2025-03-21T08:27:53Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Allow a section to be hidable to show what's on the left
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

A feature request: Allow a section to be hidable i.e. not only everything to left, but only part (a section).

Add possibility to select/mark a section of icons that be could be made hidden temporarily.

Use case - having mac 13 or 14" and opened application with wide menu, the menu items disappear on the left side. Another use-case is macbook with notch, when if you have something like Menu Meters and a couple of other menubar apps they quickly disappear under the notch. If there was an option in Ice to collapse a section, then icons on the left could be now visible and accessible when section collapsed. Very helpful if you have Menu Meters (cpu/mem gauges) and still you have some apps that you would like to be able to use.

### Screenshots

_No response_
```

### jordanbaird/Ice #312

- 链接：https://github.com/jordanbaird/Ice/issues/312
- 作者：[SteveMattan](https://github.com/SteveMattan)
- 状态：open
- 创建时间：2024-08-12T16:33:33Z（UTC）
- 更新时间：2024-08-26T12:17:11Z（UTC）
- 标签：Bug, Screen Capture
- 评论数：5（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: No items in Menu Bar
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

There are times when I involve Ice, to reveal the hidden bar, and I see only an empty bar. There are no icons in the bar. When I then open the settings for Ice I see no items in any of the three bars. Note that the always visible items are displayed. Quoting and relaunching Ice resolves the issue.

### Steps to Reproduce

Unfortunately I do not know how to reproduce this issue.

### Ice Version

0.10.4

### macOS Version

14.6.1

### Screenshots

![Screenshot 2024-08-12 at 7 37 19 AM](https://github.com/user-attachments/assets/2b78158b-ba41-4648-8bae-4e1607c416e7)
![Screenshot 2024-08-12 at 7 39 08 AM](https://github.com/user-attachments/assets/f58fe8a5-69bf-4eb3-b128-8f4223bbf752)

```

### jordanbaird/Ice #316

- 链接：https://github.com/jordanbaird/Ice/issues/316
- 作者：[cab11918](https://github.com/cab11918)
- 状态：open
- 创建时间：2024-08-15T08:59:22Z（UTC）
- 更新时间：2024-08-15T12:59:06Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Items rehidden after selecting "Show the Hidden Section" in Ice icon menu with "Show on hover" setting enabled
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

so if you right click the ice icon in menubar and you select show hidden icons, the icons are basically gonna appear and gone. probably caused by if cases based on mouse position

### Steps to Reproduce

1. turn on hover option
2. right click ice icon
3. select show hidden icons

### Ice Version

0.10.4

### macOS Version

14.4.1

### Screenshots

_No response_
```

### jordanbaird/Ice #321

- 链接：https://github.com/jordanbaird/Ice/issues/321
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-08-16T21:19:19Z（UTC）
- 更新时间：2024-08-16T21:19:19Z（UTC）
- 标签：Feature, Improvement
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Animation when showing items
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

### Discussed in https://github.com/jordanbaird/Ice/discussions/257

<div type='discussions-op-text'>

<sup>Originally posted by **johnmiles27** July 20, 2024</sup>
How hard would it be to implement some subtle animation of menubar icons sliding out to the left when Ice is triggered as the app Vanilla does? (example of what I'm talking about here: https://www.macstories.net/roundups/managing-your-mac-menu-bar-a-roundup-of-my-favorite-bartender-alternatives/ ). It's a nice little touch IMO, looks very nice. Maybe even a bit of a fade in too while sliding in would look even better</div>

### Screenshots

_No response_
```

### jordanbaird/Ice #326

- 链接：https://github.com/jordanbaird/Ice/issues/326
- 作者：[magoz](https://github.com/magoz)
- 状态：open
- 创建时间：2024-08-18T13:32:05Z（UTC）
- 更新时间：2026-09-30T10:24:23Z（UTC）
- 标签：Feature
- 评论数：11（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Custom configuration path / export settings
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I have several computers, and I'd like them to share the same configuration.

It would be awesome to point to `~/.config/ice` or any other path and load the configuration.

Alternatively, is there a way to export the current configuration?

### Screenshots

_No response_
```

### jordanbaird/Ice #329

- 链接：https://github.com/jordanbaird/Ice/issues/329
- 作者：[philocalyst](https://github.com/philocalyst)
- 状态：open
- 创建时间：2024-08-21T00:03:35Z（UTC）
- 更新时间：2024-09-13T06:30:29Z（UTC）
- 标签：Bug, Performance
- 评论数：5（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: When turning off "Show ice icon" and the turning it back on, the icon doesn't automatically repopulate
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When toggling, it takes a reselect of the item or hover for the icon the reappear. 

### Steps to Reproduce

1. General
2. Show ice icon (toggle)
3. Show ice icon (toggle)
4. Gasp

### Ice Version

10.5

### macOS Version

14.6.1 (23G93)

### Screenshots

_No response_
```

### jordanbaird/Ice #330

- 链接：https://github.com/jordanbaird/Ice/issues/330
- 作者：[tshu-w](https://github.com/tshu-w)
- 状态：open
- 创建时间：2024-08-21T08:11:16Z（UTC）
- 更新时间：2024-09-30T15:30:07Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Can not work with Focus Menu Bar Item (https://heyfocus.com)
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

If I move the menu bar of focus.app to Ice `Hidden Menu Bar Items`, the following window and hidden menu bar disappear immediately when I click the focus menu bar.

Everything works fine when I put the focus menu bar in `Visible Menu Bar Items`.

![Screenshot 2024-08-21 at 16 05 55](https://github.com/user-attachments/assets/2604ff0e-8cef-4d04-b624-6f489ebdca28)


### Steps to Reproduce

1. Move Focus menu bar icon to "Hidden Menu Bar Items"
2. Click on Empty menu bar
3. Click Focus Icon

### Ice Version

0.10.5

### macOS Version

14.6.1

### Screenshots

_No response_
```

### jordanbaird/Ice #331

- 链接：https://github.com/jordanbaird/Ice/issues/331
- 作者：[je-kizer](https://github.com/je-kizer)
- 状态：open
- 创建时间：2024-08-22T05:53:31Z（UTC）
- 更新时间：2024-09-12T21:32:09Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Hidden icons cannot be displayed when menu bar automatically hidden while in full screen
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When menu bar is set to hide automatically in full screen apps, hidden icons will not appear while viewing full screen apps. This occurs when "Automatically hide and show the menu bar" is set to "Always" or "In Fully Screen Only," and applies to any of the "Show on..." methods in Ice (click, hover, and scroll). See screen recording.

Perhaps unrelated, but occasionally the menu bar shape settings are applied to full screen apps, revealing part of the desktop background. See screenshot. When this happens, sometimes hidden icons disappear/reappear as normal. This seems to occur at random.

### Steps to Reproduce

1. In System Settings, set "Automatically hide and show the menu bar" to "Always" or "In Fully Screen Only."
2. In Ice settings, turn on "Show on click," "Show on hover," or "Show on scroll."
3. Open any app in full screen mode.
4. Move cursor to menu bar area so the menu bar appears.
5. Click, hover, or scroll to attempt to display hidden menu bar items via Ice. Nothing happens.

### Ice Version

0.10.5

### macOS Version

14.6.1

### Screenshots


https://github.com/user-attachments/assets/607011f9-b68c-4d94-8250-561741d8d014

<img width="1710" alt="Screenshot 2024-08-21 at 10 26 18 PM" src="https://github.com/user-attachments/assets/99e8a4b6-571a-4726-9671-8e298a444c03">

```

### jordanbaird/Ice #334

- 链接：https://github.com/jordanbaird/Ice/issues/334
- 作者：[hua-en](https://github.com/hua-en)
- 状态：open
- 创建时间：2024-08-23T09:08:14Z（UTC）
- 更新时间：2026-01-07T12:07:26Z（UTC）
- 标签：Bug, Performance
- 评论数：6（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Ice has noticeable energy impact during mouse movement
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Ice appears to consume more energy in activity monitor when the cursor is moved. This seems to be due to cpu usage increasing when the cursor is moved. This might be problematic since the cursor is moved fairly frequently in daily use.

### Steps to Reproduce

1. Open Ice.
2. Open Activity Monitor and go to the Energy tab.
3. Wait for Ice's energy usage to drop to 0.0 by keeping the cursor still.
4. Move the cursor.
5. The energy impact of Ice should increase from 0 briefly, before dropping back to 0.

### Ice Version

0.10.5

### macOS Version

14.6.1

### Screenshots

Energy usage increasing with mouse cursor movement:
https://github.com/user-attachments/assets/7b9e106a-777f-4e0e-a639-c008dcdfa16b

CPU usage increasing with mouse cursor movement:
https://github.com/user-attachments/assets/f76f3f25-b665-4863-8386-8ac39631e860
```

### jordanbaird/Ice #335

- 链接：https://github.com/jordanbaird/Ice/issues/335
- 作者：[radical-ed](https://github.com/radical-ed)
- 状态：open
- 创建时间：2024-08-26T09:29:56Z（UTC）
- 更新时间：2024-09-29T23:09:18Z（UTC）
- 标签：Feature, Ice Bar
- 评论数：2（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Ice Bar only for Always Hidden
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I kinda like the Ice Bar feature, i.e. the ability to show menu bar items in a separate bar below the menu. However it would be nice if we could somehow combine it with the standard menu bar. For example:

- Show Hidden section in the menubar, i.e. "standard" placement
- Show Always-hidden section on a separate bar below menu

I like the standard menu bar for my used items, however I have a couple of items in the always hidden section and when I show them, 1 or 2 is overlapping the notch on my MacBook.

### Screenshots

_No response_
```

### jordanbaird/Ice #336

- 链接：https://github.com/jordanbaird/Ice/issues/336
- 作者：[allyson-c](https://github.com/allyson-c)
- 状态：open
- 创建时间：2024-08-29T07:22:21Z（UTC）
- 更新时间：2024-08-29T18:19:30Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Split Type Ice Bar keeps the wallpaper from the previous space when switching spaces/screens
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When you switch between spaces with different wallpapers, if you use the split shape, you sometimes run into an issue where Ice Bar will keep the wallpaper background from the previous space screen. Sometimes it goes away if you click the bar, sometimes it stays as-is for the remainder of the time, until you switch between screens again.

### Steps to Reproduce

1. Go to Space 1 (Background 1)
2. Open up the space switcher (where you can see all spaces)
3. Swipe to Space 2 (Background 2)
4. Ice Bar will keep Background 1 underneath and overlay with the new Background 2 color

### Ice Version

0.10.5

### macOS Version

14.6.1 (23G93)

### Screenshots

![Bug - With Application](https://github.com/user-attachments/assets/4c5b0bae-76a5-420f-af5b-8ea05313ff67)
![Bug - Without Application](https://github.com/user-attachments/assets/f0e75f8e-bc14-457b-b2dd-997b4c470b23)
![What It Should Look Like](https://github.com/user-attachments/assets/888cc6cc-e69a-46c8-b895-c27372c413ff)


https://github.com/user-attachments/assets/cb6cf7bd-1f74-4647-bd43-48f23cb51d47

```

### jordanbaird/Ice #337

- 链接：https://github.com/jordanbaird/Ice/issues/337
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-08-29T11:34:19Z（UTC）
- 更新时间：2024-08-29T11:34:20Z（UTC）
- 标签：Bug, Appearance
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Menu bar appearance uses wallpaper from previous space when swiping through spaces in Mission Control
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

A similar issue (#336) was opened by @allyson-c, whose account seems to have been deleted, along with all their issues. It is a legitimate bug which I can reproduce. I'm opening this so it gets tracked.

When switching to a space with a different wallpaper, and using a split or rounded menu bar appearance, the menu bar overlay will be drawn with the wallpaper from the from the initial space. Note that this only seems to happen if you first open Mission Control, then swipe to another space.

### Steps to Reproduce

1. Go to Space 1 (Wallpaper 1)
2. Open Mission Control
3. Swipe to Space 2 (Wallpaper 2)
4. Menu bar will keep Wallpaper 1 underneath and overlay with the new Wallpaper 2 color

### Ice Version

0.10.5

### macOS Version

14.6.1

### Screenshots

With application:
![With application](https://github.com/user-attachments/assets/4a192119-d4b7-4c2e-a2e2-cc12232fa03d)

Without application:
![Without application](https://github.com/user-attachments/assets/4a854805-031a-45cc-ba54-afcb5d7efec4)

What it should look like:
![What it should look like](https://github.com/user-attachments/assets/93c95bed-60ec-4ce1-b3f5-48e404be313b)

Screen recording:
https://github.com/user-attachments/assets/1e49c48c-e44e-4130-be9b-55e19ea3aa03
```

### jordanbaird/Ice #340

- 链接：https://github.com/jordanbaird/Ice/issues/340
- 作者：[venpopov](https://github.com/venpopov)
- 状态：open
- 创建时间：2024-08-30T07:28:49Z（UTC）
- 更新时间：2024-09-29T23:08:14Z（UTC）
- 标签：Feature, Ice Bar, Hotkeys
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Show ice bar next to mouse in any screen location with keyboard shortcut
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

If you want to activate a menu item or see the ice bar without moving your mouse to the top of the screen, it would be very useful to have a floating ice bar that can appear right below the mouse when you activate a keyboard shortcut. That way you could even map a mouse button (e.g. button 5) to show the ice bar next to your cursor wherever it is. That would be really useful

### Screenshots

_No response_
```

### jordanbaird/Ice #342

- 链接：https://github.com/jordanbaird/Ice/issues/342
- 作者：[dotwilliam](https://github.com/dotwilliam)
- 状态：open
- 创建时间：2024-09-01T19:44:46Z（UTC）
- 更新时间：2026-03-23T20:50:57Z（UTC）
- 标签：Feature
- 评论数：5（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Display menu bar items as a vertical list
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

An overlooked quality-of-life feature that I have never found in any menu bar manager is the ability to display all menu bar items as a vertical list, including the bar icon and **item name**.

My wish would be to hide 90% of my menu bar items, but display my menu bar manager icon in the menu bar. Clicking on that item would present a vertical list view of all my menu bar services with not only their icon but also the service name, so I can more quickly pinpoint what I need and select it from the list. Displaying the name is critical because I have 30+ menu bar items and struggle to immediately recall which icon I'm looking for in order to activate the item I have in mind. To make matters worse, a number of utilities don't make it obvious what they are/do even when clicked because their only options include vague "Settings" and "About" instead of something more useful like "About _app-name_."

Because most menu bar items present sub-menus when clicked, it would be banger if these sub-menus are displayed when clicking a menu bar item from the drop down list.

I will happily sponsor Jordan if this feature is added!

### Screenshots

_No response_
```

### jordanbaird/Ice #344

- 链接：https://github.com/jordanbaird/Ice/issues/344
- 作者：[Alessandrx204](https://github.com/Alessandrx204)
- 状态：open
- 创建时间：2024-09-04T11:18:27Z（UTC）
- 更新时间：2026-07-06T12:36:18Z（UTC）
- 标签：Bug, Profiles
- 评论数：53（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Menu bar items move to hidden or always hidden section
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

whenever the mac is restarted  all ice icons go to the always hidden section



### Steps to Reproduce

turn on ice bar
restart yor mac
check ice bar

### Ice Version

0.10.5

### macOS Version

14.6.1

### Screenshots

<img width="89" alt="Screenshot 2024-09-04 alle 13 12 00" src="https://github.com/user-attachments/assets/db9f1ba0-732b-467a-8e72-1ec589835089">
<img width="686" alt="Screenshot 2024-09-04 alle 13 17 14" src="https://github.com/user-attachments/assets/e0fcebef-0e63-4ee1-88f3-4fb4de7f5fc5">

```

### jordanbaird/Ice #359

- 链接：https://github.com/jordanbaird/Ice/issues/359
- 作者：[glgray](https://github.com/glgray)
- 状态：open
- 创建时间：2024-09-18T16:35:56Z（UTC）
- 更新时间：2024-09-19T17:15:47Z（UTC）
- 标签：Bug, Appearance
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Menubars are not correct with external display on MacBook Pro
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When I use an external display with my MacBook Pro (with notch), on the exteral display (no notch), the split is wider than it should be (see first screen shot). On the MBP display, there is no split (see second screen shot). The menubar split on the built-in display of the MBP returns if it is the active display.

### Steps to Reproduce

1. Attach external display to MacBook Pro with notch.

### Ice Version

0.11.2

### macOS Version

15.0

### Screenshots

<img width="842" alt="image" src="https://github.com/user-attachments/assets/ee1d60c0-5285-4220-a465-88be8d620387">

![image](https://github.com/user-attachments/assets/0118276a-09a2-4e7e-ba50-3625a3c4b823)

```

### jordanbaird/Ice #368

- 链接：https://github.com/jordanbaird/Ice/issues/368
- 作者：[musiklee](https://github.com/musiklee)
- 状态：open
- 创建时间：2024-09-21T15:15:04Z（UTC）
- 更新时间：2026-01-14T15:18:06Z（UTC）
- 标签：Feature, Appearance
- 评论数：3（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Menu Bar Appearance for Hidden Sections
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

exactly as title says, 

I would LOVE to be able to customize colors, borders, etc for both the Hidden Section, and the Always Hidden Sections,
so when i view my Ice Bar, these 2 show in different colors, than does the main Visible Section, 

i think this would even look good without using Ice Bar, (all on top row different colors...)

thoughts?  hard to implement? 

### Screenshots

_No response_
```

### jordanbaird/Ice #372

- 链接：https://github.com/jordanbaird/Ice/issues/372
- 作者：[musiklee](https://github.com/musiklee)
- 状态：open
- 创建时间：2024-09-23T20:09:03Z（UTC）
- 更新时间：2024-09-29T23:04:59Z（UTC）
- 标签：Feature, Ice Bar, Improvement
- 评论数：2（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Ability to see both hidden sections at the same time when using the Ice Bar
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

i can only see all 3 Sections @ once when not using Ice Bar,
when using Ice Bar,  revealing Always Hidden, closes Hidden, and vice-versa.
i'd love to see all 3,  
the Always Hidden could either be to the left of Hidden,  or perhaps on a 3rd row on its own?

Jordan,  hoping you and yours are ok!

### Steps to Reproduce

description explains this

### Ice Version

0.11.3

### macOS Version

14.4.1

### Screenshots

_No response_
```

### jordanbaird/Ice #378

- 链接：https://github.com/jordanbaird/Ice/issues/378
- 作者：[eyelessjerry](https://github.com/eyelessjerry)
- 状态：open
- 创建时间：2024-09-25T21:01:44Z（UTC）
- 更新时间：2026-07-04T19:48:47Z（UTC）
- 标签：Feature, Improvement
- 评论数：17（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Show all menu bar items as default
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

It would be better if one could show all menu bar items by default – instead of having to add them manually to Visible items, it would be better to drag them the other way. Maybe there is already a way to have the menu bar default to showing all items without having to add them manually to visible items?

### Screenshots

_No response_
```

### jordanbaird/Ice #380

- 链接：https://github.com/jordanbaird/Ice/issues/380
- 作者：[ghost](https://github.com/ghost)
- 状态：open
- 创建时间：2024-09-26T15:51:59Z（UTC）
- 更新时间：2024-09-29T23:01:39Z（UTC）
- 标签：Feature, Appearance
- 评论数：2（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Can we send shadow to back?
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I was not sure whether to file this as a bug or feature request.

I wish to know if we can send menu bar shadow to back, so that it doesn't draw over window titlebars?

I provided screenshot of what I mean below.

Thank you in advance.

### Screenshots

<img width="1440" alt="image" src="https://github.com/user-attachments/assets/3812c9ed-1242-4dde-9f9b-f74f4e6ca2e7">

```

### jordanbaird/Ice #382

- 链接：https://github.com/jordanbaird/Ice/issues/382
- 作者：[alkene5](https://github.com/alkene5)
- 状态：open
- 创建时间：2024-09-29T19:19:14Z（UTC）
- 更新时间：2024-10-05T14:47:05Z（UTC）
- 标签：Feature
- 评论数：3（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Add AppleScript or CLI support
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Shortcut keys are very limited

### Screenshots

_No response_
```

### jordanbaird/Ice #383

- 链接：https://github.com/jordanbaird/Ice/issues/383
- 作者：[whme](https://github.com/whme)
- 状态：open
- 创建时间：2024-09-30T07:12:24Z（UTC）
- 更新时间：2025-06-10T15:20:08Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Disabling displays have separate spaces not working
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

With the Mac OS system setting "displays have separate spaces" disabled, and multiple displays connected, the system menu bar is only visible on the primary display:
![image](https://github.com/user-attachments/assets/4a685fe2-db30-44b6-9973-a8b7247b5308)
Ice does not detect this and thinks the menu bar is still available on all displays causing multiple issues:
* right clicking a window where the menu bar would be open the Ice / Menu bar context menu 
<img width="320" alt="image" src="https://github.com/user-attachments/assets/6a6cea82-fbad-4d13-8e8d-52a16b56a831">

* With the Ice setting "Show on hover" enabled, the hidden menu bar items are being shown when hovering the top of the screen on displays without menu bar

### Steps to Reproduce

1. Disable "displays have separate spaces" under "System Preferences" -> "Desktop & Docker" -> "Mission Control" -> "Displays have separate Spaces"
2. Reboot (for the system setting to take effect)
3. Make sure multiple external displays are connected
4. Launch Ice and
4.1. right click the very top of the screen on a display not showing the System Menu Bar
4.2. hover over the very top of the screen on a display not showing the System Menu Bar

### Ice Version

0.11.3

### macOS Version

15.0

### Screenshots

_No response_
```

### jordanbaird/Ice #397

- 链接：https://github.com/jordanbaird/Ice/issues/397
- 作者：[illusian](https://github.com/illusian)
- 状态：open
- 创建时间：2024-10-09T19:43:57Z（UTC）
- 更新时间：2025-09-27T10:25:22Z（UTC）
- 标签：Bug
- 评论数：8（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Dock icon appears when using Always hidden feature.
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

The Ice dock icon appears when clicking the icon icon to show hidden icons when always hide enabled in advanced settings. This issue won't reproduce when "always hide" is disabled.
I tried with a fresh install, but the same issue persists.

### Steps to Reproduce

1. Settings.
2. Enable "always-hidden" section.
3. Click the Ice icon to show the hidden section. (Not always hidden section)

### Ice Version

0.11.9

### macOS Version

15.0.1

### Screenshots

_No response_
```

### jordanbaird/Ice #401

- 链接：https://github.com/jordanbaird/Ice/issues/401
- 作者：[jordanbaird](https://github.com/jordanbaird)
- 状态：open
- 创建时间：2024-10-11T15:07:23Z（UTC）
- 更新时间：2024-10-11T15:07:24Z（UTC）
- 标签：Bug, Ice Bar
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Ice Bar appears and will not disappear when using "Show on hover" with a delay set to 0
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When the "Show on hover" setting is enabled, and the "Show on hover delay" advanced setting is set to 0, the Ice Bar sporadically appears and will not disappear without manually dismissing it.

### Steps to Reproduce

1. Enable "Show Ice Bar" in General settings.
2. Enable "Show on hover" in General settings.
3. Set "Show on hover delay" to 0 in Advanced settings.
4. Repeatedly hover over the menu bar.
5. At length, the Ice Bar will refuse to disappear.

### Ice Version

0.11.9

### macOS Version

15.0.1

### Screenshots

https://github.com/user-attachments/assets/8ccfc4b3-0422-44e1-be17-2e082ccc5a69
```

### jordanbaird/Ice #403

- 链接：https://github.com/jordanbaird/Ice/issues/403
- 作者：[Kayxue](https://github.com/Kayxue)
- 状态：open
- 创建时间：2024-10-16T15:46:41Z（UTC）
- 更新时间：2024-10-16T16:16:19Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Make smart mode smarter: Don't collapse the menu bar icons when toggling switches of switch app
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

In smart mode, I just toggle a switch of only switch, the icons just been hide immediately and the list created by the application collapsed. Please make the menu bar icons not to be hide under the condition.

### Steps to Reproduce

1. Install Only Switch (or One Switch) and Ice.
2. Launch the applications
3. Open the switches list by clicking the application icon on the menu bar
4. Toggle any switch in the list (e.g. Hide Desktop Icons, Keep Awake)

### Ice Version

0.11.10

### macOS Version

15.1 Beta (24B5077a)

### Screenshots

https://github.com/user-attachments/assets/30316491-f823-4710-a3cd-223c9d8902bb

```

### jordanbaird/Ice #404

- 链接：https://github.com/jordanbaird/Ice/issues/404
- 作者：[Tubo](https://github.com/Tubo)
- 状态：open
- 创建时间：2024-10-17T02:27:32Z（UTC）
- 更新时间：2025-12-19T18:36:26Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: OneDrive changes from "Hidden" to "Visible" on click
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I have multiple instances of OneDrive, one personal and one business account.

I have both set to "hidden", but on interacting with either of the instances by clicking Chevron, they both become "visible" permanently.

This may or may not be related to #300.



### Steps to Reproduce

1. Set up 2 OneDrive accounts, so 2 icons are shown

2. Change both of them to "hidden" as shown here:
<img width="669" alt="image" src="https://github.com/user-attachments/assets/24560756-d3f9-42bd-9f58-6f0a756b499f">

3. Click on *one* of the icons in menu bar by expanding it via the Chevron

4. Wait a few seconds, now *both* OneDrive icons are shown *permanently*: 
<img width="181" alt="image" src="https://github.com/user-attachments/assets/06d80b98-626f-4929-8fe0-569c6c9cdb99">

5. Check the configuration, surprise, *both* OneDrive icons are now set to "Visible": 
<img width="677" alt="image" src="https://github.com/user-attachments/assets/e082a34e-fe76-4a86-a98a-dffed2a80428">



### Ice Version

0.11.9

### macOS Version

14.6.1

### Screenshots

_No response_
```

### jordanbaird/Ice #406

- 链接：https://github.com/jordanbaird/Ice/issues/406
- 作者：[1155159410](https://github.com/1155159410)
- 状态：open
- 创建时间：2024-10-18T09:54:15Z（UTC）
- 更新时间：2024-10-18T17:57:53Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Allow clicks inside the notch
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I'm not sure if this is intended or a bug, but clicking the MacBook notch (the black region) doesn't trigger the Ice bar.

This is especially noticeable when the menu bar is full, as the notch occupies most of the empty space, making it intuitive to click the notch to show the Ice bar. Currently, I can only trigger the Ice bar by clicking a few pixels below the notch or the small gaps between menu items in that case.

Would it be possible to make the notch area trigger the Ice bar on clicks?

### Steps to Reproduce

1. Go to the "General" settings.
2. Configure the following settings:
    - Use Ice Bar: True
    - Location: Dynamic
    - Show on Click: True
    - Show on Hover: False
    - Show on Scroll: False
3. Click the notch (the black region).

### Ice Version

0.11.10

### macOS Version

15.0.1

### Screenshots

_No response_
```

### jordanbaird/Ice #409

- 链接：https://github.com/jordanbaird/Ice/issues/409
- 作者：[tigeryfan](https://github.com/tigeryfan)
- 状态：open
- 创建时间：2024-10-19T05:25:53Z（UTC）
- 更新时间：2024-12-26T18:08:50Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: macOS Sequoia requires a restart of Ice to render the menubar border
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

After upgrading to macOS Sequoia, the border function doesn't work properly. Only after quitting and reopening the app does it show up. It appears this bug only occurs when the app is launched via login items.

### Steps to Reproduce

1. Make sure Ice is set to launch on login
2. Restart
3. Notice that the Ice menubar is not rendering a border
4. Quit and reopen the Ice app
5. Notice that the Ice menubar now correctly renders a border

### Ice Version

0.11.10

### macOS Version

15.0.0

### Screenshots

_No response_
```

### jordanbaird/Ice #416

- 链接：https://github.com/jordanbaird/Ice/issues/416
- 作者：[mananong](https://github.com/mananong)
- 状态：open
- 创建时间：2024-10-24T03:02:17Z（UTC）
- 更新时间：2024-10-24T03:02:17Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: menubar icons disappear when active app menus extend to the right
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

when i have an app with menu items that extend to the right (microsoft powerpoint on a 14" macbook pro) the tailend of the menubar icons disappear, but if you open the hidden section they're not there. check screens

### Steps to Reproduce

open an app with menu items that extend to right side of notch
see the menubar icons disappear

### Ice Version

0.11.10

### macOS Version

15.0.1

### Screenshots

<img width="486" alt="image" src="https://github.com/user-attachments/assets/0f3bf90f-5259-4704-9d3e-d9a12c3b32b6">

<img width="551" alt="image" src="https://github.com/user-attachments/assets/24e4b59d-8d40-4850-9487-9ee84039684a">

```

### jordanbaird/Ice #434

- 链接：https://github.com/jordanbaird/Ice/issues/434
- 作者：[podfeet](https://github.com/podfeet)
- 状态：open
- 创建时间：2024-11-11T23:34:02Z（UTC）
- 更新时间：2026-01-03T10:35:58Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Hide Application Menus doesn't unless Enable always-hidden section is toggled on
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

On the Advanced tab, the first toggle says 

> Hide application menus when showing menu bar items Make more room in the menu bar by hiding the left application menus if needed

If the Enable always-hidden section is toggled off, application menus do not hide when needed. As soon as I toggle on the always-hidden section (even with nothing in the always-hidden section), then application menus hide appropriately.

### Steps to Reproduce

1. Disable Ice Bar in General settings
2. On Advanced tab, toggle on Hide applications menus
3. turn off Enable always-hidden section
4. Bring Finder to the foreground
5. Assuming you have a lot of menu bar items that would run into the Finder items, the far left menu bar items will not be shown in favor of the Finder menus
6. Back in Ice Settings, toggle on Enable always-hidden section
7. Bring Finder to the foreground
8. Now Finder menus will disappear when Ice menus are shown

### Ice Version

0.11.12

### macOS Version

15.1

### Screenshots

_No response_
```

### jordanbaird/Ice #435

- 链接：https://github.com/jordanbaird/Ice/issues/435
- 作者：[mathieuletyrant](https://github.com/mathieuletyrant)
- 状态：open
- 创建时间：2024-11-12T19:37:57Z（UTC）
- 更新时间：2024-11-12T19:37:57Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Glitch when toggle dock
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When I toggle my dock `CMD+OPT+D`, I have a strange glitch on the menu bar


https://github.com/user-attachments/assets/6173b039-0d25-48b7-a0c7-218f3133331c


### Steps to Reproduce

1. Hide the dock
2. Enable the theme on Ice
3. Click on `CMD + OPT + D`

### Ice Version

0.11.12

### macOS Version

15.1

### Screenshots

_No response_
```

### jordanbaird/Ice #440

- 链接：https://github.com/jordanbaird/Ice/issues/440
- 作者：[A-0-0-P](https://github.com/A-0-0-P)
- 状态：open
- 创建时间：2024-11-17T13:17:56Z（UTC）
- 更新时间：2025-03-27T06:35:52Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: The Shazam (music recognition) icon is invisible all the time
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Thanks for the great app! One little bug: When Ice is activated the Shazam icon doesn't show up in the menu bar (same issue btw with BarTender which I had running before). As soon as I quit Ice it's shown in the menu bar, see screenshots. 

### Steps to Reproduce

Always reproducible. As long as Ice runs, the icon is invisible.

### Ice Version

0.11.12

### macOS Version

15.1

### Screenshots

<img width="1012" alt="Screenshot 2024-11-17 at 14 12 06" src="https://github.com/user-attachments/assets/7b5452ca-cb22-48bd-b2bb-49dc329fbb29">
<img width="496" alt="Screenshot 2024-11-17 at 14 15 33" src="https://github.com/user-attachments/assets/ba2d3095-b1e8-49b4-910d-f916bdb2c334">
<img width="863" alt="Screenshot 2024-11-17 at 14 11 49" src="https://github.com/user-attachments/assets/eb6b656a-c98a-4f4b-8019-9e748f5a3477">
<img width="338" alt="Screenshot 2024-11-17 at 14 11 09" src="https://github.com/user-attachments/assets/c6ce3b92-d655-47e3-8a0b-1da6649e1226">

```

### jordanbaird/Ice #445

- 链接：https://github.com/jordanbaird/Ice/issues/445
- 作者：[ZeeDeeEm](https://github.com/ZeeDeeEm)
- 状态：open
- 创建时间：2024-11-22T00:50:48Z（UTC）
- 更新时间：2025-04-14T10:51:58Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
Menu bar in middle of screen
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When I open a full screen window, and then return to my non-full screen window, the part of ice that gives curved menu bar appears in the middle of the screen.

### Steps to Reproduce

1. Set menu bar appearance to be curved on all sides
2. Open window in full screen
3. return to desktop 1

### Ice Version

0.11.12

### macOS Version

15.2.Beta

### Screenshots

![Screenshot 2024-11-21 at 19 49 09](https://github.com/user-attachments/assets/d2a83fe9-1db1-4132-9ca0-f9289e148ea1)

```

### jordanbaird/Ice #451

- 链接：https://github.com/jordanbaird/Ice/issues/451
- 作者：[boramerts](https://github.com/boramerts)
- 状态：open
- 创建时间：2024-11-29T21:23:20Z（UTC）
- 更新时间：2025-01-01T19:32:27Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Unexpected behavior after swiping between desktop and full screen apps
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

After enabling "split" shape for the menu bar, when I swipe between a full screen app and desktop, menu bar shows the desktop wallpaper instead of full black menu bar on the full screen. This can be fixed or turned into a feature if anyone wants to see this kind of look in full screen.

### Steps to Reproduce

1. Enable split menu bar.
2. Three finger swipe to a full screen app.
3. Swipe back to desktop.
4. Swipe back to full screen app
5. Hover over menu bar

### Ice Version

0.11.12

### macOS Version

15.1.1

### Screenshots


https://github.com/user-attachments/assets/e8497b5c-f730-4fb4-8e79-31d2ba313e4f


```

### jordanbaird/Ice #452

- 链接：https://github.com/jordanbaird/Ice/issues/452
- 作者：[taninke](https://github.com/taninke)
- 状态：open
- 创建时间：2024-11-29T22:00:37Z（UTC）
- 更新时间：2024-12-19T11:12:29Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Automatically rehide takes affect even when inside a hidden items menu options
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

When using automatically rehide, even if you've selected an application that was hidden and in it's menu, it will disappear automatically after the allotted time previously set.

Reproducible on multiple devices

### Steps to Reproduce

- Turn on automatic re-hide to a set time (in my case, 1 second)
- Click on empty section in menu bar
- Show hidden icons
- Right or left click on any icons under hidden section
- Hover over the context menu that shows up for any application, and even when focused on it, it disappears after the time set in "automatically rehide"

### Ice Version

0.11.12

### macOS Version

15.1.1

### Screenshots


https://github.com/user-attachments/assets/2e34e006-d218-4efb-8c05-811128516930


```

### jordanbaird/Ice #456

- 链接：https://github.com/jordanbaird/Ice/issues/456
- 作者：[betalogue](https://github.com/betalogue)
- 状态：open
- 创建时间：2024-12-03T13:19:55Z（UTC）
- 更新时间：2025-06-10T14:23:17Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Ice interferes with right-click on title bar on display where menu bar is not displayed
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

In an extended desktop layout with multiple displays, with the menu bar only shown on the main display, Ice interferes with right-clicking on the title bar of document windows on secondary displays when the title bar is near the top of the display.

### Steps to Reproduce

1. Configure Mac so that it has several displays in an extended desktop layout, with the menu bar ONLY visible on one of the displays (i.e. "Displays have separate Spaces" is OFF).
2. Move a document window with a title bar that can be right-clicked on to display path to document file to a secondary display (with no menu bar visible), with the title bar near the top of the display (i.e. where the menu bar would be IF it were visible).
3. Right-click on document name in title. 

In addition to displaying the path to the document file in a popup, as expected, right-clicking also causes another popup menu to appear with Ice-related options. See screenshot. It's like Ice thinks that the menu bar is there, when it's not.

### Ice Version

0.11.11

### macOS Version

14.7

### Screenshots

![Preview 2024-12-03 at 09 10 53@2x](https://github.com/user-attachments/assets/faea33dc-267d-4d82-91ba-e8bd366be5ce)

```

### jordanbaird/Ice #462

- 链接：https://github.com/jordanbaird/Ice/issues/462
- 作者：[jwbullard](https://github.com/jwbullard)
- 状态：open
- 创建时间：2024-12-17T05:28:27Z（UTC）
- 更新时间：2024-12-17T05:28:27Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
Keyboard Maestro will not move from hidden to visible
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I tried to move Keyboard Maestro from the hidden section to the visible section.  It goes there for one moment and then I get a dialog window as shown in the pasted image.  It doesn't matter how many times I try it.

<img width="328" alt="SCR-20241216-uexd" src="https://github.com/user-attachments/assets/b5ec7001-c6b7-45f8-ad4b-016fe179f42b" />


### Steps to Reproduce

1. Open Ice Settings
2. Go to "Menu Bar Layout" in the sidebar
3. Drag the Keyboard Maestro menu item from the hidden section to the visible section.

### Ice Version

0.11.12

### macOS Version

15.2

### Screenshots

_No response_
```

### jordanbaird/Ice #463

- 链接：https://github.com/jordanbaird/Ice/issues/463
- 作者：[jace](https://github.com/jace)
- 状态：open
- 创建时间：2024-12-18T08:56:30Z（UTC）
- 更新时间：2025-01-12T19:00:49Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Make the "Use Ice Bar" toggle dynamic
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I have "Use Ice Bar" enabled because my Mac has a notch and icons disappear behind it. But I also use an external display sometimes and it has no notch and plenty of space, and the ice bar makes usability slightly worse because it appears on top of my Chrome tabs and the icons all kinda blend in. I had to turn off "show on hover" because that kept causing misclicks.

It'll be nice if this had an "Auto" option ("No/Yes/Auto") instead of being a toggle, showing the ice bar only if there isn't enough space before the notch.

### Screenshots

_No response_
```

### jordanbaird/Ice #467

- 链接：https://github.com/jordanbaird/Ice/issues/467
- 作者：[themacguru](https://github.com/themacguru)
- 状态：open
- 创建时间：2024-12-20T23:33:20Z（UTC）
- 更新时间：2025-03-18T14:21:10Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: 1Password menu item weirdness
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

1Password menu item sometimes moves from visible to not visible menus on its own. And if I try to move it back, I get this error 

### Steps to Reproduce

It happens all the time. And when I try to fix the issue, the error (see screenshot) happens. 

### Ice Version

 0.11.12

### macOS Version

15.2

### Screenshots

![Menu Bar Layout ScreenShot 16 29 58@2x](https://github.com/user-attachments/assets/bc04dbf2-6823-4a6f-bc18-6753a2f175a3)

```

### jordanbaird/Ice #468

- 链接：https://github.com/jordanbaird/Ice/issues/468
- 作者：[mnemnion](https://github.com/mnemnion)
- 状态：open
- 创建时间：2024-12-22T20:20:45Z（UTC）
- 更新时间：2025-01-21T21:49:01Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Disable / Customize Menu Bar Appearance in Full Screen Mode
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I think the gradient overlay looks great, but it detracts from the appearance of full-screen modes.  It would be great if there were a setting to disable it for full screen mode, or to have a different default (although I would just set it to disable).

### Screenshots

_No response_
```

### jordanbaird/Ice #472

- 链接：https://github.com/jordanbaird/Ice/issues/472
- 作者：[Fred-IV](https://github.com/Fred-IV)
- 状态：open
- 创建时间：2024-12-29T08:45:58Z（UTC）
- 更新时间：2025-01-07T20:33:11Z（UTC）
- 标签：Bug, Spacing
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Menu bar item spacing not applying correctly
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I've never gotten Menu Items to space correctly through Ice.
I have to use my own commands, so I will post them here in case it helps.

ICE: 0.11.12
Mac OS 15.2
Also 14.7.1 on another Mac


### Steps to Reproduce

Logging out and in as it says to do does not make it work.


### Ice Version

0.11.12

### macOS Version

15.2

### Screenshots

These commands do work, maybe this is how the app should do it.

MenuItemSpacingDefault.command
defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
defaults -currentHost delete -globalDomain NSStatusItemSpacing

MenuItemSpacingDisplay.command
defaults -currentHost read -globalDomain NSStatusItemSelectionPadding
defaults -currentHost read -globalDomain NSStatusItemSpacing

MenuItemSpacingTight.command
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 0
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 0



```

### jordanbaird/Ice #479

- 链接：https://github.com/jordanbaird/Ice/issues/479
- 作者：[glamout](https://github.com/glamout)
- 状态：open
- 创建时间：2025-01-02T01:48:25Z（UTC）
- 更新时间：2026-05-03T07:53:48Z（UTC）
- 标签：Bug, Performance
- 评论数：9（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Energy impact
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

everything is good except the energy impact  a litter bit high.
<img width="576" alt="未命名" src="https://github.com/user-attachments/assets/fa9fb481-7913-4e86-87ae-fc1ec38ab828" />

As a similar app hidden， the energy impact is very low.
<img width="583" alt="未命名2" src="https://github.com/user-attachments/assets/c1f57e94-454b-4b42-bf94-239dd5a58b55" />




### Steps to Reproduce

check acitvity monitor.

### Ice Version

0.11.2

### macOS Version

macOS 15.2 

### Screenshots

_No response_
```

### jordanbaird/Ice #480

- 链接：https://github.com/jordanbaird/Ice/issues/480
- 作者：[chaitanya9089](https://github.com/chaitanya9089)
- 状态：open
- 创建时间：2025-01-03T12:18:04Z（UTC）
- 更新时间：2025-03-20T08:42:58Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Interaction with Alcove
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Interacting with Alcove requires some refinement. There are a few issues, primarily when Ice is active. The Alcove notch doesn’t return to its original state. 



### Steps to Reproduce

...

### Ice Version

0.11.12

### macOS Version

15.2

### Screenshots

_No response_
```

### jordanbaird/Ice #481

- 链接：https://github.com/jordanbaird/Ice/issues/481
- 作者：[Careless](https://github.com/Careless)
- 状态：open
- 创建时间：2025-01-03T16:54:17Z（UTC）
- 更新时间：2025-01-03T16:54:17Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Option to enable showing hidden section when hovering over un-hidden side
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Is there a way to add an option to enable showing the hidden section when hovering over un-hidden side. Currently the hidden side is only visible if the cursor is positioned on the hidden side of the splitter. It would be a nice option to show the hidden icons no matter where on the menubar the cursor is.

### Screenshots

_No response_
```

### jordanbaird/Ice #482

- 链接：https://github.com/jordanbaird/Ice/issues/482
- 作者：[Careless](https://github.com/Careless)
- 状态：open
- 创建时间：2025-01-03T16:57:39Z（UTC）
- 更新时间：2025-02-07T22:22:46Z（UTC）
- 标签：Feature, Appearance
- 评论数：2（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Better appearance for rounded menu bar
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Can we have an option to turn only the top corners of the menubar round, with the additional option to color the negative space left in the corners with black so that it produces a rounded screenspace effect?

also, is there a way to produce the same effect on the bottom corners of the screen as well? (not sure, since it's not the menubar, but Bartender 5 seems to do this?)

### Screenshots

_No response_
```

### jordanbaird/Ice #485

- 链接：https://github.com/jordanbaird/Ice/issues/485
- 作者：[tshu-w](https://github.com/tshu-w)
- 状态：open
- 创建时间：2025-01-08T05:20:25Z（UTC）
- 更新时间：2025-01-13T06:58:58Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Cannot show any menu bar items in hidden section
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Sometimes the hidden section is empty and does not show any menu bar items

### Steps to Reproduce

Click the Ice menu bar items or open it setting -> Menu bar Layout

### Ice Version

0.11.12

### macOS Version

15.2 (24C101)

### Screenshots

<img width="365" alt="Screenshot 2025-01-08 at 10 23 54" src="https://github.com/user-attachments/assets/94e3a3d6-1028-46d6-a024-d9789f36eca3" />

<img width="1057" alt="Screenshot 2025-01-08 at 13 15 24" src="https://github.com/user-attachments/assets/4e3fac24-54ad-4dc1-9121-ab609a153c53" />

Expected:
<img width="365" alt="Screenshot 2025-01-08 at 13 18 53" src="https://github.com/user-attachments/assets/e0b21a37-1983-4598-a340-52e6172da069" />

<img width="1057" alt="Screenshot 2025-01-08 at 13 18 05" src="https://github.com/user-attachments/assets/e0a9918a-9dd8-4f70-b5dc-60242852e535" />

```

### jordanbaird/Ice #486

- 链接：https://github.com/jordanbaird/Ice/issues/486
- 作者：[roelvangils](https://github.com/roelvangils)
- 状态：open
- 创建时间：2025-01-09T09:37:52Z（UTC）
- 更新时间：2025-04-13T07:38:15Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
Zoomed-in part of the screen sometimes jumps around when macOS Display Zoom is active (while running Ice)
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

Yesterday, I switched from _The App That Shall Not Be Named_ to Ice, and I'm really happy overall. It has all the functionality I need and feels much snappier, especially when using the Search Menu Bar Items feature.

However, there's one issue that is quite problematic for me, related to the Display Zoom functionality in macOS. I have a visual impairment and rely heavily on this feature (Ctrl + / - or Ctrl + Mousewheel). I noticed that when Ice is active and my screen is zoomed in, the mouse pointer sometimes jumps to the top left corner of the screen and back, but this changes the position of the zoomed in portion of the screen (which is quite jarring). 

I assume this is related to screen recording or the rearrangement of icons, and actually, I remember reporting this bug to the developers of _That Other App_ in the past, and they were so kind to fix it. The solution was quite simple, I remember: whenever Display Zoom is active, the code causing the cursor to momentarily move the cursor to the menu bar (and back) is simply temporarily disabled. 

Maybe you could consider implementing such a feature in Ice too? I would love that.

### Steps to Reproduce

1. Activate `Zoom` in `System Settings` under `Accessibility`
2. Make sure your screen is zoomed in. It doesn't matter what the zoom level is. But the effect is more jarring. The higher the zoom factor.
3. Make sure ice has something to do. I'm not sure what ice makes do its magic, so I have added screenshots of my general and advanced settings.
4. Just use your Mac for a while. It's gonna be really hard to trigger. And I'm sorry but I cannot really tell you when exactly it happens.


### Ice Version

0.11.12

### macOS Version

15.2 (24C101)

### Screenshots

![screenshot_20250109_103413](https://github.com/user-attachments/assets/d7623721-c2f4-4738-bfbf-82d036d815ca)
![screenshot_20250109_103419](https://github.com/user-attachments/assets/e22f14b7-eabb-4c03-8f85-c5d2840bcba1)

```

### jordanbaird/Ice #487

- 链接：https://github.com/jordanbaird/Ice/issues/487
- 作者：[Ibrty](https://github.com/Ibrty)
- 状态：open
- 创建时间：2025-01-10T01:08:19Z（UTC）
- 更新时间：2025-08-16T23:29:02Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Always Hidden Use Ice Bar
```

**正文原文**

```markdown
### Check Existing Issues

- [X] I have checked existing issues, and this issue is not a duplicate

### Description

I love the always hidden section but I have a too many icons in my menu bar so some dont fit and  get hidden when i toggle to show the always hidden section. i would love to see a feature which lets me have ONLY the "always hidden section" use the ice bar and the regular "hidden section" not use the ice bar. that way when i toggle to show the "always hidden section" (which is where i keep the majority of my icons), itll pop up below and be able to include all of my icons rather than only a handful

### Screenshots

_No response_
```

### jordanbaird/Ice #494

- 链接：https://github.com/jordanbaird/Ice/issues/494
- 作者：[ruddnev](https://github.com/ruddnev)
- 状态：open
- 创建时间：2025-01-16T21:25:51Z（UTC）
- 更新时间：2025-02-14T18:02:15Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Make option for showing hidden items on mouse down, not up
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I think having an option to switch the toggle showing hidden items to mouse down instead of mouse up will create a more responsive experience. It will feel more instant, while not changing anything about the app.
I absolutely love the app so far! It's a great tool, and I think this small change could make the experience even better. 

### Screenshots

_No response_
```

### jordanbaird/Ice #495

- 链接：https://github.com/jordanbaird/Ice/issues/495
- 作者：[denkillen](https://github.com/denkillen)
- 状态：open
- 创建时间：2025-01-20T07:04:14Z（UTC）
- 更新时间：2025-02-13T06:44:06Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Organize hidden icons into multiple rows
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

An option to organize the hidden icons into multiple rows for when it starts to get rather crowded horizontally.

### Screenshots

_No response_
```

### jordanbaird/Ice #497

- 链接：https://github.com/jordanbaird/Ice/issues/497
- 作者：[dwt](https://github.com/dwt)
- 状态：open
- 创建时间：2025-01-28T12:11:53Z（UTC）
- 更新时间：2025-01-28T12:11:53Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Feature Request]: Open 'Menu Bar Layout' from Right-Click
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Right clicking the menu bar in an empty region currently opens this context menu:

<img width="250" alt="Image" src="https://github.com/user-attachments/assets/b674f3df-6d42-4a6f-af4e-2a0b97f5d974" />

To me, this would be much more useful if I could directly open the 'Menu Bar Layout' from here than editing the 'Menu bar Appearance' as that contains settings that I rarely change. Those are more of the 'ok, this is fine now, now leave it alone' kind, while 'Menu-Bar Layout' in the Ice-Settings needs constant tuning to change the order of menu items, or add a new one that got auto added to the always hidden section.

There are several things that I can think of that could be beneficial here:
- Move the 'Menu Bar Appearance' section into the regular config and change it there
- Add the 'Edit Menu Bar Layout' shortcut to the context menu (This is currently already somewhat the case, because when opening the settings from the context menu the last chosen pane already appears. However, I do not use this often enough to remember that fact, and I also by mistake often choose the first entry because it seems relevant enough. :/
- Change how new menu bar entries are added and add them to the show on demand section automatically. This would allow not having to go to the settings that frequently. Perhaps this could / should be its own setting, i.e. a setting which part of the menu bar new items should be aded to.

What do you think?

### Screenshots

_No response_
```

### jordanbaird/Ice #501

- 链接：https://github.com/jordanbaird/Ice/issues/501
- 作者：[GiorgioMendieta](https://github.com/GiorgioMendieta)
- 状态：open
- 创建时间：2025-01-29T22:34:16Z（UTC）
- 更新时间：2026-09-20T04:56:55Z（UTC）
- 标签：Feature
- 评论数：3（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Raycast Integration
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When searching for menu bar items (cf. image below) Ice's search bar reminds me a lot of Raycast's.

**Ice**

<img src="https://github.com/user-attachments/assets/898e83d5-7104-4e49-bc41-166ce1043068" width=70%>


**Raycast**

<img src="https://github.com/user-attachments/assets/1c33bbd7-2b82-4cc8-a513-dda9528e7e73" width=70%>

This got me thinking, would there be a way to integrate Raycast into Ice so that we can search directly for menu bar elements (as well as maybe some CLI or scripting capabilities)? Maybe using deep links (e.g. `Ice://search?q=`)

I could try to implement it however I don't have experience dealing with MacOS apps.

### Screenshots

_No response_
```

### jordanbaird/Ice #510

- 链接：https://github.com/jordanbaird/Ice/issues/510
- 作者：[erinschief](https://github.com/erinschief)
- 状态：open
- 创建时间：2025-02-11T15:08:19Z（UTC）
- 更新时间：2025-02-11T15:08:19Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Split bar doesn't reach top of scren
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have been using Ice for a while and been pretty happy with it, but recently noticed a graphical inconsistency I cannot understand. I am on a notch-less M1 MacBook Air and when enabling the split bar appearance the top of the menu bar is cut off so that the wallpaper is visible for a pixel or two at the very top of the screen. Unsure if this is intended, but I would like an option to disable this behavior if so. The small amount of non-translucent space at the top of my screen is very distracting and makes the menu bar feel detached from the top of my laptop's screen.

### Steps to Reproduce

1. Enable Ice
2. Go to Menu Bar Appearance in settings
3. Turn on "Split" or "Full" Menubar Shape
4. The top of the Menu Bar is pushed down a pixel or two as the shape is cut at the top by a couple pixels

I have attached a screenshot showing a closeup of my menubar, with border turned on to highlight the heigt cutoff.

### Ice Version

0.11.12

### macOS Version

15.3.0

### Screenshots

<img width="51" alt="Image" src="https://github.com/user-attachments/assets/b52495ea-5eec-4a2f-ac89-d9fa5208483e" />
```

### jordanbaird/Ice #512

- 链接：https://github.com/jordanbaird/Ice/issues/512
- 作者：[majunze2001](https://github.com/majunze2001)
- 状态：open
- 创建时间：2025-02-18T18:30:14Z（UTC）
- 更新时间：2025-02-18T18:30:14Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Lack of sync among windows
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Might be related to #93 

The hidden and unhidden status is not synced on my laptop across different windows, and the menu bar button (dot) as well as the settings menu becomes frozen after multiple attempts.




### Steps to Reproduce

1. Open 4 windows
2. Go to window 1, hide or unhide by clicking the button
3. Go to window 2, hide or unhide by clicking the button
4. Go to window 3, hide or unhide by clicking the button
5. Go to window 4, here ICE is completely frozen for me, opening up the settings menu also goes to a frozen state, and the cursor becomes spinning shape when hovering over the ICE window 

Usually, window 1-3 share the same state (hidden or shown), but window 4 is not synchronized.

### Ice Version

0.11.12

### macOS Version

15.3

### Screenshots

_No response_
```

### jordanbaird/Ice #513

- 链接：https://github.com/jordanbaird/Ice/issues/513
- 作者：[InvaderJ](https://github.com/InvaderJ)
- 状态：open
- 创建时间：2025-02-18T18:43:53Z（UTC）
- 更新时间：2025-02-18T18:43:53Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Hidden icons end up in the Visible section after some interactions
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Not sure when this issue started but it's quite a pain in the rear.

If I open a menu from an icon in the Hidden section via the Ice bar, it will randomly end up being moved to the Visible section.



### Steps to Reproduce

For example, I have the Shottr app hidden. If I open the Ice bar, open the Shotter menu, it will appear to the left side of the Ice menu icon. This is expected. 

However, at random, it will _stay there._ When I go to the Ice settings, Shottr has moved itself to the Visible section from the Hidden section.

### Ice Version

0.11.12

### macOS Version

15.3.1

### Screenshots

_No response_
```

### jordanbaird/Ice #514

- 链接：https://github.com/jordanbaird/Ice/issues/514
- 作者：[kiangti](https://github.com/kiangti)
- 状态：open
- 创建时间：2025-02-21T12:39:09Z（UTC）
- 更新时间：2025-02-21T12:39:09Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Menu bar shadow issue with single application window
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When enabling the `Shadow` option in Menu Bar Appearance, there's an inconsistent behavior in shadow rendering during window animations:

1. If the application has only **one** window open: The shadow moves downward along with the window animation when opening Application Windows
2. If the application has **more than one** window open: Shadow remains properly anchored during animations. Behaves as expected without positional shifts

---

**Expected Behavior:**
Shadow should remain positionally stable during animations regardless of the number of open windows, maintaining consistent visual appearance in both single and multi-window scenarios.







### Steps to Reproduce

1. Enable "Shadow" in Ice preferences (Menu Bar Appearance)
2. Open an application (mine is Google Chrome) with only 1 window
3. Click `Show All Windows`
4. Observe shadow behavior during window opening animation
5. Repeat with an application that has 1+ windows

### Ice Version

0.11.12

### macOS Version

Sequoia 15.3.1

### Screenshots

https://github.com/user-attachments/assets/f73ef0a2-20c3-4931-bcd2-08a0c85c2f39
```

### jordanbaird/Ice #515

- 链接：https://github.com/jordanbaird/Ice/issues/515
- 作者：[vaygr](https://github.com/vaygr)
- 状态：open
- 创建时间：2025-02-23T04:36:40Z（UTC）
- 更新时间：2025-02-23T04:36:40Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Scrolling through menu bar items
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have a unique use case where I want to auto-hide the bar, but also be able to access *all* items (and there are many). Unfortunately Ice cannot display the Ice bar when the bar is set to auto-hide mode.

Would it be possible to introduce scrolling of items within the bar, so those that don't fit in the space could still be accessible either by clicking of some sort of `<`/`>` buttons on the edges or via vertical/horizontal scrolling?

### Screenshots

_No response_
```

### jordanbaird/Ice #516

- 链接：https://github.com/jordanbaird/Ice/issues/516
- 作者：[reesericci](https://github.com/reesericci)
- 状态：open
- 创建时间：2025-02-25T15:10:13Z（UTC）
- 更新时间：2026-09-20T00:59:16Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Feature Request]: Expose API for searching menu bar items for Launchbar/Alfred/Spotlight/etc
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I'm not quite sure how this would be done, but some sort of API callable from AppleScript/Shortcuts maybe to search menu bar items, so I can use my existing launcher for search. Maybe this could be a Spotlight index?

### Screenshots

_No response_
```

### jordanbaird/Ice #517

- 链接：https://github.com/jordanbaird/Ice/issues/517
- 作者：[alexriabtsev](https://github.com/alexriabtsev)
- 状态：open
- 创建时间：2025-02-25T15:47:24Z（UTC）
- 更新时间：2025-09-12T23:15:36Z（UTC）
- 标签：Bug
- 评论数：15（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]:Bar in the middle of the screen
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

The "bar" is in the middle of the screen.

### Steps to Reproduce

I just installed ICE and liked it but the bug really bothers me. Could it be because of multi monitor setup I'm using?

### Ice Version

0.11.12

### macOS Version

15.4

### Screenshots

![Image](https://github.com/user-attachments/assets/507e5046-1ae1-49a2-8e96-05a78ff683bf)
```

### jordanbaird/Ice #518

- 链接：https://github.com/jordanbaird/Ice/issues/518
- 作者：[visnetje](https://github.com/visnetje)
- 状态：open
- 创建时间：2025-03-01T20:58:02Z（UTC）
- 更新时间：2025-03-01T20:58:02Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Configuration option to Always open Ice as minimized
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Currently, with Ice 0.11.12, when starting or reopening the Ice app (e.g. from `/Applications/Ice.app` or wherever it was installed), the main window is always opened.

Could you please add a configuration option to always open the Ice app as minimized by default.

This is desired when for example always opening the Ice app before screen capture software, making sure menu icons hidden by Ice will never get recorded. The config option can prevent always having to manually close the Ice window.

### Screenshots

_No response_
```

### jordanbaird/Ice #519

- 链接：https://github.com/jordanbaird/Ice/issues/519
- 作者：[csm10495](https://github.com/csm10495)
- 状态：open
- 创建时间：2025-03-04T17:57:36Z（UTC）
- 更新时间：2025-03-04T17:57:36Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Ability to show all icons in click menu
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Hi,

When I use my macbook (with notch) sometimes some icons just don't pop up (since they'd be behind the notch). Is it possible to show the icons that are hidden behind the notch and the normally hidden icons when clicking to view the menu bar?

(Right now it just  shows the ones that I've set to be there but the ones hidden behind the notch are still lost).

### Screenshots

On a big monitor:

![Image](https://github.com/user-attachments/assets/ccb774a9-3920-43b2-adab-d607907c2814)

On my macbook (with notch):

<img width="474" alt="Image" src="https://github.com/user-attachments/assets/8501b3f1-1226-4274-9bb6-2908d7653ea5" />
.. it skips the stuff after spotlight in my case to give empty space to the notch. I want to be able to see those hidden ones when clicking the bar.

Thanks!
```

### jordanbaird/Ice #521

- 链接：https://github.com/jordanbaird/Ice/issues/521
- 作者：[Veltair-D](https://github.com/Veltair-D)
- 状态：open
- 创建时间：2025-03-05T14:38:08Z（UTC）
- 更新时间：2025-05-31T00:57:48Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Background visible when entering fullscreen on video. or other application
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When entering full screen, There is a sort of "window" to the bg where toe menu bar was. It doesn't hide. Changing the rehide setting does not appear the fix it. 


Here is an example of the bug when full screening an application
<img width="1728" alt="Image" src="https://github.com/user-attachments/assets/ae15cf0b-9c5e-463f-b891-2299a22be904" />

Here is an example when watching a video on fullscreen (this is Coursera)
<img width="1728" alt="Image" src="https://github.com/user-attachments/assets/796dd934-590f-4eea-8360-39147b786df4" />

Here is an example when watching a YouTube video
<img width="1728" alt="Image" src="https://github.com/user-attachments/assets/73f1d96f-c245-405d-b2a4-8677d82302ad" />



### Steps to Reproduce

1. Enable Menu Bar Shape -> Shape Kind -> Split (doesn't happen on none, happens on Full as well)
2. Make an application/video fullscreen
3. Visible background with black bars as to where the menu bar is supposed to be.

### Ice Version

0.11.12

### macOS Version

15.3.1

### Screenshots

_No response_
```

### jordanbaird/Ice #525

- 链接：https://github.com/jordanbaird/Ice/issues/525
- 作者：[brittlewis12](https://github.com/brittlewis12)
- 状态：open
- 创建时间：2025-03-15T02:09:28Z（UTC）
- 更新时间：2025-09-16T19:40:29Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: split menu bar and related effects seemingly disabled in macOS 15.3.2
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

thanks so much for your delightful menu bar utility!!

just upgraded to latest macOS, and it appears the menu bar style has changed to a translucent, full width style, impervious to various menu bar style settings in ice.

![Image](https://github.com/user-attachments/assets/9e22936a-2329-4dfb-b9e7-6178366d866a)

previously, the menu bar was split and rounded. but even borders and other related effects seemingly have no impact on this latest macOS release, while it worked great on macOS 15.3.1.

i'm running Ice 0.11.12, here are my current desired menu bar settings, despite the above appearance:

![Image](https://github.com/user-attachments/assets/ac72d10f-55cb-40bf-a160-fc2fe84222a6)

functionally speaking, ice continues to work great (including right clicking the negative menu bar space to inline edit ice settings); this is purely the styling aspects that appear to no longer work.

### Steps to Reproduce

1. upgrade to macos 15.3.2

### Ice Version

0.11.12

### macOS Version

15.3.2

### Screenshots

_No response_
```

### jordanbaird/Ice #526

- 链接：https://github.com/jordanbaird/Ice/issues/526
- 作者：[Salateen](https://github.com/Salateen)
- 状态：open
- 创建时间：2025-03-15T06:02:17Z（UTC）
- 更新时间：2025-03-15T06:03:12Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Ice Causing issues with the behaviour of the Motioncontrol Light app. The brights slider keeps disappearing when trying to adjust screen brightness
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Motioncontrol light app displays and icon in the menu bar, to make it easier for the user to control screen brightness. A user would click on the icon and get presented by a slider to adjust the screen brightness. However, when Ice is enabled, once I click on the brightness slider, it automatically disappears.

![Image](https://github.com/user-attachments/assets/14fa5aad-699f-49b8-bfa2-c9fd2e8e48ef)

### Steps to Reproduce

Click on the Motioncontrol light app icon in the menu bar
click on the slider to adjust brightness
the slider will autohide, preventing the using from adjusting the brightness freely

### Ice Version

0.11.12

### macOS Version

15.32.2

### Screenshots

![Image](https://github.com/user-attachments/assets/31f6a7ca-9fa6-48cd-873b-1def63ab8126)
```

### jordanbaird/Ice #527

- 链接：https://github.com/jordanbaird/Ice/issues/527
- 作者：[dwt](https://github.com/dwt)
- 状态：open
- 创建时间：2025-03-20T08:44:08Z（UTC）
- 更新时间：2025-03-20T08:44:08Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Allow pinning bar location with hidden ice icon
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When the ice icon is moved to the ice bar, setting the location of the ice bar to 'ice icon' behaves identical to the mouse pointer or dynamic strategy.

It would make much more sense to me, if the strategy 'icon' would anchor the bar where the icon would be shown if it weren't part of the bar itself.

What I would like to be able to achieve is: Always show the bar at the same place (where the menu bar items live), without me having to sacrifice the space to always show the ice icon.

There is a workaround to achieve this, in that I can have the icon be part of the menu bar and then disable it by setting 'show ice icon' to false. However, this precludes me from accessing the other settings that the ice menu offers.

Thinking about that, perhaps another way to achieve this, could be to unify the menu we get from right-clicking the menu bar and right clicking the ice menu bar entry.

### Screenshots

# this works
<img width="409" alt="Image" src="https://github.com/user-attachments/assets/49d89198-f041-48d5-890b-c10eb6c80649" />
<img width="398" alt="Image" src="https://github.com/user-attachments/assets/693464c9-49cb-495e-9d22-7b8272b62fe4" />

# this doesn't
<img width="638" alt="Image" src="https://github.com/user-attachments/assets/a35e2175-ed67-4339-bef8-ce3fff6105b7" />
<img width="451" alt="Image" src="https://github.com/user-attachments/assets/9b18dff9-3e4c-4b6d-ba6b-8334bfda838b" />
```

### jordanbaird/Ice #529

- 链接：https://github.com/jordanbaird/Ice/issues/529
- 作者：[Go0ners](https://github.com/Go0ners)
- 状态：open
- 创建时间：2025-03-21T14:12:18Z（UTC）
- 更新时间：2025-07-02T03:32:28Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: The right bar is longer than expected on ultrawide screen
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Hello,

forgive my English, it's not my language.
I just wanted to point out that I have a problem with ICE.

ONLY when I'm connected to a second on ultrawide screen (Samsung G9 49"), the right bar bugs, as you can see on these screens. On a “classic” external screen, it doesn't have this bug.
If you need more info, I'll be happy to provide you with logs or whatever you need.

![Image](https://github.com/user-attachments/assets/2242302d-f339-468a-9d87-ad3bbca6ea50)

![Image](https://github.com/user-attachments/assets/611fe5fd-d14c-4f28-8860-b5fb583aa0fd)

### Steps to Reproduce

Just plug an additional Samsung G9 49" 5120*1440

### Ice Version

0.11.12

### macOS Version

15.3.2

### Screenshots

_No response_
```

### jordanbaird/Ice #530

- 链接：https://github.com/jordanbaird/Ice/issues/530
- 作者：[SpaXter25](https://github.com/SpaXter25)
- 状态：open
- 创建时间：2025-03-24T00:16:04Z（UTC）
- 更新时间：2026-04-23T10:37:18Z（UTC）
- 标签：Bug
- 评论数：19（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: high memory usage
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have noticed a quite high memory usage after longer runtimes. (around 4GB)
Device is a MacBook Pro with:
M2 Max, 32GB RAM, Sequoia 15.3.2, 
Issue seems reoccurring after long runtimes. 
I don't really know what's of help for solving this issue, so I just attached some screenshots I thought might help or answer questions.

### Steps to Reproduce

Run Ice for a rather long time, as seen in the screenshots. 

### Ice Version

0.11.12

### macOS Version

15.3.2

### Screenshots

![Image](https://github.com/user-attachments/assets/64413096-d414-4eca-9070-426f0a2ee70f)

![Image](https://github.com/user-attachments/assets/62ae66a5-7cda-48e4-a958-a7860798df01)

![Image](https://github.com/user-attachments/assets/4f9f5f9c-af4d-49ac-8d0e-ab32fe7e79bf)

![Image](https://github.com/user-attachments/assets/c7cb6b43-26d9-4f44-9c8e-4c6f51de859f)

![Image](https://github.com/user-attachments/assets/f8d58de6-2405-483a-9e0d-f92cbe23d58e)

![Image](https://github.com/user-attachments/assets/f7d4d11f-82ef-4648-b49d-66cf3f821b0d)

![Image](https://github.com/user-attachments/assets/ffd85b63-d215-4ca1-be87-9c18ae53eeb3)
```

### jordanbaird/Ice #533

- 链接：https://github.com/jordanbaird/Ice/issues/533
- 作者：[jeremy-beasley](https://github.com/jeremy-beasley)
- 状态：open
- 创建时间：2025-03-29T16:40:19Z（UTC）
- 更新时间：2025-03-30T01:26:33Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Make menu bar appear floating versus docked to top of screen
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I'd like the ability to crop away a few pixels from the top to make the menu bar appear fully floating versus looking like it's docked to the top of the screen.

<img width="625" alt="Image" src="https://github.com/user-attachments/assets/04b206e9-2986-46ee-bd49-74523af731e3" />

### Screenshots

_No response_
```

### jordanbaird/Ice #538

- 链接：https://github.com/jordanbaird/Ice/issues/538
- 作者：[falchion10](https://github.com/falchion10)
- 状态：open
- 创建时间：2025-04-05T15:34:05Z（UTC）
- 更新时间：2025-04-05T15:36:09Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Round corners of clicked menu bar items
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Whenever you enable the rounded menu bar when you press on items in the menu bar they still have the square appearance, making it look a bit ugly when an item is being viewed. Is there a possibility these could also be rounded?

### Screenshots

<img width="619" alt="Image" src="https://github.com/user-attachments/assets/c7845465-f1c9-47d3-9bb8-26619e1947a0" />
<img width="174" alt="Image" src="https://github.com/user-attachments/assets/411d8e64-d452-43ec-9a4b-4d38510d411e" />
```

### jordanbaird/Ice #541

- 链接：https://github.com/jordanbaird/Ice/issues/541
- 作者：[201411108](https://github.com/201411108)
- 状态：open
- 创建时间：2025-04-11T01:52:44Z（UTC）
- 更新时间：2025-04-11T01:52:44Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Split view broke with extended screens
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

![Image](https://github.com/user-attachments/assets/49aff9d8-f076-4c29-88f2-0456776369be)

Macbook's split menu bar displays in extended screens.
I using Macbook Air(M2). You can see my monitor settings below.

![Image](https://github.com/user-attachments/assets/158e0d8b-ed1f-449b-b2f4-e1d1781b36e6)

If I turn Ice app keep on, this broken is resolved.

### Steps to Reproduce

1. connect 1 or more monitor in your laptop.
2. turn your menu bar shape into split
3. close ice app(don't quit, just close it).
4. extended monitor broken

### Ice Version

0.11.12

### macOS Version

15.4

### Screenshots

_No response_
```

### jordanbaird/Ice #544

- 链接：https://github.com/jordanbaird/Ice/issues/544
- 作者：[River-Szasz](https://github.com/River-Szasz)
- 状态：open
- 创建时间：2025-04-17T22:42:36Z（UTC）
- 更新时间：2026-04-08T09:56:48Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Disable in full screen mode
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

As the title says, it would be nice to have the ability to disable in full screen mode

Thank you for your hard work

### Screenshots

_No response_
```

### jordanbaird/Ice #545

- 链接：https://github.com/jordanbaird/Ice/issues/545
- 作者：[ardonplay](https://github.com/ardonplay)
- 状态：open
- 创建时间：2025-04-18T06:45:47Z（UTC）
- 更新时间：2025-05-19T14:19:41Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: ice bar sometimes doesn't show anything
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When change spaces ice bar sometimes doesn't show anything, only bar.

### Steps to Reproduce

1. Move to other space
2. Open hidden menu bar section

### Ice Version

0.11.12

### macOS Version

15.3.2

### Screenshots

<img width="723" alt="Image" src="https://github.com/user-attachments/assets/db5d98d6-1afd-439a-8b30-4510baba6c03" />
```

### jordanbaird/Ice #550

- 链接：https://github.com/jordanbaird/Ice/issues/550
- 作者：[DaddyJapan](https://github.com/DaddyJapan)
- 状态：open
- 创建时间：2025-04-25T06:43:13Z（UTC）
- 更新时间：2025-05-12T15:14:03Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: <bug title>With VMWare + Windows 11, ICE shows menu bar in the middle of an external monitor
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When I use Macbook Sequoia 15.4.1, I also use VMWare + Windows 11. At that time, external display shows the Macbook menu bar without anything. See attached screen shots,

[menubar screenshots.docx](https://github.com/user-attachments/files/19903977/menubar.screenshots.docx)

### Steps to Reproduce

1. Start VMWare
2. check the external monitor

### Ice Version

0.11.12

### macOS Version

15.4.1

### Screenshots

[menubar screenshots.docx](https://github.com/user-attachments/files/19903995/menubar.screenshots.docx)
```

### jordanbaird/Ice #551

- 链接：https://github.com/jordanbaird/Ice/issues/551
- 作者：[salmanuc](https://github.com/salmanuc)
- 状态：open
- 创建时间：2025-04-26T06:31:09Z（UTC）
- 更新时间：2025-04-26T06:31:09Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Grid option when using Ice bar
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When using ice bar for hidden items, also add option to allow menu items to be displayed in a grid with the ability to configure number of columns. 

### Screenshots

_No response_
```

### jordanbaird/Ice #552

- 链接：https://github.com/jordanbaird/Ice/issues/552
- 作者：[salmanuc](https://github.com/salmanuc)
- 状态：open
- 创建时间：2025-04-26T06:35:27Z（UTC）
- 更新时间：2025-04-26T06:35:27Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Option for Double click on ice icon in menu bar to show always hidden menu icons instead of settings
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Single click shows hidden menu bar items, add option for double click within like 200ms to also or only (whatever preferable) show always hidden menu bar icons. 

### Screenshots

_No response_
```

### jordanbaird/Ice #554

- 链接：https://github.com/jordanbaird/Ice/issues/554
- 作者：[Z2Flow](https://github.com/Z2Flow)
- 状态：open
- 创建时间：2025-05-04T15:16:27Z（UTC）
- 更新时间：2025-05-04T15:16:27Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Show menu bar item name on hover
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have not memorised all the icons in my menubar(40+).
Displaying the item's name when hovering the cursor over each would be very helpful.
The search, while helpful, simply shows one the icon. Then a visual scan must be done to locate the icon.
Many icons look the same.
Adding hover would reduce the friction.

### Screenshots

_No response_
```

### jordanbaird/Ice #555

- 链接：https://github.com/jordanbaird/Ice/issues/555
- 作者：[ymshulman](https://github.com/ymshulman)
- 状态：open
- 创建时间：2025-05-05T21:13:34Z（UTC）
- 更新时间：2025-05-19T11:53:19Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: <Disable / alt settings with external monitor>
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

The notch is the biggest reason to use Ice. 
Can we set that on external monitors, Ice is disabled? Or specify a different set of items that should be hidden? 

(Should be able to get this data by looking at the current resolution of the monitor.)

### Screenshots

_No response_
```

### jordanbaird/Ice #560

- 链接：https://github.com/jordanbaird/Ice/issues/560
- 作者：[PixelSushiRobot](https://github.com/PixelSushiRobot)
- 状态：open
- 创建时间：2025-05-08T04:20:15Z（UTC）
- 更新时间：2025-05-08T04:20:15Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Automatically sort menu bar items in hidden section by name
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Beside manually arranging each menu bar item under hidden section, it would be great to have an option to sort them all alphabetically.

### Screenshots

_No response_
```

### jordanbaird/Ice #563

- 链接：https://github.com/jordanbaird/Ice/issues/563
- 作者：[danny-su](https://github.com/danny-su)
- 状态：open
- 创建时间：2025-05-12T06:48:39Z（UTC）
- 更新时间：2025-07-31T12:13:57Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Ice occasionally crashes.
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

-------------------------------------
Translated Report (Full Report Below)
-------------------------------------

Process:               Ice [25497]
Path:                  /Applications/Ice.app/Contents/MacOS/Ice
Identifier:            com.jordanbaird.Ice
Version:               0.11.12 (1117)
Code Type:             ARM-64 (Native)
Parent Process:        launchd [1]
User ID:               501

Date/Time:             2025-05-12 14:08:00.7874 +0800
OS Version:            macOS 15.4.1 (24E263)
Report Version:        12
Anonymous UUID:        D958B9C7-D0B1-8878-60CE-B9FF46290BF0


Time Awake Since Boot: 19000 seconds

System Integrity Protection: disabled

Crashed Thread:        0

Exception Type:        EXC_BREAKPOINT (SIGTRAP)
Exception Codes:       0x0000000000000001, 0x0000000104d92f2c

Termination Reason:    Namespace SIGNAL, Code 5 Trace/BPT trap: 5
Terminating Process:   exc handler [25497]

Thread 0 Crashed:
0   Ice                           	       0x104d92f2c 0x104d20000 + 470828
1   Ice                           	       0x104d92804 0x104d20000 + 468996
2   Ice                           	       0x104da61b4 0x104d20000 + 549300
3   Ice                           	       0x104d40151 0x104d20000 + 131409
4   libswift_Concurrency.dylib    	       0x27d8be83d completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x194a7bc34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x194a8e308 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x194a84764 mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x194a7bfa8 mach_msg + 24
4   CoreFoundation                	       0x194ba8f8c __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x194ba78a8 __CFRunLoopRun + 1208
6   CoreFoundation                	       0x194ba6d68 CFRunLoopRunSpecific + 572
7   AppKit                        	       0x19891d818 _NSEventThread + 140
8   libsystem_pthread.dylib       	       0x194abdc0c _pthread_start + 136
9   libsystem_pthread.dylib       	       0x194ab8b80 thread_start + 8

Thread 2:
0   libsystem_pthread.dylib       	       0x194ab8b6c start_wqthread + 0

Thread 3:
0   libsystem_pthread.dylib       	       0x194ab8b6c start_wqthread + 0

Thread 4:
0   libsystem_pthread.dylib       	       0x194ab8b6c start_wqthread + 0

Thread 5:
0   libsystem_pthread.dylib       	       0x194ab8b6c start_wqthread + 0

Thread 6:
0   libsystem_pthread.dylib       	       0x194ab8b6c start_wqthread + 0

Thread 7:
0   libsystem_pthread.dylib       	       0x194ab8b6c start_wqthread + 0


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x000000016b0dc9d8   x1: 0x000000020638a898   x2: 0x00000001a62a1bf8   x3: 0x0000000206392500
    x4: 0x000060000067eb00   x5: 0x0000000104ecf550   x6: 0x00000001374d1330   x7: 0xe500000000000000
    x8: 0x000000016b0dc9df   x9: 0x0000000000000007  x10: 0x00034d004800078c  x11: 0x000000000000007f
   x12: 0x000000000000002b  x13: 0x00000001370806a0  x14: 0x01000002039a86e1  x15: 0x00000002039a86e0
   x16: 0x04f8000206392500  x17: 0x04f8000206392500  x18: 0x0000000000000000  x19: 0x000000016b0dd3e0
   x20: 0x0000000000000000  x21: 0x0000000000000000  x22: 0x0000000104d73790  x23: 0x000000013719f430
   x24: 0xd000000000000014  x25: 0x00000001374d1310  x26: 0x0000000140a05a00  x27: 0x000000016b0dcec0
   x28: 0x40006000023b3210   fp: 0x000000016b0dd6a0   lr: 0x0000000104d92804
    sp: 0x000000016b0dcac0   pc: 0x0000000104d92f2c cpsr: 0x60001000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x104d20000 -        0x104eaffff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/Ice.app/Contents/MacOS/Ice
       0x105008000 -        0x10504bfff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x10a484000 -        0x10a48ffff libobjc-trampolines.dylib (*) <fb6f2685-3c65-37ec-8ee3-8adba6e1995f> /usr/lib/libobjc-trampolines.dylib
       0x117288000 -        0x11798ffff com.apple.AGXMetalG14X (325.34.1) <79b242a0-9c34-3c0b-b83f-cc82dc1478ca> /System/Library/Extensions/AGXMetalG14X.bundle/Contents/MacOS/AGXMetalG14X
       0x27d859000 -        0x27d8d94fb libswift_Concurrency.dylib (*) <fa0745db-7869-362e-bef5-066f6f1c5459> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x1a5f02000 -        0x1a6470bbf libswiftCore.dylib (*) <c5ccffbf-efe8-36b9-9386-e0e840770a09> /usr/lib/swift/libswiftCore.dylib
       0x194a7b000 -        0x194ab630b libsystem_kernel.dylib (*) <225cb279-20a9-381d-a163-d2be263f5327> /usr/lib/system/libsystem_kernel.dylib
       0x194b2c000 -        0x19506afff com.apple.CoreFoundation (6.9) <39e0f63a-3ab8-39e9-97f8-333cde9a7ba4> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x1987bf000 -        0x199c4fdff com.apple.AppKit (6.9) <1d6df541-4a74-3a0e-8a8f-15aee6f93da9> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x194ab7000 -        0x194ac3a47 libsystem_pthread.dylib (*) <8d27ec9a-d919-31a4-8df8-31a2fd2e593c> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.7G resident=0K(0%) swapped_out_or_unallocated=1.7G(100%)
Writable regions: Total=2.3G written=1395K(0%) resident=851K(0%) swapped_out=544K(0%) unallocated=2.3G(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               128K        1 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                            64K        4 
ColorSync                          560K       29 
CoreAnimation                      864K       22 
CoreGraphics                        32K        2 
CoreServices                       624K        2 
CoreUI image data                 1040K        7 
Foundation                         224K        2 
Kernel Alloc Once                   32K        1 
MALLOC                             2.3G      121 
MALLOC guard page                  384K       24 
Mach message                      3264K        6 
STACK GUARD                       56.1M        8 
Stack                             11.7M        8 
VM_ALLOCATE                       12.1M        9 
__AUTH                            5619K      708 
__AUTH_CONST                      76.9M      950 
__CTF                               824        1 
__DATA                            25.7M      930 
__DATA_CONST                      27.1M      960 
__DATA_DIRTY                      2762K      342 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       622.4M        5 
__OBJC_RO                         61.3M        1 
__OBJC_RW                         2391K        1 
__TEXT                             1.0G      981 
__TPRO_CONST                       128K        2 
mapped file                      337.6M       49 
page table in kernel               851K        1 
shared memory                     9184K       24 
===========                     =======  ======= 
TOTAL                              4.6G     5205 



-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2025-05-12 14:08:01.00 +0800","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 15.4.1 (24E263)","roots_installed":0,"name":"Ice","incident_id":"436DAE26-223E-42C4-9DC8-F10501D16774"}
{
  "uptime" : 19000,
  "procRole" : "Default",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac14,6",
  "coalitionID" : 5135,
  "osVersion" : {
    "train" : "macOS 15.4.1",
    "build" : "24E263",
    "releaseType" : "User"
  },
  "captureTime" : "2025-05-12 14:08:00.7874 +0800",
  "codeSigningMonitor" : 1,
  "incident" : "436DAE26-223E-42C4-9DC8-F10501D16774",
  "pid" : 25497,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-05-12 10:41:49.8280 +0800",
  "procStartAbsTime" : 161621825079,
  "procExitAbsTime" : 458520434104,
  "procName" : "Ice",
  "procPath" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"A8E1FC2A-3BC7-5034-83E2-155CEE799288","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "D958B9C7-D0B1-8878-60CE-B9FF46290BF0",
  "appleIntelligenceStatus" : {"state":"unavailable","reasons":["notOptedIn","selectedSiriLanguageIneligible","regionIneligible","accessNotGranted","countryLocationIneligible","countryBillingIneligible"]},
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570491393,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"AQAA0CGAC5EuTwOUJP3\/F8AJALAAQASRAQAA0CGAC5EoTwOUfv3\/Fw==","atPC":"IAAg1L0DRLL3Dx349c8Aqf17Aqn2DwD5\/YMAkfMDBar1AwSq9wMDqg=="},
  "bootSessionUUID" : "4AE2FF9E-83AF-4BB6-BC62-FCD2D54673AD",
  "sip" : "disabled",
  "exception" : {"codes":"0x0000000000000001, 0x0000000104d92f2c","rawCodes":[1,4376309548],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":25497},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":728669,"threadState":{"x":[{"value":6091033048},{"value":8694311064,"symbolLocation":0,"symbol":"type metadata for Int"},{"value":7082744824,"symbolLocation":0,"symbol":"swift::metadataimpl::ValueWitnesses<swift::metadataimpl::NativeBox<unsigned long long, 8ul, 8ul, 8ul>>::destroy(swift::OpaqueValue*, swift::TargetMetadata<swift::InProcess> const*)"},{"value":8694342912,"symbolLocation":8,"symbol":"value witness table for Builtin.Int64"},{"value":105553123076864},{"value":4377605456},{"value":5222765360},{"value":16501189034685497344},{"value":6091033055},{"value":7},{"value":929088533432204},{"value":127},{"value":43},{"value":5218240160},{"value":72057602688321249,"symbolLocation":72057594037927937,"symbol":"OBJC_CLASS_$___NSCFString"},{"value":8650393312,"symbolLocation":0,"symbol":"OBJC_CLASS_$___NSCFString"},{"value":358036179070297344},{"value":358036179070297344},{"value":0},{"value":6091035616},{"value":0},{"value":0},{"value":4376180624},{"value":5219415088},{"value":14987979559889010708},{"value":5222765328},{"value":5379217920},{"value":6091034304},{"value":4611791571581088272}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4376307716},"cpsr":{"value":1610616832},"fp":{"value":6091036320},"sp":{"value":6091033280},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4376309548,"matchesCrashFrame":1},"far":{"value":0}},"frames":[{"imageOffset":470828,"imageIndex":0},{"imageOffset":468996,"imageIndex":0},{"imageOffset":549300,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":415805,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":4}]},{"id":728725,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":171536698834944},{"value":0},{"value":171536698834944},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":39939},{"value":0},{"value":18446744073709551569},{"value":8667533752},{"value":0},{"value":4294967295},{"value":2},{"value":171536698834944},{"value":0},{"value":171536698834944},{"value":6093316232},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6789063432},"cpsr":{"value":4096},"fp":{"value":6093316080},"sp":{"value":6093316000},"esr":{"value":1442840704,"description":" Address size fault"},"pc":{"value":6788987956},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":7},{"imageOffset":78600,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":7},{"imageOffset":38756,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":7},{"imageOffset":4008,"symbol":"mach_msg","symbolLocation":24,"imageIndex":7},{"imageOffset":511884,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":8},{"imageOffset":506024,"symbol":"__CFRunLoopRun","symbolLocation":1208,"imageIndex":8},{"imageOffset":503144,"symbol":"CFRunLoopRunSpecific","symbolLocation":572,"imageIndex":8},{"imageOffset":1435672,"symbol":"_NSEventThread","symbolLocation":140,"imageIndex":9},{"imageOffset":27660,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":10},{"imageOffset":7040,"symbol":"thread_start","symbolLocation":8,"imageIndex":10}]},{"id":1580046,"frames":[{"imageOffset":7020,"symbol":"start_wqthread","symbolLocation":0,"imageIndex":10}],"threadState":{"x":[{"value":6091599872},{"value":132107},{"value":6091063296},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6091599872},"esr":{"value":1442840704,"description":" Address size fault"},"pc":{"value":6789237612},"far":{"value":0}}},{"id":1582160,"frames":[{"imageOffset":7020,"symbol":"start_wqthread","symbolLocation":0,"imageIndex":10}],"threadState":{"x":[{"value":6092173312},{"value":136219},{"value":6091636736},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6092173312},"esr":{"value":1442840704,"description":" Address size fault"},"pc":{"value":6789237612},"far":{"value":0}}},{"id":1583176,"frames":[{"imageOffset":7020,"symbol":"start_wqthread","symbolLocation":0,"imageIndex":10}],"threadState":{"x":[{"value":6092746752},{"value":81511},{"value":6092210176},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6092746752},"esr":{"value":1442840704,"description":" Address size fault"},"pc":{"value":6789237612},"far":{"value":0}}},{"id":1583960,"frames":[{"imageOffset":7020,"symbol":"start_wqthread","symbolLocation":0,"imageIndex":10}],"threadState":{"x":[{"value":6093893632},{"value":58639},{"value":6093357056},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6093893632},"esr":{"value":1442840704,"description":" Address size fault"},"pc":{"value":6789237612},"far":{"value":0}}},{"id":1584528,"frames":[{"imageOffset":7020,"symbol":"start_wqthread","symbolLocation":0,"imageIndex":10}],"threadState":{"x":[{"value":6094467072},{"value":68523},{"value":6093930496},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6094467072},"esr":{"value":1442840704,"description":" Address size fault"},"pc":{"value":6789237612},"far":{"value":0}}},{"id":1591738,"frames":[{"imageOffset":7020,"symbol":"start_wqthread","symbolLocation":0,"imageIndex":10}],"threadState":{"x":[{"value":6095040512},{"value":135031},{"value":6094503936},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6095040512},"esr":{"value":1442840704,"description":" Address size fault"},"pc":{"value":6789237612},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4375838720,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4378886144,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/Applications\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4467474432,
    "size" : 49152,
    "uuid" : "fb6f2685-3c65-37ec-8ee3-8adba6e1995f",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4683497472,
    "CFBundleShortVersionString" : "325.34.1",
    "CFBundleIdentifier" : "com.apple.AGXMetalG14X",
    "size" : 7372800,
    "uuid" : "79b242a0-9c34-3c0b-b83f-cc82dc1478ca",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG14X.bundle\/Contents\/MacOS\/AGXMetalG14X",
    "name" : "AGXMetalG14X",
    "CFBundleVersion" : "325.34.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 10695839744,
    "size" : 525564,
    "uuid" : "fa0745db-7869-362e-bef5-066f6f1c5459",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 7078944768,
    "size" : 5696448,
    "uuid" : "c5ccffbf-efe8-36b9-9386-e0e840770a09",
    "path" : "\/usr\/lib\/swift\/libswiftCore.dylib",
    "name" : "libswiftCore.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6788984832,
    "size" : 242444,
    "uuid" : "225cb279-20a9-381d-a163-d2be263f5327",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6789709824,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5500928,
    "uuid" : "39e0f63a-3ab8-39e9-97f8-333cde9a7ba4",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "3423"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6853226496,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 21564928,
    "uuid" : "1d6df541-4a74-3a0e-8a8f-15aee6f93da9",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2575.50.27"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6789230592,
    "size" : 51784,
    "uuid" : "8d27ec9a-d919-31a4-8df8-31a2fd2e593c",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6784598016,
  "size" : 5020123136,
  "uuid" : "bb86a9b4-8362-37b8-b028-212703af6f30"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.7G resident=0K(0%) swapped_out_or_unallocated=1.7G(100%)\nWritable regions: Total=2.3G written=1395K(0%) resident=851K(0%) swapped_out=544K(0%) unallocated=2.3G(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               128K        1 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                            64K        4 \nColorSync                          560K       29 \nCoreAnimation                      864K       22 \nCoreGraphics                        32K        2 \nCoreServices                       624K        2 \nCoreUI image data                 1040K        7 \nFoundation                         224K        2 \nKernel Alloc Once                   32K        1 \nMALLOC                             2.3G      121 \nMALLOC guard page                  384K       24 \nMach message                      3264K        6 \nSTACK GUARD                       56.1M        8 \nStack                             11.7M        8 \nVM_ALLOCATE                       12.1M        9 \n__AUTH                            5619K      708 \n__AUTH_CONST                      76.9M      950 \n__CTF                               824        1 \n__DATA                            25.7M      930 \n__DATA_CONST                      27.1M      960 \n__DATA_DIRTY                      2762K      342 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       622.4M        5 \n__OBJC_RO                         61.3M        1 \n__OBJC_RW                         2391K        1 \n__TEXT                             1.0G      981 \n__TPRO_CONST                       128K        2 \nmapped file                      337.6M       49 \npage table in kernel               851K        1 \nshared memory                     9184K       24 \n===========                     =======  ======= \nTOTAL                              4.6G     5205 \n",
  "legacyInfo" : {
  "threadTriggered" : {

  }
},
  "logWritingSignature" : "589e728fd06e0223eb455682262dffe979524a2a",
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "6297d96be2c9387df974efa4",
      "factorPackIds" : {

      },
      "deploymentId" : 240000032
    },
    {
      "rolloutId" : "645197bf528fbf3c3af54105",
      "factorPackIds" : {
        "SIRI_VALUE_INFERENCE_PERVASIVE_ENTITY_RESOLUTION" : "663e65b4a1526e1ca0e288a1"
      },
      "deploymentId" : 240000002
    }
  ],
  "experiments" : [
    {
      "treatmentId" : "4c25da6c-cb8d-40eb-9b62-a1230e80ce69",
      "experimentId" : "67f469f384eaf455d73c6092",
      "deploymentId" : 400000001
    }
  ]
}
}



### Steps to Reproduce

n/a

### Ice Version

0.11.12

### macOS Version

15.4.1

### Screenshots

_No response_
```

### jordanbaird/Ice #566

- 链接：https://github.com/jordanbaird/Ice/issues/566
- 作者：[kanokanor](https://github.com/kanokanor)
- 状态：open
- 创建时间：2025-05-18T16:22:56Z（UTC）
- 更新时间：2025-06-25T06:54:24Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Hide/unhide using custom application whitelist
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

What I was thinking about, maybe somekind of able to add custom application whitelist with boolean switches, at no matter what, will be always visible. Why am I bringing this topic, because the Ice forgets the arragement for applications like Discord, and I have to manually drag the Discord tray icon to unhide it every time when I would like to use it.

### Screenshots

_No response_
```

### jordanbaird/Ice #567

- 链接：https://github.com/jordanbaird/Ice/issues/567
- 作者：[hyperknot](https://github.com/hyperknot)
- 状态：open
- 创建时间：2025-05-19T13:09:27Z（UTC）
- 更新时间：2025-05-27T04:08:44Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Clicking on the menus in some apps triggers Ice
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

If I use some apps, like https://www.portfolio-performance.info/en/ then simply navigating the menu of these apps triggers the Ice bar.



### Steps to Reproduce

1. Navigate the menu in Portfolio Performance app.

### Ice Version

0.11.12

### macOS Version

15.4.1

### Screenshots

![Image](https://github.com/user-attachments/assets/39714ac2-fcf3-4666-a125-adbb6d5d80f9)
```

### jordanbaird/Ice #570

- 链接：https://github.com/jordanbaird/Ice/issues/570
- 作者：[ctafts](https://github.com/ctafts)
- 状态：open
- 创建时间：2025-05-22T18:15:57Z（UTC）
- 更新时间：2025-05-22T18:15:57Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: When bar items pass through the notch
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Sorry in advance if this is a duplicate ask, I searched but didn't find anything.

When my hidden items are shown and expand beyond the notch, they are no longer visible. Could we add the ability to automatically use the ice bar if there is not enough space to display all items?

### Screenshots

Macbook screen, the notch is just the the left of the SSD icon
<img width="1795" alt="Image" src="https://github.com/user-attachments/assets/1a0127a8-a3b4-4882-9203-446891fab059" />

External screen
![Image](https://github.com/user-attachments/assets/97c690a2-8ca3-4bd5-a3f2-b3a303156d7c)

```

### jordanbaird/Ice #573

- 链接：https://github.com/jordanbaird/Ice/issues/573
- 作者：[DerDoktorFaust](https://github.com/DerDoktorFaust)
- 状态：open
- 创建时间：2025-05-23T23:48:18Z（UTC）
- 更新时间：2025-05-28T15:09:21Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Widescreen Monitors Hidden Menu Always Visible
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have a Samsung 57 inch monitor that is 32:9 with resolution of 7680x2160 (both native resolution and the resolution I have my Mac set to).

Right now, my hidden items are always about 2/3 of the screen away from the top right corner where Ice sits and are always visible. If I click on Ice to show my hidden items, they pop on over to where they should be, next to Ice. If I click away, they go back to being 2/3 of the screen away. 

On my monitor it looks like this:

Apple logo, File, Edit, etc. Then 8 inches away or so are my hidden Ice items. Then, all the way on the other side at the top right are the normal things like the Ice ellipsis, data/time, etc.

I THINK the issue might simply be that when it hides the items, it simply pushes them far away that on a normal screen they would not be shown. But because of the length and resolution of this monitor, they are ALWAYS visible.

The issue is not present when my Macbook Pro is not connected to the widescreen monitor (i.e. when I am using the built-in display).

Thank you for your help!

### Steps to Reproduce

1. Use a Samsung 57 inch Odyssey monitor.
2. Install Ice
3. Hide some menu items
4. You will see that when they are "hidden" they are always actually visible on the left side of the screen.

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

_No response_
```

### jordanbaird/Ice #576

- 链接：https://github.com/jordanbaird/Ice/issues/576
- 作者：[unsureifnerd](https://github.com/unsureifnerd)
- 状态：open
- 创建时间：2025-05-29T15:05:32Z（UTC）
- 更新时间：2026-06-08T20:06:50Z（UTC）
- 标签：Bug
- 评论数：8（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: <UI Bar Appearing on Main Display When Playing Fullscreen Video on Extended Display>
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Hi, I’m experiencing a bug with Ice (v0.11.12) on macOS 15.5 (MacBook Air M2). I’ve noticed a UI bar appears unexpectedly on my main display (BenQ Monitor) whenever I play a video in fullscreen mode on the MacBook’s built-in screen, which is set as the extended display.

This issue does not happen the other way around—when watching fullscreen video on the BenQ monitor, no bar appears on the MacBook display.

At first, I thought it might be a browser-related issue, so I tested this with Chrome, Brave, and Safari, but the bar still appeared. I also checked by quitting all background apps like Shottr, Handmirror, Maccy, etc. Eventually, I confirmed that this behavior only occurs when Ice is running.

System Info:
	•	App: Ice v0.11.12
	•	macOS: 15.5
	•	Device: MacBook Air M2 (2022)
	•	External Monitor: BenQ (set as main display)

Other Notes:
	•	The issue only occurs when fullscreen video is on the extended (MacBook) screen.
	•	No issue when fullscreen video is on the main (BenQ) screen.
	•	I’m really enjoying the app otherwise—great work!

Thanks for taking the time to look into this!

### Steps to Reproduce

Steps to Reproduce:

1. Connect your MacBook to an external monitor and set the external monitor as the main display.
2. Keep your MacBook screen as the extended (secondary) display.
3. Launch Ice and keep it running.
4. Open any browser and play a video in fullscreen mode on the MacBook display.
5. A UI bar from Ice appears on the external (main) display, even though nothing is running fullscreen there.
6. Quitting Ice stops this from happening.

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

[**[Bug Demo]** - Ice UI Bar Appears on Main Display When Playing Fullscreen Video on Extended Display](https://drive.google.com/file/d/1mg_MK6ePsMd47dzM6ZGVF1EJzpebWBPQ/view?usp=sharing)
```

### jordanbaird/Ice #578

- 链接：https://github.com/jordanbaird/Ice/issues/578
- 作者：[liyanggyang](https://github.com/liyanggyang)
- 状态：open
- 创建时间：2025-06-06T02:30:56Z（UTC）
- 更新时间：2025-12-16T06:11:45Z（UTC）
- 标签：Bug, Performance
- 评论数：5（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: High CPU usage
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

CPU usage is over 15%, which can be optimized

### Screenshots

_No response_
```

### jordanbaird/Ice #584

- 链接：https://github.com/jordanbaird/Ice/issues/584
- 作者：[Kayxue](https://github.com/Kayxue)
- 状态：open
- 创建时间：2025-06-11T18:39:50Z（UTC）
- 更新时间：2025-07-13T14:07:46Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: macOS 26 application menu change to ice empty menu when clicking on empty space on menu bar to expand collapse items
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Like video, please focus on application menu and ice icon on dock

https://github.com/user-attachments/assets/d70119f1-3b29-459f-b9f0-73f13c445c5c

### Steps to Reproduce

1. Update to macOS 26
2. Turn of "Use Ice Bar"
3. Click on empty space on right side of menu bar

### Ice Version

0.11.12

### macOS Version

Tahoe Developer Beta 1

### Screenshots

Video has already been attached above
```

### jordanbaird/Ice #586

- 链接：https://github.com/jordanbaird/Ice/issues/586
- 作者：[comfortablemilk4454](https://github.com/comfortablemilk4454)
- 状态：open
- 创建时间：2025-06-12T15:51:22Z（UTC）
- 更新时间：2025-09-25T07:45:29Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: protonvpn app icon presses itself when it hides itself after being opened from ice bar
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

protonvpn app icon presses itself when it hides itself after being opened from ice bar (see screen recording) and also does not open when you click on it in the ice bar

### Steps to Reproduce

see video

### Ice Version

commit 81c8ef3 (self built)—0.11.12

### macOS Version

15.5

### Screenshots

https://github.com/user-attachments/assets/f56a450f-aa34-4483-88d9-18502107d606
```

### jordanbaird/Ice #589

- 链接：https://github.com/jordanbaird/Ice/issues/589
- 作者：[Sebastian1989101](https://github.com/Sebastian1989101)
- 状态：open
- 创建时间：2025-06-21T19:58:14Z（UTC）
- 更新时间：2025-06-21T19:58:14Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Menu items disappear when there is no room left
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Screenshot shows it clearly. Some icons are just lost in the 'void' (in my case fan control and amphetamine). 

### Steps to Reproduce

1. Having a few menu items in the "Visible" section 
2. Open a app with a lot of menu items (like JetBrains Rider)

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

![Image](https://github.com/user-attachments/assets/c1a7d473-a9e1-465a-8c42-82f995bf6f22)
```

### jordanbaird/Ice #590

- 链接：https://github.com/jordanbaird/Ice/issues/590
- 作者：[zhekch](https://github.com/zhekch)
- 状态：open
- 创建时间：2025-06-24T19:37:14Z（UTC）
- 更新时间：2025-07-11T14:43:39Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
App duplicates itself in dock on Tahoe
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

After clicking the menu bar "a few times," the app manages to somehow duplicate itself in the dock, with force quit not being able to quit it.

### Steps to Reproduce

Click on the menu bar few times quickly

### Ice Version

0.11.12

### macOS Version

26.0

### Screenshots

![Image](https://github.com/user-attachments/assets/cf01c8f2-49b6-4595-bcc6-35a20f0b2ec1)
```

### jordanbaird/Ice #595

- 链接：https://github.com/jordanbaird/Ice/issues/595
- 作者：[johan456789](https://github.com/johan456789)
- 状态：open
- 创建时间：2025-07-03T18:49:59Z（UTC）
- 更新时间：2025-07-03T19:07:30Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Option-click should expand even when enable always-hidden section is turned off
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

If **Enable always-hidden section** is turned off,

![Image](https://github.com/user-attachments/assets/31e7ad75-8e70-4be8-85d9-783831e3dcdb)

then Option-click does nothing.

The expected behavior should be the same as a click (I tested option-click on Control Center and Screen Mirroring, and they work the same as a click)

Maybe related to #196 

### Steps to Reproduce

Option-click on the dot in menubar when the **Enable always-hidden section** is off.

### Ice Version

0.11.12

### macOS Version

15.5 (24F74)

### Screenshots

https://github.com/user-attachments/assets/30ec5a13-8ec8-4879-9903-e2a5b3d78f23
```

### jordanbaird/Ice #600

- 链接：https://github.com/jordanbaird/Ice/issues/600
- 作者：[crckrmn77](https://github.com/crckrmn77)
- 状态：open
- 创建时间：2025-07-09T18:56:43Z（UTC）
- 更新时间：2025-07-09T18:56:43Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Open hidden items from the Ice Icon
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I could not find this, and maybe it [is/will be] part of the Tahoe release, but it would be REALLY nice to have the hidden icons slide out to the left of the Ice Icon. I keep my "system" icons (e.g. battery, WiFi, BT, sound) in the hidden list, and would prefer them to slide out on the right side of the menu bar where I place the Ice Icon. The Ice Bar pop out is an *OK* alternative for now, though I would prefer an option to have them slide out from the location of the icon. Not a deal breaker, especially for a donation only app (great job BTW!)).

### Screenshots

Menu bar as it is normally, showing my layout settings.
<img width="672" height="518" alt="Image" src="https://github.com/user-attachments/assets/2510c652-857f-4db9-b277-9af62d9dd486" />

With hidden icons inline (but at the left of visible icons.
<img width="700" height="42" alt="Image" src="https://github.com/user-attachments/assets/09078ea3-42d1-48af-8510-d739e4ecfcf6" />

Where I would prefer they appear (if the option can be made available). 
![Image](https://github.com/user-attachments/assets/f10c1ae9-4894-4fc4-b931-96bc8a76599c)
```

### jordanbaird/Ice #601

- 链接：https://github.com/jordanbaird/Ice/issues/601
- 作者：[felciano](https://github.com/felciano)
- 状态：open
- 创建时间：2025-07-11T13:18:13Z（UTC）
- 更新时间：2025-07-11T13:18:13Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: Documentation for hidden and always hidden behavior
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I'm running into some weird behaviour in where my icons are showing up, in particular either hidden or in the "always hidden" bar. It _might_ be related to #344 but I can't tell because I'm actually not clear on what the expected correct behavior is.

For what it's worth, here is what I would like it to do:

- Add to Visible by default
- Add to Hidden if you need to (e.g. run out of space)
- If I manually move an item from Hidden to Visible, use that to influence future behavior (i.e. try to keep that app in the Visible section going forward)
- Manually determine which app icons should be in the "always-hidden" section, only visible if you open the prefs or use the option-click trick. Never add items to "always hidden" automatically

I'm relatively new to Ice so if this is documented in another bug somewhere (including closed one), please feel free to point me to it. If not, could we add the expected behavior to the README or even a Github wiki page please?

### Screenshots

_No response_
```

### jordanbaird/Ice #603

- 链接：https://github.com/jordanbaird/Ice/issues/603
- 作者：[jamesqo](https://github.com/jamesqo)
- 状态：open
- 创建时间：2025-07-16T04:23:43Z（UTC）
- 更新时间：2025-09-19T23:55:02Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: App launches, then immediately crashes, on macOS Tahoe Beta 3
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

The app appears for a split second and then crashes on the latest beta. Using a 2022 13" M2 MacBook Pro.

### Steps to Reproduce

1. Open app
2. Boom

### Ice Version

0.11.13-beta1 (latest)

### macOS Version

Tahoe Beta 3

### Screenshots

https://github.com/user-attachments/assets/1d1c8f42-1696-4c89-90f2-d71269a2a8ba
```

### jordanbaird/Ice #604

- 链接：https://github.com/jordanbaird/Ice/issues/604
- 作者：[R0verDan](https://github.com/R0verDan)
- 状态：open
- 创建时间：2025-07-16T08:57:32Z（UTC）
- 更新时间：2025-09-13T01:53:54Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Disable functionality behind notch
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I use Better Touch Tool's floating menu feature, and my floating menu is located behind the notch to make the notch functional. One of the triggers I use is right-clicking on the notch to run a Mac Shortcut. But right clicking also triggers the settings for Ice Bar. Would it be possible to disable the Ice Bar trigger behind the notch? Or a toggle?

### Screenshots

<img width="481" height="145" alt="Image" src="https://github.com/user-attachments/assets/c79473ac-4474-45a3-af3b-2171a63081ba" />
```

### jordanbaird/Ice #606

- 链接：https://github.com/jordanbaird/Ice/issues/606
- 作者：[pmdci](https://github.com/pmdci)
- 状态：open
- 创建时间：2025-07-19T22:19:29Z（UTC）
- 更新时间：2025-07-19T22:19:29Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Ice bar does't leaves artefact behind when auto-hiding in full screen
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When an application is in full screen, the auto-hide leaves an artefact behind.

### Steps to Reproduce

1. Ensure Ice is set to use the Ice Bar.
2. Make an application full screen.
3. Go towards the menu bar. Click on the Ice icon to show the Ice bar.
4. Move mouse pointer away. Wait for the Ice bar to auto-hide. An artefact will be left behind.
5. Clicking elsewhere, or in the Ice icon, will make the artefact disappear.

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

<img width="1470" height="956" alt="Image" src="https://github.com/user-attachments/assets/d45597dc-6f37-4c44-be0b-c83b47ccd0c1" />
```

### jordanbaird/Ice #608

- 链接：https://github.com/jordanbaird/Ice/issues/608
- 作者：[mglenbarker](https://github.com/mglenbarker)
- 状态：open
- 创建时间：2025-07-23T20:54:00Z（UTC）
- 更新时间：2025-07-23T20:54:00Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Split menu bar holds onto a large amount of blank space to the
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I think this issue started with the latest version but I can't be certain; I kept thinking it was a temporary thing that would sort itself out, or maybe it was because of something I'd done. The issue is simply that when I run Ice on an external display (extended rather than mirroring) there is a vestigial region of menu bar that won't hide no matter what state the bar is in. This does not happen in the same instance of Ice on my Macbook Air M4 built-in display. Screenshots attached:


### Steps to Reproduce

This is consistent on two different external displays (one HDMI, one USB-C) and it does not seem to matter what other Ice settings I have in place, only that the Menu Bar Shape is set to "Split."

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

<img width="691" height="175" alt="Image" src="https://github.com/user-attachments/assets/130f6cd8-13ba-447b-99d1-7c282f0a6b3a" />
<img width="1109" height="209" alt="Image" src="https://github.com/user-attachments/assets/173f9bef-b30a-4e47-bfc2-65bd49e20321" />
```

### jordanbaird/Ice #609

- 链接：https://github.com/jordanbaird/Ice/issues/609
- 作者：[its-nymo](https://github.com/its-nymo)
- 状态：open
- 创建时间：2025-07-24T07:19:00Z（UTC）
- 更新时间：2025-11-07T06:26:34Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
Random bar in the middle of the screen
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When NOT in full screen, a random bar mimic the borders of the menu bar appears in the middle of the screen.

### Steps to Reproduce

Just setup Ice, then use mac without setting apps in full screen

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

![Image](https://github.com/user-attachments/assets/43c7b24c-c227-4e89-87da-fa25d62e15b0)

![Image](https://github.com/user-attachments/assets/2fe5ae31-296b-40a8-9aff-cf8f3cbb842d)
```

### jordanbaird/Ice #617

- 链接：https://github.com/jordanbaird/Ice/issues/617
- 作者：[Sarcose](https://github.com/Sarcose)
- 状态：open
- 创建时间：2025-08-01T16:08:52Z（UTC）
- 更新时间：2025-08-01T16:08:52Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Feature Request]: Auto-Sort behavior for "Unrecognized" Apps
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When a new app is opened and Ice is active, it automatically goes to Hidden. When "Always Hidden" mode is toggled, the new app always goes to Always Hidden. This feels counterintuitive to me -- I should have a simple option in a dropdown:

`Behavior for Unrecognized Apps: Visible | Hidden | Always Hidden`

Optionally another QoL feature for this would be a "Always put new apps to the left" or "Always put new apps to the right" toggle. This would help with automations based on screen coordinate, for instance.


Why this is relevant specifically in my use-case, and perhaps for others: there sometimes seem to be apps that don't behave nicely with MacOS Menubar settings. Maybe they aren't interacting with the Menubar API correctly or something for instance. In my case, it's the very buggy Nebula app for XReal glasses. Every time I use a Menubar manager, or MacOS itself, to move it around, its position is "forgotten" next time it starts up and it is treated as an unrecognized app. In the case of Ice, it is always hidden until I drag it.

If the other request regarding exposing the Search API gets implemented I will simply access my app that way. As it is, this behavior I'm requesting seems like it should be simple enough to implement and would benefit a lot of users greatly in my humble opinion.

Thanks for a great app!

### Screenshots

_No response_
```

### jordanbaird/Ice #619

- 链接：https://github.com/jordanbaird/Ice/issues/619
- 作者：[MicabSoi](https://github.com/MicabSoi)
- 状态：open
- 创建时间：2025-08-03T00:37:46Z（UTC）
- 更新时间：2025-08-03T00:37:46Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Unable to Restore Menu Item After Removing Duplicate Chevron Icon
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

**Description:**

I had a double-up of my icon (Chevron) in the menu bar, so I tried to remove one that looked like the duplicate. However, it ended up completely removing the item instead. Now, there is no apparent way to add it back. The item does not reappear in the menu, and there are no options available to restore it from settings or preferences.

**Expected Behavior:**

There should be a clear way to manage duplicates and restore accidentally removed menu items.

**Actual Behavior:**

Removing one apparent duplicate removes the item entirely, with no way to restore it via settings.

**Environment:**

OS: Tahoe 26.0 Beta (25A5316i)


### Steps to Reproduce

1. Open the application.
2. Drag icon out of the menu bar to remove it.
3. Attempt to re-add or restore the removed item.

### Ice Version

0.11.12

### macOS Version

26.0

### Screenshots

_No response_
```

### jordanbaird/Ice #620

- 链接：https://github.com/jordanbaird/Ice/issues/620
- 作者：[Pavel00x](https://github.com/Pavel00x)
- 状态：open
- 创建时间：2025-08-03T13:31:09Z（UTC）
- 更新时间：2026-01-03T10:28:38Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]:Hide application menus when showing menu bar items
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Hi, thanks for your app.
But this thing doesn't work on macOS 15:
**Hide application menus when showing menu bar items**
Make more room in the menu bar by hiding the left application menus if needed

Thank you

### Steps to Reproduce

Preferences:
Hide application menus when showing menu bar items

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

_No response_
```

### jordanbaird/Ice #621

- 链接：https://github.com/jordanbaird/Ice/issues/621
- 作者：[cmd-christopher](https://github.com/cmd-christopher)
- 状态：open
- 创建时间：2025-08-04T02:19:35Z（UTC）
- 更新时间：2025-08-24T01:49:36Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Can't fully interact with hidden menu items
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When I hover to re-display hidden items, I can click to drop down the menu, but some menus will have additional buttons within the dropdown to interact with.  However when I try to click a button within the drop down menu, the menu disappears immediately.  Citrix workspace item is a good example of this...

### Steps to Reproduce

With the citrix workspace menu item installed and included in the hidden menu bar items...
1. Hover over hidden items to visualize
2. drop down the citrix workspace menu
3. attempt to select the user avatar icon in the upper right of the dropdown
4. you should briefly see the sub-menu items but the whole menu disappears after a split second

### Ice Version

0.11.12

### macOS Version

15.6

### Screenshots

_No response_
```

### jordanbaird/Ice #623

- 链接：https://github.com/jordanbaird/Ice/issues/623
- 作者：[shawnhsieh2019](https://github.com/shawnhsieh2019)
- 状态：open
- 创建时间：2025-08-05T16:04:15Z（UTC）
- 更新时间：2025-08-05T16:04:15Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]:Icons in MenuBar Layout page Disappear After Using ICE Bar in Full-Screen Mode
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When using ICE, the icons displayed in the "MenuBar Layout" settings page disappear after performing a specific sequence of actions. This involves activating and then deactivating the ICE bar while in a full-screen application, and then returning to the ICE settings window.

The icons in the layout preview become completely blank. A temporary workaround is to quit and restart the ICE app, but even after restarting, some app icons remain missing, leaving empty spaces in the menu bar.

I have attached a screen recording that demonstrates this issue.

### Steps to Reproduce

1.Launch the ICE application and open its settings window.

2.Navigate to the MenuBar Layout tab. You should see your current menu bar icons displayed correctly.

3.Switch to another application that is in full-screen mode.

4.Click on the empty top menu bar to reveal the hidden menu bar icons (the "ICE bar").

5.Click on the menu bar again to hide the icons.

6.Switch back to the ICE application's settings window.

7.Result: Observe that all the icons in the MenuBar Layout preview area have vanished.

### Ice Version

0.11.12

### macOS Version

macOS Sequoia 15.6

### Screenshots

<!-- Failed to upload "CleanShot 2025-08-05 at 23.49.17.mp4" -->
```

### jordanbaird/Ice #625

- 链接：https://github.com/jordanbaird/Ice/issues/625
- 作者：[Dedsecproject](https://github.com/Dedsecproject)
- 状态：open
- 创建时间：2025-08-07T23:39:43Z（UTC）
- 更新时间：2025-08-07T23:47:20Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: Oversize hidden bar
```

**正文原文**

```markdown

### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Is there a way to resize the hidden bar so it does not go across the screen with just a few apps?


<img width="1554" height="1021" alt="Image" src="https://github.com/user-attachments/assets/db1c330e-2dba-40ab-921b-55886dc4e580" />

### Steps to Reproduce

1. Press the Ice button to display the hidden bar.
2. Hidden bar shows across the screen with just a few apps listed.

in comparison. Always hidden bar expand to the size of the icons listed.

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

_No response_
```

### jordanbaird/Ice #627

- 链接：https://github.com/jordanbaird/Ice/issues/627
- 作者：[Riyan4512](https://github.com/Riyan4512)
- 状态：open
- 创建时间：2025-08-09T06:35:41Z（UTC）
- 更新时间：2025-08-10T20:32:07Z（UTC）
- 标签：Bug, Appearance
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Menu bar appearance not being displayed
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

The menu bar appearance is not showing in any view like the split, full none

### Steps to Reproduce

h

### Ice Version

0.11.12

### macOS Version

15.4.1

### Screenshots

_No response_
```

### jordanbaird/Ice #630

- 链接：https://github.com/jordanbaird/Ice/issues/630
- 作者：[Greenysmac](https://github.com/Greenysmac)
- 状态：open
- 创建时间：2025-08-09T13:53:18Z（UTC）
- 更新时间：2025-08-09T13:53:18Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Ice Bar under when I'm on one screen.
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I would love a switch for the Ice Bar that says "Only kick on when I'm on a single screen".

The main idea here is that I spend a lot of time with a docked laptop. Ice works great when I have two screens.

When I pick up my laptop and go somewhere else, I suddenly shift from multiple screens to just one.

I want a simple switch in the Ice Bar that toggles "when on one screen, use the Ice Bar." This means if there’s more than one screen, the Ice Bar shouldn’t activate. Instead, everything should appear on the menu bar as we have it now.

A straightforward Ice Bar setup should satisfy about half of the users who want multiple configurations for the Ice Bar.

### Screenshots

_No response_
```

### jordanbaird/Ice #633

- 链接：https://github.com/jordanbaird/Ice/issues/633
- 作者：[zzzZZZ-JW](https://github.com/zzzZZZ-JW)
- 状态：open
- 创建时间：2025-08-11T14:59:33Z（UTC）
- 更新时间：2025-09-10T01:22:54Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：系统升级兼容与待澄清反馈

**标题原文**

```text
[Bug]:macOS Tahoe 26中ice无法正常使用
```

**正文原文**

```markdown
### Check Existing Issues

- [ ] I have checked existing issues, and this issue is not a duplicate

### Description

将macOS系统升级到macOS26，ice将无法正常使用

### Steps to Reproduce

1、将macOS的系统版本升级到macOS Tahoe 26
2、启动ice，正常启动，图标正常折叠
3、点击菜单栏ice的折叠小箭头，ice随即退出，折叠的图标出现

### Ice Version

0.11.12

### macOS Version

macOS Tahoe 26 beta5

### Screenshots

_No response_
```

### jordanbaird/Ice #634

- 链接：https://github.com/jordanbaird/Ice/issues/634
- 作者：[pmccarren](https://github.com/pmccarren)
- 状态：open
- 创建时间：2025-08-11T15:57:54Z（UTC）
- 更新时间：2025-08-11T15:58:58Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Option-Click does not work if Show on Click is disabled
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

`option+click Always-hidden section can be shown` has no effect when `Show on Click` is off.

If you have `Show on Click` disabled, for example using only `Show on Hover`, then the ability to show the always hidden section no longer functions as expected.

I believe this is tangentially related to #595.

### Steps to Reproduce

1. Set `Settings > General > Show on click` to `off`
2. Set `Settings > General > Show on hover` to `on`
3. Set `Settings > Advanced > Enable always-hidden section` to `on`
4. Set `Settings > Advanced > Always-hidden section can be shown` to `on`
5. Ensure you have at least 1 menu item in all three sections (Visible, Hidden, Always-Hidden)
6. Expected behavior when option clicking in menu bar is for Always-Hidden section to be shown
7. Set `Settings > General > Show on click` to `on`
8. Note that option clicking now works

### Ice Version

0.11.12

### macOS Version

15.6

### Screenshots

_No response_
```

### jordanbaird/Ice #635

- 链接：https://github.com/jordanbaird/Ice/issues/635
- 作者：[mix579](https://github.com/mix579)
- 状态：open
- 创建时间：2025-08-11T19:18:05Z（UTC）
- 更新时间：2025-09-10T01:28:03Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
Weird behavior under Tahoe MacOS 26 Public Beta 2
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Two issues, probably related. 

A. When I click empty space to show hidden items, the only thing that happens is the appearance of small semi transparent rectangular box below the cursor. Looks like the area where the hidden icons should show but they don't. Clicking again hides that box. 

B. When I click on the chevron to show hidden menu bar icons, Ice crashes unceremoniously



### Steps to Reproduce

As described above__

### Ice Version

0.11.12

### macOS Version

Version 26.0 Beta (25A5327h)

### Screenshots

<!-- Uploading "CleanShot 2025-08-11 at 15.07.44.png"... —>
```

### jordanbaird/Ice #636

- 链接：https://github.com/jordanbaird/Ice/issues/636
- 作者：[FirstDoom](https://github.com/FirstDoom)
- 状态：open
- 创建时间：2025-08-12T16:59:30Z（UTC）
- 更新时间：2026-06-08T20:21:31Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: <bug title> Shows weird bar when connected to monitor
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have my macbook open and connected to my monitor and when im on full screen on my macbook i get this weird menu bar cutout on my monitor sometimes it shows the cutout of the notch. I have the rounded edges on for the menu bar.

<img width="1605" height="466" alt="Image" src="https://github.com/user-attachments/assets/ac4d576a-6a7b-4e52-a548-88d7fbaad443" />


### Steps to Reproduce

connect a monitor/2nd screen
go into any app full screen on open macbook
weird cutout appears

### Ice Version

0.11.12

### macOS Version

Sequoia 15.6

### Screenshots

_No response_
```

### jordanbaird/Ice #638

- 链接：https://github.com/jordanbaird/Ice/issues/638
- 作者：[congyukun](https://github.com/congyukun)
- 状态：open
- 创建时间：2025-08-18T06:06:47Z（UTC）
- 更新时间：2025-10-28T22:11:06Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
Can it support the multilingual version?
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Can it support the multilingual version?

### Screenshots

Can it support the multilingual version?
```

### jordanbaird/Ice #639

- 链接：https://github.com/jordanbaird/Ice/issues/639
- 作者：[fberzau](https://github.com/fberzau)
- 状态：open
- 创建时间：2025-08-19T15:33:33Z（UTC）
- 更新时间：2025-09-10T13:42:43Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Menu bar on multiple displays
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Using a Mac Studio with three connected displays. The menu bar is on Display (1). However, on the other displays, where macOS is not showing a menu bar at all, Ice is grabbing the right mouse click, making it impossible for apps running fully zoomed to do any right click action in that area. In my example, I use Google Chrome on display (2) fully zoomed, and clicking on a tab, instead of showing me Chrome's tab actions, I get the menu bar options from Ice.

### Steps to Reproduce

See description above and screen recording

### Ice Version

0.11.12

### macOS Version

26.0

### Screenshots

https://github.com/user-attachments/assets/9df462cb-9b11-4f1a-82ca-6b80fd5f16d7
```

### jordanbaird/Ice #640

- 链接：https://github.com/jordanbaird/Ice/issues/640
- 作者：[Dave-JM](https://github.com/Dave-JM)
- 状态：open
- 创建时间：2025-08-19T19:50:46Z（UTC）
- 更新时间：2025-08-19T19:50:46Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Strange Mouse Behavior After Clicking Hidden Icon
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Using Ice on MacOS Tahoe Public Beta frequently causes strange mouse behavior.  What happens is that the mouse pointer gets locked into the standard pointer.  Mousing over text does not change the pointer into the vertical bar; mousing over hyperlinks does not change the pointer to the finger pointer; mousing over a window border does not change to the arrows; etc.  Once this behavior occurs, the only way to fix it is to restart the computer.  Quitting Ice, killall Finder, killall Dock, and killall ControlCenter do not fix the issue.

Interestingly, I encountered a similar issue with Bartender on previous macOS versions (had to switch to Ice since I can't get Bartender 6 alpha to work whatsoever), but quitting and restarting Bartender fixed it (no system restart required).

### Steps to Reproduce

**Method 1:**
1. Expand Ice Bar to show hidden items
2. Click any item in the Bar
3. Mouse pointer is now locked into the standard pointer across the system

**Method 2:**
1. Option-Click to show always-hidden section
2. Mouse pointer is now locked into the standard pointer across the system

### Ice Version

0.11.13-dev.1

### macOS Version

26.0 Public Beta (25A5338b)

### Screenshots

_No response_
```

### jordanbaird/Ice #641

- 链接：https://github.com/jordanbaird/Ice/issues/641
- 作者：[Caffeine19](https://github.com/Caffeine19)
- 状态：open
- 创建时间：2025-08-21T04:55:25Z（UTC）
- 更新时间：2025-11-22T04:22:13Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：快捷键、自动化与配置能力

**标题原文**

```text
[Feature Request]: Support Ctrl+N and Ctrl+P to navigate down and up in the  menu bar items list
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Using Ctrl+P and Ctrl+N to navigate up and down is quite common on macOS.
But currently, in Ices’ menu bar items list, this isn’t supported — we can only use the arrow keys.


### Screenshots

<img width="667" height="521" alt="Image" src="https://github.com/user-attachments/assets/e0d628e3-fc46-4666-b331-67ce82c6d07c" />
```

### jordanbaird/Ice #642

- 链接：https://github.com/jordanbaird/Ice/issues/642
- 作者：[AndrewLazarus](https://github.com/AndrewLazarus)
- 状态：open
- 创建时间：2025-08-22T22:30:32Z（UTC）
- 更新时间：2025-10-23T10:05:54Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Clicking on BusyCal Menu in hidden section opened Apple Menu instead
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have about 12 menu bar icons, half hidden, half always visible. When BusyCal Menu was in the hidden section, clicking on its icon in the floating-under menu activated the Apple Menu instead. All other icons behaved as expected, both to the left and the right of BusyCal.

I moved BusyCal to the always visible section and it works correctly. Moving it back to a different position in the Hidden section and it works again!? However, the Apple Menu is now appearing at random times without any menu interaction.

### Steps to Reproduce

See description.

### Ice Version

0.11.12

### macOS Version

15.6

### Screenshots

_No response_
```

### jordanbaird/Ice #643

- 链接：https://github.com/jordanbaird/Ice/issues/643
- 作者：[gordonbazeley](https://github.com/gordonbazeley)
- 状态：open
- 创建时间：2025-08-24T14:06:36Z（UTC）
- 更新时间：2026-07-31T01:38:11Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Completely lost Stats app when dragging into Menu Bar Layout section
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I'm using the Tahoe beta and downloaded Ice Ice 0.11.12. I tried to drag an app (https://github.com/exelban/stats) into the Menu Bar Layout section and now it's totally lost i.e. not visible anywhere in the menu bar with or without Ice running.

I've deleted and reinstalled Stats and have just installed the beta version of Ice but can't find Stats anywhere - any ideas on how to reinstate it please?

### Steps to Reproduce

1. Dragged Stats app into Visible section of Menu Bar Layout
2. Stats app not longer visible anywhere

### Ice Version

0.11.12

### macOS Version

Tahoe latest beta

### Screenshots

_No response_
```

### jordanbaird/Ice #644

- 链接：https://github.com/jordanbaird/Ice/issues/644
- 作者：[Quorum75](https://github.com/Quorum75)
- 状态：open
- 创建时间：2025-08-25T16:15:45Z（UTC）
- 更新时间：2025-09-14T01:44:00Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: <Option-Click works randomly>
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Using option-click to open always hidden menu does not work properly. Sometimes it works sometimes it does not. 


Settings are obviously set up accordingly. 

### Steps to Reproduce

1. Option-click on Icebar
2. Always hidden bar does not show up


### Ice Version

0.11.12

### macOS Version

15.6.1

### Screenshots

<img width="886" height="619" alt="Image" src="https://github.com/user-attachments/assets/2bb26723-0247-4ab6-ad18-947957861bee" />
```

### jordanbaird/Ice #645

- 链接：https://github.com/jordanbaird/Ice/issues/645
- 作者：[alexwillem](https://github.com/alexwillem)
- 状态：open
- 创建时间：2025-08-26T06:56:18Z（UTC）
- 更新时间：2025-09-01T09:58:45Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: menubar periodical glitch every 'x' minutes
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

The right-hand side of the menubar glitches every 'x' minutes, as if it continuously refreshes (see recording). This happens with a split menubar as well as the full menubar (i haven't tried any other options at this point).

### Steps to Reproduce

leave the menubar running and it happens every 30(?)-45(?) minutes. I haven't worked that out yet

### Ice Version

0.11.12

### macOS Version

15.6.1

### Screenshots

https://github.com/user-attachments/assets/31af8ee9-e58b-4aa6-bea4-22ffb71fb2e0
```

### jordanbaird/Ice #646

- 链接：https://github.com/jordanbaird/Ice/issues/646
- 作者：[orc4hrie](https://github.com/orc4hrie)
- 状态：open
- 创建时间：2025-08-26T19:06:31Z（UTC）
- 更新时间：2025-10-17T12:45:31Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Clickable area to activate Ice extends beyond menu bar to blank area of 2nd monitor.
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Run Ice. Move mouse or click near top of 2nd monitor, on which there is no menubar. Observe Ice activating.

### Steps to Reproduce

Run Ice. Move mouse or click near top of 2nd monitor, on which there is no menubar. Observe Ice activating.

### Ice Version

0.11.12

### macOS Version

15.6.1

### Screenshots

_No response_
```

### jordanbaird/Ice #647

- 链接：https://github.com/jordanbaird/Ice/issues/647
- 作者：[clvpl911](https://github.com/clvpl911)
- 状态：open
- 创建时间：2025-08-26T19:43:37Z（UTC）
- 更新时间：2025-09-16T18:21:05Z（UTC）
- 标签：Bug
- 评论数：26（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: <MacOS Tahoe app craches>
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

The app does not work at all in macos tahoe

### Steps to Reproduce

open ice, try to use it

### Ice Version

0.11.12

### macOS Version

26.0

### Screenshots

_No response_
```

### jordanbaird/Ice #649

- 链接：https://github.com/jordanbaird/Ice/issues/649
- 作者：[Stranry](https://github.com/Stranry)
- 状态：open
- 创建时间：2025-09-01T09:51:25Z（UTC）
- 更新时间：2025-09-01T09:51:25Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: split menu bar weird behavior when showing the desktop
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

when I click the wallpaper to show the desktop, the mask and shadow of split menu bar will move with the normal running applications to the screen edge.

### Steps to Reproduce

1.Set the menu bar "Shape Kind" to "Split"
2.Click wallpaper to show the desktop
and then you'll see the problem

### Ice Version

0.11.12

### macOS Version

15.5

### Screenshots

<img width="3024" height="1964" alt="Image" src="https://github.com/user-attachments/assets/606c9faf-9907-43c8-8581-c30385b76ced" />
<img width="3030" height="1974" alt="Image" src="https://github.com/user-attachments/assets/8b42586e-d23c-479c-8d95-4b60d6cae456" />
```

### jordanbaird/Ice #651

- 链接：https://github.com/jordanbaird/Ice/issues/651
- 作者：[joaofrgomes](https://github.com/joaofrgomes)
- 状态：open
- 创建时间：2025-09-01T13:39:52Z（UTC）
- 更新时间：2025-09-01T13:39:52Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Allow the tint option to affect the menubar background only and add transparency slider to colour swatch(es)
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

The current “tint” option, under the Menu Bar Appearance section in Settings, affects the entirety of the menubar, including the Apple menu and other standard menu items, as well as the menu extras. This is undesirable behaviour, as it reduces contrast between the menu contents and its background.

Also, this light tint, even if it did affect the background only, wouldn't offer as much contrast as entirely opaque or slightly transparent colours would. Adding a transparency slider for the single colour and the gradient swatches would allow for full control over the menubar's look, and having this layer disappear when triggering Mission Control would make for the most functionally optimal and aesthetically pleasing look.

I am fully aware that these options might not work perfectly on setups with wildly varying desktop backgrounds across different displays and Mission Control spaces, but for micromanagers and perfectionists it could greatly enhance the experience of customizing one's desktop, especially after Apple's new Liquid Glass's gaussian blur effects started clashing in a very ugly fashion with custom menubar backgrounds embedded into desktop pictures (see screenshots), unlike in earlier macOS versions (Big Sur – Sequoia).

<img width="2560" height="199" alt="Image" src="https://github.com/user-attachments/assets/7e432625-4090-4b64-aac9-121d2fb8ed86" />
<img width="2560" height="199" alt="Image" src="https://github.com/user-attachments/assets/391bd6a6-e03b-45e6-816b-5b81091542a8" />

### Screenshots

_No response_
```

### jordanbaird/Ice #655

- 链接：https://github.com/jordanbaird/Ice/issues/655
- 作者：[nez329](https://github.com/nez329)
- 状态：open
- 创建时间：2025-09-04T22:44:40Z（UTC）
- 更新时间：2026-03-13T12:36:35Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: ICE - Some Apps icons not appearing in the Menu Bar Layout setting
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

There are currently 3 apps icons not showing up in the Menu Bar Layout settings. 
Because they don’t appear, I cannot drag them to my desired layout (Visible Section, Hidden Section, or Always-Hidden Section). 

Strangly, these 3 Apps icons only show up in the "Always-Hidden Section" on the desktop just not in the Menu Bar Layout setting under "Always-Hidden Section".

<img width="1147" height="602" alt="Image" src="https://github.com/user-attachments/assets/6bedc600-bbc2-4cbb-9207-0c410a810aa2" />

### Steps to Reproduce

1.  These 3 Apps were installed at different times.
2. Macwhisper, Clean Links & CmdList
3. 2 of the Apps immediately do not appear in the Menubar Layout Settings. Macwhisper sometimes it will appear in the the Menubar Layout Settings at times it not disappear.
4. To clarify these 3 Apps icons can be seen & accessible from the desktop when the "Always-Hidden Section" is revealed but it just not appear in the Menubar Layout Settings
5.  I also notice that some other apps after I install, I need to wait a few hours before it appear in Menubar Layout setting before I can rearrange them.

### Ice Version

0.11.12

### macOS Version

15.6.1

### Screenshots

Interestingly, the icons for these 3 Apps only appear in the "Always-Hidden Section" on the desktop, but they are missing from the Menu Bar Layout settings under the "Always-Hidden Section."

<img width="1147" height="602" alt="Image" src="https://github.com/user-attachments/assets/3674b2c8-335f-49d7-955e-5e2ca73a5df5" />
```

### jordanbaird/Ice #656

- 链接：https://github.com/jordanbaird/Ice/issues/656
- 作者：[gitmichaelqiu](https://github.com/gitmichaelqiu)
- 状态：open
- 创建时间：2025-09-05T14:45:22Z（UTC）
- 更新时间：2025-09-08T07:12:05Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: <macOS Tahoe> Cannot move live activities across sections
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

On macOS 26, when moving live activities menu bar items from Always-Hidden Section to Visible Section, the operation fails with "Bounds check time out for 'Item-18'".

### Steps to Reproduce

1. Create a live activity on iPhone (so it will be synced to macOS)
2. Try moving live activity in Ice Settings/Menu Bar Layout across sections
3. The operation fails with "Bounds check time out for 'Item-18'"

### Ice Version

0.11.13-dev.1

### macOS Version

26.0 Beta (25A5351b)

### Screenshots

<img width="260" height="234" alt="Image" src="https://github.com/user-attachments/assets/c6d3501e-804f-47f7-9449-dcd00b4eca97" />
```

### jordanbaird/Ice #657

- 链接：https://github.com/jordanbaird/Ice/issues/657
- 作者：[Haruno19](https://github.com/Haruno19)
- 状态：open
- 创建时间：2025-09-05T16:34:16Z（UTC）
- 更新时间：2025-09-05T16:34:16Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: the Menu Bar's height with "Shape kind = full" is a few pixels too short on second monitor
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

If I enable the "Full" Shape Kind in the Menu Bar Appearance setting, while on my MacBook's screen (which has the notch) the size is correct and equal to that of the native Menu Bar, on my secondary monitor (1920x1080p resolution) the bar appears a few pixels shorter (both from above and below). 

### Steps to Reproduce

1. Set Menu Bar Shape > Shape Kind to "Full", and both angles as squared

### Ice Version

0.11.12

### macOS Version

15.6.1 (24G90)

### Screenshots

On the secondary monitor:
<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/39d9dc89-2118-46b2-9959-7b9cc6086bce" />

<img width="728" height="45" alt="Image" src="https://github.com/user-attachments/assets/926707b8-5205-48c9-8685-6e0d24f40b4a" />
  
  

On the MBP monitor:
<img width="1512" height="982" alt="Image" src="https://github.com/user-attachments/assets/69d4968d-c6d9-4e85-a0ae-54a54b1ec438" />
```

### jordanbaird/Ice #658

- 链接：https://github.com/jordanbaird/Ice/issues/658
- 作者：[aatwiz](https://github.com/aatwiz)
- 状态：open
- 创建时间：2025-09-07T11:49:04Z（UTC）
- 更新时间：2025-09-07T11:49:04Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: <Getting focused out while playing league>
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Ever since I downloaded ice, whenever i play league ill randomly get focused out of the game while playing, this means i cant cast or anything until i left click the screen again, it can get quite annoying during team fights

### Steps to Reproduce

1. play league of legends on fullscreen
2. I imagine try clicking outside the screen? I have a 2 monitor setup

### Ice Version

0.11.12

### macOS Version

15.6.1

### Screenshots

_No response_
```

### jordanbaird/Ice #659

- 链接：https://github.com/jordanbaird/Ice/issues/659
- 作者：[3CatSpam](https://github.com/3CatSpam)
- 状态：open
- 创建时间：2025-09-08T10:27:23Z（UTC）
- 更新时间：2025-09-08T10:27:23Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: <MacOS Tahoe> the bar appearance shows a slight shadow on top on the screen
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

when using ice's appearance modifyer, this is visible on the screen

<img width="1470" height="74" alt="Image" src="https://github.com/user-attachments/assets/cb72d145-b5e3-40b6-8c1c-60825e10a358" />

### Steps to Reproduce

go to appearance, enable it

### Ice Version

0.11.13-dev.1

### macOS Version

Tahoe beta 9 (26.0)

### Screenshots

<img width="1470" height="74" alt="Image" src="https://github.com/user-attachments/assets/afeb1f02-728c-4663-9cf9-0ec1d9f61a9e" />
```

### jordanbaird/Ice #661

- 链接：https://github.com/jordanbaird/Ice/issues/661
- 作者：[iwebpatch](https://github.com/iwebpatch)
- 状态：open
- 创建时间：2025-09-10T02:23:34Z（UTC）
- 更新时间：2025-09-10T02:23:42Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: When visible section application is updated, it will go to hidden section.
```

**正文原文**

```markdown
### Check Existing Issues

- [ ] I have checked existing issues, and this issue is not a duplicate

### Description

Hope it still stay in visible section forever.

### Steps to Reproduce

1. drag application from hidden section to  visible section 
2. update application
3. the application will go to hidden section

### Ice Version

0.11.12

### macOS Version

15.6.1

### Screenshots

_No response_
```

### jordanbaird/Ice #664

- 链接：https://github.com/jordanbaird/Ice/issues/664
- 作者：[Ibrty](https://github.com/Ibrty)
- 状态：open
- 创建时间：2025-09-15T00:45:22Z（UTC）
- 更新时间：2025-09-16T12:40:02Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: MacOS Tahoe Breaks Menu Bar Layout Editor
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

With MacOS Tahoe, you are unable to arrange your menu bar layout between visible, hidden and always hidden sections as the entire thing appears white.

### Steps to Reproduce

With MacOS Tahoe Installed, go to IceBar Settings
Select Menu Bay Layout
See Issue

### Ice Version

0.11.12

### macOS Version

Tahoe 26.0

### Screenshots

<img width="1792" height="1260" alt="Image" src="https://github.com/user-attachments/assets/5a036f6e-44fd-4571-82ae-bceaf2acbfdc" />
```

### jordanbaird/Ice #665

- 链接：https://github.com/jordanbaird/Ice/issues/665
- 作者：[Ibrty](https://github.com/Ibrty)
- 状态：open
- 创建时间：2025-09-15T01:03:46Z（UTC）
- 更新时间：2025-11-30T12:51:16Z（UTC）
- 标签：Bug
- 评论数：20（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: MacOS Tahoe Makes Ice Bar Invisible
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

If you have the Ice Bar enabled with MacOS Tahoe 26.0, the Ice Bar is invisible when you hover over the menu bar.
Also if you have the Ice Bar selected to Ice Icon, the app will crash. 

Screen Recording wouldnt upload so I had to make a link

### Steps to Reproduce

With MacOS Tahoe 26.0 installed, enable the Ice Bar
Hover Mouse over menu bar
See issue

### Ice Version

0.11.12

### macOS Version

Tahoe 26.0

### Screenshots

https://www.icloud.com/attachment/?u=https%3A%2F%2Fcvws.icloud-content.com%2FB%2FAb0JLsZy34_MxvuuH6Tdt6gzidefAXM0-rUC2KWQl43d-hmGXfBK8eVy%2F%24%7Bf%7D%3Fo%3DAu-LGljb2d2zXlLvQOJLFg2CwfDsQBkisZLQ4awI-Tt6%26v%3D1%26x%3D3%26a%3DCAog7ov1t7bC2dZWPDD2fp7MmRgLg2QsH6oWSIqKXdQtLqwSbxDCwZbXlDMYwtGRq54zIgEAUgQzidefWgRK8eVyaic3hVoRIoEZ5XnP7qOnNLloHkFj9CqtUIQAJ8X0ZCEspgzvq_T_CKVyJyzGg7LoWvqlrfT_znZhHq-awvF7JLAEjUSWUs5qpq39l-67342F_g%26e%3D1760490186%26fl%3D%26r%3D1BD093E5-09BF-4251-A8E9-E08732D0F28F-1%26k%3D%24%7Buk%7D%26ckc%3Dcom.apple.clouddocs%26ckz%3Dcom.apple.CloudDocs%26p%3D41%26s%3Dv5QeCDjGWb2ty7-KnMv7kEA2eMo&uk=mMBq7Tf_KDUHMzUEQFBY7g&f=Screen%20Recording%202025-09-14%20at%205.55.41%E2%80%AFPM.mov&sz=78451618
```

### jordanbaird/Ice #666

- 链接：https://github.com/jordanbaird/Ice/issues/666
- 作者：[akrabat](https://github.com/akrabat)
- 状态：open
- 创建时间：2025-09-15T09:46:36Z（UTC）
- 更新时间：2026-08-12T14:07:21Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Items that change become hidden
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I use SwiftBar to display the currently playing song. Every so often, I look up at the menu bar and the SwiftBar item has been moved to hidden.

### Steps to Reproduce

1. Install Swifter and the now playing script
2. Play some music
3. Ensure that the music's title is visible
4. Wait
5. Notice that the music's title is no longer visible and is in the hidden section of Ice's settings

### Ice Version

0.11.13-dev.1

### macOS Version

Sequoia 15.6.1

### Screenshots

_No response_
```

### jordanbaird/Ice #668

- 链接：https://github.com/jordanbaird/Ice/issues/668
- 作者：[wesbos](https://github.com/wesbos)
- 状态：open
- 创建时间：2025-09-16T14:27:15Z（UTC）
- 更新时间：2025-09-18T01:03:48Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Search Items issues
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I am running 0.11.13 on mac os 26.0 (25A354) - not sure if this is related to tahoe update or not.

When opening the search there are two issues:

1. Light mode icons are on a white background, making them hard to see:

<img width="600" height="400" alt="Image" src="https://github.com/user-attachments/assets/35a05e71-1ba5-46b0-849c-83dc65d780b4" />

2. The names of the icons are almost entirely things like "Item-0" without names. 

<img width="600" height="400" alt="Image" src="https://github.com/user-attachments/assets/74fc6945-15e3-40f7-97bd-aab6a01e9b95" />

### Steps to Reproduce

see above

### Ice Version

0.11.13 

### macOS Version

26.0

### Screenshots

_No response_
```

### jordanbaird/Ice #669

- 链接：https://github.com/jordanbaird/Ice/issues/669
- 作者：[Carlos2CV](https://github.com/Carlos2CV)
- 状态：open
- 创建时间：2025-09-16T15:34:31Z（UTC）
- 更新时间：2025-09-20T06:38:02Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: <crashes on MACOS  26 tahoe 26>
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I installed mACOS 26 Tahoe. I start Ice 0.11.12, it works fine and hides the icons.
when I click ice to unhide the icons, the hidden icons appear, but Ice app crashes

"Ice quit unexpectedly.

Click Reopen to open the
application again. Click Report to
see more detailed information and
send a report to Apple."

Process:             Ice [12652]
Path:                /Applications/2tools/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [907]
User ID:             501

Date/Time:           2025-09-16 11:31:53.9210 -0400
Launch Time:         2025-09-16 11:29:35.7314 -0400
Hardware Model:      Mac14,2
OS Version:          macOS 26.0 (25A354)
Release Type:        User

Crash Reporter Key:  
Incident Identifier: 

Sleep/Wake UUID:       1

Time Awake Since Boot: 55000 seconds
Time Since Wake:       15695 seconds

System Integrity Protection: enabled

Triggered by Thread: 0

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x00000001028e0934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [12652]


Thread 0 Crashed:
0   Ice                           	       0x1028e0934 0x1028d4000 + 51508
1   Ice                           	       0x102996b18 0x1028d4000 + 797464
2   Ice                           	       0x102996aa0 0x1028d4000 + 797344
3   Ice                           	       0x1029955e0 0x1028d4000 + 792032
4   Ice                           	       0x1029547e1 0x1028d4000 + 526305
5   Ice                           	       0x1028f4151 0x1028d4000 + 131409
6   Ice                           	       0x1028f7fb9 0x1028d4000 + 147385
7   Ice                           	       0x1028e6319 0x1028d4000 + 74521
8   libswift_Concurrency.dylib    	       0x2954b8dfd completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x19cd71c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x19cd84028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x19cd7a98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x19cd71fb4 mach_msg + 24
4   CoreFoundation                	       0x19ce53c80 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x19ce525d8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x19cf10898 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x1a12d0a68 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x19cdb4c08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x19cdafba8 thread_start + 8

Thread 2:

Thread 3:

Thread 4:

Thread 5:

Thread 6:

Thread 7:

Thread 8:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x00000008c631a580   x1: 0x21000002097b37bf   x2: 0x00000002097b37b8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x0000000218544ebb  x10: 0x00000008d725f903  x11: 0x00000000000003ff
   x12: 0x0000000000000226  x13: 0x00000008c60aa250  x14: 0x21000002097b37bf  x15: 0x00000002097b37b8
   x16: 0x21000002097b37bf  x17: 0x0000000000000040  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x00000008c631a580  x21: 0x00000008c6860a00  x22: 0x00000008c7e1d400  x23: 0x0000000000000002
   x24: 0x0000000102a7d000  x25: 0x00000008c7624a80  x26: 0x00000008c61b4e70  x27: 0x00000008c5fa79a0
   x28: 0xffffffff76ffffff   fp: 0x000000016d5278a0   lr: 0x00000001028e0928
    sp: 0x000000016d527880   pc: 0x00000001028e0934 cpsr: 0x60001000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x1028d4000 -        0x102a63fff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/2tools/Ice.app/Contents/MacOS/Ice
       0x102bbc000 -        0x102bfffff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/2tools/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x102cf8000 -        0x102d03fff libobjc-trampolines.dylib (*) <580e4b29-8304-342d-a21c-2a869364dc35> /usr/lib/libobjc-trampolines.dylib
       0x116bbc000 -        0x117377fff com.apple.AGXMetalG14G (340.26.3) <8728f149-6387-37a3-a4a7-f2deabe30f9e> /System/Library/Extensions/AGXMetalG14G.bundle/Contents/MacOS/AGXMetalG14G
       0x29544b000 -        0x2954d5317 libswift_Concurrency.dylib (*) <55c416d8-c572-3449-9302-a64cc8a57360> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x19cd71000 -        0x19cdad45f libsystem_kernel.dylib (*) <2eb73bf1-8c71-3e1f-a160-6da83dc82606> /usr/lib/system/libsystem_kernel.dylib
       0x19cdf4000 -        0x19d340f7f com.apple.CoreFoundation (6.9) <edb39786-80b1-3bff-b6c3-e33f2e3ca867> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x1a1221000 -        0x1a291cd9f com.apple.AppKit (6.9) <6d84c7a3-ee98-3daf-ac66-cd95a902ba84> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x19cdae000 -        0x19cdbaabb libsystem_pthread.dylib (*) <5d31d65c-2ecf-36da-84f5-ba4caab06adb> /usr/lib/system/libsystem_pthread.dylib
       0x1fee50000 -        0x200494df7 com.apple.ANECompiler (9.32.12) <b55b0ca3-cfb7-3bff-9017-2e101221faee> /System/Library/PrivateFrameworks/ANECompiler.framework/Versions/A/ANECompiler

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

### Steps to Reproduce

open ice
click ice to hunted icons
ice chrashes 

### Ice Version

0.11.12

### macOS Version

26

### Screenshots

_No response_
```

### jordanbaird/Ice #671

- 链接：https://github.com/jordanbaird/Ice/issues/671
- 作者：[Michiin](https://github.com/Michiin)
- 状态：open
- 创建时间：2025-09-16T17:47:39Z（UTC）
- 更新时间：2025-09-17T07:37:39Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: unexpected closure
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

after the latest upgrade on my Macbook, MacOS 26, after months of perfect performance, the app has problems, when ii click on the icon in the upper menu bar it disappears and the Mac show me the message of "unexpected closure", then when I click to re-open the app it shows the icon on the menu bar but If I try to click on it to show the other hidden icons the Mac notification show me again the message of "unexpected closure", it's a loop 

### Steps to Reproduce

Click on the icon in the upper menu bar
When the Mac notification appears click on re-open


### Ice Version

0.11.12

### macOS Version

Mac OS Thaoe 26

### Screenshots

_No response_
```

### jordanbaird/Ice #673

- 链接：https://github.com/jordanbaird/Ice/issues/673
- 作者：[Klejdis2003](https://github.com/Klejdis2003)
- 状态：open
- 创建时间：2025-09-16T20:47:50Z（UTC）
- 更新时间：2026-01-29T10:19:46Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Search Not Working, Mac OS Tahoe
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

Search menu does not show any items, neither when opened nor when searching.

### Steps to Reproduce

1. Open Search Bar Menu
2. Everything Looks Empty

### Ice Version

0.11.12

### macOS Version

26

### Screenshots

<img width="646" height="446" alt="Image" src="https://github.com/user-attachments/assets/419c71c1-e90b-41e6-9dc5-f65282938823" />
```

### jordanbaird/Ice #675

- 链接：https://github.com/jordanbaird/Ice/issues/675
- 作者：[victorchor](https://github.com/victorchor)
- 状态：open
- 创建时间：2025-09-17T01:23:02Z（UTC）
- 更新时间：2025-09-20T13:43:26Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Always Hidden Icons Disappeared.
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have moved icons in menu bar to Always Hidden, but now I can't recover the icons have been moved to Always Hidden back to Visible Section. 

I checked in menu bar layout setting in the Ice preferences, but it shown nothing. 

### Steps to Reproduce

1. Ice Settings. 
2. Menu Bar Layout. 

### Ice Version

0.11.12

### macOS Version

26

### Screenshots

![Image](https://github.com/user-attachments/assets/55c7ab35-23d8-41c4-b50a-85d71e317743)  
```

### jordanbaird/Ice #676

- 链接：https://github.com/jordanbaird/Ice/issues/676
- 作者：[mauricevs1969](https://github.com/mauricevs1969)
- 状态：open
- 创建时间：2025-09-17T03:04:34Z（UTC）
- 更新时间：2025-10-01T11:16:31Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Empty space on the left side of the right menu bar when split, MacOS Tahoe
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

<img width="1015" height="23" alt="Image" src="https://github.com/user-attachments/assets/61dde04a-ce27-4f53-a9ad-37a18f9bc06c" />
When using Ice with the Split menu bar shape, I get a lot of empty space on the left side of the right menu bar. This issue persists after restarting Ice, and upon moving icons. Other settings do not seem to affect the issue.

### Steps to Reproduce

Run MacOS Tahoe and start Ice, set shape to "Split"

### Ice Version

0.11.12

### macOS Version

Tahoe

### Screenshots

<img width="1015" height="23" alt="Image" src="https://github.com/user-attachments/assets/df9dbc16-76c3-43f7-bd0d-33237bfde87e" />
```

### jordanbaird/Ice #677

- 链接：https://github.com/jordanbaird/Ice/issues/677
- 作者：[Hoshikawakaguya](https://github.com/Hoshikawakaguya)
- 状态：open
- 创建时间：2025-09-17T04:13:49Z（UTC）
- 更新时间：2025-09-21T04:42:15Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Ice bar do not work:endless loading menu bar items
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

<img width="968" height="680" alt="Image" src="https://github.com/user-attachments/assets/5980eeff-69ca-4923-ba63-14deeaa2b931" />

Like picture, the loading never ends and I can not use ice bar.
 for version beta 1 it works.

### Steps to Reproduce

1 start ice bar

### Ice Version

0.11.13-dev-2

### macOS Version

26.0

### Screenshots

_No response_
```

### jordanbaird/Ice #679

- 链接：https://github.com/jordanbaird/Ice/issues/679
- 作者：[liaadee](https://github.com/liaadee)
- 状态：open
- 创建时间：2025-09-17T10:59:25Z（UTC）
- 更新时间：2026-02-23T08:06:41Z（UTC）
- 标签：Bug
- 评论数：25（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: "Unable to display menu bar items" on macOS Tahoe/Ice 0.11.13-dev.2
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I get the message "Unable to display menu bar items" and no icons shown under "Visible" and "Hidden" sections under Menu Bar Layout of Ice settings as well as upon clicking the Ice icon in my menu bar. 

I've granted all necessary system permissions for Ice; quitting and restarting Ice; reinstalling Ice; enabling/disabling "Show menu bar background" in System Settings, but this issue persists.

### Steps to Reproduce

1. Open Ice Settings
2. Go to Menu Bar Layout
3. Click the Ice icon in the menu bar

### Ice Version

0.11.13-dev.2

### macOS Version

Tahoe 26.0

### Screenshots

**Screenshot of Menu Bar Layout (Ice settings) and after clicking the Ice icon (ellipsis) in my menu bar; "Show menu bar background" is enabled in System Settings:**
<img width="928" height="675" alt="Image" src="https://github.com/user-attachments/assets/0c1b8367-fdd2-43d4-908d-eaf9ae6607a0" />
```

### jordanbaird/Ice #682

- 链接：https://github.com/jordanbaird/Ice/issues/682
- 作者：[avincent98144](https://github.com/avincent98144)
- 状态：open
- 创建时间：2025-09-17T17:53:14Z（UTC）
- 更新时间：2025-09-18T22:36:25Z（UTC）
- 标签：Bug
- 评论数：7（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: <Menebar Layout Pane>
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

In the Menubar Layout Pane, all three field are empty, no icon of my existing menubar items - so - I can not arrange, hide or show.

### Steps to Reproduce

Choose Menubar Layout pane

### Ice Version

0.11.12

### macOS Version

26

### Screenshots

_No response_
```

### jordanbaird/Ice #683

- 链接：https://github.com/jordanbaird/Ice/issues/683
- 作者：[duran-duran-duran](https://github.com/duran-duran-duran)
- 状态：open
- 创建时间：2025-09-18T09:37:23Z（UTC）
- 更新时间：2025-09-18T09:37:23Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: (Tahoe Beta) Hover affects across screens
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

I have two screens that both show the menu bar. When I move my mouse cursor over the menu bar in the active screen, Ice reveals the hidden area/icons on both screens simultaneously. Thought this wasn't the expected behavior.



### Steps to Reproduce

Move your cursor to a menu bar in a screen to confirm Ice gets activated and then see the other screen.



### Ice Version

0.11.13-dev2

### macOS Version

26.0

### Screenshots

_No response_
```

### jordanbaird/Ice #685

- 链接：https://github.com/jordanbaird/Ice/issues/685
- 作者：[akramanwar44](https://github.com/akramanwar44)
- 状态：open
- 创建时间：2025-09-18T15:30:55Z（UTC）
- 更新时间：2025-09-18T15:30:55Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
Whitened sections in Menu Bar Layout
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

A bug on macOS 26 which whitened the two sections under "Menu Bar Layout" i.e., Visible section & Hidden section. Please refer attachments

### Steps to Reproduce

Go to Menu Bar Layout

### Ice Version

0.11.12

### macOS Version

macOS Tahoe 26

### Screenshots

<img width="894" height="617" alt="Image" src="https://github.com/user-attachments/assets/d8f7f6f2-10b5-47fd-bb54-ba4eb3b7142f" />
```

### jordanbaird/Ice #686

- 链接：https://github.com/jordanbaird/Ice/issues/686
- 作者：[tosbsas](https://github.com/tosbsas)
- 状态：open
- 创建时间：2025-09-18T17:16:05Z（UTC）
- 更新时间：2025-09-19T13:31:22Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: <bug title>Ice bar won't let me choose app
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When using Icebar it hides again before I can choose the icon I want to touch

### Steps to Reproduce

Go tu menubar
Press Ice
Icebar opens 
try choosing an item - bar disappears before I can close

### Ice Version

0.11.13dev2

### macOS Version

Tahoe

### Screenshots

_No response_
```

### jordanbaird/Ice #687

- 链接：https://github.com/jordanbaird/Ice/issues/687
- 作者：[antkn33](https://github.com/antkn33)
- 状态：open
- 创建时间：2025-09-18T22:39:46Z（UTC）
- 更新时间：2026-08-26T23:01:59Z（UTC）
- 标签：Bug
- 评论数：18（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Doesn't display menu bar layout
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

When I open Ice settings and go to menu bar layout, the screen just displays "loading menu bar items" but never displays the items

### Steps to Reproduce

Settings
Menu bar layout


### Ice Version

.11.13 dev-2

### macOS Version

26

### Screenshots

<img width="894" height="559" alt="Image" src="https://github.com/user-attachments/assets/09326790-1d67-4063-8293-262154dfb045" />
```

### jordanbaird/Ice #691

- 链接：https://github.com/jordanbaird/Ice/issues/691
- 作者：[randomnsk](https://github.com/randomnsk)
- 状态：open
- 创建时间：2025-09-19T17:24:46Z（UTC）
- 更新时间：2025-09-19T17:24:46Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Allow unhide all when the display is larger
```

**正文原文**

```markdown
### Check Existing Issues

- [x] I have checked existing issues, and this issue is not a duplicate

### Description

It would be great to be able to configure a screen size above which ice will show all items (except Always hidden) rather than having the same behavior on all screens. 

So if the configured size is 3000px, everything over will have default unhide and on the smaller Mac Screen it would be the normal behavior. 

Thanks

### Screenshots

_No response_
```

### jordanbaird/Ice #694

- 链接：https://github.com/jordanbaird/Ice/issues/694
- 作者：[viswa0028](https://github.com/viswa0028)
- 状态：open
- 创建时间：2025-09-21T18:08:58Z（UTC）
- 更新时间：2025-09-25T12:31:56Z（UTC）
- 标签：Bug
- 评论数：7（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Once opened does not go back again
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Once I click on the icon, It is displaying the contents in the menubar but not going back to the Ice icon Again

### Steps to Reproduce

Click on the icon
Not returning back to icon again 
Needs to relaunched again


### App Version

0.11.12

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #695

- 链接：https://github.com/jordanbaird/Ice/issues/695
- 作者：[pchmykh](https://github.com/pchmykh)
- 状态：open
- 创建时间：2025-09-22T07:26:07Z（UTC）
- 更新时间：2025-09-22T17:03:50Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: ICE window opens on ICE menubar click + at login
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

ICE window (settings etc.) opens every time I'm clicking ICE menubar icon. Also, it opens every login. macOS Tahoe, ICE 0.11.12

### Steps to Reproduce

1. Click on ICE menubar icon (chevron in my case) OR just login
2. ICE window (options, etc.) opens

### App Version

0.11.12

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #696

- 链接：https://github.com/jordanbaird/Ice/issues/696
- 作者：[sayhiwael2017-web](https://github.com/sayhiwael2017-web)
- 状态：open
- 创建时间：2025-09-22T16:32:29Z（UTC）
- 更新时间：2025-09-24T16:52:14Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: nothing showing up in the menu editing
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

you can see it clearly on the screenshot

### Steps to Reproduce

it's always there

### App Version

0.11.12

### macOS Version

26

### Additional Information

<img width="892" height="610" alt="Image" src="https://github.com/user-attachments/assets/b70a00b3-b667-40f9-9633-dd6d6571d082" />
```

### jordanbaird/Ice #697

- 链接：https://github.com/jordanbaird/Ice/issues/697
- 作者：[deadcoder0904](https://github.com/deadcoder0904)
- 状态：open
- 创建时间：2025-09-23T05:52:10Z（UTC）
- 更新时间：2025-09-23T05:52:10Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Make Lungo/Dato work with Ice
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Lungo doesn't open or work with Ice.

I'd like both of them to work together.

My Mac keeps sleeping & its a handy little app to make it stay awake. I also love Ice but this is its only issue. Both are in my must-haves along with Dato.

But both Dato/Lungo don't work with Ice. I'd really love that to happen.

### Steps to Reproduce

1. Install Dato or Lungo
2. Install Ice
3. Open both & see Dato or Lungo both don't open with Ice installed
4. With no Ice, both Dato & Lungo work

### App Version

Latest

### macOS Version

Latest

### Additional Information

_No response_
```

### jordanbaird/Ice #698

- 链接：https://github.com/jordanbaird/Ice/issues/698
- 作者：[patbarry29](https://github.com/patbarry29)
- 状态：open
- 创建时间：2025-09-23T09:04:09Z（UTC）
- 更新时间：2026-07-09T15:18:13Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: On Tahoe, Items appear different sizes across monitor and laptop screen
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When I open Ice on my monitor, the items on the monitor appear at a normal size, while on the laptop screen they are 2-3x bigger. 

That is one problem, another problem is it simply does not show the icons when I hover and when I try to open Ice via Spotlight, it refuses to open. So I have to go to Activity Monitor to shut down from there. 

### Steps to Reproduce

1. Quit Ice if open
2. Open Ice on monitor screen. 
3. Hover over menu bar on (1080p) monitor screen, check if normal.
4. Hover over menu bar on laptop (M1 Air) screen, check if normal or enlarged.

Bug 2:
1. Use Ice normally.
2. At some point the hover functionality stops working. 
3. Then try to open Ice via spotlight. This is when it fails for me.

### App Version

0.11.13-dev.2

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #701

- 链接：https://github.com/jordanbaird/Ice/issues/701
- 作者：[lcottingham](https://github.com/lcottingham)
- 状态：open
- 创建时间：2025-09-23T15:15:52Z（UTC）
- 更新时间：2025-10-07T09:20:06Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Volume UI hidden on change if menu bar icon is hidden
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The volume and brightness UIs have changed in Tahoe.
https://discussions.apple.com/thread/256140322?sortBy=rank

If the parent icons are hidden by ICE, then popup UI's are also hidden on volumne/brightness change.

### Steps to Reproduce

1. Hide the Volume icon in ICE from the menu bar
2. Change the volume using a keyboard key (F11/F12)
3. UI does not display in the top right

### App Version

0.11.13

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #702

- 链接：https://github.com/jordanbaird/Ice/issues/702
- 作者：[macsen0](https://github.com/macsen0)
- 状态：open
- 创建时间：2025-09-23T20:46:26Z（UTC）
- 更新时间：2025-10-01T19:09:58Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Hidden items randomly moved to always hidden items
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Ice, out of nowhere, decides that all my hidden items ar now on the always hidden items. The bar appear empty and everything moved to the always hidden. This is on B2 on Tahoe

### Steps to Reproduce

FIx icons on hidden
Wait or reboot
now everything is hidden

### App Version

11-13 Dev 2

### macOS Version

Tahoe 26

### Additional Information

_No response_
```

### jordanbaird/Ice #703

- 链接：https://github.com/jordanbaird/Ice/issues/703
- 作者：[JonathanJLevine](https://github.com/JonathanJLevine)
- 状态：open
- 创建时间：2025-09-24T04:41:35Z（UTC）
- 更新时间：2025-12-16T21:21:43Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Ice Bar only on Macs with a Notch
```

**正文原文**

```markdown
Would love to have the ability to enable the Ice Bar only on MacBooks with a notch, or the ability to exclude the Ice Bar from being used on an external monitor (similar to Bartender for Mac).
```

### jordanbaird/Ice #704

- 链接：https://github.com/jordanbaird/Ice/issues/704
- 作者：[eureka-pg](https://github.com/eureka-pg)
- 状态：open
- 创建时间：2025-09-24T11:25:32Z（UTC）
- 更新时间：2025-09-24T11:25:32Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: menu bar items (iphone notifications) cannot be moved
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

getting error message item took too long to respond - these are for live notifications coming from i

<img width="257" height="226" alt="Image" src="https://github.com/user-attachments/assets/f5139a26-6189-4e6e-8499-154d57f5982d" />

phone see image

### Steps to Reproduce

menu bar layout, trying to move within any menu bar ie. always hidden to visible, or visible to visible

### App Version

0.11.13-dev.2

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #705

- 链接：https://github.com/jordanbaird/Ice/issues/705
- 作者：[dortamiguel](https://github.com/dortamiguel)
- 状态：open
- 创建时间：2025-09-24T15:06:25Z（UTC）
- 更新时间：2025-09-24T15:06:25Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Allow clear shape kind
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

I want to completely clear the menubar background but there is only three options.

The split shape with round caps is the closer I can get, but I will like to completely remove the grey background.

Could that be something that is possible?

<img width="1512" height="787" alt="Image" src="https://github.com/user-attachments/assets/949e6269-868a-480e-b0ee-a176278235dd" />

### Additional Information

_No response_
```

### jordanbaird/Ice #707

- 链接：https://github.com/jordanbaird/Ice/issues/707
- 作者：[odinb](https://github.com/odinb)
- 状态：open
- 创建时间：2025-09-24T18:14:31Z（UTC）
- 更新时间：2025-09-24T18:14:31Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: When using Cloudflare WARP with Ice, the WARP GUI is malfunctioning until iCE is restarted.
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When using Cloudflare WARP with Ice, the WARP GUI is malfunctioning until iCE is restarted.

### Steps to Reproduce

Cloudflare is set to autostart via /Library/LaunchDaemons.
Reboot computer
Try to access the WARP GUI via Ice menu, this will be unsuccessful unless you catch it initially when connecting. This means you are unable to enable/disable the tunnel.
Quit Ice and restart it
Now WARP GUI works as expected.

### App Version

0.11.12

### macOS Version

15.7

### Additional Information

Cloudflare WARP version: 2025.6.1335.0
```

### jordanbaird/Ice #708

- 链接：https://github.com/jordanbaird/Ice/issues/708
- 作者：[lethefrost](https://github.com/lethefrost)
- 状态：open
- 创建时间：2025-09-24T18:50:41Z（UTC）
- 更新时间：2025-09-24T19:05:22Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Ice Bar and Show on Hover hovering area detection bug when system menu bar is on auto-hide mode
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

1. If in the system setting, the menu bar is set to auto hide, 
2. and one of the following two is true:
    - _Case 1_: in Ice, the option "**Use Ice Bar**" (hidden menu items as a separate bar) is also turned on, or
    - _Case 2_: the menu bar (without Ice Bar, hidden items expanding directly in the menu bar on showing) is on an **external monitor**:

## Ice Bar Disappears Immediately after Mouse Movement

Then Ice Bar below the system menu bar disappears immediately, right after user mouse has any slightest movement (even still staying in the top row area of the screen and the system menu bar hasn't been hidden yet), which is way too fast and doesn't allow any user interaction at all with ice bar items before it disappears.

In _Case 2_ (On the external monitor without Ice Bar), the expanded hidden items collapse immediately as well after any cursor movement and cannot be interacted with either.


## Empty Area of the Menu Bar not Triggering Show-on-Hover

3. If in Ice, the option "Show on hover" is also set: 

In both _Case 1_ and _Case 2_, hovering in any empty area wouldn't trigger showing the Ice Bar. Only when the cursor is exactly hovering on the very edge/boundary of the screen top (at which point it cannot go any upper than that), it pops up the Ice Bar (but still disappears immediately as described above).
- However, if Ice Bar is turned off (the hidden items are expanding in the menu bar), the empty area detection works normally, but only on the built-in monitor; On an external monitor (_Case 2_), it still requires the screen edge to trigger.


## Other Settings

I have tested with several settings in Ice. However, whether ice bar is shown on click, on hover, on scroll, and its location is dynamic, under mouse pointer or ice icon, and automatically rehide strageties (and even turning off automatically rehide), and hide app menus or not, show on hover delay, etc., it seems that they didn't make any difference and are probably not related. The only factor that I found can stably reproduce this is the system menu bar auto-hide setting. As long as it's on auto hide mode, the empty area of the menu bar row cannot trigger show-on-hover and Ice Bar seems to consistently disappear immediately whenever mouse moves regardless of other Ice Bar settings. When it's set to not auto hide, then the aforementioned behaviors return to normal/expected.

### Steps to Reproduce

1. Go to system settings, set menu bar to auto hide
2. Test the aforementioned actions and setups

### App Version

0.11.13-dev.2

### macOS Version

macOS Tahoe 26.0

### Additional Information

Thank you for developing and maintaining this great project. Please let me know if any further information is needed or you have trouble reproducing it! ☺️
```

### jordanbaird/Ice #710

- 链接：https://github.com/jordanbaird/Ice/issues/710
- 作者：[fred913](https://github.com/fred913)
- 状态：open
- 创建时间：2025-09-25T11:39:06Z（UTC）
- 更新时间：2026-01-06T22:03:03Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Ice shows "Unable to display menu bar item" under macOS 26 Tahoe
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Whenever in Ice settings or in the menu bar (after clicking Ice icon), it shows "Unable to display menu bar item" instead of icons.

### Steps to Reproduce

Update to latest dev pre-release, launch Ice and try to open the second Ice menu bar.

### App Version

0.11.13-dev.2

### macOS Version

Version 26.0 (25A354)

### Additional Information

0.11.13-dev.1 works almost okay, except Siri is lying in Ice and not getting out of it, and it suddenly puts anything inside Ice on the first launch. I'm still investigating further but I only have limited experience of developing on mac, so if there is a way I can e.g. extract a log file or do some tests, pls feel free tell me
```

### jordanbaird/Ice #711

- 链接：https://github.com/jordanbaird/Ice/issues/711
- 作者：[zakariachahbar](https://github.com/zakariachahbar)
- 状态：open
- 创建时间：2025-09-25T11:58:09Z（UTC）
- 更新时间：2026-03-28T18:31:09Z（UTC）
- 标签：Bug
- 评论数：36（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: "Unable to display menu bar items" | macOS Tahoe Version 26.0 (25A354) | Ice 0.11.13-dev.2
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Hi,

First off, thank you very much for everything you have been doing. I've been using Ice for the past 2 years since the Bartender sale fiasco.

Issue
---
When activating `Ice Bar` 

- On hover/click on menu bar, no items can be shown and I get the following message: "Unable to display menu bar items"
- In Ice setting "Menu Bar Layout", the following message is shown (cf screenshot #3): "Unable to display menu bar items"

Unsuccessful remediation tried
---
1. Restarting the laptop
2. Reinstalling Ice 0.11.13-dev.2 (_complete uninstall (1) Dragging Ice to the bin and (2) Using AppCleaner_)
3. Running command `sudo xattr -dr com.apple.quarantine /Applications/Ice.app`

Authorizations
---
All authorizations to Ice are given:
1. System Settings > Privacy & Security > Accessibility
2. System Settings > Privacy & Security > Screen & System Audio Recording

Screenshots
---
<img width="328" height="76" alt="Image" src="https://github.com/user-attachments/assets/75faf907-4ba9-40fe-9419-23b2345c60e9" />


<img width="890" height="353" alt="Image" src="https://github.com/user-attachments/assets/46f6fb72-c6ff-4b9a-9cde-f4045d44268b" />


<img width="885" height="388" alt="Image" src="https://github.com/user-attachments/assets/09b2bbde-39a7-4fdf-bf4f-08a6ce7f48ab" />

### Steps to Reproduce

1. Go to Ice settings "General"
2. Activate "Use Ice Bar"
3. Click/Hover the menu bar
4. See message "Unable to display menu bar items"

### App Version

0.11.13-dev.2

### macOS Version

26.0 (25A354)

### Additional Information

_No response_
```

### jordanbaird/Ice #712

- 链接：https://github.com/jordanbaird/Ice/issues/712
- 作者：[CutterKnife](https://github.com/CutterKnife)
- 状态：open
- 创建时间：2025-09-25T15:24:13Z（UTC）
- 更新时间：2025-10-24T08:46:43Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: Localize Ice
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Thank you for this wonderful app!

I would like to translate Ice into Japanese. While I don't have the technical skills to implement a language switching feature myself, I'm happy to help with the Japanese translation.
Would you be interested in localizing the app?

### Additional Information

_No response_
```

### jordanbaird/Ice #713

- 链接：https://github.com/jordanbaird/Ice/issues/713
- 作者：[ymleung314](https://github.com/ymleung314)
- 状态：open
- 创建时间：2025-09-25T17:30:51Z（UTC）
- 更新时间：2025-09-25T17:30:51Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Blacklist instead of whitelist strategy
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

All menu bar items are automatically hidden by default, including system menu bar items like Focus modes. The minimal version may be just an option to switch strategy so any new/unseen items are shown by default. Something more could be like showing system menu bar items at all time as an option.

### Additional Information

_No response_
```

### jordanbaird/Ice #714

- 链接：https://github.com/jordanbaird/Ice/issues/714
- 作者：[ymleung314](https://github.com/ymleung314)
- 状态：open
- 创建时间：2025-09-25T17:38:32Z（UTC）
- 更新时间：2025-09-25T17:38:32Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Show Ice bar on hover should not trigger in Mission Control view
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

In Mission Control view (the one you open by swiping up with three fingers or control+up), moving the cursor to the top to reveal desktops/apps often opens Ice bar accidentally.

### Steps to Reproduce

As described above.

### App Version

0.11.13-dev.2

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #715

- 链接：https://github.com/jordanbaird/Ice/issues/715
- 作者：[odysseus90210](https://github.com/odysseus90210)
- 状态：open
- 创建时间：2025-09-25T19:27:02Z（UTC）
- 更新时间：2025-09-25T21:44:18Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: If a system menu icon/text winds up in the notch area, it simply disappears!
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

If an upcoming event has an overly long title as displayed by Fantastical in the menu bar, an icon to the left of that event may get pushed into the notch area on my M1 MacBook Pro. When this happens, the "pushed" icon simply disappears! It isn't displayed when one clicks on the system menu bar with the "Show on Click" option enabled.

### Steps to Reproduce

1. See attached screenshot

<img width="2492" height="1336" alt="Image" src="https://github.com/user-attachments/assets/616b809a-0880-466e-887f-15bf40c650a8" />

### App Version

0.11.12

### macOS Version

15.7

### Additional Information

_No response_
```

### jordanbaird/Ice #716

- 链接：https://github.com/jordanbaird/Ice/issues/716
- 作者：[ranwoo1234](https://github.com/ranwoo1234)
- 状态：open
- 创建时间：2025-09-26T06:26:57Z（UTC）
- 更新时间：2026-08-26T10:14:30Z（UTC）
- 标签：Bug
- 评论数：21（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu Bar Layout BLANK (can't see any icons)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Updated Macbook Pro to Tahoe 26.0 and now I can't see any of the icons in Menu Bar Layout settings, no matter if I do "LIGHT"/"DARK"/"AUTO" appearance settings, it always looks like this:

<img width="911" height="633" alt="Image" src="https://github.com/user-attachments/assets/248ec232-a969-48e1-9141-8e1cfde91bc5" />

### Steps to Reproduce

Ice settings > Menu Bar Layout

### App Version

0.11.12

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #717

- 链接：https://github.com/jordanbaird/Ice/issues/717
- 作者：[ymleung314](https://github.com/ymleung314)
- 状态：open
- 创建时间：2025-09-26T17:26:58Z（UTC）
- 更新时间：2025-09-26T17:26:58Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Show on swipe works but not scroll
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

As titled.

### Steps to Reproduce

1. Turn on Ice bar
2. Enable Show on scroll and disable Show on hover
3. By using swipe with two finger, you can trigger the Ice bar
4. But with a mouse scroll wheel, you can't

### App Version

0.11.13-dev.2

### macOS Version

26.0

### Additional Information

_No response_
```

### jordanbaird/Ice #718

- 链接：https://github.com/jordanbaird/Ice/issues/718
- 作者：[linusxiong](https://github.com/linusxiong)
- 状态：open
- 创建时间：2025-09-27T05:53:13Z（UTC）
- 更新时间：2025-09-27T05:53:13Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Cannot hide its icon when using game mode
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When in game mode on macOS, the game mode icon cannot be hidden, and clicking the dot does not drop down to show the hidden icons.

### Steps to Reproduce

1. just open a game

### App Version

0.11.13-dev.2

### macOS Version

26.0 (25A354)

### Additional Information

<img width="1878" height="1246" alt="Image" src="https://github.com/user-attachments/assets/b8a15595-be2e-402e-b6b2-94482885cd04" />
```

### jordanbaird/Ice #719

- 链接：https://github.com/jordanbaird/Ice/issues/719
- 作者：[y90ziv](https://github.com/y90ziv)
- 状态：open
- 创建时间：2025-09-28T09:54:28Z（UTC）
- 更新时间：2025-10-13T14:16:35Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Volume/brightness HUD not visible when Ice is running on macOS Tahoe
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

### Description
After upgrading to macOS Tahoe (macOS 26), the new system HUD for volume and brightness (which should appear in the top-right corner under the menu bar) no longer displays when Ice is running.  

old look:
<img width="410" height="310" alt="Image" src="https://github.com/user-attachments/assets/5a5a34b2-e89b-4266-b34e-b9c38c317bf0" />

new look:
<img width="362" height="119" alt="Image" src="https://github.com/user-attachments/assets/6b9c894e-3e8e-4cb8-910e-b00247be8e6e" />

If I quit Ice, the HUD works as expected. When Ice is active, no visual feedback is shown at all when adjusting volume/brightness with the function keys.  

### Steps to Reproduce

### Steps to Reproduce
1. Install and run Ice on macOS Tahoe.
2. Press the volume up/down (or brightness up/down) keys on the keyboard.
3. Observe: no HUD indicator appears on screen.

### Expected Behavior
The small HUD (notification-style overlay) for volume/brightness should still be displayed, even while Ice is running.

### Actual Behavior
HUD does not appear at all when Ice is active. Only visible after quitting Ice.


### App Version

Ice 0.11.13 (macOS Tahoe Beta 2)

### macOS Version

Tahoe (macOS 26.0)

### Additional Information

### Environment
- macOS: Tahoe (macOS 26.0)
- Ice version: Ice 0.11.13 (macOS Tahoe Beta 2)
- Mac model: M3 14"
- Reproducibility: Always

### Additional Notes
This seems to be a regression with macOS Tahoe. On previous macOS versions, the old center-screen HUD was unaffected by Ice.  
```

### jordanbaird/Ice #721

- 链接：https://github.com/jordanbaird/Ice/issues/721
- 作者：[2albion](https://github.com/2albion)
- 状态：open
- 创建时间：2025-09-28T18:03:51Z（UTC）
- 更新时间：2025-10-08T07:11:08Z（UTC）
- 标签：Bug
- 评论数：11（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Latest Tahoe Beta update gives Ice error, Ice freezes
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

At first instead of the hidden menu bar appearing, I got an error message that ice can't be displayed and clicking or right-clicking on the Ice icon did nothing. On later attempts, I got the menu bar at first, then it behaved as before except without the error message. 

In both cases, I looked at the Activity Monitor which showed that Ice was not responding. I stopped it each time and tried again with the same results 

### Steps to Reproduce

1. Get the Mac beta update.
2. Try to make Ice work.

### App Version

Current

### macOS Version

26.1 yesterday's beta update

### Additional Information

_No response_
```

### jordanbaird/Ice #723

- 链接：https://github.com/jordanbaird/Ice/issues/723
- 作者：[K45Tom](https://github.com/K45Tom)
- 状态：open
- 创建时间：2025-09-30T05:10:49Z（UTC）
- 更新时间：2025-10-16T17:20:55Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Icons don’t stay at its place - they flip after restart (Sequoia & Tahoe)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Arranged Icons flip after restart of the system and need to be rearranged.

### Steps to Reproduce

Restart system

### App Version

0.11.13 - dev.2

### macOS Version

15.7.1 & 26.1 public beta

### Additional Information

_No response_
```

### jordanbaird/Ice #724

- 链接：https://github.com/jordanbaird/Ice/issues/724
- 作者：[tifrato](https://github.com/tifrato)
- 状态：open
- 创建时间：2025-09-30T09:20:19Z（UTC）
- 更新时间：2026-03-17T13:37:03Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Hide Ice icon from dock
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

I'd like to be able to hide the Ice icon from the dock. I use the feature to show running Apps there, but Ice should be kind of a background application and the icon could be hidden from the dock.

Typically the LSUIElement flag in Info.plist could be set to False, but this will change the Apps signature, so I can't do this as a workaround.

Am I missing a feature in the settings pane or do you have other suggestions!

I definitely love using Ice! So keep up the good work!

### Additional Information

_No response_
```

### jordanbaird/Ice #725

- 链接：https://github.com/jordanbaird/Ice/issues/725
- 作者：[rebelspike](https://github.com/rebelspike)
- 状态：open
- 创建时间：2025-09-30T16:01:31Z（UTC）
- 更新时间：2026-07-06T21:51:46Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: App icon opens on hover
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have the menu bar in split mode with hover mode on. After updating to macOS Tahoe, when I hover over the menu bar, the menu bar shows the hidden icons as it should. Still, the left side, with the file, edit, view, etc. buttons for an app, automatically hides itself, and the app icon pops up in the dock.  This didn't happen in macOS Sequoia, only with Tahoe. The app icon does go away when I move the mouse away from the menu bar, but I don't want it popping up, and the left side disappears on hover

### Steps to Reproduce

1. Make sure u are on macOS Tahoe
2. Turn on mouse hovering and split mode for the menu bar
3. When u move the mouse to the menu bar, it should show the hidden icons. It will also hide the left side of the menu bar and show the app icon in the dock

### App Version

0.11.12

### macOS Version

26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #726

- 链接：https://github.com/jordanbaird/Ice/issues/726
- 作者：[ildiem](https://github.com/ildiem)
- 状态：open
- 创建时间：2025-10-01T01:46:51Z（UTC）
- 更新时间：2025-10-01T01:46:51Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: Clicking on center of menu bar reveals the desktop
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

I was fiddling around with the split menu bar appearance, and since the desktop wallpaper peeks through with that layout, I thought it would be nice if clicking on the middle area could reveal the desktop (since this feature already exists when you click on the actual wallpaper area). Obviously would be incompatible with clicking on menu bar to reveal hidden icons.

(incredible work on this btw!)

### Additional Information

_No response_
```

### jordanbaird/Ice #727

- 链接：https://github.com/jordanbaird/Ice/issues/727
- 作者：[mrleblanc101](https://github.com/mrleblanc101)
- 状态：open
- 创建时间：2025-10-02T13:59:00Z（UTC）
- 更新时间：2025-12-24T12:21:58Z（UTC）
- 标签：Feature
- 评论数：3（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Feature Request]: Bartender 3 mode
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Hi,
Currently, when I click the Ice icon, the "hidden" icons are added at the end like this:

Collapsed:
<img width="1920" height="31" alt="Image" src="https://github.com/user-attachments/assets/8fe86947-837b-4588-b431-f8906f2421ad" />

Expanded:
<img width="1920" height="31" alt="Image" src="https://github.com/user-attachments/assets/cdaaaf10-8b42-4898-969d-f8749954e751" />

In Bartender 3, there was an option for the hidden item to replace the icons at the left of the Ice icon like this.

Expanded with Bartender 3 mode:
<img width="1920" height="32" alt="Image" src="https://github.com/user-attachments/assets/487be47f-dce6-4218-b7e1-c85558a16138" />

This option has existed in all subsequent version of Bartender as "Bartender 3 mode".
They later renamed the option, but it doesn't work at all... Bartender 6 seems to be very buggy.
That's how and why I discovered Ice.
<img width="669" height="118" alt="Image" src="https://github.com/user-attachments/assets/065b841c-6d3d-48e0-8911-f38435ea28b9" />

### Additional Information

_No response_
```

### jordanbaird/Ice #728

- 链接：https://github.com/jordanbaird/Ice/issues/728
- 作者：[mrleblanc101](https://github.com/mrleblanc101)
- 状态：open
- 创建时间：2025-10-02T14:04:21Z（UTC）
- 更新时间：2025-10-02T14:06:47Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Chevron separator is always shown
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Currently, if I change the `|` to the `<` icon, the chevron is always shown, but the `|` is only shown why dragging.
I think this behavior should be separate. Being able to change the icon, but still have it hide when nothing is being dragger.

### Steps to Reproduce

- Open Ice Settings
- Go to advanced
- Go to section divider style
- Choose Chevron

### App Version

0.11.13-dev.2

### macOS Version

26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #729

- 链接：https://github.com/jordanbaird/Ice/issues/729
- 作者：[nullsin](https://github.com/nullsin)
- 状态：open
- 创建时间：2025-10-02T17:06:10Z（UTC）
- 更新时间：2025-11-28T18:39:05Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Menu Bar Item Stuck After Ice Bar Click When Live Activities are Active
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Dear Dev,

Issue:
If the menu bar contains Live Activities synchronized from an iPhone, clicking the icon within Ice Bar will move the item from the Hidden section to the Visible section permanently. The item then becomes "stuck" in the visible section and does not automatically re-hide to the Ice Bar.

Expected Behaviour:
When Live Activities is present, item clicked to be shown from the Ice Bar's hidden section, it should respect the automatic hiding mechanism and automatically hide back into Ice Bar.

### Steps to Reproduce

1. when Live Activities is present
2. click any icon within Ice Bar
3. this icon will not re-hide to Ice Bar when time is up

### App Version

0.11.13-dev.2

### macOS Version

macOS 26.1 (25B5042k)

### Additional Information

_No response_
```

### jordanbaird/Ice #730

- 链接：https://github.com/jordanbaird/Ice/issues/730
- 作者：[molodemb](https://github.com/molodemb)
- 状态：open
- 创建时间：2025-10-03T09:41:22Z（UTC）
- 更新时间：2025-10-15T01:35:34Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu bar layout in settings bug
```

**正文原文**

```markdown
### Search for Similar Reports

- [ ] I have searched existing issues for similar reports

### Description

Menu bar layout in settings doesn't show visible and hidden section apps for arrangement

### Steps to Reproduce

1. Settings
2. Menu Bar Layout

### App Version

0.11.12

### macOS Version

26.0.1

### Additional Information

<img width="899" height="630" alt="Image" src="https://github.com/user-attachments/assets/c81602dc-48b6-44f6-baef-42515e9d87e5" />
```

### jordanbaird/Ice #731

- 链接：https://github.com/jordanbaird/Ice/issues/731
- 作者：[ivantomicic](https://github.com/ivantomicic)
- 状态：open
- 创建时间：2025-10-03T10:30:52Z（UTC）
- 更新时间：2025-10-03T10:30:52Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Feature Request]: Allow live activities to show
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

I might be missing a settings option but live activities don't show. unless I click on these arrows - it would be useful to be able to allow them to show by default similar to how they do without Ice.

Thanks!

<img width="1152" height="554" alt="Image" src="https://github.com/user-attachments/assets/6e8fe679-31ae-41e2-a94c-18dd6628e8bb" />

### Additional Information

_No response_
```

### jordanbaird/Ice #732

- 链接：https://github.com/jordanbaird/Ice/issues/732
- 作者：[ahmetb](https://github.com/ahmetb)
- 状态：open
- 创建时间：2025-10-03T16:53:29Z（UTC）
- 更新时间：2026-08-06T16:48:45Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Docker for Mac ends up in "Always-Hidden Section" over time
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

For whatever reason, the "Docker for Mac" app's icon ends up in the Always-Hidden section even though I manually moved it to the Always Visible section probably for the 10th time over the past year or so. I can't explain why this keeps happening. 

### Steps to Reproduce

1. Install Docker for Mac + make it launch on startup
2. Move it to Always Visible section on Ice
3. Wait days/weeks/months (not sure how long)
4. it'll probably end up in Always-Hidden section over time

### App Version

0.11.12

### macOS Version

15.7.1

### Additional Information

This has been going on for a really long time (I installed Ice ~almost a year ago) so this survived multiple Ice versions / macOS versions.
```

### jordanbaird/Ice #733

- 链接：https://github.com/jordanbaird/Ice/issues/733
- 作者：[kimproductions](https://github.com/kimproductions)
- 状态：open
- 创建时间：2025-10-03T21:03:52Z（UTC）
- 更新时间：2025-10-03T21:03:52Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Strange rendering issue
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

sometimes when hovering mouse to show, it will only render a little bit and then i have to move the mouse over the whole menu bar to show it. Video shows first part of it, couldn't capture when exactly it happens

https://github.com/user-attachments/assets/681d6028-0d67-4449-a2d2-523ef97c379d

### Steps to Reproduce

Set menubar to show on hover, randomly sometimes hover the mouse over, and then see strange pixelation rendering effect

### App Version

0.11.12

### macOS Version

14.4.1

### Additional Information

_No response_
```

### jordanbaird/Ice #739

- 链接：https://github.com/jordanbaird/Ice/issues/739
- 作者：[moisesrodriguez](https://github.com/moisesrodriguez)
- 状态：open
- 创建时间：2025-10-08T21:48:37Z（UTC）
- 更新时间：2025-10-08T21:48:37Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: No proper behaviour when multiple bar item of same app
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have three OneDrive accounts running, but when I click on one of the items, the other items "disappear".



### Steps to Reproduce

1. Show hidden items
2. Click on a hidden item (on of three OneDrive items)

### App Version

0.11.13-dev.2

### macOS Version

26.0.1

### Additional Information

Evidence:
https://link.moisesrodriguez.com/7lvYhwNJ
```

### jordanbaird/Ice #740

- 链接：https://github.com/jordanbaird/Ice/issues/740
- 作者：[Tinrobotguy](https://github.com/Tinrobotguy)
- 状态：open
- 创建时间：2025-10-09T19:38:38Z（UTC）
- 更新时间：2025-10-10T17:48:01Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Crashes every time I use it
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

After expanding the menu using the arrow icon, ICE crashes. I can't return back to collapsed view.

### Steps to Reproduce

after expanding menu, the ICE app crashes

### App Version

0.11.12

### macOS Version

26.01

### Additional Information

_No response_
```

### jordanbaird/Ice #741

- 链接：https://github.com/jordanbaird/Ice/issues/741
- 作者：[MalloryKnox86](https://github.com/MalloryKnox86)
- 状态：open
- 创建时间：2025-10-10T16:12:41Z（UTC）
- 更新时间：2025-10-17T20:48:02Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Apps gone from Ice Layout
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

All the apps are gone from the layout in settings, so I have all the apps that I normally have on my hidden section crammed up in the visible section because I cannot move them 



### Steps to Reproduce

Open settings, go to menu bar layout 

### App Version

 0.11.12

### macOS Version

26.0.1

### Additional Information

<img width="882" height="610" alt="Image" src="https://github.com/user-attachments/assets/e83321fe-959a-4757-b513-24df3a39df61" />

<img width="564" height="41" alt="Image" src="https://github.com/user-attachments/assets/8f66425a-8212-4b57-91ee-bea267a3bd9d" />
```

### jordanbaird/Ice #742

- 链接：https://github.com/jordanbaird/Ice/issues/742
- 作者：[vindaso](https://github.com/vindaso)
- 状态：open
- 创建时间：2025-10-10T16:38:53Z（UTC）
- 更新时间：2025-11-02T22:57:02Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: I just installed Tahoe in my Mac and ICE is not working as it used to.  I am attaching the log report sent back form IOS.  Since the principal functionality that stopped work is to have the menu in a separate bar below the menu bar.
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Ice [5788]
Path:                /Applications/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Background
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [3423]
User ID:             501

Date/Time:           2025-10-10 10:15:12.2987 -0600
Launch Time:         2025-10-10 10:14:09.4623 -0600
Hardware Model:      Mac14,5
OS Version:          macOS 26.0.1 (25A362)
Release Type:        User

Crash Reporter Key:  B008B43F-A46C-8641-97D7-4E254364EFA3
Incident Identifier: 8F0FB8C2-618E-4682-879B-E0CC817949A4

Sleep/Wake UUID:       824C2CD6-4153-4286-95AC-E572F5ACDFD9

Time Awake Since Boot: 2800 seconds
Time Since Wake:       362 seconds

System Integrity Protection: enabled

Triggered by Thread: 0

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x0000000100414934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [5788]


Thread 0 Crashed:
0   Ice                           	       0x100414934 0x100408000 + 51508
1   Ice                           	       0x1004cab18 0x100408000 + 797464
2   Ice                           	       0x1004caaa0 0x100408000 + 797344
3   Ice                           	       0x1004c95e0 0x100408000 + 792032
4   Ice                           	       0x1004887e1 0x100408000 + 526305
5   Ice                           	       0x100428151 0x100408000 + 131409
6   Ice                           	       0x10042bfb9 0x100408000 + 147385
7   Ice                           	       0x10041a319 0x100408000 + 74521
8   libswift_Concurrency.dylib    	       0x2942eddfd completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x19bba5c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x19bbb8028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x19bbae98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x19bba5fb4 mach_msg + 24
4   CoreFoundation                	       0x19bc87c80 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x19bc865d8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x19bd44898 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x1a0104a68 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x19bbe8c08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x19bbe3ba8 thread_start + 8

Thread 2:

Thread 3:

Thread 4:

Thread 5:

Thread 6:

Thread 7:

Thread 8:

Thread 9:

Thread 10:

Thread 11:

Thread 12:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000b1a219680   x1: 0x06000002085e77bf   x2: 0x00000002085e77b8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x0000000217378ebb  x10: 0x0000000b05a7f903  x11: 0x00000000000003ff
   x12: 0x00000000000001a6  x13: 0x0000000b1ace1a50  x14: 0x06000002085e77bf  x15: 0x00000002085e77b8
   x16: 0x06000002085e77bf  x17: 0x000000000000000a  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x0000000b1a219680  x21: 0x0000000b1b915b80  x22: 0x0000000b1a75b200  x23: 0x0000000000000002
   x24: 0x00000001005b1000  x25: 0x0000000b1b39ca80  x26: 0x0000000b1a2419e0  x27: 0x0000000b1a3dec00
   x28: 0xffffffff76ffffff   fp: 0x000000016f9f5ad0   lr: 0x0000000100414928
    sp: 0x000000016f9f5ab0   pc: 0x0000000100414934 cpsr: 0x60001000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x100408000 -        0x100597fff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/Ice.app/Contents/MacOS/Ice
       0x1006f0000 -        0x100733fff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x100aa0000 -        0x100aabfff libobjc-trampolines.dylib (*) <580e4b29-8304-342d-a21c-2a869364dc35> /usr/lib/libobjc-trampolines.dylib
       0x116f20000 -        0x1176dffff com.apple.AGXMetalG14X (340.26.3) <9ba70456-c7ed-37f6-84f9-879fec3ed54e> /System/Library/Extensions/AGXMetalG14X.bundle/Contents/MacOS/AGXMetalG14X
       0x294280000 -        0x29430a317 libswift_Concurrency.dylib (*) <55c416d8-c572-3449-9302-a64cc8a57360> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x19bba5000 -        0x19bbe145f libsystem_kernel.dylib (*) <2eb73bf1-8c71-3e1f-a160-6da83dc82606> /usr/lib/system/libsystem_kernel.dylib
       0x19bc28000 -        0x19c174f7f com.apple.CoreFoundation (6.9) <edb39786-80b1-3bff-b6c3-e33f2e3ca867> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x1a0055000 -        0x1a1750cdf com.apple.AppKit (6.9) <9aef8974-703a-3941-9b3d-de8c5ccb61d0> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x19bbe2000 -        0x19bbeeabb libsystem_pthread.dylib (*) <5d31d65c-2ecf-36da-84f5-ba4caab06adb> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.7G resident=0K(0%) swapped_out_or_unallocated=1.7G(100%)
Writable regions: Total=188.3M written=593K(0%) resident=593K(0%) swapped_out=0K(0%) unallocated=187.7M(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               256K        2 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                          1040K       12 
ColorSync                          624K       29 
CoreAnimation                     14.1M       68 
CoreGraphics                        48K        3 
CoreUI image data                 2272K       17 
Dispatch continuations            96.0M        1 
Foundation                          16K        1 
Kernel Alloc Once                   32K        1 
MALLOC                            64.9M       42 
MALLOC guard page                 4080K        4 
STACK GUARD                       56.2M       13 
Stack                             14.4M       13 
VM_ALLOCATE                       3712K       15 
__AUTH                            5734K      633 
__AUTH_CONST                      87.7M     1017 
__CTF                               824        1 
__DATA                            29.3M      967 
__DATA_CONST                      32.7M     1026 
__DATA_DIRTY                      8773K      881 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       595.8M        5 
__OBJC_RO                         78.1M        1 
__OBJC_RW                         2561K        1 
__TEXT                             1.2G     1046 
__TEXT (graphics)                 9536K        2 
__TPRO_CONST                       128K        2 
mapped file                      259.8M       43 
page table in kernel               593K        1 
shared memory                     2464K       18 
===========                     =======  ======= 
TOTAL                              2.5G     5869 


-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2025-10-10 10:15:12.00 -0600","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.0.1 (25A362)","roots_installed":0,"name":"Ice","incident_id":"8F0FB8C2-618E-4682-879B-E0CC817949A4"}
{
  "uptime" : 2800,
  "procRole" : "Background",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac14,5",
  "coalitionID" : 3423,
  "osVersion" : {
    "train" : "macOS 26.0.1",
    "build" : "25A362",
    "releaseType" : "User"
  },
  "captureTime" : "2025-10-10 10:15:12.2987 -0600",
  "codeSigningMonitor" : 2,
  "incident" : "8F0FB8C2-618E-4682-879B-E0CC817949A4",
  "pid" : 5788,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-10-10 10:14:09.4623 -0600",
  "procStartAbsTime" : 67236584291,
  "procExitAbsTime" : 68744587899,
  "procName" : "Ice",
  "procPath" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"A3D82F4D-D655-5F5D-A51C-0F4F6E07A9FA","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "B008B43F-A46C-8641-97D7-4E254364EFA3",
  "developerMode" : 1,
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570503953,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"6AwAsAGpQPngAxSqvucElPMDAKrgAxSqxOcElLMB+Ldo\/mDTiAAAtA==","atPC":"IAAg1BMAgNIoAIBS6DMAOQgdABJgggiq\/XtCqfRPQan\/wwCRwANf1g=="},
  "bootSessionUUID" : "64D19257-5925-4A9F-A7EB-771671C38671",
  "wakeTime" : 362,
  "sleepWakeUUID" : "824C2CD6-4153-4286-95AC-E572F5ACDFD9",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000001, 0x0000000100414934","rawCodes":[1,4299245876],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":5788},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":123947,"threadState":{"x":[{"value":47683049088},{"value":432345572957910975,"symbolLocation":432345564227567623,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8730343352,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":1},{"value":68719476739},{"value":7},{"value":68719476739},{"value":7},{"value":1},{"value":8979451579,"objc-selector":"windowNumber"},{"value":47339534595},{"value":1023},{"value":422},{"value":47694355024},{"value":432345572957910975,"symbolLocation":432345564227567623,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8730343352,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":432345572957910975,"symbolLocation":432345564227567623,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":10},{"value":0},{"value":4294967296},{"value":47683049088},{"value":47707151232},{"value":47688561152},{"value":2},{"value":4300935168},{"value":47701412480},{"value":47683213792},{"value":47684905984},{"value":18446744071411073023}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4299245864},"cpsr":{"value":1610616832},"fp":{"value":6167681744},"sp":{"value":6167681712},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4299245876,"matchesCrashFrame":1},"far":{"value":0}},"frames":[{"imageOffset":51508,"imageIndex":0},{"imageOffset":797464,"imageIndex":0},{"imageOffset":797344,"imageIndex":0},{"imageOffset":792032,"imageIndex":0},{"imageOffset":526305,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":147385,"imageIndex":0},{"imageOffset":74521,"imageIndex":0},{"imageOffset":450045,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":4}]},{"id":123965,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":31235},{"value":0},{"value":18446744073709551569},{"value":8753293072},{"value":0},{"value":4294967295},{"value":2},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":6170534024},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6907723816},"cpsr":{"value":4096},"fp":{"value":6170533872},"sp":{"value":6170533792},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907649076},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":6},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":6},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":6},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":6},{"imageOffset":392320,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":7},{"imageOffset":386520,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":7},{"imageOffset":1165464,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":7},{"imageOffset":719464,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":8},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":9},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":9}]},{"id":123978,"frames":[],"threadState":{"x":[{"value":6173405184},{"value":56891},{"value":6172868608},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6173405184},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":124549,"frames":[],"threadState":{"x":[{"value":6168244224},{"value":9807},{"value":6167707648},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6168244224},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126544,"frames":[],"threadState":{"x":[{"value":6169964544},{"value":70955},{"value":6169427968},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6169964544},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126546,"frames":[],"threadState":{"x":[{"value":6172258304},{"value":61987},{"value":6171721728},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6172258304},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126563,"frames":[],"threadState":{"x":[{"value":6174552064},{"value":65659},{"value":6174015488},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6174552064},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126818,"frames":[],"threadState":{"x":[{"value":6168817664},{"value":130915},{"value":6168281088},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6168817664},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126819,"frames":[],"threadState":{"x":[{"value":6169391104},{"value":46755},{"value":6168854528},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6169391104},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126820,"frames":[],"threadState":{"x":[{"value":6171111424},{"value":130811},{"value":6170574848},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6171111424},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126821,"frames":[],"threadState":{"x":[{"value":6171684864},{"value":71847},{"value":6171148288},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6171684864},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126822,"frames":[],"threadState":{"x":[{"value":6172831744},{"value":45303},{"value":6172295168},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6172831744},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6907902868},"far":{"value":0}}},{"id":126823,"frames":[],"threadState":{"x":[{"value":6173978624},{"value":0},{"value":6173442048},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6173978624},"esr":{"value":0},"pc":{"value":6907902868},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4299194368,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4302241792,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/Applications\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4306108416,
    "size" : 49152,
    "uuid" : "580e4b29-8304-342d-a21c-2a869364dc35",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4679925760,
    "CFBundleShortVersionString" : "340.26.3",
    "CFBundleIdentifier" : "com.apple.AGXMetalG14X",
    "size" : 8126464,
    "uuid" : "9ba70456-c7ed-37f6-84f9-879fec3ed54e",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG14X.bundle\/Contents\/MacOS\/AGXMetalG14X",
    "name" : "AGXMetalG14X",
    "CFBundleVersion" : "340.26.3"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 11075584000,
    "size" : 566040,
    "uuid" : "55c416d8-c572-3449-9302-a64cc8a57360",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6907645952,
    "size" : 246880,
    "uuid" : "2eb73bf1-8c71-3e1f-a160-6da83dc82606",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6908182528,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5558144,
    "uuid" : "edb39786-80b1-3bff-b6c3-e33f2e3ca867",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4040.1.401"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6979670016,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24100064,
    "uuid" : "9aef8974-703a-3941-9b3d-de8c5ccb61d0",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.10.110"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6907895808,
    "size" : 51900,
    "uuid" : "5d31d65c-2ecf-36da-84f5-ba4caab06adb",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6902890496,
  "size" : 5557583872,
  "uuid" : "4300eabe-4963-34ab-a648-3d68753cf4e1"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.7G resident=0K(0%) swapped_out_or_unallocated=1.7G(100%)\nWritable regions: Total=188.3M written=593K(0%) resident=593K(0%) swapped_out=0K(0%) unallocated=187.7M(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               256K        2 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                          1040K       12 \nColorSync                          624K       29 \nCoreAnimation                     14.1M       68 \nCoreGraphics                        48K        3 \nCoreUI image data                 2272K       17 \nDispatch continuations            96.0M        1 \nFoundation                          16K        1 \nKernel Alloc Once                   32K        1 \nMALLOC                            64.9M       42 \nMALLOC guard page                 4080K        4 \nSTACK GUARD                       56.2M       13 \nStack                             14.4M       13 \nVM_ALLOCATE                       3712K       15 \n__AUTH                            5734K      633 \n__AUTH_CONST                      87.7M     1017 \n__CTF                               824        1 \n__DATA                            29.3M      967 \n__DATA_CONST                      32.7M     1026 \n__DATA_DIRTY                      8773K      881 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       595.8M        5 \n__OBJC_RO                         78.1M        1 \n__OBJC_RW                         2561K        1 \n__TEXT                             1.2G     1046 \n__TEXT (graphics)                 9536K        2 \n__TPRO_CONST                       128K        2 \nmapped file                      259.8M       43 \npage table in kernel               593K        1 \nshared memory                     2464K       18 \n===========                     =======  ======= \nTOTAL                              2.5G     5869 \n",
  "legacyInfo" : {
  "threadTriggered" : {

  }
},
  "logWritingSignature" : "013f9aa9ad815fe86e70b09e044a7e784b508f60",
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "645197bf528fbf3c3af54105",
      "factorPackIds" : {
        "SIRI_VALUE_INFERENCE_PERVASIVE_ENTITY_RESOLUTION" : "663e65b4a1526e1ca0e288a1"
      },
      "deploymentId" : 240000002
    },
    {
      "rolloutId" : "648cada15dbc71671bb3aa1b",
      "factorPackIds" : {
        "SIRI_EXPERIENCE_CAM" : "65a81173096f6a1f1ba46525"
      },
      "deploymentId" : 240000116
    }
  ],
  "experiments" : [

  ]
}
}

Model: Mac14,5, BootROM 13822.1.2, proc 12:8:4 processors, 64 GB, SMC 
Graphics: Apple M2 Max, Apple M2 Max, Built-In
Display: Color LCD, 3024 x 1964 Retina, Main, MirrorOff, Online
Display: DELL E2214H, 1920 x 1080 (1080p FHD - Full High Definition), MirrorOff, Online
Memory Module: LPDDR5, Micron
AirPort: spairport_wireless_card_type_wifi (0x14E4, 0x4388), wl0: Jul 23 2025 02:15:12 version 23.41.4.0.41.51.197 FWID 01-673dce38
IO80211_driverkit-1525.88 "IO80211_driverkit-1525.88" Aug  6 2025 21:19:03
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Wi-Fi, AirPort, en0
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.


### Steps to Reproduce

1. Precondition:  Have the "Use Ice Bar" option enabled. 
2. Meanwhile the ICE.app is running, go to the upper menu bar.
3. Right click on Ice dot icon.
4. Select Show the Hidden Section.

### App Version

0.11.12

### macOS Version

26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #743

- 链接：https://github.com/jordanbaird/Ice/issues/743
- 作者：[leblancjisc](https://github.com/leblancjisc)
- 状态：open
- 创建时间：2025-10-10T22:10:21Z（UTC）
- 更新时间：2025-10-26T19:00:12Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: I cannot see any icons
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When I look at Menu Bar Layout, both sections are entirely blank.

![Image](https://github.com/user-attachments/assets/fbda84e0-df2d-4dd7-9064-634a9bc3d8ed)

### Steps to Reproduce

1. Go to ICE preferences.
2. Click on Menu Bar Layout.
3. Behold the empty spaces!

### App Version

0.11.12

### macOS Version

Tahoe 26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #744

- 链接：https://github.com/jordanbaird/Ice/issues/744
- 作者：[Dus-Code](https://github.com/Dus-Code)
- 状态：open
- 创建时间：2025-10-11T05:35:08Z（UTC）
- 更新时间：2026-05-25T21:49:59Z（UTC）
- 标签：Bug
- 评论数：45（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu Bar Layout settings is empty
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The layout settings isn't working. The bars are empty.
<img width="937" height="664" alt="Image" src="https://github.com/user-attachments/assets/aa83ba72-37ca-4318-aeda-6616f9233007" />

### Steps to Reproduce

Go to Settings > Menu Bar Layout

### App Version

0.11.12

### macOS Version

26.0.1 (25A362)

### Additional Information

_No response_
```

### jordanbaird/Ice #745

- 链接：https://github.com/jordanbaird/Ice/issues/745
- 作者：[jfifolio](https://github.com/jfifolio)
- 状态：open
- 创建时间：2025-10-13T13:46:57Z（UTC）
- 更新时间：2025-10-13T13:46:57Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Love]: Thank You For Ice!
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

This is not a bug, but a thank you! Ice is an amazing app and one I use every day. While it is not completely compatible with macOS Tahoe (as many of the other bug reports attest), I just wanted to share my gratitude for you and the work you've put into it, @jordanbaird.

❤️ 

### Steps to Reproduce

N/A

### App Version

N/A

### macOS Version

N/A

### Additional Information

_No response_
```

### jordanbaird/Ice #746

- 链接：https://github.com/jordanbaird/Ice/issues/746
- 作者：[kmnola](https://github.com/kmnola)
- 状态：open
- 创建时间：2025-10-15T07:46:35Z（UTC）
- 更新时间：2025-10-15T07:46:35Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Event operation timed out
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Every time I move a menu bar item, I get an "operation timed out" error.

I checked the previously reported (but now closed) bug for this issue and tried the fix there.  It did not work.  I'm running 0.11.13 dev.1 due to the blank menu bar issue in dev.2

### Steps to Reproduce

1. Expand menu bar and drag item to always visible section.

### App Version

0.11.13-dev.1

### macOS Version

26.1 Beta

### Additional Information

![Image](https://github.com/user-attachments/assets/f4d62577-6b6b-4247-8d85-422f9b6ea559)
```

### jordanbaird/Ice #748

- 链接：https://github.com/jordanbaird/Ice/issues/748
- 作者：[f95ngtb74r-ux](https://github.com/f95ngtb74r-ux)
- 状态：open
- 创建时间：2025-10-15T20:22:59Z（UTC）
- 更新时间：2025-10-15T20:37:06Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: 1Password
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

1Password doesn't stay where I moved it to, which is on the right of Ice - the visible area. Every time I restart my Mac, it has moved, and I have to move it back manually. This is in Tahoe.

### Steps to Reproduce

As above

### App Version

0.11.13-dev.2

### macOS Version

Tahoe 26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #750

- 链接：https://github.com/jordanbaird/Ice/issues/750
- 作者：[khaosdoctor](https://github.com/khaosdoctor)
- 状态：open
- 创建时间：2025-10-16T12:04:48Z（UTC）
- 更新时间：2025-11-03T22:56:38Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Weird line always drawn on secondary monitor
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When plugged to a secondary monitor, Ice keeps drawing a weird line in the middle of the screen (the location of the line varies), it's not all the time, but it's happening every 2 of 5 starts, once it happens it will consistently do this at every restart.

<img width="1568" height="224" alt="Image" src="https://github.com/user-attachments/assets/1b0cc9e7-046d-408d-aeb9-cea62e4748e0" />

If I close Ice it vanishes, it doesn't happen on the built-in retina monitor

### Steps to Reproduce

1. Open Ice
2. It should appear

### App Version

0.11.13-dev.2

### macOS Version

26.0.1 (25A362)

### Additional Information

_No response_
```

### jordanbaird/Ice #751

- 链接：https://github.com/jordanbaird/Ice/issues/751
- 作者：[dxdigg](https://github.com/dxdigg)
- 状态：open
- 创建时间：2025-10-17T06:14:00Z（UTC）
- 更新时间：2026-04-15T08:10:10Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: The cursor is not visible after clicking the ICE icon and then selecting a hidden icon from the ICE bar.
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

After clicking the ICE icon and selecting a hidden icon from the ICE bar, the mouse cursor disappears.

I have to keep shaking the mouse for it to reappear, but when switching to another application window, the cursor disappears again.

The cursor only returns to normal after completely exiting ICE.

### Steps to Reproduce

1. Click on ICE'S Three Dots icon.
2. There's an ICE Bar shows up.
3. Click any app icon on the bar.

### App Version

0.11.13-dev.2

### macOS Version

26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #752

- 链接：https://github.com/jordanbaird/Ice/issues/752
- 作者：[tosbsas](https://github.com/tosbsas)
- 状态：open
- 创建时间：2025-10-20T18:19:58Z（UTC）
- 更新时间：2025-10-20T18:19:58Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Bug]: Latest beta update from Sept 16th - when is a new one coming with fixed bugs
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

There still are several bugs, for example you cannot use the iceberg with menubar to disappear settings and stuff like that. Would be nice to see some update - its 5 weeks now

### Steps to Reproduce

There still are several bugs, for example you cannot use the iceberg with menubar to disappear settings and stuff like that. Would be nice to see some update - its 5 weeks now

### App Version

beta

### macOS Version

26.01

### Additional Information

_No response_
```

### jordanbaird/Ice #753

- 链接：https://github.com/jordanbaird/Ice/issues/753
- 作者：[dubefab](https://github.com/dubefab)
- 状态：open
- 创建时间：2025-10-20T23:10:49Z（UTC）
- 更新时间：2025-10-20T23:10:49Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Always Hidden items are empty under new Tahoe Beta 4
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

No hidden items are showed. Ice bar or not option and it happens.
I tried resetting permissions with tccutil reset All com.jordanbaird.Ice

### Steps to Reproduce

1. Click/hover on ice item and nothing appears.

### App Version

0.11.13-dev.2

### macOS Version

26.1 beta 4

### Additional Information

<img width="106" height="85" alt="Image" src="https://github.com/user-attachments/assets/87a43ebf-1c7b-4720-a37d-127e09293a59" />
```

### jordanbaird/Ice #754

- 链接：https://github.com/jordanbaird/Ice/issues/754
- 作者：[rakleed](https://github.com/rakleed)
- 状态：open
- 创建时间：2025-10-21T13:59:26Z（UTC）
- 更新时间：2025-10-21T13:59:26Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Feature Request]: Dark icon
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Please add support for a dark icon to your macOS app. Useful links: https://developer.apple.com/design/human-interface-guidelines/app-icons#Appearances and https://developer.apple.com/documentation/xcode/configuring-your-app-icon#Add-dark-and-tinted-icon-variants-to-iOS-and-iPadOS

### Additional Information

![Image](https://github.com/user-attachments/assets/7e32d940-0432-48ab-88b8-547ba31aebec)
```

### jordanbaird/Ice #755

- 链接：https://github.com/jordanbaird/Ice/issues/755
- 作者：[mcandre](https://github.com/mcandre)
- 状态：open
- 创建时间：2025-10-21T21:44:42Z（UTC）
- 更新时间：2025-10-21T21:44:42Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Dropped menubar clicks
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Very many clicks on menulet icons end up getting dropped when using Ice, compared to the ordinary Apple menubar.



### Steps to Reproduce

1. Click on a menulet icon.

### App Version

0.11.12

### macOS Version

15.6.1

### Additional Information

Similar third party menubar customization utilities, including TopNotch, also experience this bug.
```

### jordanbaird/Ice #757

- 链接：https://github.com/jordanbaird/Ice/issues/757
- 作者：[FederaikLudikon](https://github.com/FederaikLudikon)
- 状态：open
- 创建时间：2025-10-22T22:35:53Z（UTC）
- 更新时间：2025-10-22T22:35:53Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Pointer disappearing after clicking on icons in ICE popup bar
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have set my pointer size a little bigger in Tahoe's accessibility settings (no sure it's related)
When I click on any icon on the ICE hidden section the pointer disappears and i have to move blindly to the hidden dock or click somewhere to make it appear again

### Steps to Reproduce

1. Click on the ICE icon
2. When hidden section appears click on any icon in there
3. the mouse pointer disappears.

### App Version

0.11.13-dev.2

### macOS Version

Tahoe 26.01

### Additional Information

https://github.com/user-attachments/assets/e824a523-a521-4c92-9289-e3d56e23c430
As described the mouse pointer disappears and reappears only after clicking.
```

### jordanbaird/Ice #758

- 链接：https://github.com/jordanbaird/Ice/issues/758
- 作者：[ericwienerdd](https://github.com/ericwienerdd)
- 状态：open
- 创建时间：2025-10-23T13:00:22Z（UTC）
- 更新时间：2025-10-28T09:40:28Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Unable to re-arrange menu bar via Ice app
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Nothing shows up in the Ice app

<img width="1788" height="1246" alt="Image" src="https://github.com/user-attachments/assets/498cf2a2-59f5-4dc6-8ba1-2c6e20db5b70" />

### Steps to Reproduce

Open up Ice app and try to re-arrange positions

### App Version

0.11.12

### macOS Version

26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #759

- 链接：https://github.com/jordanbaird/Ice/issues/759
- 作者：[Lmeadows16](https://github.com/Lmeadows16)
- 状态：open
- 创建时间：2025-10-23T20:12:42Z（UTC）
- 更新时间：2025-11-25T19:33:27Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Ice Icon Disappearing after Hidden Items are shown
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Whenever I try to show my hidden items, the ice icon, in my case is the door, disappears, almost like Ice is quitting. T get the items to be hidden again, I have to reopen ice. Only then does the icon reappear and all of the hidden items go back to being hidden.

### Steps to Reproduce

1. Click on the Ice icon in the menu bar
2. See hidden icons
3. Ice icon disappears (Error)

### App Version

0.11.12

### macOS Version

Tahoe 26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #760

- 链接：https://github.com/jordanbaird/Ice/issues/760
- 作者：[ForceConstant](https://github.com/ForceConstant)
- 状态：open
- 创建时间：2025-10-23T20:30:33Z（UTC）
- 更新时间：2026-09-14T03:29:43Z（UTC）
- 标签：Feature
- 评论数：15（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: Make stable version for Tahoe?
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

If the beta is going good, can you release into stable channels so homebrew gets update?

### Additional Information

_No response_
```

### jordanbaird/Ice #762

- 链接：https://github.com/jordanbaird/Ice/issues/762
- 作者：[DeLoeribas](https://github.com/DeLoeribas)
- 状态：open
- 创建时间：2025-10-24T09:45:24Z（UTC）
- 更新时间：2026-03-01T21:37:02Z（UTC）
- 标签：Bug
- 评论数：18（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Cannot use Ice Bar nor Menu Bar layout icons
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Ice Bar and Settings Menu Bar Layout do not work

### Steps to Reproduce

- When I go to Settings -> Menu Bar Layout, I cannot see any icons to move, just "Unable to display menu bar items".
- When I want to show the Ice Bar in the menu I see no icons, just "Unable to display menu bar items"


### App Version

0.11.13-dev.2

### macOS Version

26.0.1

### Additional Information

<img width="1276" height="598" alt="Image" src="https://github.com/user-attachments/assets/58732bd3-e05a-4f6c-843b-0eeaffad58b0" />

<img width="552" height="166" alt="Image" src="https://github.com/user-attachments/assets/3afeeff5-74ae-4c9f-acc3-ae917fcff82f" />
```

### jordanbaird/Ice #763

- 链接：https://github.com/jordanbaird/Ice/issues/763
- 作者：[RookieProducer](https://github.com/RookieProducer)
- 状态：open
- 创建时间：2025-10-25T01:58:36Z（UTC）
- 更新时间：2025-10-27T16:28:39Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Color Picker is broken for Menu Bar
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Almost none of the color picker works outside of picking a crayon. I can't use the pinwheel and slider. I have to click along it to move the slider. I can't use the color picker tool to copy a color on the screen. As soon as I click anywhere off the color picker tool is closes. 

This is important since we don't have a ton of options in Tahoe with Reduce Transparency turned on, stuck with the hideous gray Apple gives us .

### Steps to Reproduce

Right click menu Bar
Click Edit Menu Bar Appearance
Color Picker comes up with crayons as default (those work fine but limited options)
no other options work reliably 

### App Version

0.11.12

### macOS Version

26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #766

- 链接：https://github.com/jordanbaird/Ice/issues/766
- 作者：[ymleung314](https://github.com/ymleung314)
- 状态：open
- 创建时间：2025-10-29T13:33:25Z（UTC）
- 更新时间：2025-10-29T13:33:25Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: App with dropdown from menu bar (Mullvad VPN) appears as it auto-hides
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Settings (which I think may be relevant):
- Use Ice Bar: on
- Location: Dynamic
- Automatically rehide: on
- Strategy: Smart

Observed on: Mullvad VPN Cilent

I don't have another app which drops down from the menu bar, so I'm unable to generalize the idea.

### Steps to Reproduce

1. Open Ice Bar
2. Click the Mullvad VPN lock (the icon will appear in the native menu bar and dropdown appears)
3. Click anywhere other than the VPN client
4. Wait for a while and the client will appear without the icon in the native menu bar

### App Version

0.11.13-dev.2

### macOS Version

26.0.1 (25A362)

### Additional Information

_No response_
```

### jordanbaird/Ice #767

- 链接：https://github.com/jordanbaird/Ice/issues/767
- 作者：[brucemakes012](https://github.com/brucemakes012)
- 状态：open
- 创建时间：2025-10-31T03:09:03Z（UTC）
- 更新时间：2025-11-24T08:55:38Z（UTC）
- 标签：Feature
- 评论数：5（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Have new menubar items appear in always shown, or customizable
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

(disclaimer: I did a quick search and don't think I saw existing issues, sorry if this is a repeat!)

New menubar items always go straight to the always-hidden bar, which is not the ideal default behavior, and I would have to open settings, and then manually move it to always-shown. I would strongly appreciate if the new items can default to always-shown, or have an option to let users decide. Thank you!

### Additional Information

Thanks for all your work, love the app!
```

### jordanbaird/Ice #768

- 链接：https://github.com/jordanbaird/Ice/issues/768
- 作者：[SeBr28](https://github.com/SeBr28)
- 状态：open
- 创建时间：2025-11-02T09:11:55Z（UTC）
- 更新时间：2025-11-04T22:41:12Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: ICE dock icon apeears when clicking on chevron to show menu.
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I see a few issues with dock but not specifically this.. so when I click on my 'dot' (chevron) it shows the ice icon in the dock. When I close the menu again it disappears. I think it's a bug because it doesn't happen always.. some you can close or open menu and no icon show. but then second or third time there it pops up.

https://app.screencast.com/3idio3as3ZYop

### Steps to Reproduce

see the link for little video. You see there the ice dock icon popping up...

### App Version

0.11.12

### macOS Version

Tahoe 26.01

### Additional Information

_No response_
```

### jordanbaird/Ice #769

- 链接：https://github.com/jordanbaird/Ice/issues/769
- 作者：[antonmanuelgonzalez](https://github.com/antonmanuelgonzalez)
- 状态：open
- 创建时间：2025-11-02T13:57:33Z（UTC）
- 更新时间：2025-11-14T22:14:47Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu Bar Layout gets reordered when i close the Ice app
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Hi Ice Team,
It doesn't crash, and I don't get any crash reports; it just rearranges the Menu Bar Layout when I close the Ice app.

And thank you for your awesome app!
It's great, and open source!

Greetings from Sweden!

### Steps to Reproduce

I just closed the app on the menu bar! Not the first time it has happened!

### App Version

0.11.12

### macOS Version

15.7.1

### Additional Information

_No response_
```

### jordanbaird/Ice #770

- 链接：https://github.com/jordanbaird/Ice/issues/770
- 作者：[kantonopoulos](https://github.com/kantonopoulos)
- 状态：open
- 创建时间：2025-11-03T08:54:36Z（UTC）
- 更新时间：2025-11-21T11:38:55Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：权限、更新、安装与分发

**标题原文**

```text
[Bug]: App gets stuck when installed
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Hi! Thanks for the great work on this project!

When I tried to download and try to open it, it is getting stuck in the following screen and no matter what I click nothing happens...

Am I doing something wrong? I gave it access initially to both screen record and system permission.

<img width="515" height="235" alt="Image" src="https://github.com/user-attachments/assets/c262ba47-fbef-4e35-b0a3-3533316aebcf" />

### Steps to Reproduce

1. I download the file
2. I open it and grant permission
3. It gets stuck

### App Version

Current

### macOS Version

Tahoe - Current

### Additional Information

_No response_
```

### jordanbaird/Ice #771

- 链接：https://github.com/jordanbaird/Ice/issues/771
- 作者：[niclake](https://github.com/niclake)
- 状态：open
- 创建时间：2025-11-03T15:28:11Z（UTC）
- 更新时间：2026-09-01T15:40:38Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Shortcut Gets Hidden After Restart
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have created a shortcut that I want displayed in my menu bar, and gone through the steps to make it visible. However, every time I restart my computer, it goes back to being hidden by Ice.

### Steps to Reproduce

1. Create a shortcut, and add it to the menu bar via Control Center.
2. Edit the Ice layout to move the shortcut to the Visible section.
3. Click around in settings, hide/show again, quit/restart Ice, lock/unlock computer, and the shortcut is still visible.
4. Restart the computer. The shortcut will now be in the Hidden section, and you will have to move it back to the menu bar.

### App Version

0.11.13-dev.2

### macOS Version

Tahoe 26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #773

- 链接：https://github.com/jordanbaird/Ice/issues/773
- 作者：[Mutzki13](https://github.com/Mutzki13)
- 状态：open
- 创建时间：2025-11-05T11:16:35Z（UTC）
- 更新时间：2026-02-25T18:26:36Z（UTC）
- 标签：Bug
- 评论数：15（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu Bar Layout empty - All icons in hidden section
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I upgraded to the latest 0.11.12 and now all my icons were moved to the hidden section, but in the settings (see screenshot) both sections are empty.

<img width="1012" height="737" alt="Image" src="https://github.com/user-attachments/assets/60c49ab8-d70c-4733-8fec-6248be39bc30" />

### Steps to Reproduce

Ice Settings > Menu Bar Layout

### App Version

0.11.12

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #774

- 链接：https://github.com/jordanbaird/Ice/issues/774
- 作者：[fseesink](https://github.com/fseesink)
- 状态：open
- 创建时间：2025-11-06T16:14:37Z（UTC）
- 更新时间：2026-09-10T21:44:20Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Bug]: Website https://icemenubar.app/ appears to be down
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

More just an FYI that your site that you link to from your GitHub repo appears to be down.

### Steps to Reproduce

1. Open a browser
2. Visit https://icemenubar.app/

### App Version

0.11.12

### macOS Version

26.1

### Additional Information

This is not about the app itself.
(And yes, I am seeing the same issues as others with Ice on macOS 26.x "Tahoe".  But I'm tracking that in the issues.)
```

### jordanbaird/Ice #777

- 链接：https://github.com/jordanbaird/Ice/issues/777
- 作者：[Martin-Winfred](https://github.com/Martin-Winfred)
- 状态：open
- 创建时间：2025-11-08T14:43:42Z（UTC）
- 更新时间：2025-11-08T14:43:42Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]:  Ice App Freezes During Screen Capture Operations
```

**正文原文**

````markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The Ice application becomes completely unresponsive during screen capture operations. The main thread and multiple background threads are blocked indefinitely, requiring the user to force-quit the app. This issue occurs consistently when the app attempts to capture menu bar items or windows.
*(Note: I apologize for not being very familiar with Swift development, so my analysis might be limited to what I observed in the logs.)*

### Steps to Reproduce

1. Launch Ice on macOS 26.1
2. close the ice window
4. Trigger a screen capture operation
5. Observe UI freeze and unresponsiveness
6. Check Activity Monitor or sample logs for blocked threads

### App Version

0.11.13-dev.2 

### macOS Version

26.1

### Additional Information

### Stack Trace Analysis
From the sample log, I found these key blocking points:
1. **Main thread blocked**:
   ```
   OS_dispatch_queue.sync → _dispatch_sync_f_slow → __DISPATCH_WAIT_FOR_QUEUE__ → kevent_id
   ```
2. **Screen capture queue stuck**:
   ```
   SLWindowListCreateImageFromArray → _dispatch_semaphore_wait_slow → semaphore_timedwait_trap
   ```
3. **Multiple background threads blocked**:
   ```
   OS_dispatch_queue.sync (in com.apple.root.user-initiated-qos.cooperative)
   ```
### Code Location
The issue appears to be in `ScreenCapture.swift`, specifically in this method:
```swift
static func captureWindows(_ windowIDs: [CGWindowID], screenBounds: CGRect? = nil, option: CGWindowImageOption = []) -> CGImage? {
    // ... creates window array ...
    return .windowListImage(from: screenBounds ?? .null, windowArray: windowArray, imageOption: option)
}
```
This method calls `CGImage.windowListImage` which seems to be the synchronous system call causing the blockage.
### Additional Observations
- The issue is more pronounced on macOS 26.1 (Beta)
- Memory usage appears normal (75.5MB)
- The blocking occurs in the ScreenCaptureKit framework's `SLWindowListCreateImageFromArray` function

[“Ice” sample.txt](https://github.com/user-attachments/files/23432457/Ice.sample.txt)
````

### jordanbaird/Ice #778

- 链接：https://github.com/jordanbaird/Ice/issues/778
- 作者：[dwt](https://github.com/dwt)
- 状态：open
- 创建时间：2025-11-10T07:26:12Z（UTC）
- 更新时间：2025-11-10T07:26:12Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Add Toggle to expand hidden section to contain always hidden icons
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

This is the idea: If an icon accidentally gets added to the always hidden section (docker desktop for me seems to constantly do this), then the only option to check this, is to go into the settings.

Granted this use case would be much rarer for me without this unprompted change of place for docker.

So another use case: Make it easy to show the always hidden icons. There is already a shortcut to so. For Users preferring to use the mouse, this doesn't work however.

So this is the idea: Add a chevron (or other icon) to the hidden section, that allows me to expand it to also show the always hidden icons. 

That transforms the always hidden section into one that is rarely used but still easily accessible, making it much less painful to occasionally have to use something from that bar.

### Additional Information

_No response_
```

### jordanbaird/Ice #779

- 链接：https://github.com/jordanbaird/Ice/issues/779
- 作者：[chenxiangning](https://github.com/chenxiangning)
- 状态：open
- 创建时间：2025-11-10T08:23:21Z（UTC）
- 更新时间：2025-11-24T09:07:25Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: 点击图标自动就退出了.系统崩溃
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Ice [1522]
Path:                /Applications/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [870]
User ID:             501

Date/Time:           2025-11-10 16:14:53.7897 +0800
Launch Time:         2025-11-10 16:12:58.1543 +0800
Hardware Model:      MacBookPro18,4
OS Version:          macOS 26.0.1 (25A362)
Release Type:        User

Crash Reporter Key:  DC8983D4-05F3-02CF-8B73-4A264B949006
Incident Identifier: 4F72174A-F1DF-43A4-9046-FCAB7A8F317C

Time Awake Since Boot: 400 seconds

System Integrity Protection: enabled

Triggered by Thread: 0

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x00000001004bc934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [1522]


Thread 0 Crashed:
0   Ice                           	       0x1004bc934 0x1004b0000 + 51508
1   Ice                           	       0x100572b18 0x1004b0000 + 797464
2   Ice                           	       0x1005715e0 0x1004b0000 + 792032
3   Ice                           	       0x1005307e1 0x1004b0000 + 526305
4   Ice                           	       0x1004d0151 0x1004b0000 + 131409
5   Ice                           	       0x1004d3fb9 0x1004b0000 + 147385
6   Ice                           	       0x1004c2319 0x1004b0000 + 74521
7   libswift_Concurrency.dylib    	       0x2976c1dfd completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x19ef79c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x19ef8c028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x19ef8298c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x19ef79fb4 mach_msg + 24
4   CoreFoundation                	       0x19f05bc80 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x19f05a5d8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x19f118898 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x1a34d8a68 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x19efbcc08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x19efb7ba8 thread_start + 8

Thread 2:

Thread 3:

Thread 4:

Thread 5:

Thread 6:

Thread 7:

Thread 8:

Thread 9:

Thread 10:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x000000096c3fb480   x1: 0x1c0000020b9bb7bf   x2: 0x000000020b9bb7b8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x000000021a74cebb  x10: 0x000000097a0f3903  x11: 0x00000000000003ff
   x12: 0x0000000000000326  x13: 0x000000096be07250  x14: 0x1c0000020b9bb7bf  x15: 0x000000020b9bb7b8
   x16: 0x1c0000020b9bb7bf  x17: 0x0000000000000036  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x000000096c3fb480  x21: 0x000000096d49cb40  x22: 0x000000096d698a80  x23: 0x0000000000000002
   x24: 0x0000000100659000  x25: 0x000000096c955680  x26: 0x000000096e810bd0  x27: 0x000000096b9c0460
   x28: 0xffffffff76ffffff   fp: 0x000000016f94b9d0   lr: 0x00000001004bc928
    sp: 0x000000016f94b9b0   pc: 0x00000001004bc934 cpsr: 0x60001000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x1004b0000 -        0x10063ffff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/Ice.app/Contents/MacOS/Ice
       0x100798000 -        0x1007dbfff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x1008b8000 -        0x1008c3fff libobjc-trampolines.dylib (*) <580e4b29-8304-342d-a21c-2a869364dc35> /usr/lib/libobjc-trampolines.dylib
       0x114964000 -        0x1150affff com.apple.AGXMetalG13X (340.26.3) <e09c4f6b-8ff6-3edf-9e21-95f237f5a392> /System/Library/Extensions/AGXMetalG13X.bundle/Contents/MacOS/AGXMetalG13X
       0x297654000 -        0x2976de317 libswift_Concurrency.dylib (*) <55c416d8-c572-3449-9302-a64cc8a57360> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x19ef79000 -        0x19efb545f libsystem_kernel.dylib (*) <2eb73bf1-8c71-3e1f-a160-6da83dc82606> /usr/lib/system/libsystem_kernel.dylib
       0x19effc000 -        0x19f548f7f com.apple.CoreFoundation (6.9) <edb39786-80b1-3bff-b6c3-e33f2e3ca867> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x1a3429000 -        0x1a4b24cdf com.apple.AppKit (6.9) <9aef8974-703a-3941-9b3d-de8c5ccb61d0> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x19efb6000 -        0x19efc2abb libsystem_pthread.dylib (*) <5d31d65c-2ecf-36da-84f5-ba4caab06adb> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=222.3M written=675K(0%) resident=675K(0%) swapped_out=0K(0%) unallocated=221.6M(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               384K        3 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                          3968K       20 
ColorSync                          704K       34 
CoreAnimation                     10.5M      156 
CoreGraphics                        96K        6 
CoreServices                        48K        1 
CoreUI image data                 2432K       35 
Foundation                          16K        1 
Kernel Alloc Once                 2272K        2 
MALLOC                           189.4M       50 
MALLOC guard page                 3872K        4 
Mach message                       864K        4 
SQLite page cache                  128K        1 
STACK GUARD                       56.2M       11 
Stack                             13.3M       11 
VM_ALLOCATE                       5072K       16 
__AUTH                            5815K      653 
__AUTH_CONST                      89.0M     1038 
__CTF                               824        1 
__DATA                            29.8M      988 
__DATA_CONST                      32.9M     1047 
__DATA_DIRTY                      8885K      898 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       595.7M        5 
__OBJC_RO                         78.1M        1 
__OBJC_RW                         2561K        1 
__TEXT                             1.2G     1070 
__TPRO_CONST                       128K        2 
mapped file                      454.8M       64 
page table in kernel               675K        1 
shared memory                     2528K       22 
===========                     =======  ======= 
TOTAL                              2.7G     6150 


-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2025-11-10 16:14:54.00 +0800","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":0,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.0.1 (25A362)","roots_installed":0,"name":"Ice","incident_id":"4F72174A-F1DF-43A4-9046-FCAB7A8F317C"}
{
  "uptime" : 400,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "MacBookPro18,4",
  "coalitionID" : 870,
  "osVersion" : {
    "train" : "macOS 26.0.1",
    "build" : "25A362",
    "releaseType" : "User"
  },
  "captureTime" : "2025-11-10 16:14:53.7897 +0800",
  "codeSigningMonitor" : 1,
  "incident" : "4F72174A-F1DF-43A4-9046-FCAB7A8F317C",
  "pid" : 1522,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-11-10 16:12:58.1543 +0800",
  "procStartAbsTime" : 7016895537,
  "procExitAbsTime" : 9791955076,
  "procName" : "Ice",
  "procPath" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"41D9B90E-8011-5342-AFF3-240283CB344E","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "DC8983D4-05F3-02CF-8B73-4A264B949006",
  "developerMode" : 1,
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570503953,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"6AwAsAGpQPngAxSqvucElPMDAKrgAxSqxOcElLMB+Ldo\/mDTiAAAtA==","atPC":"IAAg1BMAgNIoAIBS6DMAOQgdABJgggiq\/XtCqfRPQan\/wwCRwANf1g=="},
  "bootSessionUUID" : "A4DF393E-F30A-4ED5-A1F2-98448AD6CCE3",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000001, 0x00000001004bc934","rawCodes":[1,4299934004],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":1522},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":20582,"threadState":{"x":[{"value":40470819968},{"value":2017612641846671295,"symbolLocation":2017612633061982215,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8784689080,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":1},{"value":68719476739},{"value":7},{"value":68719476739},{"value":7},{"value":1},{"value":9033797307,"objc-selector":"windowNumber"},{"value":40702523651},{"value":1023},{"value":806},{"value":40464577104},{"value":2017612641846671295,"symbolLocation":2017612633061982215,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8784689080,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":2017612641846671295,"symbolLocation":2017612633061982215,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":54},{"value":0},{"value":4294967296},{"value":40470819968},{"value":40488258368},{"value":40490338944},{"value":2},{"value":4301623296},{"value":40476432000},{"value":40508656592},{"value":40460092512},{"value":18446744071411073023}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4299933992},"cpsr":{"value":1610616832},"fp":{"value":6166985168},"sp":{"value":6166985136},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4299934004,"matchesCrashFrame":1},"far":{"value":0}},"frames":[{"imageOffset":51508,"imageIndex":0},{"imageOffset":797464,"imageIndex":0},{"imageOffset":792032,"imageIndex":0},{"imageOffset":526305,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":147385,"imageIndex":0},{"imageOffset":74521,"imageIndex":0},{"imageOffset":450045,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":4}]},{"id":20594,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":98968931401728},{"value":0},{"value":98968931401728},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":23043},{"value":0},{"value":18446744073709551569},{"value":8807638800},{"value":0},{"value":4294967295},{"value":2},{"value":98968931401728},{"value":0},{"value":98968931401728},{"value":6169845896},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6962069544},"cpsr":{"value":4096},"fp":{"value":6169845744},"sp":{"value":6169845664},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6961994804},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":6},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":6},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":6},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":6},{"imageOffset":392320,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":7},{"imageOffset":386520,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":7},{"imageOffset":1165464,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":7},{"imageOffset":719464,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":8},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":9},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":9}]},{"id":21386,"frames":[],"threadState":{"x":[{"value":6167556096},{"value":19395},{"value":6167019520},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6167556096},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":21390,"frames":[],"threadState":{"x":[{"value":6172717056},{"value":69203},{"value":6172180480},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6172717056},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":21961,"frames":[],"threadState":{"x":[{"value":6168129536},{"value":55667},{"value":6167592960},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6168129536},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":21964,"frames":[],"threadState":{"x":[{"value":6170996736},{"value":61511},{"value":6170460160},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6170996736},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":22441,"frames":[],"threadState":{"x":[{"value":6168702976},{"value":19187},{"value":6168166400},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6168702976},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":22443,"frames":[],"threadState":{"x":[{"value":6170423296},{"value":74619},{"value":6169886720},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6170423296},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":22445,"frames":[],"threadState":{"x":[{"value":6172143616},{"value":85811},{"value":6171607040},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6172143616},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":22707,"frames":[],"threadState":{"x":[{"value":6173290496},{"value":82239},{"value":6172753920},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6173290496},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}},{"id":23267,"frames":[],"threadState":{"x":[{"value":6169276416},{"value":84907},{"value":6168739840},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6169276416},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6962248596},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4299882496,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4302929920,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/Applications\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4304109568,
    "size" : 49152,
    "uuid" : "580e4b29-8304-342d-a21c-2a869364dc35",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4640358400,
    "CFBundleShortVersionString" : "340.26.3",
    "CFBundleIdentifier" : "com.apple.AGXMetalG13X",
    "size" : 7651328,
    "uuid" : "e09c4f6b-8ff6-3edf-9e21-95f237f5a392",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG13X.bundle\/Contents\/MacOS\/AGXMetalG13X",
    "name" : "AGXMetalG13X",
    "CFBundleVersion" : "340.26.3"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 11129929728,
    "size" : 566040,
    "uuid" : "55c416d8-c572-3449-9302-a64cc8a57360",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6961991680,
    "size" : 246880,
    "uuid" : "2eb73bf1-8c71-3e1f-a160-6da83dc82606",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6962528256,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5558144,
    "uuid" : "edb39786-80b1-3bff-b6c3-e33f2e3ca867",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4040.1.401"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 7034015744,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24100064,
    "uuid" : "9aef8974-703a-3941-9b3d-de8c5ccb61d0",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.10.110"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6962241536,
    "size" : 51900,
    "uuid" : "5d31d65c-2ecf-36da-84f5-ba4caab06adb",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6957236224,
  "size" : 5557583872,
  "uuid" : "4300eabe-4963-34ab-a648-3d68753cf4e1"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=222.3M written=675K(0%) resident=675K(0%) swapped_out=0K(0%) unallocated=221.6M(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               384K        3 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                          3968K       20 \nColorSync                          704K       34 \nCoreAnimation                     10.5M      156 \nCoreGraphics                        96K        6 \nCoreServices                        48K        1 \nCoreUI image data                 2432K       35 \nFoundation                          16K        1 \nKernel Alloc Once                 2272K        2 \nMALLOC                           189.4M       50 \nMALLOC guard page                 3872K        4 \nMach message                       864K        4 \nSQLite page cache                  128K        1 \nSTACK GUARD                       56.2M       11 \nStack                             13.3M       11 \nVM_ALLOCATE                       5072K       16 \n__AUTH                            5815K      653 \n__AUTH_CONST                      89.0M     1038 \n__CTF                               824        1 \n__DATA                            29.8M      988 \n__DATA_CONST                      32.9M     1047 \n__DATA_DIRTY                      8885K      898 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       595.7M        5 \n__OBJC_RO                         78.1M        1 \n__OBJC_RW                         2561K        1 \n__TEXT                             1.2G     1070 \n__TPRO_CONST                       128K        2 \nmapped file                      454.8M       64 \npage table in kernel               675K        1 \nshared memory                     2528K       22 \n===========                     =======  ======= \nTOTAL                              2.7G     6150 \n",
  "legacyInfo" : {
  "threadTriggered" : {

  }
},
  "logWritingSignature" : "9fc11ced1caa13fd97e350554e0b063a752bc90d",
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "642da32dea3b2418c750f848",
      "factorPackIds" : [
        "66d8b2f77cd4b62688efd2cf"
      ],
      "deploymentId" : 240000011
    },
    {
      "rolloutId" : "5f72dc58705eff005a46b3a9",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000015
    }
  ],
  "experiments" : [

  ]
}
}

Model: MacBookPro18,4, BootROM 13822.1.2, proc 10:8:2 processors, 32 GB, SMC 
Graphics: Apple M1 Max, Apple M1 Max, Built-In
Display: KM27192, 1920 x 1080 (1080p FHD - Full High Definition), Main, MirrorOff, Online
Display: ARZOPA, 2560 x 1600, MirrorOff, Online
Memory Module: LPDDR5, Hynix
AirPort: spairport_wireless_card_type_wifi (0x14E4, 0x4387), wl0: Jul 18 2025 22:12:22 version 20.131.2.0.8.7.213 FWID 01-50636f04
IO80211_driverkit-1525.88 "IO80211_driverkit-1525.88" Aug  6 2025 21:19:03
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Wi-Fi 2, AirPort, en0
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.


### Steps to Reproduce

打开之后,点击菜单栏图标,就崩溃了

### App Version

0.11.12

### macOS Version

Tahoe 26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #780

- 链接：https://github.com/jordanbaird/Ice/issues/780
- 作者：[MPirre](https://github.com/MPirre)
- 状态：open
- 创建时间：2025-11-10T10:33:18Z（UTC）
- 更新时间：2025-11-10T10:33:18Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Bug on Vertical Monitors
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

If i have a Horizontal and a Vertical monitor the top bar (if tint is solid or gradient) appears on the half of the screen (across it).

It doesnt assume the top of the screen. 

### Steps to Reproduce

Just have a vertical monitor i guess and on menu bar appearance have tint on 

### App Version

0.11.12-dev.2

### macOS Version

26.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #781

- 链接：https://github.com/jordanbaird/Ice/issues/781
- 作者：[MaurizioJJ](https://github.com/MaurizioJJ)
- 状态：open
- 创建时间：2025-11-10T11:32:42Z（UTC）
- 更新时间：2025-12-08T01:57:43Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: ICE menu icon non showing anymore
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The ... icon in the top bar is not shwoing up anymore...

### Steps to Reproduce

Check the top bar, icon's not there

<img width="844" height="31" alt="Image" src="https://github.com/user-attachments/assets/de5b48c2-4e5c-4ec4-b40b-3bb040cada6e" />

### App Version

0.11.12

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #783

- 链接：https://github.com/jordanbaird/Ice/issues/783
- 作者：[dafacto](https://github.com/dafacto)
- 状态：open
- 创建时间：2025-11-10T13:15:51Z（UTC）
- 更新时间：2025-11-17T10:11:41Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: Separate sets for laptops when connect to external monitor
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

It would be great to have setting sets attached to different contexts. For example, I would love to have:

- Home external monitor connected
- Laptop only

### Additional Information

_No response_
```

### jordanbaird/Ice #786

- 链接：https://github.com/jordanbaird/Ice/issues/786
- 作者：[sarahhbickerton](https://github.com/sarahhbickerton)
- 状态：open
- 创建时间：2025-11-11T18:52:12Z（UTC）
- 更新时间：2026-05-02T14:14:06Z（UTC）
- 标签：Bug
- 评论数：20（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]:Selecting 'Ice Bar' in settings and then tapping on the Ice icon causes Ice to crash
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Hi, I'm on macOS 26.1 on two machines, a M4 Mac Mini and a M3 Pro MacBook Pro and the same thing occurs. I really like using the 'Ice Bar' in settings to have the hidden items appear in a bar under the main menubar, but since upgrading to the public release of Tahoe (26.0 - never had any of the betas) if I pull up settings, select 'Use Ice Bar' then close settings, and tap on the Ice Icon (I use the ellipsis option for the icon), it causes Ice to crash. I can restart Ice, and then go back into settings and turn Ice Bar off, and then it works fine, with hidden items appearing in the menu bar when I tap on the icon (though this is frustrating on the MacBook Pro because of the notch covering up most of my icons, hence why I used Ice Bar) and Ice not crashing. Would really like if this could be fixed if at all possible. I am running version 0.11.12, and had hoped 26.1 would fix whatever was causing the bug, but unfortunately it hasn't. Thanks Jordan! :)

### Steps to Reproduce

1. Go to Settings
2. Select 'Use Ice Bar'
3. Close Settings
4. tap on Ice Icon to reveal hidden menubar items
5. Ice crashes
6. Restart Ice
7. Open Settings
8. Turn off 'Use Ice Bar'
9. Close Settings
10. Ice works

### App Version

0.11.12

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #787

- 链接：https://github.com/jordanbaird/Ice/issues/787
- 作者：[penggehero](https://github.com/penggehero)
- 状态：open
- 创建时间：2025-11-13T09:16:13Z（UTC）
- 更新时间：2025-11-13T09:16:13Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: need language option，Chinese for example....
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

need language option，Chinese for example....

### Additional Information

_No response_
```

### jordanbaird/Ice #790

- 链接：https://github.com/jordanbaird/Ice/issues/790
- 作者：[RabenkoYevhenii](https://github.com/RabenkoYevhenii)
- 状态：open
- 创建时间：2025-11-17T10:07:58Z（UTC）
- 更新时间：2025-11-19T18:28:04Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Multiple monitors freeze
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Hi, I love your app, but on my MacBook Pro m4 when I connect an external monitor, ice can just freeze and not respond on hover or even just open app manually. 

### Steps to Reproduce

1. Open app
2. Connect external monitor
3. Hover several times
4. ICE app freezes and does not respond

### App Version

0.11.13-dev2

### macOS Version

26.1

### Additional Information

<img width="956" height="31" alt="Image" src="https://github.com/user-attachments/assets/0f671eda-01a2-44d3-91d2-9cf0b47ef5f9" />

<img width="551" height="375" alt="Image" src="https://github.com/user-attachments/assets/613252da-3bbe-47c4-8132-6ab89b17eb2c" />


```

### jordanbaird/Ice #793

- 链接：https://github.com/jordanbaird/Ice/issues/793
- 作者：[Litemagic](https://github.com/Litemagic)
- 状态：open
- 创建时间：2025-11-22T08:17:01Z（UTC）
- 更新时间：2025-12-12T09:39:26Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: White icons on white background
```

**正文原文**

```markdown
### Search for Similar Reports

- [ ] I have searched existing issues for similar reports

### Description

All on screenshot

### Steps to Reproduce

1. Open menu bar layout

### App Version

0.11.12

### macOS Version

26.1 (25B78)

### Additional Information

<img width="682" height="585" alt="Image" src="https://github.com/user-attachments/assets/3c9d62cb-3d54-4859-8eb9-1d43dc82cfd5" />
```

### jordanbaird/Ice #796

- 链接：https://github.com/jordanbaird/Ice/issues/796
- 作者：[DataZombies](https://github.com/DataZombies)
- 状态：open
- 创建时间：2025-11-25T18:35:02Z（UTC）
- 更新时间：2025-12-17T01:45:29Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: App crashes when opening the sub menu
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The app crashes when I click on the icon to show the hidden items
16" MBP, M3 Pro chip
macOS Tahoe 26.1

[ICE Crash Report.txt](https://github.com/user-attachments/files/23753780/ICE.Crash.Report.txt)

### Steps to Reproduce

1. Open the app
2. Click on the hidden

<img width="228" height="825" alt="Image" src="https://github.com/user-attachments/assets/55f90707-f47b-4040-8015-0e52ae690aad" />


<img width="236" height="84" alt="Image" src="https://github.com/user-attachments/assets/f0765685-4e66-4b34-aa87-c3f5919efee7" />


<img width="476" height="44" alt="Image" src="https://github.com/user-attachments/assets/386ec1f2-2c7d-45fc-bc82-7c59373d9c90" />

### App Version

0.11.12

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #797

- 链接：https://github.com/jordanbaird/Ice/issues/797
- 作者：[JoeFeng](https://github.com/JoeFeng)
- 状态：open
- 创建时间：2025-11-26T09:56:10Z（UTC）
- 更新时间：2025-12-18T08:10:19Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Feature Request]: only on screens with a notch
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Can Ice Show menu bar items in a bar below the menu bar only on screens with a notch?

### Additional Information

_No response_
```

### jordanbaird/Ice #798

- 链接：https://github.com/jordanbaird/Ice/issues/798
- 作者：[christianmagill](https://github.com/christianmagill)
- 状态：open
- 创建时间：2025-11-27T04:20:58Z（UTC）
- 更新时间：2025-11-27T04:20:58Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Audio Wrangler Mute Icon Issue
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The Audio Wrangler app ([https://audiowrangler.app/]) displays a mute icon in the menubar when you mute your mic. When you unmute the mic the icon disappears. The problem is the icon won't stay in the visible section of Ice. When the mic is muted again, the icon is added to the hidden section.

I'm guessing Ice doesn't recognize the icon as being the same, but I also don't see any option to display new icons in the visible section by default.

### Steps to Reproduce

1. Go to https://audiowrangler.app
2. Install application
3. Configure "Toggle input mute hotkey"
4. Trigger the hotkey.
5. Move the mute icon to the visible section of Ice.
6. Trigger hotkey again. Watch icon disappear.
7. Trigger hotkey again. Find mute icon in hidden section of Ice.

### App Version

0.11.13-dev.2

### macOS Version

Tahoe 26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #799

- 链接：https://github.com/jordanbaird/Ice/issues/799
- 作者：[normausome](https://github.com/normausome)
- 状态：open
- 创建时间：2025-11-27T10:56:13Z（UTC）
- 更新时间：2026-01-07T15:32:51Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Menu bar items not disappearing
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I am currently using ICE version 0.11.13-dev.1. I had my automatic re-hide enabled and tried both the smart and timed strategies to hide the items on my menu bar. However, the items do not hide after clicking/opening them.

I am unsure what could be causing this issue. Perhaps I should consider uninstalling and reinstalling the application using Homebrew.

### Steps to Reproduce

First, go to the Ice Bar and click on one of the items to have it appear in your menu bar. 

Second, click away from the item in the menu bar. 

Third, wait for it to disappear back into the Ice Bar, which it does not.

### App Version

0.11.13-dev.1.

### macOS Version

Tahoe 26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #801

- 链接：https://github.com/jordanbaird/Ice/issues/801
- 作者：[huaer6188-star](https://github.com/huaer6188-star)
- 状态：open
- 创建时间：2025-11-28T10:58:09Z（UTC）
- 更新时间：2025-11-28T10:58:09Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: 求中文
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

求中文
求中文
求中文
求中文
求中文
求中文
求中文


### Additional Information

_No response_
```

### jordanbaird/Ice #802

- 链接：https://github.com/jordanbaird/Ice/issues/802
- 作者：[0x-IHRR](https://github.com/0x-IHRR)
- 状态：open
- 创建时间：2025-11-30T06:02:00Z（UTC）
- 更新时间：2025-12-09T05:55:24Z（UTC）
- 标签：Bug
- 评论数：13（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: After updating the Mac version, the layout settings disappeared.
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

<img width="1800" height="1252" alt="Image" src="https://github.com/user-attachments/assets/4cb9b5bf-26c9-4647-b434-912ce7706fd4" />

### Steps to Reproduce

1. Go to open ice

### App Version

0.11.12

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #806

- 链接：https://github.com/jordanbaird/Ice/issues/806
- 作者：[bobbd2000](https://github.com/bobbd2000)
- 状态：open
- 创建时间：2025-12-04T14:52:09Z（UTC）
- 更新时间：2025-12-18T08:56:30Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Razer Synapse icon always hidden on startup
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I don't know that this is an Ice bug. I have Razer Synapse for Mac. The icon is in the visible section and shows that way in settings. When I startup my Mac, the icon is always at the end of the hidden section. It's easy enough to drag it over but I have no idea why it's not staying where I put it. It's one of the last menubar items to start up. Any suggestions?

### Steps to Reproduce

This only happens with Razer Synpase.
1. Check the Ice settings to make sure that Synapse is in the visible section.
2. Restart the Mac.
3. Check where the Synapse icon is.

### App Version

0.11.13-dev.2

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #807

- 链接：https://github.com/jordanbaird/Ice/issues/807
- 作者：[jeed2424](https://github.com/jeed2424)
- 状态：open
- 创建时间：2025-12-04T16:18:08Z（UTC）
- 更新时间：2025-12-04T21:57:57Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: [Macbook Pro, M4 Pro] Not responding
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Launching the app, I can use it for a few seconds, and then it just stops responding. It stops showing menu bar items when hovering on the menu bar (as per my settings), and right-clicking the menu bar icon does nothing.

### Steps to Reproduce

1. Launch Ice
2. Wait and try to use the app

### App Version

0.11.13 (MacOS Tahoe Beta 2)

### macOS Version

Tahoe 26.1

### Additional Information

Seems like it may be an issue with the XPC, I got the same issue running from Xcode (see ice_logs.txt linked below)

[ice_logs.txt](https://github.com/user-attachments/files/23944328/ice_logs.txt)
```

### jordanbaird/Ice #808

- 链接：https://github.com/jordanbaird/Ice/issues/808
- 作者：[Macador](https://github.com/Macador)
- 状态：open
- 创建时间：2025-12-05T16:10:26Z（UTC）
- 更新时间：2026-09-02T23:18:40Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: macOS "Tahoe" - after system restart icon remains in dock
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Hello , Ni Hao & greetings from cold(!) Germany,

nothing important, but nonetheless: 
When I restart my Macbook (details below) from "off", I have the Ice-icon in my menu bar (YAY!), A N D  alsi in my dock (nay!). After approximately 5 minutes, the icon vanishes from the dock & all is fine again...
(Sometimes, 1 or 2 icons in the Ice-bar are not in the order I set them before, but that's not worth further mentioning imho)

Computer: Macbook pro 14" (ID-model: 15,6)/ M3 pro 11/14 cores / 18GB RAM / 512 GB SSD (of which appr. 130 GB free space)

OS: macOS 26.1 "Tahoe"
Ice: 0.11.13-dev.2

I would like to send a big "THANK YOU" to everyone involved in Ice: It makes my life MUCH easier!
Oh, and when I listen to my friends (who use other alternatives...), all of us are lucky to have Ice - even with its little bugs, it seems to be more stable than the solutions of my friends - thus, they are converting... one by one. ;o)

Thanks again, and keep up the good work!

Best Regards,
Marc

(who is dreaming of being in Shanghai now, where the winter is perfect in temeprature... ;o)

### Steps to Reproduce

Repro:
1. Switch Macbook "OFF".
2. Wait until Magsafe-plug changes colour of LED.
3. Switch Macbook "ON".
4. Watch Ice appear 1. in menu bar, and then 2. in dock.
5. After approximately 5 minutes, watch Ice-icon in dock disappear.

### App Version

0.11.13-dev.2

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #809

- 链接：https://github.com/jordanbaird/Ice/issues/809
- 作者：[milesmcclane](https://github.com/milesmcclane)
- 状态：open
- 创建时间：2025-12-06T14:22:59Z（UTC）
- 更新时间：2025-12-06T14:24:43Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Always place new icons at the end
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Hi, I really like this app. However, when a new icon gets added to the menu bar (be it because a new app is added, or be it because I clicked on one within Ice and it's added temporarily), it's seemingly randomly placed. I have gone through my menu bar apps and opened one at a time and manually moved them, but it doesnt always stick not to mention it's rather convoluted. The biggest annoyance is macOS adding the screen sharing warning. It seems to go wherever it pleases. It's messy, and with the notch in the picture it moves my entire placement to the left and it gets covered over. I guess I'm asking if there his anyway to add the placeholder for when the system decides or designates an icon, so we can have it placed where we please within the lineup, and that it remains consistent.

### Additional Information

_No response_
```

### jordanbaird/Ice #810

- 链接：https://github.com/jordanbaird/Ice/issues/810
- 作者：[fredy1223](https://github.com/fredy1223)
- 状态：open
- 创建时间：2025-12-06T18:03:18Z（UTC）
- 更新时间：2025-12-10T00:00:52Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Crash on M1 Pro
```

**正文原文**

```markdown
### Search for Similar Reports

- [ ] I have searched existing issues for similar reports

### Description

If I use the seperate the ICE Bar the app crashes. I attached the crash report.

-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Ice [53111]
Path:                /Applications/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [95507]
User ID:             501

Date/Time:           2025-12-06 18:45:08.3879 +0100
Launch Time:         2025-12-06 18:44:52.7737 +0100
Hardware Model:      MacBookPro18,3
OS Version:          macOS 26.1 (25B78)
Release Type:        User

Crash Reporter Key:  8C210DEF-784C-4F93-AEDB-9794AC3AC198
Incident Identifier: 272895A5-5FCF-414B-8DB4-F99B97B9AAD3

Sleep/Wake UUID:       802BA1CA-3C16-4DA9-93B0-BAF747D57892

Time Awake Since Boot: 1900000 seconds
Time Since Wake:       89036 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x0000000100d04934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [53111]


Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   Ice                           	       0x100d04934 0x100cf8000 + 51508
1   Ice                           	       0x100dbab18 0x100cf8000 + 797464
2   Ice                           	       0x100dbaaa0 0x100cf8000 + 797344
3   Ice                           	       0x100db95e0 0x100cf8000 + 792032
4   Ice                           	       0x100d787e1 0x100cf8000 + 526305
5   Ice                           	       0x100d18151 0x100cf8000 + 131409
6   Ice                           	       0x100d1bfb9 0x100cf8000 + 147385
7   Ice                           	       0x100d0a319 0x100cf8000 + 74521
8   libswift_Concurrency.dylib    	       0x288eda7c1 completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:

Thread 2:

Thread 3:

Thread 4:

Thread 5:

Thread 6:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x18e9f2c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x18ea05028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x18e9fb98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x18e9f2fb4 mach_msg + 24
4   CoreFoundation                	       0x18ead4b90 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x18ead34e8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18eb8d35c _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x192f6dcb4 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x18ea35c08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x18ea30ba8 thread_start + 8

Thread 7:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000bf3a7aa80   x1: 0x20000001fb4532ef   x2: 0x00000001fb4532e8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x000000020a19be46  x10: 0x0000000804298cae  x11: 0x00000000000003ff
   x12: 0x000000000000013a  x13: 0x0000000bf5751390  x14: 0x20000001fb4532ef  x15: 0x00000001fb4532e8
   x16: 0x20000001fb4532ef  x17: 0x000000000000003e  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x0000000bf3a7aa80  x21: 0x0000000bf487cb40  x22: 0x0000000bf5531b40  x23: 0x0000000000000002
   x24: 0x0000000100ea1000  x25: 0x0000000bf5b01200  x26: 0x0000000bf39f3570  x27: 0x0000000bf1c146e0
   x28: 0xffffffff76ffffff   fp: 0x000000016f1038d0   lr: 0x0000000100d04928
    sp: 0x000000016f1038b0   pc: 0x0000000100d04934 cpsr: 0x60001000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x100cf8000 -        0x100e87fff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/Ice.app/Contents/MacOS/Ice
       0x100fe0000 -        0x101023fff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x101174000 -        0x10117ffff libobjc-trampolines.dylib (*) <f8bd9069-8c4f-37ea-af9a-2b1060f54e4f> /usr/lib/libobjc-trampolines.dylib
       0x115460000 -        0x115baffff com.apple.AGXMetalG13X (341.11) <f4b41620-c555-31a5-ae52-eca9b80bf0d8> /System/Library/Extensions/AGXMetalG13X.bundle/Contents/MacOS/AGXMetalG13X
       0x288e6d000 -        0x288ef6bdf libswift_Concurrency.dylib (*) <1a4607f2-13d0-3c00-8cce-f3298da11e60> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x18e9f2000 -        0x18ea2e49f libsystem_kernel.dylib (*) <9fe7c84d-0c2b-363f-bee5-6fd76d67a227> /usr/lib/system/libsystem_kernel.dylib
       0x18ea75000 -        0x18efbbabf com.apple.CoreFoundation (6.9) <3c4a3add-9e48-33da-82ee-80520e6cbe3b> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x192ebe000 -        0x1945eab9f com.apple.AppKit (6.9) <3c0949bb-e361-369a-80b7-17440eb09e98> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x18ea2f000 -        0x18ea3babb libsystem_pthread.dylib (*) <e95973b8-824c-361e-adf4-390747c40897> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=191.0M written=610K(0%) resident=610K(0%) swapped_out=0K(0%) unallocated=190.4M(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               128K        1 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                          2000K       12 
ColorSync                           16K        1 
CoreAnimation                     4928K       76 
CoreGraphics                        64K        4 
CoreUI image data                 2160K       16 
Foundation                          16K        1 
Kernel Alloc Once                   32K        1 
MALLOC                           165.3M       42 
MALLOC guard page                 3424K        4 
STACK GUARD                       56.1M        8 
Stack                             11.7M        8 
VM_ALLOCATE                       4944K       11 
__AUTH                            5828K      645 
__AUTH_CONST                      88.3M     1026 
__CTF                               824        1 
__DATA                            30.0M      978 
__DATA_CONST                      32.8M     1035 
__DATA_DIRTY                      8797K      888 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       593.9M        5 
__OBJC_RO                         78.3M        1 
__OBJC_RW                         2567K        1 
__TEXT                             1.2G     1057 
__TPRO_CONST                       128K        2 
mapped file                      284.8M       47 
page table in kernel               610K        1 
shared memory                     1968K       19 
===========                     =======  ======= 
TOTAL                              2.5G     5895 


-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2025-12-06 18:45:09.00 +0100","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":0,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.1 (25B78)","roots_installed":0,"name":"Ice","incident_id":"272895A5-5FCF-414B-8DB4-F99B97B9AAD3"}
{
  "uptime" : 1900000,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "MacBookPro18,3",
  "coalitionID" : 95507,
  "osVersion" : {
    "train" : "macOS 26.1",
    "build" : "25B78",
    "releaseType" : "User"
  },
  "captureTime" : "2025-12-06 18:45:08.3879 +0100",
  "codeSigningMonitor" : 1,
  "incident" : "272895A5-5FCF-414B-8DB4-F99B97B9AAD3",
  "pid" : 53111,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-12-06 18:44:52.7737 +0100",
  "procStartAbsTime" : 46550668155328,
  "procExitAbsTime" : 46551042624762,
  "procName" : "Ice",
  "procPath" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"3DF78147-0895-5852-B47A-D24FBA7863DD","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "8C210DEF-784C-4F93-AEDB-9794AC3AC198",
  "appleIntelligenceStatus" : {"reasons":["selectedLanguageDoesNotMatchSelectedSiriLanguageInfo(system: en, siri: de)","selectedLanguageDoesNotMatchSelectedSiriLanguage"],"state":"unavailable"},
  "developerMode" : 1,
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570503953,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"6AwAsAGpQPngAxSqvucElPMDAKrgAxSqxOcElLMB+Ldo\/mDTiAAAtA==","atPC":"IAAg1BMAgNIoAIBS6DMAOQgdABJgggiq\/XtCqfRPQan\/wwCRwANf1g=="},
  "bootSessionUUID" : "0CA5CEA2-1328-46EB-B0AD-69A9D18C2AA5",
  "wakeTime" : 89036,
  "sleepWakeUUID" : "802BA1CA-3C16-4DA9-93B0-BAF747D57892",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000001, 0x0000000100d04934","rawCodes":[1,4308617524],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":53111},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":23529476,"threadState":{"x":[{"value":51332491904},{"value":2305843017724277487,"symbolLocation":2305843009213693959,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8510583528,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":1},{"value":68719476739},{"value":7},{"value":68719476739},{"value":7},{"value":1},{"value":8759393862,"objc-selector":"windowNumber"},{"value":34429570222},{"value":1023},{"value":314},{"value":51362730896},{"value":2305843017724277487,"symbolLocation":2305843009213693959,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8510583528,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":2305843017724277487,"symbolLocation":2305843009213693959,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":62},{"value":0},{"value":4294967296},{"value":51332491904},{"value":51347180352},{"value":51360504640},{"value":2},{"value":4310306816},{"value":51366597120},{"value":51331937648},{"value":51300615904},{"value":18446744071411073023}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4308617512},"cpsr":{"value":1610616832},"fp":{"value":6158301392},"sp":{"value":6158301360},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4308617524,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":51508,"imageIndex":0},{"imageOffset":797464,"imageIndex":0},{"imageOffset":797344,"imageIndex":0},{"imageOffset":792032,"imageIndex":0},{"imageOffset":526305,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":147385,"imageIndex":0},{"imageOffset":74521,"imageIndex":0},{"imageOffset":448449,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":4}]},{"id":23529479,"frames":[],"threadState":{"x":[{"value":6158872576},{"value":6403},{"value":6158336000},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6158872576},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6688017300},"far":{"value":0}}},{"id":23529480,"frames":[],"threadState":{"x":[{"value":6159446016},{"value":8707},{"value":6158909440},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6159446016},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6688017300},"far":{"value":0}}},{"id":23529488,"frames":[],"threadState":{"x":[{"value":6160019456},{"value":19463},{"value":6159482880},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6160019456},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6688017300},"far":{"value":0}}},{"id":23529490,"frames":[],"threadState":{"x":[{"value":6160592896},{"value":18227},{"value":6160056320},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6160592896},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6688017300},"far":{"value":0}}},{"id":23529491,"frames":[],"threadState":{"x":[{"value":6161166336},{"value":22795},{"value":6160629760},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6161166336},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6688017300},"far":{"value":0}}},{"id":23529492,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":31235},{"value":0},{"value":18446744073709551569},{"value":8533302000},{"value":0},{"value":4294967295},{"value":2},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":6161735816},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6687838248},"cpsr":{"value":4096},"fp":{"value":6161735664},"sp":{"value":6161735584},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6687763508},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":6},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":6},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":6},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":6},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":7},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":7},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":7},{"imageOffset":720052,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":8},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":9},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":9}]},{"id":23529521,"frames":[],"threadState":{"x":[{"value":6162313216},{"value":68403},{"value":6161776640},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6162313216},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6688017300},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4308566016,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4311613440,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/Applications\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4313268224,
    "size" : 49152,
    "uuid" : "f8bd9069-8c4f-37ea-af9a-2b1060f54e4f",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4651876352,
    "CFBundleShortVersionString" : "341.11",
    "CFBundleIdentifier" : "com.apple.AGXMetalG13X",
    "size" : 7667712,
    "uuid" : "f4b41620-c555-31a5-ae52-eca9b80bf0d8",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG13X.bundle\/Contents\/MacOS\/AGXMetalG13X",
    "name" : "AGXMetalG13X",
    "CFBundleVersion" : "341.11"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 10886762496,
    "size" : 564192,
    "uuid" : "1a4607f2-13d0-3c00-8cce-f3298da11e60",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6687760384,
    "size" : 246944,
    "uuid" : "9fe7c84d-0c2b-363f-bee5-6fd76d67a227",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6688296960,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5532352,
    "uuid" : "3c4a3add-9e48-33da-82ee-80520e6cbe3b",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4109.1.401"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6759899136,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24300448,
    "uuid" : "3c0949bb-e361-369a-80b7-17440eb09e98",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.20.119"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6688010240,
    "size" : 51900,
    "uuid" : "e95973b8-824c-361e-adf4-390747c40897",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6682951680,
  "size" : 5609635840,
  "uuid" : "b69ff43c-dbfd-3fb1-b4fe-a8fe32ea1062"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=191.0M written=610K(0%) resident=610K(0%) swapped_out=0K(0%) unallocated=190.4M(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               128K        1 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                          2000K       12 \nColorSync                           16K        1 \nCoreAnimation                     4928K       76 \nCoreGraphics                        64K        4 \nCoreUI image data                 2160K       16 \nFoundation                          16K        1 \nKernel Alloc Once                   32K        1 \nMALLOC                           165.3M       42 \nMALLOC guard page                 3424K        4 \nSTACK GUARD                       56.1M        8 \nStack                             11.7M        8 \nVM_ALLOCATE                       4944K       11 \n__AUTH                            5828K      645 \n__AUTH_CONST                      88.3M     1026 \n__CTF                               824        1 \n__DATA                            30.0M      978 \n__DATA_CONST                      32.8M     1035 \n__DATA_DIRTY                      8797K      888 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       593.9M        5 \n__OBJC_RO                         78.3M        1 \n__OBJC_RW                         2567K        1 \n__TEXT                             1.2G     1057 \n__TPRO_CONST                       128K        2 \nmapped file                      284.8M       47 \npage table in kernel               610K        1 \nshared memory                     1968K       19 \n===========                     =======  ======= \nTOTAL                              2.5G     5895 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "d92dfeefd95e612eb13a8809044af5de644a44fc",
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "60f8ddccefea4203d95cbeef",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000025
    },
    {
      "rolloutId" : "63f9578e238e7b23a1f3030a",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000005
    }
  ],
  "experiments" : [

  ]
}
}

Model: MacBookPro18,3, BootROM 13822.41.1, proc 8:6:2 processors, 16 GB, SMC 
Graphics: Apple M1 Pro, Apple M1 Pro, Built-In
Display: Color LCD, 3024 x 1964 Retina, Main, MirrorOff, Online
Memory Module: LPDDR5, Samsung
AirPort: spairport_wireless_card_type_wifi (0x14E4, 0x4387), wl0: Sep 22 2025 22:41:34 version 20.131.4.0.8.7.215 FWID 01-45655c04
IO80211_driverkit-1530.16 "IO80211_driverkit-1530.16" Oct 10 2025 22:56:35
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Wi-Fi, AirPort, en0
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.
Thunderbolt Bus: MacBook Pro, Apple Inc.


### Steps to Reproduce

1. open the app
2. open settings
3. select "Use Ice Bar"
4. close settings
5. use Ice

### App Version

Version 0.11.12

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #813

- 链接：https://github.com/jordanbaird/Ice/issues/813
- 作者：[mdigirol](https://github.com/mdigirol)
- 状态：open
- 创建时间：2025-12-07T03:36:16Z（UTC）
- 更新时间：2025-12-10T19:36:46Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: Ice bar closes soon after opening
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When Ice Bar is enabled, clicking Ice icon to open Ice Bar can sometimes open the bar only for it to close a few milliseconds after. The app itself doesn't crash or shutdown, and clicking the Ice icon again leads to the same result. 

### Steps to Reproduce

1. Enable Ice Bar
2. Click Ice icon in the menu bar to open Ice Bar.

This doesn't happen all the time; it does not have concrete reproducibility.

### App Version

0.11.13-dev1

### macOS Version

26.1 (25B78)

### Additional Information

![Image](https://github.com/user-attachments/assets/9ab7b68f-d9ea-48d1-a244-84293dcf31af)
```

### jordanbaird/Ice #814

- 链接：https://github.com/jordanbaird/Ice/issues/814
- 作者：[iamtodor](https://github.com/iamtodor)
- 状态：open
- 创建时间：2025-12-08T08:08:17Z（UTC）
- 更新时间：2026-01-29T11:04:54Z（UTC）
- 标签：Bug
- 评论数：25（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: "Use Ice Bar" feature does not work
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I would like to use a separate bar below the menu bar, but it simply does not work with any options: mouse pointer, dynamic, or ice icon.

<img width="662" height="130" alt="Image" src="https://github.com/user-attachments/assets/8d2c8d39-902a-4736-990c-da980ca04cc8" />

### Steps to Reproduce

I uploaded the recording

<!-- Failed to upload "Screen Recording 2025-12-08 at 09.07.00.mov" -->

### App Version

0.11.12

### macOS Version

26.1 (25B78)

### Additional Information

_No response_
```

### jordanbaird/Ice #816

- 链接：https://github.com/jordanbaird/Ice/issues/816
- 作者：[sverdiyev](https://github.com/sverdiyev)
- 状态：open
- 创建时间：2025-12-12T09:46:18Z（UTC）
- 更新时间：2025-12-22T12:39:24Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu Bar Layout does not give option to customize anything
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

this is a fresh install on a new laptop.

<img width="902" height="623" alt="Image" src="https://github.com/user-attachments/assets/62539135-2275-455c-83af-70424a82a204" />

<img width="905" height="623" alt="Image" src="https://github.com/user-attachments/assets/d1ebd4b7-fb45-49b8-bfe6-e17f85647229" />

<img width="476" height="111" alt="Image" src="https://github.com/user-attachments/assets/ad770857-624b-404b-9cb4-320dc932fe79" />


It still hides everything, just cannot customize. 

<img width="581" height="50" alt="Image" src="https://github.com/user-attachments/assets/58dda140-a3f1-4c56-9250-50703b76273c" />

<img width="638" height="70" alt="Image" src="https://github.com/user-attachments/assets/fdc4a634-a1b3-4adf-a810-a9fd42c769a6" />


attempted fixes:
1. deleted ICE, reinstalled (into Applications directory)
2. restarted laptop

### Steps to Reproduce

1. fresh install
2. grant permissions
3. thats it :) 

### App Version

0.11.12

### macOS Version

26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #817

- 链接：https://github.com/jordanbaird/Ice/issues/817
- 作者：[iamtodor](https://github.com/iamtodor)
- 状态：open
- 创建时间：2025-12-12T11:27:25Z（UTC）
- 更新时间：2025-12-17T09:24:39Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: User (Login) Icon is not customasibale
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

As title said, the user icon cannot be hidden and adjusted. The icon is being placed in the menu bar, but Ice does not see it

### Steps to Reproduce

The icon is being placed in the menu bar, but Ice does not see it

### App Version

0.11.13-dev.2

### macOS Version

26.1

### Additional Information

<img width="443" height="36" alt="Image" src="https://github.com/user-attachments/assets/9ffa55a7-179b-4cbe-b86f-892b84b45716" />

<img width="670" height="351" alt="Image" src="https://github.com/user-attachments/assets/70352fbb-fcd5-40f7-90c1-6cad4ab85192" />
```

### jordanbaird/Ice #818

- 链接：https://github.com/jordanbaird/Ice/issues/818
- 作者：[moritzWa](https://github.com/moritzWa)
- 状态：open
- 创建时间：2025-12-12T13:47:50Z（UTC）
- 更新时间：2026-05-25T22:27:31Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu bar layout editor is just empty/white
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Menu bar layout editor is just empty/white

<img width="952" height="449" alt="Image" src="https://github.com/user-attachments/assets/2319fe6f-b034-494f-90b5-4ba8afd8235f" />

### Steps to Reproduce

I'm on macOS Tahoe Version 26.0 (just upgated)

### App Version

0.11.12

### macOS Version

25.0

### Additional Information

<img width="952" height="449" alt="Image" src="https://github.com/user-attachments/assets/2319fe6f-b034-494f-90b5-4ba8afd8235f" />
```

### jordanbaird/Ice #819

- 链接：https://github.com/jordanbaird/Ice/issues/819
- 作者：[ThomasWaldmann](https://github.com/ThomasWaldmann)
- 状态：open
- 创建时间：2025-12-13T14:13:39Z（UTC）
- 更新时间：2026-07-07T18:43:21Z（UTC）
- 标签：Bug
- 评论数：10（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: memory leak in WindowServer caused by Ice?
```

**正文原文**

````markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

There is #530 about a memory leak in Ice itself, but this issue is different, because the leak is in Windowserver and only the cause of it is in Ice.

The memory usage of WindowServer steadily climbs up in 16kB (one page) increments every few (2-4?) seconds.

This only happens when Ice has screen recording permissions.


### Steps to Reproduce

Important: Reboot your system to make the effect easier to see.

Do not run a lot of other stuff, just the bare minimum.

In a Terminal:
```
watch sudo footprint $(pgrep WindowServer)
```

Watch the line with Category "untagged (VM_ALLOCATE)", look at the "Dirty" column. It goes up in 16KB increments every few seconds.

Now take away Screen Recording Permissions from Ice (and restart the Ice process).

Watch the WindowServer footprint again: that memory usage still goes up and down a bit, but the steady leaking is gone.


### App Version

0.11.12

### macOS Version

15.7.3 (but also happened on older versions)

### HW

MBP M3P

### Additional Information

The memory pages leaked only contain "0A 00 00 00 00 ...".

The effect is a real PITA, because WindowServer can grow many GigaBytes big and then you will need to reboot (logging out does not suffice).
````

### jordanbaird/Ice #821

- 链接：https://github.com/jordanbaird/Ice/issues/821
- 作者：[cjvqj5x2b6-beep](https://github.com/cjvqj5x2b6-beep)
- 状态：open
- 创建时间：2025-12-15T12:47:39Z（UTC）
- 更新时间：2026-07-11T00:02:52Z（UTC）
- 标签：Bug
- 评论数：12（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: ICE crashes every time on clicking the ICE icon in menubar. iMac, macOS 26.2 (issue identical on 26.1).
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Ice [7847]
Path:                /Applications/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Background
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [1076]
User ID:             501

Date/Time:           2025-12-15 13:39:52.8522 +0100
Launch Time:         2025-12-15 13:38:37.7680 +0100
Hardware Model:      iMac21,1
OS Version:          macOS 26.2 (25C56)
Release Type:        User

Crash Reporter Key:  54857838-3657-B285-C8E8-331A1836D6EB
Incident Identifier: 5F0C52B2-F93D-44F8-992B-D6B8CA00F943

Time Awake Since Boot: 52000 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x000000010420c934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [7847]


Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   Ice                           	       0x10420c934 0x104200000 + 51508
1   Ice                           	       0x1042c2b18 0x104200000 + 797464
2   Ice                           	       0x1042c15e0 0x104200000 + 792032
3   Ice                           	       0x1042807e1 0x104200000 + 526305
4   Ice                           	       0x104220151 0x104200000 + 131409
5   Ice                           	       0x104223fb9 0x104200000 + 147385
6   Ice                           	       0x104212319 0x104200000 + 74521
7   libswift_Concurrency.dylib    	       0x291c9b2fd completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:

Thread 2:

Thread 3:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x19636ac34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x19637d028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x19637398c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x19636afb4 mach_msg + 24
4   CoreFoundation                	       0x19644cba0 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x19644b4f8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x196505e34 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x19a8eea34 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x1963adc08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x1963a8ba8 thread_start + 8

Thread 4:

Thread 5:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000a44540280   x1: 0x1c0000020331f2bf   x2: 0x000000020331f2b8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x0000000211ae9a51  x10: 0x0000000a570468e9  x11: 0x00000000000003ff
   x12: 0x0000000000000365  x13: 0x0000000a459b3640  x14: 0x1c0000020331f2bf  x15: 0x000000020331f2b8
   x16: 0x1c0000020331f2bf  x17: 0x0000000000000036  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x0000000a44540280  x21: 0x0000000a4506ca00  x22: 0x0000000a45a44c00  x23: 0x0000000000000002
   x24: 0x00000001043a9000  x25: 0x0000000a44f5e880  x26: 0x0000000a447e11a0  x27: 0x0000000a441246c0
   x28: 0xffffffff76ffffff   fp: 0x000000016bbfcfc0   lr: 0x000000010420c928
    sp: 0x000000016bbfcfa0   pc: 0x000000010420c934 cpsr: 0x60001000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x104200000 -        0x10438ffff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/Ice.app/Contents/MacOS/Ice
       0x1044e8000 -        0x10452bfff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x104880000 -        0x10488bfff libobjc-trampolines.dylib (*) <d4baeab8-b553-3779-a0ff-d8848e7a22df> /usr/lib/libobjc-trampolines.dylib
       0x1185e8000 -        0x118d37fff com.apple.AGXMetal13-3 (342.3) <1a28beb3-d41b-3dfb-b477-fee36881bc82> /System/Library/Extensions/AGXMetal13_3.bundle/Contents/MacOS/AGXMetal13_3
       0x291c2e000 -        0x291cb76ff libswift_Concurrency.dylib (*) <2cd4d4d2-15a3-3057-b506-6e79bd1d6428> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x19636a000 -        0x1963a649f libsystem_kernel.dylib (*) <548c45c8-9733-3f0d-8ef4-c06df1df2ad0> /usr/lib/system/libsystem_kernel.dylib
       0x1963ed000 -        0x196935c3f com.apple.CoreFoundation (6.9) <649000a2-3eb4-3cf5-970a-d3cb37b5780c> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x19a83f000 -        0x19bf6e27f com.apple.AppKit (6.9) <4e909aec-68bc-3fc9-a87a-de928e1e36e1> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x1963a7000 -        0x1963b3abb libsystem_pthread.dylib (*) <527c4ba0-91a5-378b-b3e2-d38269ca5a66> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=168.8M written=4418K(3%) resident=610K(0%) swapped_out=3808K(2%) unallocated=164.5M(97%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               128K        1 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                          1856K        8 
ColorSync                           16K        1 
CoreAnimation                     14.9M       63 
CoreGraphics                        48K        3 
CoreUI image data                 2368K       18 
Foundation                          16K        1 
Kernel Alloc Once                   32K        1 
MALLOC                           141.3M       35 
MALLOC guard page                 3152K        4 
Mach message                      1072K        2 
STACK GUARD                       56.1M        5 
STACK GUARD (graphics)              16K        1 
Stack                             10.6M        6 
VM_ALLOCATE                       5024K       16 
__AUTH                            5881K      644 
__AUTH_CONST                      88.5M     1026 
__CTF                               824        1 
__DATA                            35.6M      978 
__DATA_CONST                      32.9M     1035 
__DATA_DIRTY                      8759K      887 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       592.1M        5 
__OBJC_RO                         78.4M        1 
__OBJC_RW                         2570K        1 
__TEXT                             1.2G     1055 
__TEXT (graphics)                 1872K        2 
__TPRO_CONST                       128K        2 
mapped file                      307.8M       54 
page table in kernel               610K        1 
shared memory                     1920K       15 
===========                     =======  ======= 
TOTAL                              2.5G     5876 


-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2025-12-15 13:39:57.00 +0100","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":0,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.2 (25C56)","roots_installed":0,"name":"Ice","incident_id":"5F0C52B2-F93D-44F8-992B-D6B8CA00F943"}
{
  "uptime" : 52000,
  "procRole" : "Background",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "iMac21,1",
  "coalitionID" : 1076,
  "osVersion" : {
    "train" : "macOS 26.2",
    "build" : "25C56",
    "releaseType" : "User"
  },
  "captureTime" : "2025-12-15 13:39:52.8522 +0100",
  "codeSigningMonitor" : 1,
  "incident" : "5F0C52B2-F93D-44F8-992B-D6B8CA00F943",
  "pid" : 7847,
  "translated" : false,
  "cpuType" : "ARM-64",
  "procLaunch" : "2025-12-15 13:38:37.7680 +0100",
  "procStartAbsTime" : 1248754692353,
  "procExitAbsTime" : 1250555574067,
  "procName" : "Ice",
  "procPath" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"7E0AA005-3503-5E6C-932E-F0EAF0C42FCB","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "54857838-3657-B285-C8E8-331A1836D6EB",
  "appleIntelligenceStatus" : {"state":"available"},
  "developerMode" : 1,
  "bootProgressRegister" : "0x2f000000",
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570503953,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"6AwAsAGpQPngAxSqvucElPMDAKrgAxSqxOcElLMB+Ldo\/mDTiAAAtA==","atPC":"IAAg1BMAgNIoAIBS6DMAOQgdABJgggiq\/XtCqfRPQan\/wwCRwANf1g=="},
  "bootSessionUUID" : "13D6094C-4962-4E57-8185-8F6E3B1F7832",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000001, 0x000000010420c934","rawCodes":[1,4364224820],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":7847},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":574163,"threadState":{"x":[{"value":44096029312},{"value":2017612641705521855,"symbolLocation":2017612633061982215,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8643539640,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":1},{"value":68719476739},{"value":7},{"value":68719476739},{"value":7},{"value":1},{"value":8886590033,"objc-selector":"windowNumber"},{"value":44409579753},{"value":1023},{"value":869},{"value":44117472832},{"value":2017612641705521855,"symbolLocation":2017612633061982215,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8643539640,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":2017612641705521855,"symbolLocation":2017612633061982215,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":54},{"value":0},{"value":4294967296},{"value":44096029312},{"value":44107745792},{"value":44118068224},{"value":2},{"value":4365914112},{"value":44106639488},{"value":44098785696},{"value":44091721408},{"value":18446744071411073023}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4364224808},"cpsr":{"value":1610616832},"fp":{"value":6102699968},"sp":{"value":6102699936},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4364224820,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":51508,"imageIndex":0},{"imageOffset":797464,"imageIndex":0},{"imageOffset":792032,"imageIndex":0},{"imageOffset":526305,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":147385,"imageIndex":0},{"imageOffset":74521,"imageIndex":0},{"imageOffset":447229,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":4}]},{"id":574173,"frames":[],"threadState":{"x":[{"value":6103265280},{"value":6403},{"value":6102728704},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6103265280},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6815386516},"far":{"value":0}}},{"id":574175,"frames":[],"threadState":{"x":[{"value":6103838720},{"value":8707},{"value":6103302144},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6103838720},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6815386516},"far":{"value":0}}},{"id":574184,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":31235},{"value":0},{"value":18446744073709551569},{"value":8666009760},{"value":0},{"value":4294967295},{"value":2},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":6104981640},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6815207464},"cpsr":{"value":4096},"fp":{"value":6104981488},"sp":{"value":6104981408},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6815132724},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":6},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":6},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":6},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":6},{"imageOffset":392096,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":7},{"imageOffset":386296,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":7},{"imageOffset":1150516,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":7},{"imageOffset":719412,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":8},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":9},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":9}]},{"id":575029,"frames":[],"threadState":{"x":[{"value":6104412160},{"value":52291},{"value":6103875584},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6104412160},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6815386516},"far":{"value":0}}},{"id":575030,"frames":[],"threadState":{"x":[{"value":6105559040},{"value":0},{"value":6105022464},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":4096},"fp":{"value":0},"sp":{"value":6105559040},"esr":{"value":0},"pc":{"value":6815386516},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4364173312,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4367220736,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/Applications\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4370989056,
    "size" : 49152,
    "uuid" : "d4baeab8-b553-3779-a0ff-d8848e7a22df",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4703813632,
    "CFBundleShortVersionString" : "342.3",
    "CFBundleIdentifier" : "com.apple.AGXMetal13-3",
    "size" : 7667712,
    "uuid" : "1a28beb3-d41b-3dfb-b477-fee36881bc82",
    "path" : "\/System\/Library\/Extensions\/AGXMetal13_3.bundle\/Contents\/MacOS\/AGXMetal13_3",
    "name" : "AGXMetal13_3",
    "CFBundleVersion" : "342.3"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 11035402240,
    "size" : 562944,
    "uuid" : "2cd4d4d2-15a3-3057-b506-6e79bd1d6428",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6815129600,
    "size" : 246944,
    "uuid" : "548c45c8-9733-3f0d-8ef4-c06df1df2ad0",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6815666176,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5540928,
    "uuid" : "649000a2-3eb4-3cf5-970a-d3cb37b5780c",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4201"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6887305216,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24310400,
    "uuid" : "4e909aec-68bc-3fc9-a87a-de928e1e36e1",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.30.107"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6815379456,
    "size" : 51900,
    "uuid" : "527c4ba0-91a5-378b-b3e2-d38269ca5a66",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6810320896,
  "size" : 5653544960,
  "uuid" : "acb998b6-263c-3634-b0a8-ae8270a116c2"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=168.8M written=4418K(3%) resident=610K(0%) swapped_out=3808K(2%) unallocated=164.5M(97%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               128K        1 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                          1856K        8 \nColorSync                           16K        1 \nCoreAnimation                     14.9M       63 \nCoreGraphics                        48K        3 \nCoreUI image data                 2368K       18 \nFoundation                          16K        1 \nKernel Alloc Once                   32K        1 \nMALLOC                           141.3M       35 \nMALLOC guard page                 3152K        4 \nMach message                      1072K        2 \nSTACK GUARD                       56.1M        5 \nSTACK GUARD (graphics)              16K        1 \nStack                             10.6M        6 \nVM_ALLOCATE                       5024K       16 \n__AUTH                            5881K      644 \n__AUTH_CONST                      88.5M     1026 \n__CTF                               824        1 \n__DATA                            35.6M      978 \n__DATA_CONST                      32.9M     1035 \n__DATA_DIRTY                      8759K      887 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       592.1M        5 \n__OBJC_RO                         78.4M        1 \n__OBJC_RW                         2570K        1 \n__TEXT                             1.2G     1055 \n__TEXT (graphics)                 1872K        2 \n__TPRO_CONST                       128K        2 \nmapped file                      307.8M       54 \npage table in kernel               610K        1 \nshared memory                     1920K       15 \n===========                     =======  ======= \nTOTAL                              2.5G     5876 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "e58f57d38413d271cc7d59d4ba898da52ed37733",
  "bug_type" : "309",
  "roots_installed" : 0,
  "trmStatus" : 8192,
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "64628732bf2f5257dedc8988",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000001
    },
    {
      "rolloutId" : "644114de41e7236e6177f9bd",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000013
    }
  ],
  "experiments" : [
    {
      "treatmentId" : "28060e10-d4e5-4163-aa2b-d8bd088d5cbf",
      "experimentId" : "6685b283afc7c17197d69eec",
      "deploymentId" : 400000012
    },
    {
      "treatmentId" : "f18344bb-554f-48ae-8449-e108a8813a55",
      "experimentId" : "6685b5584477001000e8c6c9",
      "deploymentId" : 400000009
    }
  ]
}
}

Model: iMac21,1, BootROM 13822.61.10, proc 8:4:4 processors, 8 GB, SMC 
Graphics: Apple M1, Apple M1, Built-In
Display: iMac, Retina 4.5K (4480 x 2520), Main, MirrorOff, Online
Memory Module: LPDDR4, Hynix
AirPort: spairport_wireless_card_type_wifi (0x14E4, 0x4378), wl0: Jul 11 2025 19:42:51 version 18.20.480.0.7.8.186 FWID 01-4b2f7f1a
IO80211_driverkit-1533.5 "IO80211_driverkit-1533.5" Nov 14 2025 18:26:34
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Ethernet, Ethernet, en0
Network Service: Wi-Fi, AirPort, en1
Thunderbolt Bus: iMac, Apple Inc.
Thunderbolt Bus: iMac, Apple Inc.


### Steps to Reproduce

Click an menubar item of ICE / ice icon immediately crashes ICE. Option click resolves into settings as usual w/o crashing.

### App Version

0.11.12

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #823

- 链接：https://github.com/jordanbaird/Ice/issues/823
- 作者：[willfischer26](https://github.com/willfischer26)
- 状态：open
- 创建时间：2025-12-16T14:50:41Z（UTC）
- 更新时间：2026-05-26T12:08:43Z（UTC）
- 标签：Feature
- 评论数：17（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: Are we every going to get a stable version for macOS Tahoe, or is the app not in development anymore?
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

I know developing ice can be really busy, but we have stayed on the beta since September. I am wondering when you will push out a full release for Tahoe? I would look forward to that, as well as some new features, and in 2024 loads of new features and frequent updates were introduced, and now, we don’t really get any updates? Why, and do you have anything planned for this app in the future, or have you stopped developing it?

### Additional Information

_No response_
```

### jordanbaird/Ice #824

- 链接：https://github.com/jordanbaird/Ice/issues/824
- 作者：[ian-rose](https://github.com/ian-rose)
- 状态：open
- 创建时间：2025-12-17T14:05:32Z（UTC）
- 更新时间：2026-01-29T11:03:36Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Right-clicking in external monitor opens "Edit menu bar appearance" menu
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

On a setup with external monitors that are larger than the primary monitor, and all displays set to the same space (menu bar and dock are only on the primary display)l, right-clicking on a non-primary monitor roughly at the same height as the menu bar on the primary monitor causes the Ice "Edit menu bar appearance" menu to open.

### Steps to Reproduce

- Have a setup with at least one external monitor, with more vertical pixels than the main monitor
- Disable each display having its own space
- Right-click in an external monitor at roughly the same height as the menu bar in the main monitor

### App Version

0.11.12

### macOS Version

15.7.2

### Additional Information

<img width="715" height="625" alt="Image" src="https://github.com/user-attachments/assets/b23fd236-a3c7-4045-afce-1a44e71d6ea1" />
<img width="3008" height="1692" alt="Image" src="https://github.com/user-attachments/assets/0d5e92d0-ca45-4e80-84f7-db3537218d03" />
```

### jordanbaird/Ice #825

- 链接：https://github.com/jordanbaird/Ice/issues/825
- 作者：[rak00001](https://github.com/rak00001)
- 状态：open
- 创建时间：2025-12-18T09:04:18Z（UTC）
- 更新时间：2026-02-05T04:16:23Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: "show on click" on secondary screen shows the extra Ice bar in a small resolution
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

It only happens every now and again, when moving between screens – clicking to show hidden items on main macbook screen is fine, but if I go to my external 2K monitor and click on the menu bar the Ice bar that appears is tiny. Back and forth a couple times and it "fixes itself".

At the moment not able to screenshot as it's obviously chosen to work fine, but I'll add one as soon as it is replicated.

### Steps to Reproduce

Click on menu bar on main screen
click on menu bar on secondary screen without doing any other steps in between two actions


### App Version

0.11.13-dev.2

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #826

- 链接：https://github.com/jordanbaird/Ice/issues/826
- 作者：[moisesrodriguez](https://github.com/moisesrodriguez)
- 状态：open
- 创建时间：2025-12-22T02:28:25Z（UTC）
- 更新时间：2025-12-22T02:28:25Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Not opening menu item
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When clicking to open the battery menu item, it does nothing.

### Steps to Reproduce

1. Click to show hidden menu bar items.
2. Click battery menu item

### App Version

0.11.3-dev.2

### macOS Version

26.1 (25B78)

### Additional Information

Here is a screen recording:

https://github.com/user-attachments/assets/bd9507ae-b2f2-40af-a97b-19f6fceb22f3
```

### jordanbaird/Ice #829

- 链接：https://github.com/jordanbaird/Ice/issues/829
- 作者：[Andrewzhang00GH](https://github.com/Andrewzhang00GH)
- 状态：open
- 创建时间：2025-12-25T15:32:14Z（UTC）
- 更新时间：2026-01-08T21:04:55Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: the ice bar cannot show the proper size when second monitor connected
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have a 2k, 27' external monitor and it causes ice bar to be really really small on the external monitor.
This is the external monitor

<img width="232" height="73" alt="Image" src="https://github.com/user-attachments/assets/d7540382-6034-4dc9-88bb-096c01e5b736" />

This is the macbook's monitor.

<img width="146" height="46" alt="Image" src="https://github.com/user-attachments/assets/423ce25b-2e57-40e2-9fe9-e2c438d73219" />


### Steps to Reproduce

It should be able to display the correct size ice bar on monitors with different resolutions

### App Version

Version 0.11.13-dev.2

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #830

- 链接：https://github.com/jordanbaird/Ice/issues/830
- 作者：[anjobaba1008](https://github.com/anjobaba1008)
- 状态：open
- 创建时间：2025-12-25T21:59:41Z（UTC）
- 更新时间：2026-01-29T12:54:34Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: So many bugs
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

So many bug i dont know where to start. but most important: I noticed a higher temperature of the mac after insyallin and running ICE. 

### Steps to Reproduce

install on sequoia 15.7.3

### App Version

0.11.12

### macOS Version

15.7.3

### Additional Information

_No response_
```

### jordanbaird/Ice #832

- 链接：https://github.com/jordanbaird/Ice/issues/832
- 作者：[RicardoUKMX](https://github.com/RicardoUKMX)
- 状态：open
- 创建时间：2025-12-28T17:31:00Z（UTC）
- 更新时间：2026-05-25T22:27:32Z（UTC）
- 标签：Bug
- 评论数：8（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu Bar Layout with Tahoe OS
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have tried to rearrange apps under "menu bar layout" and any of the icons shows now. While opening the bar apps will show but there is no way to rearrange them.

### Steps to Reproduce

![Image](https://github.com/user-attachments/assets/65154ba9-6415-4de5-8db3-9cb20cf9969a)

### App Version

0.11.12

### macOS Version

Tahoe

### Additional Information

![Image](https://github.com/user-attachments/assets/dde14d45-7b7e-46e8-9fae-541ec681996d)
```

### jordanbaird/Ice #833

- 链接：https://github.com/jordanbaird/Ice/issues/833
- 作者：[hdob-macko](https://github.com/hdob-macko)
- 状态：open
- 创建时间：2025-12-30T16:57:41Z（UTC）
- 更新时间：2026-01-08T00:03:57Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：系统升级兼容与待澄清反馈

**标题原文**

```text
[Bug]: Cant see anything on
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

<img width="1123" height="527" alt="Image" src="https://github.com/user-attachments/assets/1c458c04-058d-447b-ab7b-e19795f0f97d" />

### Steps to Reproduce

Go to settings page, also floating bar below doesn't work. Dont have time to do much debugging but its just not working

### App Version

0.11.12

### macOS Version

Version 26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #834

- 链接：https://github.com/jordanbaird/Ice/issues/834
- 作者：[vargula1](https://github.com/vargula1)
- 状态：open
- 创建时间：2025-12-31T10:51:13Z（UTC）
- 更新时间：2026-09-01T15:40:53Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：权限、更新、安装与分发

**标题原文**

```text
[Bug]:
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The attached dialog comes back again and again even if I fully support permissions. Incidentally ice does not routinely work and always breaks down displaying no icons on Sequoia 15.8.1 - but I need to solve this permissions glitch first. 

<img width="385" height="479" alt="Image" src="https://github.com/user-attachments/assets/a3768efe-a15f-46bb-929d-791b6c7f9dd5" />

### Steps to Reproduce

This happens every day usually following a restart after a couple of hours though. 

### App Version

0.11.12

### macOS Version

15.8.1

### Additional Information

<img width="385" height="479" alt="Image" src="https://github.com/user-attachments/assets/6ca8415e-e705-4552-94e1-6d4df8d29eaf" />
```

### jordanbaird/Ice #835

- 链接：https://github.com/jordanbaird/Ice/issues/835
- 作者：[melvynm](https://github.com/melvynm)
- 状态：open
- 创建时间：2025-12-31T11:42:18Z（UTC）
- 更新时间：2026-01-29T16:46:04Z（UTC）
- 标签：Bug
- 评论数：20（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Ice stopped doing anything other than changing the Bar's appearance
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I installed Ice to hid various icons from my Menu Bar. It worked well for a month or two. Now all icons are shown and the 'Menu Bar Layout' section of the Ice Settings shows two empty bars: no icons at all are shown.

### Steps to Reproduce

Restarting the app didn't resolve the problem. 
The steps to reproduce are boring: run the app!

### App Version

0.11.12

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #836

- 链接：https://github.com/jordanbaird/Ice/issues/836
- 作者：[AdaMiez](https://github.com/AdaMiez)
- 状态：open
- 创建时间：2025-12-31T11:55:38Z（UTC）
- 更新时间：2026-01-29T11:00:28Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Ice didn't work on external monitor menu-bar on auto-hide
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Ice does not work when an external monitor is connected and a program other than Finder is in the foreground and the menu bar is set to auto-hide.

### Steps to Reproduce

Set the menu bar to auto-hide and bring another program to the foreground. Then open the menu and click to open Ice.

### App Version

0.11.12

### macOS Version

15.7.3

### Additional Information

_No response_
```

### jordanbaird/Ice #838

- 链接：https://github.com/jordanbaird/Ice/issues/838
- 作者：[macdaddy1944](https://github.com/macdaddy1944)
- 状态：open
- 创建时间：2026-01-05T19:59:15Z（UTC）
- 更新时间：2026-01-06T14:38:52Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: it seems to be frozen. I have to quit it and re-launch it to get it to function properly.
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

This happens after it has been running for a while, as I don't restart my computer unless there are problems. I then have to quit Ice and restart it; everything works fine after that.
I am running the way this Tahoe Beta.

### Steps to Reproduce

Since this happens over time, my only step would be to leave it running for a few days.

### App Version

0.11.13-dev.2

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #840

- 链接：https://github.com/jordanbaird/Ice/issues/840
- 作者：[hanzili](https://github.com/hanzili)
- 状态：open
- 创建时间：2026-01-06T04:47:25Z（UTC）
- 更新时间：2026-05-25T22:50:34Z（UTC）
- 标签：无
- 评论数：8（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
Crash when enabling Ice Bar: EXC_BREAKPOINT in window handling
```

**正文原文**

```markdown
## Bug

Ice crashes when enabling "Use Ice Bar" in Settings. The app freezes, any Sparkle dialogs become unresponsive, and clicking the menu bar icon crashes the app.

## Repro

1. Open Ice Settings → General
2. Enable "Use Ice Bar"
3. Try clicking the Ice menu bar icon → crash

## Environment

- Ice 0.11.12
- macOS 26.1 (25B78), M1 Pro MacBook

## Crash Info

Exception: `EXC_BREAKPOINT` (SIGTRAP) - Swift assertion failure
Involves: `NSStatusBarWindow` / `windowNumber`
Thread: main


Looks like a race condition when the `useIceBar` setting changes - something accesses a window in an invalid state.
```

### jordanbaird/Ice #844

- 链接：https://github.com/jordanbaird/Ice/issues/844
- 作者：[ryjohnson](https://github.com/ryjohnson)
- 状态：open
- 创建时间：2026-01-06T22:19:30Z（UTC）
- 更新时间：2026-01-06T22:19:30Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: System icons set to "Show When Active" don't remember their correct placement in the menubar
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When Control Center items (ex: time machine, AirPods, now playing) are set to show when active, once they hide and reappear, they always revert to the far right of the menu bar. I've tried setting where they should go by CMD + dragging and setting it directly in the Ice settings

### Steps to Reproduce

1. Connect AirPods to the Mac
2. Once their icon appears in the menubar, drag it to where you want it to be
3. Disconnect AirPods so they disappear from the menubar
4. Reconnect AirPods
5. They are now back in their original location, vs where they were set to be

### App Version

0.11.13-dev.2

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #845

- 链接：https://github.com/jordanbaird/Ice/issues/845
- 作者：[bgebhardt](https://github.com/bgebhardt)
- 状态：open
- 创建时间：2026-01-08T03:03:11Z（UTC）
- 更新时间：2026-01-08T03:03:11Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Hidden menubar items not selectable
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When I open the hidden menubar section I am not able to select any of the hidden menubar items to reveal their menus.

### Steps to Reproduce

1. Click the Ice Chevron
2. See the hidden menubar section
3. Click on an menubar item. Nothing shows.

If I quit ICE the menubar items work fine.

### App Version

0.11.13-dev.2a

### macOS Version

26.2 (25C56)

### Additional Information

Thanks all for trying to get Ice working. It's been a challenge since Tahoe for all the menubar managers I've tried.
```

### jordanbaird/Ice #846

- 链接：https://github.com/jordanbaird/Ice/issues/846
- 作者：[cecilia-n](https://github.com/cecilia-n)
- 状态：open
- 创建时间：2026-01-08T04:49:25Z（UTC）
- 更新时间：2026-05-25T22:27:30Z（UTC）
- 标签：Bug
- 评论数：10（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: MenuBar in Settings Is Empty White Space
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have updated my Mac Software to and have updated Ice, but see a white blocks where the Menu bar Layout should be. I have restarted and re-opened the app many times to find the issue. Clicking on the ice icon in the top menu bar makes it disappear.

### Steps to Reproduce

1. Go to Settings
2. Go to Menu Bar Layout

### App Version

0.11.12

### macOS Version

Macbook M4 Pro, Tahoe 26.2

### Additional Information

<img width="896" height="596" alt="Image" src="https://github.com/user-attachments/assets/64ee6bfb-6ebc-4c35-b6ee-3eaae0f2d6f2" />
```

### jordanbaird/Ice #852

- 链接：https://github.com/jordanbaird/Ice/issues/852
- 作者：[lcx-0504](https://github.com/lcx-0504)
- 状态：open
- 创建时间：2026-01-17T14:18:23Z（UTC）
- 更新时间：2026-01-17T18:44:14Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Ice bar cannot hide recording indicator in 15.7.3
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I know due to macOS limitation in Sequoia 15, the system will show this indicator when using ice bar. In 15.7.2, I can move this indicator into hidden area, show it would not appear unless I open ice bar. How ever in 15.7.3, it seems ice cannot detect this indicator any more, I cannot see this indicator in icon manager in ice main window, and when I use cmd+mouse to move this indicator into hidden area, it not works anymore.
Could you please fix this? Thank you very much!

<img width="806" height="120" alt="Image" src="https://github.com/user-attachments/assets/2a057f5e-4429-4671-bac5-83ba40bd59f6" />

<img width="1340" height="820" alt="Image" src="https://github.com/user-attachments/assets/7b1f0ff3-beeb-4aa7-8050-62003fc34546" />

### Steps to Reproduce

1. Use ice bar or other app to activate this system indicator
2. look at ice main window, this indicator did not appear in ice and cannot be managed
3. If use cmd+mouse to move this indicator to hidden area on menu bar, it will immediately appears again and cannot be hidden.

In previous version(15.7.2), I can see this indicator in ice and move it to hidden area. I don't know why it cannot works, and whether it should be like this. I would really appretiate if anyone can fix this.

<img width="1496" height="912" alt="Image" src="https://github.com/user-attachments/assets/cd05e384-b6fb-4947-afb1-977375fcf140" />

### App Version

0.11.12

### macOS Version

15.7.3

### Additional Information

_No response_
```

### jordanbaird/Ice #853

- 链接：https://github.com/jordanbaird/Ice/issues/853
- 作者：[pombzilla](https://github.com/pombzilla)
- 状态：open
- 创建时间：2026-01-17T19:06:19Z（UTC）
- 更新时间：2026-01-17T19:06:19Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Cursor IDE icon position is not saved well
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

This is the only app I've found that is not working with ICE as expeted.

### Steps to Reproduce

1. run ice, hide some apps
2. run cursor, IDE menu bar icon will be on hidden icons
3. configure in ice to show the icon
4. close cursor, reopen cursor
5. the icon of cursor is again hidden, no relocation was saved

### App Version

0.11.12

### macOS Version

15.6.1

### Additional Information

_No response_
```

### jordanbaird/Ice #854

- 链接：https://github.com/jordanbaird/Ice/issues/854
- 作者：[JackMajor](https://github.com/JackMajor)
- 状态：open
- 创建时间：2026-01-19T15:36:33Z（UTC）
- 更新时间：2026-03-20T14:04:08Z（UTC）
- 标签：Bug
- 评论数：4（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Icons are duplicated in the menu bar
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have duplicating icons in the menu bar, and I also have Pika that says it should be enabled in the menu bar, but it is not showing up.

<img width="271" height="51" alt="Image" src="https://github.com/user-attachments/assets/1dbf8d87-1841-4ac5-a478-14eb22b053da" />

I tried restarting, but it still shows the same ones.

### Steps to Reproduce

1. Disable an app that shows the menu bar icon, then re-enable it. It didn't reappear.
2. Tried restarting
3. menu bar should re-appear, but now it shows duplicated icons for some of them.
4. When you click one of the duplicated icons, another app that was mistakenly replaced with its icon should reappear, and then hop out of the hidden ICE bar.
5. When you go to the ICE settings again, they still show as the duplicated icons

### App Version

0.11.13-dev.2

### macOS Version

macOS 26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #855

- 链接：https://github.com/jordanbaird/Ice/issues/855
- 作者：[jmsautter-jpg](https://github.com/jmsautter-jpg)
- 状态：open
- 创建时间：2026-01-19T16:02:20Z（UTC）
- 更新时间：2026-01-21T18:53:02Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Ice keeps crashing after updating to OS26.2
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

ice has stopped functioning, it lodas, when i go to click it the program crashes.

### Steps to Reproduce

go to ice too menu bar
click on it
it crashes

### App Version

11.12

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #857

- 链接：https://github.com/jordanbaird/Ice/issues/857
- 作者：[emaba](https://github.com/emaba)
- 状态：open
- 创建时间：2026-01-21T00:00:31Z（UTC）
- 更新时间：2026-02-23T07:58:30Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: Multiple identical app icons disappear when one is restored from hidden state (e.g. OneDrive)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

**Description**
When multiple menu bar icons belong to the same application (for example OneDrive, with multiple accounts logged in), Ice does not handle interaction correctly if all of them are hidden.

In my case, I have three OneDrive menu bar icons, one per account. If I hide all three using Ice, and later try to interact with them, the following happens:

- I click on one of the hidden OneDrive icons
- That specific icon reappears in the menu bar as expected
- However, the other hidden OneDrive icons disappear entirely from the hidden icons list
- At this point, it becomes impossible to interact with the remaining OneDrive instances unless Ice is reset or the app is restarted

This seems to happen only when multiple identical icons from the same application are present and all of them are hidden.

**Expected behavior**
When multiple icons from the same app are hidden:

- Restoring or interacting with one icon should not affect the visibility or availability of the others
- All hidden icons should remain accessible independently

**Actual behavior**
- Restoring one icon causes the other hidden icons of the same app to disappear
- The missing icons cannot be interacted with anymore

### Steps to Reproduce

1. Run an app that creates multiple identical menu bar icons (e.g. OneDrive with multiple accounts)
2. Hide all icons from that app using Ice
3. Click on one hidden icon to restore it
4. Observe that the other hidden icons disappear and are no longer accessible

### App Version

0.11.13-dev.2c-unofficial (but it is the same with latest official)

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #858

- 链接：https://github.com/jordanbaird/Ice/issues/858
- 作者：[chaggui](https://github.com/chaggui)
- 状态：open
- 创建时间：2026-01-23T20:38:38Z（UTC）
- 更新时间：2026-01-30T20:36:35Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: second screen layout wrong display
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Once ICE active with auto mask menu bar icons, there is a wrong display on my second screen.

This overlay display issue seems to be only when there is a full screen app on the built-in screen.

<img width="1920" height="1080" alt="Image" src="https://github.com/user-attachments/assets/06995f1f-b47f-4b90-a7c7-89a6ee8f57d6" />

MacPro M4 2024
Tahoe 26.2

### Steps to Reproduce

Launch ICE
Push full screen on built-in screen
Back to second screen

### App Version

0.11.12

### macOS Version

26.2

### Additional Information

_No response_
```

### jordanbaird/Ice #860

- 链接：https://github.com/jordanbaird/Ice/issues/860
- 作者：[chosa91](https://github.com/chosa91)
- 状态：open
- 创建时间：2026-01-26T12:21:46Z（UTC）
- 更新时间：2026-01-26T12:21:46Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Option to re-add the menu bar icon, after manual removal
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

It'd be nice to restore/reset/re-add the menu bar icon, once somebody (accidentally or intentionally) removed it.

### Additional Information

_No response_
```

### jordanbaird/Ice #861

- 链接：https://github.com/jordanbaird/Ice/issues/861
- 作者：[gerard-pt](https://github.com/gerard-pt)
- 状态：open
- 创建时间：2026-01-26T18:51:01Z（UTC）
- 更新时间：2026-01-29T10:18:21Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: unable to move icons to hidden section
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Unable to hide icons anymore due to a timeout error from the app, while it does not provide information about what is timing out, why and whether the user could do anything on its own to fix it; I reset permissions via `tccutil reset All com.jordanbaird.Ice` in case it was related to that, but that didn't help

### Steps to Reproduce

1. Open Ice Settings
2. Go to "Menu Bar Layout" tab
3. Try to move any one icon from "Visible Section" to "Hidden Section"
4. An error pops up. The UI seems to indicate as if the icon was indeed moved, but if you either go to any other tab and come back to "Menu Bar Layout" the icon you attempted to move to hidden is still visible. Happens for any and all icons not already hidden.


### App Version

0.11.2

### macOS Version

15.7.3

### Additional Information

<img width="260" height="234" alt="Image" src="https://github.com/user-attachments/assets/891ac2b4-ed47-4317-9dbc-8d51bcb34d8c" />
```

### jordanbaird/Ice #862

- 链接：https://github.com/jordanbaird/Ice/issues/862
- 作者：[milesmode](https://github.com/milesmode)
- 状态：open
- 创建时间：2026-01-26T23:42:25Z（UTC）
- 更新时间：2026-01-28T12:38:36Z（UTC）
- 标签：Feature
- 评论数：9（本清单不采集评论正文）
- 主分类：权限、更新、安装与分发

**标题原文**

```text
[Feature Request]: submit the app to the homebrew
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

create a cask and submit it to homebrew 

### Additional Information

_No response_
```

### jordanbaird/Ice #863

- 链接：https://github.com/jordanbaird/Ice/issues/863
- 作者：[sxin0](https://github.com/sxin0)
- 状态：open
- 创建时间：2026-01-27T02:26:04Z（UTC）
- 更新时间：2026-01-27T02:26:04Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Black square appears in bottom-right corner of primary display when secondary display has fullscreen window
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When the external display is set as the primary display, a black square artifact appears in the bottom-right corner of the primary display if the secondary display (original main display) has a fullscreen window running.

### Steps to Reproduce

1. Set external display as primary display in System Settings
2. Open any application on the secondary display
3. Switch the application to fullscreen mode on the secondary display
4. Observe the bottom-right corner area of the primary display

### App Version

0.11.12

### macOS Version

Sequoia 15.7.3

### Additional Information

## Expected Behavior
The primary display should not show any black square or visual artifacts in the bottom-right corner.

## Actual Behavior
A black square appears in the bottom-right corner of the primary display.

## Environment
- **App Version:** 0.11.12
- **macOS Version:** Sequoia 15.7.3 (Darwin 24.6.0)

## Screenshots
<img width="1088" height="166" alt="Image" src="https://github.com/user-attachments/assets/60a9baab-58cd-47a4-8b8e-81d5f8b1aeb9" />

<img width="275" height="190" alt="Image" src="https://github.com/user-attachments/assets/bf2dcd11-bd03-4c0b-8383-9dcd36d12855" />

```

### jordanbaird/Ice #865

- 链接：https://github.com/jordanbaird/Ice/issues/865
- 作者：[kristiankruse](https://github.com/kristiankruse)
- 状态：open
- 创建时间：2026-01-28T02:49:04Z（UTC）
- 更新时间：2026-01-28T16:19:59Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: macOS 26.3 beta 3 prevents Ice from expanding
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The lates beta makes Ice break by not allowing for expanding when clicking the icon (eclipse in my case).

### Steps to Reproduce

1. Start ice.app
2. Click eclipse in menubar
3. Nothing expands.

### App Version

0.11.13-dev.2

### macOS Version

26.3b3

### Additional Information

![Image](https://github.com/user-attachments/assets/8e83fd0e-1ebf-49ec-ac54-8aae91c2d3ac)
```

### jordanbaird/Ice #867

- 链接：https://github.com/jordanbaird/Ice/issues/867
- 作者：[xbeta](https://github.com/xbeta)
- 状态：open
- 创建时间：2026-01-28T23:20:57Z（UTC）
- 更新时间：2026-05-25T22:50:34Z（UTC）
- 标签：Bug
- 评论数：15（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Ice crash on macOS 26.2 (25C56)
```

**正文原文**

````markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

```
-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Ice [20193]
Path:                /Applications/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Default
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [5322]
User ID:             502

Date/Time:           2026-01-27 12:45:43.6234 -0800
Launch Time:         2026-01-23 13:39:23.3263 -0800
Hardware Model:      Mac16,7
OS Version:          macOS 26.2 (25C56)
Release Type:        User

Crash Reporter Key:  C01D697C-FBC2-876B-24F6-AB7897237F2C
Incident Identifier: 9A57E141-5FE4-4243-99B5-1A72C0F6985C

Sleep/Wake UUID:       FECA4485-CEF9-439C-B27F-4ADEE2CA4C72

Time Awake Since Boot: 1000000 seconds
Time Since Wake:       263670 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x00000001021b8934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [20193]


Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   Ice                           	       0x1021b8934 0x1021ac000 + 51508
1   Ice                           	       0x10226eb18 0x1021ac000 + 797464
2   Ice                           	       0x10226eaa0 0x1021ac000 + 797344
3   Ice                           	       0x10226d5e0 0x1021ac000 + 792032
4   Ice                           	       0x10222c7e1 0x1021ac000 + 526305
5   Ice                           	       0x1021cc151 0x1021ac000 + 131409
6   Ice                           	       0x1021cffb9 0x1021ac000 + 147385
7   Ice                           	       0x1021be319 0x1021ac000 + 74521
8   libswift_Concurrency.dylib    	       0x296b272fd completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x19b1f6c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x19b209028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x19b1ff98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x19b1f6fb4 mach_msg + 24
4   CoreFoundation                	       0x19b2d8ba0 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x19b2d74f8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x19b391e34 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x19f77aa34 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x19b239c08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x19b234ba8 thread_start + 8

Thread 2:

Thread 3:

Thread 4:

Thread 5:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x00000008c464ea80   x1: 0x20000002081ab2bf   x2: 0x00000002081ab2b8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x0000000216975a51  x10: 0x00000008dacd68e9  x11: 0x00000000000003ff
   x12: 0x00000000000000e5  x13: 0x00000008c4408e40  x14: 0x20000002081ab2bf  x15: 0x00000002081ab2b8
   x16: 0x20000002081ab2bf  x17: 0x000000000000003e  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x00000008c464ea80  x21: 0x00000008c1eaca00  x22: 0x00000008c44eb640  x23: 0x0000000000000002
   x24: 0x0000000102355000  x25: 0x00000008c29a0900  x26: 0x00000008c414c510  x27: 0x00000008c1855940
   x28: 0xffffffff76ffffff   fp: 0x000000016dc50e40   lr: 0x00000001021b8928
    sp: 0x000000016dc50e20   pc: 0x00000001021b8934 cpsr: 0x60000000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x1021ac000 -        0x10233bfff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/Ice.app/Contents/MacOS/Ice
       0x102494000 -        0x1024d7fff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x10295c000 -        0x102967fff libobjc-trampolines.dylib (*) <d4baeab8-b553-3779-a0ff-d8848e7a22df> /usr/lib/libobjc-trampolines.dylib
       0x116cb4000 -        0x1174dffff com.apple.AGXMetalG16X (342.3) <f3e5018e-3b97-3b77-837f-18455b13e98f> /System/Library/Extensions/AGXMetalG16X.bundle/Contents/MacOS/AGXMetalG16X
       0x296aba000 -        0x296b436ff libswift_Concurrency.dylib (*) <2cd4d4d2-15a3-3057-b506-6e79bd1d6428> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x19b1f6000 -        0x19b23249f libsystem_kernel.dylib (*) <548c45c8-9733-3f0d-8ef4-c06df1df2ad0> /usr/lib/system/libsystem_kernel.dylib
       0x19b279000 -        0x19b7c1c3f com.apple.CoreFoundation (6.9) <649000a2-3eb4-3cf5-970a-d3cb37b5780c> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x19f6cb000 -        0x1a0dfa27f com.apple.AppKit (6.9) <4e909aec-68bc-3fc9-a87a-de928e1e36e1> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x19b233000 -        0x19b23fabb libsystem_pthread.dylib (*) <527c4ba0-91a5-378b-b3e2-d38269ca5a66> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=179.8M written=1809K(1%) resident=593K(0%) swapped_out=1216K(1%) unallocated=178.0M(99%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               128K        1 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                           176K       10 
ColorSync                           16K        1 
CoreAnimation                     2272K       89 
CoreGraphics                        64K        4 
CoreUI image data                 1952K       21 
Foundation                          16K        1 
Kernel Alloc Once                  208K        2 
MALLOC                           161.6M       35 
MALLOC guard page                 4032K        4 
SQLite page cache                  128K        1 
STACK GUARD                       56.1M        6 
Stack                             10.6M        6 
VM_ALLOCATE                       3232K       11 
__AUTH                            5891K      648 
__AUTH_CONST                      88.6M     1030 
__CTF                               824        1 
__DATA                            35.6M      981 
__DATA_CONST                      32.9M     1039 
__DATA_DIRTY                      8784K      890 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       592.4M        5 
__OBJC_RO                         78.4M        1 
__OBJC_RW                         2570K        1 
__TEXT                             1.2G     1061 
__TPRO_CONST                       128K        2 
mapped file                      276.2M       44 
page table in kernel               593K        1 
shared memory                     2400K       14 
===========                     =======  ======= 
TOTAL                              2.5G     5914 


-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2026-01-27 12:45:47.00 -0800","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":0,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.2 (25C56)","roots_installed":0,"name":"Ice","incident_id":"9A57E141-5FE4-4243-99B5-1A72C0F6985C"}
{
  "uptime" : 1000000,
  "procRole" : "Default",
  "version" : 2,
  "userID" : 502,
  "deployVersion" : 210,
  "modelCode" : "Mac16,7",
  "coalitionID" : 5322,
  "osVersion" : {
    "train" : "macOS 26.2",
    "build" : "25C56",
    "releaseType" : "User"
  },
  "captureTime" : "2026-01-27 12:45:43.6234 -0800",
  "codeSigningMonitor" : 2,
  "incident" : "9A57E141-5FE4-4243-99B5-1A72C0F6985C",
  "pid" : 20193,
  "translated" : false,
  "cpuType" : "ARM-64",
  "procLaunch" : "2026-01-23 13:39:23.3263 -0800",
  "procStartAbsTime" : 18194935767300,
  "procExitAbsTime" : 24795634028228,
  "procName" : "Ice",
  "procPath" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"7AA69CB5-F66F-5334-B72A-A11E82491029","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "C01D697C-FBC2-876B-24F6-AB7897237F2C",
  "appleIntelligenceStatus" : {"state":"unavailable","reasons":["notOptedIn","siriAssetIsNotReady","assetIsNotReady"]},
  "developerMode" : 1,
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570503953,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"6AwAsAGpQPngAxSqvucElPMDAKrgAxSqxOcElLMB+Ldo\/mDTiAAAtA==","atPC":"IAAg1BMAgNIoAIBS6DMAOQgdABJgggiq\/XtCqfRPQan\/wwCRwANf1g=="},
  "bootSessionUUID" : "E40646C1-0068-4BE8-AB19-D65F94F5E297",
  "wakeTime" : 263670,
  "sleepWakeUUID" : "FECA4485-CEF9-439C-B27F-4ADEE2CA4C72",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000001, 0x00000001021b8934","rawCodes":[1,4330326324],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":20193},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":35843014,"threadState":{"x":[{"value":37654686336},{"value":2305843017939595967,"symbolLocation":2305843009213693959,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8725902008,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":1},{"value":68719476739},{"value":7},{"value":68719476739},{"value":7},{"value":1},{"value":8968952401,"objc-selector":"windowNumber"},{"value":38030633193},{"value":1023},{"value":229},{"value":37652303424},{"value":2305843017939595967,"symbolLocation":2305843009213693959,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8725902008,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":2305843017939595967,"symbolLocation":2305843009213693959,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":62},{"value":0},{"value":4294967296},{"value":37654686336},{"value":37613128192},{"value":37653231168},{"value":2},{"value":4332015616},{"value":37624613120},{"value":37649433872},{"value":37606480192},{"value":18446744071411073023}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4330326312},"cpsr":{"value":1610612736},"fp":{"value":6136598080},"sp":{"value":6136598048},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4330326324,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":51508,"imageIndex":0},{"imageOffset":797464,"imageIndex":0},{"imageOffset":797344,"imageIndex":0},{"imageOffset":792032,"imageIndex":0},{"imageOffset":526305,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":147385,"imageIndex":0},{"imageOffset":74521,"imageIndex":0},{"imageOffset":447229,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":4}]},{"id":35843036,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":31235},{"value":0},{"value":18446744073709551569},{"value":8748372128},{"value":0},{"value":4294967295},{"value":2},{"value":134153303490560},{"value":0},{"value":134153303490560},{"value":6139453576},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6897569832},"cpsr":{"value":0},"fp":{"value":6139453424},"sp":{"value":6139453344},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6897495092},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":6},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":6},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":6},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":6},{"imageOffset":392096,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":7},{"imageOffset":386296,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":7},{"imageOffset":1150516,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":7},{"imageOffset":719412,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":8},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":9},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":9}]},{"id":49318721,"frames":[],"threadState":{"x":[{"value":6137163776},{"value":83639},{"value":6136627200},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6137163776},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6897748884},"far":{"value":0}}},{"id":49322657,"frames":[],"threadState":{"x":[{"value":6140030976},{"value":82291},{"value":6139494400},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6140030976},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6897748884},"far":{"value":0}}},{"id":49327946,"frames":[],"threadState":{"x":[{"value":6138310656},{"value":69315},{"value":6137774080},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6138310656},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6897748884},"far":{"value":0}}},{"id":49331074,"frames":[],"threadState":{"x":[{"value":6137737216},{"value":0},{"value":6137200640},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6137737216},"esr":{"value":0},"pc":{"value":6897748884},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4330274816,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4333322240,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/Applications\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4338335744,
    "size" : 49152,
    "uuid" : "d4baeab8-b553-3779-a0ff-d8848e7a22df",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4677386240,
    "CFBundleShortVersionString" : "342.3",
    "CFBundleIdentifier" : "com.apple.AGXMetalG16X",
    "size" : 8568832,
    "uuid" : "f3e5018e-3b97-3b77-837f-18455b13e98f",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG16X.bundle\/Contents\/MacOS\/AGXMetalG16X",
    "name" : "AGXMetalG16X",
    "CFBundleVersion" : "342.3"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 11117764608,
    "size" : 562944,
    "uuid" : "2cd4d4d2-15a3-3057-b506-6e79bd1d6428",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6897491968,
    "size" : 246944,
    "uuid" : "548c45c8-9733-3f0d-8ef4-c06df1df2ad0",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6898028544,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5540928,
    "uuid" : "649000a2-3eb4-3cf5-970a-d3cb37b5780c",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4201"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6969667584,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24310400,
    "uuid" : "4e909aec-68bc-3fc9-a87a-de928e1e36e1",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.30.107"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6897741824,
    "size" : 51900,
    "uuid" : "527c4ba0-91a5-378b-b3e2-d38269ca5a66",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6892683264,
  "size" : 5653544960,
  "uuid" : "acb998b6-263c-3634-b0a8-ae8270a116c2"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=179.8M written=1809K(1%) resident=593K(0%) swapped_out=1216K(1%) unallocated=178.0M(99%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               128K        1 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                           176K       10 \nColorSync                           16K        1 \nCoreAnimation                     2272K       89 \nCoreGraphics                        64K        4 \nCoreUI image data                 1952K       21 \nFoundation                          16K        1 \nKernel Alloc Once                  208K        2 \nMALLOC                           161.6M       35 \nMALLOC guard page                 4032K        4 \nSQLite page cache                  128K        1 \nSTACK GUARD                       56.1M        6 \nStack                             10.6M        6 \nVM_ALLOCATE                       3232K       11 \n__AUTH                            5891K      648 \n__AUTH_CONST                      88.6M     1030 \n__CTF                               824        1 \n__DATA                            35.6M      981 \n__DATA_CONST                      32.9M     1039 \n__DATA_DIRTY                      8784K      890 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       592.4M        5 \n__OBJC_RO                         78.4M        1 \n__OBJC_RW                         2570K        1 \n__TEXT                             1.2G     1061 \n__TPRO_CONST                       128K        2 \nmapped file                      276.2M       44 \npage table in kernel               593K        1 \nshared memory                     2400K       14 \n===========                     =======  ======= \nTOTAL                              2.5G     5914 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "cf1da5e425f0c45800939a4fdba26c07945beb2b",
  "bug_type" : "309",
  "roots_installed" : 0,
  "trmStatus" : 1,
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "67648e5334a82511f4acf879",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000008
    },
    {
      "rolloutId" : "642da32dea3b2418c750f848",
      "factorPackIds" : [
        "66d8b2f77cd4b62688efd2cf"
      ],
      "deploymentId" : 240000011
    }
  ],
  "experiments" : [

  ]
}
}


```

### Steps to Reproduce

1. Upgraded to macOS 26.2
2. Reboot macOS
3. Check the logs of Ice

### App Version

0.11.12

### macOS Version

26.2

### Additional Information

_No response_
````

### jordanbaird/Ice #871

- 链接：https://github.com/jordanbaird/Ice/issues/871
- 作者：[kevinlong206](https://github.com/kevinlong206)
- 状态：open
- 创建时间：2026-02-01T00:08:59Z（UTC）
- 更新时间：2026-04-14T18:58:09Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Unable to click on secondary menu bar icons, the bar disappears
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Brand new user here,

I often have too many menu bar icons and so I was looking for a solution for a "drop down" menu or secondary menu bar.

When I use Ice and click on the ... icon, a secondary menu bar appears below (good), but when I move the mouse to try to click on one of these icons, it disappears immediately. I have restarted the app and my computer already to no avail.



### Steps to Reproduce

Video: https://github.com/user-attachments/assets/fd64ce7a-3322-4584-9bc1-96b6debe6b36

### App Version

0.13.11-dev2

### macOS Version

26.2 Tahoe

### Additional Information

https://github.com/user-attachments/assets/fd64ce7a-3322-4584-9bc1-96b6debe6b36
```

### jordanbaird/Ice #872

- 链接：https://github.com/jordanbaird/Ice/issues/872
- 作者：[tigger-developer](https://github.com/tigger-developer)
- 状态：open
- 创建时间：2026-02-02T17:30:45Z（UTC）
- 更新时间：2026-05-25T22:27:33Z（UTC）
- 标签：Bug
- 评论数：8（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Unstable, Layout menu area broken
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I love this app so much, but it crashes constantly to the point of being of no use any more.
Looking at the code commits, it seems the project is no longer being maintained, or is it?

Here is my "Layout" section, as you can see, the icons are not even visible for me to configure anything here:

<img width="866" height="773" alt="Image" src="https://github.com/user-attachments/assets/cf000a8b-d1f6-4889-bf1b-86c6f981e594" />

If there is some setting or tweak that I could toggle to improve stability that anyone knows about, I'd be super keen to hear! thanks

### Steps to Reproduce

Open Ice

### App Version

0.11.12

### macOS Version

tahoe 26.1

### Additional Information

_No response_
```

### jordanbaird/Ice #877

- 链接：https://github.com/jordanbaird/Ice/issues/877
- 作者：[phazei](https://github.com/phazei)
- 状态：open
- 创建时间：2026-02-10T23:56:57Z（UTC）
- 更新时间：2026-05-29T18:10:15Z（UTC）
- 标签：Bug
- 评论数：11（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Bug]: PROJECT DEAD, no updates in 1.5 years, crashes all the time.
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

OS: Tahoe

App asks if want automatic updates: can't click anything, can't close, just stuck.  Need to use keyboard to navigate to close it

Use special second ice bar: app just crashes

Some specific and colored tray icons:  Docker, AltTab, just don't show at all with ice, which was the entire point this was solving.

Project should be marked deprecated to not waste peoples time.

### Steps to Reproduce

1) Use the app
2) Fail

### App Version

0.11.12

### macOS Version

Tahoe

### Additional Information

_No response_
```

### jordanbaird/Ice #878

- 链接：https://github.com/jordanbaird/Ice/issues/878
- 作者：[ghl5261](https://github.com/ghl5261)
- 状态：open
- 创建时间：2026-02-12T21:53:20Z（UTC）
- 更新时间：2026-02-12T21:53:20Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu bar items are not appearing
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Any new app that has a menu bar item is not appearing in my menu bar, nowhere to be found in the visible, hidden, or always hidden sections.

There are four items in my hidden section:

<img width="749" height="34" alt="Image" src="https://github.com/user-attachments/assets/422ecefc-69e3-4365-9480-3e3b5ae34dcc" />

And my always-hidden section is enabled.

<img width="906" height="619" alt="Image" src="https://github.com/user-attachments/assets/6235811c-35ff-4661-9bf6-e21e5a8a8f2c" />

But the rest of my menu bar items do not appear in any of the sections.

<img width="896" height="623" alt="Image" src="https://github.com/user-attachments/assets/849475d0-2291-48cc-970c-bacd41d603b6" />

I can confirm in System Preferences that the menu bar items should be there.

<img width="485" height="795" alt="Image" src="https://github.com/user-attachments/assets/7f3ee25a-ceea-4e48-a0e0-01e6e455b5f3" />

When I search for hidden items, I can see these items under "Hidden". Notice the four items that are there properly. There is this weird symbol, and below that are the other menu bar items that should be there.

<img width="608" height="319" alt="Image" src="https://github.com/user-attachments/assets/6b7bca79-568e-4b6b-b253-7f80d82d0f29" />
<img width="601" height="315" alt="Image" src="https://github.com/user-attachments/assets/14bc3d22-64e7-4659-a42a-d0c5e322b87b" />

Nothing opens when I click on these items through the search.

I tried quitting and uninstalling Ice, but the problem persists. No luck when rebooting the computer either. To be clear, even when I quit or uninstall Ice entirely, the invisible menu bar items remain invisible.

### Steps to Reproduce

Not sure, as this behavior persists no matter what I do (close Ice and reopen, uninstall Ice and reinstall, reboot the Mac).

### App Version

0.11.13-dev.2

### macOS Version

26.3

### Additional Information

_No response_
```

### jordanbaird/Ice #879

- 链接：https://github.com/jordanbaird/Ice/issues/879
- 作者：[nickkats200](https://github.com/nickkats200)
- 状态：open
- 创建时间：2026-02-14T20:05:55Z（UTC）
- 更新时间：2026-02-21T00:25:10Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: "hide app menus when showing menu bar items" feature not working
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The current app's menus do not disappear when opening hidden menu bar items, even when ice app is visible in dock.

### Steps to Reproduce

1. enable "hide app menus when showing menu bar items" setting
2. hover on menu bar or click ice icon in menu bar (open hidden portion of the menu bar)
3. expected behavior: current (foreground) app's menus should disappear to allow for hidden menu bar apps to fill screen and not push into current app's menu items. this does not currently occur as expected.

### App Version

0.11.13-dev.2

### macOS Version

Tahoe 26.3

### Additional Information

_No response_
```

### jordanbaird/Ice #880

- 链接：https://github.com/jordanbaird/Ice/issues/880
- 作者：[Qingzi0428](https://github.com/Qingzi0428)
- 状态：open
- 创建时间：2026-02-16T07:10:54Z（UTC）
- 更新时间：2026-02-16T07:10:54Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: not be able to use it on imac today
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Keep showing bug report and ask me to reopen.

### Steps to Reproduce

-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Ice [1752]
Path:                /private/var/folders/*/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [1610]
User ID:             501

Date/Time:           2026-02-16 15:07:37.5261 +0800
Launch Time:         2026-02-16 15:07:18.8415 +0800
Hardware Model:      Mac16,3
OS Version:          macOS 26.2 (25C56)
Release Type:        User

Crash Reporter Key:  90A35642-E76C-8B15-07B3-7EC64E155A66
Incident Identifier: 0D7C0706-C579-4C2E-BC8A-0A124576C4C0

Time Awake Since Boot: 780 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x0000000100d74934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [1752]


Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   Ice                           	       0x100d74934 0x100d68000 + 51508
1   Ice                           	       0x100e2ab18 0x100d68000 + 797464
2   Ice                           	       0x100e2aaa0 0x100d68000 + 797344
3   Ice                           	       0x100e295e0 0x100d68000 + 792032
4   Ice                           	       0x100de87e1 0x100d68000 + 526305
5   Ice                           	       0x100d88151 0x100d68000 + 131409
6   Ice                           	       0x100d8bfb9 0x100d68000 + 147385
7   Ice                           	       0x100d7a319 0x100d68000 + 74521
8   libswift_Concurrency.dylib    	       0x2931932fd completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:

Thread 2:

Thread 3:

Thread 4:

Thread 5:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x197862c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x197875028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x19786b98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x197862fb4 mach_msg + 24
4   CoreFoundation                	       0x197944ba0 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x1979434f8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x1979fde34 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x19bde6a34 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x1978a5c08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x1978a0ba8 thread_start + 8

Thread 6:

Thread 7:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x00000007022d7c00   x1: 0x21000002048172bf   x2: 0x00000002048172b8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x0000000212fe1a51  x10: 0x00000007170e28e9  x11: 0x00000000000003ff
   x12: 0x0000000000000265  x13: 0x0000000701716640  x14: 0x21000002048172bf  x15: 0x00000002048172b8
   x16: 0x21000002048172bf  x17: 0x0000000000000040  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x00000007022d7c00  x21: 0x0000000701434c80  x22: 0x00000007005c1480  x23: 0x0000000000000002
   x24: 0x0000000100f11000  x25: 0x0000000701d2c300  x26: 0x00000007023a23d0  x27: 0x0000000701e10640
   x28: 0xffffffff76ffffff   fp: 0x000000016f093860   lr: 0x0000000100d74928
    sp: 0x000000016f093840   pc: 0x0000000100d74934 cpsr: 0x60000000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x100d68000 -        0x100ef7fff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /private/var/folders/*/Ice.app/Contents/MacOS/Ice
       0x101050000 -        0x101093fff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /private/var/folders/*/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x101124000 -        0x10112ffff libobjc-trampolines.dylib (*) <d4baeab8-b553-3779-a0ff-d8848e7a22df> /usr/lib/libobjc-trampolines.dylib
       0x1154d8000 -        0x115d03fff com.apple.AGXMetalG16G-B0 (342.3) <9b7b6d4d-007d-3c9a-9764-8f0253020490> /System/Library/Extensions/AGXMetalG16G_B0.bundle/Contents/MacOS/AGXMetalG16G_B0
       0x293126000 -        0x2931af6ff libswift_Concurrency.dylib (*) <2cd4d4d2-15a3-3057-b506-6e79bd1d6428> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x197862000 -        0x19789e49f libsystem_kernel.dylib (*) <548c45c8-9733-3f0d-8ef4-c06df1df2ad0> /usr/lib/system/libsystem_kernel.dylib
       0x1978e5000 -        0x197e2dc3f com.apple.CoreFoundation (6.9) <649000a2-3eb4-3cf5-970a-d3cb37b5780c> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x19bd37000 -        0x19d46627f com.apple.AppKit (6.9) <4e909aec-68bc-3fc9-a87a-de928e1e36e1> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x19789f000 -        0x1978ababb libsystem_pthread.dylib (*) <527c4ba0-91a5-378b-b3e2-d38269ca5a66> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=159.7M written=641K(0%) resident=641K(0%) swapped_out=0K(0%) unallocated=159.1M(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               128K        1 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                            96K        5 
ColorSync                           16K        1 
CoreAnimation                     4448K       61 
CoreGraphics                        64K        4 
CoreServices                       624K        2 
CoreUI image data                 2624K       20 
Foundation                          16K        1 
Kernel Alloc Once                   32K        1 
MALLOC                           137.4M       29 
MALLOC guard page                 3856K        4 
STACK GUARD                       56.1M        8 
Stack                             11.7M        8 
VM_ALLOCATE                       3296K       15 
__AUTH                            5863K      644 
__AUTH_CONST                      88.4M     1026 
__CTF                               824        1 
__DATA                            35.4M      977 
__DATA_CONST                      32.9M     1035 
__DATA_DIRTY                      8729K      887 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       592.4M        5 
__OBJC_RO                         78.4M        1 
__OBJC_RW                         2570K        1 
__TEXT                             1.2G     1058 
__TPRO_CONST                       128K        2 
mapped file                      355.7M       51 
page table in kernel               641K        1 
shared memory                     2400K       14 
===========                     =======  ======= 
TOTAL                              2.6G     5867 


-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2026-02-16 15:07:37.00 +0800","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.2 (25C56)","roots_installed":0,"name":"Ice","incident_id":"0D7C0706-C579-4C2E-BC8A-0A124576C4C0"}
{
  "uptime" : 780,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac16,3",
  "coalitionID" : 1610,
  "osVersion" : {
    "train" : "macOS 26.2",
    "build" : "25C56",
    "releaseType" : "User"
  },
  "captureTime" : "2026-02-16 15:07:37.5261 +0800",
  "codeSigningMonitor" : 2,
  "incident" : "0D7C0706-C579-4C2E-BC8A-0A124576C4C0",
  "pid" : 1752,
  "translated" : false,
  "cpuType" : "ARM-64",
  "procLaunch" : "2026-02-16 15:07:18.8415 +0800",
  "procStartAbsTime" : 18497771511,
  "procExitAbsTime" : 18946177233,
  "procName" : "Ice",
  "procPath" : "\/private\/var\/folders\/*\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"074E012A-3C75-55AA-8CCD-9337F2AA4F63","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "90A35642-E76C-8B15-07B3-7EC64E155A66",
  "appleIntelligenceStatus" : {"reasons":["countryBillingIneligible","countryLocationIneligible","regionIneligible"],"state":"unavailable"},
  "developerMode" : 1,
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570503953,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"6AwAsAGpQPngAxSqvucElPMDAKrgAxSqxOcElLMB+Ldo\/mDTiAAAtA==","atPC":"IAAg1BMAgNIoAIBS6DMAOQgdABJgggiq\/XtCqfRPQan\/wwCRwANf1g=="},
  "bootSessionUUID" : "082228BC-2E91-4AF2-9B5A-008055DE8012",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000001, 0x0000000100d74934","rawCodes":[1,4309076276],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":1752},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":37037,"threadState":{"x":[{"value":30101306368},{"value":2377900611917148863,"symbolLocation":2377900603251621895,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8665526968,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":1},{"value":68719476739},{"value":7},{"value":68719476739},{"value":7},{"value":1},{"value":8908577361,"objc-selector":"windowNumber"},{"value":30451575017},{"value":1023},{"value":613},{"value":30088980032},{"value":2377900611917148863,"symbolLocation":2377900603251621895,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8665526968,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":2377900611917148863,"symbolLocation":2377900603251621895,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":64},{"value":0},{"value":4294967296},{"value":30101306368},{"value":30085958784},{"value":30070805632},{"value":2},{"value":4310765568},{"value":30095360768},{"value":30102135760},{"value":30096295488},{"value":18446744071411073023}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4309076264},"cpsr":{"value":1610612736},"fp":{"value":6157842528},"sp":{"value":6157842496},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4309076276,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":51508,"imageIndex":0},{"imageOffset":797464,"imageIndex":0},{"imageOffset":797344,"imageIndex":0},{"imageOffset":792032,"imageIndex":0},{"imageOffset":526305,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":147385,"imageIndex":0},{"imageOffset":74521,"imageIndex":0},{"imageOffset":447229,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":4}]},{"id":37039,"frames":[],"threadState":{"x":[{"value":6158413824},{"value":4355},{"value":6157877248},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6158413824},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6837373844},"far":{"value":0}}},{"id":37040,"frames":[],"threadState":{"x":[{"value":6158987264},{"value":4867},{"value":6158450688},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6158987264},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6837373844},"far":{"value":0}}},{"id":37041,"frames":[],"threadState":{"x":[{"value":6159560704},{"value":19203},{"value":6159024128},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6159560704},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6837373844},"far":{"value":0}}},{"id":37042,"frames":[],"threadState":{"x":[{"value":6160134144},{"value":60931},{"value":6159597568},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6160134144},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6837373844},"far":{"value":0}}},{"id":37043,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":101167954657280},{"value":0},{"value":101167954657280},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":23555},{"value":0},{"value":18446744073709551569},{"value":8687997088},{"value":0},{"value":4294967295},{"value":2},{"value":101167954657280},{"value":0},{"value":101167954657280},{"value":6160703624},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6837194792},"cpsr":{"value":0},"fp":{"value":6160703472},"sp":{"value":6160703392},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6837120052},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":6},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":6},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":6},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":6},{"imageOffset":392096,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":7},{"imageOffset":386296,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":7},{"imageOffset":1150516,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":7},{"imageOffset":719412,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":8},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":9},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":9}]},{"id":37050,"frames":[],"threadState":{"x":[{"value":6161281024},{"value":56347},{"value":6160744448},{"value":0},{"value":409603},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6161281024},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6837373844},"far":{"value":0}}},{"id":37051,"frames":[],"threadState":{"x":[{"value":6161854464},{"value":0},{"value":6161317888},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6161854464},"esr":{"value":0},"pc":{"value":6837373844},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4309024768,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/private\/var\/folders\/*\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4312072192,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/private\/var\/folders\/*\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4312940544,
    "size" : 49152,
    "uuid" : "d4baeab8-b553-3779-a0ff-d8848e7a22df",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4652367872,
    "CFBundleShortVersionString" : "342.3",
    "CFBundleIdentifier" : "com.apple.AGXMetalG16G-B0",
    "size" : 8568832,
    "uuid" : "9b7b6d4d-007d-3c9a-9764-8f0253020490",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG16G_B0.bundle\/Contents\/MacOS\/AGXMetalG16G_B0",
    "name" : "AGXMetalG16G_B0",
    "CFBundleVersion" : "342.3"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 11057389568,
    "size" : 562944,
    "uuid" : "2cd4d4d2-15a3-3057-b506-6e79bd1d6428",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6837116928,
    "size" : 246944,
    "uuid" : "548c45c8-9733-3f0d-8ef4-c06df1df2ad0",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6837653504,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5540928,
    "uuid" : "649000a2-3eb4-3cf5-970a-d3cb37b5780c",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4201"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6909292544,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24310400,
    "uuid" : "4e909aec-68bc-3fc9-a87a-de928e1e36e1",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.30.107"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6837366784,
    "size" : 51900,
    "uuid" : "527c4ba0-91a5-378b-b3e2-d38269ca5a66",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6832308224,
  "size" : 5653544960,
  "uuid" : "acb998b6-263c-3634-b0a8-ae8270a116c2"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=159.7M written=641K(0%) resident=641K(0%) swapped_out=0K(0%) unallocated=159.1M(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               128K        1 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                            96K        5 \nColorSync                           16K        1 \nCoreAnimation                     4448K       61 \nCoreGraphics                        64K        4 \nCoreServices                       624K        2 \nCoreUI image data                 2624K       20 \nFoundation                          16K        1 \nKernel Alloc Once                   32K        1 \nMALLOC                           137.4M       29 \nMALLOC guard page                 3856K        4 \nSTACK GUARD                       56.1M        8 \nStack                             11.7M        8 \nVM_ALLOCATE                       3296K       15 \n__AUTH                            5863K      644 \n__AUTH_CONST                      88.4M     1026 \n__CTF                               824        1 \n__DATA                            35.4M      977 \n__DATA_CONST                      32.9M     1035 \n__DATA_DIRTY                      8729K      887 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       592.4M        5 \n__OBJC_RO                         78.4M        1 \n__OBJC_RW                         2570K        1 \n__TEXT                             1.2G     1058 \n__TPRO_CONST                       128K        2 \nmapped file                      355.7M       51 \npage table in kernel               641K        1 \nshared memory                     2400K       14 \n===========                     =======  ======= \nTOTAL                              2.6G     5867 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "cf1da5e425f0c45800939a4fdba26c07945beb2b",
  "roots_installed" : 0,
  "bug_type" : "309",
  "trmStatus" : 8192,
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "5ffde50ce2aacd000d47a95f",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000509
    },
    {
      "rolloutId" : "6246d6a916a70b047e454124",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000010
    }
  ],
  "experiments" : [

  ]
}
}

Model: Mac16,3, BootROM 13822.61.10, proc 10:4:6 processors, 16 GB, SMC 
Graphics: Apple M4, Apple M4, Built-In
Display: iMac, 4480 x 2520, Main, MirrorOff, Online
Memory Module: LPDDR5, Micron
AirPort: spairport_wireless_card_type_wifi (0x14E4, 0x4388), wl0: Oct  3 2025 01:10:09 version 23.41.7.0.41.51.200 FWID 01-b32af15a
IO80211_driverkit-1533.5 "IO80211_driverkit-1533.5" Nov 14 2025 18:26:34
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Wi-Fi, AirPort, en1
Thunderbolt Bus: iMac, Apple Inc.
Thunderbolt Bus: iMac, Apple Inc.
Thunderbolt Bus: iMac, Apple Inc.
Thunderbolt Bus: iMac, Apple Inc.

### App Version

0.11.12

### macOS Version

26.2 

### Additional Information

_No response_
```

### jordanbaird/Ice #886

- 链接：https://github.com/jordanbaird/Ice/issues/886
- 作者：[kopyl](https://github.com/kopyl)
- 状态：open
- 创建时间：2026-02-21T03:06:09Z（UTC）
- 更新时间：2026-03-06T07:31:49Z（UTC）
- 标签：Feature
- 评论数：4（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Feature Request]: Hide screen recording indicator
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Is it actually possible to hide this thing?

<img width="57" height="43" alt="Image" src="https://github.com/user-attachments/assets/557a7551-87d2-44f6-beb9-e8b79de891f6" />

### Additional Information

And thank you for a great software.
I even decided to send you $5 through GitHub sponsorship.
```

### jordanbaird/Ice #887

- 链接：https://github.com/jordanbaird/Ice/issues/887
- 作者：[kopyl](https://github.com/kopyl)
- 状态：open
- 创建时间：2026-02-21T05:30:30Z（UTC）
- 更新时间：2026-02-21T13:09:43Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: some application don't respect visibility section (like HubStuff)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The issue seems to happen with ["Hidden Bar"](https://apps.apple.com/ru/app/hidden-bar/id1452453066) too.

Video demo: https://youtu.be/rjf1GFU9tFM

Can this be fixed on the Ice side or there is no way?

### Steps to Reproduce

1. Download HubStuff
2. Open HubStuff
3. Place its menu bar icon in the "Visible" section
4. Quit HubStuff
5. Open HubStuff

The HubStuff menu bar item is going to be in the "Hidden" section :(

### App Version

0.11.12

### macOS Version

15.7.1

### Additional Information

_No response_
```

### jordanbaird/Ice #888

- 链接：https://github.com/jordanbaird/Ice/issues/888
- 作者：[Duii1120](https://github.com/Duii1120)
- 状态：open
- 创建时间：2026-02-22T10:03:34Z（UTC）
- 更新时间：2026-02-22T10:03:34Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: Cannot use ice bar when which between windows
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

(Accessibility and Screen Record permissions granted)
This bug is about "Use Ice Bar" feature. When I fill a window to full screen and switch between 2-3 windows, the app start to delay showing icon in the bar (when click ice icon, it shows a blank bar) and then it freezes (nothing happen when interacting with the icon). (I tested with 2-3 different app with full screen)
When it freezes, I cannot interact with ice icon and hover/click to show ice bar. Usually when ice icon freezes, the app freezes too (I cannot open or interact the app) and I have to force quit it in Activity Monitor. Sometimes menu bar goes blank.
This bug affects Menu Bar Shape feature too. When use Spilt and ice icon freeze, it makes menu bar become Full.

This link below is a screen capture video how to trigger the bug.
https://youtu.be/hlJU9YTKSlg

### Steps to Reproduce

1. Open random app into full screen windows
2. Fast switch between windows
3. Try to interact with ice icon or hover/click on menu bar and it freeze.

### App Version

0.11.12

### macOS Version

15.7.4

### Additional Information

_No response_
```

### jordanbaird/Ice #890

- 链接：https://github.com/jordanbaird/Ice/issues/890
- 作者：[jasonbb77](https://github.com/jasonbb77)
- 状态：open
- 创建时间：2026-02-26T01:55:54Z（UTC）
- 更新时间：2026-06-11T13:07:51Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：Ice Bar 功能与交互

**标题原文**

```text
[Bug]: Ice Bar
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

New to Ice, if I activate "Use Ice Bar" the menu items don't open, it just says "unable to display menu bar items" or loading.
As soon as I turn the option off, it works again.

<img width="522" height="168" alt="Image" src="https://github.com/user-attachments/assets/e80673e0-fa66-49b2-b01e-259c33680c91" />

### Steps to Reproduce

1 - open ice settings
2 - Click use ice bar
3 - Click on menu bar

### App Version

0.11.13-dev.2

### macOS Version

26.3

### Additional Information

_No response_
```

### jordanbaird/Ice #891

- 链接：https://github.com/jordanbaird/Ice/issues/891
- 作者：[simongreig](https://github.com/simongreig)
- 状态：open
- 创建时间：2026-02-26T08:47:57Z（UTC）
- 更新时间：2026-05-25T21:50:00Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: ICons List Blank In Settings
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I previously set up Ice and all was well.  I installed a new app and wanted to include the new icon in the menu bar.  When I go to Ice settings then the menu list is empty and I cannot add or change anything.



I have tried a quit and restart.

### Steps to Reproduce

1. Open settings

### App Version

 0.11.12

### macOS Version

26.3

### Additional Information

<img width="1012" height="737" alt="Image" src="https://github.com/user-attachments/assets/6db93996-db75-45de-8083-345b56d0af05" />
```

### jordanbaird/Ice #899

- 链接：https://github.com/jordanbaird/Ice/issues/899
- 作者：[allenwixted](https://github.com/allenwixted)
- 状态：open
- 创建时间：2026-03-12T08:25:51Z（UTC）
- 更新时间：2026-03-12T08:25:51Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Ice triggering while clicking just under the menu bar in fullscreen
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

On my Kuycon g32p monitor (6k display), the ice expanded menu bar area triggers when I click at the top of apps that are in full screen. For example, clicking the URL in Arc browser. I'm not seeing the menu bar itself while in fullscreen, maybe this is a quirk as I'm not used to my new screen yet and maybe it's a Mac OS behaviour? 

### Steps to Reproduce

1. Use large display 
2. Enter an app in full screen 
3. Click towards the top of the app 

### App Version

11.13-dev2

### macOS Version

26.3.1

### Additional Information

_No response_
```

### jordanbaird/Ice #905

- 链接：https://github.com/jordanbaird/Ice/issues/905
- 作者：[Novbobo1](https://github.com/Novbobo1)
- 状态：open
- 创建时间：2026-03-27T02:18:11Z（UTC）
- 更新时间：2026-04-03T15:22:10Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]:
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Immediate Crash Cause:
Ice 0.11.12 (native ARM64) triggers an EXC_BREAKPOINT (SIGTRAP) exception (termination code: Trace/BPT trap: 5) on the main thread (com.apple.main-thread) under macOS 26.4 (build 25E246). The crash stack points to the Swift concurrency runtime's completeTaskWithClosure logic, caused by a main thread assertion failure when accessing the windowNumber property of NSStatusBarWindow.
Root Cause:
Ice version 0.11.12 contains a Swift concurrency thread safety defect, which is incompatible with the system menu bar UI framework of macOS 26.4 (Sequoia 15.4). A race condition is triggered when the Ice Bar feature is enabled, leading to application crash during launch or runtime.

[error.txt](https://github.com/user-attachments/files/26292858/error.txt)



### Steps to Reproduce

Click on "use ice bar"

Click the Hide button in the menu bar

See the error

### App Version

0.11.12

### macOS Version

Sequoia 15.4

### Additional Information

_No response_
```

### jordanbaird/Ice #906

- 链接：https://github.com/jordanbaird/Ice/issues/906
- 作者：[michaelabdou](https://github.com/michaelabdou)
- 状态：open
- 创建时间：2026-03-28T12:08:00Z（UTC）
- 更新时间：2026-03-28T12:08:00Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: App opens in dock when expanding the bar
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When expanding the bar, Ice opens in the dock and disappears when hiding the bar. This issue appeared after updating to Tahoe and wasn't there in Sequoia

### Steps to Reproduce

Make a hide app in dock option

### App Version

0.11.12

### macOS Version

0.11.12

### Additional Information

_No response_
```

### jordanbaird/Ice #908

- 链接：https://github.com/jordanbaird/Ice/issues/908
- 作者：[jerzygangi](https://github.com/jerzygangi)
- 状态：open
- 创建时间：2026-03-28T22:01:17Z（UTC）
- 更新时间：2026-03-28T22:01:57Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Ice appears to have caused system-wide freeze & kernel panic after ~33 hours of uptime
```

**正文原文**

````markdown
## Summary

* After Ice had been running continuously for ~33 hours, it appears to have entered some kind of bad/stale internal state involving a missing control item for the `hidden` section.
* ~82 seconds later, Ice began rapidly requesting Control Center auxiliary scenes which FrontBoard immediately invalidated.
* Shortly thereafter, my machine effectively froze.
* Ice itself then crashed with `EXC_BREAKPOINT`.
* I had to force-restart the machine, which resulted in a kernel panic.

## Environment[^env]

- Ice version: `0.11.12` (build `1117`).
- macOS: `26.4` (build `25E246`).
- Hardware: `MacBookPro18,2` (`M1 Max`).
- Ice uptime at crash time: ~33 hours.
- The machine had not slept since boot; the entire session was continuous.

## Notes

1. I can't prove every hop in the causal chain below definitively from the logs I still have.
1. I can't definitively prove the initial misbehaving WindowServer client was Ice, but Ice is the only process with matching internal errors in that time window.
1. I can't prove Ice's scene loop directly caused the compositing failures that followed, but the timing lines up unusually well.

## Timeline

### 10:30pm+: a WindowServer client stops processing events

Starting from at least 10:30pm, WindowServer was repeatedly clearing the datagram buffer for a single client connection (`cid 0x6db53`) that had stopped draining events[^ws-log]:

```
2026-03-27 22:30:43.652 E  WindowServer[441:12ee] [com.apple.SkyLight:default]
  Clearing datagram buffer for cid 0x6db53. Client state:
  Data count: 16692 connectionIsUnresponsive: 0 clientMayIgnoreEvents: 1 clientIsSuspended: 0
```

I can't prove this was Ice. However, it was the only client in this state for over an hour before the broader cascade, and Ice is the only process with matching internal errors in that period (see below).

### 11:08-11:09pm: Control Center repeatedly wakes Ice, then immediately suspends it

The `runningboardd` log shows `com.apple.controlcenter` (PID 702) acquiring execution assertions targeting Ice (PID 911) and then invalidating them ~100-130ms later, in a cycle that repeated every ~30 seconds[^rb-cycle]:

```
2026-03-27 23:08:01.010 Df runningboardd[450:5d72e3] [com.apple.runningboard:ttl]
  Acquiring assertion targeting [app<application.com.jordanbaird.Ice.584319968.584319978(501)>:911]
  from originator [osservice<com.apple.controlcenter(501)>:702]
  with description <RBSAssertionDescriptor| "FBWorkspace (BG-Active[40])" ...>
```

```
2026-03-27 23:08:01.131 Df runningboardd[450:5d73fd] [com.apple.runningboard:ttl]
  Invalidating assertion 450-702-273420
  (target:[app<application.com.jordanbaird.Ice.584319968.584319978(501)>:911])
  from originator [osservice<com.apple.controlcenter(501)>:702]
```

I observed this cycle at 11:08:01pm, 11:08:35pm, 11:09:01pm, and 11:09:35pm.

### 11:08:43pm: Ice logs `Missing control item for hidden section`

Ice's `MenuBarItemManager` then logged[^ice-log]:

```
2026-03-27 23:08:43.353 E  Ice[911:22d3] [com.jordanbaird.Ice:MenuBarItemManager]
  Missing control item for hidden section
2026-03-27 23:08:45.336 E  Ice[911:22d3] [com.jordanbaird.Ice:MenuBarItemManager]
  Missing control item for hidden section
```

Afaict, this is the first explicit sign that Ice's internal model of the menu bar had gone stale/inconsistent -- it expected a control item for the `hidden` section which no longer existed.

### 11:10:05pm: Ice enters a FrontBoard scene creation/invalidation loop

Ice then began rapidly requesting FrontBoard scenes for Control Center status item auxiliary windows. Within ~1 second, it generated 20+ scene requests, and FrontBoard immediately dropped or invalidated all of them[^ice-log]:

```
2026-03-27 23:10:05.946 Df Ice[911:22d3] [com.apple.FrontBoard:Common]
  Requesting scene <FBSScene: 0x91145c500;
  com.apple.controlcenter:DECA27FF-...-Replicant[37]-Aux[1]-NSStatusItemView>
  from com.apple.controlcenter.statusitems

2026-03-27 23:10:05.949 Df Ice[911:22d3] [com.apple.FrontBoard:SceneClient]
  [...-Replicant[37]-Aux[1]-NSStatusItemView]
  Dropping transition context because the scene is reconnecting
```

This pattern repeated for multiple scene identifiers and then escalated into hard errors[^ice-log]:

```
2026-03-27 23:10:06.052 E  Ice[911:5d95b8] [com.apple.FrontBoard:Common]
  Error creating <FBSScene: ...>:
  <NSError: 0x91605eaf0; domain: FBSceneErrorDomain; code: 2 ("scene-invalidated");
  "scene explicitly invalidated">

2026-03-27 23:10:06.053 E  Ice[911:22d3] [com.apple.AppKit:StatusBar]
  auxiliary scene activation failed: Error Domain=FBSceneErrorDomain Code=2

2026-03-27 23:10:06.053 E  Ice[911:22d3] [com.apple.FrontBoard:SceneClient]
  [...-Replicant[37]-Aux[1]-NSStatusItemView]
  No matching scene to invalidate for this identity.
```

So at this point Ice is in a create-fail-cleanup-fail loop:

1. Ice requests a Control Center auxiliary scene.
1. FrontBoard immediately invalidates it.
1. Ice tries to clean up / invalidate the scene identity, and FrontBoard says no such scene exists.

That's a problem because, if Ice does this tightly enough, it would plausibly explain the system-wide freeze that follows.

### ~11:15pm: the machine freezes

Within ~5 minutes of Ice's scene loop starting, WindowServer began failing to deliver UI events to multiple apps simultaneously[^ws-log]. All apps became unresponsive to interaction.

### 11:29:29pm: Ice crashes with `EXC_BREAKPOINT`

Ice crashed on its main thread with a Swift precondition failure (`brk 1`) involving `NSStatusBarWindow` and the `windowNumber` selector, inside an async task[^crash-details].

By this point my system was too degraded to recover. I had to force-restart the machine; the forced restart itself resulted in a kernel panic[^panic-string] because the system was too wedged to shut down cleanly. Either way, Ice still appears to be the start of the chain.

## What I think happened

Afaict, the most likely sequence is:

1. After ~33 hours of uptime, Ice loses track of a control item for the `hidden` section.
1. That stale/inconsistent internal state causes Ice to repeatedly request Control Center auxiliary scenes.
1. FrontBoard immediately invalidates those scenes.
1. Instead of bailing out / resetting its state, Ice keeps churning through create-fail-cleanup-fail cycles.
1. That churn cascades into compositing failures on the WindowServer side, and the machine effectively freezes.
1. Ice eventually traps on `NSStatusBarWindow.windowNumber`, but by then the machine is already too degraded to recover cleanly.

I can't prove every step in the foregoing definitively. However, the chronology and the Ice-specific errors line up better than any alternative explanation I can currently think of.

## How to reproduce

I don't have reliable repro steps.

## Additional diagnostic data

### Crash report exception details[^crash-l43-44]

```json
{
  "exception": {
    "codes": "0x0000000000000001, 0x0000000100320934",
    "rawCodes": [1, 4298246452],
    "type": "EXC_BREAKPOINT",
    "signal": "SIGTRAP"
  },
  "termination": {
    "flags": 0,
    "code": 5,
    "namespace": "SIGNAL",
    "indicator": "Trace/BPT trap: 5",
    "byProc": "exc handler",
    "byPid": 911
  }
}
```

### Crash report thread 0 backtrace (unsymbolicated)[^crash-l48]

```
Thread 0 (triggered), queue: com.apple.main-thread
  frame 0: Ice + 51508    (faulting frame)
  frame 1: Ice + 797464
  frame 2: Ice + 792032
  frame 3: Ice + 526305
  frame 4: Ice + 131409
  frame 5: Ice + 147385
  frame 6: Ice + 74521
  frame 7: completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1
```

[^env]: Ice crash report (`Ice-2026-03-27-232932.ips`): line 1 (`"app_version":"0.11.12"`, `"os_version":"macOS 26.4 (25E246)"`), line 8 (`"modelCode" : "MacBookPro18,2"`), line 3 (`"uptime" : 120000`). Kernel panic log (`panic-full-2026-03-27-233619.0002.panic`), `panicString` field: `Sleep: 0x00000000`, `Wake: 0x00000000`.
[^crash-l43-44]: Ice crash report, lines 43-44.
[^crash-l48]: Ice crash report, line 48. Image offsets are relative to Ice's binary base. Binary UUID: `438423db-718a-3fc0-9935-2a5721737382`.
[^crash-details]: Ice crash report, line 43 (exception) and line 48 (thread 0 state): registers x1/x14 contain `OBJC_CLASS_$_NSStatusBarWindow`, register x9 contains objc-selector `windowNumber`, ESR is `"(Breakpoint) brk 1"`, frame 7 is `completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)`.
[^panic-string]: Kernel panic log (`panic-full-2026-03-27-233619.0002.panic`), line 8, `panicString` field.
[^ws-log]: WindowServer unified log, captured via `log show`.
[^rb-cycle]: `runningboardd` unified log, captured via `log show`.
[^ice-log]: Ice process unified log, captured via `log show`.
````

### jordanbaird/Ice #909

- 链接：https://github.com/jordanbaird/Ice/issues/909
- 作者：[Kujaw](https://github.com/Kujaw)
- 状态：open
- 创建时间：2026-03-29T20:56:31Z（UTC）
- 更新时间：2026-09-28T13:53:29Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]: OneDrive icons
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

After every system restart, you have to add the OneDrive icons to the taskbar again.

### Steps to Reproduce

After every system restart, you have to add the OneDrive icons to the taskbar again

### App Version

0.11.13-dev.2

### macOS Version

Tahoe 26.4

### Additional Information

_No response_
```

### jordanbaird/Ice #910

- 链接：https://github.com/jordanbaird/Ice/issues/910
- 作者：[drschellenberg](https://github.com/drschellenberg)
- 状态：open
- 创建时间：2026-03-30T23:50:18Z（UTC）
- 更新时间：2026-03-30T23:50:18Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: iPad appearance tint shows on main monitor when the iPad is used as an extended display
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description


<img width="412" height="493" alt="Image" src="https://github.com/user-attachments/assets/d1cf4664-b5c8-43f4-b8b2-6240067999d3" />

### Steps to Reproduce

1. Click the screen mirroring menu bar icon. 
2. Select iPad. 

### App Version

0.11.13-dev.2

### macOS Version

macos: 26.4 (25E246)

### Additional Information

macos: 26.4 (25E246)
iPadOS: 26.4
15-inch, M4, 2025 MBA
iPadPro 11/gen3


```

### jordanbaird/Ice #913

- 链接：https://github.com/jordanbaird/Ice/issues/913
- 作者：[thomasquinlan](https://github.com/thomasquinlan)
- 状态：open
- 创建时间：2026-04-11T10:48:27Z（UTC）
- 更新时间：2026-05-26T02:36:59Z（UTC）
- 标签：Bug
- 评论数：10（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Settings Menu: Menu Bar Layout Icons Do Not Appear
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Selecting Settings then Menu Bar Layour shows three white lines with no icons in them. While you can still move icons in the menu itself, anything that is in the "Always-Hidden" section is unavailable. You can get this through the menu itself but not through settings.

<img width="1654" height="993" alt="Image" src="https://github.com/user-attachments/assets/71d6982e-5a23-4755-8e5b-f6500f21a17d" />

### Steps to Reproduce

Click on the Ice Button.
Select settings.
Select Menubar Layout.

### App Version

0.11.12

### macOS Version

26.4

### Additional Information

_No response_
```

### jordanbaird/Ice #914

- 链接：https://github.com/jordanbaird/Ice/issues/914
- 作者：[pbarmyff](https://github.com/pbarmyff)
- 状态：open
- 创建时间：2026-04-12T10:53:02Z（UTC）
- 更新时间：2026-04-12T10:53:02Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Ice Bar auto-hides before cursor reaches it (latest beta)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

**Ice Bar auto-hides before cursor can reach it**

Hey Jordan,

I've been testing the latest beta on macOS Tahoe and ran into a pretty frustrating bug with the Ice Bar that makes it completely unusable in its current state.

**What's happening**
When I click the dot to reveal the Ice Bar, it shows up for a split second but then hides itself as soon as I move my cursor downward to interact with it. By the time my cursor reaches the Ice Bar, it's already gone.

**Steps to reproduce**
1. Enable Use Ice Bar in General settings
2. Enable Automatically Rehide with Smart strategy
3. Click the dot in the menu bar to reveal the Ice Bar
4. Move cursor downward toward the Ice Bar
5. Ice Bar disappears before cursor arrives

**Expected behavior**
The Ice Bar should stay visible while the cursor is in motion toward it and remain open until the user clicks somewhere else to dismiss it.

**Workaround**
Disabling Automatically Rehide keeps the Ice Bar open, but this shouldn't be the permanent fix since it removes useful functionality for other use cases.

**Environment**
macOS Tahoe, MacBook Air, Ice latest beta

Thanks for the great app, hope this gets sorted soon!

John Doe

### Steps to Reproduce

1. Open Ice settings and go to General
2. Enable Use Ice Bar
3. Enable Automatically Rehide and set Strategy to Smart
4. Close settings and click the dot icon in the menu bar to reveal the Ice Bar
5. Slowly move your cursor downward toward the Ice Bar
6. Observe that the Ice Bar disappears before the cursor reaches it

### App Version

0.11.13-dev.2

### macOS Version

Tahoe 26.4

### Additional Information

_No response_
```

### jordanbaird/Ice #915

- 链接：https://github.com/jordanbaird/Ice/issues/915
- 作者：[wjxjeffery97](https://github.com/wjxjeffery97)
- 状态：open
- 创建时间：2026-04-13T15:52:38Z（UTC）
- 更新时间：2026-04-13T15:52:38Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Unsplash client crashes shortly after being hidden by ICE
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Bug Description
The Unsplash client crashes shortly after it is hidden by ICE.
Steps to Reproduce
Open the Unsplash client.
Hide the window using ICE.
Wait for a short period.
The application crashes.
Additional Context
The app also crashes shortly after being relaunched.
The application functions normally if it is not hidden.

### Steps to Reproduce

1.open ice
2.open unsplash client
3.ice settings
4.menu bar layout
5.drag unsplash icon into hidden section bar
6.a few minutes later, unsplash gone

### App Version

0.11.12

### macOS Version

15.7.4

### Additional Information

_No response_
```

### jordanbaird/Ice #916

- 链接：https://github.com/jordanbaird/Ice/issues/916
- 作者：[dyc12ii](https://github.com/dyc12ii)
- 状态：open
- 创建时间：2026-04-15T07:39:53Z（UTC）
- 更新时间：2026-09-08T07:30:40Z（UTC）
- 标签：Bug
- 评论数：10（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]:  I can't edit my layout, because it's all blank
```

**正文原文**

```markdown
### Search for Similar Reports

- [ ] I have searched existing issues for similar reports

### Description

<img width="885" height="361" alt="Image" src="https://github.com/user-attachments/assets/faff674a-c9a4-4da1-9e45-2f39900eb220" />

### Steps to Reproduce

1. go to ice setting
2. go to menu bar layout 

visible section & hidden section all blank

### App Version

0.11.12

### macOS Version

26.4 (25E246)

### Additional Information

_No response_
```

### jordanbaird/Ice #918

- 链接：https://github.com/jordanbaird/Ice/issues/918
- 作者：[90acres](https://github.com/90acres)
- 状态：open
- 创建时间：2026-04-16T17:15:06Z（UTC）
- 更新时间：2026-04-17T11:09:08Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[Bug]:When icon for Intego One is moved from hidden to visible bar in settings, the icon disappears
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When icon for Intego One app is moved from hidden bar to visible bar, it disappears and a error dialog appears stating:

Frame check timed out for "Intego ONE"
Please try again. If the error persists, please file a bug report.

Repeats only with Intego One app and no other.

### Steps to Reproduce

1. After installing Intego ONE app, its icon appears in Hidden Bar of Ice
2. When Ice settings are opened and MenuBar Layout is selected, Intego ONE icon is in hidden menubar section.
3.  When Intego ONE icon is dragged to Visible Menu Layout, it disappears and error dialog appears.

### App Version

0.11.12

### macOS Version

26.4.1

### Additional Information

<img width="522" height="476" alt="Image" src="https://github.com/user-attachments/assets/9219f4fc-fabf-47d1-9ec7-f681f3f16d7d" />
```

### jordanbaird/Ice #919

- 链接：https://github.com/jordanbaird/Ice/issues/919
- 作者：[MrSpider369](https://github.com/MrSpider369)
- 状态：open
- 创建时间：2026-04-17T18:07:32Z（UTC）
- 更新时间：2026-04-17T18:07:44Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Ice icon dissappeared
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] #920

### Description

By mistakenly i removed ice icon from the menu bar .And suddenly i could;nt find it anywhere. I opened ice setting and clicked the menu bar layout( where i can keep all the menubar thing hidden ),the whoel menu bar layout tab is keep on loading like hell and it never stops.

### Steps to Reproduce

<img width="883" height="600" alt="Image" src="https://github.com/user-attachments/assets/51195c1a-eef0-4713-8083-80ba50e791ef" />

### App Version

0.11.13

### macOS Version

26.4

### Additional Information

_No response_
```

### jordanbaird/Ice #920

- 链接：https://github.com/jordanbaird/Ice/issues/920
- 作者：[MrSpider369](https://github.com/MrSpider369)
- 状态：open
- 创建时间：2026-04-17T18:07:44Z（UTC）
- 更新时间：2026-04-17T18:07:44Z（UTC）
- 标签：无
- 评论数：0（本清单不采集评论正文）
- 主分类：系统升级兼容与待澄清反馈

**标题原文**

```text
I have searched existing issues for similar reports
```

**正文原文**

（此 issue 无正文；原始数据中的 `body` 为空。）

### jordanbaird/Ice #921

- 链接：https://github.com/jordanbaird/Ice/issues/921
- 作者：[bryanmanio](https://github.com/bryanmanio)
- 状态：open
- 创建时间：2026-04-17T22:43:04Z（UTC）
- 更新时间：2026-04-28T23:30:49Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Bug]: Icons in re-arrange menu in settings aren't visible
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

<img width="2112" height="1512" alt="Image" src="https://github.com/user-attachments/assets/94363185-98db-4239-8c51-379ef42826ea" />

Tested in both dark and light mode and nothing is visible.

### Steps to Reproduce

1. Open settings
2. Go to layout


### App Version

0.11.12

### macOS Version

26.3.1

### Additional Information

_No response_
```

### jordanbaird/Ice #925

- 链接：https://github.com/jordanbaird/Ice/issues/925
- 作者：[fulvi0](https://github.com/fulvi0)
- 状态：open
- 创建时间：2026-04-18T12:12:37Z（UTC）
- 更新时间：2026-09-13T14:42:26Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Crash when enabling "Use Ice Bar" with Dynamic location
```

**正文原文**

````markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Ice crashes with an EXC_BREAKPOINT exception when enabling the "Use Ice Bar" option and setting the location to "Dynamic". The crash occurs immediately after clicking to apply the settings.

### Steps to Reproduce

1. Open Ice preferences/settings
2. Enable the "Use Ice Bar" toggle
3. Set Location to "Dynamic"
4. Click to apply the settings
5. Application crashes

### App Version

0.11.12

### macOS Version

26.3.1

### Additional Information

### Environment
- **Ice version:** 0.11.12 (build 1117)
- **macOS version:** 26.3.1 (25D771280a)
- **Hardware:** Mac16,8 (Apple Silicon)
- **Crash date:** 2026-04-18 08:02:28 -0400

### Crash Details
- **Exception Type:** EXC_BREAKPOINT (SIGTRAP)
- **Exception Code:** 0x0000000000000001, 0x0000000104644934
- **Crashed Thread:** 0 (com.apple.main-thread)
- **Termination Reason:** Namespace SIGNAL, Code 5, Trace/BPT trap
- **Crash Report ID:** C6297023-5490-4EF4-AB75-C6AD11BA587E

### Stack Trace (main thread)
```
0   Ice                           0x104644934 0x104638000 + 51508
1   Ice                           0x1046fab18 0x104638000 + 797464
2   Ice                           0x1046faaa0 0x104638000 + 797344
3   Ice                           0x1046f95e0 0x104638000 + 792032
4   Ice                           0x1046b87e1 0x104638000 + 526305
5   Ice                           0x104658151 0x104638000 + 131409
6   Ice                           0x10465bfb9 0x104638000 + 147385
7   Ice                           0x10464a319 0x104638000 + 74521
8   libswift_Concurrency.dylib    0x2823df31d completeTaskWithClosure
```

### Analysis
The crash appears to be related to Ice Bar initialization when set to Dynamic location mode, possibly involving async task handling in the Swift concurrency layer.

### Labels
`bug` `crash` `ice-bar`
````

### jordanbaird/Ice #929

- 链接：https://github.com/jordanbaird/Ice/issues/929
- 作者：[etrock99](https://github.com/etrock99)
- 状态：open
- 创建时间：2026-04-23T07:31:57Z（UTC）
- 更新时间：2026-07-03T04:00:42Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Menu bar scaling and layout issues on external/built-in displays (macOS 26.4.1)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I am experiencing two distinct UI issues regarding the menu bar when using my MacBook Air with an external 1080p monitor. These issues seem related to display switching and resolution handling.
Environment:
•	Device: MacBook Air M2
•	macOS Version: 26.4.1
•	Ice Version: 0.11.13-dev.2
•	Setup: Built-in display + External 1080p monitor




### Steps to Reproduce

Issue 1: Oversized Menu Bar on MacBook Air Screen
Behavior: The menu bar on the MacBook Air's built-in display occasionally becomes excessively large (oversized).
Steps to Reproduce/Trigger:
	1.	Switch focus/active windows between the built-in screen and the external screen.
	2.	The menu bar on the MacBook Air screen grows significantly in size.
	3.	If I interact with a window (e.g., resizing it), a recording prompt from Ice appears.
	4.	After the prompt appears, the menu bar returns to its normal size.

<img width="1668" height="253" alt="Image" src="https://github.com/user-attachments/assets/527c0971-fa9c-4a38-afa4-e31d3b9c977f" />

Issue 2: Persistent Blank Space and Shrunken Bar on External 1080p Screen
Behavior A (Persistent Gap):
On the external 1080p monitor, there is a long, empty blank space on the left side of the menu bar. This space does not disappear and stays there indefinitely.

<img width="1108" height="98" alt="Image" src="https://github.com/user-attachments/assets/ee18e681-4ea3-4fad-af9d-d7d2da8feaeb" />

Behavior B (Scaling Glitch):
When moving the mouse cursor from the MacBook screen to the 1080p monitor, the menu bar on the 1080p screen often becomes extremely small (shrunken).

<img width="986" height="130" alt="Image" src="https://github.com/user-attachments/assets/0b422025-6657-4503-afd7-7466904d958b" />

### App Version

0.11.13-dev.2

### macOS Version

26.4.1

### Additional Information

Recovery:
Similar to the first issue, it eventually restores to normal size after a brief moment or interaction, but it is easily reproducible when switching focus between screens.
Expected Behavior:
•	The menu bar should maintain consistent and correct scaling across both displays.
•	There should be no persistent blank gaps on the left side of the menu bar on external monitors.
•	Switching focus between displays should not trigger sudden size changes (too large or too small) of the menu bar.
```

### jordanbaird/Ice #934

- 链接：https://github.com/jordanbaird/Ice/issues/934
- 作者：[alienbogart](https://github.com/alienbogart)
- 状态：open
- 创建时间：2026-04-26T14:29:06Z（UTC）
- 更新时间：2026-04-27T11:07:50Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：权限、更新、安装与分发

**标题原文**

```text
[Bug]: Nothing happens when I try to run Ice
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I have installed Ice using both homebrew and the release from Github. Either way, runnning the executable does nothing.

### Steps to Reproduce

1. Install Ice on macOS Tahoe via either homebrew or dmg.
2. Run Ice app

### App Version

 0.11.12

### macOS Version

26.4.1 (25E253)

### Additional Information

I don't have anything to add.
```

### jordanbaird/Ice #935

- 链接：https://github.com/jordanbaird/Ice/issues/935
- 作者：[mikeroq](https://github.com/mikeroq)
- 状态：open
- 创建时间：2026-04-30T14:21:02Z（UTC）
- 更新时间：2026-05-12T11:01:38Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Bug]: Website SSL cert expired
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Your SSL certificate expired on April 25th. 

<img width="537" height="399" alt="Image" src="https://github.com/user-attachments/assets/eb84c8f8-f16c-4bee-a5d3-3ee9ddf16d19" />

### Steps to Reproduce

1. Goto https://icemenubar.app

### App Version

0

### macOS Version

0

### Additional Information

_No response_
```

### jordanbaird/Ice #938

- 链接：https://github.com/jordanbaird/Ice/issues/938
- 作者：[markjaquith](https://github.com/markjaquith)
- 状态：open
- 创建时间：2026-05-01T19:52:56Z（UTC）
- 更新时间：2026-10-03T13:38:04Z（UTC）
- 标签：Feature
- 评论数：2（本清单不采集评论正文）
- 主分类：分区、排序与状态持久化

**标题原文**

```text
[Feature Request]: Option that lets you choose location of new items
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

I would like to choose a specific location in my Menu Bar Layout for new/unknown items to appear.

A good way to do this on the Menu Bar Layout screen is with a "new items" proxy item that can be dragged to a specific location in the Visible, Hidden, or Always-Hidden bars.

This would help with immediate visibility of just-installed things, and it would also help for tools like SwiftBar where Ice cannot seem to reliably keep track of the items when they're edited or are only sometimes displayed. By having a "new items" landing location, these unstable items could at least always end up in the same place when Ice loses track of their stable identity.

### Additional Information

_No response_
```

### jordanbaird/Ice #939

- 链接：https://github.com/jordanbaird/Ice/issues/939
- 作者：[tenbeh5](https://github.com/tenbeh5)
- 状态：open
- 创建时间：2026-05-03T22:30:59Z（UTC）
- 更新时间：2026-07-06T12:38:14Z（UTC）
- 标签：Bug
- 评论数：12（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Bug]: IS THIS PROJECT ABANDONED?
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I just started using this last week, but looks like this project is abandoned, all the issues created recently are critical and the app is unusable in latest MacOS with no response nor comments.

### Steps to Reproduce

I am facing all the following issues:
- https://github.com/jordanbaird/Ice/issues/937 
- https://github.com/jordanbaird/Ice/issues/934
- https://github.com/jordanbaird/Ice/issues/919
- https://github.com/jordanbaird/Ice/issues/926
- https://github.com/jordanbaird/Ice/issues/925
- https://github.com/jordanbaird/Ice/issues/905
- https://github.com/jordanbaird/Ice/issues/891
- Too many similar ones created and unaddressed by owner and contributors.


### App Version

0.11.12

### macOS Version

26.4.1

### Additional Information

_No response_
```

### jordanbaird/Ice #943

- 链接：https://github.com/jordanbaird/Ice/issues/943
- 作者：[jurgenvisser](https://github.com/jurgenvisser)
- 状态：open
- 创建时间：2026-05-10T19:53:37Z（UTC）
- 更新时间：2026-07-01T13:25:43Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Ligthing error when enabeling split shape in menu bar appearance
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

The menu bar gets a brightness error. The menu bar looks to bright. this makes the feature unusable as it does not look correct.

<img width="1368" height="885" alt="Image" src="https://github.com/user-attachments/assets/eeaec27a-5c78-437d-90f6-405d2675cb06" />

### Steps to Reproduce

1. Go to Menu Bar Appearance
2. Set Menu Bar > Shape Kind to Split of Full
3. Set Tint to Solid color Black (Optional)
4. The menu bar gets a brightness error

### App Version

0.11.12

### macOS Version

Tahoe 26.4

### Additional Information

_No response_
```

### jordanbaird/Ice #946

- 链接：https://github.com/jordanbaird/Ice/issues/946
- 作者：[Elibabah](https://github.com/Elibabah)
- 状态：open
- 创建时间：2026-05-14T03:16:00Z（UTC）
- 更新时间：2026-05-14T03:16:00Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: MacOS Tahoe 26.5 update broke hidden elements in ice layout
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

After the latest update of MacOS Tahoe 26.5, the hidden area is not support nested elements. Instead, the icons fall into the always-hidden area, which is not needed

### Steps to Reproduce

1. Click on the elipsis icon in the bar menu to open the menu with hidden elements
2. The hidden elements do not appear
3. Open the ice settings
4. click on the layout
5. see all the hidden elements have fallen into the always hidden areas
6. Try to fix them by dragging and dropping
7. The elements fall again into the always hidden area

### App Version

Version 0.11.13-dev.2

### macOS Version

MacOS Tahoe 26.5

### Additional Information

<img width="1192" height="932" alt="Image" src="https://github.com/user-attachments/assets/59688c47-b0ed-41aa-ac6c-5bd34a7e9ecd" />

<img width="1312" height="992" alt="Image" src="https://github.com/user-attachments/assets/88ee6bc9-a32b-4404-bf2e-648b761c8bf2" />
```

### jordanbaird/Ice #947

- 链接：https://github.com/jordanbaird/Ice/issues/947
- 作者：[Benature](https://github.com/Benature)
- 状态：open
- 创建时间：2026-05-16T08:09:02Z（UTC）
- 更新时间：2026-08-27T06:47:37Z（UTC）
- 标签：Bug
- 评论数：16（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: app crash after click in menubar
```

**正文原文**

````markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

```
-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             Ice [40369]
Path:                /Applications/Ice.app/Contents/MacOS/Ice
Identifier:          com.jordanbaird.Ice
Version:             0.11.12 (1117)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      launchd [1]
Coalition:           com.jordanbaird.Ice [30176]
User ID:             501

Date/Time:           2026-05-16 16:06:06.4367 +0800
Launch Time:         2026-05-16 16:05:27.4305 +0800
Hardware Model:      Mac17,3
OS Version:          macOS 26.4 (25E246)
Release Type:        User

Crash Reporter Key:  C8F60A47-B4CB-A05E-64F6-B94DFA0A6509
Incident Identifier: 2A710CB3-5A27-476A-B05D-807653B3F0C4

Sleep/Wake UUID:       2D2648A9-602D-43CE-BC6A-B6F025532DD7

Time Awake Since Boot: 38000 seconds
Time Since Wake:       10047 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_BREAKPOINT (SIGTRAP)
Exception Codes:   0x0000000000000001, 0x0000000104810934

Termination Reason:  Namespace SIGNAL, Code 5, Trace/BPT trap: 5
Terminating Process: exc handler [40369]


Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   Ice                           	       0x104810934 0x104804000 + 51508
1   Ice                           	       0x1048c6b18 0x104804000 + 797464
2   Ice                           	       0x1048c6aa0 0x104804000 + 797344
3   Ice                           	       0x1048c55e0 0x104804000 + 792032
4   Ice                           	       0x1048847e1 0x104804000 + 526305
5   Ice                           	       0x104824151 0x104804000 + 131409
6   Ice                           	       0x104827fb9 0x104804000 + 147385
7   Ice                           	       0x104816319 0x104804000 + 74521
8   libswift_Concurrency.dylib    	       0x286ab6ec5 completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*) + 1

Thread 1:

Thread 2:

Thread 3:

Thread 4:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x1829a3c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1829b6574 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1829ac9c0 mach_msg_overwrite + 480
3   libsystem_kernel.dylib        	       0x1829a3fc0 mach_msg + 24
4   CoreFoundation                	       0x182aa4d68 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x182aa3654 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x182b75be0 _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x186ff0c64 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x1829e7c58 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x1829e2c1c thread_start + 8

Thread 5:

Thread 6:

Thread 7:

Thread 8:

Thread 9:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000a1c06f980   x1: 0x21000001ee842fff   x2: 0x00000001ee842ff8   x3: 0x0000000000000001
    x4: 0x0000001000000003   x5: 0x0000000000000007   x6: 0x0000001000000003   x7: 0x0000000000000007
    x8: 0x0000000000000001   x9: 0x00000001fd3ba649  x10: 0x0000000a0ef5c9b1  x11: 0x00000000000003ff
   x12: 0x0000000000000105  x13: 0x0000000a1d4a5040  x14: 0x21000001ee842fff  x15: 0x00000001ee842ff8
   x16: 0x21000001ee842fff  x17: 0x0000000000000040  x18: 0x0000000000000000  x19: 0x0000000100000000
   x20: 0x0000000a1c06f980  x21: 0x0000000a1e42cdc0  x22: 0x0000000a1c474280  x23: 0x0000000000000002
   x24: 0x00000001049ad000  x25: 0x0000000a1d6dca80  x26: 0x0000000a1c0f2970  x27: 0x0000000a1e61d540
   x28: 0xffffffff76ffffff   fp: 0x000000016b5f78a0   lr: 0x0000000104810928
    sp: 0x000000016b5f7880   pc: 0x0000000104810934 cpsr: 0x60000000
   far: 0x0000000000000000  esr: 0xf2000001 (Breakpoint) brk 1

Binary Images:
       0x104804000 -        0x104993fff com.jordanbaird.Ice (0.11.12) <438423db-718a-3fc0-9935-2a5721737382> /Applications/Ice.app/Contents/MacOS/Ice
       0x104aec000 -        0x104b2ffff org.sparkle-project.Sparkle (2.6.4) <0e273e3e-459c-3fa6-9a86-4754c5cc30ff> /Applications/Ice.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle
       0x104cb4000 -        0x104cbffff libobjc-trampolines.dylib (*) <a4dd56f1-375a-3540-844b-5e397f0b78b3> /usr/lib/libobjc-trampolines.dylib
       0x1192f4000 -        0x119cabfff com.apple.AGXMetalG17G (350.38) <c44193ee-a732-3f50-acb5-a6d3a6ca2a27> /System/Library/Extensions/AGXMetalG17G.bundle/Contents/MacOS/AGXMetalG17G
       0x11c61c000 -        0x11c637fff com.apple.security.csparser (3.0) <94cbb39b-af04-3e75-85e6-d8cedf3ebd91> /System/Library/Frameworks/Security.framework/Versions/A/PlugIns/csparser.bundle/Contents/MacOS/csparser
       0x286aaa000 -        0x286b35095 libswift_Concurrency.dylib (*) <02634765-cb69-3c2b-9cce-10103cbea22a> /usr/lib/swift/libswift_Concurrency.dylib
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x1829a3000 -        0x1829e028f libsystem_kernel.dylib (*) <51565b39-f595-3e96-a217-fef29815057a> /usr/lib/system/libsystem_kernel.dylib
       0x182a27000 -        0x182f84c5f com.apple.CoreFoundation (6.9) <04941709-2330-3bf8-9213-6d33964db448> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x186e96000 -        0x1885b8abf com.apple.AppKit (6.9) <59e23bd5-d01e-305a-b96f-a5790356049a> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x1829e1000 -        0x1829edb3b libsystem_pthread.dylib (*) <e7a73008-0c09-31e3-9dd9-0c61652f0e85> /usr/lib/system/libsystem_pthread.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=189.9M written=2481K(1%) resident=641K(0%) swapped_out=1840K(1%) unallocated=187.5M(99%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               128K        1 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                          5328K       11 
ColorSync                           32K        2 
CoreAnimation                     15.8M       69 
CoreGraphics                        64K        4 
CoreServices                        80K        1 
CoreUI image data                 2608K       20 
Foundation                          16K        1 
Kernel Alloc Once                 8960K        2 
MALLOC                            92.9M       40 
MALLOC guard page                 4112K        4 
Memory Tag 22                     64.0M        1 
STACK GUARD                       56.2M       10 
Stack                             12.8M       10 
VM_ALLOCATE                       5024K       16 
__AUTH                            6087K      638 
__AUTH_CONST                      89.8M     1027 
__CTF                               824        1 
__DATA                            34.6M      978 
__DATA_CONST                      34.8M     1036 
__DATA_DIRTY                      8436K      884 
__FONT_DATA                        2352        1 
__LINKEDIT                       575.5M        6 
__OBJC_RO                         79.1M        1 
__OBJC_RW                         2597K        1 
__TEXT                             1.2G     1058 
__TPRO_CONST                       128K        2 
mapped file                      315.0M       56 
page table in kernel               641K        1 
shared memory                     2480K       19 
===========                     =======  ======= 
TOTAL                              2.6G     5903 


-----------
Full Report
-----------

{"app_name":"Ice","timestamp":"2026-05-16 16:06:10.00 +0800","app_version":"0.11.12","slice_uuid":"438423db-718a-3fc0-9935-2a5721737382","build_version":"1117","platform":1,"bundleID":"com.jordanbaird.Ice","share_with_app_devs":0,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.4 (25E246)","roots_installed":0,"name":"Ice","incident_id":"2A710CB3-5A27-476A-B05D-807653B3F0C4"}
{
  "uptime" : 38000,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac17,3",
  "coalitionID" : 30176,
  "osVersion" : {
    "train" : "macOS 26.4",
    "build" : "25E246",
    "releaseType" : "User"
  },
  "captureTime" : "2026-05-16 16:06:06.4367 +0800",
  "codeSigningMonitor" : 2,
  "incident" : "2A710CB3-5A27-476A-B05D-807653B3F0C4",
  "pid" : 40369,
  "translated" : false,
  "cpuType" : "ARM-64",
  "procLaunch" : "2026-05-16 16:05:27.4305 +0800",
  "procStartAbsTime" : 924994142666,
  "procExitAbsTime" : 925930194996,
  "procName" : "Ice",
  "procPath" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
  "bundleInfo" : {"CFBundleShortVersionString":"0.11.12","CFBundleVersion":"1117","CFBundleIdentifier":"com.jordanbaird.Ice"},
  "storeInfo" : {"deviceIdentifierForVendor":"1E7623B3-1E2E-5E9E-907F-0B0FD71399F5","thirdParty":true},
  "parentProc" : "launchd",
  "parentPid" : 1,
  "coalitionName" : "com.jordanbaird.Ice",
  "crashReporterKey" : "C8F60A47-B4CB-A05E-64F6-B94DFA0A6509",
  "appleIntelligenceStatus" : {"reasons":["countryBillingIneligible","selectedSiriLanguageIneligibleInfo(yue-CN)","regionIneligible","selectedSiriLanguageIneligible","countryLocationIneligible","selectedLanguageDoesNotMatchSelectedSiriLanguageInfo(system: en, siri: yue-CN)","selectedLanguageDoesNotMatchSelectedSiriLanguage"],"state":"unavailable"},
  "developerMode" : 1,
  "codeSigningID" : "com.jordanbaird.Ice",
  "codeSigningTeamID" : "K2ATHQPJDP",
  "codeSigningFlags" : 570503953,
  "codeSigningValidationCategory" : 6,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"6AwAsAGpQPngAxSqvucElPMDAKrgAxSqxOcElLMB+Ldo\/mDTiAAAtA==","atPC":"IAAg1BMAgNIoAIBS6DMAOQgdABJgggiq\/XtCqfRPQan\/wwCRwANf1g=="},
  "bootSessionUUID" : "2B67445A-303A-4AFC-ADA3-CFB20CE5D703",
  "wakeTime" : 10047,
  "sleepWakeUUID" : "2D2648A9-602D-43CE-BC6A-B6F025532DD7",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000001, 0x0000000104810934","rawCodes":[1,4370532660],"type":"EXC_BREAKPOINT","signal":"SIGTRAP"},
  "termination" : {"flags":0,"code":5,"namespace":"SIGNAL","indicator":"Trace\/BPT trap: 5","byProc":"exc handler","byPid":40369},
  "os_fault" : {"process":"Ice"},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":1701651,"threadState":{"x":[{"value":43419892096},{"value":2377900611548229631,"symbolLocation":2377900603251621895,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8296607736,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":1},{"value":68719476739},{"value":7},{"value":68719476739},{"value":7},{"value":1},{"value":8543512137,"objc-selector":"windowNumber"},{"value":43200661937},{"value":1023},{"value":261},{"value":43441082432},{"value":2377900611548229631,"symbolLocation":2377900603251621895,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":8296607736,"symbolLocation":0,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":2377900611548229631,"symbolLocation":2377900603251621895,"symbol":"OBJC_CLASS_$_NSStatusBarWindow"},{"value":64},{"value":0},{"value":4294967296},{"value":43419892096},{"value":43457367488},{"value":43424105088},{"value":2},{"value":4372221952},{"value":43443407488},{"value":43420428656},{"value":43459401024},{"value":18446744071411073023}],"flavor":"ARM_THREAD_STATE64","lr":{"value":4370532648},"cpsr":{"value":1610612736},"fp":{"value":6096386208},"sp":{"value":6096386176},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":4370532660,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":51508,"imageIndex":0},{"imageOffset":797464,"imageIndex":0},{"imageOffset":797344,"imageIndex":0},{"imageOffset":792032,"imageIndex":0},{"imageOffset":526305,"imageIndex":0},{"imageOffset":131409,"imageIndex":0},{"imageOffset":147385,"imageIndex":0},{"imageOffset":74521,"imageIndex":0},{"imageOffset":52933,"symbol":"completeTaskWithClosure(swift::AsyncContext*, swift::SwiftError*)","symbolLocation":1,"imageIndex":5}]},{"id":1701658,"frames":[],"threadState":{"x":[{"value":6096957440},{"value":4099},{"value":6096420864},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6096957440},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486371336},"far":{"value":0}}},{"id":1701669,"frames":[],"threadState":{"x":[{"value":6098104320},{"value":11267},{"value":6097567744},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6098104320},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486371336},"far":{"value":0}}},{"id":1701680,"frames":[],"threadState":{"x":[{"value":6098677760},{"value":22539},{"value":6098141184},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6098677760},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486371336},"far":{"value":0}}},{"id":1701684,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":100068443029504},{"value":0},{"value":100068443029504},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":23299},{"value":1099511628032},{"value":18446744073709551569},{"value":8319575600},{"value":0},{"value":4294967295},{"value":2},{"value":100068443029504},{"value":0},{"value":100068443029504},{"value":21592279046},{"value":6099247240},{"value":8589934592},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6486189428},"cpsr":{"value":0},"fp":{"value":6099247088},"sp":{"value":6099247008},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486113332},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":7},{"imageOffset":79220,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":7},{"imageOffset":39360,"symbol":"mach_msg_overwrite","symbolLocation":480,"imageIndex":7},{"imageOffset":4032,"symbol":"mach_msg","symbolLocation":24,"imageIndex":7},{"imageOffset":515432,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":8},{"imageOffset":509524,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":8},{"imageOffset":1371104,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":8},{"imageOffset":1420388,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":9},{"imageOffset":27736,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":10},{"imageOffset":7196,"symbol":"thread_start","symbolLocation":8,"imageIndex":10}]},{"id":1701781,"frames":[],"threadState":{"x":[{"value":6100398080},{"value":68403},{"value":6099861504},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6100398080},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486371336},"far":{"value":0}}},{"id":1701782,"frames":[],"threadState":{"x":[{"value":6100971520},{"value":53811},{"value":6100434944},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6100971520},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486371336},"far":{"value":0}}},{"id":1701784,"frames":[],"threadState":{"x":[{"value":6102118400},{"value":71691},{"value":6101581824},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6102118400},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486371336},"far":{"value":0}}},{"id":1703998,"frames":[],"threadState":{"x":[{"value":6097530880},{"value":82979},{"value":6096994304},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6097530880},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6486371336},"far":{"value":0}}},{"id":1703999,"frames":[],"threadState":{"x":[{"value":6099824640},{"value":0},{"value":6099288064},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6099824640},"esr":{"value":0},"pc":{"value":6486371336},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4370481152,
    "CFBundleShortVersionString" : "0.11.12",
    "CFBundleIdentifier" : "com.jordanbaird.Ice",
    "size" : 1638400,
    "uuid" : "438423db-718a-3fc0-9935-2a5721737382",
    "path" : "\/Applications\/Ice.app\/Contents\/MacOS\/Ice",
    "name" : "Ice",
    "CFBundleVersion" : "1117"
  },
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4373528576,
    "CFBundleShortVersionString" : "2.6.4",
    "CFBundleIdentifier" : "org.sparkle-project.Sparkle",
    "size" : 278528,
    "uuid" : "0e273e3e-459c-3fa6-9a86-4754c5cc30ff",
    "path" : "\/Applications\/Ice.app\/Contents\/Frameworks\/Sparkle.framework\/Versions\/B\/Sparkle",
    "name" : "Sparkle",
    "CFBundleVersion" : "2039.1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4375396352,
    "size" : 49152,
    "uuid" : "a4dd56f1-375a-3540-844b-5e397f0b78b3",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4717494272,
    "CFBundleShortVersionString" : "350.38",
    "CFBundleIdentifier" : "com.apple.AGXMetalG17G",
    "size" : 10190848,
    "uuid" : "c44193ee-a732-3f50-acb5-a6d3a6ca2a27",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG17G.bundle\/Contents\/MacOS\/AGXMetalG17G",
    "name" : "AGXMetalG17G",
    "CFBundleVersion" : "350.38"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4771135488,
    "CFBundleShortVersionString" : "3.0",
    "CFBundleIdentifier" : "com.apple.security.csparser",
    "size" : 114688,
    "uuid" : "94cbb39b-af04-3e75-85e6-d8cedf3ebd91",
    "path" : "\/System\/Library\/Frameworks\/Security.framework\/Versions\/A\/PlugIns\/csparser.bundle\/Contents\/MacOS\/csparser",
    "name" : "csparser",
    "CFBundleVersion" : "61901.101.4"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 10849263616,
    "size" : 569494,
    "uuid" : "02634765-cb69-3c2b-9cce-10103cbea22a",
    "path" : "\/usr\/lib\/swift\/libswift_Concurrency.dylib",
    "name" : "libswift_Concurrency.dylib"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6486110208,
    "size" : 250512,
    "uuid" : "51565b39-f595-3e96-a217-fef29815057a",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6486650880,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5626976,
    "uuid" : "04941709-2330-3bf8-9213-6d33964db448",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4424.1.402"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6558408704,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24259264,
    "uuid" : "59e23bd5-d01e-305a-b96f-a5790356049a",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.50.120"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6486364160,
    "size" : 52028,
    "uuid" : "e7a73008-0c09-31e3-9dd9-0c61652f0e85",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  }
],
  "sharedCache" : {
  "base" : 6481215488,
  "size" : 5978570752,
  "uuid" : "7d4906c9-9ca2-3f56-8242-3ec2c1e3245b"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=189.9M written=2481K(1%) resident=641K(0%) swapped_out=1840K(1%) unallocated=187.5M(99%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               128K        1 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                          5328K       11 \nColorSync                           32K        2 \nCoreAnimation                     15.8M       69 \nCoreGraphics                        64K        4 \nCoreServices                        80K        1 \nCoreUI image data                 2608K       20 \nFoundation                          16K        1 \nKernel Alloc Once                 8960K        2 \nMALLOC                            92.9M       40 \nMALLOC guard page                 4112K        4 \nMemory Tag 22                     64.0M        1 \nSTACK GUARD                       56.2M       10 \nStack                             12.8M       10 \nVM_ALLOCATE                       5024K       16 \n__AUTH                            6087K      638 \n__AUTH_CONST                      89.8M     1027 \n__CTF                               824        1 \n__DATA                            34.6M      978 \n__DATA_CONST                      34.8M     1036 \n__DATA_DIRTY                      8436K      884 \n__FONT_DATA                        2352        1 \n__LINKEDIT                       575.5M        6 \n__OBJC_RO                         79.1M        1 \n__OBJC_RW                         2597K        1 \n__TEXT                             1.2G     1058 \n__TPRO_CONST                       128K        2 \nmapped file                      315.0M       56 \npage table in kernel               641K        1 \nshared memory                     2480K       19 \n===========                     =======  ======= \nTOTAL                              2.6G     5903 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "f904b95ebfb6d917b1f5dd6631182cea40ae16dc",
  "roots_installed" : 0,
  "bug_type" : "309",
  "trmStatus" : 1,
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "60f8ddccefea4203d95cbeef",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000025
    },
    {
      "rolloutId" : "67fd77fe1f9da9148f70d6ed",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000020
    }
  ],
  "experiments" : [

  ]
}
}

Model: Mac17,3, BootROM 18000.101.7, proc 10:4:6:0 processors, 32 GB, SMC 
Graphics: Apple M5, Apple M5, Built-In
Display: Color LCD, 2560 x 1664 Retina, Main, MirrorOff, Online
Display: R27U61, 5120 x 2880 (5K/UHD+ - Ultra High Definition Plus), MirrorOff, Online
Memory Module: LPDDR5, Micron
AirPort: chip id: 0x11 api 1.2 firmware [Rev 72.29.721 N1B1 devFused=0] phy [20.1.62.0], core80211 [324.29.751 N1_silicon_b ], Mar 10 2026 20:31:01 version XBS_BUILD_TAG GIT_DESCRIBE FWID chip id: 0x11 api 1.2 firmware [Rev 72.29.721 N1B1 devFused=0] phy [20.1.62.0], core80211 [324.29.751 N1_silicon_b ]
IO80211_driverkit-1555.23 "IO80211_driverkit-1555.23" Mar  5 2026 21:45:55
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: USB 10/100 LAN, Ethernet, en5
Network Service: Wi-Fi, AirPort, en0
Network Service: Tailscale, VPN (io.tailscale.ipn.macsys), utun6
Thunderbolt Bus: MacBook Air, Apple Inc.
Thunderbolt Bus: MacBook Air, Apple Inc.

```

### Steps to Reproduce

1. click ice in menubar
2. crash

### App Version

0.11.12

### macOS Version

macOS 26.4

### Additional Information

_No response_
````

### jordanbaird/Ice #951

- 链接：https://github.com/jordanbaird/Ice/issues/951
- 作者：[fernandoJoseC](https://github.com/fernandoJoseC)
- 状态：open
- 创建时间：2026-05-26T14:35:51Z（UTC）
- 更新时间：2026-08-24T07:26:06Z（UTC）
- 标签：Bug
- 评论数：14（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Can't view the icons on Menu Bar Layout
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

<img width="886" height="523" alt="Image" src="https://github.com/user-attachments/assets/543c5c98-e331-4431-a3f9-fd462c58072a" />

### Steps to Reproduce

1. Add other user from Mac
2. Open Ice app
3. Go to Menu Bar Layout

### App Version

0.11.12

### macOS Version

Tahoe 26.3

### Additional Information

_No response_
```

### jordanbaird/Ice #954

- 链接：https://github.com/jordanbaird/Ice/issues/954
- 作者：[Bramgus12](https://github.com/Bramgus12)
- 状态：open
- 创建时间：2026-06-08T19:26:11Z（UTC）
- 更新时间：2026-09-22T12:47:16Z（UTC）
- 标签：Bug
- 评论数：42（本清单不采集评论正文）
- 主分类：系统升级兼容与待澄清反馈

**标题原文**

```text
[Bug]: Ice in menu bar not working anymore (MacOS Golden Gate 27)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Just downloaded the new version of MacOS Golden Gate 27. It seems that Apple has redone some of their menu bar. One addition that I have seen now is that I can see my live activities in the menu bar (never had access to iPhone mirroring in the EU tho), which I did not see before and the battery icon seems to be redone.

<img width="675" height="55" alt="Image" src="https://github.com/user-attachments/assets/33339cf5-a88c-4d5d-b409-a6cde7a6f07a" />

I have no clue if this is even fixable anymore after the update...

### Steps to Reproduce

1. Update to MacOS Golden Gate 27
2. See all icons instead of only the visible icons.

### App Version

0.11.13-dev.2

### macOS Version

27 beta 1

### Additional Information

_No response_
```

### jordanbaird/Ice #955

- 链接：https://github.com/jordanbaird/Ice/issues/955
- 作者：[dnissanbiz](https://github.com/dnissanbiz)
- 状态：open
- 创建时间：2026-06-17T03:36:09Z（UTC）
- 更新时间：2026-07-06T12:36:06Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Scale error and auto-deploying
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

On my secondary display, a lot of the time the ice bar will just appear on a very small scale that I can't even tell what the icons are. And sometimes when I click into the ice bar on either of my displays, it is absolutely massive, about seven times the size of what it usually is. this only happened in Tahoe

### Steps to Reproduce

could not figure out how to reproduce

### App Version

0.11.13-dev.2

### macOS Version

26.4.1 

### Additional Information

_No response_
```

### jordanbaird/Ice #957

- 链接：https://github.com/jordanbaird/Ice/issues/957
- 作者：[tsjl](https://github.com/tsjl)
- 状态：open
- 创建时间：2026-06-25T15:34:43Z（UTC）
- 更新时间：2026-07-16T14:32:01Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：系统升级兼容与待澄清反馈

**标题原文**

```text
[Bug]: Starts but nothing much more
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I can start the ICE app. At first it brong up some popup that had two buttons which did nothing.

Now when starting it hides things from the menubar and puts an ellipsis there to open them back but it seems that it doesn't do anything else. It might be that I just don't understand how to open configuration or something. And I'm sorry if that is the case. But still in that case it is quite a confusing situation.

### Steps to Reproduce

1. Start the program in this computer.
2. Happends again after uninstalling and installing again.

### App Version

3.8.2 installed from Brew.

### macOS Version

26.5.1

### Additional Information

_No response_
```

### jordanbaird/Ice #959

- 链接：https://github.com/jordanbaird/Ice/issues/959
- 作者：[jurgenvisser](https://github.com/jurgenvisser)
- 状态：open
- 创建时间：2026-07-01T13:28:58Z（UTC）
- 更新时间：2026-07-06T12:36:32Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：菜单栏外观与渲染

**标题原文**

```text
[Bug]: Split menu bar does not function like expected in full screen
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

the wallpaper still shows in the menu bar and it isn't black on notched screens. it behaves different when you user vinger gestures on the fullscreen apps or when you go into Mission Control and then go back fullscreen.

### Steps to Reproduce

1. Turn on split menu bar shape in menu bar appearance.
2. Go full screen in an app and the wallpaper still shows in the menu bar and it isn't black on notched screens.

### App Version

0.11.12

### macOS Version

Tahoe 26.4

### Additional Information

_No response_
```

### jordanbaird/Ice #961

- 链接：https://github.com/jordanbaird/Ice/issues/961
- 作者：[sciencefictionspacecraft](https://github.com/sciencefictionspacecraft)
- 状态：open
- 创建时间：2026-07-12T07:57:00Z（UTC）
- 更新时间：2026-07-12T07:57:00Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Feature Request]: No dock icon
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Hi. I love Ice, so thanks for the app, at this point I couldn't live without it. One thing though, is that it puts a big ol icon in the Dock, which is fairly useless and undoes some of the minimalism that the app otherwise brings.

Can we have a setting to hide the dock icon? Ice is great just running quietly an unobtrusively in the menu bar.

Thanks!

### Additional Information

_No response_
```

### jordanbaird/Ice #965

- 链接：https://github.com/jordanbaird/Ice/issues/965
- 作者：[dmfresco](https://github.com/dmfresco)
- 状态：open
- 创建时间：2026-07-15T01:05:26Z（UTC）
- 更新时间：2026-10-06T22:55:19Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menubar layout broken/spinning in MacOS 27 Public Beta
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I don't know how to paste a screenshot into this form, but I just upgraded this M5 MBP to MacOS 27 Public Beta.  The first release of it. 

### Steps to Reproduce

Menubar Layout

### App Version

0.11.13 Dev 2

### macOS Version

27.0 Beta (26A5378n)

### Additional Information

<img width="674" height="486" alt="Image" src="https://github.com/user-attachments/assets/4a76337f-dba3-4def-82d5-cda257657c30" />
```

### jordanbaird/Ice #966

- 链接：https://github.com/jordanbaird/Ice/issues/966
- 作者：[lxy1992](https://github.com/lxy1992)
- 状态：open
- 创建时间：2026-07-17T02:30:32Z（UTC）
- 更新时间：2026-08-05T02:51:33Z（UTC）
- 标签：Bug
- 评论数：9（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Bug]: Unofficial macOS 26-compatible build of Ice (signed and notarized)
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Hi everyone,

For anyone experiencing startup crashes or menu bar interaction issues with Ice on macOS 26, I’ve prepared an unofficial compatibility build based on the upstream Ice project:

https://github.com/lxy1992/Ice/releases/tag/0.11.13-macos26.1

This build:

- Fixes the macOS 26 startup and menu bar interaction crashes.
- Supports both Apple Silicon and Intel Macs as a Universal binary.
- Is signed with a Developer ID certificate and notarized by Apple.
- Uses an independent bundle identifier: `com.lxy1992.Ice`.
- Does not use the upstream Sparkle update feed or signing keys, so automatic updates are disabled.

Because it uses a separate bundle identifier, macOS treats it as a different app. You will need to grant Accessibility, Screen Recording, and any other required permissions again after installing it.

This is an unofficial community build, not a replacement for the upstream project. Homebrew still installs the official upstream version. Please report issues related specifically to this build in the fork:

https://github.com/lxy1992/Ice/issues

Many thanks to Jordan Baird and all Ice contributors for creating and maintaining the original project.

### Steps to Reproduce

1. open app
2. click on menu bar
3. crash

### App Version

latest

### macOS Version

26.3.1

### Additional Information

_No response_
```

### jordanbaird/Ice #968

- 链接：https://github.com/jordanbaird/Ice/issues/968
- 作者：[aliafshany](https://github.com/aliafshany)
- 状态：open
- 创建时间：2026-07-23T21:36:26Z（UTC）
- 更新时间：2026-07-23T21:36:26Z（UTC）
- 标签：无
- 评论数：0（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
macOS 26.5.2: Ice stuck / menu bar stays hidden after form dropdown hang (Dock auto-hide also stuck)
```

**正文原文**

````markdown
## Summary

When opening **form/select dropdowns** (native popups — e.g. country pickers on websites, tag choosers in apps), the foreground app often freezes or crashes. After that:

1. **Ice stops responding** (cannot show/hide sections, menu bar items stay hidden)
2. **Dock stays auto-hidden** until the stuck app is force-quit
3. Only killing the app (and sometimes Ice / Dock) restores normal UI

This is **not** the app menu bar (File / Edit). It is **popup / HTML `<select>` / NSPopUp** style dropdowns.

## Environment

| Item | Value |
|------|--------|
| Ice | **0.11.12** (build 1117) |
| Bundle ID | `com.jordanbaird.Ice` |
| macOS | **26.5.2 (25F84)** Tahoe |
| Hardware | MacBook Pro **Mac14,7**, Apple **M2**, 8 GB |
| Dock | Auto-hide **ON** |
| Ice settings | `HideApplicationMenus = ON`, `ShowOnHover = ON` (0.1s), `ShowOnClick = OFF`, `UseIceBar = OFF`, `AutoRehide = ON` |

Also running other Accessibility clients (iStat Menus, BetterDisplay, Swish, Input Source Pro, CleanShot X, etc.).

## Steps to reproduce

1. Ice running with sections hidden as usual (hover-to-show enabled).
2. Dock auto-hide enabled.
3. Open Helium (or another app) on a form with a native-style dropdown (country list, tags, HTML `<select>`).
4. Click the dropdown to open the option list.
5. App freezes or crashes mid-popup.
6. Observe: Ice no longer reveals hidden items; Dock does not unhide on hover until the app is force-quit.

## Expected

- Opening a form dropdown should not leave Ice stuck.
- After app hang/crash, Ice and Dock should return to a consistent state without force-quit / `killall Ice`.

## Actual

- Ice becomes non-interactive; hidden menu bar content stays hidden.
- Dock remains auto-hidden.
- Recovery typically requires force-quit of the stuck app, and often:

```bash
killall Ice
killall Dock
open -a Ice
```

## Crash evidence (Helium — Chromium)

Repeated Helium crashes while **native popup menus** are tracking (same path as form selects). 6× reports in ~5 days under `~/Library/Logs/DiagnosticReports/Helium-*.ips`.

Exception: `EXC_BREAKPOINT` / `SIGTRAP` via `+[NSApplication _crashOnException:]`

Representative stack:

```
-[NSPopUpButtonCell trackMouse:inRect:ofView:untilMouseUp:]
-[NSCocoaMenuImpl popUpMenu:...]
_NSPopUpMenu
+[NSContextMenuImpl presentPopup:fromView:withContext:animated:]
-[NSContextMenuTrackingSession startMonitoringEvents:]
-[NSMenuTrackingSession startRunningMenuEventLoop:]
...
-[NSWindow(NSDisplayCycle) _postWindowNeedsLayout]  // NSException
+[NSApplication _crashOnException:]
```

Alternate path also seen: `NSMenuBarTrackingSession` → menu event loop → same layout exception.

Ice does **not** appear in the crash frames (no Ice symbols on the faulting stack). Ice is implicated as **aftermath stuck state** when the system is mid–menu-tracking / after the hang, not necessarily as the process that crashes.

## Related report

Helium issue (browser-side crash): https://github.com/imputnet/helium/issues/2188

## Request / questions for maintainers

1. Does Ice install event monitors or menu-bar observers that can race with `NSMenuTrackingSession` / popup menus (especially with **Hide Application Menus** + **Show on Hover**)?
2. Can Ice detect a broken / stuck hide state and self-recover when the frontmost app dies mid-menu-tracking?
3. Is there a recommended setting combo on Tahoe 26.5 for users who hit this (e.g. disable Hide Application Menus + Show on Hover)?

Happy to attach Ice console logs, a sysdiagnose, or test nightlies if useful.

Thanks!

````

### jordanbaird/Ice #970

- 链接：https://github.com/jordanbaird/Ice/issues/970
- 作者：[sowerbray](https://github.com/sowerbray)
- 状态：open
- 创建时间：2026-08-01T13:11:05Z（UTC）
- 更新时间：2026-09-28T22:25:54Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Not automatically hiding in MacOS 27
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Upgraded to MacOS 27 Public Beta. Menu Bar no longer auto hides.

### Steps to Reproduce

1. Upgrade to MacOS 27 Public Beta 2
2. Ice Menu Bar stopped auto hiding

### App Version

0.11.12

### macOS Version

20457.0.125.0.2

### Additional Information

_No response_
```

### jordanbaird/Ice #973

- 链接：https://github.com/jordanbaird/Ice/issues/973
- 作者：[abominateryan](https://github.com/abominateryan)
- 状态：open
- 创建时间：2026-08-19T16:20:26Z（UTC）
- 更新时间：2026-08-31T23:43:22Z（UTC）
- 标签：Bug
- 评论数：8（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Menu bar layout shown nothing on the sections
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

when I was on macOS Sequoia this happened only once right after installing for the first time and the issue somehow fixed itself. and now since I updated to macOS Tahoe, I'm having this issue

<img width="889" height="617" alt="Image" src="https://github.com/user-attachments/assets/62b8510f-9a2c-4236-88dd-ffd20379454a" />

### Steps to Reproduce

1. Open Ice
2. Menu Bar layout

### App Version

0.11.12

### macOS Version

26.6.2

### Additional Information

_No response_
```

### jordanbaird/Ice #974

- 链接：https://github.com/jordanbaird/Ice/issues/974
- 作者：[medlars](https://github.com/medlars)
- 状态：open
- 创建时间：2026-08-19T19:44:52Z（UTC）
- 更新时间：2026-09-29T15:40:22Z（UTC）
- 标签：无
- 评论数：4（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: Orphaned application menu-bar windows stuck at CGWindow layer 101, invisible to accessibility (macOS 26.6.1, 0.11.13-dev.2)
```

**正文原文**

````markdown
## Summary

Orphaned **application menu-bar windows** are left composited at CoreGraphics layer 101 after menu tracking is interrupted. The frozen panels are visible on screen but **absent from the accessibility tree**, so they ignore clicks and Escape and cannot be dismissed by any normal means — only `kill -9 Finder` clears them.

This is adjacent to #968 but a **different surface**: that issue covers popup / `<select>` / NSPopUpButton dropdowns, whereas this is the **Apple menu and the application menu bar** itself. Same recovery (force-quit), same Ice config, different affected UI.

I want to be upfront about the strength of the evidence: **I have not proven Ice causes this.** I am reporting it because Ice is the only process on the machine that touches other applications' menu-bar windows via private APIs, and because the config matches #968 exactly. See "What I could not establish" below — please close this if it does not match anything you recognise.

## Environment

| Item | Value |
|------|-------|
| Ice | **0.11.13-dev.2** (build **1120**) — dev channel, ahead of stable 0.11.12 / 1117 |
| Bundle ID | `com.jordanbaird.Ice` |
| macOS | **26.6.1 (25G76)** Tahoe |
| Hardware | Apple Silicon (arm64e) |
| Ice settings | `HideApplicationMenus = 1`, `AutoRehide = 1`, `RehideInterval = 15`, `ShowOnClick = 1`, `ShowOnHover = 0`, `UseIceBar = 1` |
| Other AX clients | Magnet, PopClip, Paste, TextExpander, Dropzone, Snagit, 1Password |

Note the config is the same `HideApplicationMenus = ON` + `AutoRehide = ON` combination reported in #968.

## Symptom (measured)

Two Finder windows stuck at layer 101:

```
PID 91315  Finder  L101   6,34    263x305    ''     <- renders as the Apple menu
PID 91315  Finder  L101   264,34  585x1036   ''     <- renders as an Applications list
```

Enumerated with `CGWindowListCopyWindowInfo`. Meanwhile `System Events` reported **no** windows for Finder at all:

```applescript
tell application "System Events" to get name of every process whose visible is true
-- Finder present, but 'every window of process "Finder"' returns empty
```

That divergence — composited by CG, unknown to AX — is why the panels are undismissable: there is no live menu to close, only its retained layer.

## Correlating system evidence

`WindowServer` filed CPU-resource diagnostics on both affected days, each stuck re-preparing a layer tree it could not retire:

```
Command: WindowServer
CPU: 90s over 175s (51% avg), exceeding limit of 50% over 180s

  update_display_callback -> CGXUpdateDisplay -> WS::Updater::UpdateDisplays
    -> WS::Updater::prepare_coreanimation
      -> ca_prepare_begin_window_update
        -> CA::Render::Updater::prepare_layer0
          -> prepare_sublayer0   (recursing ~20 levels deep, repeatedly)
```

Consistent with a retained/abandoned layer tree rather than transient load.

## Why I am pointing at Ice specifically

Ice is the only process on this machine linking private CoreGraphics window APIs that reach into **other processes'** menu bars:

```
_CGSGetProcessMenuBarWindowList     <- enumerates another process's menu-bar windows
_CGSCopyActiveMenuBarDisplayIdentifier
_CGSGetOnScreenWindowList
_CGSGetWindowLevel
_CGSSetConnectionProperty
... 14 private _CGS* symbols total (via `nm -u`)
```

With `AutoRehide` on a 15s timer, Ice touches those windows continuously. The hypothesis is a **race**: if Ice mutates the menu-bar window list while a menu is mid-tracking, the AX element is torn down while the composited layer survives. This machine runs a heavy nightly job load (load average 22-28), which would widen such a window.

## What I could not establish (please weight accordingly)

- **No log line shows Ice creating or touching those specific windows.** Two independent passes over the unified log at both incident timestamps found Ice doing only routine ~100ms background-refresh work, with no anomaly correlating to onset.
- An **orphaned `System Events` process** (PPID 1, 1m06s CPU, spawned by an `osascript` whose parent had exited) was also present on this machine and is an equally plausible driver — abandoned UI-scripting is a known way to strand menu state. I have separately fixed that on my side.
- So this may be **entirely my own automation's fault**, not Ice's. I am filing because the capability and the config match #968, and only you can say whether the teardown path here is sound.

## Question for maintainers

When Ice enumerates or mutates another process's menu-bar windows via `_CGSGetProcessMenuBarWindowList`, is there a guard for the case where a menu is **actively tracking** at that moment? If not, that is where I would look — and it would plausibly explain both this and #968, which has had no comments since July.

## Recovery

```bash
kill -9 $(pgrep -x Finder)   # Finder relaunches automatically
```

Detection (useful for anyone hitting this — exits 1 with the owning PID):
compare the CG layer-101 window set against the set of processes `System Events` reports as owning windows; any owner present in the former and absent from the latter is orphaned.

````

### jordanbaird/Ice #977

- 链接：https://github.com/jordanbaird/Ice/issues/977
- 作者：[AtharvaSarada](https://github.com/AtharvaSarada)
- 状态：open
- 创建时间：2026-08-31T14:12:59Z（UTC）
- 更新时间：2026-09-02T12:20:20Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：崩溃、冻结与资源消耗

**标题原文**

```text
[Bug]: crashes whenever I use the trigger button in the menu bar
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I've set the icon to cube. Whenever I press that cube icon in the menu bar when it is not expanded, as soon as I press the cube icon, the app crashes. I have to reopen the app, and then it asks me if it can update the app automatically or it can check for updates. None of the buttons are pressable on that option pop up

### Steps to Reproduce

Open the ice app, then press the icon in the menu bar which is dedicated for the ice app expander, and then the app will fail at least it did on my MacBook Pro M5. 

### App Version

The latest one 

### macOS Version

The latest one 

### Additional Information

_No response_
```

### jordanbaird/Ice #986

- 链接：https://github.com/jordanbaird/Ice/issues/986
- 作者：[maverickOG](https://github.com/maverickOG)
- 状态：open
- 创建时间：2026-09-07T16:10:25Z（UTC）
- 更新时间：2026-09-07T16:10:25Z（UTC）
- 标签：Bug
- 评论数：0（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Ice Bar leaves a ghost/visual artifact on the primary display when a video enters fullscreen on a secondary display
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

I am using a dual-display setup with an external monitor as the main/primary display and my MacBook's built-in display as the secondary display.
When I enter fullscreen video playback on the MacBook's built-in display, the Ice Bar/menu bar area appears to leave a ghost/visual artifact on the external monitor.
The external monitor is not displaying the fullscreen video or the active window, but a remnant of the Ice Bar remains visible on it.

<img width="2560" height="1440" alt="Image" src="https://github.com/user-attachments/assets/94698650-58f2-47ff-9e99-9f05a48f5952" />

### Steps to Reproduce

1. Connect an external monitor to a MacBook.
2. Set the external monitor as the main/primary display and the MacBook display as the secondary display.
3. Have Ice running with the Ice Bar enabled.
4. Open a video on the MacBook's built-in display.
5. Enter fullscreen video mode.
6. Observe the external monitor.

### App Version

0.11.13-dev.2

### macOS Version

26.6.1

### Additional Information

**Actual Behavior**
A ghost/leftover rendering of the Ice Bar appears on the external monitor, even though the fullscreen video and active window are on the MacBook's secondary display.

**Expected Behavior**
The Ice Bar should render correctly for each display without leaving a ghost, stale rendering, or visual artifact on another display.

See attached screenshot showing the ghosted Ice Bar on the external monitor.
```

### jordanbaird/Ice #987

- 链接：https://github.com/jordanbaird/Ice/issues/987
- 作者：[maverickOG](https://github.com/maverickOG)
- 状态：open
- 创建时间：2026-09-07T16:14:30Z（UTC）
- 更新时间：2026-09-15T15:44:41Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Ice Bar icons shrink drastically when expanded on an external display
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

When using Ice with an external monitor as the main/primary display and the MacBook's built-in display as the secondary display, clicking the Ice Bar to expand it on the external monitor can cause the menu bar icons to become drastically smaller than their normal size.

The icons can shrink to approximately 50% of their normal size.

This appears to happen specifically when expanding Ice on the external monitor. The normal icon size is restored at some point, but the scaling becomes severely incorrect during the issue.

### Steps to Reproduce

1. Connect an external monitor to a MacBook.
2. Set the external monitor as the main/primary display.
3. Keep the MacBook's built-in display as the secondary display.
4. Move the cursor to the external monitor.
5. Click the Ice control to expand the Ice Bar.
6. Observe the menu bar icons.

### App Version

0.11.13-dev.2

### macOS Version

26.6.1

### Additional Information

**Actual Behavior**
The menu bar icons sometimes become severely scaled down, approximately half their normal size.

**Expected Behavior**
The menu bar icons should retain the same configured size when the Ice Bar is expanded, regardless of which connected display is being used.

**Additional Information**
Related to #698, but this appears to be a different manifestation of the multi-display sizing issue. In #698, items are rendered at different sizes across displays. In this issue, the items shrink significantly when Ice is expanded on the external display. [GitHub](https://github.com/jordanbaird/Ice/issues/929?utm_source=chatgpt.com)

However, this report is specifically about the icons shrinking when the Ice Bar is expanded on the external display.
```

### jordanbaird/Ice #988

- 链接：https://github.com/jordanbaird/Ice/issues/988
- 作者：[maverickOG](https://github.com/maverickOG)
- 状态：open
- 创建时间：2026-09-07T16:16:21Z（UTC）
- 更新时间：2026-09-16T11:26:20Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：显示器、分辨率与刘海适配

**标题原文**

```text
[Bug]: Ice Bar fullscreen expansion behaves differently depending on which display contains the active window
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

There is an inconsistent fullscreen behavior when using Ice with a dual-display setup.

My external monitor is configured as the main/primary display, while the MacBook's built-in display is the secondary display.

When an application/window is fullscreen and the active window is on the MacBook display, Ice expands the menu bar with the expected spacing/separation, as shown in Screenshot 3.

However, when the active window and cursor are on the external monitor, Ice handles the expanded area differently. The space occupied by the Ice Bar is expanded in an unexpected way, and on the MacBook display the resulting layout becomes continuous with the fullscreen window, without the separation/gap visible in Screenshot 3. The result looks like Screenshot 4.

In other words, the same fullscreen setup produces different Ice Bar spacing/layout depending on which display currently contains the active window.

<img width="3600" height="78" alt="Image" src="https://github.com/user-attachments/assets/5822d8e1-e7ac-4c80-84ae-558c3dce05fe" />

<img width="3600" height="78" alt="Image" src="https://github.com/user-attachments/assets/6d101bd4-225c-4447-898b-756142636257" />

### Steps to Reproduce

1. Connect an external monitor to a MacBook.
2. Set the external monitor as the main/primary display.
3. Keep the MacBook display as the secondary display.
4. Open an application in fullscreen.
5. Expand the Ice Bar.
6. First, have the active window/cursor on the MacBook display.
7. Observe the spacing between the Ice Bar/menu bar area and the fullscreen application.
   - This produces the behavior shown in Screenshot 3.
8. Move the active window/cursor to the external monitor.
9. Expand/use the Ice Bar again.
10. Observe the MacBook display.
- The spacing/layout changes to the behavior shown in Screenshot 4.

### App Version

0.11.13-dev.2

### macOS Version

26.6.1

### Additional Information

**Actual Behavior**
- The fullscreen layout of the Ice Bar is dependent on which display contains the active window.
- When the active window is on the external monitor, the MacBook display loses the expected separation between the Ice Bar-expanded area and the fullscreen application, producing an incorrect/continuous layout.

**Expected Behavior**
- The Ice Bar should maintain consistent fullscreen spacing and layout across displays.
- The expanded Ice Bar should behave the same way regardless of whether the active window is on the primary external display or the secondary MacBook display.
```

### jordanbaird/Ice #991

- 链接：https://github.com/jordanbaird/Ice/issues/991
- 作者：[anthonyhrcr](https://github.com/anthonyhrcr)
- 状态：open
- 创建时间：2026-09-14T23:21:35Z（UTC）
- 更新时间：2026-09-23T07:58:06Z（UTC）
- 标签：Bug
- 评论数：8（本清单不采集评论正文）
- 主分类：系统升级兼容与待澄清反馈

**标题原文**

```text
[Bug]: MacOS 27 Update
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

After the launch of MacOS 27 the application isn't succeeding on making the default schedule, system update is probably required!

### Steps to Reproduce

Update the system and you will see the need

### App Version

0.11.13-dev.2

### macOS Version

27

### Additional Information

_No response_
```

### jordanbaird/Ice #992

- 链接：https://github.com/jordanbaird/Ice/issues/992
- 作者：[WuColin-1](https://github.com/WuColin-1)
- 状态：open
- 创建时间：2026-09-15T00:34:34Z（UTC）
- 更新时间：2026-09-23T07:58:43Z（UTC）
- 标签：Bug
- 评论数：12（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: unavailable under MacOS27
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

After upgrading to macOS 27, the ice logo in the menu bar doesn't work anymore, showing "loading menu bar items".

<img width="252" height="89" alt="Image" src="https://github.com/user-attachments/assets/a284fee5-8e1d-45be-b99f-e71a64304604" />

### Steps to Reproduce

just update to the latest version of macOS, and you will see.

### App Version

0.11.13-dev.2.

### macOS Version

MacOS 27

### Additional Information

_No response_
```

### jordanbaird/Ice #993

- 链接：https://github.com/jordanbaird/Ice/issues/993
- 作者：[cavaldos](https://github.com/cavaldos)
- 状态：open
- 创建时间：2026-09-16T04:21:24Z（UTC）
- 更新时间：2026-09-18T02:11:59Z（UTC）
- 标签：Feature
- 评论数：5（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: This project is no longer maintained by the original author
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

## Project maintenance update

This repository has not been actively maintained for the past few years.

I have created and am actively maintaining a fork of this project here:

👉 **New actively maintained repository:**  
https://github.com/cavaldos/Ice

Please use the new repository for:

- New issues
- Pull requests
- Bug reports
- Feature requests
- The latest updates and releases

The original project remains available for historical reference, but new development and maintenance will take place in the new repository.

Thank you!


### Additional Information

_No response_
```

### jordanbaird/Ice #996

- 链接：https://github.com/jordanbaird/Ice/issues/996
- 作者：[ldngoc-misa](https://github.com/ldngoc-misa)
- 状态：open
- 创建时间：2026-09-17T02:38:03Z（UTC）
- 更新时间：2026-09-23T07:59:20Z（UTC）
- 标签：Bug
- 评论数：6（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Ice not working properly on macOS 27 Golden Gate
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

After i upgrade macOS 27 Golden Gate, Ice not working properly: click on Ice icon in menubar doesn't make items expand/collapse (always stuck in expanded mode)

### Steps to Reproduce

1. Upgrade macOS 27 Golden Gate
2. Click on Ice icon in menubar
3. Error: nothing happened

### App Version

0.11.13-dev.2

### macOS Version

27.0

### Additional Information

_No response_
```

### jordanbaird/Ice #999

- 链接：https://github.com/jordanbaird/Ice/issues/999
- 作者：[Jayjaytik09](https://github.com/Jayjaytik09)
- 状态：open
- 创建时间：2026-09-19T13:02:18Z（UTC）
- 更新时间：2026-10-01T02:50:09Z（UTC）
- 标签：Bug
- 评论数：8（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: Can't see layout
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

<img width="935" height="642" alt="Image" src="https://github.com/user-attachments/assets/7fbf3f6b-9c1a-4a67-aa33-1367d5d8cc9c" />



This is happening on both of my laptops. They're both on the new software for the Macs. I have closed and unclosed the app I've looked for an update, and I have also uninstalled and reinstalled. 

### Steps to Reproduce

Go to the settings and go to the menu layout section 

### App Version

0.11.12 

### macOS Version

27 Golden Gate 27.0

### Additional Information

_No response_
```

### jordanbaird/Ice #1003

- 链接：https://github.com/jordanbaird/Ice/issues/1003
- 作者：[steliospaps7](https://github.com/steliospaps7)
- 状态：open
- 创建时间：2026-09-29T09:43:31Z（UTC）
- 更新时间：2026-10-07T19:22:06Z（UTC）
- 标签：Bug
- 评论数：2（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: [Bug]: Updated to MacOS 27.0.1 and cannot customize Menu Bar Layout on Ice
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Menu Bar Layout keeps loading but not showing the actual menu bar so I can customize it.

<img width="908" height="649" alt="Image" src="https://github.com/user-attachments/assets/34127ae3-4287-410e-912f-1bf88699a305" />

### Steps to Reproduce

1. Open Ice after updating MacOS to 27.0.1
2. Go to Menu Bar Layout
3. Observe loading indicator

### App Version

0.11.12

### macOS Version

27.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #1006

- 链接：https://github.com/jordanbaird/Ice/issues/1006
- 作者：[Theralley](https://github.com/Theralley)
- 状态：open
- 创建时间：2026-10-01T07:42:03Z（UTC）
- 更新时间：2026-10-07T19:21:53Z（UTC）
- 标签：无
- 评论数：2（本清单不采集评论正文）
- 主分类：权限、更新、安装与分发

**标题原文**

```text
[macOS 27.0.1] What got Ice working with PR #995, plus two things to look into
```

**正文原文**

````markdown
Ice 0.11.13-dev.2 is broken on macOS 27 for me as well: stuck on "Loading menu bar items" and hides nothing (same as #954, #992, #1003, #1005). I got it working by building PR #995 from source, and two problems came up along the way that are worth a look before it lands.

**Setup**
- macOS 27.0.1 (26A434), Apple Silicon, Xcode 27.0 (27A266a)
- PR #995 at `d1858fb`, Release build, signed ad hoc (no developer team)

**What solved it**
1. Built #995 with `CODE_SIGN_IDENTITY=- ENABLE_HARDENED_RUNTIME=NO`.
2. Granted Accessibility to the new build. An old Ice entry in System Settings belongs to the previous signature and has to be removed first.
3. Filled in the macOS 27 layout by hand. With that, hiding, revealing and Ice's click toggle all work.

**Look into 1: the existing layout is not migrated**

After upgrading, nothing was hidden because the `MacOS27Layout` default was empty, and "applications missing from it are visible". The old dividers were still in place (`Ice.ControlItem.Hidden` and `Ice.ControlItem.Visible` with eight apps between them), but those apps were never written into the macOS 27 layout, so the app looked broken. This fixed it immediately:

```
defaults write com.jordanbaird.Ice MacOS27Layout -dict <bundle-id> -int 1 ...   # 0 visible, 1 hidden, 2 always hidden
```

Suggestion: on first launch on 27, seed `MacOS27Layout` from the current divider order. Watch out: an item's owner can differ from the app's bundle ID. Docker Desktop's item is owned by `com.electron.dockerdesktop`, not `com.docker.docker`.

**Look into 2: ad hoc builds die at launch with the hardened runtime on**

With the default `ENABLE_HARDENED_RUNTIME=YES` and an ad hoc signature:

```
dyld: Library not loaded: @rpath/Sparkle.framework/Versions/B/Sparkle
  ... not valid for use in process: mapping process and mapped file (non-platform) have different Team IDs
```

`codesign --verify --deep --strict` passes, so `Scripts/install.sh` will install a bundle that can't launch for anyone without a developer team. Fix: `ENABLE_HARDENED_RUNTIME=NO`, or `com.apple.security.cs.disable-library-validation` for local builds.

**Tip:** turn off Sparkle auto-update for local builds (`defaults write com.jordanbaird.Ice SUAutomaticallyUpdate -bool false`), or the official build can replace yours.

Thanks to @RabenkoYevhenii for #995.

````

### jordanbaird/Ice #1007

- 链接：https://github.com/jordanbaird/Ice/issues/1007
- 作者：[Theralley](https://github.com/Theralley)
- 状态：open
- 创建时间：2026-10-01T13:20:29Z（UTC）
- 更新时间：2026-10-02T14:11:25Z（UTC）
- 标签：无
- 评论数：2（本清单不采集评论正文）
- 主分类：第三方应用与系统项目兼容

**标题原文**

```text
[macOS 27 / PR #995] An app launched while concealed gets a squashed (3 pt) menu bar item that never recovers
```

**正文原文**

```markdown
Follow-up to #1006. Reproducible on macOS 27.0.1 (26A434) with #995 at `15f59a9`.

**What happens**

If an app in the hidden section is launched while Ice holds its concealment assertion, the app's status item comes back 3 pt wide when revealed: a clipped sliver of its icon, overlapping the item beside it. It stays that way after Ice quits and after relaunching the app. Only relaunching the app while Ice is not running fixes it.

**Steps**

1. Put AlDente (`com.apphousekitchen.aldente-pro`) in the hidden section, start Ice. The item is 18 pt (Accessibility `AXMenuExtra` width).
2. Quit AlDente and open it again while Ice is running.
3. The item is now 3 pt. Revealing does not fix it, quitting Ice does not fix it, relaunching AlDente does not fix it.
4. Fix: quit Ice and AlDente, open AlDente, then Ice. Back to 18 pt.

**Not every app.** Amphetamine relaunched the same way keeps its 33 pt width. AlDente probably uses a variable-length item that sizes itself from the space it is offered at creation, and gets zero while concealed. So any variable-length item is likely affected.

**Why it matters:** Login Items start in their own order. With Ice before such an app, its item is squashed on every boot. I work around it with a LaunchAgent that opens Ice only after AlDente is running.

**Possible fix:** when an application in a concealed section launches, release it from the assertion briefly, until its status item has been created and sized, then conceal it again. `Concealer27` already observes `didLaunchApplicationNotification`.

```

### jordanbaird/Ice #1008

- 链接：https://github.com/jordanbaird/Ice/issues/1008
- 作者：[CyBoRg2605](https://github.com/CyBoRg2605)
- 状态：open
- 创建时间：2026-10-06T05:18:48Z（UTC）
- 更新时间：2026-10-07T19:21:39Z（UTC）
- 标签：Bug
- 评论数：5（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[Bug]: Not functioning since MacOS 27 update on my Macbook pro M3 pro
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

Basically the title. 
The icons are not hidden no matter what I try and the ICE icon just does nothing. ICE app has all the required permissions and yet this issue. I believe it started since macOS 27 update.

### Steps to Reproduce

I am not sure. This is my first time tim here

### App Version

0.11.13-dev.2

### macOS Version

macOS 27 Golden Gate 27.0.1

### Additional Information

_No response_
```

### jordanbaird/Ice #1009

- 链接：https://github.com/jordanbaird/Ice/issues/1009
- 作者：[mweldridge](https://github.com/mweldridge)
- 状态：open
- 创建时间：2026-10-07T17:08:23Z（UTC）
- 更新时间：2026-10-07T19:21:19Z（UTC）
- 标签：Bug
- 评论数：3（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]:
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

In Ice Settings select Menu Bar Layout and get constant Loading menu bar items... spinning wheel.

### Steps to Reproduce

Go to Menu bar layout
screen shows "Loading menu bar items..."
Screen shows spinning cursor.

### App Version

9.11.1-Dev2

### macOS Version

MacOS 27.2 Beta 3

### Additional Information

_No response_
```

### jordanbaird/Ice #1010

- 链接：https://github.com/jordanbaird/Ice/issues/1010
- 作者：[Mmmmarvin](https://github.com/Mmmmarvin)
- 状态：open
- 创建时间：2026-10-08T02:52:04Z（UTC）
- 更新时间：2026-10-08T07:45:31Z（UTC）
- 标签：Bug
- 评论数：1（本清单不采集评论正文）
- 主分类：布局编辑、图标发现与搜索

**标题原文**

```text
[Bug]: always loading meum bar items
```

**正文原文**

```markdown
### Search for Similar Reports

- [x] I have searched existing issues for similar reports

### Description

<img width="306" height="67" alt="Image" src="https://github.com/user-attachments/assets/1ec4afe4-3f0f-42f6-b121-409d5a411d7b" />

### Steps to Reproduce

1.restart Ice
2.Cannot hide the menu bar


### App Version

Version 0.11.13- dev.2

### macOS Version

27.0.1 (26A434)

### Additional Information

_No response_
```

### jordanbaird/Ice #1011

- 链接：https://github.com/jordanbaird/Ice/issues/1011
- 作者：[Jimmbo](https://github.com/Jimmbo)
- 状态：open
- 创建时间：2026-10-08T15:43:34Z（UTC）
- 更新时间：2026-10-09T13:09:37Z（UTC）
- 标签：Feature
- 评论数：1（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: Some Golden Gate Clarity
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Jordan, thanks so so much for Ice, which has been so great.

There are several bug reports and discussion threads on Golden Gate compatibility.  I know what it is to run a popular freeware project, and don't want to put any pressure on you. But if you could drop a statement on where the project is at and headed, insofar as you can say at this point, it would be super helpful. 

It seems like there might be an impasse. If you (and your co-conspirators) don't plan on working through it, perhaps you could bless one of the splinter projects offering similar functionality in Golden Gate (I'm compiling a list [here](https://github.com/jordanbaird/Ice/discussions/1013)).

And if you do none of those things, I am (and we are) nothing but grateful for your work thus far.

### Additional Information

_No response_
```

### jordanbaird/Ice #1014

- 链接：https://github.com/jordanbaird/Ice/issues/1014
- 作者：[Theralley](https://github.com/Theralley)
- 状态：open
- 创建时间：2026-10-09T21:03:33Z（UTC）
- 更新时间：2026-10-11T12:45:29Z（UTC）
- 标签：无
- 评论数：3（本清单不采集评论正文）
- 主分类：触发、点击与自动隐藏

**标题原文**

```text
[macOS 27 / PR #995] With an app item among the system items, clicking the battery opens that app and Wi-Fi does not open
```

**正文原文**

````markdown
Reproducible on macOS 27.0.1 (26A434) with #995 at `8f53e22`.

**What happens**

Macs Fan Control (`com.crystalidea.macsfancontrol`) had its item between the battery and Control Centre. While Ice conceals, MenuBarAgent draws the battery on top of it, and the two Accessibility frames overlap:

```
  x    w   owner
 1274  22  MenuBarAgent  com.apple.menuextra.wifi
 1312  26  MenuBarAgent  com.apple.menuextra.battery
 1315  24  com.crystalidea.macsfancontrol
 1354  26  MenuBarAgent  com.apple.menuextra.controlcenter
```

With Ice running and items concealed:

- Clicking the battery opens Macs Fan Control instead of the battery panel.
- Clicking Wi-Fi opens nothing.
- Each of those clicks makes the hidden items flash and Wi-Fi and the battery jump sideways.

It makes no difference whether the app is in a hidden section or left visible.

**Cause**

Wi-Fi, the battery and the clock are in `systemItemsIgnoringPress`, so `handleSystemItemClick27` holds the click, lifts concealment and replays it at the point where it was made. Lifting concealment gives the app item its slot back, so the system items left of it move. I read their frames again every few milliseconds after a click:

```
                 wifi   battery   controlcenter   macsfancontrol
concealed        1274   1312      1354            1315
lifted           1236   1274      1354            1315
```

The move comes 50–150 ms after the assertion is released. The replayed battery click lands at x = 1325, which is now Macs Fan Control. The replayed Wi-Fi click lands at x = 1285, which is now the battery.

Two more things I found:

- The `AXUIElement` kept from the last scan can go on reporting the old frame after the bar has moved, so the item has to be looked up again by its identifier.
- Reading the frame straight after the release is too early: the bar has not moved yet.

**Workaround**

With Ice quit, Cmd-drag the app's item to the left of the system items, then start Ice again.

**Fix**

I have a fix on top of #995 at `8f53e22`, tested on macOS 27.0.1. It only changes the path where an app item overlaps a system item at or right of the clicked one. In that case Ice waits for the clicked item to move (up to 200 ms, with the lift extended by the same amount), looks the item up again by identifier, and replays the click on it. Every other click is replayed exactly as before.

With the app visible or concealed next to the battery, the battery and Wi-Fi now open their own panels every time; the clock and Control Centre are unchanged. The jump itself remains, because MenuBarAgent moves the bar whenever concealment is lifted.

Happy to open a PR against #995's branch if that's useful.

````

### jordanbaird/Ice #1015

- 链接：https://github.com/jordanbaird/Ice/issues/1015
- 作者：[alabotski](https://github.com/alabotski)
- 状态：open
- 创建时间：2026-10-11T17:42:40Z（UTC）
- 更新时间：2026-10-11T17:42:40Z（UTC）
- 标签：Feature
- 评论数：0（本清单不采集评论正文）
- 主分类：本地化、文档与项目维护

**标题原文**

```text
[Feature Request]: Is the project still alive?
```

**正文原文**

```markdown
### Search for Similar Requests

- [x] I have searched existing issues for similar requests

### Description

Is the project still alive?
There haven't been any updates for a long time.

### Additional Information

_No response_
```


