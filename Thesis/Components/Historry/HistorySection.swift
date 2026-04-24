//
//  HistorySection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/11/2568 BE.
//
import SwiftUI

struct HistorySection: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    let items: [HistoryItem]
    
    var body: some View {
        VStack(spacing: config.rewardVStackSpacing) {
            SectionHeader(
                config: config,
                title: "ประวัติคะแนน",
                destinationView: ScoreHistoryView(hideTabBar: $hideTabBar)
            )
            
            if items.isEmpty {
                NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                    HStack {
                        VStack(alignment: .leading, spacing: config.rewardTextSpacing) {
                            Text("ยังไม่มีคะแนน?")
                                .font(.noto(config.historyTitleFontSize, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("แยกขยะเพื่อเริ่มสะสมคะแนนได้เลย!")
                                .font(.noto(config.rewardSubtitleFontSize, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("0")
                                .font(.system(size: config.titleFontSize, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("คะแนน")
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
