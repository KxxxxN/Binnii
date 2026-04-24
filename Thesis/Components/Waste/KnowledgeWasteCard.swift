//
//  KnowledgeWasteCard.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/12/2568 BE.
//

import SwiftUI

struct KnowledgeWasteCard: View {
    let config: ResponsiveConfig
    let example: WasteExample

    var body: some View {
        HStack(spacing: 0) {
            Image(example.image)
                .resizable()
                .scaledToFit()
                .frame(width: config.wasteCardImageSize, height: config.wasteCardImageSize)
                .frame(width: config.wasteCardImageSize)
                .padding(10)
                .padding(.leading, config.isIPad ? 25 : 0)

            Text(example.label)
                .font(.noto(config.wasteCardTextFont, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10)
        }
        .frame(height: config.wasteCardHeight)
        .background(Color.wasteCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    KnowledgeView(hideTabBar: .constant(false))
}

