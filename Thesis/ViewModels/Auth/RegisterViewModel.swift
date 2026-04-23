//
//  RegisterViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 28/11/2568 BE.
//


import Foundation
import Combine
import SwiftUI
import Supabase

@MainActor
class RegisterViewModel: ObservableObject {
    
    // MARK: - Input Fields
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // MARK: - UI States
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var isPrivacyAccepted: Bool = false
    @Published var showPrivacyPopup: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    @Published var isRegisterSubmitted: Bool = false
    
    // MARK: - Validation States (สำหรับแสดงสีแดง/ข้อความเตือนใน UI)
    @Published var isFirstNameValid: Bool = true
    @Published var isLastNameValid: Bool = true
    @Published var isEmailValid: Bool = true
    @Published var isPhoneValid: Bool = true
    @Published var isPasswordValid: Bool = true
    @Published var isConfirmPasswordValid: Bool = true
    @Published var authErrorMessage: String? = nil
    
    // MARK: - Password Checklist Helpers
    // เรียกใช้ ValidationHelper เพื่อเช็คเงื่อนไขแต่ละข้อสำหรับแสดงใน UI
    var passwordHasLength: Bool { ValidationHelper.hasMinimumLength(password) }
    var passwordHasUpper: Bool { ValidationHelper.hasUppercase(password) }
    var passwordHasLower: Bool { ValidationHelper.hasLowercase(password) }
    var passwordHasDigit: Bool { ValidationHelper.hasDigit(password) }
    var passwordHasSpecial: Bool { ValidationHelper.hasSpecialCharacter(password) }
    
    func clearError(for field: String) {
        authErrorMessage = nil // ล้าง error กลางเมื่อมีการพิมพ์ใหม่
        switch field {
        case "firstName": isFirstNameValid = true
        case "lastName": isLastNameValid = true
        case "email": isEmailValid = true
        case "phone": isPhoneValid = true
        case "password": isPasswordValid = true
        case "confirmPassword": isConfirmPasswordValid = true
        default: break
        }
    }
    
    
    @discardableResult
    func validateFormRegister() -> Bool {
        isFirstNameValid = !firstName.isEmpty && ValidationHelper.isNameValid(name: firstName)
        isLastNameValid = !lastName.isEmpty && ValidationHelper.isNameValid(name: lastName)
        isEmailValid = !email.isEmpty && ValidationHelper.isValidEmail(email)
        isPhoneValid = !phone.isEmpty && ValidationHelper.isValidPhone(phone)
        isPasswordValid = !password.isEmpty && ValidationHelper.isPasswordValid(password)
        isConfirmPasswordValid = !confirmPassword.isEmpty && (password == confirmPassword)
        
        let isDataValid = isFirstNameValid && isLastNameValid && isEmailValid && isPhoneValid && isPasswordValid && isConfirmPasswordValid
        
        return isDataValid && isPrivacyAccepted
    }
    
    //    func register() {
    //        // 1. สั่งเปิดสถานะ Submit เพื่อให้ขอบแดงทำงาน
    //        self.isRegisterSubmitted = true
    //
    //        // 2. ตรวจสอบความถูกต้องของข้อมูลทั้งหมด
    //        if validateFormRegister() {
    //            // ✅ กรณีข้อมูลถูกต้องทั้งหมด
    //            self.showSuccessPopup = true
    //        }
    //    }
    //}
    func register() async {
        self.isRegisterSubmitted = true
        
        if validateFormRegister() {
//            self.isLoading = true
            self.authErrorMessage = nil
            
            do {
                // 5. เรียกใช้ Supabase Auth SignUp
                // ส่งชื่อ นามสกุล และเบอร์โทรเข้าไปใน user_metadata
                let _ = try await supabase.auth.signUp(
                    email: email,
                    password: password,
                    data: [
                        "first_name": .string(firstName),
                        "last_name": .string(lastName),
                        "phone": .string(phone)
                    ]
                )
                self.showSuccessPopup = true
                
            } catch {
                // ❌ กรณีผิดพลาด (เช่น อีเมลซ้ำ หรือปัญหา Network)
                print("Register Failed: \(error.localizedDescription)")
//                self.authErrorMessage = error.localizedDescription
//                self.showErrorPopup = true
            }
        }
    }
}
