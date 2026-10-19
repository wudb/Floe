[English](README.md) | [简体中文](README.zh-CN.md)

<div align="center">
    <img src="Floe/Assets.xcassets/AppIcon.appiconset/icon_256x256.png" width=200 height=200>
    <h1>Floe — Free & Open-Source Menu Bar Manager for macOS</h1>
    <p>Hide and organize menu bar icons on your Mac to keep your menu bar tidy.</p>
</div>

![Floe menu bar manager for macOS — hide and organize menu bar icons](./Resources/Image/banner.png)

<div align="center">

[![Download](https://img.shields.io/badge/download-latest-brightgreen?style=flat-square)](https://github.com/wudb/Floe/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/wudb/Floe/total?style=flat-square)](https://github.com/wudb/Floe/releases)
![Platform](https://img.shields.io/badge/platform-macOS-blue?style=flat-square)
![Requirements](https://img.shields.io/badge/requirements-macOS%2014%2B-fa4e49?style=flat-square)
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

Floe requires macOS 14 Sonoma or later. See the [issues milestones](docs/issues_milestone.md) for macOS 26/27 compatibility work and validation scope.

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

## Appearance

Open **Settings → General → Appearance** and choose **Follow System** (default),
**Light**, or **Dark**. Your selection is saved and applies immediately. Follow
System continues to track your Mac's light/dark appearance. This preference
changes Floe's interface without changing macOS system settings.

## Language

Open **Settings → General → Language** and choose **Follow System**, **English**,
or **简体中文**. The default follows the system's primary preferred language.
Simplified Chinese is supported; unsupported languages (including Traditional
Chinese) fall back to English. Your selection is saved and applies immediately
without restarting Floe.

## Permissions

In System Settings → Privacy & Security, grant Accessibility and Screen Recording
to `Floe.app`. Existing grants for Ice do not apply to Floe. After rebuilding an
ad-hoc signed app, use `./script/fix-permissions.sh /path/to/Floe.app` if its
previous grants no longer match the new signature.

## Uninstall

**Manual:** quit Floe, then drag `Floe.app` out of `/Applications` to the Trash. To also remove preferences, delete `~/Library/Preferences/com.wudb.Floe.plist`.


## Gallery

These demonstrations come from the upstream project. Some images still show the upstream name or an older interface.

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


If you need a similar tool for macOS 13 Ventura or earlier, check out [Ice 0.11.x](https://github.com/jordanbaird/Ice/releases).


## Contributing

Contributions are welcome! Please read the [contribution guidelines](./Resources/document/CONTRIBUTING.md) before submitting a pull request.

Maintain new visible strings in both `Floe/Resources/en.lproj/Localizable.strings` and `Floe/Resources/zh-Hans.lproj/Localizable.strings`. Use localization keys in SwiftUI and `L10n.string` for native menus and alerts; keep persisted identifiers, application names, and upstream links unchanged.

## Support Upstream

<a href="https://ko-fi.com/calvados" target="_blank">
    <img src="https://storage.ko-fi.com/cdn/kofi5.png?v=6" alt="Support upstream on Ko-fi" style="height: 36px !important;width: 130px !important;">
</a>

<a href="https://www.paypal.com/paypalme/nnkhanh29" target="_blank">
    <img src="https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_200x51.png" alt="Donate with PayPal" style="height: 36px !important;">
</a>

Open **Edit Menu Bar Layout…** directly from the context menu in an empty menu bar area. Search accepts item and application names; use Up/Down or Control-N/Control-P to select a result, Return to open the selected result, and Escape to close.

In Menu Bar Layout, Tab focuses icons, Left/Right changes focus, Command-Left/Right reorders an icon, and Command-1/2/3 moves it to Visible/Hidden/Always Hidden. The context menu and VoiceOver actions expose the same operations. Protected system items cannot be moved or hidden where macOS disallows it.

Choose a destination and beginning/end position for **new menu bar items**. On first use, Floe keeps the current layout; changing this setting does not rearrange existing items. **Show all current icons** explicitly moves identifiable current items to Visible. If Always Hidden is disabled, new items assigned there use Hidden instead. Previously saved placement takes precedence over the default for new items. In an icon's context menu, **Always show this app** overrides its saved section until that rule is removed; removing the rule keeps the current placement and allows manual changes.

Automatic placement waits for menus to close and the pointer to stop moving. It requires supported item discovery and unique identities; ambiguous items keep their position. Temporary reveals do not become new placement choices. Confirmed manual layout changes and automatic placement choices are saved for later restoration.

If the Floe icon was removed, reopen Floe from Applications, then choose **Restore Floe icon** in General settings. Reopening intentionally keeps access to settings available even when the menu bar icon is missing.

## Floe Bar layouts and placement

In General settings, choose **Native menu bar**, **Floe Bar**, **Follow Use Floe Bar**, or **Adaptive** separately for Hidden and Always Hidden. Follow preserves the existing global switch and shortcut. For example, Hidden can stay in the native row while Always Hidden opens in the Floe Bar. Native Always Hidden still reveals Hidden because both sections share the same row.

Choose horizontal icons, a names list, or a grid. The grid supports 2–12 requested columns and reduces the column count on narrow displays; list and grid content scroll vertically and stay within the display's available area. Names and activation use the same discovered items as the existing bar, including the Accessibility fallback.

Right-click the bar background and choose **Reorder**, drag an icon onto another to insert it before that icon, or onto **Drop at end**. Click Done to return to normal menu activation. The actual native order is read back after a move; a rejected or stale move shows an error instead of saving a visual-only order. Closing the bar cancels the edit session. Protected items and missing/offscreen Accessibility frames cannot be forced into a new position.

After leaving Reorder mode, move the bar by its background, then right-click its background and choose **Pin position** to save the current position for that display. While pinned, later background drags update that display's position. Positions are stored relatively, so resizing or changing display scale does not reuse old pixel coordinates. An unfamiliar display starts at the available area's top-right. **Unpin position** restores the normal location rule. Pinning fixes placement; it does not keep the bar open or disable automatic rehide.

## Adaptive presentation

Select **Adaptive** for either hidden section in General settings, then expand **Adaptive presentation rules**. Choose the target display type (all, built-in, external or notched) and connected display count (any, one or multiple). Both scope conditions must match. Outside this scope, the section opens in the native menu bar.

By default, matching displays use Floe Bar only when the native row lacks continuous space beside application menus and the notch. Widths use logical points, including the visible and hidden icons that a native reveal would expose. Set the reserved space, or turn off the space condition to always use Floe Bar within the scope. Missing measurements and system menu bar auto-hide favor Floe Bar. A 48-point exit margin reduces repeated switching near the boundary.

Fixed section choices take priority. For Adaptive sections, a saved per-display override takes priority over full-screen rules, followed by display scope and space. Full-screen options are follow rules, native, Floe Bar, or do not reveal. Full-screen status belongs to the target display; unavailable Space metadata stays unknown. Normal use shows only the icon bar; the toolbar appears during Reorder.

Rules refresh after display/Space/frontmost-app changes and on a one-second measurement cycle. Outdated presentations close safely after menus, temporary reveals or reordering finish. The next user trigger chooses the new presentation; rules do not automatically show all icons or change saved visibility. Display overrides use persistent display UUIDs. This provides presentation rules, not independent native icon sets for every display.

## Acknowledgments

Floe is forked from [cavaldos/Ice](https://github.com/cavaldos/Ice), which is forked from [jordanbaird/Ice](https://github.com/jordanbaird/Ice) by [Jordan Baird](https://github.com/jordanbaird). Thanks to both upstream projects.

## License

[GPL-3.0](LICENSE) — Floe is and will always remain open-source and free.

## Star History

<a href="https://star-history.com/#wudb/Floe&Date">
    <img src="https://api.star-history.com/svg?repos=wudb/Floe&type=Date" alt="Star History Chart" width="500">
</a>
