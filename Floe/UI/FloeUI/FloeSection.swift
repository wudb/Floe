//
//  FloeSection.swift
//  Floe
//

import SwiftUI

struct FloeSectionOptions: OptionSet {
    let rawValue: Int

    static let isBordered = FloeSectionOptions(rawValue: 1 << 0)

    static let plain: FloeSectionOptions = []
    static let `default`: FloeSectionOptions = [.isBordered]
}

struct FloeSection<Header: View, Content: View, Footer: View>: View {
    private let header: Header
    private let content: Content
    private let footer: Footer
    private let spacing: CGFloat
    private let options: FloeSectionOptions

    private var isBordered: Bool { options.contains(.isBordered) }

    init(
        spacing: CGFloat = 10,
        options: FloeSectionOptions = .default,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.spacing = spacing
        self.options = options
        self.header = header()
        self.content = content()
        self.footer = footer()
    }

    init(
        spacing: CGFloat = 10,
        options: FloeSectionOptions = .default,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header == EmptyView {
        self.init(spacing: spacing, options: options) {
            EmptyView()
        } content: {
            content()
        } footer: {
            footer()
        }
    }

    init(
        spacing: CGFloat = 10,
        options: FloeSectionOptions = .default,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) where Footer == EmptyView {
        self.init(spacing: spacing, options: options) {
            header()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        spacing: CGFloat = 10,
        options: FloeSectionOptions = .default,
        @ViewBuilder content: () -> Content
    ) where Header == EmptyView, Footer == EmptyView {
        self.init(spacing: spacing, options: options) {
            EmptyView()
        } content: {
            content()
        } footer: {
            EmptyView()
        }
    }

    init(
        _ title: LocalizedStringKey,
        spacing: CGFloat = 10,
        options: FloeSectionOptions = .default,
        @ViewBuilder content: () -> Content
    ) where Header == Text, Footer == EmptyView {
        self.init(spacing: spacing, options: options) {
            Text(title)
                .font(.headline)
        } content: {
            content()
        }
    }

    var body: some View {
        if isBordered {
            FloeGroupBox(padding: spacing) {
                header
            } content: {
                content
                    .frame(maxWidth: .infinity)
            } footer: {
                footer
            }
        } else {
            VStack(alignment: .leading) {
                header
                content
                    .frame(maxWidth: .infinity)
                footer
            }
        }
    }
}
