//
//  ChangeEmailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//

import SwiftUI

struct ChangeEmailView: View {
    @StateObject private var viewModel = ChangeEmailViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                ZStack {
                    Text("ยืนยันแก้ไขอีเมล")
                        .font(.noto(config.titleFontSize, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.topPadding)
                .padding(.bottom, config.bottomTitlePadding)
                
                // MARK: - Input Field
                LoginInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมลที่ต้องการแก้ไข",
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
                    title: "ส่งรหัส OTP",
                    action: {
                        Task {
                            await viewModel.validateEmail()
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
        }
    }
}

#Preview {
    ChangeEmailView()
}
