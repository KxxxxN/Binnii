//
//  LogoutPopupView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 23/4/2569 BE.
//


import SwiftUI

struct LogoutPopupView: View {
    @Binding var isPresented: Bool
    var onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 0) {

                // รูป Logout
                Image("PopupLogout")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100,height: 100)
                    .padding(.top, 30)

                // หัวข้อ
                Text("ออกจากระบบ?")
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 20)

                // คำอธิบาย
                Text("คุณสามารถเข้าสู่ระบบใหม่ได้ทุกเมื่อ")
                    .font(.noto(16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)

                // ปุ่ม
                HStack(spacing: 21) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("ยกเลิก")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(.mainColor)
                            .frame(width: 120, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.mainColor, lineWidth: 1.5)
                            )
                    }


                    Button {
                        isPresented = false
                        onConfirm()
                    } label: {
                        Text("ออกจากระบบ")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 40)
                            .background(Color.mainColor)
                            .cornerRadius(20)
                    }
                }
                .padding(.bottom, 24)
            }
            .frame(width: 320, height: 320)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    struct LogoutPopupPreviewContainer: View {
        @State private var isPresented = true
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.3).ignoresSafeArea()
                LogoutPopupView(
                    isPresented: $isPresented,
                    onConfirm: { print("Logout confirmed") }
                )
            }
        }
    }
    
    return LogoutPopupPreviewContainer()
}
