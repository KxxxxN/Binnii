//
//  ChangePasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import SwiftUI

struct ChangePasswordView: View {
    @StateObject private var viewModel = ChangePasswordViewModel()
    
    // 1. ดึง Size Class เพื่อทำ Responsive
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                GeometryReader { geo in
                    let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
                    
                    // ✅ 1. เพิ่ม ScrollView ครอบ VStack
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{ //เปิด Vstack1
                            ZStack { //เปิด Zstack1
                                Text("เปลี่ยนรหัสผ่านใหม่")
                                    .font(.noto(config.titleFontSize, weight: .bold))
                                HStack { //เปิด Hstack1
                                    BackButton()
                                    Spacer()
                                }//ปิด Hstack1
                            }//ปิด Zstack1
                            .padding(.top, config.topPadding)
                            .padding(.bottom, config.bottomTitlePadding)
                            
                            // --- 1. ช่องรหัสผ่านใหม่ ---
                            ChangePasswordField(
                                title: "รหัสผ่าน",
                                placeholder: "อย่างน้อย 8 ตัวอักษร",
                                text: $viewModel.password,
                                isValid: .constant(!viewModel.isChangePasswordSubmitted || viewModel.isPasswordValid),
                                errorMessage: viewModel.isChangePasswordSubmitted && !viewModel.isPasswordValid ? (viewModel.password.isEmpty ? "กรุณากรอกรหัสผ่าน" : !ValidationHelper.isPasswordValid(viewModel.password) ? "รูปแบบรหัสผ่านไม่ถูกต้อง" : "รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านเดิม") : "",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isPasswordVisible,
                                config: config // ✅ ส่ง config เข้าไป
                            )
                            .onChange(of: viewModel.password) { _, _ in
                                viewModel.clearError(for: "password")
                                // ตรวจสอบ Confirm Password ใหม่ด้วยถ้ามีข้อมูลอยู่แล้ว
                                if !viewModel.confirmPassword.isEmpty {
                                    viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                                }
                            }
                            
                            if !ValidationHelper.isPasswordValid(viewModel.password) {
                                PasswordValidationCheckView(password: viewModel.password, config: config)
                                    .padding(.top, -7)
                                    .padding(.bottom, 5)
                            }
                            
                            // --- 2. ช่องยืนยันรหัสผ่าน ---
                            ChangePasswordField(
                                title: "ยืนยันรหัสผ่าน",
                                placeholder: "กรอกรหัสผ่านอีกครั้ง",
                                text: $viewModel.confirmPassword,
                                isValid: .constant(!viewModel.isChangePasswordSubmitted || viewModel.isConfirmPasswordValid),
                                errorMessage: viewModel.isChangePasswordSubmitted && !viewModel.isConfirmPasswordValid ? (viewModel.confirmPassword.isEmpty ? "กรุณากรอกรหัสผ่านอีกครั้ง" : !viewModel.isPasswordValid ? "รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านเดิม" : "รหัสผ่านไม่ตรงกัน") : "",
                                isSecure: true,
                                isPasswordToggle: $viewModel.isConfirmPasswordVisible,
                                config: config
                            )
                            .onChange(of: viewModel.confirmPassword) { _, _ in
                                viewModel.clearError(for: "confirmPassword")
                            }

                            PrimaryButton(
                                title: "ยืนยัน",
                                action: {
                                    Task {
                                        await viewModel.changePassword()
                                    }
                                },
                                width: config.isIPad ? 220 : 155,
                                height: config.isIPad ? 60 : 49
                            )
                            .padding(.top, config.isIPad ? 65 : 55)
                            
                            Spacer() // ดันเนื้อหาขึ้นด้านบน
                            
                        }//ปิด Vstack1
                        // ✅ 2. กำหนด minHeight ให้ VStack เพื่อให้ Spacer() ยังทำงานได้ถูกต้องในเนื้อหาที่สั้นกว่าจอ
                        .frame(minHeight: geo.size.height)
                        
                    } // ปิด ScrollView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // ✅ ย้าย Modifier เหล่านี้มาไว้ที่ ScrollView
                    .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                    .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                }
                
                // MARK: - Popups
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: "เปลี่ยนรหัสผ่านสำเร็จ") {
                        withAnimation {
                            viewModel.showSuccessPopup = false
                            viewModel.navigateToLogin = true
                        }
                    }
                }
                
                if viewModel.showErrorPopup {
                    ErrorPopupView(
                        title: "ดำเนินการไม่สำเร็จ"
                    ) {
                        withAnimation {
                            viewModel.showErrorPopup = false
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.navigateToLogin) {
                LoginView()
            }
        }
    }
}
