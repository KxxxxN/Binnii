//
//  ScoreHistoryView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//
import SwiftUI

struct ScoreItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let points: String
    let color: Color
}

struct ScoreHistoryView: View {
    @State private var currentPage = 0
    @Binding var hideTabBar: Bool
    //    @Environment(\.dismiss) var dismiss
    @StateObject private var historyVM = ScoreHistoryViewModel()
    @StateObject private var profileVM = UserProfileViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Text("ประวัติคะแนน")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack {
                        BackButtonWhite()
                        
                        Spacer()
                    }
                }
                .padding(.top, 65)
                
                HStack(alignment: .center, spacing: 13) {
                    Group {
                        if let image = profileVM.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Image("Profile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                    
                    HStack {
                        Text(profileVM.fullName)
                            .font(.noto(20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(profileVM.totalPoints)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                            Text("คะแนน")
                                .font(.noto(15, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 28)
                }
                .padding(.top, 16)
                .padding(.leading, 28)
                .padding(.bottom, 30)
            }
            .frame(height: 205)
            .frame(maxWidth: .infinity)
            .background(
                Color.mainColor
                    .clipShape(
                        RoundedCorner(
                            radius: 20,
                            corners: [.bottomLeft, .bottomRight]
                        )
                    )
            )
            
            if historyVM.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                TabView {
                    PageView(items: historyVM.items)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(Color.white)
            }
//            .tabViewStyle(.page(indexDisplayMode: .never))
//            .background(Color.white)

        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
        .onAppear { hideTabBar = true }
        .onDisappear { hideTabBar = false }
        .task {
            do {
                let session = try await supabase.auth.session
                await profileVM.fetchProfile(userId: session.user.id)
            } catch {
                print("❌ No session: \(error)")
            }
            await historyVM.fetchHistory()
        }
    }
}

struct PageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == current ? Color.mainColor : Color.thirdColor)
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct ScoreSortMenu: View {
    @Binding var items: [ScoreItem]
    @Binding var selectedSort: String
    @Binding var isDropdownOpen: Bool
    @Binding var currentPage: Int

    let menuItems = [
        "ใหม่ที่สุด", "เก่าที่สุด",
        "คะแนนมาก → น้อย", "คะแนนน้อย → มาก"
    ]

    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isDropdownOpen.toggle()
                }
            } label: {
                HStack(spacing: 2) {
                    Text("เรียงจาก")
                        .font(.noto(14, weight: .medium))
                        .foregroundColor(.mainColor)
                    Image(isDropdownOpen ? "IconSort2" : "IconSort")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct PageView: View {
    @State private var currentPage = 0
    @State private var items: [ScoreItem]        // ✅ รับจากภายนอก
    @State private var isDropdownOpen = false
    @State private var selectedSort = "ใหม่ที่สุด"

    let itemsPerPage = 7

    init(items: [ScoreItem]) {
        _items = State(initialValue: items)
        _currentPage = State(initialValue: 0)
    }

    var body: some View {
        let totalPages = max(0, (items.count - 1) / itemsPerPage)

        VStack(spacing: 11) {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    VStack(spacing: 9) {
                        ScoreSortMenu(
                            items: $items,
                            selectedSort: $selectedSort,
                            isDropdownOpen: $isDropdownOpen,
                            currentPage: $currentPage
                        )
                        .padding(.horizontal, 15)

                        ForEach(currentItems, id: \.id) { item in
                            ScoreCard(
                                title: item.title,
                                date: item.date,
                                points: item.points,
                                backgroundColor: item.color
                            )
                        }

                    }
                    .padding(.bottom, 16)
                    
                }
//                .padding(.horizontal, 16)
                .contentShape(Rectangle())
                

                .onTapGesture {
                    if isDropdownOpen {
                        withAnimation { isDropdownOpen = false }
                    }
                }

                if isDropdownOpen {
                    DropdownOverlay(
                        items: $items,
                        currentPage: $currentPage,
                        isOpen: $isDropdownOpen,
                        selectedSort: $selectedSort
                    )
                    .padding(.top, 0)
                    .padding(.trailing, 15)
                    .zIndex(999)
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 16)



            CustomPaginationView(currentPage: $currentPage, maxPage: totalPages)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(10)
        }

        
    }

    var currentItems: [ScoreItem] {
        let start = currentPage * itemsPerPage
        let end = min(start + itemsPerPage, items.count)
        guard start < end else { return [] }
        return Array(items[start..<end])
    }

}

#Preview {
    ScoreHistoryView(hideTabBar: .constant(true))
}




