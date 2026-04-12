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

    @State private var selectedWaste: WasteItem? = nil    

    @State private var currentPage = 1
    @StateObject private var vm = FrequentWasteViewModel() // ✅ เพิ่ม

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
    
    var headerView: some View {
        ZStack {
            Color.mainColor

            ZStack {
                Text("ขยะที่แยกทั้งหมด")
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.white)

                HStack {
                    BackButtonWhite()
                    Spacer()
                }
            }
            .padding(.top, 69)
            .padding(.bottom, 28)
        }
        .frame(height: 123)
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
    }

    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {

                headerView

                if vm.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(paginatedItems, id: \.self) { item in
                                WasteCardView(item: item)
                                    .onTapGesture {
                                        selectedWaste = item
                                    }
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 43)
                    }
                    
                    PaginationSection(currentPage: $currentPage, totalPages: totalPages)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationDestination(item: $selectedWaste) { waste in
            WasteTypeView(hideTabBar: .constant(true), category: waste.title)
                .navigationBarBackButtonHidden(true)
        }
        .task {
            await vm.fetchWasteCounts() // ✅ โหลดข้อมูล
        }
    }
}


// MARK: - CARD
struct WasteCardView: View {
    let item: WasteItem

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)

            VStack(spacing: 4) {
                Text(item.title)
                    .font(.noto(14, weight: .semibold))
                    .foregroundColor(.black)

                Text(item.count)
                    .font(.noto(12, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.bottom, 20)
        }
        .frame(height: 215)
        .background(Color.thirdColor)
        .cornerRadius(20)
    }
}

#Preview {
    FrequentWasteView()
}
