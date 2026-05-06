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

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    let itemsPerPage = 5

    var totalPages: Int { vm.totalPages(perPage: itemsPerPage) }
    var pagedItems: [WasteTypeItem] { vm.pagedItems(page: currentPage, perPage: itemsPerPage) }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            ZStack {
                VStack(spacing: 0) {
                    
                    WasteHeaderView(title: L("ขยะแต่ละประเภท"), config: config)
                    
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
                                
                                Text(L("ไม่มีประวัติการแยกขยะ"))
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
                                    NavigationLink(destination: HistoryWasteDetailView(
                                        hideTabBar: $hideTabBar,
                                        item: item
                                    )) {
                                        WasteItemCard(
                                            title: item.title,
                                            date: item.dateOnly,
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
                        
                        PaginationSection(
                            config: config,
                            currentPage: $currentPage,
                            totalPages: totalPages
                        )
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .ignoresSafeArea()
                
            }
            .background(Color.backgroundColor)
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
