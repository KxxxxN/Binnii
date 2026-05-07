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
 
    /// ✅ QRScanView ส่งมาให้ — ตอน ScanContainer disappear จะ set เป็น true
    /// เพื่อให้ QRScanView รู้ว่าต้องล็อก portrait กลับ
    @Binding var shouldLockPortraitOnReturn: Bool
 
    @State private var currentTab: ScanTab = .ai
    @State private var slideDirection: Int = 0
 
    var body: some View {
        ZStack {
            switch currentTab {
            case .barcode:
                BarcodeScanView(
                    hideTabBar: $hideTabBar,
                    currentTab: $currentTab,
                    slideDirection: $slideDirection
                )
                .transition(.opacity)
 
            case .ai:
                AiScanView(
                    hideTabBar: $hideTabBar,
                    currentTab: $currentTab,
                    slideDirection: $slideDirection
                )
                .transition(.opacity)
 
            case .search:
                SearchView(
                    hideTabBar: $hideTabBar,
                    currentTab: $currentTab,
                    slideDirection: $slideDirection
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentTab)
        .onAppear {
            //  Lock portrait ตลอดที่อยู่ใน ScanContainer
            OrientationHelper.setOrientation(.portrait)
        }
        .onDisappear {
            // แจ้ง QRScanView ว่ากำลังกลับ — QRScanView จะ lock portrait เอง
            shouldLockPortraitOnReturn = true
            // ปลดล็อกก่อน แล้ว QRScanView จะ lock ทับทันที
            OrientationHelper.setOrientation(.all)
        }
        .onChange(of: currentTab) { _, _ in
            OrientationHelper.setOrientation(.portrait)
        }
    }
}
