[English](README.md) | [简体中文](README.zh-CN.md)

<div align="center">
    <img src="Floe/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width="200">
    <h1>Floe — 免费开源的 macOS 菜单栏管理工具</h1>
    <p>隐藏并整理 Mac 菜单栏图标，让菜单栏保持简洁。</p>
</div>

![Floe 菜单栏管理工具](Resources/Image/banner.png)

[下载最新版本](https://github.com/wudb/Floe/releases/latest) · [源代码](https://github.com/wudb/Floe) · [反馈问题](https://github.com/wudb/Floe/issues) · [GPL-3.0 许可证](LICENSE)

Floe 正在持续开发，支持 macOS 14 Sonoma 及更高版本。已有的 macOS 26/27 兼容问题及验证范围见 [issues 里程碑](docs/issues_milestone.md)。

## 安装

1. 从[发布页面](https://github.com/wudb/Floe/releases/latest)下载 `Floe.zip`。
2. 解压后，将 `Floe.app` 放入 `/Applications`。
3. 当前发布构建采用 ad hoc 签名，尚未公证。首次启动若受到 Gatekeeper 限制，可清除隔离标记：

```bash
xattr -d com.apple.quarantine /Applications/Floe.app
```

打开 Floe，并在系统设置中授予辅助功能和屏幕录制权限。

本地开发时打开 `Floe.xcodeproj`，选择 `Floe` Scheme；构建和运行脚本见 [开发说明](script/README.md)。

Floe 的应用标识为 `com.wudb.Floe`，与上游 Ice 的偏好设置和隐私授权相互独立。配置 Floe 自己的更新源和签名公钥之前，自动更新保持关闭。

## 语言

打开 **设置 → 通用 → 语言**（英文界面为 **Settings → General → Language**），选择：

- **跟随系统**：默认选项，匹配系统首选语言。
- **English**：始终使用英语。
- **简体中文**：始终使用简体中文。

目前支持英语和简体中文。系统首选语言不受支持时（包括繁体中文），回退为英语。选择会保存，切换后立即生效，无需重启 Floe。README 默认使用英语，简体中文版为当前文档。

## 权限

在 **系统设置 → 隐私与安全性** 中，为 `Floe.app` 授予：

- **辅助功能**：发现、整理并操作菜单栏项目。
- **屏幕录制**：获取菜单栏图像和编辑外观。未授予时可使用受限模式。

Ice 的已有授权不会应用到 Floe。重新构建或签名后，如果旧授权与新签名不匹配，可以运行：

```bash
./script/fix-permissions.sh /path/to/Floe.app
```

随后按系统提示重新授权。

## 卸载

退出 Floe，然后将 `/Applications/Floe.app` 移到废纸篓。若还要删除偏好设置，可删除 `~/Library/Preferences/com.wudb.Floe.plist`。

## 界面预览

以下演示图来自上游项目，部分图片仍显示上游名称或旧版界面。

**始终隐藏分区**

![始终隐藏分区演示](Resources/vid/demo-ah.gif)

**显示与隐藏菜单栏图标**

![显示与隐藏图标演示](Resources/vid/demo.gif)

**全屏设置**

![全屏设置](Resources/Image/fullscreen.png)

| Floe 浮栏 | 菜单栏布局 |
| --- | --- |
| ![独立浮栏](https://github.com/user-attachments/assets/f1429589-6186-4e1b-8aef-592219d49b9b) | ![菜单栏布局](Resources/Image/MenuBarLayout.png) |

| 菜单栏外观 | 图标间距 |
| --- | --- |
| ![菜单栏外观](Resources/Image/MenuBarAppearance.png) | ![图标间距](https://github.com/user-attachments/assets/b196aa7e-184a-4d4c-b040-502f4aae40a6) |

如需支持 macOS 13 Ventura 或更早版本，可参考上游 [Ice 0.11.x](https://github.com/jordanbaird/Ice/releases)。

## 图标规则与键盘操作

右键点击菜单栏空白区域，选择“编辑菜单栏布局…”可直接进入布局页。搜索支持图标名和应用名；使用上/下方向键或 Control-N/Control-P 选择结果，Return 打开当前选中项，Escape 关闭。

在布局页使用 Tab 聚焦图标，左/右方向键切换焦点，Command-左/右方向键调整顺序，Command-1/2/3 分别移至可见、隐藏、始终隐藏分区。右键菜单和 VoiceOver 操作菜单提供相同的移动操作。系统不允许移动或隐藏的项目仍受系统限制。

“新菜单栏图标”设置可选择默认分区和分区内开头/末尾。首次启用时保留当前布局，修改默认规则不会重排已有项目；“显示所有当前图标”才会显式将可识别的当前图标移至可见区。未启用始终隐藏时，指定进入该区的新项会回退到隐藏区。已保存的单项位置优先于新项默认规则。图标右键菜单中的“始终显示此应用”优先于已保存的分区；取消规则后保留当前位置，随后可以手动整理。

自动放置会等待菜单关闭、鼠标停止移动。它需要系统支持项目发现且身份可唯一识别；身份不明确的图标保留当前位置。临时显示不会被保存为新布局，确认后的手动调整和自动放置选择则会用于宿主重建后的恢复。

若 Floe 图标已被移除，从“应用程序”重新打开 Floe，再在通用设置中点击“恢复 Floe 图标”。重新打开应用会保留设置入口，方便在图标缺失时恢复。

## 浮栏布局与固定位置

在通用设置中，可分别为隐藏、始终隐藏分区选择“原生菜单栏”“Floe 浮栏”“跟随使用 Floe 浮栏”或“自适应”。跟随模式沿用原有全局开关及快捷键。例如，普通隐藏区可在原生栏展开，始终隐藏区则使用浮栏。原生始终隐藏区仍会同时露出隐藏区，因为二者共用同一行。

浮栏支持横向图标、名称列表和图标网格。网格可设置 2–12 列，窄屏时会减少实际列数；列表和网格使用纵向滚动，并限制在显示器可用区域内。名称和激活沿用现有项目发现机制，包括辅助功能回退路径。

右键点击浮栏背景并选择“整理”，将图标拖到另一图标上可插入到它之前，拖到“放到末尾”可移至末尾；点击“完成”恢复正常菜单激活。移动后会读回真实原生顺序，拒绝或失效的操作会显示错误，不会只改变画面上的顺序。关闭浮栏会取消编辑会话。受系统保护、辅助功能帧缺失或仍在屏外的项目不会被强制移动。

退出整理模式、拖动浮栏背景到目标位置后，右键点击背景并选择“固定位置”，即可保存该显示器上的位置。固定后再次拖动背景，会更新该屏记录。位置按可用区域的相对比例保存，改变尺寸或显示缩放后不会套用旧像素坐标；没有记录的显示器默认位于可用区域右上角。“取消固定位置”恢复常规定位规则。固定的是位置，不是显示时长，自动收起仍然有效。

## 参与贡献

欢迎提交改进。提交 Pull Request 前，请阅读[贡献说明](Resources/document/CONTRIBUTING.md)。

新增可见文案时，在 `Floe/Resources/en.lproj/Localizable.strings` 与 `Floe/Resources/zh-Hans.lproj/Localizable.strings` 中同时维护资源。SwiftUI 使用本地化键，原生菜单和弹窗使用 `L10n.string`，不要直接改写持久化标识、应用名或上游链接。

## 支持上游

可通过 [Ko-fi](https://ko-fi.com/calvados)、[PayPal](https://www.paypal.com/paypalme/nnkhanh29) 支持上游维护者。

可从 Floe 右键菜单或“设置 → 快捷键”中配置的快捷键搜索菜单栏项目。支持项目和应用名称，回车打开首个结果，Escape 关闭。对于支持 CGS 项目发现的系统，已确认的布局拖拽会保存可唯一识别项目的选择。

## 致谢

Floe fork 自 [cavaldos/Ice](https://github.com/cavaldos/Ice)，后者 fork 自 [Jordan Baird](https://github.com/jordanbaird) 的 [jordanbaird/Ice](https://github.com/jordanbaird/Ice)。感谢两个上游项目的贡献。

## 许可证

采用 [GPL-3.0](LICENSE) 许可证，保持免费开源。

## Star 历史

[查看 Star 历史](https://star-history.com/#wudb/Floe&Date)

![Star 历史图](https://api.star-history.com/svg?repos=wudb/Floe&type=Date)

## 自适应呈现

在通用设置中，将任一隐藏分区设为“自适应”，展开“自适应呈现规则”。可选择屏幕类型（全部、内屏、外屏、刘海屏）和连接数量（任意、单屏、多屏），两项范围须同时满足。范围以外仍使用原生菜单栏。

默认仅在原生连续空间不足时使用浮栏。空间会扣除应用菜单及刘海，并计入原生展开时需要显示的可见区和隐藏区图标宽度；长度使用逻辑点。可调整预留空间，或关闭空间条件，让范围内始终使用浮栏。无法测量或系统自动隐藏菜单栏时优先浮栏；退出浮栏多留 48 点余量，避免临界宽度下反复切换。

分区的固定选择优先。对于自适应分区，按显示器手动覆盖优先于全屏规则，其后才是屏幕范围和空间条件。全屏可选遵循规则、原生栏、浮栏或不展开；状态按目标显示器读取，无法确认时保留未知。日常只显示图标栏，整理期间才显示工具栏。

切换显示器、Space 或前台应用后刷新规则，空间测量以一秒为周期。菜单打开、临时显示和整理期间延后收起过时呈现；下一次用户触发时采用新方式，不会自动显示全部图标或改变已保存的显隐选择。显示器覆盖按持久 UUID 保存。这是呈现规则，不代表每屏拥有独立的原生图标集合。
