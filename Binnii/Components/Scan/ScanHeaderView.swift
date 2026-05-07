//
//  ScanHeaderView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct ScanHeaderView: View {
    let title: String
    var aiSuffix: String? = nil
    let isFlashOn: Bool
    let onFlashToggle: () -> Void
    let config: ResponsiveConfig

    var body: some View {
        HStack {
            BackButton()
            Color.clear.frame(width: 10, height: 10)
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(title)
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.black)
                if let suffix = aiSuffix {
                    Text(suffix)
                        .font(.inter(config.titleFontSize, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            Spacer()
            Button { onFlashToggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize)
                    .padding(.trailing, config.paddingStandard)
            }
        }
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.bottomTitlePadding)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}
