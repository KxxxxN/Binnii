//
//  WasteHeaderView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct WasteHeaderView: View {
    let title: String
    let config: ResponsiveConfig

    var body: some View {
        ZStack {
            Color.mainColor
            ZStack {
                Text(title)
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.white)
                HStack {
                    BackButtonWhite()
                    Spacer()
                }
            }
            .padding(.top, config.headerTopPadding)
            .padding(.bottom, config.paddingStandard)
            .padding(.horizontal, config.paddingMedium)
        }
        .frame(height: config.searchHeaderHeight)
        .cornerRadius(config.bannerCornerRadius, corners: [.bottomLeft, .bottomRight])
    }
}
