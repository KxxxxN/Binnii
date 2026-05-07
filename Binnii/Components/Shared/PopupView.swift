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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showPrivacyPopup = false }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .padding(.top, config .isIPad ? 20 : 10)
                                .padding(.horizontal, config .isIPad ? 20 : 10)
                                .background(Color.white.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text(L("Privacy Policy"))
                                    .font(.noto(config.fontBody, weight: .bold))
                                    .foregroundColor(.black)
                                Text(L("privacy_intro"))
                                    .font(.noto(config.fontBody, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                // Section 1
                                PrivacySectionHeader(title: L("privacy_section1_title"), config: config)
                                PrivacyBulletText(text: L("privacy_section1_personal_data"), config: config)
                                PrivacyBulletText(text: L("privacy_section1_sensitive_data"), config: config)
                                PrivacyBulletText(text: L("privacy_section1_user"), config: config)
                            }
                            VStack(alignment: .leading, spacing: 0) {
                                // Section 2
                                PrivacySectionHeader(title: L("privacy_section2_title"), config: config)
                                PrivacyTableRow(label: L("privacy_s2_identity_label"), detail: L("privacy_s2_identity_detail"), config: config)
                                PrivacyTableRow(label: L("privacy_s2_contact_label"), detail: L("privacy_s2_contact_detail"), config: config)
                                PrivacyTableRow(label: L("privacy_s2_usage_label"), detail: L("privacy_s2_usage_detail"), config: config)
                                PrivacyTableRow(label: L("privacy_s2_technical_label"), detail: L("privacy_s2_technical_detail"), config: config)
                            }
                            //                         // Section 3
                            VStack(alignment: .leading, spacing: 0) {
                                PrivacySectionHeader(title: L("privacy_section3_title"), config: config)
                                PrivacyBulletText(text: L("privacy_section3_point1"), config: config)
                                PrivacyBulletText(text: L("privacy_section3_point2"), config: config)
                            }
                            //                         // Section 4
                            VStack(alignment: .leading, spacing: 0) {
                                PrivacySectionHeader(title: L("privacy_section4_title"), config: config)
                                PrivacyTableRow(label: L("privacy_s4_ai_label"), detail: L("privacy_s4_ai_detail"), config: config)
                                PrivacyTableRow(label: L("privacy_s4_history_label"), detail: L("privacy_s4_history_detail"), config: config)
                                PrivacyTableRow(label: L("privacy_s4_research_label"), detail: L("privacy_s4_research_detail"), config: config)
                                PrivacyTableRow(label: L("privacy_s4_identity_label"), detail: L("privacy_s4_identity_detail"), config: config)
                                PrivacyTableRow(label: L("privacy_s4_notify_label"), detail: L("privacy_s4_notify_detail"), config: config)
                            }
                            // Section 5
                            VStack(alignment: .leading, spacing: 0) {
                                PrivacySectionHeader(title: L("privacy_section5_title"), config: config)
                                Text(L("privacy_section5_body"))
                                    .font(.noto(config.fontBody, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            
                            // Section 6
                            VStack(alignment: .leading, spacing: 0) {
                                PrivacySectionHeader(title: L("privacy_section6_title"), config: config)
                                Text(L("privacy_section6_body"))
                                    .font(.noto(config.fontBody, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            
                            // Section 7
                            VStack(alignment: .leading, spacing: 0) {
                                PrivacySectionHeader(title: L("privacy_section7_title"), config: config)
                                PrivacyBulletText(text: L("privacy_section7_point1"), config: config)
                                PrivacyBulletText(text: L("privacy_section7_point2"), config: config)
                                PrivacyBulletText(text: L("privacy_section7_point3"), config: config)
                            }
                            
                            // Section 8
                            VStack(alignment: .leading, spacing: 0) {
                                PrivacySectionHeader(title: L("privacy_section8_title"), config: config)
                                PrivacyBulletText(text: L("privacy_s8_right1"), config: config)
                                PrivacyBulletText(text: L("privacy_s8_right2"), config: config)
                                PrivacyBulletText(text: L("privacy_s8_right3"), config: config)
                                PrivacyBulletText(text: L("privacy_s8_right4"), config: config)
                                PrivacyBulletText(text: L("privacy_s8_right5"), config: config)
                            }
                            
                            // Section 9
                            VStack(alignment: .leading, spacing: 0) {
                                PrivacySectionHeader(title: L("privacy_section9_title"), config: config)
                                Text(L("privacy_section9_body"))
                                    .font(.noto(config.fontBody, weight: .medium))
                                    .foregroundColor(.black)
                                Text(L("privacy_section9_contact"))
                                    .font(.noto(config.fontBody, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, config .isIPad ? 20 : 10)
                        .padding(.bottom, config .isIPad ? 20 : 10)
                    }
                    .frame(height: config .isIPad ? 800 : 500)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(15)
                }
                .frame(width: config .isIPad ? 600 : 386)
                .background(Color.white)
                .cornerRadius(config.bannerCornerRadius)
                .shadow(radius: 10)
                .transition(.scale)
                .animation(.spring(), value: showPrivacyPopup)
            }
        }
    }
}

private struct PrivacySectionHeader: View {
    let title: String
    let config: ResponsiveConfig
    var body: some View {
        Text(title)
            .font(.noto(config.fontBody, weight: .bold))
            .foregroundColor(.black)
            .padding(.top, 8)
    }
}

private struct PrivacyBulletText: View {
    let text: String
    let config: ResponsiveConfig
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
//            Text("•")
//                .font(.noto(18, weight: .medium))
//                .foregroundColor(.black)
            Text(text)
                .font(.noto(config.fontBody, weight: .medium))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct PrivacyTableRow: View {
    let label: String
    let detail: String
    let config: ResponsiveConfig
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.noto(config.fontBody, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 110, alignment: .leading)
            Text(detail)
                .font(.noto(config.fontBody, weight: .medium))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
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
