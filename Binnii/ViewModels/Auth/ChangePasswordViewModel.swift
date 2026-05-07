//
//  ChangePasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 2/12/2568 BE.
//


import Foundation
import SwiftUI
import Supabase

enum ChangePasswordSource {
    case forgotPassword
    case profile
}

@MainActor
class ChangePasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var isChangePasswordSubmitted: Bool = false
    
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    @Published var passwordErrorMessage: String = ""
    
    @Published var navigateToLogin: Bool = false
    @Published var navigateToProfile: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    // MARK: - Password Checklist Helpers (เรียกใช้จาก Helper)
    var passwordHasLength: Bool { ValidationHelper.hasMinimumLength(password) }
    var passwordHasUpper: Bool { ValidationHelper.hasUppercase(password) }
    var passwordHasLower: Bool { ValidationHelper.hasLowercase(password) }
    var passwordHasDigit: Bool { ValidationHelper.hasDigit(password) }
    var passwordHasSpecial: Bool { ValidationHelper.hasSpecialCharacter(password) }
    
    var isFormValid: Bool {
        return ValidationHelper.isPasswordValid(password) && (password == confirmPassword) && !password.isEmpty
    }
    
    func clearError(for field: String) {
        if field == "password" {
            isPasswordValid = true
        } else if field == "confirmPassword" {
            isConfirmPasswordValid = true
        }
    }
    
    // MARK: - Action & Confirmation Validation
    func validateFormChangePassword() -> Bool {
        isChangePasswordSubmitted = true
        
        isPasswordValid = !ValidationHelper.isEmpty(password) && ValidationHelper.isPasswordValid(password)
        
        if ValidationHelper.isEmpty(confirmPassword) {
            isConfirmPasswordValid = false
        } else {
            isConfirmPasswordValid = (password == confirmPassword)
        }
        
        return isPasswordValid && isConfirmPasswordValid
    }
    
    func validateOnPasswordChange() {
        clearError(for: "password")
        if !confirmPassword.isEmpty {
            isConfirmPasswordValid = (password == confirmPassword)
        }
    }
    
    func changePassword(source: ChangePasswordSource) async {
        if validateFormChangePassword() {
            do {
                try await supabase.auth.update(
                    user: UserAttributes(
                        password: password,
                        data: ["has_password": .bool(true)]
                    )
                )
                
                switch source {
                case .forgotPassword:
                    try await supabase.auth.signOut()
                    isLoggedIn = false
                case .profile:
                    break
                }
                
                withAnimation {
                    self.showSuccessPopup = true
                }
                
                password = ""
                confirmPassword = ""
                isChangePasswordSubmitted = false
                
            } catch  {
                if error.localizedDescription.contains("New password should be different") {
                    self.isPasswordValid = false
                    self.isConfirmPasswordValid = false
                } else {
                    self.showErrorPopup = true
                }
            }
        }
    }
}
