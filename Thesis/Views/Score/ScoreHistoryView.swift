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
//            .onChange(of: isLoggedIn) {
//                if !isLoggedIn {
//                    profileVM.clearProfile()
//                }
//            }
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
        case .newest: return L("ใหม่ที่สุด")
        case .oldest: return L("เก่าที่สุด")
        case .highToLow: return L("คะแนนมาก → น้อย")
        case .lowToHigh: return L("คะแนนน้อย → มาก")
        }
    }
}

// MARK: - ScoreSortMenu
struct ScoreSortMenu: View {
    @Binding var items: [ScoreItem]
    @Binding var selectedSort: SortType
    @Binding var isDropdownOpen: Bool
    @Binding var currentPage: Int

    let config: ResponsiveConfig

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
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
                        .frame(width: config.fontCaption,
                               height: config.fontCaption)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.top, config.sortMenuTopPadding)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct PageView: View {
    @State private var currentPage = 0
    @State private var items: [ScoreItem]
    @State private var originalItems: [ScoreItem]
    @State private var isDropdownOpen = false
    @State private var selectedSort: SortType = .newest
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
        switch selectedSort {
        case .newest:
            items = originalItems.sorted { dateFrom($0.date) > dateFrom($1.date) }
        case .oldest:
            items = originalItems.sorted { dateFrom($0.date) < dateFrom($1.date) }
        case .highToLow:
            items = originalItems.sorted { cleanPoints($0.points) > cleanPoints($1.points) }
        case .lowToHigh:
            items = originalItems.sorted { cleanPoints($0.points) < cleanPoints($1.points) }
        }
        currentPage = 1
    }

    private func dateFrom(_ str: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "d/M/yyyy"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.date(from: str) ?? Date.distantPast
    }

    private func cleanPoints(_ points: String) -> Int {
        let isNegative = points.hasPrefix("-")
        let clean = points
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
        let value = Int(clean) ?? 0
        return isNegative ? -value : value
    }

    var body: some View {
        let totalPages = max(1, Int(ceil(Double(items.count) / Double(itemsPerPage))))

        VStack(spacing: 11) {
            if items.isEmpty {

                // MARK: - Empty State
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
                                items: $items,
                                selectedSort: $selectedSort,
                                isDropdownOpen: $isDropdownOpen,
                                currentPage: $currentPage,
                                config: config
                            )
//                            .padding(Edge.Set.horizontal, config.paddingMedium)

                            ForEach(currentItems, id: \.id) { item in
                                ScoreCard(
                                    title: item.title,
                                    date: item.date,
                                    points: item.points,
                                    backgroundColor: item.color,
                                    config: config
                                )
                            }
                            .frame(maxWidth: config.mainContentMaxWidth, alignment: .center)
                        }
                        .padding(.bottom, config.paddingMedium)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isDropdownOpen {
                            withAnimation { isDropdownOpen = false }
                            applySortIfNeeded()
                        }
                    }

                    if isDropdownOpen {
                        DropdownOverlay(
                            items: $items,
                            currentPage: $currentPage,
                            isOpen: $isDropdownOpen,
                            selectedSort: $selectedSort
                        )
                        .padding(.trailing, config.paddingMedium)
                        .zIndex(999)
                    }
                }
                .background(Color.white)
                .cornerRadius(config.bannerCornerRadius)
                .padding(.horizontal, config.paddingMedium)

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

