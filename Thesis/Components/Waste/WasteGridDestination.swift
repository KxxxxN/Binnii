//
//  WasteGridDestination.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

import SwiftUI

enum WasteGridDestination {
    case wasteType
    case search
}

struct WasteExamplesGrid: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    let wasteExamples: [WasteExample]
    var destination: WasteGridDestination = .wasteType
    var onSaveSuccess: (() -> Void)? = nil

    private var columns: [GridItem] {
        config.isIPad
            ? [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
            : [GridItem(.flexible(), spacing: 8),  GridItem(.flexible(), spacing: 18)]
    }

    private var spacing: CGFloat {
        destination == .search
            ? (config.isIPad ? 20 : 10)
            : config.knowledgeGridSpacing
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(wasteExamples) { example in
                NavigationLink {
                    if destination == .search {
                        DetailSearchView(hideTabBar: $hideTabBar, category: example.label)
                    } else {
                        DetailWasteTypeView(hideTabBar: $hideTabBar, category: example.label)
                    }
                } label: {
                    KnowledgeWasteCard(config: config, example: example)
                }
            }
        }
        .padding(.top, destination == .search ? (config.isIPad ? 30 : 20) : 0)
    }
}
