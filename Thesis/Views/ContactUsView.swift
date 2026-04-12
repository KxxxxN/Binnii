//
//  ContactUsView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//

import SwiftUI

struct ContactUsView: View {
//    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
//        NavigationStack {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                
                // Header 
                ZStack {
                    Text("ติดต่อเรา")
                        .font(.noto(config.titleFontSize, weight: .bold))
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.topPadding)
                .padding(.bottom, config.bottomTitlePadding)
                
                // Menu List
                VStack(spacing: 0) {
                    ContactRow(
                        title: "ช่องทางที่ 1",
                        imageName: "ContactUs",
                        config: config
                    ) {
                        print("ติดต่อ 1")
                    }
                    
                    ContactRow(
                        title: "ช่องทางที่ 2",
                        imageName: "ContactUs",
                        config: config
                    ) {
                        print("ติดต่อ 2")
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
//        }
    }
}

#Preview {
    ContactUsView()
}
