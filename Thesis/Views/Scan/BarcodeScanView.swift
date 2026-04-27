//
//  BarcodeScanView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI

struct BarcodeScanView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @Binding var currentTab: ScanTab
    @Binding var slideDirection: Int
    
    @StateObject private var viewModel = BarcodeScanViewModel()
    
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
                    capturedUIImage: $viewModel.capturedBarcodeImage,
                    isFlashOn: $viewModel.isFlashOn,
                    isScanning: $viewModel.isScanning,
                    isCameraActive: $viewModel.isCameraActive,
                    scanMode: true,
                    barcodeMode: true,
                    onScan:  { barcode in
                        viewModel.handleScannedBarcode(barcode, hideTabBar: $hideTabBar)
                    }
                )
//                .id(viewModel.cameraID)
                
                VStack(spacing: 0) {
                    
                    ScanHeaderView(
                        title: L("สแกนบาร์โค้ด"),
                        isFlashOn: viewModel.isFlashOn,
                        onFlashToggle: { viewModel.isFlashOn.toggle() },
                        config: config
                    )
                    
                    VStack {
                        
                        Text("กรุณาสแกนบาร์โค้ดของขยะทีละชิ้น")
                            .font(.noto(config.fontHeader, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: config.qrContentMaxWidth, height: config.confirmBannerHeight)
                            .background(Color.textFieldColor)
                            .cornerRadius(config.bannerCornerRadius)
                        
                        Spacer()
                        
                        ScanBottomControls(
                            selectedItem: $viewModel.selectedItem,
                            captureImageName: "Barcode",
                            onImageSelected: { viewModel.loadImage(from: $0, hideTabBar: $hideTabBar) },
                            onCapture: { viewModel.handleCaptureButton(hideTabBar: $hideTabBar) },
                            config: config
                        )
                        
                        AiScanBottomNavigationBar(
                            selectedTab: $viewModel.selectedTabNavigationItem
                        ) { index in
                            switch index {
                            case 1: switchTab(to: .ai)
                            case 2: switchTab(to: .search)
                            default: break
                            }
                        }
                        .padding(.bottom, config.paddingStandard)
                        .padding(.top, config.spacingSmall)
                        
                    }
                }
                
                // MARK: - Loading Overlay
                if viewModel.barcodeVM.isLoading {
                    BarcodeLoadingOverlay(config: config)
                }
                
                if viewModel.showBarcodeNotFound {
                    BarcodeScanResultAlert(
                        onDismiss: {
                            viewModel.showBarcodeNotFound = false
                            viewModel.resetAfterDismiss()
                        },
                        config: config
                    )
                }
            }
            .onAppear {
                viewModel.onViewAppear(hideTabBar: $hideTabBar)
                
                OrientationHelper.setOrientation(.portrait)
            }

            .onDisappear {
                viewModel.onViewDisappear()
                
                OrientationHelper.setOrientation(.all)
            }
            .navigationDestination(isPresented: $viewModel.showDetailBarcodeView) {
                WasteDetailView(
                    hideTabBar: $hideTabBar,
                    category: viewModel.barcodeVM.category,
                    capturedImage: viewModel.capturedBarcodeImage,
                    title: L("สแกนบาร์โค้ด"),
                    scanMethod: "barcode"
                )
                .onDisappear {
                    viewModel.resetAfterDismiss()
                }
            }
//            .onChange(of: viewModel.showDetailBarcodeView) { _, isShowing in
//                if !isShowing { viewModel.resetAfterDismiss() }
//            }
            .onChange(of: currentTab) { _, tab in
                viewModel.isCameraActive = (tab == .barcode)
                viewModel.isScanning = (tab == .barcode)
                viewModel.selectedTabNavigationItem = tab.rawValue 
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    BarcodeScanView(
        hideTabBar: .constant(false),
        currentTab: .constant(.barcode),
        slideDirection: .constant(0)
    )
}
