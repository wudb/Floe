//
//  MenuBarItemAXDiscovery.swift
//  Floe
//

import ApplicationServices
import Carbon.HIToolbox
import Cocoa
import OSLog

/// Lists menu bar items via Accessibility (`AXExtrasMenuBar`).
///
/// This only needs Accessibility permission, not Screen Recording,
/// and still works when `CGSGetProcessMenuBarWindowList` no longer returns
/// per-item windows (macOS 27+) — the same approach Thaw uses.
enum MenuBarItemAXDiscovery {
    /// A menu bar item read via Accessibility.
    struct AXMenuBarItem: Hashable {
        /// Exact click target; identifiers and titles can be missing or shared by siblings.
        let element: AXUIElement

        /// Process identifier of the app owning the item. Used to fetch the app icon.
        let pid: pid_t

        /// Display name of the app owning the item.
        let appName: String

        /// Bundle identifier of the app owning the item.
        let bundleID: String?

        /// `AXIdentifier` of the item (e.g. `com.apple.menuextra.wifi`).
        let identifier: String?

        /// Title/description of the item (may be nil for icon-only items).
        let title: String?

        /// Raw frame of the item in AX coordinates (top-left origin).
        /// Convert to Cocoa coordinates when classifying.
        let axFrame: CGRect?

        /// MenuBarAgent 的宿主身份不能沿用旧 ControlCenter 窗口判断；用稳定系统标识保护不可移动项。
        var isMovable: Bool {
            !["com.apple.menuextra.clock", "com.apple.menuextra.controlcenter", "com.apple.menuextra.siri"].contains(identifier ?? "")
        }

        var canBeHidden: Bool {
            isMovable && ![
                "com.apple.menuextra.audiovideo", "com.apple.menuextra.facetime", "com.apple.menuextra.musicrecognition",
            ].contains(identifier ?? "")
        }

        /// Most descriptive name for display.
        var displayName: String {
            // AX 的占位名不能遮住可读的宿主名称；空字符串也需要回退。
            for candidate in [title, identifier] {
                guard let name = candidate?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !name.isEmpty,
                      name.range(of: "^Item-[0-9]+$", options: .regularExpression) == nil
                else { continue }
                return name
            }
            return appName
        }
    }

    /// The menubar group an item currently belongs to.
    enum SectionKind: Hashable {
        case visible
        case hidden
        case alwaysHidden
    }

    /// Classifies an item by its horizontal position relative to Floe's dividers.
    ///
    /// The X axis is identical in both AX and Cocoa coordinates (only the Y axis is flipped),
    /// so this works for both AX frames and CGS window frames.
    ///
    /// Each divider is evaluated independently so this stays correct when a section is disabled
    /// (its divider is nil): left of the Always-Hidden divider → alwaysHidden,
    /// left of the Hidden divider → hidden, otherwise → visible.
    ///
    /// - Parameters:
    ///   - centerX: X center of the item, nil when unreadable (falls back to Visible).
    ///   - hiddenDividerX: Left edge (minX) of the Hidden divider, nil when the section is disabled.
    ///   - alwaysHiddenDividerX: Left edge of the Always Hidden divider, nil when the section is disabled.
    static func classify(
        centerX: CGFloat?,
        hiddenDividerX: CGFloat?,
        alwaysHiddenDividerX: CGFloat?
    ) -> SectionKind {
        guard let centerX else {
            return .visible
        }
        let dividers = normalizedDividers(
            hiddenDividerX: hiddenDividerX,
            alwaysHiddenDividerX: alwaysHiddenDividerX
        )
        if let alwaysHiddenX = dividers.alwaysHidden, centerX < alwaysHiddenX {
            return .alwaysHidden
        }
        if let hiddenX = dividers.hidden, centerX < hiddenX {
            return .hidden
        }
        return .visible
    }

