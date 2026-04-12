//
//  OTPConfirmView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/11/2568 BE.
//

import SwiftUI

enum OTPSource {
    case forgotPassword // ไป ChangePasswordView
    case changeEmail    // แสดง Popup สำเร็จ
    case confirmEmail   // ไป NewPasswordView
}

struct OTPConfirmView: View {
    let source: OTPSource
    let email: String
//    let refCode: String
    
    @StateObject private var viewModel = OTPConfirmViewModel()
    @FocusState private var focusedField: Int?
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        // MARK: - Header
                        ZStack {
                            Text("ยืนยันรหัส OTP")
                                .font(.noto(config.titleFontSize, weight: .bold)) 
                            
                            HStack {
                                BackButton()
                                Spacer()
                            }
                        }
                        .padding(.top, config.topPadding)
                        .padding(.bottom, config.bottomTitlePadding)
                        .padding(.bottom, config.isIPad ? 80 : 65)
                        
                        Text("ใส่รหัสที่ส่งไปยังอีเมลของคุณ")
                            .font(.noto(config.isIPad ? 24 : 20, weight: .semibold)) // ปรับขนาดฟอนต์บน iPad
                            .padding(.bottom, config.isIPad ? 24 : 18)
                        
                        // MARK: - OTP Input
                        OTPInputView(viewModel: viewModel, focusedField: $focusedField, config: config)
                            .padding(.bottom, 15)
                        
                        // MARK: - Error Message
                        Text(viewModel.errorMessage)
                            .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                            .foregroundColor(Color.errorColor)
                            .frame(height: config.isIPad ? 20 : 15)
                            .padding(.bottom, 0)
                            .opacity(viewModel.shouldShowError ? 1 : 0)
                        
                        // MARK: - Reference Code (Commented)
                        // HStack(spacing: 5){
                        //     Text("รหัสอ้างอิง :")
                        //         .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                        //         .foregroundColor(Color.placeholderColor)
                        //
                        //     let refCode = "A9F4K2"
                        //     Text(refCode)
                        //         .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                        //         .foregroundColor(Color.placeholderColor)
                        // }
                        .padding(.bottom, config.isIPad ? 25 : 18)
                        
                        // MARK: - Action Button
                        PrimaryButton(
                            title: "ยืนยัน",
                            action: {
                                focusedField = nil
                                Task {
                                    await viewModel.verifyOTP(source: source, email: email)
                                }
                            },
                            width: config.isIPad ? 220 : 155, // ปรับขนาดปุ่มบน iPad
                            height: config.isIPad ? 60 : 49
                        )
                        
                        // MARK: - Resend Code
                        HStack(spacing: 8) {
                            Text("ยังไม่ได้รับรหัส?")
                                .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                                .foregroundColor(.black)
                            
                            if viewModel.resendCooldown > 0 {
                                Text("ส่งรหัสใหม่ (\(viewModel.resendCooldown))")
                                    .font(.noto(config.isIPad ? 18 : 15, weight: .bold))
                                    .foregroundColor(.placeholderColor)  // สีจางลงตอน cooldown
                            } else {
                                Button(action: {
                                    Task {
                                        await viewModel.resendOTP(source: source, email: email)
                                    }
                                }) {
                                    Text("ส่งรหัสใหม่")
                                        .font(.noto(config.isIPad ? 18 : 15, weight: .bold))
                                        .foregroundColor(.mainColor)
                                        .underline(color: .mainColor)
                                }
                            }
                        }
                        .padding(.top, config.isIPad ? 20 : 15)
                        
                        Spacer()
                    }
                    .frame(minHeight: geo.size.height) 
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                .onAppear {
                    focusedField = 0
                    viewModel.startCooldown()
                }
                
                // MARK: - Navigation
                .navigationDestination(isPresented: $viewModel.navigateToChangePW) {
                    ChangePasswordView()
                }
                .navigationDestination(isPresented: $viewModel.navigateToNewPW) {
                    NewPasswordView()
                }
                .navigationDestination(isPresented: $viewModel.navigateToProfile) {
                    ProfileView()
                }
            }
            .navigationBarBackButtonHidden(true)
            
            // MARK: - Popups (วางไว้ที่ ZStack นอกสุด)
            if viewModel.showSuccessPopup {
                SuccessPopupView(message: "แก้ไขอีเมลสำเร็จ") {
                    viewModel.showSuccessPopup = false
//                    viewModel.emailChangeSuccess = true
                    viewModel.navigateToProfile = true
                }
            }
            
            if viewModel.showErrorPopup && source == .changeEmail {
                ErrorPopupView(title: "แก้ไขอีเมลไม่สำเร็จ"){
                    withAnimation {
                        viewModel.showErrorPopup = false
                        viewModel.resetOTPFields() // ล้างข้อมูลเพื่อให้พิมพ์ใหม่ได้ง่าย
                        focusedField = 0
                    }
                }
            }
        }
    }
}

#Preview {
    OTPConfirmView(source: .changeEmail, email: "1123kansinee@gmail.com")
}
