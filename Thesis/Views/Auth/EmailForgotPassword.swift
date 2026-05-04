//
//  EmailForgotPassword.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//

import SwiftUI

struct EmailForgotPassword: View {
    
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showErrorPopup = false
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack{
                VStack(spacing: 0){
                    ZStack {
                        Text(L("ลืมรหัสผ่าน"))
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(.black)
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.top, config.headerTopPadding)
                    .padding(.bottom, config.isIPad ? 80 : 57)
                    
                    LoginInputField(
                        title: L("ที่อยู่อีเมล"),
                        placeholder: L("กรอกอีเมล"),
                        text: $viewModel.emailForgotPassword,
                        isValid: .constant(!viewModel.isForgotSubmitted || viewModel.emailErrorForgot == nil),
                        errorMessage: viewModel.isForgotSubmitted ? (viewModel.emailErrorForgot ?? "") : "",
                        config: config
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: viewModel.emailForgotPassword) {
                        viewModel.clearError()
                    }
                    
                    PrimaryButton(
                        title: L("ส่งรหัส OTP"),
                        action: {
                            Task {
                                await viewModel.forgotPassword()
                                if viewModel.hasNetworkError {
                                    showErrorPopup = true
                                    viewModel.hasNetworkError = false
                                }
                            }
                        },
                        width: config.isIPad ? 220 : 155,
                        height: config.isIPad ? 60 : 49
                    )
                    .padding(.top, 40)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .ignoresSafeArea()
                .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                    OTPConfirmView(
                        source: .forgotPassword,
                        email: viewModel.emailForgotPassword
                    )
                }
                .navigationBarBackButtonHidden(true)
                .blur(radius: showErrorPopup ? 3 : 0)
                .disabled(showErrorPopup)
                
                if showErrorPopup {
                    ErrorPopupView(
                        title: L("ส่งรหัส OTP ไม่สำเร็จ"),
                        onDismiss: { showErrorPopup = false }
                    )
                }
            }
        }
    }
}

#Preview {
    EmailForgotPassword()
}
