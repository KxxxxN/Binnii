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
    @Environment(\.horizontalSizeClass) private var sizeClass
    @StateObject private var historyVM = ScoreHistoryViewModel()
    @StateObject private var profileVM = UserProfileViewModel()

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            VStack(spacing: 0) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        Text("ประวัติคะแนน")
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(.white)

                        HStack {
                            BackButtonWhite()
                            Spacer()
                        }
                    }
                    .padding(.top, config.headerTopPadding)

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
                        .frame(width: config.mainProfileSize,
                               height: config.mainProfileSize)
                        .clipShape(Circle())
                        .shadow(radius: 4)

                        HStack {
                            Text(profileVM.fullName)
                                .font(.noto(config.fontHeader, weight: .bold))
                                .foregroundColor(.white)

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("\(profileVM.totalPoints)")
                                    .font(.system(size: config.mainPointsFontSize, weight: .bold))
                                    .foregroundColor(.white)
                                Text("คะแนน")
                                    .font(.noto(config.fontSubBody, weight: .regular))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, config.paddingStandard)
                    }
                    .padding(.top, config.paddingMedium)
                    .padding(.leading, config.paddingStandard)
                    .padding(.bottom, config.paddingStandard)
                }
                .frame(height: config.mainHeaderHeight)
                .frame(maxWidth: .infinity)
                .background(
                    Color.mainColor
                        .clipShape(RoundedCorner(
                            radius: config.bannerCornerRadius,
                            corners: [.bottomLeft, .bottomRight]
                        ))
                )

                // MARK: - Content
                if historyVM.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    TabView {
                        PageView(
                            items: historyVM.items,
                            config: config,
                            availableHeight: geo.size.height - config.mainHeaderHeight
                        )
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(Color.white)
                }
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
}

// MARK: - PageIndicator
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

// MARK: - ScoreSortMenu
struct ScoreSortMenu: View {
    @Binding var items: [ScoreItem]
    @Binding var selectedSort: String
    @Binding var isDropdownOpen: Bool
    @Binding var currentPage: Int
    let config: ResponsiveConfig

    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isDropdownOpen.toggle()
                }
            } label: {
                HStack(spacing: 2) {
                    Text("เรียงจาก")
                        .font(.noto(config.fontCaption, weight: .medium))
                        .foregroundColor(.mainColor)
                    Image(isDropdownOpen ? "IconSort2" : "IconSort")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: config.fontCaption, height: config.fontCaption)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.top, config.sortMenuTopPadding)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - PageView
struct PageView: View {
    @State private var currentPage = 0
    @State private var items: [ScoreItem]
    @State private var isDropdownOpen = false
    @State private var selectedSort = "ใหม่ที่สุด"
    let config: ResponsiveConfig
    let availableHeight: CGFloat  // ✅ รับความสูงที่เหลือใต้ header

    let itemsPerPage = 7

    init(items: [ScoreItem], config: ResponsiveConfig, availableHeight: CGFloat) {
        _items = State(initialValue: items)
        _currentPage = State(initialValue: 0)
        self.config = config
        self.availableHeight = availableHeight
    }

    var body: some View {
        let totalPages = max(0, (items.count - 1) / itemsPerPage)

        VStack(spacing: 11) {
            if items.isEmpty {

                // MARK: - Empty State
                // ✅ ครอบ ScrollView + minHeight เพื่อให้ scroll ได้ใน landscape
                ScrollView {
                    VStack(spacing: config.spacingMedium) {
                        Image("ListEmpty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: config.emptyStateImageSize,
                                   height: config.emptyStateImageSize)

                        Text("ยังไม่มีคะแนน?")
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(.textFieldColor)

                        Text("แยกขยะเพื่อเริ่มสะสมคะแนนได้เลย!")
                            .font(.noto(config.fontSubHeader, weight: .bold))
                            .foregroundColor(.textFieldColor)
                    }
                    // ✅ portrait → จัดกลาง, landscape → scroll ได้
                    .frame(maxWidth: .infinity, minHeight: availableHeight)
                }

            } else {

                // MARK: - มีข้อมูล
                ZStack(alignment: .topTrailing) {
                    ScrollView {
                        VStack(spacing: 9) {
                            ScoreSortMenu(
                                items: $items,
                                selectedSort: $selectedSort,
                                isDropdownOpen: $isDropdownOpen,
                                currentPage: $currentPage,
                                config: config
                            )
                            .padding(.horizontal, config.paddingMedium)

                            ForEach(currentItems, id: \.id) { item in
                                ScoreCard(
                                    title: item.title,
                                    date: item.date,
                                    points: item.points,
                                    backgroundColor: item.color
                                )
                            }
                        }
                        .padding(.bottom, config.paddingMedium)
                    }
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
                        .padding(.trailing, config.paddingMedium)
                        .zIndex(999)
                    }
                }
                .background(Color.white)
                .cornerRadius(config.bannerCornerRadius)
                .padding(.horizontal, config.paddingMedium)

                CustomPaginationView(currentPage: $currentPage, maxPage: totalPages)
                    .padding(.vertical, config.paddingMedium)
                    .background(Color.white)
                    .cornerRadius(10)
            }
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
