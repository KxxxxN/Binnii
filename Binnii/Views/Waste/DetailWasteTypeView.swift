//
//  DetailWasteTypeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct DetailWasteTypeView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    let category: String

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            let imageWidth = geo.size.width > 40 ? geo.size.width - 40 : 0

            VStack(spacing: 0) {

                DetailWasteHeader(title: L("ประเภทขยะ"), config: config)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Image(WasteImageMapper.image(for: category))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageWidth, height: imageWidth > 0 ? 290 : 0)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        Spacer().frame(height: config.isIPad ? 40 : 23)

                        WasteDetailContentView(category: category, config: config)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarHidden(true)
            .onAppear { hideTabBar = true }
        }
        .background(Color.backgroundColor)
        .ignoresSafeArea()
    }
}

#Preview {
    DetailWasteTypeView(hideTabBar: .constant(false), category: "ขวดพลาสติก")
}
