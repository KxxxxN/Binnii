//
//  LoginViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import Foundation
import SwiftUI
import Supabase

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    
    @Published var isLoginSubmitted: Bool = false
    @Published var authErrorMessage: String? = nil
    
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    func clearError(for field: String) {
        if field == "email" {
            emailError = nil
        } else if field == "password" {
            passwordError = nil
        }
        authErrorMessage = nil
    }
    
    
    @discardableResult
    func validateFormLogin() -> Bool {
        emailError = nil
        passwordError = nil
        var allFieldsValid = true
        
        // 2. ตรวจสอบอีเมล
        if ValidationHelper.isEmpty(email) {
            emailError = "กรุณากรอกอีเมล"
            allFieldsValid = false
        } else if !ValidationHelper.isValidEmail(email) {
            emailError = "รูปแบบอีเมลไม่ถูกต้อง"
            allFieldsValid = false
        }
        
        // 3. ตรวจสอบรหัสผ่าน
        if ValidationHelper.isEmpty(password) {
            passwordError = "กรุณากรอกรหัสผ่าน"
            allFieldsValid = false
        }
        
        return allFieldsValid
    }
    
    func login() async {
        self.isLoginSubmitted = true
        self.authErrorMessage = nil
        
        if validateFormLogin() {
            do {
                // เชื่อมต่อ Supabase
                _ = try await supabase.auth.signIn(email: email, password: password)
                self.isLoggedIn = true
                print("Sign in Success!")
            } catch {
                self.emailError = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
                self.passwordError = "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
                print("Login Failed: \(error.localizedDescription)")
            }
        }
    }
}
