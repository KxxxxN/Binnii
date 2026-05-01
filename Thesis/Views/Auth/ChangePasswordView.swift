//
//  ChangePasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import SwiftUI

struct ChangePasswordView: View {
    @StateObject private var viewModel = ChangePasswordViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var source: ChangePasswordSource = .forgotPassword
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Header
                    ZStack {
                        Text(L("เปลี่ยนรหัสผ่านใหม่"))
                            .font(.noto(config.titleFontSize, weight: .bold))
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.top, config.headerTopPadding)
                    .padding(.bottom, config.isIPad ? 50 : 21)
                    
                    // MARK: - New Password
                    ChangePasswordField(
                        title: L("รหัสผ่าน"),
                        placeholder: L("อย่างน้อย 8 ตัวอักษร"),
                        text: $viewModel.password,
                        isValid: .constant(!viewModel.isChangePasswordSubmitted || viewModel.isPasswordValid),
                        errorMessage: viewModel.isChangePasswordSubmitted && !viewModel.isPasswordValid
                        ? (viewModel.password.isEmpty
                           ? L("กรุณากรอกรหัสผ่าน")
                           : !ValidationHelper.isPasswordValid(viewModel.password)
                           ? L("รูปแบบรหัสผ่านไม่ถูกต้อง")
                           : L("รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านเดิม"))
                        : "",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isPasswordVisible,
                        config: config
                    )
                    .onChange(of: viewModel.password) { _, _ in
                        viewModel.validateOnPasswordChange()
                    }
                    
                    if !ValidationHelper.isPasswordValid(viewModel.password) {
                        PasswordValidationCheckView(password: viewModel.password, config: config)
                            .frame(maxWidth: config.isIPad ? 520 : 400, alignment: .leading)
                            .padding(.top, -7)
                            .padding(.bottom, 5)
                    }
                    
                    // MARK: - Confirm Password
                    ChangePasswordField(
                        title: L("ยืนยันรหัสผ่าน"),
                        placeholder: L("กรอกรหัสผ่านอีกครั้ง"),
                        text: $viewModel.confirmPassword,
                        isValid: .constant(!viewModel.isChangePasswordSubmitted || viewModel.isConfirmPasswordValid),
                        errorMessage: viewModel.isChangePasswordSubmitted && !viewModel.isConfirmPasswordValid
                        ? (viewModel.confirmPassword.isEmpty
                           ? L("กรุณากรอกรหัสผ่านอีกครั้ง")
                           : !viewModel.isPasswordValid
                           ? L("รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านเดิม")
                           : L("รหัสผ่านไม่ตรงกัน"))
                        : "",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isConfirmPasswordVisible,
                        config: config
                    )
                    .onChange(of: viewModel.confirmPassword) { _, _ in
                        viewModel.clearError(for: "confirmPassword")
                    }
                    
                    // MARK: - Submit Button
                    PrimaryButton(
                        title: L("ยืนยัน"),
                        action: {
                            Task {
                                await viewModel.changePassword(source: source)
                            }
                        },
                        width: config.isIPad ? 220 : 155,
                        height: config.isIPad ? 60 : 49
                    )
                    .padding(.top, config.isIPad ? 65 : 55)
                    
                    Spacer()
                }
                .frame(minHeight: geo.size.height)
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                
                // MARK: - Popups
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: L("เปลี่ยนรหัสผ่านสำเร็จ")) {
                        viewModel.showSuccessPopup = false
                        switch source {
                        case .forgotPassword: viewModel.navigateToLogin = true
                        case .profile:        viewModel.navigateToProfile = true
                        }
                    }
                }
                
                if viewModel.showErrorPopup {
                    ErrorPopupView(
                        title: L("ดำเนินการไม่สำเร็จ")
                    ) {
                        withAnimation {
                            viewModel.showErrorPopup = false
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.navigateToLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $viewModel.navigateToProfile) {
                ProfileView()
            }
        }
    }
}

#Preview {
   ChangePasswordView()
}
