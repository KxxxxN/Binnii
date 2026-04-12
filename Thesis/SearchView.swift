//
//  SearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI

struct SearchView: View {
    @Binding var hideTabBar: Bool
    @State private var searchText = ""
    @State private var selectedTabnavigationItem = 2
    @State private var showBarcodeView = false
    @State private var showAiScanView = false
    @State private var selectedItem: String? = nil
    @State private var showDetailSearch = false
    @FocusState private var isSearchFocused: Bool

    let searchItems = ["ขวดพลาสติก", "กระป๋อง", "ซองขนม", "เศษอาหาร", "ตะเกียบไม้"]
        
    var filteredItems: [String] {
        let allLabels = WasteData.allExamples.map { $0.label }
        if searchText.isEmpty {
            return allLabels // ✅ โชว์ทั้งหมดเลยตอน focus
        } else {
            return allLabels.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
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
                    headerView
                    
                    //                    VStack(spacing: 0) {
                    //  SearchSection อยู่นอก ScrollView
                    //                        SearchSection(
                    //                            hideTabBar: $hideTabBar,
                    //                            searchText: $searchText,
                    //                            searchItems: filteredItems,
                    //                            onSelectItem: { _ in },
                    //                            isFocused: $isSearchFocused
                    //                        )
                    //                        .padding(.horizontal, 35)
                    //                        .padding(.top, 18)
                    //                        .padding(.bottom, 10)
                    //                        .zIndex(1)
                    
                    ZStack(alignment: .top) {
                        ScrollView {
                        SearchWasteExamplesGrid(
                            hideTabBar: $hideTabBar,
                            wasteExamples: WasteData.allExamples
                        )
                        .padding(.horizontal, 35)
                        .padding(.top, 90)
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 80)
                    }
                    .opacity((isSearchFocused || !searchText.isEmpty) ? 0.3 : 1.0)
                    .overlay(alignment: .bottom) {
                        AiScanBottomNavigationBar(selectedTab: $selectedTabnavigationItem) { index in
                            hideTabBar = true
                            switch index {
                            case 0: showBarcodeView = true
                            case 1: showAiScanView = true
                            default: break
                            }
                        }
                        .padding(.horizontal, 47)
                        .padding(.bottom, 18)
                        .opacity(isSearchFocused ? 0 : 1)
                    }
                        SearchSection(
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
            .navigationDestination(isPresented: $showAiScanView) {
                AiScanView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showBarcodeView) {
                BarcodeScanView(hideTabBar: $hideTabBar)
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                if isSearchFocused { isSearchFocused = false }
//            }
        }
    }

    var headerView: some View {
        HStack {
            BackButton()
            Spacer()
            Text("ค้นหา")
                .font(.noto(25, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Color.clear.frame(width: 25)
        }
        .padding(.trailing, 18)
        .padding(.top, 67)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 123)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
        .edgesIgnoringSafeArea(.top)
    }
}

struct SearchSection: View {
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
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.searchColor)
                .frame(height: containerHeight)

            VStack(spacing: 0) {
                SearchBar(searchText: $searchText, isFocused: isFocused)

                if !searchText.isEmpty {
                    VStack(spacing: 0) {
                        if searchItems.isEmpty {
                            Text("ไม่พบรายการที่ค้นหา")
                                .font(.noto(16, weight: .bold))
                                .foregroundColor(.gray)
                                .frame(height: rowHeight)
                        } else {
                            ForEach(searchItems.indices, id: \.self) { index in
                                VStack(spacing: 0) {
                                    NavigationLink {
                                        DetailSearchView(hideTabBar: $hideTabBar, category: searchItems[index])
                                    } label: {
                                        HStack {
                                            Text(searchItems[index])
                                                .font(.noto(16, weight: .bold))
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding(.vertical, 11)
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
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
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
//        .animation(.easeInOut(duration: 0.25), value: containerHeight)
//    }
//}

struct SearchBar: View {
    @Binding var searchText: String
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(spacing: 8) {
            TextField("ค้นหา", text: $searchText)
                .font(.noto(16))
                .focused(isFocused)
                .padding(.leading, 23)

            Button { } label: {
                Image("SearchBlack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 37, height: 37)
            }
            .padding(.trailing, 23)
        }
        .frame(height: 50)
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
                WasteExample(image: "Foambox", label: "ภาชนะใส่อาหาร"),
                WasteExample(image: "Chopstick", label: "ตะเกียบไม้"),
                WasteExample(image: "Straw", label: "หลอด"),
                WasteExample(image: "Spoon", label: "ช้อน-ส้อม พลาสติก")
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
                WasteExample(image: "paper", label: "กระดาษทั่วไป"),
                WasteExample(image: "Can", label: "กระป๋อง"),
                WasteExample(image: "Bag", label: "ถุงพลาสติก")
            ]
        )
    ]

    static var allExamples: [WasteExample] {
        categories.flatMap { $0.examples }
    }
}

struct SearchWasteExamplesGrid: View {
    @Binding var hideTabBar: Bool
    let wasteExamples: [WasteExample]
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 18)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(wasteExamples) { example in
                NavigationLink {
                    DetailSearchView(hideTabBar: $hideTabBar, category: example.label)
                } label: {
                    WasteCard(example: example)
                }
            }
        }
        .padding(.top, 20)
    }
}

#Preview{
    SearchView(hideTabBar: .constant(false))
}
