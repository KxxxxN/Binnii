//
//  DetailSearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 9/1/2569 BE.
//

import SwiftUI

struct DetailSearchView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    @State private var showConfirmPhotoView = false
    var onSaveSuccess: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    let category: String

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            // ✅ ป้องกัน negative/zero frame เหมือน WasteDetailView
            let imageWidth = geo.size.width > 40 ? geo.size.width - 40 : 0

            VStack(spacing: 0) {

                DetailWasteHeader(title: L("ค้นหา"), config: config)

                ScrollView {
                    VStack(spacing: 0) {
                        Image(WasteImageMapper.image(for: category))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageWidth, height: imageWidth > 0 ? 290 : 0)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        Spacer().frame(height: 23)

                        WasteDetailContentView(category: category, config: config)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        hideTabBar = true
                        showConfirmPhotoView = true
                    } label: {
                        HStack {
                            Text(L("ยืนยันภาพถ่าย"))
                                .font(.noto(config.fontHeader))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: config.isIPad ? 220 : 175, height: config.isIPad ? 60 : 49)
                        .background(Color.mainColor)
                        .cornerRadius(20)
                    }
                    .padding(.trailing, 25)
                    .padding(.bottom, 25)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationDestination(isPresented: $showConfirmPhotoView) {
                ConfirmPhotoView(
                    hideTabBar: $hideTabBar,
                    category: category,
                    onSaveSuccess: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) { dismiss() }
                        onSaveSuccess?()
                    }
                )
            }
            .navigationBarHidden(true)
            .onAppear { hideTabBar = true }
        }
        .background(Color.backgroundColor)
        .ignoresSafeArea()
    }
}

#Preview {
    DetailSearchView(hideTabBar: .constant(false), category: "ขวดพลาสติก")
}
