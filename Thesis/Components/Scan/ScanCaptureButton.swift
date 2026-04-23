//
//  ScanCaptureButton.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


// ScanCaptureButton.swift
// Thesis

import SwiftUI

struct ScanCaptureButton: View {
    let imageName: String
    let onCapture: () -> Void
    let config: ResponsiveConfig

    var body: some View {
        Button { onCapture() } label: {
            ZStack {
                Circle()
                    .stroke(Color.mainColor, lineWidth: config.aiButtonOuterLineWidth)
                    .frame(width: config.aiButtonOuterSize, height: config.aiButtonOuterSize)
                Circle()
                    .fill(Color.mainColor)
                    .frame(width: config.aiButtonInnerSize, height: config.aiButtonInnerSize)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.aiButtonIconSize, height: config.aiButtonIconSize)
            }
        }
    }
}