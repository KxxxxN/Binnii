//
//  BarcodeLoadingOverlay.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct BarcodeLoadingOverlay: View {
    let config: ResponsiveConfig

    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack(spacing: config.spacingSmall) {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(config.isIPad ? 2.0 : 1.5)
                Text("กำลังค้นหาข้อมูล...")
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}
