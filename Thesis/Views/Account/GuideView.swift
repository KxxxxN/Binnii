//
//  GuideView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 29/4/2569 BE.
//

import SwiftUI

struct GuideView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(imageName: "Onboarding1"),
        OnboardingPage(imageName: "Onboarding2"),
        OnboardingPage(imageName: "Onboarding3")
    ]
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                
                ZStack {
                    Text(L("วิธีการใช้งาน"))
                        .font(.noto(config.titleFontSize, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.headerTopPadding)
                .padding(.bottom, config.bottomTitlePadding)
                
                // Menu List
                VStack(spacing: 0) {
                    
                    // MARK: - Page Content
                        TabView(selection: $currentPage) {
                            ForEach(pages.indices, id: \.self) { index in
                                ZStack {
                                    Image(pages[index].imageName)
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: config.isIPad ? 570 : 370, height: config.isIPad ? 835 : 635)
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: config.isIPad ? 835 : 635)
                        .padding(.top, config.isIPad ? 35 : 15)
                    
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
                        .padding(.bottom, config.isIPad ? 15 : 20)
                    }
                    
                    // MARK: - Buttons
                        HStack(alignment: .bottom, spacing: config.isIPad ? 100 : 24) {
                            if currentPage > 0 {
                                SecondButton(
                                    title: L("< ย้อนกลับ"),
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
                                    title: L("ต่อไป >"),
                                    action: { currentPage += 1 },
                                    width: config.isIPad ? 180 : 160,
                                    height: config.isIPad ? 60 : 58
                                )
                            } else {
                                Color.clear
                                    .frame(width: config.isIPad ? 180 : 160, height: config.isIPad ? 60 : 58)
                            }
                        }
                        .padding(.bottom, config.isIPad ? 20 : 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    GuideView()
}
