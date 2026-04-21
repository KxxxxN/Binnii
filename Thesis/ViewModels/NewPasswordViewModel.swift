//
//  NewPasswordViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 8/1/2569 BE.
//


import Foundation
import SwiftUI
import Supabase

@MainActor
class NewPasswordViewModel: ObservableObject {
    // MARK: - Input Fields
    @Published var oldPassword: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // MARK: - UI States
    @Published var isOldPasswordVisible: Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    
    // MARK: - Validation States
    @Published var isOldPasswordValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    
    @Published var showSuccessAlert: Bool = false
    @Published var showErrorPopup: Bool = false
    @Published var isSubmitted: Bool = false
    
    @Published var showOldError = false
    @Published var showNewError = false
    @Published var showConfirmError = false
    @Published var navigateToProfile: Bool = false
    
    // MARK: - Navigation
//    @Published var navigateToLogin: Bool = false
//    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    // MARK: - Password Checklist Helpers (ดึงจาก ValidationHelper)
    // ใช้สำหรับแสดง Checklist 5 ข้อในหน้า View
    var passwordHasLength: Bool { ValidationHelper.hasMinimumLength(password) }
    var passwordHasUpper: Bool { ValidationHelper.hasUppercase(password) }
    var passwordHasLower: Bool { ValidationHelper.hasLowercase(password) }
    var passwordHasDigit: Bool { ValidationHelper.hasDigit(password) }
    var passwordHasSpecial: Bool { ValidationHelper.hasSpecialCharacter(password) }
    
    // ตรวจสอบว่ารหัสผ่านใหม่ถูกต้องตามกฎ และรหัสผ่านใหม่ต้องตรงกับยืนยัน
    var isNewPasswordFormValid: Bool {
        return ValidationHelper.isPasswordValid(password) && (password == confirmPassword) && !password.isEmpty
    }
    
    func validateOnPasswordChange() {
        clearErrorOnTyping(for: "new")
        if !password.isEmpty {
            isPasswordValid = ValidationHelper.isPasswordValid(password)
        }
        if !confirmPassword.isEmpty {
            isConfirmPasswordValid = (password == confirmPassword)
        }
    }
    
    func saveNewPassword() async {
        self.isSubmitted = true
        
        isOldPasswordValid = !oldPassword.isEmpty
        isPasswordValid = ValidationHelper.isPasswordValid(password)
        isConfirmPasswordValid = !confirmPassword.isEmpty && (password == confirmPassword)
        
        // เช็คว่ารหัสผ่านใหม่ซ้ำกับเก่าไหม
        if password == oldPassword {
            isPasswordValid = false
            return
        }
        
        guard isOldPasswordValid && isPasswordValid && isConfirmPasswordValid else {
            return
        }
        
        await updatePassword()
    }

    private func updatePassword() async {
        do {
            let session = try await supabase.auth.session
            
            // ขั้นที่ 1: ตรวจสอบรหัสผ่านเก่า
            do {
                try await supabase.auth.signIn(
                    email: session.user.email ?? "",
                    password: oldPassword
                )
                print("✅ Re-authenticate สำเร็จ")
            } catch {
                // ✅ รหัสผ่านเก่าผิด → แสดงแค่ขอบแดง
                print("❌ Re-authenticate Failed: \(error.localizedDescription)")
                isOldPasswordValid = false
                return
            }
            
            // ขั้นที่ 2: บันทึกรหัสผ่านใหม่ลง server
            do {
                try await supabase.auth.update(user: UserAttributes(password: password))
                print("✅ เปลี่ยนรหัสผ่านสำเร็จ")
                showSuccessAlert = true
            } catch {
                // ✅ บันทึกลง server ไม่ได้ → แสดง popup
                print("❌ Update Password Error: \(error.localizedDescription)")
                showErrorPopup = true
            }
            
        } catch {
            print("❌ Session Error: \(error.localizedDescription)")
            showErrorPopup = true
        }
    }
        
    func validateAndSave() -> Bool {
        isOldPasswordValid = !oldPassword.isEmpty
        isPasswordValid = !ValidationHelper.isEmpty(password) && ValidationHelper.isPasswordValid(password)
        
        if ValidationHelper.isEmpty(confirmPassword) {
            isConfirmPasswordValid = false
        } else {
            isConfirmPasswordValid = (password == confirmPassword)
        }
        
        return isOldPasswordValid && isPasswordValid && isConfirmPasswordValid
    }
    
    func clearErrorOnTyping(for field: String) {
        switch field {
        case "old":
            isOldPasswordValid = true
            showOldError = false
        case "new":
            isPasswordValid = true
            showNewError = false
            if !confirmPassword.isEmpty {
                isConfirmPasswordValid = (password == confirmPassword)
            }
        case "confirm":
            isConfirmPasswordValid = true
            showConfirmError = false
        default:
            break
        }
    }
    
    func clearErrorOnTyping() {
        if isSubmitted { isSubmitted = false }
        isOldPasswordValid = true
        isPasswordValid = true
        isConfirmPasswordValid = true
        showErrorPopup = false
    }

    // MARK: - Reset Fields
    private func resetFields() {
        oldPassword = ""
        password = ""
        confirmPassword = ""
        isOldPasswordValid = true
        isPasswordValid = true
        isConfirmPasswordValid = true
    }
}
