import Foundation
import SwiftUI
import Supabase

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    
    @Published var emailForgotPassword: String = ""
    @Published var emailErrorForgot: String? = nil
    @Published var isForgotSubmitted: Bool = false
    @Published var navigateToOTP = false
    
    func clearError() {
        emailErrorForgot = nil
    }
    
    func validateFormForgot() -> Bool {
        emailErrorForgot = nil
        
        if emailForgotPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailErrorForgot = "กรุณากรอกอีเมลที่ลงทะเบียนไว้"
            return false
        } else if !ValidationHelper.isValidEmail(emailForgotPassword) {
            emailErrorForgot = "รูปแบบอีเมลไม่ถูกต้อง"
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
            try await supabase.auth.resetPasswordForEmail(email)
            self.navigateToOTP = true
            print("Reset password email sent to: \(email)")
            
        } catch {
            print("Error: \(error.localizedDescription)")
            if error.localizedDescription.contains("rate limit") {
                self.emailErrorForgot = "ส่งคำขอบ่อยเกินไป กรุณารอสักครู่"
            } else {
                self.emailErrorForgot = "เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง"
            }
        }
    }
}
