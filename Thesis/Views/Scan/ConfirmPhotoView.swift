//
//  ConfirmPhotoView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 9/1/2569 BE.
//

import SwiftUI
import PhotosUI

struct ConfirmPhotoView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    var category: String
    var onSaveSuccess: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = ConfirmPhotoViewModel()
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
                        
            ZStack(alignment: .top) {
                
                CameraContainerView(
                    hideTabBar: $hideTabBar,
                    capturedUIImage: $viewModel.selectedUIImage,
                    isFlashOn: $viewModel.isFlashOn,
                    isScanning: $viewModel.isScanning,
                    isCameraActive: $viewModel.isCameraActive,
                    shouldCapture: viewModel.shouldCapture
                )
                
                VStack(spacing: 0) {
                    
                    ScanHeaderView(
                        title: "ยืนยันภาพถ่าย",
                        isFlashOn: viewModel.isFlashOn,
                        onFlashToggle: { viewModel.isFlashOn.toggle() },
                        config: config
                    )
                    
                    VStack {
                        
                        Text("กรุณาถ่ายรูปขยะทีละชิ้น ให้ตรงกับที่ค้นหา")
                            .font(.noto(config.fontHeader, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: config.qrContentMaxWidth, height: config.confirmBannerHeight)
                            .background(Color.textFieldColor)
                            .cornerRadius(config.bannerCornerRadius)
                        
                        Spacer()
                        
                    ScanBottomControls(
                            selectedItem: $viewModel.selectedItem,
                            captureImageName: "Camera",
                            onImageSelected: { viewModel.loadImage(from: $0) },
                            onCapture: { viewModel.handleCaptureButton(hideTabBar: $hideTabBar) },
                            config: config
                        )

                        .padding(.bottom, config.paddingStandard)
                    }
                }
            }
            .onChange(of: viewModel.selectedUIImage) { _, newImage in
                viewModel.onImageChanged(newImage, hideTabBar: $hideTabBar)
            }
            .onChange(of: viewModel.showSaveSearchPhotoView) { _, isShowing in
                if !isShowing { viewModel.resetAfterDismiss() }
            }
            .navigationDestination(isPresented: $viewModel.showSaveSearchPhotoView) {
                if let uiImage = viewModel.selectedUIImage {
                    WasteDetailView(
                        hideTabBar: $hideTabBar,
                        category: category,
                        capturedImage: uiImage,
                        title: "ค้นหา",
                        scanMethod: "search",
                        onSaveSuccess: {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                dismiss()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                onSaveSuccess?()
                            }
                        }
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }
}
    
#Preview {
    ConfirmPhotoView(hideTabBar: .constant(false), category: "ขวดพลาสติก")
}
