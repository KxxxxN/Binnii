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
    
    private func mapToTranslationKey(_ title: String) -> String {
        let normalizedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch normalizedTitle {
        case "plastic bottle", "plasticbottle": return "ขวดพลาสติก"
        case "plastic cups", "plastic cup":     return "แก้วพลาสติก"
        case "can", "cans":                     return "กระป๋อง"
        case "cardboard box":                   return "กล่องกระดาษ"
        case "general paper", "paper":          return "กระดาษทั่วไป"
        case "plastic bag":                     return "ถุงพลาสติก"
        case "food waste":                      return "เศษอาหาร"
        case "fruit peel":                      return "เปลือกผลไม้"
        case "crumbs":                          return "เศษขนม"
        case "eggshell":                        return "เปลือกไข่"
        case "leftover drinks":                 return "เครื่องดื่มเหลือ"
        case "leftover ice":                    return "น้ำแข็งเหลือ"
        case "snack bag":                       return "ซองขนม"
        case "food container":                  return "ภาชนะใส่อาหาร"
        case "straw":                           return "หลอด"
        case "tissues", "tissue":               return "กระดาษทิชชู่"
        case "wooden chopsticks":               return "ตะเกียบไม้"
        case "plastic cutlery":                 return "ช้อน-ส้อม พลาสติก"
        default: return title
        }
    }
    
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
                                Text(L(mapToTranslationKey(item.title)))
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
