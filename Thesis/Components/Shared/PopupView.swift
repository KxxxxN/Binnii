//
//  PopupView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//

import SwiftUI

// MARK: - Privacy Popup View
struct PrivacyPopupView: View {
    @Binding var showPrivacyPopup: Bool
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showPrivacyPopup = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(.top, 10)
                            .padding(.horizontal, 10)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                ScrollView {
                    Text(L("""
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit.  
                    ... (ข้อความนโยบายความเป็นส่วนตัว)
                    """))
                    .font(.noto(16))
                    .padding()
                }
                .frame(height: 500)
                .background(Color.white.opacity(0.9))
                .cornerRadius(15)
            }
            .padding()
            .frame(width: 386)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale)
            .animation(.spring(), value: showPrivacyPopup)
        }
    }
}

// MARK: - Success Popup View
struct SuccessPopupView: View {
    let message: String
    var onDismiss: () -> Void
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        onDismiss()
                    }
                }
            
            VStack {
                VStack(spacing: 29) {
                    Image("Passmark")
                        .resizable()
                        .frame(width: 111, height: 111)
                    
                    Text(L(message))
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding(40)
                .frame(width: 340)
//                .frame(width: 343, height: 255)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .transition(.scale)
            }
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onDismiss()
            }
        }
    }
}

// MARK: - Error Popup View
struct ErrorPopupView: View {
    let title: String
    var onDismiss: () -> Void
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            VStack {
                VStack(spacing: 0) {
                    Image("Errormark")
                        .resizable()
                        .frame(width: 111, height: 111)
                        .padding(.bottom,29)
                    
                    VStack(spacing:0){
                        Text(L(title))
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom,7)
                        
                        Text(L("กรุณาลองใหม่อีกครั้ง"))
                            .font(.noto(18, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(40)
                .frame(width: 340)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .transition(.scale)
            }
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onDismiss()
            }
        }
    }
}

#Preview("Privacy Popup") {
    PrivacyPopupView(showPrivacyPopup: .constant(true))
}
