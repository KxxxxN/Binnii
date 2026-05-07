//
//  BarcodeScanViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI
import PhotosUI
import Vision

@MainActor
final class BarcodeScanViewModel: ObservableObject {

    // MARK: - UI State
    @Published var showBarcodeNotFound = false
    @Published var showDetailBarcodeView: Bool = false
    @Published var selectedTabNavigationItem: Int = 0
    @Published var isFlashOn: Bool = false
    @Published var isCameraActive: Bool = true
    @Published var isScanning: Bool = true
//    @Published var cameraID: UUID = UUID()

    // MARK: - Image & Barcode
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var capturedBarcodeImage: UIImage? = nil
    @Published var scannedBarcode: String? = nil

    // MARK: - Dependency
    let barcodeVM = BarcodeViewModel()

    // MARK: - Lifecycle
    func onViewAppear(hideTabBar: Binding<Bool>) {
        hideTabBar.wrappedValue = true
        if !showDetailBarcodeView {
            isCameraActive = true
            isScanning = true
        }
    }
    
    func onViewDisappear() {
        if !showDetailBarcodeView {
            isCameraActive = false
            isScanning = false
        }
    }

    // MARK: - Scan from Camera
    func handleScannedBarcode(_ barcode: String, hideTabBar: Binding<Bool>) {
        guard !showDetailBarcodeView else { return }
        scannedBarcode = barcode
        isScanning = false
        hideTabBar.wrappedValue = true
        Task {
            await barcodeVM.fetchProduct(barcode: barcode)
            var waited = 0
            while capturedBarcodeImage == nil && waited < 10 {
                try? await Task.sleep(nanoseconds: 100_000_000)
                waited += 1
            }
            if barcodeVM.isNotFound {
                showBarcodeNotFound = true
                isScanning = true
            } else {
                showDetailBarcodeView = true
            }
        }
    }

    // MARK: - Capture Button (test)
    func handleCaptureButton(hideTabBar: Binding<Bool>) {
        hideTabBar.wrappedValue = true
        Task {
            await barcodeVM.fetchProduct(barcode: "test_barcode")
            if barcodeVM.isNotFound {
                showBarcodeNotFound = true
            } else {
                showDetailBarcodeView = true
            }
        }
    }

    // MARK: - Reset after detail dismiss
    func resetAfterDismiss() {
        showBarcodeNotFound = false
        barcodeVM.isNotFound = false
        scannedBarcode = nil
        selectedItem = nil
//        selectedTabNavigationItem = 0

        isCameraActive = false
        isScanning = false
        capturedBarcodeImage = nil

        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            isCameraActive = true
            isScanning = true
        }
    }

    // MARK: - Image Loading from Gallery
    func loadImage(from item: PhotosPickerItem?, hideTabBar: Binding<Bool>) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    self.scanBarcodeFromImage(uiImage.fixedOrientation(), hideTabBar: hideTabBar)
                }
            }
        }
    }

    // MARK: - Scan Barcode from Image (Vision)
    private func scanBarcodeFromImage(_ image: UIImage, hideTabBar: Binding<Bool>) {
        guard let cgImage = image.cgImage else { return }

        let request = VNDetectBarcodesRequest { request, error in
            if let error { print("❌ Vision error: \(error)"); return }
            guard let results = request.results as? [VNBarcodeObservation],
                  let barcode = results.first?.payloadStringValue else { return }

            DispatchQueue.main.async {
                self.scannedBarcode = barcode
                self.capturedBarcodeImage = image
                hideTabBar.wrappedValue = true
                Task {
                    await self.barcodeVM.fetchProduct(barcode: barcode)
                    if self.barcodeVM.isNotFound {  
                        self.showBarcodeNotFound = true
                    } else {
                        self.showDetailBarcodeView = true
                    }
                }
            }
        }

        request.symbologies = [.ean13, .ean8, .upce, .code128, .qr, .dataMatrix]
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        try? handler.perform([request])
    }
}
