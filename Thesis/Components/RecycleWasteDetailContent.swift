//
//  RecycleWasteDetail.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/3/2569 BE.
//

import SwiftUI

// MARK: - Model
struct WasteSeparationStep {
    let imageName: String
    let text: String
    let imageSize: CGSize = CGSize(width: 90, height: 90)
}
struct WasteBinStep {
    let imageName: String
    let text: String
    let imageSize: CGSize = CGSize(width: 40, height: 40)
}

// MARK: - Shared Component
struct RecycleWasteDetailContent: View {
    let config: ResponsiveConfig
    
    let category: String
    let separationSteps: [WasteSeparationStep]
    let binSteps: [WasteBinStep]
    let recyclingMethods: [String]
    var showDate: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // ชื่อขยะและวันที่
            HStack(spacing: 12) {
                Text(category)
                    .font(.noto(config.titleFontSize, weight: .bold))
                
                if showDate {
                    Text(Date().formatted(date: .numeric, time: .shortened))
                        .font(.noto(config.detailStepTextFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                }
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
                        if index > 0 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .font(.system(size: config.detailArrowSize))
                                .padding(.horizontal, 2)
                                .padding(.top, config.detailStepImageSize / 2 - (config.detailArrowSize / 2))
                        }
                        
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
                            
                            if index < binSteps.count {
                                VStack(spacing: 2) {
                                    Image(binSteps[index].imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                                    Text(binSteps[index].text)
                                        .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)  // ✅ แก้: บังคับ HStack ขยายเต็มความกว้าง
                .padding(.horizontal, config.isIPad ? config.detailContentPaddingH : 10)
            }
            .frame(maxWidth: .infinity)      // ✅ แก้: บังคับ VStack ขยายเต็มความกว้าง
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

// MARK: - ขวดพลาสติก (Custom Layout Component)
struct RecycleWasteDetailPlasticBottle: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    
    private let recyclingMethods: [String] = [
        "ทำเป็นกระถางปลูกต้นไม้เล็กๆ",
        "ตัดครึ่งขวดทำเป็นที่ใส่เครื่องเขียน",
        "นำไปหลอมเป็นเส้นใยพลาสติก"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // ชื่อขยะและวันที่
            HStack(spacing: 12) {
                Text("ขวดพลาสติก")
                    .font(.noto(config.titleFontSize, weight: .bold))
                if showDate {
                    Text(Date().formatted(date: .numeric, time: .shortened))
                        .font(.noto(config.detailStepTextFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                }
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
                    // ขั้นตอน 1
                    VStack(spacing: 0) {
                        Image("DetailRecycle1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: config.detailStepImageSize, height: config.detailStepImageSize)
                            .padding(.bottom, 10)
                        Text("เทน้ำให้หมด")
                            .font(.noto(config.detailStepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 45, alignment: .top)
                        Spacer().frame(height: 8)
                        VStack(spacing: 2) {
                            Image("bin-icon1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                            Text("ถังขยะเปียก")
                                .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // ลูกศร 1
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: config.detailArrowSize))
                        .padding(.horizontal, 2)
                        .padding(.top, config.detailStepImageSize / 2 - (config.detailArrowSize / 2))
                    
                    // ขั้นตอน 2
                    VStack(spacing: 0) {
                        Image("DetailRecycle2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: config.detailStepImageSize, height: config.detailStepImageSize)
                            .padding(.bottom, 10)
                        Text("แยกฝาและฉลาก")
                            .font(.noto(config.detailStepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 45, alignment: .top)
                        Spacer().frame(height: 8)
                        HStack(spacing: 5) {
                            VStack(spacing: 2) {
                                Image("bin-icon3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                                Text("ถังขยะรีไซเคิล")
                                    .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                            VStack(spacing: 2) {
                                Image("bin-icon2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                                Text("ถังขยะทั่วไป")
                                    .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // ลูกศร 2
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: config.detailArrowSize))
                        .padding(.horizontal, 2)
                        .padding(.top, config.detailStepImageSize / 2 - (config.detailArrowSize / 2))
                    
                    // ขั้นตอน 3
                    VStack(spacing: 0) {
                        Image("DetailRecycle3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: config.detailStepImageSize, height: config.detailStepImageSize)
                            .padding(.bottom, 10)
                        Text("บีบขวดให้แบน")
                            .font(.noto(config.detailStepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 45, alignment: .top)
                        Spacer().frame(height: 8)
                        VStack(spacing: 2) {
                            Image("bin-icon3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                            Text("ถังขยะรีไซเคิล")
                                .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)  // ✅ แก้: บังคับ HStack ขยายเต็มความกว้าง
                .padding(.horizontal, config.isIPad ? config.detailContentPaddingH : 5)
            }
            .frame(maxWidth: .infinity)      // ✅ แก้: บังคับ VStack ขยายเต็มความกว้าง
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
        )
    }
}

// MARK: - แก้วพลาสติก
struct RecycleWasteDetailPlasticCup: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: "แก้วพลาสติก",
            separationSteps: [
                WasteSeparationStep(imageName: "step_plastic_cup_1", text: "เทน้ำให้หมด"),
                WasteSeparationStep(imageName: "step_plastic_cup_2", text: "ล้างแก้วเล็กน้อย"),
                WasteSeparationStep(imageName: "step_plastic_cup_3", text: "บีบหรือซ้อนแก้ว")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล")
            ],
            recyclingMethods: [
                "ทำเป็นกระถางปลูกต้นไม้เล็กๆ",
                "ทำเป็นที่ใส่เครื่องเขียน",
                "ใช้เป็นที่เพาะต้นอ่อน"
            ],
            showDate: showDate
        )
    }
}

// MARK: - กระป๋อง
struct RecycleWasteDetailCan: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: "กระป๋อง",
            separationSteps: [
                WasteSeparationStep(imageName: "step_can_1", text: "เทน้ำให้หมด"),
                WasteSeparationStep(imageName: "step_can_2", text: "ล้างกระป๋อง"),
                WasteSeparationStep(imageName: "step_can_3", text: "บีบให้แบน")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล")
            ],
            recyclingMethods: [
                "ทำเป็นที่ใส่เครื่องเขียน",
                "ทำเป็นกระถางปลูกต้นไม้เล็กๆ",
                "ประดิษฐ์เป็นโคมไฟตกแต่ง",
                "ทำเป็นโมบายหรือกระดิ่งลมแขวน"
            ],
            showDate: showDate
        )
    }
}

// MARK: - กล่องกระดาษ
struct RecycleWasteDetailCardboardBox: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: "กล่องกระดาษ",
            separationSteps: [
                WasteSeparationStep(imageName: "step_cardboard_1", text: "แกะเทปและฉลาก"),
                WasteSeparationStep(imageName: "step_cardboard_2", text: "พับกล่องให้แบน")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
            ],
            recyclingMethods: [
                "ใช้ทำเป็นงานประดิษฐ์",
                "ทำกล่องจัดระเบียบและเก็บของ",
                "ตัดเป็นแผ่นรองพัสดุหรือกันกระแทก"
            ],
            showDate: showDate
        )
    }
}

// MARK: - กระดาษทั่วไป
struct RecycleWasteDetailPaper: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: "กระดาษทั่วไป",
            separationSteps: [
                WasteSeparationStep(imageName: "step_paper_1", text: "แยกกระดาษแห้ง"),
                WasteSeparationStep(imageName: "step_paper_2", text: "พับหรือมัดรวมกัน"),
                WasteSeparationStep(imageName: "step_paper_3", text: "กระดาษเปียก")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
            ],
            recyclingMethods: [
                "ใช้ซ้ำเป็นกระดาษโน้ต",
                "ทำเป็นงานประดิษฐ์หรือของเล่น",
                "ใช้ห่อกันกระแทก"
            ],
            showDate: showDate
        )
    }
}

// MARK: - ถุงพลาสติก
struct RecycleWasteDetailPlasticBag: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: "ถุงพลาสติก",
            separationSteps: [
                WasteSeparationStep(imageName: "step_plastic_bag_1", text: "เขย่าเศษ\nอาหารออก"),
                WasteSeparationStep(imageName: "step_plastic_bag_2", text: "ถุงสะอาด\nล้าง-ทำให้แห้ง-พับ"),
                WasteSeparationStep(imageName: "step_plastic_bag_3", text: "ถุงสกปรก"),
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon3", text: "ถังขยะรีไซเคิล"),
                WasteBinStep(imageName: "bin-icon2", text: "ถังขยะทั่วไป"),
            ],
            recyclingMethods: [
                "นำกลับมาใช้ซ้ำ",
                "ใช้เป็นถุงใส่ขยะ",
                "ถักเป็นพรมหรือกระเป๋า"
            ],
            showDate: showDate
        )
    }
}

#Preview {
    GeometryReader { geo in
        let config = ResponsiveConfig(horizontalSizeClass: .compact, geo: geo)
        ScrollView {
            RecycleWasteDetailPlasticBottle(config: config)
            RecycleWasteDetailPlasticCup(config: config)
            RecycleWasteDetailCan(config: config)
            RecycleWasteDetailCardboardBox(config: config)
            RecycleWasteDetailPaper(config: config)
            RecycleWasteDetailPlasticBag(config: config)
        }
    }
}
