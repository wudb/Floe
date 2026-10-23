//
//  LayoutImportSettingsPane.swift
//  Floe
//

import Cocoa
import SwiftUI
import UniformTypeIdentifiers

/// 文件只读解析，预览确认后才保存；离开页面取消任务，迟到的扫描不能重新发布预览。
struct LayoutImportSettingsPane: View {
    @EnvironmentObject var appState: AppState
    @State private var source = LayoutImportDocument.Source.ice
    @State private var document: LayoutImportDocument?
    @State private var listPath = ""
    @State private var destination = LayoutImportDocument.Section.hidden
    @State private var items = [LayoutImportDocument.Item]()
    @State private var selected = Set<UUID>()
    @State private var snapshot: MenuBarItemManager.ImportSnapshot?
    @State private var knownBundles = Set<String>()
    @State private var task: Task<Void, Never>?
    @State private var isBusy = false
    @State private var status: String?
    @State private var hasBackup = false
    @State private var filename = ""
    @State private var isVisible = false

    private var plan: LayoutImportPlan {
        LayoutImportPlan(items: items, available: snapshot?.items ?? [], knownBundles: knownBundles, alwaysShownBundles: snapshot?.alwaysShownBundles ?? [])
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Import app sections and order. Apps not listed keep their existing layout.")
                    .foregroundStyle(.secondary)
                sourceControls
                if let document, !document.lists.isEmpty { listControls(document) }
                if !items.isEmpty { preview }
                if let status {
                    Text(status).font(.callout).foregroundStyle(.secondary).textSelection(.enabled)
                }
                HStack {
                    Button("Undo Last Import") {
                        run {
                            guard checkOtherManagers() else { return }
                            try await appState.itemManager.undoLayoutImport()
                            snapshot = nil
                            status = appState.itemManager.layoutRecoveryStatus
                        }
                    }
                        .disabled(!hasBackup || isBusy)
                    Spacer()
                    if isBusy {
                        ProgressView().controlSize(.small)
                        Button("Cancel") { task?.cancel() }
                    }
                    Button("Refresh Preview") { refresh() }.disabled(items.isEmpty || isBusy)
                    Button("Import Selected Layout") { apply() }
                        .disabled(isBusy || snapshot == nil || !plan.rows.contains { $0.key != nil && selected.contains($0.id) })
                }
                Text("Imported apps follow source order at the beginning of each section. Always Hidden stays pending while that section is disabled. A backup is saved before each import.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .padding(24)
        }
        .buttonStyle(FloeButtonStyle())
        .onAppear { isVisible = true; hasBackup = appState.itemManager.hasLayoutImportBackup }
        .onDisappear { isVisible = false; task?.cancel() }
        .onChange(of: source) { _, _ in
            document = nil
            items = []
            selected = []
            snapshot = nil
            status = nil
            filename = ""
        }
    }

    private var sourceControls: some View {
        VStack(alignment: .leading, spacing: 10) {
            Picker("Import from", selection: $source) {
                ForEach(LayoutImportDocument.Source.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .disabled(isBusy)
            Text(LocalizedStringKey(sourceHelp)).font(.caption).foregroundStyle(.secondary)
            HStack {
                if source == .ice {
                    Button("Capture Ice Layout") {
                        run {
                            items = try appState.itemManager.captureIceLayout()
                            try await loadPreview()
                        }
                    }
                } else {
                    Button("Choose Configuration…") { chooseFile() }
                }
                Text(filename).font(.caption).lineLimit(1).truncationMode(.middle)
            }
            .disabled(isBusy)
        }
    }

    private var sourceHelp: String {
        switch source {
        case .ice:
            "Ice preferences do not save icon layouts. Keep Ice running with its original dividers, capture the current layout, then quit Ice before importing. Only readable icons on that menu bar are captured."
        case .bartender:
            "Choose a Bartender preferences plist with ProfileSettings/activeProfile. Other exports require selecting an app list and confirming its destination. Review that source order is left to right."
        case .barbee:
            "Assisted import: choose a JSON or plist export, select its ordered app list, and confirm the destination section. Encrypted or undocumented backup formats require a readable export."
        case .extraBar:
            "Assisted import: export a preset as JSON in ExtraBar, select its app list, and choose a Floe section. Only matching menu bar apps are migrated; folders, links, scripts and widgets are omitted."
        }
    }

    private func listControls(_ document: LayoutImportDocument) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Picker("App list", selection: $listPath) {
                ForEach(document.lists) { list in
                    Text("\(list.path) (\(list.identities.count))").tag(list.path)
                }
            }
            Picker("Destination section", selection: $destination) {
                ForEach(LayoutImportDocument.Section.allCases, id: \.self) { Text(LocalizedStringKey($0.title)).tag($0) }
            }
            Button("Add List to Preview") {
                guard let list = document.lists.first(where: { $0.path == listPath }) else { return }
                guard items.count + list.identities.count <= 2_000 else {
                    status = L10n.string("The preview supports up to 2,000 app entries. Clear it before adding another list.")
                    return
                }
                items += list.identities.map { LayoutImportDocument.Item(identity: $0, section: destination) }
                status = L10n.string("Added %d apps; %d non-app records were omitted.", list.identities.count, list.omittedCount)
                refresh(clearStatus: false)
            }
            Text("Select one list per section or preset. Confirm the order and section below before importing.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .disabled(isBusy)
    }

    private var preview: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Layout Preview").font(.headline)
                Spacer()
                Button("Reverse Order") { items.reverse() }
                Button("Clear Preview") { items = []; selected = []; snapshot = nil }
            }
            ForEach(plan.rows) { row in
                HStack(alignment: .top, spacing: 8) {
                    Toggle("Select item", isOn: Binding(
                        get: { selected.contains(row.id) && row.key != nil },
                        set: { if $0 { selected.insert(row.id) } else { selected.remove(row.id) } }
                    ))
                    .labelsHidden().disabled(row.key == nil)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(row.item.identity).lineLimit(2).textSelection(.enabled)
                        Text(LocalizedStringKey(row.status)).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 4)
                    Picker("Destination section", selection: Binding(
                        get: { row.item.section },
                        set: { section in
                            if let index = items.firstIndex(where: { $0.id == row.id }) { items[index].section = section }
                        }
                    )) {
                        ForEach(LayoutImportDocument.Section.allCases, id: \.self) { Text(LocalizedStringKey($0.title)).tag($0) }
                    }
                    .labelsHidden().frame(width: 145)
                    Button {
                        items.removeAll { $0.id == row.id }
                        selected.remove(row.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .help("Remove from Preview")
                    .accessibilityLabel("Remove from Preview")
                }
                Divider()
            }
        }
        .disabled(isBusy)
    }