    /// Normalizes invalid swapped divider geometry for every section-boundary use.
    ///
    /// macOS 27 can leave the Always-Hidden divider right of the Hidden divider.
    /// Ignoring only that boundary for classification while using it for drop
    /// bounds would still target the wrong section.
    static func normalizedDividers(
        hiddenDividerX: CGFloat?,
        alwaysHiddenDividerX: CGFloat?
    ) -> (hidden: CGFloat?, alwaysHidden: CGFloat?) {
        if
            let alwaysHiddenDividerX,
            let hiddenDividerX,
            alwaysHiddenDividerX > hiddenDividerX
        {
            return (hiddenDividerX, nil)
        }
        return (hiddenDividerX, alwaysHiddenDividerX)
    }

    /// Returns true when the app has been granted Accessibility permission.
    static func isTrusted() -> Bool {
        AXIsProcessTrusted()
    }

    /// Icon of the current input source (the keyboard/layout indicator on the menubar).
    ///
    /// Used for the TextInputMenuAgent item — that app has no icon of its own,
    /// the real icon on the menubar is the current input source's icon.
    static func inputSourceIcon() -> NSImage? {
        let source = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
        guard let pointer = TISGetInputSourceProperty(source, kTISPropertyIconImageURL) else {
            return nil
        }
        let url = Unmanaged<CFURL>.fromOpaque(pointer).takeUnretainedValue() as URL
        return NSImage(contentsOf: url)
    }

    /// 新符号不可用的旧系统使用已支持的盾牌符号。
    private static let vpnSymbolName = NSImage(systemSymbolName: "network.badge.shield.half.filled", accessibilityDescription: nil) == nil
        ? "lock.shield" : "network.badge.shield.half.filled"

    /// 直接使用当前 macOS 的 VPN 菜单资源，保留原生轮廓和透明度，不将系统图形复制进应用。
    private static let nativeVPNIcon: NSImage? = {
        guard let bundle = Bundle(path: "/System/Library/CoreServices/Menu Extras/VPN.menu"),
              let url = bundle.url(forResource: "VPN0", withExtension: "pdf"),
              let image = NSImage(contentsOf: url) else { return nil }
        image.isTemplate = true
        return image
    }()

    static func systemIconImage(forIdentifier identifier: String?, title: String?, bundleID: String?) -> NSImage? {
        if identifier == "com.apple.menuextra.vpn" { return nativeVPNIcon }
        guard bundleID?.hasPrefix("com.apple.") == true, title?.lowercased() == "vpn" else { return nil }
        return nativeVPNIcon
    }

    /// 系统 VPN 有时只有名称，没有 AXIdentifier；名称回退限定在系统宿主，保留第三方应用自己的图标。
    static func systemImageName(for item: AXMenuBarItem) -> String? {
        systemImageName(forIdentifier: item.identifier) ?? systemImageName(forTitle: item.title, bundleID: item.bundleID)
    }

    /// 系统菜单项目按稳定标识映射符号，避免使用 MenuBarAgent 的通用宿主图标。
    static func systemImageName(forIdentifier identifier: String?) -> String? {
        switch identifier {
        case "com.apple.menuextra.wifi": "wifi"
        case "com.apple.menuextra.sound": "speaker.wave.2.fill"
        case "com.apple.menuextra.bluetooth": "bluetooth"
        case "com.apple.menuextra.battery": "battery.100"
        case "com.apple.menuextra.controlcenter": "switch.2"
        case "com.apple.menuextra.clock": "clock"
        case "com.apple.menuextra.spotlight": "magnifyingglass"
        case "com.apple.menuextra.airplay": "airplayvideo"
        case "com.apple.menuextra.vpn": nativeVPNIcon == nil ? vpnSymbolName : nil
        default: nil
        }
    }

