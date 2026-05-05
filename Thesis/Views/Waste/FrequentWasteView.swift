//
//  FrequentWasteView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct FrequentWasteView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass

    @State private var selectedWaste: FrequentWasteItem? = nil
    @State private var currentPage = 1
    @StateObject private var vm = FrequentWasteViewModel()

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    let itemsPerPage = 6

    var sortedWasteItems: [FrequentWasteItem] { vm.wasteItems }

    var paginatedItems: [FrequentWasteItem] {
        let startIndex = (currentPage - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, sortedWasteItems.count)
        return Array(sortedWasteItems[startIndex..<endIndex])
    }

    var totalPages: Int {
        max(1, Int(ceil(Double(sortedWasteItems.count) / Double(itemsPerPage))))
    }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            VStack(spacing: 0) {

                WasteHeaderView(title: L("ขยะที่แยกทั้งหมด"), config: config)

                if vm.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: config.paddingMedium),
                                GridItem(.flexible(), spacing: config.paddingMedium)
                            ],
                            spacing: config.paddingMedium
                        ) {
                            ForEach(paginatedItems, id: \.self) { item in
                                FrequentWasteCard(item: item, config: config)
                                    .onTapGesture { selectedWaste = item }
                            }
                        }
                        .padding(.horizontal, config.paddingMedium)
                        .padding(.top, config.wasteGridTopPadding)
                    }

                    PaginationSection(
                        config: config,
                        currentPage: $currentPage,
                        totalPages: totalPages
                    )
                }
            }
            .edgesIgnoringSafeArea(.top)
            .ignoresSafeArea()
            .background(Color.backgroundColor)
            .navigationDestination(item: $selectedWaste) { waste in
                WasteTypeView(hideTabBar: .constant(true), category: waste.title)
                    .navigationBarBackButtonHidden(true)
            }
            .task { await vm.fetchWasteCounts() }
        }
    }
}

#Preview {
    FrequentWasteView()
}
