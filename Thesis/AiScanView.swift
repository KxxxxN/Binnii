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

    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @State private var showBarcodeView = false
    @State private var showSearchView = false

    @State private var selectedTabnavigationItem = 1
    @State private var isFlashOn = false
    @State private var showResultAlert = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isCameraActive = true

    @State private var capturedUIImage: UIImage? = nil  // ✅ รับภาพจากกล้อง
    @State private var shouldCapture = false             // ✅ trigger ถ่าย
    @State private var isAnalyzing = false

    @State private var aiResult: String = "ขวดพลาสติก"
    
    @State private var isScanning = true

    private var resultTitle: AttributedString {
        var text = AttributedString("ขยะชิ้นนี้คือ \(aiResult) \nถูกต้องหรือไม่?")
        if let range = text.range(of: aiResult) {
            text[range].font = .noto(25, weight: .bold)
        }
        return text
    }

    var body: some View {
        NavigationStack {

            ZStack(alignment: .top) {

                CameraContainerView(
                    hideTabBar: $hideTabBar,
                    capturedUIImage: $capturedUIImage,
                    isFlashOn: $isFlashOn,
                    isScanning: $isScanning,
                    isCameraActive: $isCameraActive,
                    shouldCapture: shouldCapture
                )

                VStack(spacing: 0) {

                    headerView

                    VStack {
                        Text("กรุณาสแกนขยะทีละชิ้นเพื่อแยกประเภท")
                            .font(.noto(20, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: 343, height: 60)
                            .background(Color.textFieldColor)
                            .cornerRadius(20)

                        Spacer()

                        HStack {
                            GalleryPickerButton(selectedItem: $selectedItem)
                                .onChange(of: selectedItem) { _, newItem in
                                    loadImage(from: newItem)
                                }

                            Spacer()

                            Button {
                                // ✅ ถ้ามีรูปจาก gallery → วิเคราะห์เลย
                                // ถ้ายังไม่มี → ถ่ายภาพจากกล้องก่อน
                                if capturedUIImage != nil || selectedImage != nil {
                                    analyzeImage()
                                } else {
                                    shouldCapture = true
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .stroke(Color.mainColor, lineWidth: 3)
                                        .frame(width: 85, height: 85)

                                    Circle()
                                        .fill(Color.mainColor)
                                        .frame(width: 73, height: 73)

                                    Image("Tabler_ai")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 57, height: 57)
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
                            case 0: showBarcodeView = true
                            case 1: break
                            case 2: showSearchView = true
                            default: break
                            }
                        }
                        .padding(.bottom, 25)
                        .padding(.top, 21)
                    }
//                    .padding(.top, 18)
                }

                // Alert overlay
                if showResultAlert {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                            .ignoresSafeArea()

                        VStack(spacing: 16) {
                            Text(resultTitle)
                                .font(.noto(25, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text("ผลการสแกนตรงกับขยะของคุณหรือไม่?\nหากไม่ถูกต้อง กรุณาสแกนใหม่")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)

                            HStack(spacing: 21) {
                                Button {
                                    // ✅ reset ทั้งหมดเพื่อสแกนใหม่
                                    capturedUIImage = nil
                                    selectedImage = nil
                                    selectedItem = nil
                                    shouldCapture = false
                                    showResultAlert = false
                                } label: {
                                    Text("สแกนใหม่")
                                        .font(.noto(16, weight: .bold))
                                        .foregroundColor(.mainColor)
                                        .frame(width: 120, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.mainColor, lineWidth: 2)
                                        )
                                }

                                Button {
                                    showResultAlert = false
                                    showDetailView = true
                                } label: {
                                    Text("ถูกต้อง")
                                        .font(.noto(16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 40)
                                        .background(Color.mainColor)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(20)
                        .frame(width: 343, height: 255)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }

                if isAnalyzing {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()

                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(30)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                }
            }
            // ✅ เมื่อถ่ายภาพได้ → วิเคราะห์อัตโนมัติ
            .onChange(of: capturedUIImage) { _, newImage in
                if newImage != nil {
                    shouldCapture = false
                    analyzeImage()
                }
            }
            .onAppear {
                hideTabBar = true
                selectedTabnavigationItem = 1
            }
            .onDisappear { hideTabBar = false }
            .navigationDestination(isPresented: $showDetailView) {
                WasteDetailView(
                    hideTabBar: $hideTabBar,
                    category: aiResult,
                    capturedImage: capturedUIImage,
                    title: "สแกนด้วย AI",
                    scanMethod: "ai"   // ✅
                )
            }
            .navigationDestination(isPresented: $showBarcodeView) {
                BarcodeScanView(hideTabBar: $hideTabBar)
            }
            .navigationDestination(isPresented: $showSearchView) {
                SearchView(hideTabBar: $hideTabBar)
            }
            .navigationBarHidden(true)
        }
    }

    private var headerView: some View {
        HStack {
            BackButton()
            Color.clear.frame(width: 10, height: 10)

            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("สแกนด้วย ")
                    .font(.noto(25, weight: .bold))
                Text("AI")
                    .font(.inter(25, weight: .bold))
            }
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
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
        .edgesIgnoringSafeArea(.all)
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    // ✅ เก็บเป็น UIImage ด้วยเพื่อส่งวิเคราะห์ได้
                    capturedUIImage = uiImage
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    private func analyzeImage() {
        guard let uiImage = capturedUIImage else { return }
        isAnalyzing = true

        DispatchQueue.global(qos: .userInitiated).async {
            guard let model = try? MyGarbageModel(configuration: MLModelConfiguration()),
                  let vnModel = try? VNCoreMLModel(for: model.model) else {
                DispatchQueue.main.async { isAnalyzing = false }
                return
            }

            let request = VNCoreMLRequest(model: vnModel) { request, _ in
                DispatchQueue.main.async {
                    isAnalyzing = false

                    guard let results = request.results as? [VNClassificationObservation],
                          let top = results.first else { return }

                    // ✅ เพิ่มชั่วคราว print ดู label ทั้งหมด
                    print("=== AI Results ===")
                    results.prefix(5).forEach {
                        print("🏷️ \($0.identifier) - \(String(format: "%.1f", $0.confidence * 100))%")
                    }

                    aiResult = labelToThai(top.identifier)
                    showResultAlert = true
                }
            }
            request.imageCropAndScaleOption = .centerCrop

            guard let cgImage = uiImage.cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }

    // ✅ แปลง label → ภาษาไทย (แก้ให้ตรงกับ label ใน model ของคุณ)
    private func labelToThai(_ label: String) -> String {
        switch label {
        case "plasticBottle":   return "ขวดพลาสติก"
        case "can":              return "กระป๋อง"
        default:                 return "ไม่พบขยะชิ้นนี้"
        }
    }
}

#Preview {
    AiScanView(hideTabBar: .constant(false))
}
