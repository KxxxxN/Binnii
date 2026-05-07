//
//  ScoreHistoryCard.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/12/2568 BE.
//

import SwiftUI

struct ScoreCard: View {
    let title: String
    let date: String
    let points: String
    let backgroundColor: Color
    let config: ResponsiveConfig
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(L(title))
                    .font(.noto(config.scoreCardTitleFont, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(date)
                    .font(.noto(config.scoreCardDateFont, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 0) {
                Text(points)
                    .font(.noto(config.scoreCardPointsFont, weight: .bold))
                    .foregroundColor(.white)

                Text(L("คะแนน"))
                    .font(.noto(config.scoreCardLabelFont, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, config.rewardCardPadding)
        .frame(maxWidth: .infinity)
        .frame(height: config.rewardCardHeight)
        .background(backgroundColor)
        .cornerRadius(config.bannerCornerRadius)    }
}

#Preview {
    ScoreHistoryView(hideTabBar: .constant(true))
}
