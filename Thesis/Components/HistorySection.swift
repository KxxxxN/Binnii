//
//  HistorySection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/11/2568 BE.
//
import SwiftUI

struct HistorySection: View {
    let config: ResponsiveConfig // 1. รับ config เข้ามาจากหน้าหลัก
    @Binding var hideTabBar: Bool
    let items: [HistoryItem]
    
    var body: some View {
        VStack(spacing: config.rewardVStackSpacing) { // ใช้ 12:7 ร่วมกับ Reward
            SectionHeader(
                config: config,
                title: "ประวัติคะแนน",
                destinationView: ScoreHistoryView(hideTabBar: $hideTabBar)
            )
            
            if items.isEmpty {
                // ✅ Empty state card
                NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                    HStack {
                        VStack(alignment: .leading, spacing: config.rewardTextSpacing) { // ใช้ 6:3 ร่วมกับ Reward
                            Text("ยังไม่มีคะแนน?")
                                .font(.noto(config.historyTitleFontSize, weight: .bold)) // ค่าใหม่ 24:20
                                .foregroundColor(.white)
                            
                            Text("แยกขยะเพื่อเริ่มสะสมคะแนนได้เลย!")
                                .font(.noto(config.rewardSubtitleFontSize, weight: .medium)) // ใช้ 18:14 ร่วมกับ Reward
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("0")
                                .font(.system(size: config.titleFontSize, weight: .bold)) // ใช้ 36:25 จาก Shared
                                .foregroundColor(.white)
                            
                            Text("คะแนน")
                                .font(.noto(config.mainPointsLabelFontSize, weight: .bold)) // ใช้ 20:15
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, config.rewardCardPadding) // ใช้ 24:16 ร่วมกับ Reward
                    .frame(maxWidth: .infinity)
                    .frame(height: config.rewardCardHeight) // ใช้ 110:75 ร่วมกับ Reward
                    .background(Color.secondColor)
                    .cornerRadius(config.bannerCornerRadius) // ใช้ 25:20
                }
            } else {
                ForEach(items) { item in
                    NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                        HStack {
                            VStack(alignment: .leading, spacing: config.rewardTextSpacing) {
                                Text(item.title)
                                    .font(.noto(config.historyTitleFontSize, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(item.date)
                                    .font(.system(size: config.rewardSubtitleFontSize, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 0) {
                                Text(item.points)
                                    .font(.system(size: config.titleFontSize, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text(item.pointsLabel)
                                    .font(.noto(config.mainPointsLabelFontSize, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, config.rewardCardPadding)
                        .frame(maxWidth: .infinity)
                        .frame(height: config.rewardCardHeight)
                        .background(Color.secondColor)
                        .cornerRadius(config.bannerCornerRadius)
                    }
                }
            }
        }
    }
}
