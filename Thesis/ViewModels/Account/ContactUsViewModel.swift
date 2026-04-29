//
//  ContactUsViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 29/4/2569 BE.
//


import Foundation
import Combine

@MainActor
class ContactUsViewModel: ObservableObject {
    
    // MARK: - Form Fields
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var subject: String = ""
    @Published var message: String = ""
    
    // MARK: - UI State
    @Published var didAttemptSubmit: Bool = false
    @Published var isSending: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    
    // MARK: - Error Flags
    var showNameError: Bool {
        didAttemptSubmit && ValidationHelper.isEmpty(name)
    }
    
    var showEmailError: Bool {
        didAttemptSubmit && (ValidationHelper.isEmpty(email) || !ValidationHelper.isValidEmail(email))
    }
    
    var isEmailInvalid: Bool {
        !ValidationHelper.isEmpty(email) && !ValidationHelper.isValidEmail(email)
    }
    
    var showSubjectError: Bool {
        didAttemptSubmit && ValidationHelper.isEmpty(subject)
    }
    
    var showMessageError: Bool {
        didAttemptSubmit && ValidationHelper.isEmpty(message)
    }
    
    // MARK: - Form Validation
    var isFormValid: Bool {
        !ValidationHelper.isEmpty(name) &&
        !ValidationHelper.isEmpty(email) &&
        ValidationHelper.isValidEmail(email) &&
        !ValidationHelper.isEmpty(subject) &&
        !ValidationHelper.isEmpty(message)
    }
    
    // MARK: - Actions
    func sendMessage() {
        didAttemptSubmit = true
        guard isFormValid else { return }
        
        isSending = true
        
        Task {
            do {
                try await ContactUsService().sendMessage(
                    name: name,
                    email: email,
                    subject: subject,
                    message: message
                )
                isSending = false
                showSuccessPopup = true
            } catch {
                isSending = false
                showErrorPopup = true
                print("❌ ContactUs Error:", error)
            }
        }
    }
    
    func resetForm() {
        name = ""
        email = ""
        subject = ""
        message = ""
        didAttemptSubmit = false
    }
    
    func dismissSuccess() {
        showSuccessPopup = false
        resetForm()
    }
    
    func dismissError() {
        showErrorPopup = false
    }
}
