//
//  OTPConfirmViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 2/12/2568 BE.
//

import Foundation
import SwiftUI
import Supabase

@MainActor
class OTPConfirmViewModel: ObservableObject {
    // สถานะสำหรับช่องกรอก OTP
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    @Published var isFieldInvalid: [Bool] = Array(repeating: false, count: 6)

    @Published var isSubmitted: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    @Published var showIncompleteError: Bool = false
    @Published var showIncorrectError: Bool = false

    @Published var navigateToChangePW: Bool = false
    @Published var navigateToProfile: Bool = false

    @Published var resendCooldown: Int = 0
    private var cooldownTimer: Timer?

    @AppStorage("emailChangeSuccess") var emailChangeSuccess = false

    private let lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var fullOTP: String {
        otpFields.joined()
    }

    var errorMessage: String {
        if showIncompleteError {
            return L("กรุณากรอกรหัส OTP ให้ครบถ้วน")
        } else if showIncorrectError {
            return L("รหัส OTP ไม่ถูกต้องหรือหมดอายุ")
        }
        return ""
    }

    var shouldShowError: Bool {
        return isSubmitted && (showIncompleteError || showIncorrectError)
    }

    func handleOTPChange(index: Int, newValue: String) -> Int? {
        if isSubmitted { isSubmitted = false }

        if newValue.isEmpty {
            return index > 0 ? index - 1 : 0
        }

        let filtered = newValue.filter { $0.isNumber }
        if let lastDigit = filtered.last {
            otpFields[index] = String(lastDigit)
            isFieldInvalid[index] = false
            return index < 5 ? index + 1 : nil
        }

        return index
    }

    private func handlePasteReturningIndex(_ value: String) -> Int? {
        let digits = Array(value.filter { $0.isNumber }.prefix(6))
        for i in 0..<6 {
            otpFields[i] = i < digits.count ? String(digits[i]) : ""
        }
        return digits.count < 6 ? digits.count : nil
    }

    func handlePaste(_ value: String, focusedField: inout Int?) {
        let digits = value.filter { $0.isNumber }
        let limited = String(digits.prefix(6))

        for i in 0..<6 {
            if i < limited.count {
                otpFields[i] = String(limited[limited.index(limited.startIndex, offsetBy: i)])
            } else {
                otpFields[i] = ""
            }
        }

        focusedField = limited.count < 6 ? limited.count : nil

        showIncompleteError = false
        showIncorrectError = false
    }

    func resetOTPFields() {
        otpFields = Array(repeating: "", count: 6)
        isFieldInvalid = Array(repeating: false, count: 6)
        showIncorrectError = false
        showIncompleteError = false
        isSubmitted = false
    }

    private var cooldownTask: Task<Void, Never>?

    func startCooldown() {
        resendCooldown = 60
        cooldownTask?.cancel()
        cooldownTask = Task {
            for remaining in stride(from: 59, through: 0, by: -1) {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                self.resendCooldown = remaining
            }
        }
    }

    func resendOTP(source: OTPSource, email: String) async {
        guard resendCooldown == 0 else { return }
        resetOTPFields()
        startCooldown()

        do {
            switch source {
            case .forgotPassword, .confirmEmail:
                try await supabase.auth.resetPasswordForEmail(email)
            case .changeEmail:
                try await supabase.auth.update(user: UserAttributes(email: email))
            }
        } catch {
            print("Resend Failed: \(error.localizedDescription)")
            cooldownTask?.cancel()
            resendCooldown = 0
            showIncorrectError = true
        }
    }

    func verifyOTP(source: OTPSource, email: String) async {
        self.isSubmitted = true
        self.showIncompleteError = false
        self.showIncorrectError = false
        self.isFieldInvalid = Array(repeating: false, count: 6)

        if fullOTP.count < 6 {
            showIncompleteError = true
            for i in 0..<6 { isFieldInvalid[i] = otpFields[i].isEmpty }
            return
        }

        do {
            if source == .forgotPassword || source == .confirmEmail {
                try await supabase.auth.verifyOTP(
                    email: email,
                    token: fullOTP,
                    type: .recovery
                )
            } else if source == .changeEmail {
                try await supabase.auth.verifyOTP(
                    email: email,
                    token: fullOTP,
                    type: .emailChange
                )
            }

            switch source {
            case .forgotPassword:  navigateToChangePW = true
            case .confirmEmail:    navigateToChangePW = true
            case .changeEmail:
                showSuccessPopup = true
                emailChangeSuccess = true
            }

        } catch {
            print("OTP Verification Failed: \(error.localizedDescription)")
            self.showIncorrectError = true
            self.isFieldInvalid = Array(repeating: true, count: 6)

            if source == .changeEmail {
                self.showErrorPopup = true
            }
        }
    }
}
