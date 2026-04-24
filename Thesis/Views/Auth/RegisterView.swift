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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
                let bodyFontSize: CGFloat = config.isIPad ? 18 : 15
                ZStack {
                    VStack {
                        // MARK: - Header
                        ZStack {
                            Text("ลงทะเบียน")
                                .font(.noto(config.titleFontSize, weight: .bold))
                            
                            HStack {
                                BackButton()
                                Spacer()
                            }
                        }
                        .padding(.top, config.headerTopPadding)
                        .padding(.bottom, config.bottomTitlePadding)
                        
                        // MARK: - Form Fields
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: config.isIPad ? 10 : -3){
                                
                                RegisterInputField(
                                    title: "ชื่อ",
                                    placeholder: "กรอกชื่อภาษาไทย",
                                    text: $viewModel.firstName,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isFirstNameValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isFirstNameValid ? (viewModel.firstName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกชื่อให้ถูกต้อง") : "",
                                    config: config
                                )
                                .onChange(of: viewModel.firstName) { _, _ in
                                    viewModel.clearError(for: "firstName")
                                }
                                
                                RegisterInputField(
                                    title: "นามสกุล",
                                    placeholder: "กรอกนามสกุลภาษาไทย",
                                    text: $viewModel.lastName,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isLastNameValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isLastNameValid ? (viewModel.lastName.isEmpty ? "จำเป็นต้องระบุ" : "กรุณากรอกนามสกุลให้ถูกต้อง") : "",
                                    config: config
                                )
                                .onChange(of: viewModel.lastName) { _, _ in
                                    viewModel.clearError(for: "lastName")
                                }
                                
                                RegisterInputField(
                                    title: "อีเมล",
                                    placeholder: "กรอกอีเมล",
                                    text: $viewModel.email,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isEmailValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isEmailValid ? (viewModel.email.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบอีเมลไม่ถูกต้อง") : "",
                                    config: config
                                )
                                .onChange(of: viewModel.email) { _, _ in
                                    viewModel.clearError(for: "email")
                                }
                                
                                RegisterInputField(
                                    title: "เบอร์โทร",
                                    placeholder: "0XX-XXX-XXXX",
                                    text: $viewModel.phone,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isPhoneValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isPhoneValid ? (viewModel.phone.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบเบอร์โทรไม่ถูกต้อง") : "",
                                    config: config
                                )
                                .onChange(of: viewModel.phone) { _, _ in
                                    viewModel.clearError(for: "phone")
                                }
                                
                                RegisterInputField(
                                    title: "รหัสผ่าน",
                                    placeholder: "อย่างน้อย 8 ตัวอักษร",
                                    text: $viewModel.password,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isPasswordValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isPasswordValid ? (viewModel.password.isEmpty ? "จำเป็นต้องระบุ" : "รูปแบบรหัสผ่านไม่ถูกต้อง") : "",
                                    isSecure: true,
                                    isPasswordToggle: $viewModel.isPasswordVisible,
                                    config: config
                                )
                                .onChange(of: viewModel.password) { _, _ in
                                    viewModel.clearError(for: "password")
                                    if !viewModel.confirmPassword.isEmpty {
                                        viewModel.isConfirmPasswordValid = (viewModel.password == viewModel.confirmPassword)
                                    }
                                }
                                
                                if !ValidationHelper.isPasswordValid(viewModel.password) {
                                    PasswordValidationCheckView(password: viewModel.password, config: config)
                                        .frame(maxWidth: config.isIPad ? 520 : .infinity, alignment: .leading)
                                        .padding(.top, config.isIPad ? -10 : 2)
                                        .padding(.bottom, 5)
                                }
                                
                                RegisterInputField(
                                    title: "ยืนยันรหัสผ่าน",
                                    placeholder: "กรอกรหัสผ่านอีกครั้ง",
                                    text: $viewModel.confirmPassword,
                                    isValid: .constant(!viewModel.isRegisterSubmitted || viewModel.isConfirmPasswordValid),
                                    errorMessage: viewModel.isRegisterSubmitted && !viewModel.isConfirmPasswordValid ? (viewModel.confirmPassword.isEmpty ? "จำเป็นต้องระบุ" : "รหัสผ่านไม่ตรงกัน") : "",
                                    isSecure: true,
                                    isPasswordToggle: $viewModel.isConfirmPasswordVisible,
                                    config: config
                                )
                                .onChange(of: viewModel.confirmPassword) { _, _ in
                                    viewModel.clearError(for: "confirmPassword")
                                }
                                
                                // MARK: - Privacy Accept
                                VStack {
                                    HStack {
                                        Button { viewModel.isPrivacyAccepted.toggle() } label: {
                                            Image(systemName: viewModel.isPrivacyAccepted ? "checkmark.square.fill" : "square")
                                                .foregroundColor(.mainColor)
                                                .font(.system(size: config.isIPad ? 24 : 20))
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
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("จำเป็นต้องยอมรับนโยบายความเป็นส่วนตัว")
                                            .font(.noto(bodyFontSize, weight: .medium))
                                            .foregroundColor(Color.errorColor)
                                            .opacity((!viewModel.isPrivacyAccepted && viewModel.isRegisterSubmitted) ? 1 : 0)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .frame(maxWidth: config.isIPad ? 445 : .infinity, alignment: .leading)
                                .padding(.horizontal, config.paddingStandard)
                                .padding(.top, config.isIPad ? 5 : 10)
                                
                                // MARK: - Register Button
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
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.backgroundColor)
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .blur(radius: (viewModel.showPrivacyPopup || viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                    .disabled(viewModel.showPrivacyPopup || viewModel.showSuccessPopup || viewModel.showErrorPopup)
                }
                
                // MARK: - Popups
                if viewModel.showPrivacyPopup {
                    PrivacyPopupView(showPrivacyPopup: $viewModel.showPrivacyPopup)
                }
                
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: "สร้างบัญชีสำเร็จ") {
                        withAnimation {
                            viewModel.showSuccessPopup = false
                            dismiss()
                        }
                    }
                }
                
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

#Preview {
    RegisterView()
}
