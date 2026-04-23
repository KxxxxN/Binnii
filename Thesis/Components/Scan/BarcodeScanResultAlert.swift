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

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: config.isIPad ? 24 : 16) {
                Text("ไม่พบบาร์โค้ดนี้")
                    .font(.noto(config.isIPad ? 32 : 25, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text("กรุณาสแกนใหม่ หรือเลือกใช้\nสแกนด้วย AI หรือค้นหา")
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                PrimaryButton(
                    title: "ตกลง",
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
