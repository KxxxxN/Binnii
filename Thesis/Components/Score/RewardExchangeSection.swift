//
//  RewardExchangeSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//
import SwiftUI

struct RewardExchangeSection: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    let totalPoints: Int
    @ObservedObject var profileVM: UserProfileViewModel
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    private var displayPoints: Int { isLoggedIn && totalPoints > 0 ? 500 : 0 }
    private var canRedeem: Bool { isLoggedIn && totalPoints >= 500 }
    
    var body: some View {
        VStack(spacing: config.rewardVStackSpacing) {

            HStack {
                Text(L("แลกคะแนน"))
                    .font(.noto(config.sectionHeaderTitleFont, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }

            NavigationLink {
                RewardExchangeView(
                    hideTabBar: $hideTabBar,
                    totalPoints: totalPoints,
                    profileVM: profileVM
                )
                .navigationBarBackButtonHidden(true)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: config.rewardTextSpacing) {

                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("\(displayPoints)")
                                .font(.system(size: config.titleFontSize, weight: .bold))
                                .foregroundColor(.white)

                            Text(L("คะแนน"))
                                .font(.noto(config.mainPointsLabelFontSize, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text(
                            displayPoints == 0
                            ? L("สะสมคะแนนเพื่อแลกชั่วโมงจิตอาสาได้เลย!")
                            : L("แลกชั่วโมงจิตอาสาได้ 5 ชั่วโมง")
                        )
                        .font(.noto(config.rewardSubtitleFontSize, weight: .medium))
                        .foregroundColor(.white)
                    }

                    Spacer()

                    Text(L("แลกคะแนน"))
                        .font(.noto(config.buttonFont, weight: .bold))
                        .foregroundColor(
                            canRedeem ? Color.white : Color.white.opacity(0.5)
                        )
                        .padding(.horizontal, config.rewardCardPadding)
                        .padding(.vertical, config.rewardButtonVPadding)
                        .background(
                            canRedeem ? Color.mainColor : Color.mainColor.opacity(0.5)
                        )
                        .cornerRadius(config.bannerCornerRadius)
                }
                .padding(config.rewardCardPadding)
                .frame(maxWidth: .infinity)
                .frame(height: config.rewardCardHeight)
                .background(Color.secondColor)
                .cornerRadius(20)
            }
            .buttonStyle(.plain)
            .allowsHitTesting(canRedeem)
        }
    }
}
