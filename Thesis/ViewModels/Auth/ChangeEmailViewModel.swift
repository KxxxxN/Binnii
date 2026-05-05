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
    
    @Published var hasNetworkError = false
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    func validateEmail() async {
        self.isSubmitted = true
        
        let trimmed = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            emailError = L("กรุณากรอกอีเมลที่ต้องการแก้ไข")
        } else if ValidationHelper.isValidEmail(trimmed) {
            emailError = nil
            await updateEmailRequest(to: trimmed) 
        } else {
            emailError = L("รูปแบบอีเมลไม่ถูกต้อง")
        }
    }
    
    private func updateEmailRequest(to trimmedEmail: String) async {
        self.emailError = nil
        
        self.refCodeGenerated = String((0..<6).map { _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()! })
        
        do {
            try await supabase.auth.update(user: UserAttributes(email: trimmedEmail))
            
            self.navigateToOTP = true
            print("Request to change email sent to: \(trimmedEmail)")
            
        } catch {
            print("Update Email Error: \(error.localizedDescription)")
            if error.localizedDescription.contains("already been registered") || error.localizedDescription.contains("already exists") {
                self.emailError = L("อีเมลนี้ถูกใช้งานแล้ว")
            } else {
                self.emailError = L("ไม่สามารถใช้อีเมลนี้ได้ หรือส่งคำขอบ่อยเกินไป")
                self.hasNetworkError = true
            }
        }
    }
    
    func clearError() {
        if isSubmitted {
            isSubmitted = false
            emailError = nil
        }
    }
}
