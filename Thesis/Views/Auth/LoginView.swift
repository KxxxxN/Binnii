//
//  LoginView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        
        NavigationStack(path: $path) {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                GeometryReader { geo in
                    let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
                    let bodyFontSize: CGFloat = config.isIPad ? 20 : 15
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(alignment: .center) {
                            
                            HStack {
                                BackButton()
                                Spacer()
                            }
                            .padding(.top, config.headerTopPadding)
                            
                            Spacer()
                            
                            // MARK: - Logo
                            Image("logo_green")
                                .resizable()
                                .scaledToFit()
                                .frame(width: config.isIPad ? 300 : 220)
                                .padding(.bottom, config.isIPad ? 90 : 26)
                            
                            // MARK: - Input Fields
                            VStack(spacing: 0) {
                                LoginInputField(
                                    title: L("อีเมล"),
                                    placeholder: L("กรอกอีเมล"),
                                    text: $viewModel.email,
                                    isValid: .constant(!viewModel.isLoginSubmitted || viewModel.emailError == nil),
                                    errorMessage: viewModel.isLoginSubmitted ? (viewModel.emailError ?? "") : "",
//                                    contentType: .emailAddress,
                                    config: config
                                )
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .onChange(of: viewModel.email) { _, _ in
                                    viewModel.clearError(for: "email")
                                }
                                
                                LoginPasswordField(
                                    title: L("รหัสผ่าน"),
                                    placeholder: L("กรอกรหัสผ่าน"),
                                    text: $viewModel.password,
                                    isValid: .constant(!viewModel.isLoginSubmitted || viewModel.passwordError == nil),
                                    errorMessage: viewModel.isLoginSubmitted ? (viewModel.passwordError ?? "") : "",
                                    isPasswordVisible: $viewModel.isPasswordVisible,
                                    config: config
                                )
                                .onChange(of: viewModel.password) { _, _ in
                                    viewModel.clearError(for: "password")
                                }
                                .padding(.bottom, -15)
                                
                                HStack {
                                    Spacer()
                                    
                                    NavigationLink(destination: EmailForgotPassword()){
                                        Text(L("ลืมรหัสผ่าน?"))
                                            .font(.noto(bodyFontSize, weight: .medium))
                                            .foregroundColor(.mainColor)
                                    }
                                }
                                .padding(.horizontal,config.isIPad ?  200 : 46)
                            }
                            
                            // MARK: - Login Button
                            PrimaryButton(
                                title: L("เข้าสู่ระบบ"),
                                action: {
                                    Task {
                                        await viewModel.login()
                                    }
                                },
                                width: config.isIPad ? 220 : 155,
                                height: config.isIPad ? 60 : 49
                            )
                            .padding(.top, 21)
                            
                            // MARK: - Register Link
                            HStack(spacing: 8){
                                Text(L("ยังไม่มีบัญชี?"))
                                    .font(.noto(bodyFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                
                                NavigationLink(destination: RegisterView()){
                                    Text(L("ลงทะเบียน"))
                                        .font(.noto(bodyFontSize, weight: .medium))
                                        .foregroundColor(.mainColor)
                                        .underline(color: .mainColor)
                                }
                            }
                            .padding(.top,10)
                            
                            // MARK: - Divider
                            HStack(spacing: 6){
                                Divider()
                                    .frame(width: config.isIPad ? 160 : 108, height: 2)
                                    .background(Color.textFieldColor)
                                
                                Text(L("หรือลงชื่อเข้าใช้ด้วย"))
                                    .font(.noto(bodyFontSize, weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Divider()
                                    .frame(width: config.isIPad ? 160 : 108, height: 2)
                                    .background(Color.textFieldColor)
                            }
                            .padding(.top, config.isIPad ? 80 : 64.5)
                            
                            // MARK: - Social Login
                            VStack(spacing: 16){
                                SocialLoginButton(
                                    iconName: "GoogleIcon",
                                    title: L("ดำเนินการต่อด้วย Google"),
                                    config: config
                                ) {
                                    Task { await authViewModel.signInWithOAuth(provider: .google) }
                                }
                                .padding(.top, 21)
                                
                                SocialLoginButton(
                                    iconName: "FacebookIcon",
                                    title: L("ดำเนินการต่อด้วย Facebook"),
                                    config: config
                                ) {
                                    Task { await authViewModel.signInWithOAuth(provider: .facebook) }
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(minHeight: geo.size.height)
                        .background(Color.backgroundColor)
                    }
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .background(Color.backgroundColor)
                    .ignoresSafeArea(.keyboard)
                    .frame(maxWidth: .infinity, minHeight: geo.size.height)
                }
            }
            .onChange(of: isLoggedIn) {
                if isLoggedIn {
                    dismiss()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .popToLogin)) { _ in
                path = NavigationPath()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("")
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
