//
//  NewPasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//

import SwiftUI

struct NewPasswordView: View {
    @StateObject private var viewModel = NewPasswordViewModel()
    // 1. ดึง Size Class เพื่อทำ Responsive
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Header
                    ZStack {
                        Text("ตั้งรหัสผ่านใหม่")
                            .font(.noto(config.titleFontSize, weight: .bold))
                        HStack {
                            BackButton(action: {
                                viewModel.navigateToProfile = true
                            })
                            Spacer()
                        }
                    }
                    .padding(.top, config.topPadding)
                    .padding(.bottom, config.bottomTitlePadding)
                    
                    // 1. ช่องรหัสผ่านปัจจุบัน
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
                    
                    // 2. ช่องรหัสผ่านใหม่
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
                        config: config // ✅ ส่ง config
                    )
                    .onChange(of: viewModel.password) { _, _ in
                        viewModel.clearErrorOnTyping(for: "new") // ✅ ระบุว่าเป็นช่อง new
                        
                        // Logic ตรวจสอบความถูกต้องอื่นๆ ของคุณคงเดิม
                        if !viewModel.password.isEmpty {
                            viewModel.isPasswordValid = ValidationHelper.isPasswordValid(viewModel.password)
                        }
                        if !viewModel.confirmPassword.isEmpty {
                            viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                        }
                    }
                    
                    // Checklist แสดงเงื่อนไขรหัสผ่านใหม่
                    if !ValidationHelper.isPasswordValid(viewModel.password) {
                        PasswordValidationCheckView(password: viewModel.password, config: config) // ✅ ส่ง config
                            .padding(.top, 1)
                            .padding(.bottom, 7)
                    }
                    
                    // 3. ช่องยืนยันรหัสผ่านใหม่
                    ChangePasswordField(
                        title: "ยืนยันรหัสผ่านใหม่",
                        placeholder: "กรอกรหัสผ่านใหม่อีกครั้ง",
                        text: $viewModel.confirmPassword,
                        isValid: $viewModel.isConfirmPasswordValid,
                        errorMessage: viewModel.confirmPassword.isEmpty ? "กรุณากรอกรหัสผ่านอีกครั้ง" : "รหัสผ่านไม่ตรงกัน",
                        isSecure: true,
                        isPasswordToggle: $viewModel.isConfirmPasswordVisible,
                        config: config // ✅ ส่ง config
                    )
                    .onChange(of: viewModel.confirmPassword) { _, _ in
                        viewModel.clearErrorOnTyping(for: "confirm")
                    }
                    
                    HStack(alignment: .bottom, spacing: config.isIPad ? 50 : 35){ // ✅ ปรับช่องว่างระหว่างปุ่มบน iPad
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
                .blur(radius: (viewModel.showSuccessAlert || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessAlert || viewModel.showErrorPopup)
                
                // MARK: Success Popup
                if viewModel.showSuccessAlert {
                    SuccessPopupView(message: "เปลี่ยนรหัสผ่านสำเร็จ") {
                        viewModel.showSuccessAlert = false
                        viewModel.navigateToProfile = true
                    }
                }
                
                // MARK: Error Popup
                if viewModel.showErrorPopup{
                    ErrorPopupView(title: "เปลี่ยนรหัสผ่านไม่สำเร็จ"){
                        withAnimation {
                            viewModel.showErrorPopup = false
                        }
                    }
                }
            }
            .background(Color.backgroundColor.ignoresSafeArea())
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
