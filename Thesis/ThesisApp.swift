//
//  TheisApp.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

@main
struct ThesisApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @StateObject var authViewModel = AuthViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .onOpenURL { url in          // ✅ เพิ่มตรงนี้
                    Task {
                        await authViewModel.handleOAuthCallback(url: url)
                    }
                }
        }
    }
}
