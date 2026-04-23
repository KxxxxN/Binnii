//
//  ChangeEmailViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//


import Foundation
import SwiftUI
import Supabase

@MainActor
class ChangeEmailViewModel: ObservableObject {
    @Published var newEmail = ""
    @Published var emailError: String? = nil
    @Published var navigateToOTP = false
    
    @Published var isSubmitted = false
    @Published var refCodeGenerated: String = ""
    
    @Published var navigateToProfile: Bool = false
    
    func validateEmail() async {
        self.isSubmitted = true
        
        let trimmed = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            emailError = "กรุณากรอกอีเมลที่ต้องการแก้ไข"
        } else if ValidationHelper.isValidEmail(trimmed) {
            emailError = nil
            await updateEmailRequest(to: trimmed) // เพิ่มบรรทัดนี้
        } else {
            emailError = "รูปแบบอีเมลไม่ถูกต้อง"
        }
    }
    
    private func updateEmailRequest(to trimmedEmail: String) async {
//        self.isLoading = true
        self.emailError = nil
        
        // สุ่ม Ref Code สำหรับโชว์ในหน้า OTP
        self.refCodeGenerated = String((0..<6).map { _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()! })
        
        do {
            // ส่งคำขอเปลี่ยนอีเมลไปยัง Supabase
            // หมายเหตุ: โดยปกติ Supabase จะส่ง OTP ไปที่อีเมลใหม่
            try await supabase.auth.update(user: UserAttributes(email: trimmedEmail))
            
            self.navigateToOTP = true
            print("Request to change email sent to: \(trimmedEmail)")
            
        } catch {
            print("Update Email Error: \(error.localizedDescription)")
            // ตรวจสอบกรณีอีเมลซ้ำ หรือ Rate Limit
            if error.localizedDescription.contains("already been registered") || error.localizedDescription.contains("already exists") {
                self.emailError = "อีเมลนี้ถูกใช้งานแล้ว"
            } else {
                self.emailError = "ไม่สามารถใช้อีเมลนี้ได้ หรือส่งคำขอบ่อยเกินไป"
            }
        }
        
//        self.isLoading = false
    }
    
    func clearError() {
        if isSubmitted {
            isSubmitted = false
            emailError = nil
        }
    }
}
