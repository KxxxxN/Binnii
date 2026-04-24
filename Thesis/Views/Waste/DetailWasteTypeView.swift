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
    
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
                
                VStack(spacing: 0) {
                    
                    DetailWasteHeader(title: "ประเภทขยะ", config: config)

                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 0) {
                            Image(WasteImageMapper.image(for: category))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 290)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Spacer().frame(height: config.isIPad ? 40 : 23)
                            
                            WasteDetailContentView(category: category, config: config)
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                .background(Color.backgroundColor)
                .ignoresSafeArea()
            .navigationBarHidden(true)
            .onAppear {
                hideTabBar = true
            }
        }
    }
}

#Preview {
    DetailWasteTypeView(hideTabBar: .constant(false), category: "ขวดพลาสติก")
}
