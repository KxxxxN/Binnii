//
//  FAQView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
        
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    Text("คำถามที่พบบ่อย")
                        .font(.noto(config.titleFontSize, weight: .bold))
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.headerTopPadding)
                .padding(.bottom, config.bottomTitlePadding)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: config.isIPad ? 15 : 9) {
                        ForEach(viewModel.faqItems) { item in
                            FAQExpandableRow(item: item, config: config)
                        }
                    }
                    .padding(.top, 31)
                    .padding(.horizontal, config.paddingMedium)
                    .padding(.bottom, config.paddingMedium)                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    FAQView()
}
