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
    @State private var currentIndex = 0
    @Binding var hideTabBar: Bool
    
    let wasteCategories: [WasteCategory] = [
        WasteCategory(
            name: "ถังขยะเปียก",
            colorName: "(สีเขียว)",
            color: .wetWasteColor,
            description: "สำหรับขยะที่ย่อยสลายได้เองตามธรรมชาติ",
            binImage: "Bin1",
            examples: [
                WasteExample(image: "Foodscraps", label: "เศษอาหาร"),
                WasteExample(image: "Egg", label: "เปลือกไข่"),
                WasteExample(image: "Fruit", label: "เปลือกผลไม้"),
                WasteExample(image: "Drink", label: "เครื่องดื่มเหลือ"),
                WasteExample(image: "Snack", label: "เศษขนม"),
                WasteExample(image: "Ice", label:"น้ำแข็งเหลือ")
            ]
        ),
        WasteCategory(
            name: "ถังขยะทั่วไป",
            colorName: "(สีน้ำเงิน)",
            color: .generalWasteColor,
            description: "สำหรับขยะทั่วไปไม่สามารถรีไซเคิลได้",
            binImage: "Bin2",
            examples: [
                WasteExample(image: "SnackBag", label: "ซองขนม"),
                WasteExample(image: "Tissue", label: "กระดาษทิชชู่"),
                WasteExample(image: "Foambox", label: "ภาชนะใส่อาหาร"),
                WasteExample(image: "Chopstick", label: "ตะเกียบไม้"),
                WasteExample(image: "Straw", label: "หลอด"),
                WasteExample(image: "Spoon", label: "ช้อน-ส้อมพลาสติก")
            ]
        ),
        WasteCategory(
            name: "ถังขยะรีไซเคิล",
            colorName: "(สีเหลือง)",
            color: .recycleWasteColor,
            description: "สำหรับขยะที่สามารถนำกลับมาใช้ใหม่หรือแปรรูปได้",
            binImage: "Bin3",
            examples: [
                WasteExample(image: "Bottle", label: "ขวดพลาสติก"),
                WasteExample(image: "Box", label: "กล่องกระดาษ"),
                WasteExample(image: "Plasticcup", label: "แก้วพลาสติก"),
                WasteExample(image: "paper", label: "กระดาษทั่วไป"),
                WasteExample(image: "Can", label: "กระป๋อง"),
                WasteExample(image: "Bag", label: "ถุงพลาสติก")
            ]
        ),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                Color.backgroundColor
                    .ignoresSafeArea()
                
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
                            
                            let current = wasteCategories[currentIndex]
                            
                            // ส่วนแสดงถังขยะและปุ่มลูกศร
                            ZStack {
                                Image(current.binImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: config.knowledgeBinImageSize, height: config.knowledgeBinImageSize)
                                    .padding(.bottom, config.knowledgeBinPaddingBottom)
                                
                                // ปุ่มลูกศร
                                HStack {
                                    // ปุ่มซ้าย
                                    if currentIndex > 0 {
                                        Button(action: {
                                            withAnimation(.easeInOut) {
                                                currentIndex -= 1
                                            }
                                        }) {
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
                                            .frame(width: config.knowledgeArrowButtonSize, height: config.knowledgeArrowButtonSize)
                                            .padding(.leading, config.knowledgeArrowSidePadding)
                                    }
                                    
                                    Spacer()
                                    
                                    // ปุ่มขวา
                                    if currentIndex < wasteCategories.count - 1 {
                                        Button(action: {
                                            withAnimation(.easeInOut) {
                                                currentIndex += 1
                                            }
                                        }) {
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
                                            .frame(width: config.knowledgeArrowButtonSize, height: config.knowledgeArrowButtonSize)
                                            .padding(.trailing, config.knowledgeArrowSidePadding)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // ส่วนข้อมูลและตัวอย่างขยะ
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(current.name + " ")
                                        .font(.noto(config.titleFontSize, weight: .bold)) // ใช้ titleFontSize (36:25)
                                        .minimumScaleFactor(0.8)
                                        .foregroundColor(.black)
                                    Text(current.colorName)
                                        .font(.noto(config.titleFontSize, weight: .bold))
                                        .minimumScaleFactor(0.8)
                                        .foregroundColor(current.color)
                                }
                                .padding(.bottom, 5)
                                
                                Text(current.description)
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
                                
                                // ส่ง config ให้ WasteExamplesGrid
                                WasteExamplesGrid(config: config, hideTabBar: $hideTabBar, wasteExamples: current.examples)
                                
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
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            hideTabBar = false
        }
    }
}

// MARK: - Subviews

struct WasteExamplesGrid: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    let wasteExamples: [WasteExample]
    
    private var columns: [GridItem] {
        if config.isIPad {
            return [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20),
            ]
        } else {
            return [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 18)
            ]
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: config.knowledgeGridSpacing) {
            ForEach(wasteExamples) { example in
                NavigationLink {
                    DetailWasteTypeView(hideTabBar: $hideTabBar, category: example.label)
                } label: {
                    WasteCard(config: config, example: example) 
                }
            }
        }
    }
}

struct WasteCard: View {
    let config: ResponsiveConfig
    let example: WasteExample
    
    var body: some View {
        HStack(spacing: 0) {
            Image(example.image)
                .resizable()
                .scaledToFit()
                .frame(width: config.wasteCardImageSize, height: config.wasteCardImageSize)
                .frame(width: config.wasteCardImageSize) // ล็อกขอบเขตภาพ
                .padding(10)
                
            Text(example.label)
                .font(.noto(config.wasteCardTextFont, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 10)
        }
        .frame(height: config.wasteCardHeight)
        .background(Color.wasteCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    KnowledgeView(hideTabBar: .constant(false))
}
