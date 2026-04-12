//
//  DetailAiScanView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI

struct DetailAiScanView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool

    let separationSteps = [
        SeparationStep(imageName: "DetailRecycle1", text: "เทน้ำให้หมด"),
        SeparationStep(imageName: "DetailRecycle2", text: "เอาฝาและฉลากออก"),
        SeparationStep(imageName: "DetailRecycle3", text: "บีบขวดให้แบน")
    ]

    let recyclingMethods = [
        "ใช้เป็นกระถางปลูกต้นไม้เล็กๆ",
        "ตัดครึ่งขวดทำเป็นที่ใส่ปากกา",
        "นำไปหลอมเป็นเส้นใยพลาสติก"
    ]
    
    let plasticbottleStep = [
        PlasticbottleStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
        PlasticbottleStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
        PlasticbottleStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
        PlasticbottleStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล")
    ]
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header Section
                    ZStack {
                        Text("สแกนด้วย AI")
                            .font(.noto(config.fontTitle, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack {
                            BackButton()
                            Spacer()
                            Button {
                                // Action บันทึก
                            } label: {
                                Text("บันทึก")
                                    .font(.noto(config.isIPad ? 20 : 16, weight: .medium))
                                    .foregroundColor(.mainColor)
                            }
                        }
                    }
                    .padding(.horizontal, config.isIPad ? 60 : 20)
                    .padding(.bottom, config.isIPad ? 40 : 27)
                    .padding(.top, config.headerTopPadding)

                    // MARK: - Content Section
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            // 1. รูปภาพสินค้า
                            Image("AiBottle")
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1.25, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.horizontal, config.isIPad ? 60 : 20)
                            
                            Spacer().frame(height: config.isIPad ? 40 : 23)
                            
                            // 2. พื้นที่เนื้อหาที่มีพื้นหลังสีครีมและขอบโค้ง
                            VStack(alignment: .leading, spacing: 0) {
                                
                                // ชื่อขยะและวันที่
                                HStack(spacing: 12) {
                                    Text("ขวดพลาสติก")
                                        .font(.noto(config.titleFontSize, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Text("13/9/2568 - 13:00")
                                        .font(.noto(config.detailStepTextFontSize, weight: .medium))
                                        .foregroundColor(.black)
                                        .padding(.top, config.isIPad ? 12 : 8)
                                }
                                .padding(.top, 24)
                                .padding(.horizontal, config.detailContentPaddingH)

                                // ประเภทถังขยะ
                                HStack(spacing: 13) {
                                    Image("Bin3")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: config.detailMainBinHeight)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("ประเภทถังขยะ")
                                            .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                                        
                                        HStack(spacing: 0) {
                                            Text("ถังขยะรีไซเคิล ")
                                                .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                                            Text("(สีเหลือง)")
                                                .font(.noto(config.isIPad ? 24 : 18, weight: .bold))
                                                .foregroundColor(.recycleWasteColor)
                                        }
                                    }
                                }
                                .padding(.top, 25)
                                .padding(.horizontal, config.detailContentPaddingH)
                                
                                // วิธีการแยกขยะ
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("วิธีการแยกขยะ")
                                        .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, config.detailContentPaddingH)

                                    HStack(alignment: .top, spacing: 0) {
                                        ForEach(separationSteps.indices, id: \.self) { index in
                                            
                                            // ลูกศรคั่นกลาง
                                            if index > 0 {
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: config.detailArrowSize))
                                                    .padding(.horizontal, 2)
                                                    .padding(.top, config.detailStepImageSize / 2 - (config.detailArrowSize / 2))
                                            }
                                            
                                            // รูปภาพและข้อความขั้นตอน
                                            VStack(spacing: 0) {
                                                Image(separationSteps[index].imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: config.detailStepImageSize, height: config.detailStepImageSize)
                                                    .padding(.bottom, 10)
                                                
                                                Text(separationSteps[index].text)
                                                    .font(.noto(config.detailStepTextFontSize, weight: .medium))
                                                    .foregroundColor(.black)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(2)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 45, alignment: .top)
                                                
                                                Spacer().frame(height: 10)
                                                
                                                // ถังขยะใบเล็กด้านล่าง (เช็ค index ป้องกัน error)
                                                if index < plasticbottleStep.count {
                                                    VStack(spacing: 2) {
                                                        Image(plasticbottleStep[index].imageName)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                                                        
                                                        Text(plasticbottleStep[index].text)
                                                            .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                                            .foregroundColor(.black)
                                                            .multilineTextAlignment(.center)
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .padding(.horizontal, config.isIPad ? 20 : 10)
                                }
                                .padding(.top, 30)
                                
                                // การรีไซเคิล
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("การรีไซเคิล")
                                        .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        ForEach(recyclingMethods, id: \.self) { method in
                                            Text("•   \(method)")
                                                .font(.noto(config.detailBodyFontSize, weight: .medium))
                                        }
                                    }
                                }
                                .padding(.horizontal, config.detailContentPaddingH)
                                .padding(.top, 30)
                                .padding(.bottom, 50)
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .background(
                                Color.knowledgeBackground
                                    .clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight]))
                                    .ignoresSafeArea(.container, edges: .horizontal)
                            )
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                .ignoresSafeArea(.container, edges: .top)
            }
            .navigationBarHidden(true)
            .onAppear {
                hideTabBar = true
            }
        }
    }
}
