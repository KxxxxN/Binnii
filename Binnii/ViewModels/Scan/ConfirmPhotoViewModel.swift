//
//  ConfirmPhotoViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI
import PhotosUI

@MainActor
final class ConfirmPhotoViewModel: ObservableObject {

    // MARK: - UI State
    @Published var showSaveSearchPhotoView: Bool = false
    @Published var isFlashOn: Bool = false
    @Published var isCameraActive: Bool = true
    @Published var isScanning: Bool = true
    @Published var shouldCapture: Bool = false

    // MARK: - Image
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedUIImage: UIImage? = nil

    // MARK: - Actions
    func handleCaptureButton(hideTabBar: Binding<Bool>) {
        if selectedUIImage != nil {
            hideTabBar.wrappedValue = true
            showSaveSearchPhotoView = true
        } else {
            shouldCapture = true
        }
    }

    func onImageChanged(_ newImage: UIImage?, hideTabBar: Binding<Bool>) {
        guard newImage != nil, !showSaveSearchPhotoView else { return }
        shouldCapture = false
        hideTabBar.wrappedValue = true
        showSaveSearchPhotoView = true
    }

//    func resetAfterDismiss() {
//        selectedUIImage = nil
//        selectedItem = nil
//        isCameraActive = true
//    }
    
    func resetAfterDismiss() {
        selectedUIImage = nil
        selectedItem = nil
        shouldCapture = false
        
        isCameraActive = false
        isScanning = false
        
        Task {
            try? await Task.sleep(nanoseconds: 150_000_000)
            isCameraActive = true
            isScanning = true
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
                    self.selectedUIImage = uiImage.fixedOrientation()
                }
            }
        }
    }
}
