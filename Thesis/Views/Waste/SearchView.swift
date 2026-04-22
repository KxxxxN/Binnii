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
    @State private var selectedTabnavigationItem = 2
    @FocusState private var isSearchFocused: Bool
    
    private func switchTab(to tab: ScanTab) {
        slideDirection = tab.rawValue > currentTab.rawValue ? -1 : 1
        currentTab = tab
    }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack(alignment: .top) {
                Color.backgroundColor.ignoresSafeArea()
                
                if isSearchFocused {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isSearchFocused = false
                        }
                        .zIndex(0)
                }
                
                
                VStack(spacing: 0) {
                    SearchHeaderView(config: config)
                    
                    ZStack(alignment: .top) {
                        ScrollView {
                            SearchWasteExamplesGrid(
                                config: config,
                                hideTabBar: $hideTabBar,
                                wasteExamples: WasteData.allExamples
                            )
                            .padding(.horizontal, config.isIPad ? 60 : 35)
                            .padding(.top, 90)
                        }
                        .scrollDismissesKeyboard(.immediately)
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: config.isIPad ? 100 : 80)
                        }
                        .opacity((isSearchFocused || !vm.searchText.isEmpty) ? 0.3 : 1.0)
                        .overlay(alignment: .bottom) {
                            AiScanBottomNavigationBar(
                                selectedTab: $selectedTabnavigationItem
                            ) { index in
                                switch index {
                                case 0: switchTab(to: .barcode)
                                case 1: switchTab(to: .ai)
                                default: break
                                }
                            }
                            .padding(.horizontal, config.isIPad ? 80 : 47)
                            .padding(.bottom, config.isIPad ? 24 : 18)
                            .opacity(isSearchFocused ? 0 : 1)
                        }
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
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                selectedTabnavigationItem = 2
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(
            hideTabBar: .constant(false),
            currentTab: .constant(.search),
            slideDirection: .constant(0)
        )
    }
}
