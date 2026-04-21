//
//  SearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass // รับค่า Size Class
    @Binding var hideTabBar: Bool
    @Binding var currentTab: ScanTab
    @Binding var slideDirection: Int
    
    @State private var searchText = ""
    @State private var selectedTabnavigationItem = 2
    @State private var selectedItem: String? = nil
    @State private var showDetailSearch = false
    @FocusState private var isSearchFocused: Bool
    
    //    let searchItems = ["ขวดพลาสติก", "กระป๋อง", "ซองขนม", "เศษอาหาร", "ตะเกียบไม้"]
    private func switchTab(to tab: ScanTab) {
        slideDirection = tab.rawValue > currentTab.rawValue ? -1 : 1
        currentTab = tab
    }
    
    var filteredItems: [String] {
        let allLabels = WasteData.allExamples.map { $0.label }
        if searchText.isEmpty {
            return allLabels
        } else {
            return allLabels.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
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
                    HeaderView(config: config)
                    
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
                        .opacity((isSearchFocused || !searchText.isEmpty) ? 0.3 : 1.0)
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
                            searchText: $searchText,
                            searchItems: filteredItems,
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
    
// แยก Header ออกมาเป็น Component เพื่อรับ config
struct HeaderView: View {
    let config: ResponsiveConfig
    
    var body: some View {
        HStack {
            BackButton()
            Spacer()
            Text("ค้นหา")
                .font(.noto(config.titleFontSize, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            // กำหนดกล่องเปล่าให้สมดุลกับ BackButton
            Color.clear.frame(width: config.isIPad ? 40 : 25)
        }
        .padding(.trailing, config.isIPad ? 30 : 18)
        .padding(.top, config.searchHeaderTopPadding)
        .padding(.bottom, config.isIPad ? 30 : 20)
        .frame(maxWidth: .infinity)
        .frame(height: config.searchHeaderHeight)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }
}
    
struct SearchSection: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    @Binding var searchText: String
    let searchItems: [String]
    var onSelectItem: (String) -> Void
    var isFocused: FocusState<Bool>.Binding
    
    @State private var isExpanded = false
    
    private let rowHeight: CGFloat = 46
    private let searchBarHeight: CGFloat = 50
    private let verticalPadding: CGFloat = 20
    
    private var containerHeight: CGFloat {
        if searchText.isEmpty {
            return searchBarHeight
        }
        let itemCount = max(searchItems.count, 1)
        return searchBarHeight + (CGFloat(itemCount) * rowHeight) + verticalPadding
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(config: config, searchText: $searchText, isFocused: isFocused)
            
            if !searchText.isEmpty {
                VStack(spacing: 0) {
                    if searchItems.isEmpty {
                        Text("ไม่พบรายการที่ค้นหา")
                            .font(.noto(config.buttonFont, weight: .bold))
                            .foregroundColor(.gray)
                            .frame(height: config.buttonHeight)
                            .padding(.vertical, config.isIPad ? 20 : 10)
                    } else {
                        ForEach(searchItems.indices, id: \.self) { index in
                            VStack(spacing: 0) {
                                NavigationLink {
                                    DetailSearchView(hideTabBar: $hideTabBar, category: searchItems[index])
                                } label: {
                                    HStack {
                                        Text(searchItems[index])
                                            .font(.noto(config.buttonFont, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding(.vertical, config.isIPad ? 16 : 11)
                                }
                                
                                if index < searchItems.count - 1 {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, config.isIPad ? 30 : 20)
                .padding(.top, config.isIPad ? 16 : 10)
                .padding(.bottom, config.isIPad ? 20 : 10)
            }
        }
        // ✨ ใช้ background สีตรงนี้ จะยืดหดตามเนื้อหาภายใน 100% หมดปัญหาความสูงพัง
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.searchColor)
//                .frame(height: containerHeight)
        )
        
        .onChange(of: isFocused.wrappedValue) {
            withAnimation(.easeInOut(duration: 0.25)) {
                isExpanded = isFocused.wrappedValue
            }
        }
        .onChange(of: searchText) {
            if !searchText.isEmpty {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded = true
                }
            }
        }
    }
}
    
struct SearchBar: View {
    let config: ResponsiveConfig
    @Binding var searchText: String
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        HStack(spacing: config.isIPad ? 12 : 8) {
            TextField("ค้นหา", text: $searchText)
                .font(.noto(config.buttonFont))
                .focused(isFocused)
                .padding(.leading, config.isIPad ? 35 : 23)
            
            Button { } label: {
                Image("SearchBlack")
                    .resizable()
                    .scaledToFit()
                // ปรับขนาดไอคอนให้สัมพันธ์กับหน้าจอ
                    .frame(width: config.isIPad ? 45 : 37, height: config.isIPad ? 45 : 37)
            }
            .padding(.trailing, config.isIPad ? 35 : 23)
        }
        .frame(height: config.buttonHeight)
        // พื้นหลังของ TextField ปกติให้กลมกลืนกับ SearchSection
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.textFieldColor)
        )
    }
}
    
struct WasteData {
    static let categories: [WasteCategory] = [
        WasteCategory(
            name: "ถังขยะเปียก",
            colorName: "(สีเขียว)",
            color: .wetWasteColor,
            description: "สำหรับขยะที่ย่อยสลายได้เองตามธรรมชาติ",
            binImage: "Bin1",
            examples: [
                WasteExample(image: "Foodscraps", label: "เศษอาหาร"),
                WasteExample(image: "Egg", label: "เปลือกไข่"),
                WasteExample(image: "Fruit", label: "เปลือกผลไม้"),
                WasteExample(image: "Drink", label: "เครื่องดื่มเหลือ"),
                WasteExample(image: "Snack", label: "เศษขนม"),
                WasteExample(image: "Ice", label:"น้ำแข็งเหลือ")
            ]
        ),
        WasteCategory(
            name: "ถังขยะทั่วไป",
            colorName: "(สีน้ำเงิน)",
            color: .generalWasteColor,
            description: "สำหรับขยะทั่วไปไม่สามารถรีไซเคิลได้",
            binImage: "Bin2",
            examples: [
                WasteExample(image: "SnackBag", label: "ซองขนม"),
                WasteExample(image: "Tissue", label: "กระดาษทิชชู่"),
                WasteExample(image: "FoodContainers", label: "ภาชนะใส่อาหาร"),
                WasteExample(image: "Chopsticks", label: "ตะเกียบไม้"),
                WasteExample(image: "Straw", label: "หลอด"),
                WasteExample(image: "Plasticcutlery", label: "ช้อน-ส้อม พลาสติก")
            ]
        ),
        WasteCategory(
            name: "ถังขยะรีไซเคิล",
            colorName: "(สีเหลือง)",
            color: .recycleWasteColor,
            description: "สำหรับขยะที่สามารถนำกลับมาใช้ใหม่หรือแปรรูปได้",
            binImage: "Bin3",
            examples: [
                WasteExample(image: "Bottle", label: "ขวดพลาสติก"),
                WasteExample(image: "Box", label: "กล่องกระดาษ"),
                WasteExample(image: "Plasticcup", label: "แก้วพลาสติก"),
                WasteExample(image: "Paper", label: "กระดาษทั่วไป"),
                WasteExample(image: "Can", label: "กระป๋อง"),
                WasteExample(image: "Plasticbag", label: "ถุงพลาสติก")
            ]
        )
    ]
    
    static var allExamples: [WasteExample] {
        categories.flatMap { $0.examples }
    }
}
    
struct SearchWasteExamplesGrid: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    let wasteExamples: [WasteExample]
    
    var columns: [GridItem] {
        if config.isIPad {
            return [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20),
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

#Preview {
    NavigationStack {
        SearchView(
            hideTabBar: .constant(false),
            currentTab: .constant(.search),
            slideDirection: .constant(0)
        )
    }
}
