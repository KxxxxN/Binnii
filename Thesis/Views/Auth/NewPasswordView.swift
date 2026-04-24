//
//  NewPasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//

import SwiftUI

struct NewPasswordView: View {
    @StateObject private var viewModel = NewPasswordViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Header
                    ZStack {
                        Text("เปลี่ยนรหัสผ่าน")
                            .font(.noto(config.titleFontSize, weight: .bold))
                        HStack {
                            BackButton(action: {
                                viewModel.navigateToProfile = true
                            })
                            Spacer()
                        }
                    }
                    .padding(.top, config.headerTopPadding)
                    .padding(.bottom, config.bottomTitlePadding)
                    
                    // MARK: - Old Password
                    ChangePasswordField(
                        title: "รหัสผ่านเก่า",
                        placeholder: "กรอกรหัสผ่านปัจจุบัน",
                        text: $viewModel.oldPassword,
                        isValid: $viewModel.isOldPasswordValid,
                        errorMessage: viewModel.oldPassword.isEmpty ? "กรุณากรอกรหัสผ่าน" : "รหัสผ่านเดิมไม่ถูกต้อง",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isOldPasswordVisible,
                        config: config
                    )
                    .padding(.bottom, 5)
                    .onChange(of: viewModel.oldPassword) { _, _ in
                        viewModel.clearErrorOnTyping(for: "old")
                    }

                    // MARK: - New Password
                    ChangePasswordField(
                        title: "รหัสผ่านใหม่",
                        placeholder: "อย่างน้อย 8 ตัวอักษร",
                        text: $viewModel.password,
                        isValid: $viewModel.isPasswordValid,
                        errorMessage: viewModel.password.isEmpty ? "กรุณากรอกรหัสผ่าน"
                        : viewModel.password == viewModel.oldPassword ? "รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านเดิม"
                        : "รูปแบบรหัสผ่านไม่ถูกต้อง",
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
                            .padding(.top, 1)
                            .padding(.bottom, 7)
                    }

                    // MARK: - Confirm Password
                    ChangePasswordField(
                        title: "ยืนยันรหัสผ่านใหม่",
                        placeholder: "กรอกรหัสผ่านใหม่อีกครั้ง",
                        text: $viewModel.confirmPassword,
                        isValid: $viewModel.isConfirmPasswordValid,
                        errorMessage: viewModel.confirmPassword.isEmpty ? "กรุณากรอกรหัสผ่านอีกครั้ง" : "รหัสผ่านไม่ตรงกัน",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isConfirmPasswordVisible,
                        config: config
                    )
                    .onChange(of: viewModel.confirmPassword) { _, _ in
                        viewModel.clearErrorOnTyping(for: "confirm")
                    }
                    
                    HStack(alignment: .bottom, spacing: config.isIPad ? 50 : 35){
                        SecondButton(
                            title: "ยกเลิก",
                            action: { viewModel.navigateToProfile = true },
                            width: config.isIPad ? 180 : 155,
                            height: config.isIPad ? 60 : 49
                        )
                        
                        PrimaryButton(
                            title: "บันทึก",
                            action: {
                                Task {
                                    await viewModel.saveNewPassword()
                                }
                            },
                            width: config.isIPad ? 180 : 155,
                            height: config.isIPad ? 60 : 49
                        )
                    }
                    .padding(.top, config.isIPad ? 30 : 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .ignoresSafeArea()
                .blur(radius: (viewModel.showSuccessAlert || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessAlert || viewModel.showErrorPopup)
                
                // MARK: - Popups
                if viewModel.showSuccessAlert {
                    SuccessPopupView(message: "เปลี่ยนรหัสผ่านสำเร็จ") {
                        viewModel.showSuccessAlert = false
                        viewModel.navigateToProfile = true
                    }
                }

                if viewModel.showErrorPopup{
                    ErrorPopupView(title: "เปลี่ยนรหัสผ่านไม่สำเร็จ"){
                        withAnimation {
                            viewModel.showErrorPopup = false
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.navigateToProfile) {
                ProfileView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    NewPasswordView()
}
