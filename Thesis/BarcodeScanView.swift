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
    @Binding var hideTabBar: Bool
    @StateObject private var barcodeVM = BarcodeViewModel()
    
    @State private var showAiScanView = false
    @State private var showSearchView = false
    @State private var showDetailBarcodeView = false
    @State private var selectedTabnavigationItem = 0
    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var selectedUIImage: UIImage? = nil
    @State private var isCameraActive = true
    @State private var scannedBarcode: String? = nil
//    @State private var scannedCategory: String = ""
    @State private var isScanning = true
    @State private var capturedBarcodeImage: UIImage? = nil
    @State private var cameraID = UUID()

    var body: some View {
        NavigationStack {
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

                    headerView

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
                                    await barcodeVM.fetchProduct(barcode: "test_barcode") // ใส่ barcode ที่ต้องการทดสอบ
                                    showDetailBarcodeView = true
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .stroke(Color.mainColor, lineWidth: 3)
                                        .frame(width: 85, height: 85)

                                    Circle()
                                        .fill(Color.mainColor)
                                        .frame(width: 73, height: 73)

                                    Image("Barcode")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                }
                            }

                            Spacer()
                            Color.clear.frame(width: 55, height: 1)
                        }
                        .frame(maxWidth: 343)

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
                        .padding(.bottom, 25)
                        .padding(.top, 21)
                    }
                }
                if barcodeVM.isLoading {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        VStack(spacing: 12) {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.5)
                            Text("กำลังค้นหาข้อมูล...")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear { hideTabBar = true }
            .onDisappear { hideTabBar = false }
            .navigationDestination(isPresented: $showAiScanView) {
                AiScanView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showSearchView) {
                SearchView(hideTabBar: $hideTabBar)
            }

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
                        cameraID = UUID()  // ✅ force recreate
                        isScanning = true
                        isCameraActive = true
                    }
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            BackButton()
            Color.clear.frame(width: 10, height: 10)

            Spacer()

            Text("สแกนบาร์โค้ด")
                .font(.noto(25, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 25)
            }
        }
        .padding(.top, 69)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 123)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
        .edgesIgnoringSafeArea(.top)
    }

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
                capturedBarcodeImage = image  // ✅ เก็บรูปจาก gallery ไว้ด้วย
                hideTabBar = true
                Task {
                    await barcodeVM.fetchProduct(barcode: barcode)
                    showDetailBarcodeView = true
                }
            }
        }

        // ระบุ symbology ที่ต้องการ
        request.symbologies = [.ean13, .ean8, .upce, .code128, .qr, .dataMatrix]

        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("❌ handler error: \(error)")
        }
    }
}
