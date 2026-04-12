//
//  FrequentWasteView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct WasteItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let count: String
}

struct FrequentWasteView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass

    @State private var selectedWaste: WasteItem? = nil
    @State private var currentPage = 1
    @StateObject private var vm = FrequentWasteViewModel()

    let itemsPerPage = 6

    var sortedWasteItems: [WasteItem] { vm.wasteItems }

    func extractNumber(_ text: String) -> Int {
        Int(text.replacingOccurrences(of: " ครั้ง", with: "")) ?? 0
    }

    var paginatedItems: [WasteItem] {
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

            ZStack {
                Color.backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {

                    headerView(config: config)

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
                                    WasteCardView(item: item, config: config)
                                        .onTapGesture { selectedWaste = item }
                                }
                            }
                            .padding(.horizontal, config.paddingMedium)
                            .padding(.top, config.wasteGridTopPadding)                    
                        }

                        paginationSection(config: config)
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationDestination(item: $selectedWaste) { waste in
                WasteTypeView(hideTabBar: .constant(true), category: waste.title)
                    .navigationBarBackButtonHidden(true)
            }
            .task { await vm.fetchWasteCounts() }
        }
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        ZStack {
            Color.mainColor

            ZStack {
                Text("ขยะที่แยกทั้งหมด")
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.white)

                HStack {
                    BackButtonWhite()
                    Spacer()
                }
            }
            .padding(.top, config.headerTopPadding)
            .padding(.bottom, config.paddingStandard)
        }
        .frame(height: config.searchHeaderHeight)
        .cornerRadius(config.bannerCornerRadius,
                      corners: [.bottomLeft, .bottomRight])
    }

    // MARK: - Pagination
    private func paginationSection(config: ResponsiveConfig) -> some View {
        HStack(spacing: config.paginationSpacing) {
            Button(action: { if currentPage > 1 { currentPage -= 1 } }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(currentPage == 1 ? .gray : Color.mainColor)
                    .font(.system(size: config.fontHeader))
            }
            .disabled(currentPage == 1)

            ForEach(1...totalPages, id: \.self) { page in
                Button(action: { currentPage = page }) {
                    Text("\(page)")
                        .font(.noto(config.fontBody, weight: .medium))
                        .foregroundColor(currentPage == page ? .white : Color.mainColor)
                        .frame(width: config.paginationButtonSize,
                               height: config.paginationButtonSize)
                        .background(currentPage == page ? Color.mainColor : Color.clear)
                        .clipShape(Circle())
                }
            }

            Button(action: { if currentPage < totalPages { currentPage += 1 } }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(currentPage == totalPages ? .gray : Color.mainColor)
                    .font(.system(size: config.fontHeader))
            }
            .disabled(currentPage == totalPages)
        }
        .padding(.vertical, config.paddingMedium)
    }
}

// MARK: - WasteCardView
struct WasteCardView: View {
    let item: WasteItem
    let config: ResponsiveConfig

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: config.itemCardImageHeight)
            }
            .frame(maxWidth: .infinity)
            .frame(height: config.wasteCardImageZStackHeight)

            VStack(spacing: 4) {
                Text(item.title)
                    .font(.noto(config.fontCaption, weight: .semibold))
                    .foregroundColor(.black)

                Text(item.count)
                    .font(.noto(config.fontSmall, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.bottom, config.paddingMedium)
        }
        .frame(height: config.wasteCardTotalHeight)
        .background(Color.thirdColor)
        .cornerRadius(config.bannerCornerRadius)
    }
}

#Preview {
    FrequentWasteView()
}
