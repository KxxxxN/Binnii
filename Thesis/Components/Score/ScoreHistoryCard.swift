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

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
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

                Text("คะแนน")
                    .font(.noto(config.scoreCardLabelFont, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, config.paddingMedium)
        .frame(width: config.isIPad ? 700 : 410, height: config.isIPad ? 110 : 75)
        .background(backgroundColor)
        .cornerRadius(config.bannerCornerRadius)
    }
}

#Preview {
    ScoreHistoryView(hideTabBar: .constant(true))
}
