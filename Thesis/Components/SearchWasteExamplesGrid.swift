//
//  SearchWasteExamplesGrid.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct SearchWasteExamplesGrid: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    let wasteExamples: [WasteExample]

    var columns: [GridItem] {
        if config.isIPad {
            return [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20)
            ]
        } else {
            return [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 18)
            ]
        }
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: config.isIPad ? 20 : 10) {
            ForEach(wasteExamples) { example in
                NavigationLink {
                    DetailSearchView(hideTabBar: $hideTabBar, category: example.label)
                } label: {
                    WasteCard(config: config, example: example)
                }
            }
        }
        .padding(.top, config.isIPad ? 30 : 20)
    }
}
