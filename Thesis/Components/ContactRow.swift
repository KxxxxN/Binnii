//
//  ContactRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//


import SwiftUI

struct ContactRow: View {
    let title: String
/* let subtitle: String?*/ // อาจเพิ่มข้อมูลติดต่อย่อย
    let imageName: String // ไอคอนช่องทางติดต่อ
    let config: ResponsiveConfig
    let action: () -> Void // action เมื่อกด (เช่น เปิดเบราว์เซอร์/โทรศัพท์)

    var body: some View {
        Button(action: action) {
            HStack(spacing: config.accountRowSpacing) {
                // Icon
                Image(imageName)
                    .resizable()
                    .frame(width: config.accountRowIconSize, height: config.accountRowIconSize)
                    .padding(.leading, config.accountRowIconLeading)
                
                // Text และ Subtitle
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.noto(config.accountRowFontSize, weight: .medium)) 
                        .foregroundColor(Color.black)
                    
//                    if let subtitle = subtitle {
//                        Text(subtitle)
//                            // ถ้าอนาคตใช้ subtitle ให้ขนาดฟอนต์เล็กกว่า title ลงมาสักหน่อยครับ
//                            .font(.system(size: max(config.accountRowFontSize - 6, 12)))
//                            .foregroundColor(.gray)
//                    }
                }
                
                Spacer()
                
            }
            .padding(.trailing, config.paddingStandard) // ปรับ padding ขวาให้มีมาตรฐานเดียวกับหน้าอื่น
            .frame(height: config.accountRowHeight) // ปรับความสูงของแถว
            .background(Color.accountSecColor)
        }
    }
}
