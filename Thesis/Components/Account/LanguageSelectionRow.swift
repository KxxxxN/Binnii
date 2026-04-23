//
//  LanguageSelectionRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI

struct LanguageSelectionRow: View {
    let code: String
    let name: String
    let imageName: String
    let selectedCode: String
    let action: (String) -> Void // รับ String (code) เป็น input
    
    // คำนวณสถานะการเลือกภายในตัวมันเอง
    var isSelected: Bool {
        selectedCode == code
    }

    var body: some View {
        Button(action: {
            // ส่ง code กลับไปให้ Parent View อัปเดตสถานะ
            action(code) 
            print("\(name) selected")
        }) {
            HStack(spacing: 15) {
                // Image
                Image(imageName)
                    .resizable()
                    .frame(width: 43, height: 43) 
                    .padding(.leading, 31)

                // Text
                Text(name)
                    .font(.noto(20, weight: .medium))
                    .foregroundColor(Color.black)

                Spacer()

                // Radio Button Logic
                ZStack {
                    // วงกลมด้านนอก (ขอบ)
                    Circle()
                        .stroke(isSelected ? Color.mainColor : Color.mainColor.opacity(0.5), lineWidth: 2)
                        .frame(width: 25, height: 25)

                    // วงกลมด้านใน (จุดที่เติมสีเมื่อถูกเลือก)
                    if isSelected {
                        Circle()
                            .fill(Color.mainColor)
                            .frame(width: 15, height: 15)
                    }
                }
            }
            .padding(.trailing)
            .frame(height: 93)
            .background(Color.accountSecColor)
        }
    }
}
