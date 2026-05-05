//
//  AiScanResultAlert.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct AiScanResultAlert: View {
    // MARK: - Properties
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    let resultTitle: AttributedString
    let onRescan: () -> Void
    let onConfirm: () -> Void
    let config: ResponsiveConfig
    
    // ปรับให้รับ 'manager' เข้ามา หรือใช้ Shared โดยตรงอย่างปลอดภัย
    static func makeResultTitle(category: String, config: ResponsiveConfig) -> AttributedString {
        let manager = LanguageManager.shared
        
        // แนะนำ: ใช้ String Interpolation ร่วมกับการ Localize key
        let prefix = manager.localized("ขยะชิ้นนี้คือ")
        let suffix = manager.localized("ถูกต้องหรือไม่?")
        let categoryName = manager.localized(category) // category ควรเป็น key เช่น "plasticBottle"
        
        var result = AttributedString("\(prefix) ")
        
        var highlight = AttributedString(categoryName)
        highlight.foregroundColor = .black
        highlight.font = .noto(config.isIPad ? 32 : 25, weight: .bold)
        
        result += highlight
        result += AttributedString("\n\(suffix)")
        return result
    }

    var body: some View {
        ZStack {
            // ฉากหลังเบลอ
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: config.isIPad ? 24 : 16) {
                Text(resultTitle)
                    .font(.noto(config.isIPad ? 32 : 25, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text(L("ผลการสแกนตรงกับขยะของคุณหรือไม่?\nหากไม่ถูกต้อง กรุณาสแกนใหม่"))
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                HStack(spacing: config.alertButtonSpacing) {
                    // ปุ่มสแกนใหม่ (Cancel/Rescan)
                    Button { onRescan() } label: {
                        Text(L("สแกนใหม่"))
                            .font(.noto(config.fontBody, weight: .bold))
                            .foregroundColor(.mainColor)
                            .frame(width: config.qrAlertButtonWidth, height: config.qrAlertButtonHeight)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.mainColor, lineWidth: 2)
                            )
                    }

                    // ปุ่มถูกต้อง (Confirm)
                    Button { onConfirm() } label: {
                        Text(L("ถูกต้อง"))
                            .font(.noto(config.fontBody, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: config.qrAlertButtonWidth, height: config.qrAlertButtonHeight)
                            .background(Color.mainColor)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(config.paddingStandard)
            // ใช้ maxWidth เพื่อให้ยืดหยุ่นตามเนื้อหาภาษาอังกฤษที่อาจยาวกว่าไทย
            .frame(width: config.isIPad ? 450 : 380)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}
