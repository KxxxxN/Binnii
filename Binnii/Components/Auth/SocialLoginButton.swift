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
            HStack(spacing: 0) {
                Image(iconName)
                    .resizable()
                    .frame(width: config.isIPad ? 40 : 30, height: config.isIPad ? 40 : 30)
                    .padding(.leading, config.isIPad ? 70 : 54)
                    .padding(.trailing, config.isIPad ? 20 : 15)
                
                Text(title)
                    .font(.noto(config.isIPad ? 22 : 18, weight: .medium))
                    .foregroundColor(.mainColor)
                
                Spacer()
            }
            .frame(width: config.isIPad ? 445 : 345, height: config.isIPad ? 60 : 49)
            .overlay(
                RoundedRectangle(cornerRadius: config.isIPad ? 25 : 20)
                    .stroke(Color.mainColor, lineWidth: 2)
            )
        }
        .padding(.horizontal, config.paddingStandard)
    }
}

#Preview {
    LoginView()
            .environmentObject(AuthViewModel())
}
