//
//  ScanContainerView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 16/4/2569 BE.
//


import SwiftUI

enum ScanTab: Int, CaseIterable {
    case barcode = 0
    case ai = 1
    case search = 2
}

//struct ScanContainerView: View {
//    @Binding var hideTabBar: Bool
//    @State private var currentTab: ScanTab = .ai
//    @State private var slideDirection: Int = 0
//    var body: some View {
//        ZStack {
//            switch currentTab {
//            case .barcode:
//                BarcodeScanView(
//                    hideTabBar: $hideTabBar,
//                    currentTab: $currentTab,
//                    slideDirection: $slideDirection
//                )
//            case .ai:
//                AiScanView(
//                    hideTabBar: $hideTabBar,
//                    currentTab: $currentTab,
//                    slideDirection: $slideDirection
//                )
//            case .search:
//                SearchView(
//                    hideTabBar: $hideTabBar,
//                    currentTab: $currentTab,
//                    slideDirection: $slideDirection
//                )
//            }
//        }
//        .animation(.easeInOut(duration: 0.3), value: currentTab)
//    }
//}

struct ScanContainerView: View {
    @Binding var hideTabBar: Bool
    @State private var currentTab: ScanTab = .ai
    @State private var slideDirection: Int = 0

    var body: some View {
        ZStack {
            BarcodeScanView(
                hideTabBar: $hideTabBar,
                currentTab: $currentTab,
                slideDirection: $slideDirection
            )
            .opacity(currentTab == .barcode ? 1 : 0)
            .allowsHitTesting(currentTab == .barcode)

            AiScanView(
                hideTabBar: $hideTabBar,
                currentTab: $currentTab,
                slideDirection: $slideDirection
            )
            .opacity(currentTab == .ai ? 1 : 0)
            .allowsHitTesting(currentTab == .ai)

            SearchView(
                hideTabBar: $hideTabBar,
                currentTab: $currentTab,
                slideDirection: $slideDirection
            )
            .opacity(currentTab == .search ? 1 : 0)
            .allowsHitTesting(currentTab == .search)
        }
        .animation(.easeInOut(duration: 0.3), value: currentTab)
    }
}
