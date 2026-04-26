//
//  SearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    @Binding var currentTab: ScanTab
    @Binding var slideDirection: Int

    @StateObject private var vm = SearchViewModel()
    @ObservedObject private var lm = LanguageManager.shared
    @State private var selectedTabnavigationItem = 2
    @FocusState private var isSearchFocused: Bool

    private func switchTab(to tab: ScanTab) {
        slideDirection = tab.rawValue > currentTab.rawValue ? -1 : 1
        currentTab = tab
    }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

            ZStack(alignment: .bottom) {

                VStack(spacing: 0) {
                    SearchHeaderView(config: config)

                    ZStack(alignment: .top) {
                        ScrollView {
                            WasteExamplesGrid(
                                config: config,
                                hideTabBar: $hideTabBar,
                                wasteExamples: WasteData.allExamples(lm: lm),
                                destination: .search
                            )
                            .padding(.horizontal, config.isIPad ? 60 : 35)
                            .padding(.top, 90)
                        }
                        .scrollDismissesKeyboard(.immediately)
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: config.isIPad ? 100 : 80)
                        }
                        .opacity((isSearchFocused || !vm.searchText.isEmpty) ? 0.3 : 1.0)

                        SearchSection(
                            config: config,
                            hideTabBar: $hideTabBar,
                            searchText: $vm.searchText,
                            searchItems: vm.filteredItems,
                            onSelectItem: { _ in },
                            isFocused: $isSearchFocused
                        )
                        .padding(.horizontal, 35)
                        .padding(.top, 18)
                        .padding(.bottom, 10)
                        .zIndex(1)
                    }

                    if isSearchFocused {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture { isSearchFocused = false }
                            .zIndex(2)
                    }
                }

                AiScanBottomNavigationBar(
                    selectedTab: $selectedTabnavigationItem
                ) { index in
                    switch index {
                    case 0: switchTab(to: .barcode)
                    case 1: switchTab(to: .ai)
                    default: break
                    }
                }
                .padding(.top, config.spacingSmall)
                .padding(.bottom, config.paddingStandard)
                .zIndex(3)
            }
            .background(Color.backgroundColor)
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
            .environment(\.locale, lm.locale)   
            .onAppear {
                selectedTabnavigationItem = 2
            }
        }
    }
}

#Preview {
    SearchView(
        hideTabBar: .constant(false),
        currentTab: .constant(.search),
        slideDirection: .constant(0)
    )
}
