//
//  ContentView.swift
//  Theis
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

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Image("logo_white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 44)
                    .padding(.top, 80)
                
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
//                        Text("สุนิสา จินดาวัฒนา")
//                            .font(.noto(20, weight: .bold))
//                            .foregroundColor(.white)
                        
                        // ✅ แสดงชื่อจาก Supabase
                        if profileVM.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(profileVM.fullName)
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(profileVM.totalPoints)") // ✅ เปลี่ยนจาก profileVM.points
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("คะแนน")
                                .font(.noto(15, weight: .regular))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.trailing, 28)
                }
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 205)
            .frame(maxWidth: .infinity)
            .padding(.leading, 28)
            .background(Color.mainColor)
            .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HistorySection(
                        hideTabBar: $hideTabBar,
                        items: profileVM.latestHistory.map { [$0] } ?? []
                    )
                    RewardExchangeSection(hideTabBar: $hideTabBar)
                    FrequentWasteSection(
                        hideTabBar: $hideTabBar,
                        items: wasteVM.wasteItems.prefix(3).map {
                            RecyclableItem(
                                imageName: $0.imageName,
                                title: $0.title,
                                countNumber: Int($0.count.replacingOccurrences(of: " ครั้ง", with: "")) ?? 0
                            )
                        }
                    )
                    WasteSeparationGuideSection(currentIndex: $currentCarouselIndex, hideTabBar: $hideTabBar, tabIndex: $tabIndex)
                }
                .padding()
            }
            
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
}


struct SectionHeader<Destination: View>: View {
    let title: String
    let destinationView: Destination
    var onTapSeeAll: (() -> Void)? = nil  // ✅ เพิ่ม optional action

    var body: some View {
        HStack {
            Text(title)
                .font(.noto(18, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            if let action = onTapSeeAll {
                // ✅ ถ้ามี action ใช้ Button แทน NavigationLink
                Button(action: action) {
                    HStack(spacing: 4) {
                        Text("ดูทั้งหมด")
                            .font(.noto(14, weight: .medium))
                            .foregroundColor(Color.mainColor)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(Color.mainColor)
                    }
                }
            } else {
                NavigationLink(destination: destinationView.navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 4) {
                        Text("ดูทั้งหมด")
                            .font(.noto(14, weight: .medium))
                            .foregroundColor(Color.mainColor)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(Color.mainColor)
                    }
                }
            }
        }
    }
}

struct FrequentWasteSection: View {
    
    @Binding var hideTabBar: Bool
    let items: [RecyclableItem]
    
    var body: some View {
        VStack(spacing: 7) {
            SectionHeader(title: "ขยะที่แยกบ่อย", destinationView: FrequentWasteView())
            
            HStack(spacing: 8) {
                ForEach(items) { item in
                    NavigationLink(destination: WasteTypeView(hideTabBar: $hideTabBar, category: item.title)) {
                        RecyclableItemCard(item: item)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct RecyclableItemCard: View {
    let item: RecyclableItem
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 92)
            
            VStack(spacing: 2) {
                Text(item.title)
                    .font(.noto(14, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("\(item.countNumber) ครั้ง")
                    .font(.noto(10, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color.thirdColor)
        .cornerRadius(20)
    }
}

struct WasteSeparationGuideSection: View {
    @Binding var currentIndex: Int
    @Binding var hideTabBar: Bool
    @Binding var tabIndex: Int

    let totalPages = 3
    let virtualPages = 300  // infinite scroll
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 7) {
            SectionHeader(
                title: "วิธีการแยกขยะ",
                destinationView: KnowledgeView(hideTabBar: $hideTabBar),
                onTapSeeAll: {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                        tabIndex = 2  // ✅ เปลี่ยนไปแท็บความรู้ทั่วไป
                    }
                }
            )
            VStack(spacing: 12) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<virtualPages, id: \.self) { index in
                        ZStack {
                            Image("info-banner\(index % totalPages + 1)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 410, height: 150)
                                .cornerRadius(25)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 150)
                .onReceive(timer) { _ in
                    withAnimation(.easeInOut(duration: 1.5)) {
                        currentIndex += 1  // เลื่อนไปข้างหน้าเสมอ ไม่มีวนกลับ
                    }
                }

                // Dot indicator ใช้ % totalPages เพื่อให้ dot ถูกต้อง
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
            currentIndex = 0  //  เริ่มต้นที่หน้าแรกเสมอ
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
