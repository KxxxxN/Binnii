//
//  SaveSearchPhotoView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 10/1/2569 BE.
//

import SwiftUI
import PhotosUI

struct SaveSearchPhotoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @State private var showDetailSaveSearchView = false

    @State private var isFlashOn = false
    @State private var selectedItem: PhotosPickerItem? = nil
    var selectedImage: UIImage

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            ZStack(alignment: .top) {

                // MARK: - Background
                ZStack {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .background(Color.cameraBackground)
                }
                .ignoresSafeArea()

                // MARK: - Foreground
                VStack(spacing: 0) {
                    headerView(config: config)
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showDetailSaveSearchView) {
                DetailSaveSearchView(hideTabBar: $hideTabBar)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        HStack {
            BackButton()
            Color.clear.frame(width: config.paddingSmall, height: config.paddingSmall)

            Spacer()

            Text("ยืนยันภาพถ่าย")
                .font(.noto(config.titleFontSize, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Button {
                hideTabBar = true
                showDetailSaveSearchView = true
            } label: {
                Text("บันทึก")
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(.mainColor)
            }
        }
        .padding(.trailing, config.paddingMedium)
        .padding(.bottom, config.paddingMedium)    
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }
}
