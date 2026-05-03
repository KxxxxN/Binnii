//
//  AiScanView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

struct AiScanView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @Binding var currentTab: ScanTab
    @Binding var slideDirection: Int
    
    @StateObject private var viewModel = AiScanViewModel()
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    private func switchTab(to tab: ScanTab) {
        slideDirection = tab.rawValue > currentTab.rawValue ? -1 : 1
        currentTab = tab
    }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
            ZStack(alignment: .top) {
                
                CameraContainerView(
                    hideTabBar: $hideTabBar,
                    capturedUIImage: $viewModel.capturedUIImage,
                    isFlashOn: $viewModel.isFlashOn,
                    isScanning: $viewModel.isScanning,
                    isCameraActive: $viewModel.isCameraActive,
                    shouldCapture: viewModel.shouldCapture
                )
                
                VStack(spacing: 0) {
                    
                    ScanHeaderView(
                        title: L("สแกนด้วย "),
                        aiSuffix: "AI",
                        isFlashOn: viewModel.isFlashOn,
                        onFlashToggle: { viewModel.toggleFlash() },
                        config: config
                    )
                    
                    VStack {
                        Text(L("กรุณาสแกนขยะทีละชิ้นเพื่อแยกประเภท"))
                            .font(.noto(config.fontHeader, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: config.qrContentMaxWidth, height: config.confirmBannerHeight)
                            .background(Color.textFieldColor)
                            .cornerRadius(config.bannerCornerRadius)
                        
                        Spacer()
                        
                        ScanBottomControls(
                            selectedItem: $viewModel.selectedItem,
                            captureImageName: "Tabler_ai",
                            onImageSelected: { viewModel.loadImage(from: $0) },
                            onCapture: { viewModel.handleCaptureButton() },
                            config: config
                        )
                        
                        AiScanBottomNavigationBar(
                            selectedTab: .constant(1)
                        ) { index in
                            switch index {
                            case 0: switchTab(to: .barcode)
                            case 2: switchTab(to: .search)
                            default: break
                            }
                        }
                        .padding(.bottom, config.paddingStandard)
                        .padding(.top, config.spacingSmall)
                    }
                }
                
                // MARK: - Result Alert
                if viewModel.showResultAlert {
                    AiScanResultAlert(
                        resultTitle: viewModel.resultTitle,
                        onRescan: { viewModel.resetScan() },
                        onConfirm: { viewModel.confirmResult() },
                        config: config
                    )
                }
                
                
                // MARK: - Loading
                if viewModel.isAnalyzing {
                    ScanLoadingOverlay()
                }
            }
        }
        .onChange(of: viewModel.capturedUIImage) { _, newImage in
            viewModel.onCapturedImageChanged(newImage)
        }
        .onAppear {
            viewModel.onViewAppear()
            
            OrientationHelper.setOrientation(.portrait)
        }

        .onDisappear {
            viewModel.onViewDisappear()
            
            OrientationHelper.setOrientation(.all)
        }
        .navigationDestination(isPresented: $viewModel.showDetailView) {
            WasteDetailView(
                hideTabBar: $hideTabBar,
                category: viewModel.aiResult,
                capturedImage: viewModel.capturedUIImage,
                title: L("สแกนด้วย AI"),
                scanMethod: "ai"
            )
            .onDisappear {
                viewModel.resetAfterDismiss()
            }
        }
//        .onChange(of: currentTab) { _, tab in
//            viewModel.isCameraActive = (tab == .ai)
//            viewModel.isScanning = (tab == .ai)
//            
//            if tab != .ai {
//                viewModel.isFlashOn = false
//            }
//        }
        .navigationBarHidden(true)
    }
}
        
#Preview {
    NavigationStack {
        AiScanView(
            hideTabBar: .constant(false),
            currentTab: .constant(.ai),
            slideDirection: .constant(0)
        )
    }
}
