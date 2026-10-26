//
//  MenuBarVisibilityRecoveryView.swift
//  Floe
//

import SwiftUI

/// 图标消失时仍可从“应用程序”再次打开设置，恢复入口不依赖菜单栏本身。
struct MenuBarVisibilityRecoveryView: View {
    @ObservedObject var manager: MenuBarManager
    @State private var needsIdleMenuBar = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("Recover Menu Bar Items") {
                needsIdleMenuBar = !manager.recoverMenuBarVisibility()
            }
            .annotation("Temporarily stops Floe from hiding items and restores its icon. Saved layouts and hiding preferences are kept.")
            if manager.isMenuBarRecoveryActive {
                Text("Menu bar recovery is active. Hiding stays paused until you resume it or restart Floe.")
                    .font(.caption).foregroundStyle(.secondary)
                Button("Resume Hiding") {
                    needsIdleMenuBar = !manager.resumeMenuBarHiding()
                }
            }
            if needsIdleMenuBar {
                Text("Close menus and finish moving items before restoring the layout.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
