//
//  ValidationHelper.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 6/1/2569 BE.
//


import Foundation

struct ValidationHelper {
    
    static func isEmpty(_ value: String) -> Bool {
        return value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Name & Lastname Validation
    static func isNameValid(name: String) -> Bool {
        if name.isEmpty { return true }
        
        let thaiRegex = "^[\\p{Thai}\\s\\-]+$"
        let isThaiOnly = NSPredicate(format: "SELF MATCHES %@", thaiRegex).evaluate(with: name)

        let englishRegex = "^[a-zA-Z\\s\\-]+$"
        let isEnglishOnly = NSPredicate(format: "SELF MATCHES %@", englishRegex).evaluate(with: name)
        
        return isThaiOnly || isEnglishOnly
    }
    
    // MARK: - Email Validation
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: - Phone Validation
    static func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^(0[0-9]{2}-?)([0-9]{3}-?)([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    // MARK: - Password Validation
    static func isPasswordValid(_ password: String) -> Bool {
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%&*_-]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    static func hasMinimumLength(_ password: String) -> Bool {
        return password.count >= 8
    }

    static func hasUppercase(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil
    }

    static func hasLowercase(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil
    }

    static func hasDigit(_ password: String) -> Bool {
        return password.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }

    static func hasSpecialCharacter(_ password: String) -> Bool {
        let specialChars = "!@#$%&*_-"
        return password.contains { specialChars.contains($0) }
    }
}
