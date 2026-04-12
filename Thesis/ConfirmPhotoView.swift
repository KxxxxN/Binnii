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
    @Binding var hideTabBar: Bool
    var category: String
    @State private var showSaveSearchPhotoView = false
    
    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var isCameraActive = true
    @State private var shouldCapture = false  // ✅ เพิ่ม
    
    @State private var isScanning = true
    
    var body: some View {
        ZStack(alignment: .top) {
            
            CameraContainerView(
                hideTabBar: $hideTabBar,
                capturedUIImage: $selectedUIImage,
                isFlashOn: $isFlashOn,
                isScanning: $isScanning,
                isCameraActive: $isCameraActive,
                shouldCapture: shouldCapture
            )
            
            VStack(spacing: 0) {
                
                headerView
                
                VStack {
                    
                    Text("กรุณาถ่ายรูปขยะทีละชิ้น ให้ตรงกับที่ค้นหา")
                        .font(.noto(20, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 343, height: 60)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                        .padding(.top, 35)
                    
                    Spacer()
                    
                    HStack {
                        GalleryPickerButton(selectedItem: $selectedItem)
                            .onChange(of: selectedItem) { _, newItem in
                                loadImage(from: newItem)
                            }
                        
                        Spacer()
                        
                        Button {
                            // ✅ ถ้ามีรูปแล้ว (จาก gallery) → navigate เลย
                            // ถ้ายังไม่มีรูป → สั่งถ่ายภาพจากกล้อง
                            if selectedUIImage != nil {
                                hideTabBar = true
                                showSaveSearchPhotoView = true
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
                                
                                Image("Camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                            }
                        }
                        
                        Spacer()
                        Color.clear.frame(width: 55, height: 1)
                    }
                    .frame(maxWidth: 343)
                    .padding(.bottom, 25)
                }
            }
        }
        // ✅ เมื่อได้ภาพจากกล้อง → navigate อัตโนมัติ
        .onChange(of: selectedUIImage) { _, newImage in
            if newImage != nil && !showSaveSearchPhotoView {
                shouldCapture = false
                hideTabBar = true
                showSaveSearchPhotoView = true
            }
        }
        .navigationDestination(isPresented: $showSaveSearchPhotoView) {
            if let uiImage = selectedUIImage {
                WasteDetailView(
                    hideTabBar: $hideTabBar,
                    category: category,
                    capturedImage: uiImage,
                    title: "ค้นหา",
                    scanMethod: "search"
                )
            }
        }
        .onChange(of: showSaveSearchPhotoView) { _, isShowing in
            if !isShowing {
                selectedUIImage = nil
                selectedItem = nil
                isCameraActive = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    isCameraActive = true
//                    
//                }
            }
        }
        .navigationBarHidden(true)
    }
    
    var headerView: some View {
        HStack {
            BackButton()
            Color.clear.frame(width: 10, height: 10)
            
            Spacer()
            
            Text("ยืนยันภาพถ่าย")
                .font(.noto(25, weight: .bold))
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
        .padding(.bottom, 18)
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
                    selectedUIImage = uiImage.fixedOrientation()
                }
            }
        }
    }
}
