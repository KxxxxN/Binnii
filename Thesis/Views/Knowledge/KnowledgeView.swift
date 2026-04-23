//
//  KnowledgeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 27/10/2568 BE.
//

import SwiftUI
import Foundation

struct KnowledgeView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    @StateObject private var vm = KnowledgeViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        Text("ความรู้ทั่วไป")
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .minimumScaleFactor(0.7)
                            .foregroundColor(.black)
                            .padding(.top, config.headerTopPadding)
                            .padding(.bottom, 10)
                        
                        // MARK: - Bin + Arrow
                        ZStack {
                            Image(vm.current.binImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: config.knowledgeBinImageSize,
                                       height: config.knowledgeBinImageSize)
                                .padding(.bottom, config.knowledgeBinPaddingBottom)
                            
                            // ปุ่มลูกศร
                            HStack {
                                if vm.canGoPrevious {
                                    Button(action: { vm.previous() }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: config.knowledgeArrowIconSize))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: config.knowledgeArrowButtonSize, height: config.knowledgeArrowButtonSize)
                                    .background(Color.mainColor)
                                    .clipShape(Circle())
                                    .padding(.leading, config.knowledgeArrowSidePadding)
                                } else {
                                    Color.clear
                                        .frame(width: config.knowledgeArrowButtonSize,
                                               height: config.knowledgeArrowButtonSize)
                                        .padding(.leading, config.knowledgeArrowSidePadding)
                                }
                                
                                Spacer()
                                
                                if vm.canGoNext {
                                    Button(action: { vm.next() }) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: config.knowledgeArrowIconSize))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: config.knowledgeArrowButtonSize, height: config.knowledgeArrowButtonSize)
                                    .background(Color.mainColor)
                                    .clipShape(Circle())
                                    .padding(.trailing, config.knowledgeArrowSidePadding)
                                    
                                } else {
                                    Color.clear
                                        .frame(width: config.knowledgeArrowButtonSize,
                                               height: config.knowledgeArrowButtonSize)
                                        .padding(.trailing, config.knowledgeArrowSidePadding)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // MARK: - Info + Examples
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Text(vm.current.name + " ")
                                    .font(.noto(config.titleFontSize, weight: .bold)) // ใช้ titleFontSize (36:25)
                                    .minimumScaleFactor(0.8)
                                    .foregroundColor(.black)
                                Text(vm.current.colorName)
                                    .font(.noto(config.titleFontSize, weight: .bold))
                                    .minimumScaleFactor(0.8)
                                    .foregroundColor(vm.current.color)
                            }
                            .padding(.bottom, 5)
                            
                            Text(vm.current.description)
                                .font(.noto(config.knowledgeDescFont, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minHeight: config.knowledgeDescHeight, maxHeight: config.knowledgeDescHeight, alignment: .top)
                                .padding(.bottom, 10)
                            
                            Text("ตัวอย่างขยะ:")
                                .font(.noto(config.knowledgeDescFont, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            
                            WasteExamplesGrid(
                                config: config,
                                hideTabBar: $hideTabBar,
                                wasteExamples: vm.current.examples
                            )
                            
                            Spacer(minLength: 50)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.horizontal, config.knowledgeContentPaddingH)
                        .padding(.top, config.knowledgeContentPaddingTop)
                        .background(
                            Color.knowledgeBackground
                                .clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight]))
                                .ignoresSafeArea(.container, edges: .horizontal)
                        )
                    }
                    .frame(width: geo.size.width)
                    .frame(minHeight: geo.size.height, alignment: .top)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            hideTabBar = false
        }
    }
}

#Preview {
    KnowledgeView(hideTabBar: .constant(false))
}
