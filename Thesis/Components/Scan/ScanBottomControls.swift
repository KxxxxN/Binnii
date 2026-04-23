//
//  ScanBottomControls.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


// ScanBottomControls.swift
// Thesis

import SwiftUI
import PhotosUI

struct ScanBottomControls: View {
    @Binding var selectedItem: PhotosPickerItem?
    let captureImageName: String
    let onImageSelected: (PhotosPickerItem?) -> Void
    let onCapture: () -> Void
    let config: ResponsiveConfig

    var body: some View {
        HStack {
            GalleryPickerButton(selectedItem: $selectedItem)
                .onChange(of: selectedItem) { _, newItem in
                    onImageSelected(newItem)
                }

            Spacer()

            ScanCaptureButton(
                imageName: captureImageName,
                onCapture: onCapture,
                config: config
            )

            Spacer()
            Color.clear.frame(width: config.isIPad ? 75 : 55, height: 1)
        }
        .frame(maxWidth: config.qrContentMaxWidth)
    }
}