    private func chooseFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json, .propertyList, .xml]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        // Sheet 回调不持有异步读回；取消选择不会改变现有预览。
        guard let window = NSApp.keyWindow else { return }
        panel.beginSheetModal(for: window) { response in
            guard isVisible, response == .OK, let url = panel.url else { return }
            run {
                let selectedSource = source
                let worker = Task.detached(priority: .userInitiated) {
                    let size = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
                    guard size <= 10 * 1024 * 1024 else { throw LayoutImportDocument.Failure.tooLarge }
                    let data = try Data(contentsOf: url, options: [.mappedIfSafe])
                    try Task.checkCancellation()
                    return try LayoutImportDocument.read(data, source: selectedSource)
                }
                let parsed = try await withTaskCancellationHandler {
                    try await worker.value
                } onCancel: {
                    worker.cancel()
                }
                try Task.checkCancellation()
                document = parsed
                filename = url.lastPathComponent
                listPath = parsed.lists.first?.path ?? ""
                items = parsed.items
                selected = []
                snapshot = nil
                if !items.isEmpty { try await loadPreview() }
            }
        }
    }

    private func loadPreview() async throws {
        let fresh = try await appState.itemManager.layoutImportSnapshot()
        try Task.checkCancellation()
        snapshot = fresh
        knownBundles = appState.itemManager.knownImportBundles(for: items)
        selected = Set(plan.rows.filter { $0.key != nil }.map(\.id))
    }

    private func refresh(clearStatus: Bool = true) {
        run(clearStatus: clearStatus) { try await loadPreview() }
    }

    private func apply() {
        guard let snapshot else { return }
        run {
            guard checkOtherManagers() else { return }
            try await appState.itemManager.importLayout(items: items, selected: selected, snapshot: snapshot)
            self.snapshot = nil
            status = appState.itemManager.layoutRecoveryStatus
        }
    }

    /// 读取允许来源工具继续运行；真正移动和撤销前要求退出，避免两个管理器争抢布局。
    private func checkOtherManagers() -> Bool {
        let bundles = ["com.jordanbaird.Ice", "com.HyperartFlow.Barbee", "com.appit.ExtraBar"]
        let active = NSWorkspace.shared.runningApplications.contains {
            let bundle = $0.bundleIdentifier ?? ""
            return bundles.contains(bundle) || bundle.hasPrefix("com.surteesstudios.Bartender")
        }
        guard !active else {
            status = L10n.string("Quit Ice, Barbee, ExtraBar and Bartender before applying or undoing an import, then refresh the preview.")
            return false
        }
        return true
    }

    private func run(clearStatus: Bool = true, _ operation: @escaping @MainActor () async throws -> Void) {
        guard isVisible, !isBusy else { return }
        isBusy = true
        if clearStatus { status = nil }
        task = Task { @MainActor in
            defer { isBusy = false; hasBackup = appState.itemManager.hasLayoutImportBackup }
            do {
                try await operation()
                if Task.isCancelled, isVisible { status = L10n.string("Operation cancelled. Saved layout choices were kept.") }
            } catch is CancellationError {
                // 页面离开后不发布迟到结果，已保存的选择仍可由布局恢复入口继续执行。
                if isVisible { status = L10n.string("Operation cancelled. Saved layout choices were kept.") }
            } catch let error as LayoutImportDocument.Failure {
                status = L10n.string(error.rawValue)
            } catch {
                status = L10n.string("Could not read or import the configuration: %@", error.localizedDescription)
            }
        }
    }
}
