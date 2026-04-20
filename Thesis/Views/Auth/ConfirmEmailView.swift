//
//  ConfirmEmailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 12/12/2568 BE.
//

import SwiftUI

@MainActor
struct ConfirmEmailView: View {
    let currentEmail: String
    @StateObject private var viewModel = ConfirmEmailViewModel()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

//    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    Text("ยืนยันแก้ไขรหัสผ่าน")
                        .font(.noto(config.titleFontSize, weight: .bold))
                        .foregroundColor(.black)
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.horizontal, config.paddingStandard)
                .padding(.top, config.topPadding)
                .padding(.bottom, config.bottomTitlePadding)
                
                // MARK: - Email Input Field
                ReadOnlyEmailField(
                    title: "ที่อยู่อีเมล",
                    email: viewModel.email,
                    config: config 
                )
                
                Text("เพื่อความปลอดภัย ไม่สามารถเปลี่ยนอีเมลได้ในหน้านี้")
                    .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                    .foregroundColor(.placeholderColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                    .padding(.horizontal, config.paddingStandard)
                
                // MARK: - Action Button
                PrimaryButton(
                    title: "ส่งรหัส OTP",
                    action: {
                        Task {
                            await viewModel.verifyEmailBeforeChange()
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
            .onAppear {
                viewModel.email = currentEmail
            }
            .navigationDestination(isPresented: $viewModel.navigateToOTP) {
                OTPConfirmView(
                    source: .confirmEmail,
                    email: viewModel.email
                )
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ConfirmEmailView(currentEmail: "kansinee.klinkhachon@g.swu.ac.th")
}
