//
//  BarcodeScanResultAlert.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 23/4/2569 BE.
//

import SwiftUI

struct BarcodeScanResultAlert: View {
    let onDismiss: () -> Void
    let config: ResponsiveConfig
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: config.isIPad ? 24 : 16) {
                Text(L("noBarcodeTitle"))
                    .font(.noto(config.isIPad ? 32 : 25, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text(L("noBarcodeDes"))
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                PrimaryButton(
                    title: L("ตกลง"),
                    action: { onDismiss() },
                    width: config.isIPad ? 140 : 120,
                    height: config.isIPad ? 60 : 40
                )
            }
            .padding(config.paddingStandard)
            .frame(width: config.isIPad ? 460 : 343,height: 255)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}

#Preview {
    GeometryReader { geo in
        let config = ResponsiveConfig(horizontalSizeClass: .compact, geo: geo)
        BarcodeScanResultAlert(
            onDismiss: {},
            config: config
        )
    }
}
