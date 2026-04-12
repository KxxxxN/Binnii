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
    @StateObject private var barcodeVM = BarcodeViewModel()
    
    @State private var showAiScanView = false
    @State private var showSearchView = false
    @State private var showDetailBarcodeView = false
    @State private var selectedTabnavigationItem = 0
    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var isCameraActive = true
    @State private var scannedBarcode: String? = nil
    @State private var isScanning = true
    @State private var capturedBarcodeImage: UIImage? = nil
    @State private var cameraID = UUID()

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

                ZStack(alignment: .top) {

                    // MARK: - Background (กล้อง หรือ รูปจาก Gallery)
                    ZStack {
                        if let selectedUIImage {
                            GeometryReader { innerGeo in
                                Image(uiImage: selectedUIImage.fixedOrientation())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: innerGeo.size.width, height: innerGeo.size.height)
                                    .clipped()
                            }
                            .ignoresSafeArea()
                        } else {
                            CameraPreview(
                                isScanning: $isScanning,
                                isActive: $isCameraActive,
                                capturedImage: Binding(
                                    get: { capturedBarcodeImage },
                                    set: { capturedBarcodeImage = $0 }
                                ),
                                isFlashOn: $isFlashOn,
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
                            Color.black.opacity(0.25)
                        }
                    }
                    .ignoresSafeArea()

                    // MARK: - Foreground (UI ซ้อนทับ)
                    VStack(spacing: 0) {

                        headerView(config: config)
                        
                        Spacer(minLength: 0)


                        VStack {
                            Spacer()
                                .frame(height: config.barcodeShutterSpacerHeight)

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
                                            .stroke(Color.mainColor, lineWidth: config.aiButtonOuterLineWidth)
                                            .frame(width: config.aiButtonOuterSize, height: config.aiButtonOuterSize)

                                        Circle()
                                            .fill(Color.mainColor)
                                            .frame(width: config.aiButtonInnerSize, height: config.aiButtonInnerSize)

                                        Image("Barcode")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.barcodeShutterIconSize,
                                                   height: config.barcodeShutterIconSize)
                                    }
                                }

                                Spacer()
                                Color.clear.frame(width: 55, height: 1)
                            }
                            .frame(maxWidth: config.qrContentMaxWidth)  

                            AiScanBottomNavigationBar(
                                selectedTab: $selectedTabnavigationItem
                            ) { index in
                                hideTabBar = true
                                switch index {
                                case 1: showAiScanView = true
                                case 2: showSearchView = true
                                default: break
                                }
                            }
                            .padding(.bottom, config.paddingStandard)
                            .padding(.top, config.spacingSmall)
                        }
                        .frame(maxWidth: config.qrContentMaxWidth)                  // เดิม: 343 → qrContentMaxWidth

                    }

                    // MARK: - Loading Overlay
                    if barcodeVM.isLoading {
                        ZStack {
                            Color.black.opacity(0.3).ignoresSafeArea()
                            VStack(spacing: config.spacingSmall) {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(config.isIPad ? 2.0 : 1.5)
                                Text("กำลังค้นหาข้อมูล...")
                                    .font(.noto(config.fontBody, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .onAppear {
                    hideTabBar = true
                    OrientationHelper.setOrientation(.portrait)

                }
                .onDisappear {
                    hideTabBar = false
                    OrientationHelper.setOrientation(.all)
                }
            }
            .navigationDestination(isPresented: $showAiScanView) {
                AiScanView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showSearchView) {
                SearchView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showDetailBarcodeView) {
                DetailBarcodeView(
                    hideTabBar: $hideTabBar,
                    category: barcodeVM.category,
                    capturedImage: capturedBarcodeImage
                )
            }
            .navigationBarHidden(true)
            .onChange(of: showDetailBarcodeView) { _, isShowing in
                if !isShowing {
                    isScanning = false
                    isCameraActive = false
                    capturedBarcodeImage = nil
                    selectedUIImage = nil
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
        HStack {
            BackButton()
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("สแกนบาร์โค้ด")
                .font(.noto(config.titleFontSize, weight: .bold))
                .foregroundColor(.black)
                .layoutPriority(1)

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, config.headerSidePadding)
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.paddingMedium)
        .frame(maxWidth: .infinity)
        .frame(height: config.searchHeaderHeight)
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
                    selectedUIImage = uiImage.fixedOrientation()
                    scanBarcodeFromImage(uiImage.fixedOrientation())
                }
            }
        }
    }

    // MARK: - Scan Barcode from Image (Vision)
    private func scanBarcodeFromImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("❌ cgImage nil")
            return
        }

        let request = VNDetectBarcodesRequest { request, error in
            if let error {
                print("❌ Vision error: \(error)")
                return
            }

            guard let results = request.results as? [VNBarcodeObservation] else {
                print("❌ ไม่มี results")
                return
            }

            print("🔍 พบ barcode ทั้งหมด: \(results.count) อัน")
            results.forEach { obs in
                print("  - symbology: \(obs.symbology.rawValue)")
                print("  - payload: \(obs.payloadStringValue ?? "nil")")
                print("  - confidence: \(obs.confidence)")
            }

            guard let barcode = results.first?.payloadStringValue else {
                print("❌ payload nil")
                return
            }

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
        do {
            try handler.perform([request])
        } catch {
            print("❌ handler error: \(error)")
        }
    }
}
