//
//  SocialLoginButton.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI

// MARK: SocialLoginButton
struct SocialLoginButton: View {
    let iconName: String
    let title: String
    let config: ResponsiveConfig
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: config.isIPad ? 20 : 15) {
                Image(iconName)
                    .resizable()
                    .frame(width: config.isIPad ? 40 : 30, height: config.isIPad ? 40 : 30)
                
                Text(title)
                    .font(.noto(config.isIPad ? 22 : 18, weight: .medium))
                    .foregroundColor(.mainColor)
            }
//            .padding(.leading, config.isIPad ? 80 : 54)
            .frame(width: config.isIPad ? 445 : 345, height: config.isIPad ? 60 : 49)
            .frame(alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: config.isIPad ? 25 : 20)
                    .stroke(Color.mainColor, lineWidth: 2)
            )
        }
        .padding(.horizontal, config.paddingStandard)
    }
}
