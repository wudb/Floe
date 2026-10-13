//
//  AppLanguagePicker.swift
//  Floe
//

import SwiftUI

struct AppLanguagePicker: View {
    @Binding var selection: AppLanguage

    var body: some View {
        Picker("Language", selection: $selection) {
            Text("Follow System").tag(AppLanguage.system)
            Text(verbatim: "English").tag(AppLanguage.english)
            Text(verbatim: "简体中文").tag(AppLanguage.simplifiedChinese)
        }
        .pickerStyle(.menu)
        // 使用控件自身的边框和留白，让可见按钮范围与实际点击范围一致。
        .buttonStyle(.bordered)
        .controlSize(.regular)
        .tint(.primary)
        .font(.callout)
        .labelsHidden()
        .fixedSize()
    }
}
