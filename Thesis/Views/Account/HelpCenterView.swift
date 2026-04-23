//
//  HelpCenterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//

import SwiftUI

struct HelpCenterView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                
                // MARK: - Header
                ZStack {
                    Text("ช่วยเหลือ")
                        .font(.noto(config.titleFontSize, weight: .bold))
                    
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.top, config.headerTopPadding)
                .padding(.bottom, config.bottomTitlePadding)
                
                // MARK: - Menu List
                VStack(spacing: 0) {
                    HelpMenuRow(
                        title: "วิธีการใช้งาน",
                        imageName: "BookGuide",
                        destination: Text("หน้าวิธีการใช้งาน"),
                        config: config
                    )
                    HelpMenuRow(
                        title: "คำถามที่พบบ่อย",
                        imageName: "Question",
                        destination: FAQView(),
                        config: config
                    )
                }
                .padding(.top, 35)
                
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
    HelpCenterView()
}
