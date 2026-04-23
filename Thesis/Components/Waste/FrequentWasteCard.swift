//
//  FrequentWasteCard.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/12/2568 BE.
//

import SwiftUI

struct FrequentWasteCard: View {
    let item: FrequentWasteItem
    let config: ResponsiveConfig

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: config.itemCardImageHeight)
            }
            .frame(maxWidth: .infinity)
            .frame(height: config.wasteCardImageZStackHeight)

            VStack(spacing: 4) {
                Text(item.title)
                    .font(.noto(config.fontCaption, weight: .semibold))
                    .foregroundColor(.black)

                Text(item.count)
                    .font(.noto(config.fontSmall, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.bottom, config.paddingMedium)
        }
        .frame(height: config.wasteCardTotalHeight)
        .background(Color.thirdColor)
        .cornerRadius(config.bannerCornerRadius)     
    }
}

