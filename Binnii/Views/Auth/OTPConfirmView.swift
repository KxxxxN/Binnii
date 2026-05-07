//
//  OTPConfirmView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/11/2568 BE.
//

import SwiftUI

struct OTPConfirmView: View {
    let source: OTPSource
    let email: String
    
    @StateObject private var viewModel = OTPConfirmViewModel()
    @FocusState private var focusedField: Int?
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Header
                    ZStack {
                        Text(L("ยืนยันรหัส OTP"))
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.top, config.headerTopPadding)
                    .padding(.bottom, config.isIPad ? 80 : 42)
                    
                    Text(L("ใส่รหัสที่ส่งไปยังอีเมลของคุณ"))
                        .font(.noto(config.isIPad ? 24 : 20, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.bottom, config.isIPad ? 24 : 18)
                    
                    // MARK: - OTP Input
                    OTPInputView(viewModel: viewModel, focusedField: $focusedField, config: config)
                        .padding(.bottom, 15)
                    
                    // MARK: - Error Message
                    Text(viewModel.errorMessage)
                        .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                        .foregroundColor(Color.errorColor)
                        .frame(height: config.isIPad ? 20 : 15)
                        .opacity(viewModel.shouldShowError ? 1 : 0)
                        .padding(.bottom, config.isIPad ? 25 : 18)
                    
                    // MARK: - Action Button
                    PrimaryButton(
                        title: L("ยืนยัน"),
                        action: {
                            focusedField = nil
                            Task {
                                await viewModel.verifyOTP(source: source, email: email)
                            }
                        },
                        width: config.isIPad ? 220 : 155,
                        height: config.isIPad ? 60 : 49
                    )
                    
                    // MARK: - Resend Code
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(L("ยังไม่ได้รับรหัส?"))
                            .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)  // ✅ ป้องกัน wrap ผิด
                        
                        if viewModel.resendCooldown > 0 {
                            Text(L("ส่งรหัสใหม่") + " (\(viewModel.resendCooldown))")
                                .font(.noto(config.isIPad ? 18 : 15, weight: .bold))
                                .foregroundColor(.placeholderColor)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Button(action: {
                                Task {
                                    await viewModel.resendOTP(source: source, email: email)
                                }
                            }) {
                                Text(L("ส่งรหัสใหม่"))
                                    .font(.noto(config.isIPad ? 18 : 15, weight: .bold))
                                    .foregroundColor(.mainColor)
                                    .underline(color: .mainColor)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                    }
                    .multilineTextAlignment(.center)  
                    .padding(.horizontal, config.paddingStandard)
                    .padding(.top, config.isIPad ? 20 : 15)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .ignoresSafeArea()
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                .onAppear {
                    focusedField = 0
                    viewModel.startCooldown()
                }
                .navigationDestination(isPresented: $viewModel.navigateToChangePW) {
                    ChangePasswordView(source: source == .confirmEmail ? .profile : .forgotPassword)
                }
                .navigationDestination(isPresented: $viewModel.navigateToProfile) {
                    ProfileView()
                }
                
                // MARK: - Popups
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: L("แก้ไขอีเมลสำเร็จ")) {
                        viewModel.showSuccessPopup = false
                        viewModel.navigateToProfile = true
                    }
                }
                
                if viewModel.showErrorPopup && source == .changeEmail {
                    ErrorPopupView(title: L("แก้ไขอีเมลไม่สำเร็จ")){
                        withAnimation {
                            viewModel.showErrorPopup = false
                            viewModel.resetOTPFields()
                            focusedField = 0
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    OTPConfirmView(source: .changeEmail, email: "1123kansinee@gmail.com")
}
