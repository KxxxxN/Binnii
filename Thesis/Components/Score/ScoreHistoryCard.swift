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

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.noto(20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(date)
                    .font(.noto(14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 0) {
                Text(points)
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.white)

                Text("คะแนน")
                    .font(.noto(15, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .frame(width: 410, height: 75)
        .background(backgroundColor)
        .cornerRadius(20)
    }
}
