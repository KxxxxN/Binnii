//
//  WasteTypeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct WasteTypeView: View {

    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @State private var currentPage = 1
    let category: String
    @StateObject private var vm = WasteTypeViewModel()

    let itemsPerPage = 5

    var totalPages: Int {
        vm.totalPages(perPage: itemsPerPage)
    }

    var pagedItems: [WasteTypeItem] {
        vm.pagedItems(page: currentPage, perPage: itemsPerPage)
    }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            ZStack {
                Color.backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {

                    WasteHeaderView(title: "ขยะแต่ละประเภท", config: config)

                    if vm.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()

                    } else if vm.items.isEmpty {

                        // MARK: - Empty State
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
                            .frame(maxWidth: .infinity,
                                   minHeight: geo.size.height - config.searchHeaderHeight)
                        }

                    } else {

                        // MARK: - Content
                        ScrollView {
                            VStack(spacing: 11) {
                                ForEach(pagedItems) { item in
                                    NavigationLink(destination: DetailWasteTypeView(hideTabBar: $hideTabBar, category: item.title)) {
                                        WasteItemCard(
                                            title: item.title,
                                            date: item.date,
                                            imageUrl: item.imageUrl,
                                            config: config
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, config.paddingMedium)
                            .padding(.top, config.wasteGridTopPadding)
                            .padding(.bottom, config.paddingMedium)
                        }
                        PaginationSection(config: config, currentPage: $currentPage, totalPages: totalPages)

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
}

#Preview {
    NavigationStack {
        WasteTypeView(hideTabBar: .constant(false), category: "ขยะทั่วไป")
    }
}
