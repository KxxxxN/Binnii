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
                .id(viewModel.cameraID)
                
                VStack(spacing: 0) {
                    
                    ScanHeaderView(
                        title: "สแกนบาร์โค้ด",
                        isFlashOn: viewModel.isFlashOn,
                        onFlashToggle: { viewModel.isFlashOn.toggle() },
                        config: config
                    )
                    
                    VStack {
                        
                        Spacer()
                            .frame(height: config.barcodeShutterSpacerHeight)
                        
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
            }
            .onAppear { viewModel.onViewAppear(hideTabBar: $hideTabBar) }
            .onDisappear { viewModel.onViewDisappear() }
            .navigationDestination(isPresented: $viewModel.showDetailBarcodeView) {
                WasteDetailView(
                    hideTabBar: $hideTabBar,
                    category: viewModel.barcodeVM.category,
                    capturedImage: viewModel.capturedBarcodeImage,
                    title: "สแกนบาร์โค้ด",
                    scanMethod: "barcode"
                )
            }
            .onChange(of: viewModel.showDetailBarcodeView) { _, isShowing in
                if !isShowing { viewModel.resetAfterDismiss() }
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
