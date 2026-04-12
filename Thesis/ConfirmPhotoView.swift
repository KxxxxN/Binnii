//
//  ConfirmPhotoView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 9/1/2569 BE.
//

import SwiftUI
import PhotosUI

struct ConfirmPhotoView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @State private var showSaveSearchPhotoView = false

    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var isCameraActive = true
    @State private var shouldCapture = false

    @State private var isScanning = true

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            ZStack(alignment: .top) {

                // MARK: - Background
                ZStack {
                    if let uiImage = selectedUIImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .background(Color.cameraBackground)
                    } else {
                        CameraPreview(
                            isScanning: $isScanning,
                            isActive: $isCameraActive,
                            capturedImage: $selectedUIImage,
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

                        Text("กรุณาถ่ายรูปขยะทีละชิ้น ให้ตรงกับที่ค้นหา")
                            .font(.noto(config.fontHeader, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: config.qrContentMaxWidth,
                                   minHeight: config.confirmBannerHeight)
                            .background(Color.textFieldColor)
                            .cornerRadius(config.bannerCornerRadius)
                            .padding(.top, config.confirmBannerTopPadding)
                            .padding(.horizontal, config.paddingMedium)

                        Spacer()

                        HStack {
                            GalleryPickerButton(selectedItem: $selectedItem)
                                .onChange(of: selectedItem) { _, newItem in
                                    loadImage(from: newItem)
                                }

                            Spacer()

                            Button {
                                if selectedUIImage != nil {
                                    hideTabBar = true
                                    showSaveSearchPhotoView = true
                                } else {
                                    shouldCapture = true
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .stroke(Color.mainColor, lineWidth: config.aiButtonOuterLineWidth)
                                        .frame(width: config.aiButtonOuterSize, height: config.aiButtonOuterSize)

                                    Circle()
                                        .fill(Color.mainColor)
                                        .frame(width: config.aiButtonInnerSize, height: config.aiButtonInnerSize)
                                    Image("Camera")
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
                        .padding(.bottom, config.paddingStandard)
                    }
                }
            }
            
            .onAppear {
                // ✅ 1. ล็อกหน้าจอเป็นแนวตั้งเมื่อเข้าหน้านี้
                OrientationHelper.setOrientation(.portrait)
                            
                // ตั้งค่าอื่นๆ
                hideTabBar = true
                isCameraActive = true
            }
            .onDisappear {
                // ✅ 2. ปลดล็อกหน้าจอให้หมุนได้อิสระเมื่อออกจากหน้านี้
                // (หรือเปลี่ยนเป็นแนวที่โปรเจกต์คุณใช้เป็นหลัก)
                OrientationHelper.setOrientation(.all)
                            
                isCameraActive = false
            }
            .onChange(of: selectedUIImage) { _, newImage in
                if newImage != nil {
                    shouldCapture = false
                    hideTabBar = true
                    showSaveSearchPhotoView = true
                }
            }
            .navigationDestination(isPresented: $showSaveSearchPhotoView) {
                if let uiImage = selectedUIImage {
                    SaveSearchPhotoView(hideTabBar: $hideTabBar, selectedImage: uiImage)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        HStack {
            BackButton()
            Color.clear.frame(width: config.spacingSmall, height: config.spacingSmall)  // เดิม: 10 → spacingSmall 10/20

            Spacer()

            Text("ยืนยันภาพถ่าย")
                .font(.noto(config.titleFontSize, weight: .bold))   // เดิม: 25 → titleFontSize 25/36
                .foregroundColor(.black)

            Spacer()

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize)
                    .padding(.trailing, config.paddingStandard)
            }
        }
        .padding(.bottom, config.paddingMedium)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let data,
                   let uiImage = UIImage(data: data) {
                    selectedUIImage = uiImage
                }
            }
        }
    }
}
