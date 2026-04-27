//
//  TranslateView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//

import SwiftUI

struct TranslateView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var viewModel = TranslateViewModel()
    // ✅ observe เพื่อให้ checkmark อัปเดตทันทีที่เลือกภาษา
    @ObservedObject private var lm = LanguageManager.shared

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

            VStack(spacing: 0) {

                // MARK: - Header
                ZStack {
                    Text("เปลี่ยนภาษา")
                        .font(.noto(config.titleFontSize, weight: .bold))
                        .foregroundColor(Color.black)

                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.headerTopPadding)
                .padding(.bottom, config.bottomTitlePadding)

                // MARK: - Language List
                VStack(spacing: 0) {
                    ForEach(viewModel.languages, id: \.code) { lang in
                        LanguageSelectionRow(
                            code: lang.code,
                            name: lang.name,
                            imageName: lang.image,
                            selectedCode: lm.selectedLanguage  // ✅ ใช้ lm โดยตรง
                        ) { newCode in
                            viewModel.selectLanguage(newCode)
                        }
                    }
                }
                .padding(.top, 35)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            // ✅ ทุก Text("key") ใน view นี้แปลตามภาษาที่เลือก
            .environment(\.locale, lm.locale)
        }
    }
}

#Preview {
    TranslateView()
}
