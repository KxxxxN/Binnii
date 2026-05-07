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
import Combine

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

    private var isResetting = false
    
    // MARK: - Language Management
    private var lm = LanguageManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private func L(_ key: String) -> String { lm.localized(key) }
    
    init() {
        // ติดตามการเปลี่ยนภาษาเพื่อให้ UI อัปเดต AttributedString ทันที
        lm.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    // MARK: - Computed
    var resultTitle: AttributedString {
        let prefix = L("ขยะชิ้นนี้คือ")
        let suffix = L("ถูกต้องหรือไม่?")
        
        let thaiName = labelToThai(aiResult)        // "plasticBottle" → "ขวดพลาสติก"
        let localizedResult = L(thaiName)           // "ขวดพลาสติก" → "Plastic Bottle" (EN)

        var text = AttributedString("\(prefix) \(localizedResult)\n\(suffix)")

        if let range = text.range(of: localizedResult) {
            text[range].font = .noto(25, weight: .bold)
            text[range].foregroundColor = .black
        }
        return text
    }

    // MARK: - Lifecycle
    func onViewAppear() {
        isCameraActive = true
        isScanning = true
    }

    func onViewDisappear() {
        if !showDetailView {
            isCameraActive = false
            isScanning = false
        }
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
    
    func resetAfterDismiss() {
        showResultAlert = false
        aiResult = ""
        selectedItem = nil
        shouldCapture = false

        isCameraActive = false
        isScanning = false
        capturedUIImage = nil

        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            isCameraActive = true
            isScanning = true
        }
    }
    
    // MARK: - AI Analysis
    func analyzeImage() {
        guard let uiImage = capturedUIImage else { return }
        isAnalyzing = true

        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? BinniiAI(configuration: MLModelConfiguration()),
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

                    self.aiResult = top.identifier
                    self.showResultAlert = true
                }
            }
            request.imageCropAndScaleOption = .centerCrop

            guard let cgImage = uiImage.cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }

    // MARK: - Label Mapping (คืนค่าเป็น Key สำหรับแปลภาษา)
        private func labelToThai(_ label: String) -> String {
            switch label {
            case "plasticBottle": return "ขวดพลาสติก"
            case "can": return "กระป๋อง"
            case "General Paper": return "กระดาษทั่วไป" 
            case "Tissues": return "กระดาษทิชชู่"
            case "Cardboard Box": return "กล่องกระดาษ"
            case "Plastic cutlery": return "ช้อน-ส้อม พลาสติก"
            case "Snack Bag": return "ซองขนม"
            case "Wooden Chopsticks": return "ตะเกียบไม้"
            case "Plastic Bag": return "ถุงพลาสติก"
            case "Leftover Ice": return "น้ำแข็งเหลือ"
            case "Food Container": return "ภาชนะใส่อาหาร"
            case "Straw": return "หลอด"
            case "Leftover Drinks": return "เครื่องดื่มเหลือ"
            case "Fruit Peel": return "เปลือกผลไม้"
            case "Eggshell": return "เปลือกไข่"
            case "Crumbs": return "เศษขนม"
            case "Food waste": return "เศษอาหาร"
            case "Plastic Cups": return "แก้วพลาสติก"
            default:              return "ไม่พบขยะชิ้นนี้"
            }
        }
}
