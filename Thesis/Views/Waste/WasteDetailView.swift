//
//  WasteDetailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/4/2569 BE.
//


import SwiftUI
import Storage
import Auth

struct WasteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    var category: String
    var capturedImage: UIImage?
    var showBarcodeImage: Bool = false
    var title: String = "ยืนยันภาพถ่าย"
    var scanMethod: String = "search"
    
    @StateObject private var viewModel = WasteDetailViewModel()
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView(config: config)
                    
                    // MARK: - Content
                    ScrollView {
                        VStack(spacing: 0) {
                            photoView
                            WasteDetailContentView(category: category, config: config)
                        }
                        .frame(minHeight: 750)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .navigationBarHidden(true)
            .onAppear { hideTabBar = true }
            .overlay {
                if viewModel.showSaveSuccess {
                    SuccessPopupView(message: "บันทึกสำเร็จ") {
                        viewModel.showSaveSuccess = false
                        dismiss()
                    }
                }
                if viewModel.showSaveError {
                    ErrorPopupView(title: "บันทึกไม่สำเร็จ") {
                        viewModel.showSaveError = false
                    }
                }
            }
        }
    }
    private func headerView(config: ResponsiveConfig) -> some View {
        ZStack {
            Text(title)
                .font(.noto(25, weight: .bold))
                .foregroundColor(.black)

            HStack {
                BackButton()
                Spacer()
                Button {
                    Task { await viewModel.save(category: category, scanMethod: scanMethod, capturedImage: capturedImage) }
                } label: {
                    if viewModel.isSaving {
                        ProgressView().padding(.trailing, 25)
                    } else {
                        Text("บันทึก")
                            .font(.noto(config.fontBody, weight: .medium))
                            .foregroundColor(.mainColor)
                            .padding(.trailing, 25)
                    }
                }
                .disabled(viewModel.isSaving)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, config.isIPad ? 40 : 27)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }
    private var photoView: some View {
        Group {
            if let uiImage = capturedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("BarcodeEx")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 290)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.bottom, 30)
    }
}

#Preview {
    WasteDetailView(hideTabBar: .constant(false), category: "เศษอาหาร")
}
