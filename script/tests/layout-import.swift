import Foundation

// 编译实际解析与匹配代码；仅使用合成配置，不读取用户配置或发送系统输入。
let repo = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
let directory = FileManager.default.temporaryDirectory.appendingPathComponent("floe-import-\(UUID().uuidString)")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
defer { try? FileManager.default.removeItem(at: directory) }
let production = try ["LayoutImportDocument", "LayoutImportPlan"].map {
    try String(contentsOf: repo.appendingPathComponent("Floe/MenuBar/LayoutImport/\($0).swift"), encoding: .utf8)
}.joined(separator: "\n")
let checks = #"""
@main struct Checks {
    static func main() throws {
        typealias Document = LayoutImportDocument
        func data(_ value: Any) throws -> Data { try JSONSerialization.data(withJSONObject: value) }
        let profile: [String: Any] = ["ProfileSettings": ["activeProfile": [
            "Show": ["com.example.one-Item-0"], "Hide": ["com.example.two"], "AlwaysHide": ["com.example.three"],
        ]]]
        let json = try Document.read(data(profile), source: .bartender)
        let binary = try PropertyListSerialization.data(fromPropertyList: profile, format: .binary, options: 0)
        let plist = try Document.read(binary, source: .bartender)
        precondition(json.items.map(\.identity) == plist.items.map(\.identity))
        precondition(plist.items.map(\.section) == [.visible, .hidden, .alwaysHidden])
        precondition(plist.lists.isEmpty)
        do { _ = try Document.read(data(["ProfileSettings": ["activeProfile": ["Hide": [true]]]]), source: .bartender); fatalError("wrong field type accepted") }
        catch Document.Failure.invalid {}
        do { _ = try Document.read(data(["UseIceBar": true]), source: .ice); fatalError("Ice prefs became a layout") }
        catch Document.Failure.icePreferences {}
        for source in [Document.Source.barbee, .extraBar] {
            let exported = try Document.read(data(["presets": [["name": "work", "items": [
                ["bundleID": "com.example.two"], ["bundleID": "com.example.one"],
                ["type": "script", "command": "echo com.example.evil"], ["type": "link", "url": "https://com.example.fake"],
            ]]]]), source: source)
            let list = exported.lists.first!
            precondition(list.identities == ["com.example.two", "com.example.one"] && list.omittedCount == 2)
            precondition(exported.items.isEmpty, "assisted lists must not silently choose a section")
        }
        let embedded = try PropertyListSerialization.data(fromPropertyList: ["layout": data(["apps": ["com.example.one"]])], format: .binary, options: 0)
        let embeddedDocument = try Document.read(embedded, source: .barbee)
        precondition(embeddedDocument.lists.first?.identities == ["com.example.one"])
        for invalid in [Data("invalid".utf8), try data(["command": "com.example.app"])] {
            do { _ = try Document.read(invalid, source: .extraBar); fatalError("unstructured config accepted") } catch is Document.Failure {}
        }
        do { _ = try Document.read(Data(repeating: 32, count: 10 * 1024 * 1024 + 1), source: .extraBar); fatalError("oversize accepted") }
        catch Document.Failure.tooLarge {}
        precondition(!Document.isBundleIdentifier("https://example.com"))
        precondition(!Document.isBundleIdentifier("com.example.app; rm -rf ~"))
        print("PASS: actual Bartender profile JSON/binary plist, Ice preference rejection, assisted Barbee/ExtraBar lists, omitted scripts/URLs, embedded JSON and input bounds")

        func live(_ key: String, _ bundle: String, _ title: String = "", movable: Bool = true, hideable: Bool = true, always: Bool = false) -> LayoutImportPlan.AvailableItem {
            .init(key: key, bundleIdentifier: bundle, title: title, isMovable: movable, canBeHidden: hideable, alwaysShown: always)
        }
        let available = [
            live("com.example.one", "com.example.one"),
            live("com.example.hyphen-app", "com.example.hyphen-app"),
            live("com.example.multi:left", "com.example.multi", "left"),
            live("com.example.multi:right", "com.example.multi", "right"),
            live("", "com.example.ambiguous", "Item-0"), live("", "com.example.ambiguous", "Item-1"),
            live("com.example.protected", "com.example.protected", movable: false),
            live("com.example.visible", "com.example.visible", hideable: false),
            live("com.example.rule", "com.example.rule", always: true),
        ]
        func row(_ raw: String, section: Document.Section = .hidden) -> LayoutImportPlan.Row {
            LayoutImportPlan(items: [.init(identity: raw, section: section)], available: available, knownBundles: [], alwaysShownBundles: ["com.example.offlineRule"]).rows[0]
        }
        precondition(row("com.example.one-Item-0").key == "com.example.one")
        precondition(row("com.example.hyphen-app-Item-0").key == "com.example.hyphen-app")
        precondition(row("com.example.multi-left").key == "com.example.multi:left")
        precondition(row("com.example.multi").key == nil)
        precondition(row("com.example.multi-Item-0").key == nil)
        precondition(row("com.example.ambiguous").key == nil)
        precondition(row("com.example.protected").key == nil)
        precondition(row("com.example.visible").key == nil)
        precondition(row("com.example.visible", section: .visible).key != nil)
        precondition(row("com.example.rule").key == nil)
        precondition(row("com.example.offlineRule").key == nil)
        precondition(row("com.example.offline").key == "com.example.offline")
        precondition(row("com.apple.controlcenter").key == nil)
        precondition(row("AllOtherItems").key == nil)
        precondition(row("com.float.floe").key == nil)
        let duplicates = LayoutImportPlan(items: [
            .init(identity: "com.example.one", section: .visible), .init(identity: "com.example.one-Item-0", section: .hidden),
        ], available: available, knownBundles: [])
        precondition(duplicates.rows.allSatisfy { $0.key == nil })
        print("PASS: stable single/multiple app identities, hyphenated bundles, ambiguity/protection/rule conflicts, unavailable apps, special tokens and duplicate destinations")
    }
}
"""#
let file = directory.appendingPathComponent("Checks.swift")
try (production + "\n" + checks).write(to: file, atomically: true, encoding: .utf8)
let executable = directory.appendingPathComponent("checks").path
for arguments in [["swiftc", "-parse-as-library", file.path, "-o", executable], [executable]] {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    try process.run()
    process.waitUntilExit()
    guard process.terminationStatus == 0 else { exit(process.terminationStatus) }
}
