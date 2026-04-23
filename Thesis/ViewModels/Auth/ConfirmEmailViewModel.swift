//
//  ConfirmEmailViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/1/2569 BE.
//


import SwiftUI
import Supabase

@MainActor
class ConfirmEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var navigateToOTP = false

    func verifyEmailBeforeChange() async {
        do {
            try await supabase.auth.resetPasswordForEmail(email)
            self.navigateToOTP = true
            print("OTP Sent to \(email)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
