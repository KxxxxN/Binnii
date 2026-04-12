//
//  TranslateView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//

import SwiftUI

struct TranslateView: View {
    //    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State private var selectedLanguageCode: String = "TH"
    
    let languages = [
        (code: "TH", name: "ภาษาไทย", image: "Thai"),
        (code: "EN", name: "English", image: "English")
    ]
    
    var body: some View {
        GeometryReader { geo in
            // เรียกใช้ ResponsiveConfig
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            VStack(spacing: 0) {
                
                // Header
                ZStack {
                    Text("เปลี่ยนภาษา")
                        .font(.noto(config.titleFontSize, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    HStack {
                        BackButton()
                        
                        Spacer()
                    }
                }
                .padding(.top, config.topPadding)
                .padding(.bottom, config.bottomTitlePadding)
                
                // Language Selection List
                VStack(spacing: 0) {
                    ForEach(languages, id: \.code) { lang in
                        LanguageSelectionRow(
                            code: lang.code,
                            name: lang.name,
                            imageName: lang.image,
                            selectedCode: selectedLanguageCode //
                        ) { newCode in
                            selectedLanguageCode = newCode
                        }
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
//}

#Preview {
    TranslateView()
}
