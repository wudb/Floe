//
//  NewItemRulesView.swift
//  Floe
//

import SwiftUI

/// 设置变更只影响未来的新项；批量改变已有项目必须通过单独的显式按钮。
struct NewItemRulesView: View {
    @ObservedObject var rules: MenuBarNewItemRules
    let manager: MenuBarItemManager
    @State private var isApplying = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Picker("New menu bar items", selection: Binding(get: { rules.destination }, set: { rules.destination = $0 })) {
                    ForEach(MenuBarNewItemRules.Destination.allCases, id: \.self) { destination in
                        Text(LocalizedStringKey(destination.title)).tag(destination)
                    }
                }
                Picker("Position in section", selection: Binding(get: { rules.insertAtEnd }, set: { rules.insertAtEnd = $0 })) {
                    Text("Beginning").tag(false)
                    Text("End").tag(true)
                }
            }
            Text("Existing items keep their saved placement. If Always Hidden is disabled, new items use Hidden instead.")
                .font(.caption).foregroundStyle(.secondary)
            Text("Automatic placement only moves uniquely identifiable items. Ambiguous items keep their current position.")
                .font(.caption).foregroundStyle(.secondary)
            Text("Automatic placement waits until menus are closed and the pointer is idle.")
                .font(.caption).foregroundStyle(.secondary)
            HStack {
                Button("Show all current icons") {
                    isApplying = true
                    Task {
                        await manager.showAllExistingItems()
                        isApplying = false
                    }
                }
                .disabled(isApplying || manager.itemCache.allItems.isEmpty)
                if isApplying { ProgressView().controlSize(.small) }
            }
            if manager.isItemDiscoveryUnavailable {
                Text("Automatic placement requires menu bar item discovery. You can still arrange icons manually below.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
