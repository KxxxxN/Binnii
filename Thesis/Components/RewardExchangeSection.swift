//
//  RewardExchangeSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//
import SwiftUI

struct RewardExchangeSection: View {
    let config: ResponsiveConfig // 1. รับ config เข้ามาจากหน้าหลัก
    @Binding var hideTabBar: Bool
    
    var body: some View {
        VStack(spacing: config.rewardVStackSpacing) {

            HStack {
                Text("แลกคะแนน")
                    .font(.noto(config.sectionHeaderTitleFont, weight: .bold))
                    .foregroundColor(.black)

                Spacer()
            }

            NavigationLink {
                RewardExchangeView(hideTabBar: $hideTabBar)
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: config.rewardTextSpacing) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("300")
                                .font(.system(size: config.titleFontSize, weight: .bold))
                                .foregroundColor(.white)

                            Text("คะแนน")
                                .font(.noto(config.mainPointsLabelFontSize, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Text("แลกชั่วโมงจิตอาสาได้ 1 ชั่วโมง")
                            .font(.noto(config.rewardSubtitleFontSize, weight: .medium))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text("แลกคะแนน")
                        .font(.noto(config.buttonFont, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, config.rewardCardPadding) // ใช้ค่าเดิม 24:16
                        .padding(.vertical, config.rewardButtonVPadding)
                        .background(Color.mainColor)
                        .cornerRadius(config.bannerCornerRadius) // ใช้ค่าเดิม 25:20
                }
                .padding(config.rewardCardPadding)
                .frame(maxWidth: .infinity) // ยืดให้เต็มกรอบที่ Parent View กำหนดไว้
                .frame(height: config.rewardCardHeight)
                .background(Color.secondColor)
                .cornerRadius(20) // มุมของการ์ดเป็น 20 คงที่ตามเดิม
            }
            .buttonStyle(.plain)
        }
    }
}
