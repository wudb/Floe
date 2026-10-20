//
//  ApplicationIcon.swift
//  Floe
//

import AppKit

/// 从当前应用包读取图标，避免同一路径覆盖安装后继续使用系统缓存中的旧图。
@MainActor
enum ApplicationIcon {
    static let image = load(from: .main) ?? NSImage(named: NSImage.applicationIconName) ?? NSImage()

    /// 界面和 Dock 共用同一份资源；启动时显式设置，覆盖 Launch Services 的旧缓存。
    static func apply() {
        NSApp.applicationIconImage = image
    }

    static func load(from bundle: Bundle) -> NSImage? {
        guard let iconFile = bundle.object(forInfoDictionaryKey: "CFBundleIconFile") as? String,
              !iconFile.isEmpty else {
            return nil
        }
        let filename = iconFile as NSString
        let fileExtension = filename.pathExtension.isEmpty ? "icns" : filename.pathExtension
        let resourceName = filename.pathExtension.isEmpty ? iconFile : filename.deletingPathExtension
        guard let url = bundle.url(forResource: resourceName, withExtension: fileExtension) else {
            return nil
        }
        // contentsOf 绕过 NSImage 的命名图像缓存，读取本次构建实际打包的文件。
        return NSImage(contentsOf: url)
    }
}
