//
//  AiScanViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI
import PhotosUI
import CoreML
import Vision

@MainActor
final class AiScanViewModel: ObservableObject {

    // MARK: - UI State
    @Published var isFlashOn: Bool = false
    @Published var showResultAlert: Bool = false
    @Published var showDetailView: Bool = false
    @Published var isAnalyzing: Bool = false
    @Published var isCameraActive: Bool = true
    @Published var isScanning: Bool = true
    @Published var shouldCapture: Bool = false

    // MARK: - Image
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var capturedUIImage: UIImage? = nil

    // MARK: - Result
    @Published var aiResult: String = ""

    // MARK: - Computed
    var resultTitle: AttributedString {
        var text = AttributedString("ขยะชิ้นนี้คือ \(aiResult) \nถูกต้องหรือไม่?")
        if let range = text.range(of: aiResult) {
            text[range].font = .noto(25, weight: .bold)
        }
        return text
    }

    // MARK: - Lifecycle
    func onViewAppear() {
        isCameraActive = true
        isScanning = true
    }

    func onViewDisappear() {
        isCameraActive = false
        isScanning = false
    }

    // MARK: - Actions
    func toggleFlash() {
        isFlashOn.toggle()
    }

    func handleCaptureButton() {
        if capturedUIImage != nil {
            analyzeImage()
        } else {
            shouldCapture = true
        }
    }

    func resetScan() {
        capturedUIImage = nil
        selectedItem = nil
        shouldCapture = false
        showResultAlert = false
    }

    func confirmResult() {
        showResultAlert = false
        showDetailView = true
    }

    func onCapturedImageChanged(_ newImage: UIImage?) {
        if newImage != nil {
            shouldCapture = false
            analyzeImage()
        }
    }

    // MARK: - Image Loading
    func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    self.capturedUIImage = uiImage
                }
            }
        }
    }

    // MARK: - AI Analysis
    func analyzeImage() {
        guard let uiImage = capturedUIImage else { return }
        isAnalyzing = true

        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? MyGarbageModel(configuration: MLModelConfiguration()),
                  let vnModel = try? VNCoreMLModel(for: model.model) else {
                DispatchQueue.main.async { self.isAnalyzing = false }
                return
            }

            let request = VNCoreMLRequest(model: vnModel) { request, _ in
                DispatchQueue.main.async {
                    self.isAnalyzing = false
                    guard let results = request.results as? [VNClassificationObservation],
                          let top = results.first else { return }

                    results.prefix(5).forEach {
                        print("🏷️ \($0.identifier) - \(String(format: "%.1f", $0.confidence * 100))%")
                    }

                    self.aiResult = self.labelToThai(top.identifier)
                    self.showResultAlert = true
                }
            }
            request.imageCropAndScaleOption = .centerCrop

            guard let cgImage = uiImage.cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }

    // MARK: - Label Mapping
    private func labelToThai(_ label: String) -> String {
        switch label {
        case "plasticBottle": return "ขวดพลาสติก"
        case "can":           return "กระป๋อง"
        default:              return "ไม่พบขยะชิ้นนี้"
        }
    }
}
