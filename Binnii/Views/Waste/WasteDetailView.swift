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
    var onSaveSuccess: (() -> Void)? = nil

    @StateObject private var viewModel = WasteDetailViewModel()

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
            let imageWidth = geo.size.width > 40 ? geo.size.width - 40 : 0

            VStack(spacing: 0) {
                headerView(config: config)

                ScrollView {
                    VStack(spacing: 0) {
                        photoView(imageWidth: imageWidth)

                        WasteDetailContentView(
                            category: category,
                            config: config,
                            showDate: true
                        )
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarHidden(true)
            .onAppear { hideTabBar = true }
            .overlay {
                if viewModel.showSaveSuccess {
                    SuccessPopupView(message: L("บันทึกสำเร็จ")) {
                        if let onSaveSuccess {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) { dismiss() }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                onSaveSuccess()
                            }
                        } else {
                            dismiss()
                        }
                    }
                }

                if viewModel.showSaveError {
                    ErrorPopupView(title: L("บันทึกไม่สำเร็จ")) {
                        viewModel.showSaveError = false
                    }
                }
            }
        }
        .background(Color.backgroundColor)
        .ignoresSafeArea()
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        ZStack {
            Text(L(title))
                .font(.noto(25, weight: .bold))
                .foregroundColor(.black)

            HStack {
                BackButton()
                Spacer()

                Button {
                    Task {
                        await viewModel.save(
                            category: category,
                            scanMethod: scanMethod,
                            capturedImage: capturedImage
                        )
                    }
                } label: {
                    if viewModel.isSaving {
                        ProgressView().padding(.trailing, 25)
                    } else {
                        Text(L("บันทึก"))
                            .font(.noto(config.fontBody, weight: .medium))
                            .foregroundColor(.mainColor)
                            .padding(.trailing, 25)
                    }
                }
                .disabled(viewModel.isSaving)
            }
        }
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.bottomTitlePadding)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Photo
    private func photoView(imageWidth: CGFloat) -> some View {
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
        .frame(width: imageWidth, height: imageWidth > 0 ? 290 : 0)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.bottom, 30)
    }
}

#Preview {
    WasteDetailView(hideTabBar: .constant(false), category: "เศษอาหาร")
}