    /// SF Symbol for a CGS menu bar item (no AX identifier available).
    ///
    /// Same intent as `systemImageName(forIdentifier:)`: ControlCenter /
    /// SystemUIServer extras share one host app, so `owningApplication.icon`
    /// is the same generic icon for Sound, Wi-Fi, Clock… — mapping the
    /// title keeps Visible stable across CGS/AX sources instead of
    /// flickering between a generic icon and an SF Symbol per refresh.
    /// Only applies to `com.apple.*` hosts so third-party apps keep
    /// their real icons.
    static func systemImageName(forTitle title: String?, bundleID: String?) -> String? {
        guard bundleID?.hasPrefix("com.apple.") == true else {
            return nil
        }
        switch title?.lowercased() ?? "" {
        case "wifi", "wi-fi": return "wifi"
        case "sound": return "speaker.wave.2.fill"
        case "bluetooth": return "bluetooth"
        case "battery", "batterymenu": return "battery.100"
        case "bentobox", "controlcenter", "control center": return "switch.2"
        case "clock": return "clock"
        case "spotlight": return "magnifyingglass"
        case "airplay", "screenmirroring", "screen mirroring": return "airplayvideo"
        case "vpn": return nativeVPNIcon == nil ? vpnSymbolName : nil
        default: return nil
        }
    }

    /// Lists all menu bar items of running apps.
    ///
    /// - Parameter apps: The apps to scan. Pass `NSWorkspace.shared.runningApplications`
    ///   from the main thread.
    /// - Returns: The item list, sorted by display name.
    static func discoverItems(in apps: [NSRunningApplication]) -> [AXMenuBarItem] {
        guard isTrusted() else {
            return []
        }
        // Drops Floe's own icons (the dividers) from the list.
        let ownBundleID = Bundle.main.bundleIdentifier
        var result = [AXMenuBarItem]()
        // 原应用的状态项优先；代理窗口只补充这些应用没有公开的项目。
        let orderedApps = apps.filter { $0.bundleIdentifier != "com.apple.MenuBarAgent" } +
            apps.filter { $0.bundleIdentifier == "com.apple.MenuBarAgent" }
        for app in orderedApps {
            guard app.bundleIdentifier != ownBundleID else {
                continue
            }
            // 每个宿主独立限制树遍历，不能让一个复杂宿主耗尽所有后续应用的额度。
            var visited = 0
            let sourceItems = result
            for item in items(for: app, visited: &visited) where !result.contains(where: { $0.pid == item.pid && CFEqual($0.element, item.element) }) {
                if app.bundleIdentifier == "com.apple.MenuBarAgent", sourceItems.contains(where: { source in
                    guard source.pid == item.pid, let original = source.axFrame, let proxy = item.axFrame,
                          !original.isEmpty, !proxy.isEmpty else { return false }
                    return abs(original.midX - proxy.midX) <= 1 && abs(original.midY - proxy.midY) <= 1
                }) { continue }
                result.append(item)
            }
        }
        return result.sorted {
            $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
        }
    }

    /// Presses (AXPress) the exact menu bar item retained during discovery.
    ///
    /// Used for the Floe Bar on macOS 27: with no CGS window left for temp-show +
    /// click, press directly via Accessibility and let the system open the menu.
    /// AXPress does not distinguish left/right — most extras ignore right-click,
    /// so the Floe Bar shares one action for both. Runs in the background (each app may
    /// block up to ~1s per the messaging timeout); returns true once pressed.
    ///
    /// If the element has become invalid, fail without pressing another item from its app.
    static func press(_ item: AXMenuBarItem) -> Bool {
        guard isTrusted() else {
            return false
        }
        AXUIElementSetMessagingTimeout(item.element, 1)
        let currentFrame = frame(of: item.element)
        os.Logger(subsystem: "com.float.floe", category: "AXDiscovery")
            .info("axPress geometry pid=\(item.pid) original=\(String(describing: item.axFrame), privacy: .public) current=\(String(describing: currentFrame), privacy: .public)")
        let result = AXUIElementPerformAction(item.element, kAXPressAction as CFString)
        os.Logger(subsystem: "com.float.floe", category: "AXDiscovery")
            .info("axPress result pid=\(item.pid) element=\(CFHash(item.element)) code=\(result.rawValue)")
        return result == .success
    }

