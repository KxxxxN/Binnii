//
//  HelpCenterView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//

import SwiftUI

struct HelpCenterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    
    var body: some View {
        GeometryReader { geo in
            // เรียกใช้ ResponsiveConfig
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            VStack(spacing: 0) {
                
                ZStack {
                    Text("ช่วยเหลือ")
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
                    
                    // วิธีการใช้งาน
                    HelpMenuRow(
                        title: "วิธีการใช้งาน",
                        imageName: "BookGuide",
                        destination: Text("หน้าวิธีการใช้งาน"),
                        config: config
                    )
                    
                    // คำถามที่พบบ่อย
                    HelpMenuRow(
                        title: "คำถามที่พบบ่อย",
                        imageName: "Question",
                        destination: FAQView(),
                        config: config
                    )
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
    HelpCenterView()
}
