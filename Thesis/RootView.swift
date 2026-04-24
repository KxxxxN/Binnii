//
//  RootView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var shouldHideTabBar = false
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView()
        } else {
            ContentView(hideTabBar: $shouldHideTabBar)
                .environmentObject(authViewModel)
                .environmentObject(userProfileViewModel)
        }
    }
}