    /// 原生整理需要真实屏内坐标，系统溢出按钮展开后才会将被遮挡图标放回可拖动的位置。
    /// 返回是否由本次调用改变状态，调用方只收回自己临时展开的溢出区。
    static func setOverflowExpanded(_ expanded: Bool, in apps: [NSRunningApplication]) -> Bool {
        guard isTrusted(), let app = apps.first(where: { $0.bundleIdentifier == "com.apple.MenuBarAgent" }) else { return false }
        let deadline = Date.now.addingTimeInterval(1)
        let axApp = AXUIElementCreateApplication(app.processIdentifier)
        AXUIElementSetMessagingTimeout(axApp, 0.1)
        var bar: AnyObject?
        guard AXUIElementCopyAttributeValue(axApp, "AXExtrasMenuBar" as CFString, &bar) == .success,
              let bar, CFGetTypeID(bar) == AXUIElementGetTypeID() else { return false }
        // swiftlint:disable:next force_cast
        let barElement = bar as! AXUIElement
        var button: AnyObject?
        var pending = [barElement]
        if AXUIElementCopyAttributeValue(barElement, "AXOverflowButton" as CFString, &button) == .success,
           let button, CFGetTypeID(button) == AXUIElementGetTypeID() {
            // swiftlint:disable:next force_cast
            pending.append(button as! AXUIElement)
        }
        let expected = expanded ? "menu-bar-overflow-indicator" : "menu-bar-overflow-indicator-expanded"
        var visited = 0
        while let element = pending.popLast(), visited < 64, Date.now < deadline {
            visited += 1
            let identifier = stringAttribute("AXIdentifier" as CFString, of: element)
            if identifier == expected {
                return AXUIElementPerformAction(element, kAXPressAction as CFString) == .success
            }
            if identifier == (expanded ? "menu-bar-overflow-indicator-expanded" : "menu-bar-overflow-indicator") { return false }
            let role = stringAttribute(kAXRoleAttribute as CFString, of: element)
            guard role != "AXMenu", role != "AXMenuItem" else { continue }
            var children: AnyObject?
            if AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &children) == .success {
                pending.append(contentsOf: children as? [AXUIElement] ?? [])
            }
        }
        return false
    }

    /// 共享菜单栏的占位帧可能指向另一应用，投递拖拽前必须检查鼠标实际命中的进程。
    @MainActor
    static func isItemAtPosition(_ item: AXMenuBarItem, point: CGPoint) -> Bool {
        let system = AXUIElementCreateSystemWide()
        AXUIElementSetMessagingTimeout(system, 0.1)
        var target: AXUIElement?
        guard AXUIElementCopyElementAtPosition(system, Float(point.x), Float(point.y), &target) == .success,
              let target else { return false }
        if CFEqual(target, item.element) { return true }
        var pid: pid_t = 0
        let result = AXUIElementGetPid(target, &pid) == .success && pid == item.pid
        os.Logger(subsystem: "com.float.floe", category: "AXDiscovery")
            .info("axDragHit expectedPID=\(item.pid) actualPID=\(pid) point=\(String(describing: point), privacy: .public) matches=\(result)")
        return result
    }

    /// Frames (in AX coordinates, same system as `AXMenuBarItem.axFrame`) of Floe's
    /// dividers, looked up via Accessibility.
    ///
    /// On macOS 27 `NSStatusItem.button.window.frame` returns the spacer's rect
    /// rather than the chevron position, so the Floe Bar cannot use it to classify
    /// sections. Dividers are identified by the `accessibilityIdentifier` set by
    /// ControlItem itself, so this lookup is exact and independent of window
    /// layout. It only reads our own app, so it is fast and safe to call in the background.
    ///
    /// - Note: When the spacer is expanded (section hidden), the divider's window is parked
    ///   offscreen and the returned frame is a junk rect (hundreds of pt wide, below
    ///   the bottom of the screen). Always filter via ``isSettledDividerFrame(_:)`` before
    ///   using `minX` for classification.
    static func dividerFrames() -> (hidden: CGRect?, alwaysHidden: CGRect?) {
        guard isTrusted() else {
            return (nil, nil)
        }
        let axApp = AXUIElementCreateApplication(NSRunningApplication.current.processIdentifier)
        AXUIElementSetMessagingTimeout(axApp, 1)

        var bar: AnyObject?
        guard
            AXUIElementCopyAttributeValue(axApp, "AXExtrasMenuBar" as CFString, &bar) == .success,
            let bar,
            CFGetTypeID(bar) == AXUIElementGetTypeID()
        else {
            return (nil, nil)
        }
        // swiftlint:disable:next force_cast
        let barElement = bar as! AXUIElement
        var visited = 0
        var found = [String: CGRect]()
        collectDividerFrames(from: barElement, depth: maxWalkDepth, visited: &visited, into: &found)
        found = found.filter { isSettledDividerFrame($0.value) }
        if #available(macOS 27, *), found["FloeHiddenDivider"] == nil || found["FloeAlwaysHiddenDivider"] == nil {
            // 分隔符进入系统溢出区后，原应用的 Extras 树会缺项；代理窗口仍提供带精确标识的按钮。
            for app in NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.MenuBarAgent") {
                let agent = AXUIElementCreateApplication(app.processIdentifier)
                AXUIElementSetMessagingTimeout(agent, 0.1)
                var windows: AnyObject?
                guard AXUIElementCopyAttributeValue(agent, kAXWindowsAttribute as CFString, &windows) == .success else { continue }
                visited = 0
                let deadline = Date.now.addingTimeInterval(1)
                for window in windows as? [AXUIElement] ?? [] {
                    guard let bounds = frame(of: window), bounds.height > 0, bounds.height <= 64 else { continue }
                    collectDividerFrames(from: window, depth: maxWalkDepth, visited: &visited, deadline: deadline, into: &found)
                }
            }
        }
        return (found["FloeHiddenDivider"], found["FloeAlwaysHiddenDivider"])
    }

    /// Whether an AX frame looks like a real divider in the menubar.
    ///
    /// An expanded spacer (hidden section) yields a WIDE frame (hundreds of pt), but minX still
    /// matches the chevron position and minY still falls within the menubar band — keep it to read
    /// minX for classification. Only discards junk frames parked offscreen (minY below the
    /// screen bottom, e.g. 986) or minX stuck at the left edge.
    static func isSettledDividerFrame(_ frame: CGRect) -> Bool {
        frame.minY <= 100 && frame.minX > 100
    }

    /// Collects frames of elements carrying Floe's `accessibilityIdentifier`.
    ///
    /// Mirrors `collectItems` (skips the `AXMenu`/`AXMenuItem` tree, descends at most
    /// `maxWalkDepth`), but records frames by identifier instead of building items.
    /// The identifier may live on the wrapper element or the inner button — takes the
    /// first frame found for each identifier.
    private static func collectDividerFrames(
        from element: AXUIElement,
        depth: Int,
        visited: inout Int,
        deadline: Date = Date.now.addingTimeInterval(1),
        into result: inout [String: CGRect]
    ) {
        guard depth > 0, visited < maxElementsVisited, Date.now < deadline else {
            return
        }
        visited += 1

        let role = stringAttribute(kAXRoleAttribute as CFString, of: element)

        guard role != "AXMenu", role != "AXMenuItem" else {
            return
        }

        if
            let identifier = stringAttribute("AXIdentifier" as CFString, of: element),
            identifier == "FloeHiddenDivider" || identifier == "FloeAlwaysHiddenDivider",
            result[identifier] == nil,
            let frame = frame(of: element)
        {
            result[identifier] = frame
        }

        var children: AnyObject?
        guard
            AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &children) == .success,
            let elements = children as? [AXUIElement]
        else {
            return
        }
        for child in elements {
            collectDividerFrames(from: child, depth: depth - 1, visited: &visited, deadline: deadline, into: &result)
        }
    }

    /// Maximum number of elements read from one application in a scan.
    private static let maxElementsVisited = 256

    /// Maximum depth when descending the AX tree.
    ///
    /// Real items usually sit at grandchild level (e.g. `AXGroup` → `AXMenuBarItem`
    /// inside MenuBarAgent), so this must descend instead of only reading direct
    /// children of `AXExtrasMenuBar`.
    private static let maxWalkDepth = 4

    /// Reads an app's `AXExtrasMenuBar`.
    private static func items(for app: NSRunningApplication, visited: inout Int) -> [AXMenuBarItem] {
        let axApp = AXUIElementCreateApplication(app.processIdentifier)
        // 单次 AX 消息采用短超时，整棵宿主树有独立时间预算，避免无响应宿主拖住后续发现。
        AXUIElementSetMessagingTimeout(axApp, 0.1)
        let deadline = Date.now.addingTimeInterval(1)

        var bar: AnyObject?
        guard
            AXUIElementCopyAttributeValue(axApp, "AXExtrasMenuBar" as CFString, &bar) == .success,
            let bar,
            CFGetTypeID(bar) == AXUIElementGetTypeID()
        else {
            return []
        }
        // swiftlint:disable:next force_cast
        let barElement = bar as! AXUIElement

        let appName = app.localizedName ?? app.bundleIdentifier ?? "Unknown"
        var result = [AXMenuBarItem]()
        collectItems(
            from: barElement,
            pid: app.processIdentifier,
            appName: appName,
            bundleID: app.bundleIdentifier,
            depth: maxWalkDepth,
            visited: &visited,
            deadline: deadline,
            into: &result
        )
        if app.bundleIdentifier == "com.apple.MenuBarAgent" {
            // 27 的 AXExtrasMenuBar 只含部分系统项目；第三方图标还挂在代理的菜单栏窗口下。
            // 限定菜单栏高度的窗口，继续共用宿主的节点/时间预算，避免遍历应用弹窗内容。
            var windows: AnyObject?
            if AXUIElementCopyAttributeValue(axApp, kAXWindowsAttribute as CFString, &windows) == .success {
                for window in windows as? [AXUIElement] ?? [] {
                    guard let bounds = frame(of: window), bounds.height > 0, bounds.height <= 64, bounds.width > bounds.height * 4 else { continue }
                    collectItems(
                        from: window,
                        pid: app.processIdentifier,
                        appName: appName,
                        bundleID: app.bundleIdentifier,
                        depth: maxWalkDepth,
                        visited: &visited,
                        deadline: deadline,
                        into: &result
                    )
                }
            }
            // 系统溢出按钮会随布局重建身份，不能把它当成应用图标不断加入隐藏缓存。
            var overflow: AnyObject?
            if AXUIElementCopyAttributeValue(barElement, "AXOverflowButton" as CFString, &overflow) == .success,
               let overflow, CFGetTypeID(overflow) == AXUIElementGetTypeID() {
                result.removeAll { CFEqual($0.element, overflow) }
            }
            // 某些 27 版本未返回 AXOverflowButton，但提供了系统按钮的本地化名称。
            result.removeAll { ["Show hidden menu bar items", "Show Hidden Menu Bar Items", "显示隐藏菜单栏项目", "顯示隱藏的選單列項目"].contains($0.title ?? "") }
        }
        return result
    }

    /// Collects items from an AX element.
    ///
    /// - `AXMenu`/`AXMenuItem` is dropdown content; skip the whole tree.
    /// - `AXMenuBarItem` is a real icon; record it immediately without descending.
    /// - Everything else (wrapper groups…) descends first; only records the outer
    ///   element when nothing inside is an item.
    private static func collectItems(
        from element: AXUIElement,
        pid: pid_t,
        appName: String,
        bundleID: String?,
        depth: Int,
        visited: inout Int,
        deadline: Date,
        into result: inout [AXMenuBarItem]
    ) {
        guard depth > 0, visited < maxElementsVisited, Date.now < deadline else {
            return
        }
        visited += 1

        let role = stringAttribute(kAXRoleAttribute as CFString, of: element)

        guard role != "AXMenu", role != "AXMenuItem" else {
            return
        }

        // 状态按钮本身才是拖拽/激活目标；不能下钻到其图片资源并把资源名当成额外图标。
        if role == "AXMenuBarItem" || role == "AXButton" {
            record(element, pid: pid, appName: appName, bundleID: bundleID, into: &result, recordNameless: true)
            return
        }

        var children: AnyObject?
        if
            AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &children) == .success,
            let elements = children as? [AXUIElement],
            !elements.isEmpty
        {
            let countBefore = result.count
            for child in elements {
                collectItems(from: child, pid: pid, appName: appName, bundleID: bundleID, depth: depth - 1, visited: &visited, deadline: deadline, into: &result)
            }
            // When a child is an item, skip the wrapper element.
            guard result.count == countBefore else {
                return
            }
        }

        // 超时截断子树后不能把未读完的 wrapper 冒充状态项。
        guard Date.now < deadline else { return }
        record(element, pid: pid, appName: appName, bundleID: bundleID, into: &result, recordNameless: false)
    }

    /// Records an element as an item when it has an identity.
    private static func record(
        _ element: AXUIElement,
        pid: pid_t,
        appName: String,
        bundleID: String?,
        into result: inout [AXMenuBarItem],
        recordNameless: Bool
    ) {
        let identifier = stringAttribute("AXIdentifier" as CFString, of: element)
        let title = stringAttribute(kAXTitleAttribute as CFString, of: element)
            ?? stringAttribute(kAXDescriptionAttribute as CFString, of: element)
            ?? stringAttribute(kAXHelpAttribute as CFString, of: element)

        // 27 的代理可能把自身控件作为代理子项返回，不能把恢复按钮/分隔符列成待隐藏应用。
        guard !["FloeIcon", "FloeHiddenDivider", "FloeAlwaysHiddenDivider", "menu-bar-overflow-indicator", "menu-bar-overflow-indicator-expanded"].contains(identifier ?? "") else { return }
        guard identifier != nil || title != nil || recordNameless else {
            return
        }
        // 代理窗口下的叶节点仍可能由原应用提供，用真实进程读取名称、图标与退出状态。
        var ownerPID = pid
        if bundleID == "com.apple.MenuBarAgent" {
            _ = AXUIElementGetPid(element, &ownerPID)
        }
        guard !result.contains(where: { $0.pid == ownerPID && CFEqual($0.element, element) }) else { return }
        let owner = ownerPID == pid ? nil : NSRunningApplication(processIdentifier: ownerPID)
        result.append(
            AXMenuBarItem(
                element: element,
                pid: ownerPID,
                appName: owner?.localizedName ?? appName,
                bundleID: owner?.bundleIdentifier ?? bundleID,
                identifier: identifier,
                title: stringAttribute(kAXRoleAttribute as CFString, of: element) == "AXImage"
                    ? owner?.localizedName ?? appName : title,
                axFrame: frame(of: element)
            )
        )
    }

    /// Reads an element's raw frame (AX coordinates), nil when absent.
    private static func frame(of element: AXUIElement) -> CGRect? {
        var position: AnyObject?
        var size: AnyObject?
        guard
            AXUIElementCopyAttributeValue(element, kAXPositionAttribute as CFString, &position) == .success,
            AXUIElementCopyAttributeValue(element, kAXSizeAttribute as CFString, &size) == .success,
            let position, let size,
            CFGetTypeID(position) == AXValueGetTypeID(),
            CFGetTypeID(size) == AXValueGetTypeID()
        else {
            return nil
        }
        // swiftlint:disable:next force_cast
        let positionValue = position as! AXValue
        // swiftlint:disable:next force_cast
        let sizeValue = size as! AXValue
        var point = CGPoint.zero
        var cgSize = CGSize.zero
        guard
            AXValueGetValue(positionValue, .cgPoint, &point),
            AXValueGetValue(sizeValue, .cgSize, &cgSize)
        else {
            return nil
        }
        return CGRect(origin: point, size: cgSize)
    }

    /// Reads a string attribute of an AX element, nil when missing/on error.
    private static func stringAttribute(_ attribute: CFString, of element: AXUIElement) -> String? {
        var value: AnyObject?
        guard AXUIElementCopyAttributeValue(element, attribute, &value) == .success,
              let string = value as? String,
              !string.isEmpty
        else {
            return nil
        }
        return string
    }
}
