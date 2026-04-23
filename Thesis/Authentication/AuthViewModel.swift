//
//  AuthViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 24/2/2569 BE.
//


import SwiftUI
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Session
    func getInitialSession() async {
        do {
            // ใน SDK บางเวอร์ชัน .session จะ throw error ถ้าไม่มี session
            let current = try await supabase.auth.session
            
            self.session = current
            self.isAuthenticated = true
            
        } catch {
            // ถ้าเข้ามาใน catch แสดงว่าไม่มี session หรือเกิดข้อผิดพลาด
            self.session = nil
            self.isAuthenticated = false
            print("No active session or error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Email Auth
    func signUp(email:String,password:String) async {
        do {
            let result = try await supabase.auth.signUp(email: email, password: password)
            self.session = result.session
            self.isAuthenticated = self.session != nil
            print("Sign up Success!")
        } catch {
            print("Sign up Failed: \(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            let result = try await supabase.auth.signIn(email: email, password: password)
            self.session = result
            self.isAuthenticated = self.session != nil
            print("Sign in Success!")
        } catch {
            print("Sign in Failed: \(error.localizedDescription)")
        }
    }
    
    // ✅ X (Twitter) Login
    //    func signInWithX() async {
    //        do {
    //            let url = try supabase.auth.getOAuthSignInURL(
    //                provider: .twitter,
    //                redirectTo: URL(string: "binnii://login-callback")!
    //            )
    //            await UIApplication.shared.open(url)
    //        } catch {
    //            print("X Sign in Failed: \(error.localizedDescription)")
    //        }
    //    }
    //
    //    func signInWithGoogle() async {
    //        do {
    //            let url = try supabase.auth.getOAuthSignInURL(
    //                provider: .google,
    //                redirectTo: URL(string: "binnii://login-callback")!
    //            )
    //            await UIApplication.shared.open(url)
    //        } catch {
    //            print("Google Sign in Failed: \(error.localizedDescription)")
    //        }
    //    }
    // MARK: - OAuth
    func signInWithOAuth(provider: Provider) async {
        errorMessage = nil
        
        do {
            let url = try supabase.auth.getOAuthSignInURL(
                provider: provider,
                redirectTo: URL(string: "binnii://login-callback")!
            )
            await UIApplication.shared.open(url)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func handleOAuthCallback(url: URL) async {
        do {
            let session = try await supabase.auth.session(from: url)
            self.session = session
            self.isAuthenticated = true
            print("X Sign in Success! Email: \(session.user.email ?? "-")")
        } catch {
            print("OAuth Callback Failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Sign Out
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.isAuthenticated = false
        } catch {
            print("Sign out Failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Account
    func deleteUser() async {
        do {
            print("Calling delete-user function...")
            
            let session = try await supabase.auth.session
            let token = session.accessToken
            print("Access token: \(token.prefix(20))...") // print แค่ต้นๆ
            
            try await supabase.functions.invoke(
                "delete-user",
                options: FunctionInvokeOptions(
                    headers: ["Authorization": "Bearer \(token)"]
                )
            )
            
            self.session = nil
            self.isAuthenticated = false
            print("Delete Account Success!")
        } catch {
            self.errorMessage = error.localizedDescription
            print("Delete Account Failed: \(error.localizedDescription)")
        }
    }
}
