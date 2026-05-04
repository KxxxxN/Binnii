//
//  confirmPasswordView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct ConfirmPasswordView: View {
    @StateObject private var viewModel = ConfirmPasswordViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    Text(L("ยืนยันรหัสผ่าน"))
                        .font(.noto(config.titleFontSize, weight: .bold))
                        .foregroundColor(.black)

                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.headerTopPadding)
                .padding(.bottom, config.isIPad ? 100 : 57)
                
                // MARK: - Input Field
                LoginPasswordField(
                    title: L("รหัสผ่าน"),
                    placeholder: L("กรอกรหัสผ่าน"),
                    text: $viewModel.password,
                    isValid: .constant(!viewModel.isSubmitted || viewModel.passwordError == nil),
                    errorMessage: viewModel.isSubmitted ? (viewModel.passwordError ?? "") : "",
                    isPasswordVisible: $viewModel.isPasswordVisible,
                    config: config
                )
                .onChange(of: viewModel.password) { _, _ in
                    viewModel.clearError()
                }
                
                // MARK: - Confirm Button
                PrimaryButton(
                    title: L("ยืนยัน"),
                    action: {
                        viewModel.verifyPassword()
                    },
                    width: 155,
                    height: 49
                )
                .padding(.top, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $viewModel.navigateToNextStep) {
                ChangeEmailView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ConfirmPasswordView()
}
