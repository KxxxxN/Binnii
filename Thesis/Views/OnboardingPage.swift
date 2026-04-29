//
//  OnboardingView.swift
//  Thesis
//


import SwiftUI

struct OnboardingPage {
    let imageName: String
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var currentPage = -1  // ← -1 = Start page

    let pages: [OnboardingPage] = [
        OnboardingPage(imageName: "Onboarding1"),
        OnboardingPage(imageName: "Onboarding2"),
        OnboardingPage(imageName: "Onboarding3")
    ]

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

            VStack(spacing: 0) {

                // MARK: - Page Content
                if currentPage == -1 {
                    Image("OnboardingStart")
                        .resizable()
                        .scaledToFit()
                        .frame(width:config.isIPad ? 670 : 370, height: config.isIPad ? 935 : 635)
                        .cornerRadius(20)
                        .padding(.top, config.isIPad ? 60 : 40)
                } else {
                    TabView(selection: $currentPage) {
                        ForEach(pages.indices, id: \.self) { index in
                            ZStack {
                                Image(pages[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(width: config.isIPad ? 670 : 370, height: config.isIPad ? 935 : 635)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: config.isIPad ? 935 : 635)
                    .padding(.top, config.isIPad ? 60 : 40)
                }

                // MARK: - Page Indicator
                if currentPage >= 0 {
                    HStack(spacing: 8) {
                        ForEach(pages.indices, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.mainColor : Color.thirdColor)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, config.isIPad ? 20 : 20)
                } else {
                    Color.clear
                        .frame(height: config.isIPad ? 48 : 44)
                }

                // MARK: - Buttons
                if currentPage == -1 {
                    PrimaryButton(
                        title: "เริ่มต้น",
                        action: { currentPage = 0 },
                        width: config.isIPad ? 380 : 300,
                        height: config.isIPad ? 60 : 58
                    )
                    .padding(.bottom, config.isIPad ? 30 : 22)
                } else {
                    HStack(alignment: .bottom, spacing: config.isIPad ? 100 : 24) {
                        if currentPage > 0 {
                            SecondButton(
                                title: "< ย้อนกลับ",
                                action: { currentPage -= 1 },
                                width: config.isIPad ? 180 : 160,
                                height: config.isIPad ? 60 : 58
                            )
                        } else {
                            Color.clear
                                .frame(width: config.isIPad ? 180 : 160, height: config.isIPad ? 60 : 58)
                        }

                        if currentPage < pages.count - 1 {
                            PrimaryButton(
                                title: "ต่อไป >",
                                action: { currentPage += 1 },
                                width: config.isIPad ? 180 : 160,
                                height: config.isIPad ? 60 : 58
                            )
                        } else {
                            PrimaryButton(
                                title: "เสร็จสิ้น >",
                                action: { hasSeenOnboarding = true },
                                width: config.isIPad ? 180 : 160,
                                height: config.isIPad ? 60 : 58
                            )
                        }
                    }
                    .padding(.bottom, config.isIPad ? 5 : 22)
                }


                // MARK: - ข้ามทั้งหมด
                if currentPage >= 0 && currentPage < pages.count - 1 {
                    HStack(spacing: config.isIPad ? 80 : 24) {
                        Color.clear
                            .frame(width: config.isIPad ? 180 : 160, height: 20)
                        Button("ข้ามทั้งหมด >") {
                            hasSeenOnboarding = true
                        }
                        .font(.noto(16, weight: .medium))
                        .foregroundColor(.mainColor)
                        .frame(width: config.isIPad ? 180 : 160, alignment: .trailing)
                    }
                    .padding(.bottom, config.isIPad ? 30 : 20)
                } else {
                    Color.clear
                        .frame(height: config.isIPad ? 50 : 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor.ignoresSafeArea())
        }
    }
}

#Preview {
    OnboardingView()
}
