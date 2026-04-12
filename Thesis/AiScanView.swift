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
    @Environment(\.horizontalSizeClass) private var sizeClass
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

    @State private var capturedUIImage: UIImage? = nil
    @State private var shouldCapture = false
    @State private var isAnalyzing = false

    @State private var aiResult: String = "ขวดพลาสติก"
    @State private var isScanning = true

    private func resultTitle(config: ResponsiveConfig) -> AttributedString {
        var text = AttributedString("ขยะชิ้นนี้คือ \(aiResult) \nถูกต้องหรือไม่?")
        if let range = text.range(of: aiResult) {
            text[range].font = .noto(config.titleFontSize, weight: .bold) // เดิม: 25 → titleFontSize 25/36
        }
        return text
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

                ZStack(alignment: .top) {

                    // MARK: - Background
                    ZStack {
                        if let uiImage = capturedUIImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                                .background(Color.cameraBackground)
                        } else if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                                .background(Color.cameraBackground)
                        } else {
                            CameraPreview(
                                isScanning: $isScanning,
                                isActive: $isCameraActive,
                                capturedImage: $capturedUIImage,
                                isFlashOn: $isFlashOn,
                                shouldCapture: shouldCapture
                            )
                            Color.black.opacity(0.25)
                        }
                    }
                    .ignoresSafeArea()

                    // MARK: - Foreground
                    VStack(spacing: 0) {

                        headerView(config: config)

                        VStack {
                            Text("กรุณาสแกนขยะทีละชิ้นเพื่อแยกประเภท")
                                .font(.noto(config.fontHeader, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: config.qrContentMaxWidth,
                                       minHeight: config.confirmBannerHeight)
                                .background(Color.textFieldColor)
                                .cornerRadius(config.bannerCornerRadius)
                                .padding(.top, config.confirmBannerTopPadding)
                                .padding(.horizontal, config.paddingMedium)

                            Spacer(minLength: 0)

                            HStack {
                                GalleryPickerButton(selectedItem: $selectedItem)
                                    .onChange(of: selectedItem) { _, newItem in
                                        loadImage(from: newItem)
                                    }

                                Spacer()

                                Button {
                                    if capturedUIImage != nil || selectedImage != nil {
                                        analyzeImage()
                                    } else {
                                        shouldCapture = true
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.mainColor, lineWidth: config.aiButtonOuterLineWidth) // เดิม: 3
                                            .frame(width: config.aiButtonOuterSize,      // เดิม: 85
                                                   height: config.aiButtonOuterSize)

                                        Circle()
                                            .fill(Color.mainColor)
                                            .frame(width: config.aiButtonInnerSize,      // เดิม: 73
                                                   height: config.aiButtonInnerSize)

                                        Image("Tabler_ai")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: config.aiButtonIconSize,       // เดิม: 57
                                                   height: config.aiButtonIconSize)
                                    }
                                }

                                Spacer()
                                Color.clear.frame(width: 55, height: 1)
                            }
                            .frame(maxWidth: config.qrContentMaxWidth)                  // เดิม: 343 → qrContentMaxWidth
                            

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
                            .padding(.bottom, config.paddingStandard)                   // เดิม: 25 → paddingStandard 28/40
                            .padding(.top, config.spacingSmall)
                        }
                        .frame(maxWidth: config.qrContentMaxWidth)                  // เดิม: 343 → qrContentMaxWidth
                    }

                    // MARK: - Result Alert
                    if showResultAlert {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.8)
                                .ignoresSafeArea()

                            VStack(spacing: config.paddingMedium) {                     // เดิม: 16 → paddingMedium 16/24
                                Text(resultTitle(config: config))
                                    .font(.noto(config.titleFontSize, weight: .medium))  // เดิม: 25 → titleFontSize 25/36
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)

                                Text("ผลการสแกนตรงกับขยะของคุณหรือไม่?\nหากไม่ถูกต้อง กรุณาสแกนใหม่")
                                    .font(.noto(config.fontBody, weight: .medium))       // เดิม: 16 → fontBody 16/20
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)

                                HStack(spacing: config.alertButtonSpacing) {            // เดิม: 21 → alertButtonSpacing 21/30
                                    Button {
                                        capturedUIImage = nil
                                        selectedImage = nil
                                        selectedItem = nil
                                        shouldCapture = false
                                        showResultAlert = false
                                    } label: {
                                        Text("สแกนใหม่")
                                            .font(.noto(config.fontBody, weight: .bold)) // เดิม: 16 → fontBody 16/20
                                            .foregroundColor(.mainColor)
                                            .frame(width: config.qrAlertButtonWidth,    // เดิม: 120 → qrAlertButtonWidth 120/160
                                                   height: config.qrAlertButtonHeight)  // เดิม: 40 → qrAlertButtonHeight 40/52
                                            .background(Color.white)
                                            .cornerRadius(config.qrAlertButtonHeight / 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: config.qrAlertButtonHeight / 2)
                                                    .stroke(Color.mainColor, lineWidth: 2)
                                            )
                                    }

                                    Button {
                                        showResultAlert = false
                                        showDetailView = true
                                    } label: {
                                        Text("ถูกต้อง")
                                            .font(.noto(config.fontBody, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: config.qrAlertButtonWidth,
                                                   height: config.qrAlertButtonHeight)
                                            .background(Color.mainColor)
                                            .cornerRadius(config.qrAlertButtonHeight / 2)
                                    }
                                }
                            }
                            .padding(config.paddingMedium)                              // เดิม: 20 → paddingMedium 16/24
                            .frame(width: config.qrContentMaxWidth)                  // เดิม: 343 → qrContentMaxWidth 343/500
                            .frame(height: config.isIPad ? 350 : 250)

                            .background(Color.white)
                            .cornerRadius(config.bannerCornerRadius)
                        }
                    }

                    // MARK: - Analyzing Overlay
                    if isAnalyzing {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea()

                            ProgressView()
                                .scaleEffect(config.isIPad ? 2.0 : 1.5)
                                .padding(config.paddingStandard)                        // เดิม: 30 → paddingStandard 28/40
                                .background(Color.white)
                                .cornerRadius(config.bannerCornerRadius)
                        }
                    }
                }
                .onChange(of: capturedUIImage) { _, newImage in
                    if newImage != nil {
                        shouldCapture = false
                        analyzeImage()
                    }
                }
                .onAppear {
                    hideTabBar = true
                    selectedTabnavigationItem = 1
                    OrientationHelper.setOrientation(.portrait)
                }
                .onDisappear {
                    hideTabBar = false
                    OrientationHelper.setOrientation(.all)
                }
                .navigationDestination(isPresented: $showDetailView) {
                    DetailAiScanView(hideTabBar: $hideTabBar)
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
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        HStack {
            BackButton()
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("สแกนด้วย ")
                    .font(.noto(config.titleFontSize, weight: .bold))                   // เดิม: 25 → titleFontSize 25/36
                Text("AI")
                    .font(.inter(config.titleFontSize, weight: .bold))
            }
            .foregroundColor(.black)
            .layoutPriority(1)

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize) // เดิม: 35 → headerIconSize 35/45
                    .padding(.trailing, config.paddingStandard)                         // เดิม: 25 → paddingStandard 28/40
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.top, config.headerTopPadding)                                        // เดิม: 69 → headerTopPadding 65/80
        .padding(.bottom, config.paddingMedium)                                        // เดิม: 18 → paddingMedium 16/24
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
                    capturedUIImage = uiImage
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    private func analyzeImage() {
        isAnalyzing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isAnalyzing = false
            aiResult = "ขวดพลาสติก"
            showResultAlert = true
        }
    }
}
