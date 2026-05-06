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
    @State private var currentPage = 1
    @Binding var hideTabBar: Bool
    @Environment(\.horizontalSizeClass) private var sizeClass
    @StateObject private var historyVM = ScoreHistoryViewModel()
    @StateObject private var profileVM = UserProfileViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn = false

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            VStack(spacing: 0) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        Text(L("ประวัติคะแนน"))
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
                        .frame(width: config.mainProfileSize, height: config.mainProfileSize)
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
                                Text(L("คะแนน"))
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
            .ignoresSafeArea()
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

// MARK: - SortType
enum SortType: String, CaseIterable {
    case newest
    case oldest
    case highToLow
    case lowToHigh

    func title(_ L: (String) -> String) -> String {
        switch self {
        case .newest:    return L("ใหม่ที่สุด")
        case .oldest:    return L("เก่าที่สุด")
        case .highToLow: return L("คะแนนมาก → น้อย")
        case .lowToHigh: return L("คะแนนน้อย → มาก")
        }
    }
}

// MARK: - ScoreSortMenu
struct ScoreSortMenu: View {
    @Binding var selectedSort: SortType
    @Binding var isDropdownOpen: Bool
    let config: ResponsiveConfig

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isDropdownOpen.toggle()
                }
            } label: {
                HStack(spacing: 4) {
                    Text(L("เรียงจาก"))
                        .font(.noto(config.fontCaption, weight: .medium))
                        .foregroundColor(.mainColor)
                    Image(isDropdownOpen ? "IconSort2" : "IconSort")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: config.fontCaption, height: config.fontCaption)
                        // ✅ icon หมุน 180° เมื่อเปิด
                        .rotationEffect(.degrees(isDropdownOpen ? 180 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDropdownOpen)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.top, config.sortMenuTopPadding)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - AnimatedScoreCard — wrapper สำหรับ stagger animation
struct AnimatedScoreCard: View {
    let item: ScoreItem
    let index: Int
    let config: ResponsiveConfig
    let isVisible: Bool

    var body: some View {
        ScoreCard(
            title: item.title,
            date: item.date,
            points: item.points,
            backgroundColor: item.color,
            config: config
        )
        // ✅ เลื่อนจากล่างขึ้น + fade + scale พร้อม stagger delay
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.94)
        .offset(y: isVisible ? 0 : 20)
        .animation(
            .spring(response: 0.45, dampingFraction: 0.75)
            .delay(isVisible ? Double(index) * 0.055 : 0),
            value: isVisible
        )
    }
}

// MARK: - PageView
struct PageView: View {
    @State private var currentPage = 1
    @State private var items: [ScoreItem]
    @State private var originalItems: [ScoreItem]
    @State private var isDropdownOpen = false
    @State private var selectedSort: SortType = .newest
    @State private var isVisible = false   // ✅ ควบคุม stagger animation

    let config: ResponsiveConfig
    let availableHeight: CGFloat

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    let itemsPerPage = 7

    init(items: [ScoreItem], config: ResponsiveConfig, availableHeight: CGFloat) {
        _items = State(initialValue: items)
        _originalItems = State(initialValue: items)
        _currentPage = State(initialValue: 1)
        self.config = config
        self.availableHeight = availableHeight
    }

    private func applySortIfNeeded() {
        // ✅ Step 1: fade + slide ออก
        withAnimation(.easeIn(duration: 0.18)) {
            isVisible = false
        }
        // ✅ Step 2: sort ข้อมูลตอนมองไม่เห็น
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            switch selectedSort {
            case .newest:
                items = originalItems.sorted { dateFrom($0.date) > dateFrom($1.date) }
            case .oldest:
                items = originalItems.sorted { dateFrom($0.date) < dateFrom($1.date) }
            case .highToLow:
                items = originalItems.sorted {
                    let p0 = cleanPoints($0.points), p1 = cleanPoints($1.points)
                    return p0 != p1 ? p0 > p1 : dateFrom($0.date) > dateFrom($1.date)
                }
            case .lowToHigh:
                items = originalItems.sorted {
                    let p0 = cleanPoints($0.points), p1 = cleanPoints($1.points)
                    return p0 != p1 ? p0 < p1 : dateFrom($0.date) > dateFrom($1.date)
                }
            }
            currentPage = 1
            // ✅ Step 3: stagger fade + slide กลับเข้ามา
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isVisible = true
            }
        }
    }

    private func cleanPoints(_ points: String) -> Int {
        let stripped = points
            .replacingOccurrences(of: "+", with: "")
            .trimmingCharacters(in: .whitespaces)
        return Int(stripped) ?? 0
    }

    private func dateFrom(_ str: String) -> Date {
        let formats = ["d/M/yyyy", "d/M/yyyy - HH:mm", "yyyy-MM-dd"]
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        for format in formats {
            f.dateFormat = format
            if let date = f.date(from: str) { return date }
        }
        return Date.distantPast
    }

    var body: some View {
        let totalPages = max(1, Int(ceil(Double(items.count) / Double(itemsPerPage))))

        VStack(spacing: 11) {
            if items.isEmpty {
                ScrollView {
                    VStack(spacing: config.spacingMedium) {
                        Image("ListEmpty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: config.emptyStateImageSize,
                                   height: config.emptyStateImageSize)
                        Text(L("ยังไม่มีคะแนน?"))
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(.textFieldColor)
                        Text(L("แยกขยะเพื่อเริ่มสะสมคะแนนได้เลย!"))
                            .font(.noto(config.fontSubHeader, weight: .bold))
                            .foregroundColor(.textFieldColor)
                    }
                    .frame(maxWidth: .infinity, minHeight: availableHeight)
                }

            } else {

                ZStack(alignment: .topTrailing) {
                    ScrollView {
                        VStack(spacing: 9) {

                            ScoreSortMenu(
                                selectedSort: $selectedSort,
                                isDropdownOpen: $isDropdownOpen,
                                config: config
                            )

                            // ✅ ใช้ AnimatedScoreCard พร้อม stagger
                            ForEach(Array(currentItems.enumerated()), id: \.element.id) { index, item in
                                AnimatedScoreCard(
                                    item: item,
                                    index: index,
                                    config: config,
                                    isVisible: isVisible
                                )
                            }
                            .frame(maxWidth: config.mainContentMaxWidth, alignment: .center)
                        }
                        .padding(.bottom, config.paddingMedium)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isDropdownOpen {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isDropdownOpen = false
                            }
                        }
                    }

                    if isDropdownOpen {
                        DropdownOverlay(
                            currentPage: $currentPage,
                            isOpen: $isDropdownOpen,
                            selectedSort: $selectedSort
                        )
                        .padding(.trailing, config.paddingMedium)
                        .zIndex(999)
                        // ✅ dropdown เด้งลงมา
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .opacity
                            )
                        )
                    }
                }
                .background(Color.white)
                .cornerRadius(config.bannerCornerRadius)
                .padding(.horizontal, config.paddingMedium)
                .onChange(of: selectedSort) { _, _ in
                    applySortIfNeeded()
                }
                // ✅ แสดง card ครั้งแรกเมื่อ view ปรากฏ
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isVisible = true
                    }
                }

                PaginationSection(
                    config: config,
                    currentPage: $currentPage,
                    totalPages: totalPages
                )
            }
        }
    }

    var currentItems: [ScoreItem] {
        let start = (currentPage - 1) * itemsPerPage
        let end = min(start + itemsPerPage, items.count)
        guard start < end else { return [] }
        return Array(items[start..<end])
    }
}

#Preview {
    ScoreHistoryView(hideTabBar: .constant(true))
}
