//
//  RegisterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/11/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = RegisterViewModel()
    
    // 1. ดึง Size Class เพื่อทำ Responsive
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            ZStack {
                // ✅ ปูพื้นหลังให้เต็มจอครอบคลุม Safe Area
                Color.backgroundColor.ignoresSafeArea()
                
                GeometryReader { geo in
                    let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
                    let titleFontSize: CGFloat = config.isIPad ? 32 : 25
                    let bodyFontSize: CGFloat = config.isIPad ? 18 : 15
                    
                    VStack { //เปิด Vstack1
                        ZStack {
                            Text("ลงทะเบียน")
                                .font(.noto(titleFontSize, weight: .bold))
                                
                            HStack {
                                BackButton()
                                Spacer()
                            }
                        }
                        .padding(.top, config.topPadding)
                        .padding(.bottom, config.bottomTitlePadding)
                            
                        // MARK: Form Fields
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: config.isIPad ? 10 : -3){ //เปิด Vstack2
                                
                                // First Name
                                RegisterInputField(
                                    title: "ชื่อ",
                                    placeholder: "กรอกชื่อภาษาไทย",
                                    text: $viewModel.firstName,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isFirstNameValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isFirstNameValid ? (viewModel.firstName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกชื่อให้ถูกต้อง") : "",
                                    config: config // ✅ ส่ง config เข้าไป
                                )
                                .onChange(of: viewModel.firstName) { _, _ in
                                    viewModel.clearError(for: "firstName")
                                }
                                
                                // Last Name
                                RegisterInputField(
                                    title: "นามสกุล",
                                    placeholder: "กรอกนามสกุลภาษาไทย",
                                    text: $viewModel.lastName,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isLastNameValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isLastNameValid ? (viewModel.lastName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกนามสกุลให้ถูกต้อง") : "",
                                    config: config // ✅ ส่ง config เข้าไป
                                )
                                .onChange(of: viewModel.lastName) { _, _ in
                                    viewModel.clearError(for: "lastName")
                                }
                                
                                // Email
                                RegisterInputField(
                                    title: "อีเมล",
                                    placeholder: "กรอกอีเมล",
                                    text: $viewModel.email,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isEmailValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isEmailValid ? (viewModel.email.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบอีเมลไม่ถูกต้อง") : "",
                                    config: config // ✅ ส่ง config เข้าไป
                                )
                                .onChange(of: viewModel.email) { _, _ in
                                    viewModel.clearError(for: "email")
                                }

                                
                                // Phone
                                RegisterInputField(
                                    title: "เบอร์โทร",
                                    placeholder: "0XX-XXX-XXXX",
                                    text: $viewModel.phone,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isPhoneValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isPhoneValid ? (viewModel.phone.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบเบอร์โทรไม่ถูกต้อง") : "",
                                    config: config // ✅ ส่ง config เข้าไป
                                )
                                .onChange(of: viewModel.phone) { _, _ in
                                    viewModel.clearError(for: "phone")
                                }
                                
                                // Password
                                RegisterInputField(
                                    title: "รหัสผ่าน",
                                    placeholder: "อย่างน้อย 8 ตัวอักษร",
                                    text: $viewModel.password,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isPasswordValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isPasswordValid ? (viewModel.password.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบรหัสผ่านไม่ถูกต้อง") : "",
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
                                
                                // Password Validation Checklist
                                if !ValidationHelper.isPasswordValid(viewModel.password) {
                                    PasswordValidationCheckView(password: viewModel.password, config: config)
                                        .padding(.top, 0)
                                        .padding(.bottom, 5)
                                        // 💡 ถ้า PasswordValidationCheckView รับ config ได้ ให้ส่งไปด้วยครับ
                                }
                                
                                // Confirm Password
                                RegisterInputField(
                                    title: "ยืนยันรหัสผ่าน",
                                    placeholder: "กรอกรหัสผ่านอีกครั้ง",
                                    text: $viewModel.confirmPassword,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isConfirmPasswordValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isConfirmPasswordValid ? (viewModel.confirmPassword.isEmpty ? "จำเป็นต้องระบุ" : "รหัสผ่านไม่ตรงกัน") : "",
                                    isSecure: true,
                                    isPasswordToggle: $viewModel.isConfirmPasswordVisible,
                                    config: config // ✅ ส่ง config เข้าไป
                                )
                                .onChange(of: viewModel.confirmPassword) { _, _ in
                                    viewModel.clearError(for: "confirmPassword")
                                }
                                
                            }//ปิด Vstack2
                                
                            // MARK: Privacy Accept
                            VStack {
                                HStack {
                                    Button { viewModel.isPrivacyAccepted.toggle() } label: {
                                        Image(systemName: viewModel.isPrivacyAccepted ? "checkmark.square.fill" : "square")
                                            .foregroundColor(viewModel.isPrivacyAccepted ? .mainColor : .mainColor)
                                            .font(.system(size: config.isIPad ? 24 : 20)) // ปรับขนาด Checkbox
                                    }
                                    HStack(spacing:0){
                                        Text("ฉันได้อ่านและยอมรับ")
                                            .font(.noto(bodyFontSize, weight: .medium))
                                            
                                        Button(action: { viewModel.showPrivacyPopup = true }){
                                            Text("นโยบายความเป็นส่วนตัว*")
                                                .font(.noto(bodyFontSize, weight: .semibold))
                                                .foregroundColor(Color.errorColor)
                                                .underline(color: .errorColor)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading) // ✅ เปลี่ยนเป็น maxWidth
                                    
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("จำเป็นต้องยอมรับนโยบายความเป็นส่วนตัว")
                                        .font(.noto(bodyFontSize, weight: .medium))
                                        .foregroundColor(Color.errorColor)
                                        .opacity((!viewModel.isPrivacyAccepted && viewModel.isRegisterSubmitted) ? 1 : 0)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, config.paddingStandard)
                            .padding(.top, 10)
                
                            PrimaryButton(
                                title: "สร้างบัญชี",
                                action: {
                                    Task {
                                        await viewModel.register()
                                    }
                                },
                                width: config.isIPad ? 220 : 155,
                                height: config.isIPad ? 60 : 49
                            )
                            .padding(.vertical, 20)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, config.paddingMedium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                
                // MARK: Privacy Popup
                if viewModel.showPrivacyPopup {
                    PrivacyPopupView(showPrivacyPopup: $viewModel.showPrivacyPopup)
                }
                
                // MARK: Success Popup
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: "สร้างบัญชีสำเร็จ") {
                        // action เมื่อกดปิด popup เอง (ถ้ามีปุ่มหรือการเคาะพื้นหลัง)
                        withAnimation {
                            viewModel.showSuccessPopup = false
                            dismiss()
                        }
                    }
                }
                
                // MARK: Error Popup
                if viewModel.showErrorPopup{
                    ErrorPopupView(title: "สร้างบัญชีไม่สำเร็จ"){
                        withAnimation {
                            viewModel.showErrorPopup = false
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }
}
