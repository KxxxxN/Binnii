//
//  AiScanResultAlert.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


// AiScanResultAlert.swift
// Thesis

import SwiftUI

struct AiScanResultAlert: View {
    let resultTitle: AttributedString
    let onRescan: () -> Void
    let onConfirm: () -> Void
    let config: ResponsiveConfig

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: config.isIPad ? 24 : 16) {
                Text(resultTitle)
                    .font(.noto(config.isIPad ? 32 : 25, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text("ผลการสแกนตรงกับขยะของคุณหรือไม่?\nหากไม่ถูกต้อง กรุณาสแกนใหม่")
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                HStack(spacing: config.alertButtonSpacing) {
                    Button { onRescan() } label: {
                        Text("สแกนใหม่")
                            .font(.noto(config.fontBody, weight: .bold))
                            .foregroundColor(.mainColor)
                            .frame(width: config.qrAlertButtonWidth, height: config.qrAlertButtonHeight)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.mainColor, lineWidth: 2))
                    }

                    Button { onConfirm() } label: {
                        Text("ถูกต้อง")
                            .font(.noto(config.fontBody, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: config.qrAlertButtonWidth, height: config.qrAlertButtonHeight)
                            .background(Color.mainColor)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(config.paddingStandard)
            .frame(width: config.isIPad ? 460 : 343, height: config.qrAlertHeight)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}