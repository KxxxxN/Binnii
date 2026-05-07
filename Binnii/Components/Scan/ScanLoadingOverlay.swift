//
//  ScanLoadingOverlay.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


// ScanLoadingOverlay.swift
// Thesis

import SwiftUI

struct ScanLoadingOverlay: View {
    var body: some View {
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