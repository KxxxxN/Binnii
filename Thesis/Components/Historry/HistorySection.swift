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
    
    private func cardColor(for points: String) -> Color {
        points.hasPrefix("-") ? Color.dangerColor : Color.secondColor
    }
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        VStack(spacing: config.rewardVStackSpacing) {
            SectionHeader(
                config: config,
                title: L("ประวัติคะแนน"),
                destinationView: ScoreHistoryView(hideTabBar: $hideTabBar)
            )
            
            if items.isEmpty {
                NavigationLink(destination: ScoreHistoryView(hideTabBar: $hideTabBar)) {
                    HStack {
                        VStack(alignment: .leading, spacing: config.rewardTextSpacing) {
                            Text(L("ยังไม่มีคะแนน?"))
                                .font(.noto(config.historyTitleFontSize, weight: .bold))
                                .foregroundColor(.white)

                            Text(L("แยกขยะเพื่อเริ่มสะสมคะแนนได้เลย!"))
                                .font(.noto(config.rewardSubtitleFontSize, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("0")
                                .font(.system(size: config.titleFontSize, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(L("คะแนน"))
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
                                Text(L(item.title))
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
                                
                                Text(L(item.pointsLabel))
                                    .font(.noto(config.mainPointsLabelFontSize, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, config.rewardCardPadding)
                        .frame(maxWidth: .infinity)
                        .frame(height: config.rewardCardHeight)
//                        .background(Color.secondColor)
                        .background(cardColor(for: item.points))
                        .cornerRadius(config.bannerCornerRadius)
                    }
                }
            }
        }
    }
}
