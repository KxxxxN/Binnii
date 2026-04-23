//
//  AiScanBottomNavigationBar.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI

struct AiScanBottomNavigationBar: View {
    @Binding var selectedTab: Int
    @Environment(\.horizontalSizeClass) private var sizeClass
    var onSelect: (Int) -> Void

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
            
            ZStack {
                // Background Capsule
                Capsule()
                    .fill(Color.secondColor)
                    .frame(width: config.aiBarWidth, height: config.aiBarHeight)

                // Selection Indicator (ตัวที่เลื่อนไปมา)
                Capsule()
                    .fill(Color.mainColor)
                    .frame(width: config.aiBarTabWidth, height: config.aiBarTabHeight)
                    .offset(x: CGFloat(selectedTab - 1) * config.aiBarTabWidth)

                HStack(spacing: 0) {
                    tabButton(config: config, icon: "Barcode", label: "บาร์โค้ด", index: 0)
                    tabButton(config: config, icon: "Tabler_ai", label: "สแกน", index: 1)
                    tabButton(config: config, icon: "Search", label: "ค้นหา", index: 2)
                }
                .frame(width: config.aiBarWidth)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
    }

    private func tabButton(config: ResponsiveConfig, icon: String, label: String, index: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedTab = index
            }
            onSelect(index)
        } label: {
            HStack(spacing: config.isIPad ? 10 : 6) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: icon == "Tabler_ai" ? config.aiBarAIIconSize : config.aiBarIconSize,
                        height: icon == "Tabler_ai" ? config.aiBarAIIconSize : config.aiBarIconSize
                    )

                Text(label)
                    .font(.noto(config.fontSubBody, weight: .regular))
                    .minimumScaleFactor(0.8) 
            }
            .foregroundColor(.white)
            .frame(width: config.aiBarTabWidth, height: config.aiBarTabHeight)
        }
    }
}

