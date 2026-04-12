//
//  FAQExpandableRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct FAQExpandableRow: View {
    let item: FAQItem
    let config: ResponsiveConfig
    
    let cornerRadiusValue: CGFloat = 20
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // ปุ่มหลัก (คำถาม)
            Button(action: {
                withAnimation(.easeOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
                print("FAQ Toggled: \(item.question)")
            }) {
                HStack(spacing: 0) {
                    Text("\(item.question)?")
                        .font(.noto(config.accountRowFontSize, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.leading, config.accountRowIconLeading)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                        
                    Image(systemName: isExpanded ? "minus" : "plus")
                        .foregroundColor(.black)
                        .font(.system(size: config.accountRowChevronSize))
                }
                .padding(.trailing, config.paddingMedium)
                .frame(maxWidth: .infinity, minHeight: config.accountRowHeight)
                .background(Color.accountSecColor)
                .cornerRadius(cornerRadiusValue, corners: isExpanded ? [.topLeft, .topRight] : .allCorners)
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.answer)
                        .font(.noto(max(config.accountRowFontSize - 4, 14), weight: .regular))
                        .foregroundColor(.black)
                        .lineLimit(nil)
                }
                .padding(.horizontal, config.accountRowIconLeading)
                // 💡 ปรับ Padding ตรงนี้เพิ่มเล็กน้อย เพื่อไม่ให้ข้อความชิดขอบบนของคำตอบมากเกินไป
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accountSecColor)
                .cornerRadius(cornerRadiusValue, corners: [.bottomLeft, .bottomRight])
                // ❌ ลบ .offset(y: -cornerRadiusValue) ออกไปเลย กล่องมันต่อกันสนิทอยู่แล้วครับ
            }
        }
        // ❌ ลบ .padding(.bottom, ...) ออกไปด้วยครับ ไม่ต้องชดเชยระยะแล้ว
    }
}
