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

## 参与贡献

欢迎提交改进。提交 Pull Request 前，请阅读[贡献说明](Resources/document/CONTRIBUTING.md)。

新增可见文案时，在 `Floe/Resources/en.lproj/Localizable.strings` 与 `Floe/Resources/zh-Hans.lproj/Localizable.strings` 中同时维护资源。SwiftUI 使用本地化键，原生菜单和弹窗使用 `L10n.string`，不要直接改写持久化标识、应用名或上游链接。

## 支持上游

可通过 [Ko-fi](https://ko-fi.com/calvados)、[PayPal](https://www.paypal.com/paypalme/nnkhanh29) 支持上游维护者。

## 致谢

Floe fork 自 [cavaldos/Ice](https://github.com/cavaldos/Ice)，后者 fork 自 [Jordan Baird](https://github.com/jordanbaird) 的 [jordanbaird/Ice](https://github.com/jordanbaird/Ice)。感谢两个上游项目的贡献。

## 许可证

采用 [GPL-3.0](LICENSE) 许可证，保持免费开源。

## Star 历史

[查看 Star 历史](https://star-history.com/#wudb/Floe&Date)

![Star 历史图](https://api.star-history.com/svg?repos=wudb/Floe&type=Date)
