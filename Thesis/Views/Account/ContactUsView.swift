//
//  ContactUsView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct ContactUsView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    @StateObject private var vm = ContactUsViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case name, email, subject, message
    }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // MARK: - Header
                    ZStack {
                        Text(L("ติดต่อเรา"))
                            .font(.noto(config.titleFontSize, weight: .bold))
                        
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.top, config.headerTopPadding)
                    .padding(.bottom, config.bottomTitlePadding)
                    
                    // MARK: - Form
                    VStack(spacing: 5) {
                        
                        // ชื่อ
                        ContactTextField(
                            title: L("ชื่อ"),
                            placeholder: L("กรอกชื่อของคุณ"),
                            text: $vm.name,
                            config: config,
                            showError: vm.showNameError
                        )
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }

                        // อีเมล
                        ContactTextField(
                            title: L("อีเมล"),
                            placeholder: L("กรอกอีเมลสำหรับติดต่อกลับ"),
                            text: $vm.email,
                            keyboardType: .emailAddress,
                            config: config,
                            showError: vm.showEmailError,
                            isEmailField: true
                        )
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .subject }

                        // หัวข้อ
                        ContactTextField(
                            title: L("หัวข้อ"),
                            placeholder: L("ระบุหัวข้อที่ต้องการติดต่อ"),
                            text: $vm.subject,
                            config: config,
                            showError: vm.showSubjectError
                        )
                        .focused($focusedField, equals: .subject)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .message }

                        // ข้อความ
                        ContactTextEditor(
                            title: L("ข้อความ"),
                            placeholder: L("กรอกรายละเอียดข้อความ"),
                            text: $vm.message,
                            config: config,
                            showError: vm.showMessageError
                        )
                        .focused($focusedField, equals: .message)

                        // ปุ่มส่ง
                        PrimaryButton(
                            title: L("ส่งข้อความ"),
                            action: {
                                focusedField = nil
                                vm.sendMessage()
                            },
                            width: config.isIPad ? 200 : 155,
                            height: config.isIPad ? 60 : 49
                        )
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .onTapGesture { focusedField = nil }
            .overlay {
                if vm.showSuccessPopup {
                    SuccessPopupView(message: L("ส่งข้อความสำเร็จ")) {
                        withAnimation { vm.dismissSuccess() }
                    }
                    .transition(.opacity)
                }
                if vm.showErrorPopup {
                    ErrorPopupView(title: L("ส่งข้อความไม่สำเร็จ")) {
                        withAnimation { vm.dismissError() }
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: vm.showSuccessPopup)
            .animation(.easeInOut, value: vm.showErrorPopup)
        }
    }
}

#Preview {
    ContactUsView()
}
