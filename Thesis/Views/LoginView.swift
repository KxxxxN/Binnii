//
//  SwiftUIView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
//        ScrollView{
            NavigationStack(path: $path) {
                GeometryReader { geo in
                    ScrollView{
                        VStack(alignment: .center) { //เปิด Vstack1
                            
                            Spacer()
                            
                            Image("logo_green")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 88)
                                .padding(.bottom, 50)
                            
                            VStack(spacing: 0) {
                                LoginInputField(
                                    title: "อีเมล",
                                    placeholder: "กรอกอีเมล",
                                    text: $viewModel.email,
                                    isValid: .constant(!viewModel.isLoginSubmitted || viewModel.emailError == nil),
                                    errorMessage: viewModel.isLoginSubmitted ? (viewModel.emailError ?? "") : ""
                                )
                                .onChange(of: viewModel.email) { _, _ in
                                    viewModel.clearError(for: "email")
                                }
                                
                                // 2. ช่องป้อนรหัสผ่าน
                                LoginInputField(
                                    title: "รหัสผ่าน",
                                    placeholder: "กรอกรหัสผ่าน",
                                    text: $viewModel.password,
                                    isValid: .constant(!viewModel.isLoginSubmitted || viewModel.passwordError == nil),
                                    errorMessage: viewModel.isLoginSubmitted ? (viewModel.passwordError ?? "") : "",
                                    isSecure: true,
                                    isPasswordToggle: $viewModel.isPasswordVisible
                                )
                                .onChange(of: viewModel.password) { _, _ in
                                    viewModel.clearError(for: "password")
                                }
                                .padding(.bottom, -15)
                                
                                
                                // 3. ปุ่มลืมรหัสผ่าน (NavigationLink)
                                HStack {
                                    Spacer()
                                    
                                    NavigationLink(destination: EmailForgotPassword()){
                                        Text("ลืมรหัสผ่าน?")
                                            .font(.noto(15, weight: .medium))
                                            .foregroundColor(.mainColor)
                                    }
                                }
                                .frame(width: 345)
                            }
                            
                            PrimaryButton(
                                title: "เข้าสู่ระบบ",
                                action: {
                                    Task {
                                        await viewModel.login()
                                    }
                                },
                                width: 155,
                                height: 49
                            )
                            .padding(.top, 21)
                            
                            HStack(spacing: 8){
                                Text("ยังไม่มีบัญชี?")
                                    .font(.noto(15,weight: .medium))
                                    .foregroundColor(.black)
                                
                                NavigationLink(destination: RegisterView()){
                                    Text("ลงทะเบียน")
                                        .font(.noto(15,weight: .bold))
                                        .foregroundColor(.mainColor)
                                        .underline(color: .mainColor)
                                }
                            }
                            .padding(.top,10)
                            
                            HStack(spacing: 6){
                                Divider()
                                    .frame(width: 108,height: 2)
                                    .background(Color.textFieldColor)
                                
                                Text("หรือลงชื่อเข้าใช้ด้วย")
                                    .font(.noto(15,weight: .medium))
                                    .foregroundColor(Color.black)
                                
                                Divider()
                                    .frame(width: 108,height: 2)
                                    .background(Color.textFieldColor)
                            }
                            .padding(.top, 64.5)
                            
                            VStack(spacing: 16){
                                SocialLoginButton(iconName: "GoogleIcon", title: "ดำเนินการต่อด้วย Google") {
                                    print("Google Login Action")
                                    Task {
                                        await authViewModel.signInWithGoogle()
                                    }
                                }
                                .padding(.top, 21)
                                
                                SocialLoginButton(iconName: "XIcon", title: "ดำเนินการต่อด้วย X (Twitter)") {
                                    print("X Login Action")
                                    Task {
                                        await authViewModel.signInWithX()
                                    }
                                }
                            }
                            Spacer()
                            
                        } //ปิด Vstack1
                        //                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: geo.size.height)
                        .background(Color.backgroundColor)
                    }
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .background(Color.backgroundColor)
                    .ignoresSafeArea(.keyboard)
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
}
