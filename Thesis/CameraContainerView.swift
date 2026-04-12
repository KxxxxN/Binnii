//
//  CameraContainerView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/4/2569 BE.
//

import SwiftUI

struct CameraContainerView: View {
    @Binding var hideTabBar: Bool
    @Binding var capturedUIImage: UIImage?
    @Binding var isFlashOn: Bool
    @Binding var isScanning: Bool
    @Binding var isCameraActive: Bool
    var shouldCapture: Bool = false
    var scanMode: Bool = false
    var barcodeMode: Bool = false
    var onScan: ((String) -> Void)? = nil

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let uiImage = capturedUIImage {
                    GeometryReader { geo in
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }
                    .ignoresSafeArea()
                } else {
                    CameraPreview(
                        isScanning: $isScanning,
                        isActive: $isCameraActive,
                        capturedImage: $capturedUIImage,
                        isFlashOn: $isFlashOn,
                        shouldCapture: shouldCapture,
                        scanMode: scanMode,
                        barcodeMode: barcodeMode,
                        onScan: onScan
                    )
                    Color.black.opacity(0.25)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}
