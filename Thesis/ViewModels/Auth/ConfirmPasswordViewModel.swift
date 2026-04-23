//
//  ConfirmPasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/1/2569 BE.
//


import SwiftUI
import Supabase

@MainActor
class ConfirmPasswordViewModel: ObservableObject {
    @Published var password = ""
    @Published var passwordError: String? = nil
    @Published var isPasswordVisible = false
    @Published var navigateToNextStep = false
    @Published var isSubmitted = false

    func verifyPassword() {
        self.isSubmitted = true
        
        if password.isEmpty {
            passwordError = "กรุณากรอกรหัสผ่าน"
            return
        }
        
        Task {
            await verifyWithSupabase()
        }
    }
    
    private func verifyWithSupabase() async {
        do {
            let user = try await supabase.auth.session.user
            let email = user.email ?? ""
            print("Email: \(email)")
            print("Password: \(password)")
            
            try await supabase.auth.signIn(email: email, password: password)
            
            self.passwordError = nil
            self.navigateToNextStep = true
            
        } catch {
            print("Error full: \(error)")
            self.passwordError = "รหัสผ่านไม่ถูกต้อง"
        }
    }
    
    func clearError() {
        if isSubmitted {
            isSubmitted = false
            passwordError = nil
        }
    }
}
