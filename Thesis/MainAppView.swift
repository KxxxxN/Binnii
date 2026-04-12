//
//  MainAppView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

struct MainAppView: View {
    @State private var currentCarouselIndex = 0
    @Binding var hideTabBar: Bool
    @Binding var tabIndex: Int
    @StateObject private var profileVM = UserProfileViewModel()
    @StateObject private var wasteVM = FrequentWasteViewModel()

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

            VStack(spacing: 0) {
                // --- Header Section ---
                VStack(alignment: .leading, spacing: 4) {
                    Image("logo_white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: config.mainLogoWidth, height: config.mainLogoHeight)
                        .padding(.top, config.mainLogoTopPadding)
                    
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
                            if profileVM.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(profileVM.fullName)
                                    .font(.noto(config.mainNameFontSize, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(profileVM.totalPoints)")
                                    .font(.system(size: config.mainPointsFontSize, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("คะแนน")
                                    .font(.noto(config.mainPointsLabelFontSize, weight: .regular))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.trailing, config.mainHorizontalPadding)
                    }
                    .padding(.bottom, config.mainProfileBottomPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: config.mainHeaderHeight)
                .frame(maxWidth: .infinity)
                .padding(.leading, config.mainHorizontalPadding)
                .background(Color.mainColor)
                .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))

                
                // --- Scrollable Content ---
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: config.mainContentSpacing) {
                        HistorySection(
                            config: config,
                            hideTabBar: $hideTabBar,
                            items: profileVM.latestHistory.map { [$0] } ?? []
                        )
                        
                        RewardExchangeSection(config: config,hideTabBar: $hideTabBar)
                        
                        FrequentWasteSection(
                            config: config,
                            hideTabBar: $hideTabBar,
                            items: wasteVM.wasteItems.isEmpty
                                ? [
                                    RecyclableItem(imageName: "Bottle",     title: "ขวดพลาสติก", countNumber: 0),
                                    RecyclableItem(imageName: "Plasticcup", title: "แก้วพลาสติก",  countNumber: 0),
                                    RecyclableItem(imageName: "Can",        title: "กระป๋อง",    countNumber: 0)
                                  ]
                                : wasteVM.wasteItems.prefix(3).map {
                                    RecyclableItem(
                                        imageName: $0.imageName,
                                        title: $0.title,
                                        countNumber: Int($0.count.replacingOccurrences(of: " ครั้ง", with: "")) ?? 0
                                    )
                                  }
                        )
                        
                        WasteSeparationGuideSection(
                            config: config,
                            currentIndex: $currentCarouselIndex,
                            hideTabBar: $hideTabBar,
                            tabIndex: $tabIndex
                        )
                    }
                    .padding()
                    .padding(.horizontal, config.isIPad ? 20 : 0)
                    .frame(maxWidth: config.mainContentMaxWidth, alignment: .center)
                }
                .frame(width: config.screenWidth)
                
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .task {
                do {
                    let session = try await supabase.auth.session
                    await profileVM.fetchProfile(userId: session.user.id)
                    await wasteVM.fetchWasteCounts()
                } catch {
                    print("❌ No session: \(error)")
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

// --- Helper Views ---

struct SectionHeader<Destination: View>: View {
    let config: ResponsiveConfig // รับ Config เข้ามา
    let title: String
    let destinationView: Destination
    var onTapSeeAll: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.noto(config.sectionHeaderTitleFont, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            if let action = onTapSeeAll {
                Button(action: action) {
                    HStack(spacing: 4) {
                        Text("ดูทั้งหมด")
                            .font(.noto(config.sectionHeaderButtonFont, weight: .medium))
                            .foregroundColor(Color.mainColor)
                        Image(systemName: "chevron.right")
                            .font(.system(size: config.sectionHeaderButtonFont))
                            .foregroundColor(Color.mainColor)
                    }
                }
            } else {
                NavigationLink(destination: destinationView.navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 4) {
                        Text("ดูทั้งหมด")
                            .font(.noto(config.sectionHeaderButtonFont, weight: .medium))
                            .foregroundColor(Color.mainColor)
                        Image(systemName: "chevron.right")
                            .font(.system(size: config.sectionHeaderButtonFont))
                            .foregroundColor(Color.mainColor)
                    }
                }
            }
        }
    }
}

struct FrequentWasteSection: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    let items: [RecyclableItem]
    
    var body: some View {
        VStack(spacing: 7) {
            SectionHeader(config: config, title: "ขยะที่แยกบ่อย", destinationView: FrequentWasteView())
            
            HStack(spacing: 8) {
                ForEach(items) { item in
                    NavigationLink(destination: WasteTypeView(hideTabBar: $hideTabBar, category: item.title)) {
                        RecyclableItemCard(config: config, item: item)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct RecyclableItemCard: View {
    let config: ResponsiveConfig
    let item: RecyclableItem
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: config.itemCardImageHeight)
            
            VStack(spacing: 2) {
                Text(item.title)
                    .font(.noto(config.itemCardTitleFont, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("\(item.countNumber) ครั้ง")
                    .font(.noto(config.itemCardCountFont, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: config.itemCardHeight)
        .background(Color.thirdColor)
        .cornerRadius(20)
    }
}

struct WasteSeparationGuideSection: View {
    let config: ResponsiveConfig
    @Binding var currentIndex: Int
    @Binding var hideTabBar: Bool
    @Binding var tabIndex: Int
    
    let totalPages = 3
    let virtualPages = 300  // infinite scroll
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 7) {
            SectionHeader(
                config: config,
                title: "วิธีการแยกขยะ",
                destinationView: KnowledgeView(hideTabBar: $hideTabBar),
                onTapSeeAll: {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                        tabIndex = 2
                    }
                }
            )
            
            VStack(spacing: 12) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<virtualPages, id: \.self) { index in
                        ZStack {
                            Image("info-banner\(index % totalPages + 1)")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(config.bannerCornerRadius)
                                .clipped()
                        }
                        .padding(.horizontal, 2)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .aspectRatio(config.bannerAspectRatio, contentMode: .fit)

                HStack(spacing: 6) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex % totalPages ? Color.mainColor : Color.thirdColor)
                            .frame(width: index == currentIndex % totalPages ? 10 : 9,
                                   height: index == currentIndex % totalPages ? 10 : 9)
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    }
                }
            }
        }
        .onAppear {
            currentIndex = 0
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.bottomLeft, .bottomRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    MainAppView(hideTabBar: .constant(false), tabIndex: .constant(0))
}
