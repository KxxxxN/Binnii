//
//  ChangeEmailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//

import SwiftUI

struct ChangeEmailView: View {
    @StateObject private var viewModel = ChangeEmailViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showErrorPopup = false
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                VStack(spacing: 0) {
                    ZStack {
                        Text(L("ยืนยันแก้ไขอีเมล"))
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.bottom, config.isIPad ? 100 : 57)
                    
                    // MARK: - Input Field
                    LoginInputField(
                        title: L("ที่อยู่อีเมล"),
                        placeholder: L("กรอกอีเมลที่ต้องการแก้ไข"),
                        text: $viewModel.newEmail,
                        isValid: .constant(!viewModel.isSubmitted || viewModel.emailError == nil),
                        errorMessage: viewModel.isSubmitted ? (viewModel.emailError ?? "") : "",
                        config: config
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: viewModel.newEmail) { _, _ in
                        viewModel.clearError()
                    }
                    
                    // MARK: - Action Button
                    PrimaryButton(
                        title: L("ส่งรหัส OTP"),
                        action: {
                            Task {
                                await viewModel.validateEmail()
                                if viewModel.hasNetworkError {
                                    showErrorPopup = true
                                    viewModel.hasNetworkError = false
                                }
                            }
                        },
                        width: config.isIPad ? 220 : 155,
                        height: config.isIPad ? 60 : 49
                    )
                    .padding(.top, config.isIPad ? 55 : 40)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor.ignoresSafeArea())
                .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                    OTPConfirmView(
                        source: .changeEmail,
                        email: viewModel.newEmail
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
    ChangeEmailView()
}
