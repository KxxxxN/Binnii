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
    
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0){
                ZStack {
                    Text("ลืมรหัสผ่าน")
                        .font(.noto(config.titleFontSize, weight: .bold))
                    HStack {
                        BackButton()
                        
                        Spacer()
                    }
                }
                .padding(.top, config.headerTopPadding)
                .padding(.bottom, config.isIPad ? 80 : 57)
                
                LoginInputField(
                    title: "ที่อยู่อีเมล",
                    placeholder: "กรอกอีเมล",
                    text: $viewModel.emailForgotPassword,
                    isValid: .constant(!viewModel.isForgotSubmitted || viewModel.emailErrorForgot == nil),
                    errorMessage: viewModel.isForgotSubmitted ? (viewModel.emailErrorForgot ?? "") : "", config: config
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .onChange(of: viewModel.emailForgotPassword) {
                    viewModel.clearError()
                }
                
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        Task {
                            await viewModel.forgotPassword()
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
                OTPConfirmView(source: .forgotPassword, email: viewModel.emailForgotPassword)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EmailForgotPassword()
}
