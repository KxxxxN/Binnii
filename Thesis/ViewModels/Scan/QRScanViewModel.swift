//
//  QRScanViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

@MainActor
final class QRScanViewModel: ObservableObject {

    // MARK: - Published States
    @Published var isFlashOn: Bool = false
    @Published var showResultAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showAiScanView: Bool = false

    @Published var isCameraActive: Bool = false
    @Published var isScanning: Bool = true
    @Published var cameraID: UUID = UUID()

    @Published var qrResult: String = ""

    // MARK: - Attributed Result Title
    func resultTitle(config: ResponsiveConfig) -> AttributedString {
        var text = AttributedString(qrResult)
        text.font = .noto(config.fontSubHeader, weight: .medium)
        if let range = text.range(of: "COSCI") {
            text[range].font = .inter(config.fontSubHeader, weight: .medium)
        }
        return text
    }

    // MARK: - Lifecycle
    func onAppear(hideTabBar: inout Bool) {
        hideTabBar = true
        isCameraActive = true
        isScanning = true
        cameraID = UUID()
        OrientationHelper.setOrientation(.portrait)
    }

    func onDisappear(hideTabBar: inout Bool) {
        if !showAiScanView {
            hideTabBar = false
        }
        isFlashOn = false
        isCameraActive = false
//        OrientationHelper.setOrientation(.all)
    }

    // MARK: - QR Scan Handler
    func handleScanResult(_ result: String) {
        qrResult = result
        isCameraActive = false
        isScanning = false
        if result.contains("COSCI") {
            showResultAlert = true
        } else {
            showErrorAlert = true
        }
    }

    // MARK: - Alert Actions
    func cancelResult() {
        showResultAlert = false
        resetCamera()
    }
    
    func navigateToAIScan(hideTabBar: inout Bool) {
        hideTabBar = true
        showAiScanView = true
    }

    func confirmResult(hideTabBar: inout Bool) {
        hideTabBar = true
        showResultAlert = false
        showAiScanView = true
    }

    func dismissError() {
        showErrorAlert = false
        resetCamera()
    }

    func navigateToAiScan(hideTabBar: inout Bool) {
        hideTabBar = true
        showAiScanView = true
    }

    func toggleFlash() {
        isFlashOn.toggle()
    }

    // MARK: - Private
    private func resetCamera() {
        cameraID = UUID()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.isScanning = true
            self?.isCameraActive = true
        }
    }
}
