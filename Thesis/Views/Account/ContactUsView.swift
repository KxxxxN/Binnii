//
//  ContactUsView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct ContactUsView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                
                ZStack {
                    Text(L("ติดต่อเรา"))
                        .font(.noto(config.titleFontSize, weight: .bold))
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.headerTopPadding)
                .padding(.bottom, config.bottomTitlePadding)
                
                // Menu List
                VStack(spacing: 0) {
                    ContactRow(
                        title: L("ช่องทางที่ 1"),
                        imageName: "ContactUs",
                        config: config
                    ) {
                        print("contact 1")
                    }
                    
                    ContactRow(
                        title: L("ช่องทางที่ 2"),
                        imageName: "ContactUs",
                        config: config
                    ) {
                        print("contact 2")
                    }
                }
                .padding(.top, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContactUsView()
}
