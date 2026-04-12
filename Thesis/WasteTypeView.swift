//
//  WasteTypeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct WasteTypeItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let imageUrl: String?
}

struct WasteTypeView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @State private var currentPage = 1
    let category: String
    @StateObject private var vm = WasteTypeViewModel()

    let itemsPerPage = 5

    var totalPages: Int {
        max(1, Int(ceil(Double(vm.items.count) / Double(itemsPerPage))))
    }

    var pagedItems: [WasteTypeItem] {
        let start = (currentPage - 1) * itemsPerPage
        let end = min(start + itemsPerPage, vm.items.count)
        guard start < end else { return [] }
        return Array(vm.items[start..<end])
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

                    } else if vm.items.isEmpty {

                        // MARK: - Empty State
                        // ✅ ครอบ ScrollView เพื่อให้ scroll ได้ใน landscape
                        ScrollView {
                            VStack(spacing: config.spacingMedium) {
                                Image("ListEmpty")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: config.emptyStateImageSize,
                                           height: config.emptyStateImageSize)

                                Text("ไม่มีประวัติการแยกขยะ")
                                    .font(.noto(config.titleFontSize, weight: .bold))
                                    .foregroundColor(.textFieldColor)
                            }
                            // ✅ MinHeight ทำให้เนื้อหากลางจอบน portrait, scroll ได้บน landscape
                            .frame(maxWidth: .infinity,
                                   minHeight: geo.size.height - config.searchHeaderHeight)
                        }

                    } else {

                        // MARK: - Content
                        ScrollView {
                            VStack(spacing: 11) {
                                ForEach(pagedItems) { item in
                                    NavigationLink(destination: DetailView(hideTabBar: $hideTabBar)) {
                                        WasteItemCard(
                                            title: item.title,
                                            date: item.date,
                                            imageUrl: item.imageUrl,
                                            config: config
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }

                                paginationSection(config: config)
                            }
                            .padding(.horizontal, config.paddingMedium)
                            .padding(.top, config.wasteGridTopPadding)
                            .padding(.bottom, config.paddingMedium)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
            .onAppear { hideTabBar = true }
            .onDisappear { hideTabBar = false }
            .navigationBarHidden(true)
            .task { await vm.fetchItems(category: category) }
        }
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        ZStack {
            Color.mainColor
            ZStack {
                Text("ขยะแต่ละประเภท")
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.white)
                HStack {
                    BackButtonWhite()
                    Spacer()
                }
            }
            .padding(.top, config.headerTopPadding)
            .padding(.bottom, config.paddingStandard)
            .padding(.horizontal, config.paddingMedium)
        }
        .frame(height: config.searchHeaderHeight)
        .cornerRadius(config.bannerCornerRadius, corners: [.bottomLeft, .bottomRight])
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
        .frame(maxWidth: .infinity)
        .padding(.vertical, config.paddingMedium)
    }
}

// MARK: - WasteItemCard
struct WasteItemCard: View {
    let title: String
    let date: String
    let imageUrl: String?
    let config: ResponsiveConfig

    var body: some View {
        HStack(spacing: config.wasteItemCardSpacing) {
            if let urlString = imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.thirdColor
                }
                .frame(width: config.wasteItemImageWidth,
                       height: config.wasteItemImageHeight)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: config.wasteItemImageRadius))
            } else {
                RoundedRectangle(cornerRadius: config.wasteItemImageRadius)
                    .fill(Color.thirdColor)
                    .frame(width: config.wasteItemImageWidth,
                           height: config.wasteItemImageHeight)
            }

            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.noto(config.fontHeader, weight: .bold))
                    .foregroundColor(.black)
                Text(date)
                    .font(.noto(config.fontCaption, weight: .medium))
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .padding(.horizontal, config.paddingMedium)
        .frame(height: config.wasteItemCardHeight)
        .background(Color.thirdColor)
        .clipShape(RoundedRectangle(cornerRadius: config.bannerCornerRadius))
    }
}
