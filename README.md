<div align="center">
    <img src="Floe/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width=200 height=200>
    <h1>Floe — Free & Open-Source Menu Bar Manager for macOS</h1>
    <p>Hide and organize menu bar icons on your Mac. The best <strong>free Bartender alternative</strong> — also a great <strong>Hidden Bar</strong> and <strong>Vanilla alternative</strong> — focused on stability and a smooth, distraction-free experience.<br>✅ <strong>Fully supports macOS 27</strong></p>
</div>

![Floe menu bar manager for macOS — hide and organize menu bar icons](./Resources/Image/banner.png)

<div align="center">

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/wudb/Floe/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/wudb/Floe/total?style=flat-square)](https://github.com/wudb/Floe/releases)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2014%2B-fa4e49?style=flat-square)
![macOS 27](https://img.shields.io/badge/macOS_27-fully_supported-brightgreen?style=flat-square)
[![GitHub stars](https://img.shields.io/github/stars/wudb/Floe?style=flat-square)](https://github.com/wudb/Floe/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/wudb/Floe?style=flat-square)](https://github.com/wudb/Floe/network/members)
[![Repository](https://img.shields.io/badge/Repository-GitHub-015FBA?style=flat-square)](https://github.com/wudb/Floe)
[![License](https://img.shields.io/github/license/wudb/Floe?style=flat-square)](LICENSE)
[![Sponsor](https://img.shields.io/badge/Sponsor%20%E2%9D%A4%EF%B8%8F-8A2BE2?style=flat-square)](https://ko-fi.com/calvados)

<br>

<a href="https://ko-fi.com/calvados" target="_blank">
    <img src="https://storage.ko-fi.com/cdn/kofi5.png?v=6" alt="Support upstream on Ko-fi" style="height: 60px !important;width: 217px !important;">
</a>

</div>

> [!NOTE]
> Floe is in active development. Grab the latest build from the [releases page](https://github.com/wudb/Floe/releases/latest).

> [!TIP]
> ✅ **Fully supports macOS 27** — tested and ready for the latest macOS, all the way back to macOS 14 Sonoma.

## Install

**Manual:**

1. Download `Floe.zip` from the [latest release](https://github.com/wudb/Floe/releases/latest).
2. Unzip it and move `Floe.app` into `/Applications`.
3. Clear the quarantine flag — releases are ad-hoc signed and not notarized, so Gatekeeper would otherwise block the first launch:

```bash
xattr -d com.apple.quarantine /Applications/Floe.app
```

Then open Floe and grant **Accessibility** and **Screen Recording** in System Settings (see [local development instructions](script/README.md#after-installing-a-build)).

For local development, open `Floe.xcodeproj` and select the `Floe` scheme, or see [script/README.md](script/README.md).

Floe uses the bundle identifier `com.wudb.Floe`, with separate preferences and privacy permissions from Ice. Grant Accessibility and Screen Recording to Floe on first launch. Automatic updates are disabled until Floe has its own update feed and signing key.

## Permissions

In System Settings → Privacy & Security, grant Accessibility and Screen Recording
to `Floe.app`. Existing grants for Ice do not apply to Floe. After rebuilding an
ad-hoc signed app, use `./script/fix-permissions.sh /path/to/Floe.app` if its
previous grants no longer match the new signature.

## Uninstall

**Manual:** quit Floe, then drag `Floe.app` out of `/Applications` to the Trash. To also remove preferences, delete `~/Library/Preferences/com.wudb.Floe.plist`.


## Gallery

**Always-Hidden section demo — hide menu bar icons and reveal on hover**

![Demo of Floe always-hidden menu bar section on macOS](Resources/vid/demo-ah.gif)

**Show and hide menu bar icons demo**

![Demo showing and hiding Mac menu bar icons with Floe](Resources/vid/demo.gif)

**Fullscreen settings**

![Floe fullscreen settings window on macOS](Resources/Image/fullscreen.png)


| Floe Bar — second menu bar for notched MacBooks                                                   | Drag-and-drop menu bar layout                                                                   |
| ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| ![Floe Bar second menu bar for MacBook notch](https://github.com/user-attachments/assets/f1429589-6186-4e1b-8aef-592219d49b9b) | ![Drag and drop menu bar layout editor](./Resources/Image/MenuBarLayout.png) |

| Menu bar appearance and theme settings                                                                  | Menu bar item spacing                                                                                       |
| ------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| ![Menu bar appearance theme settings](./Resources/Image/MenuBarAppearance.png) | ![Menu bar icon spacing settings](https://github.com/user-attachments/assets/b196aa7e-184a-4d4c-b040-502f4aae40a6) |


> ✅ **macOS 27 fully supported** — works on macOS 14 Sonoma and later, including Sequoia, Tahoe, and macOS 27. If you need a similar tool for macOS 13 Ventura or earlier, check out [Ice 0.11.x](https://github.com/jordanbaird/Ice/releases).


## Contributing

Contributions are welcome! Please read the [contribution guidelines](./Resources/document/CONTRIBUTING.md) before submitting a pull request.

## Support Upstream

<a href="https://ko-fi.com/calvados" target="_blank">
    <img src="https://storage.ko-fi.com/cdn/kofi5.png?v=6" alt="Support upstream on Ko-fi" style="height: 36px !important;width: 130px !important;">
</a>

<a href="https://www.paypal.com/paypalme/nnkhanh29" target="_blank">
    <img src="https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_200x51.png" alt="Donate with PayPal" style="height: 36px !important;">
</a>

## Acknowledgments

Floe is forked from [cavaldos/Ice](https://github.com/cavaldos/Ice), which is forked from [jordanbaird/Ice](https://github.com/jordanbaird/Ice) by [Jordan Baird](https://github.com/jordanbaird). Thanks to both upstream projects.

## License

[GPL-3.0](LICENSE) — Floe is and will always remain open-source and free.

## Star History

<a href="https://star-history.com/#wudb/Floe&Date">
    <img src="https://api.star-history.com/svg?repos=wudb/Floe&type=Date" alt="Star History Chart" width="500">
</a>
