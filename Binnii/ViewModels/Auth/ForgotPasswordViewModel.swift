import Foundation
import SwiftUI
import Supabase

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    
    @Published var emailForgotPassword: String = ""
    @Published var emailErrorForgot: String? = nil
    @Published var isForgotSubmitted: Bool = false
    @Published var navigateToOTP = false
    @Published var hasNetworkError = false
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    func clearError() {
        emailErrorForgot = nil
    }
    
    func validateFormForgot() -> Bool {
        emailErrorForgot = nil
        
        if emailForgotPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailErrorForgot = L("กรุณากรอกอีเมลที่ลงทะเบียนไว้")
            return false
        } else if !ValidationHelper.isValidEmail(emailForgotPassword) {
            emailErrorForgot = L("รูปแบบอีเมลไม่ถูกต้อง")
            return false
        }
        return true
    }
    
    func forgotPassword() async {
        self.isForgotSubmitted = true
        
        if validateFormForgot() {
            let trimmedEmail = emailForgotPassword.trimmingCharacters(in: .whitespacesAndNewlines)
            await sendResetPasswordRequest(to: trimmedEmail)
        }
    }
    
    private func sendResetPasswordRequest(to email: String) async {
        self.emailErrorForgot = nil
        
        do {
            struct UserEmail: Decodable {
                let email: String
            }
            
            let response = try await supabase
                .from("users")
                .select("email")
                .eq("email", value: email.lowercased())
                .execute()
            
            let users = try JSONDecoder().decode([UserEmail].self, from: response.data)
            
            guard !users.isEmpty else {
                self.emailErrorForgot = L("อีเมลนี้ยังไม่ได้ลงทะเบียน")
                return
            }
            
            try await supabase.auth.resetPasswordForEmail(email)
            self.navigateToOTP = true
            
        } catch {
            print("Error: \(error.localizedDescription)")
            if error.localizedDescription.contains("rate limit") {
                self.emailErrorForgot = L("ส่งคำขอบ่อยเกินไป กรุณารอสักครู่")
            } else {
                self.emailErrorForgot = L("เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง")
            }
            self.hasNetworkError = true
        }
    }
}
