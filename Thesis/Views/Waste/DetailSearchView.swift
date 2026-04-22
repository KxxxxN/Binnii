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
    
    let category: String

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    DetailWasteHeader(title: "ค้นหา", config: config)
                    
                    // MARK: - Content
                    ScrollView {
                        VStack(spacing: 0) {
                            Image(WasteImageMapper.image(for: category))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 290)
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
                                Text("ยืนยันภาพถ่าย")
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
            }
        }
        .navigationDestination(isPresented: $showConfirmPhotoView) {
            ConfirmPhotoView(hideTabBar: $hideTabBar, category: category)
        }
        .navigationBarHidden(true)
        .onAppear { hideTabBar = true }
    }
}

#Preview {
    DetailSearchView(hideTabBar: .constant(false), category: "ขวดพลาสติก")
}

