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
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                
                ZStack {
                    if self.index == 0 { MainAppView(hideTabBar: $hideTabBar, tabIndex: $index) }
                    else if self.index == 1 { QRScanView(hideTabBar: $hideTabBar, index: $index) }
                    else if self.index == 2 { KnowledgeView(hideTabBar: $hideTabBar) }
                    else { AccountView() }
                }
                
                if !hideTabBar && index != 1 {
                    MainTabView(index: self.$index)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
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
