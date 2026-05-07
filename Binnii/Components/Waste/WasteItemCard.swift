//
//  WasteItemCard.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

import SwiftUI

struct WasteItemCard: View {
    let title: String
    let date: String
    let imageUrl: String?
    let config: ResponsiveConfig
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        HStack(spacing: config.spacingMedium) {
            if let urlString = imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.thirdColor
                }
                .frame(width: config.wasteItemImageWidth,
                       height: config.wasteItemImageHeight)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: config.wasteItemImageRadius))
            } else {
                RoundedRectangle(cornerRadius: config.wasteItemImageRadius)
                    .fill(Color.thirdColor)
                    .frame(width: config.wasteItemImageWidth,
                           height: config.wasteItemImageHeight)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(L(title))
                    .font(.noto(config.fontHeader, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(date)
                    .font(.noto(config.fontCaption, weight: .medium))
                    .foregroundColor(.black)
            }
            
        }
        .padding(.horizontal, config.paddingMedium)
        .frame(height: config.wasteItemCardHeight)
        .background(Color.thirdColor)
        .clipShape(RoundedRectangle(cornerRadius: config.bannerCornerRadius))
    }
}
