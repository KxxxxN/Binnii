//
//  BarcodeScanView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/12/2568 BE.
//

import SwiftUI
import PhotosUI
import Vision

struct BarcodeScanView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @Binding var currentTab: ScanTab
    @Binding var slideDirection: Int
    
    @StateObject private var barcodeVM = BarcodeViewModel()
    
    @State private var showDetailBarcodeView = false
    @State private var selectedTabnavigationItem = 0
    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var isCameraActive = true
    @State private var scannedBarcode: String? = nil
    @State private var isScanning = true
    @State private var capturedBarcodeImage: UIImage? = nil
    @State private var cameraID = UUID()
    
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
                    capturedUIImage: $capturedBarcodeImage,
                    isFlashOn: $isFlashOn,
                    isScanning: $isScanning,
                    isCameraActive: $isCameraActive,
                    scanMode: true,
                    barcodeMode: true,
                    onScan: { barcode in
                        guard !showDetailBarcodeView else { return }
                        scannedBarcode = barcode
                        isScanning = false
                        hideTabBar = true
                        Task {
                            await barcodeVM.fetchProduct(barcode: barcode)
                            var waited = 0
                            while capturedBarcodeImage == nil && waited < 10 {
                                try? await Task.sleep(nanoseconds: 100_000_000)
                                waited += 1
                            }
                            showDetailBarcodeView = true
                        }
                    }
                )
                .id(cameraID)
                
                VStack(spacing: 0) {
                    
                    headerView(config: config)
                    
                    VStack {
                        
                        Spacer()
                            .frame(height: 565)
                        
                        HStack {
                            GalleryPickerButton(selectedItem: $selectedItem)
                                .onChange(of: selectedItem) { _, newItem in
                                    loadImage(from: newItem)
                                }
                            
                            Spacer()
                            
                            
                            Button {
                                hideTabBar = true
                                Task {
                                    await barcodeVM.fetchProduct(barcode: "test_barcode")
                                    showDetailBarcodeView = true
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                    //                                       .stroke(Color.mainColor, lineWidth: config.aiButtonOuterLineWidth)
                                        .stroke(Color.mainColor, lineWidth: 3)
                                    //.frame(width: config.aiButtonOuterSize, height: config.aiButtonOuterSize)
                                        .frame(width: 85, height: 85)
                                    
                                    Circle()
                                        .fill(Color.mainColor)
                                    //.frame(width: config.aiButtonInnerSize, height: config.aiButtonInnerSize)
                                        .frame(width: 73, height: 73)
                                    
                                    Image("Barcode")
                                        .resizable()
                                        .scaledToFit()
                                    //.frame(width: config.barcodeShutterIconSize,height: config.barcodeShutterIconSize)
                                        .frame(width: 45,height: 45)
                                }
                            }
                            Spacer()
                            Color.clear.frame(width: 55, height: 1)
                        }
                        //                            .frame(maxWidth: config.qrContentMaxWidth)
                        .frame(maxWidth: 343)
                        
                        AiScanBottomNavigationBar(
                            selectedTab: $selectedTabnavigationItem
                        ) { index in
                            switch index {
                            case 1: switchTab(to: .ai)
                            case 2: switchTab(to: .search)
                            default: break
                            }
                        }
                        //.padding(.bottom, config.paddingStandard)
                        //.padding(.top, config.spacingSmall)
                        .padding(.bottom, 25)
                        .padding(.top, 21)
                        
                    }
                    //.frame(maxWidth: config.qrContentMaxWidth)
                    
                }
                
                // MARK: - Loading Overlay
                if barcodeVM.isLoading {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        //VStack(spacing: config.spacingSmall) {
                        VStack(spacing: 12) {
                            ProgressView()
                                .tint(.white)
                            //.scaleEffect(config.isIPad ? 2.0 : 1.5)
                                .scaleEffect(1.5)
                            Text("กำลังค้นหาข้อมูล...")
                            // .font(.noto(config.fontBody, weight: .medium))
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear {
                hideTabBar = true
                isCameraActive = true
                isScanning = true
                //OrientationHelper.setOrientation(.portrait)
                
            }
            .onDisappear {
                isCameraActive = false
                isScanning = false
                //OrientationHelper.setOrientation(.all)
            }
            //        }
            .navigationDestination(isPresented: $showDetailBarcodeView) {
                WasteDetailView(
                    hideTabBar: $hideTabBar,
                    category: barcodeVM.category,
                    capturedImage: capturedBarcodeImage,
                    title: "สแกนบาร์โค้ด",
                    scanMethod: "barcode"
                )
            }
            .navigationBarHidden(true)
            .onChange(of: showDetailBarcodeView) { _, isShowing in
                if !isShowing {
                    isScanning = false
                    isCameraActive = false
                    capturedBarcodeImage = nil
                    //                    selectedUIImage = nil
                    selectedItem = nil
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        cameraID = UUID()
                        isScanning = true
                        isCameraActive = true
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        //    private var headerView: some View {
        HStack {
            BackButton()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("สแกนบาร์โค้ด")
            //                .font(.noto(config.titleFontSize, weight: .bold))
                .font(.noto(25, weight: .bold))
                .foregroundColor(.black)
                .layoutPriority(1)
            
            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize)
                //                    .frame(width: 35, height: 35)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, config.headerSidePadding)
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.paddingMedium)
        //        .padding(.top, 69)
        //        .padding(.bottom, 20)
        //        .frame(maxWidth: .infinity)
        .frame(height: config.searchHeaderHeight)
        //        .frame(height: 123)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
        .edgesIgnoringSafeArea(.top)
    }
    
    // MARK: - Load Image from Gallery
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    //                    selectedUIImage = uiImage.fixedOrientation()
                    scanBarcodeFromImage(uiImage.fixedOrientation())
                }
            }
        }
    }
    
    // MARK: - Scan Barcode from Image (Vision)
    //    private func scanBarcodeFromImage(_ image: UIImage) {
    //        guard let cgImage = image.cgImage else {
    //            print("❌ cgImage nil")
    //            return
    //        }
    //
    //        let request = VNDetectBarcodesRequest { request, error in
    //            if let error {
    //                print("❌ Vision error: \(error)")
    //                return
    //            }
    //
    //            guard let results = request.results as? [VNBarcodeObservation] else {
    //                print("❌ ไม่มี results")
    //                return
    //            }
    //
    //            print("🔍 พบ barcode ทั้งหมด: \(results.count) อัน")
    //            results.forEach { obs in
    //                print("  - symbology: \(obs.symbology.rawValue)")
    //                print("  - payload: \(obs.payloadStringValue ?? "nil")")
    //                print("  - confidence: \(obs.confidence)")
    //            }
    //
    //            guard let barcode = results.first?.payloadStringValue else {
    //                print("❌ payload nil")
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //                scannedBarcode = barcode
    //                capturedBarcodeImage = image
    //                hideTabBar = true
    //                Task {
    //                    await barcodeVM.fetchProduct(barcode: barcode)
    //                    showDetailBarcodeView = true
    //                }
    //            }
    //        }
    //
    //        request.symbologies = [.ean13, .ean8, .upce, .code128, .qr, .dataMatrix]
    //
    //        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
    //        do {
    //            try handler.perform([request])
    //        } catch {
    //            print("❌ handler error: \(error)")
    //        }
    //    }
    //}
    private func scanBarcodeFromImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNDetectBarcodesRequest { request, error in
            if let error { print("❌ Vision error: \(error)"); return }
            guard let results = request.results as? [VNBarcodeObservation],
                  let barcode = results.first?.payloadStringValue else { return }
            
            DispatchQueue.main.async {
                scannedBarcode = barcode
                capturedBarcodeImage = image
                hideTabBar = true
                Task {
                    await barcodeVM.fetchProduct(barcode: barcode)
                    showDetailBarcodeView = true
                }
            }
        }
        
        request.symbologies = [.ean13, .ean8, .upce, .code128, .qr, .dataMatrix]
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        try? handler.perform([request])
    }
}
