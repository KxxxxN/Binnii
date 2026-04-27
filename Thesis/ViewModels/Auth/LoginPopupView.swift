//
//  LoginPopupView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 23/4/2569 BE.
//


import SwiftUI

struct LoginPopupView: View {
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)? = nil
    var onLogin: (() -> Void)? = nil
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Circle()
                    .fill(Color.mainColor)
                    .frame(width: 85, height: 85)
                    .overlay(
                        Image("Profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    .padding(.top, 30)

                Text(L("เริ่มใช้งาน"))
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top,20)

                Text(L("กรุณาเข้าสู่ระบบเพื่อใช้งานได้ทันที"))
                    .font(.noto(16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)

                HStack(spacing: 21) {
                    SecondButton(
                        title: L("ภายหลัง"),
                        action: {
                            isPresented = false
                            onDismiss?()
                        },
                        width: 120,
                        height: 40
                    )
                    
                    NavigationLink(destination: LoginView()) {
                        PrimaryButton(
                            title: L("เข้าสู่ระบบ"),
                            action: { isPresented = false
                                onLogin?()},
                            width: 120,
                            height: 40
                        )
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
    struct LoginPopupPreviewContainer: View {
        @State private var isPresented = true
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.3).ignoresSafeArea()
                LoginPopupView(isPresented: $isPresented)
            }
        }
    }
    
    return LoginPopupPreviewContainer()
}
