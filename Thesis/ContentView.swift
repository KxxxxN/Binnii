//
//  ContentView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 25/10/2568 BE.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var hideTabBar: Bool
    @State var index = 0
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var displayIndex = 0
    @State private var showLoginPopup = false
    @State private var pendingIndex = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToLogin = false
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                
                ZStack {
                    if displayIndex == 0 { MainAppView(hideTabBar: $hideTabBar, tabIndex: $index) }
                    else if displayIndex == 1 { QRScanView(hideTabBar: $hideTabBar, index: $index) }
                    else if displayIndex == 2 { KnowledgeView(hideTabBar: $hideTabBar) }
                    else { AccountView() }
                    
                    if showLoginPopup {
                        LoginPopupView(
                            isPresented: $showLoginPopup,
                            onDismiss: {
                                index = 0
                                displayIndex = 0
                            },
                            onLogin: {
                                index = 0
                                displayIndex = 0
                                navigateToLogin = true
                            }
                        )
                    }
                }
                
                if !hideTabBar && index != 1 {
                    MainTabView(index: self.$index)
                        .disabled(showLoginPopup)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            .onReceive(NotificationCenter.default.publisher(for: .popToRoot)) { _ in
                navigateToLogin = false  // pop กลับมาที่ ContentView
            }
        }
        .onChange(of: index) {
            if (index == 1 || index == 3) && !isLoggedIn {
                displayIndex = index
                showLoginPopup = true
            } else {
                displayIndex = index
            }
        }
        .onChange(of: isLoggedIn) {
            if !isLoggedIn {
                index = 0
                displayIndex = 0
            }
        }
    }
}
#Preview {
    struct ContentViewPreviewContainer: View {
        @State private var hideTabBarState = false
        
        var body: some View {
            ContentView(hideTabBar: $hideTabBarState)
        }
    }
    
    return ContentViewPreviewContainer()
}


