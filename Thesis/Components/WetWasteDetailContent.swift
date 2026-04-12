//
//  WetWasteDetailContent.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/3/2569 BE.
//

import SwiftUI

// MARK: - Shared Component
struct WetWasteDetailContent: View {
    let config: ResponsiveConfig
    
    let category: String
    var wasteDetail: String? = nil
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
                    .foregroundColor(.black)
                
                if showDate {
                    Text(Date().formatted(date: .numeric, time: .shortened))
                        .font(.noto(config.detailStepTextFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, config.isIPad ? 12 : 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, config.detailContentPaddingH)
            
            // รายละเอียดตัวอย่างขยะ
            if let wasteDetail = wasteDetail {
                Text(wasteDetail)
                    .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true) // ✅ ป้องกันข้อความโดนตัด
                    .frame(maxWidth: .infinity, alignment: .leading) // ✅ บังคับไม่ให้ดันขอบจอ
                    .padding(.horizontal, config.detailContentPaddingH)
            }
            
            // ประเภทถังขยะ
            HStack(spacing: 13) {
                Image("Bin1")
                    .resizable()
                    .scaledToFit()
                    // ✅ แก้อาการรูปกว้างเกินด้วยการคุมทั้งความกว้างและความสูง
                    .frame(width: config.detailMainBinHeight, height: config.detailMainBinHeight)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ประเภทถังขยะ")
                        .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                    HStack(spacing: 0) {
                        Text("ถังขยะเปียก ")
                            .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                        Text("(สีเขียว)")
                            .font(.noto(config.isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.wetWasteColor)
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
                                        // ✅ ป้องกันข้อความถังขยะดันขอบ
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        // ✅ เพิ่ม minWidth: 0 เพื่อให้การ์ดยอมบีบตัวลงตามขนาดจอไอโฟน ไม่ดันไปทางขวา
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, config.isIPad ? 20 : 10)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
            
            // การรีไซเคิล
            VStack(alignment: .leading, spacing: 10) {
                Text("การรีไซเคิล")
                    .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(recyclingMethods, id: \.self) { method in
                        Text("•   \(method)")
                            .font(.noto(config.detailBodyFontSize, weight: .medium))
                            .fixedSize(horizontal: false, vertical: true) // ✅ ให้คำยาวๆ ยอมขึ้นบรรทัดใหม่
                            .frame(maxWidth: .infinity, alignment: .leading) // ✅ บังคับไม่ให้กว้างเกินจอ
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


// MARK: - เศษอาหาร
struct WetWasteDetailFoodscraps: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: "เศษอาหาร",
            wasteDetail: "เช่น ข้าว เศษผัก เศษเนื้อ ก้างปลา กระดูกไก่",
            separationSteps: [
                WasteSeparationStep(imageName: "step_food_1", text: "เทเศษอาหาร \nออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_food_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "ทำปุ๋ยหมักจากเศษอาหาร",
                "นำไปหมักเป็นปุ๋ยน้ำสำหรับต้นไม้",
                "ใช้เป็นอาหารปลา \n    (เฉพาะเศษผัก ผลไม้ และเศษอาหารชิ้นเล็กๆ)"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เปลือกผลไม้
struct WetWasteDetailFruitPeel: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: "เปลือกผลไม้",
            separationSteps: [
                WasteSeparationStep(imageName: "step_fruit_1", text: "แยกออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_fruit_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "ตากแห้งทำปุ๋ยหมัก",
                "ทำปุ๋ยน้ำหมักชีวภาพ",
                "ใช้เป็นน้ำหมักไล่แมลงอ่อน ๆ"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เศษขนม
struct WetWasteDetailCrumbs: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: "เศษขนม",
            wasteDetail: "เช่น ขนมขบเคี้ยว คุกกี้ ขนมปัง เค้ก",
            separationSteps: [
                WasteSeparationStep(imageName: "step_snack_1", text: "เทเศษขนมออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_snack_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "นำไปทำปุ๋ยหมัก",
                "นำไปหมักเป็นปุ๋ยน้ำสำหรับต้นไม้",
                "ใช้เลี้ยงสัตว์เล็กบางชนิด \n    (เฉพาะเศษขนมที่เหมาะสม)"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เปลือกไข่
struct WetWasteDetailEggshell: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: "เปลือกไข่",
            separationSteps: [
                WasteSeparationStep(imageName: "step_eggshell_1", text: "แยกออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_eggshell_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "บดผสมดินเพิ่มแคลเซียมให้ต้นไม้",
                "ใส่กระถางช่วยบำรุงดิน",
                "นำไปใช้เป็นปุ๋ยธรรมชาติ"
            ],
            showDate: showDate
        )
    }
}

// MARK: - เครื่องดื่มเหลือ
struct WetWasteDetailLeftoverDrinks: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: "เครื่องดื่มเหลือ",
            separationSteps: [
                WasteSeparationStep(imageName: "step_drink_1", text: "เทเครื่องดื่มออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_drink_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "นำไปหมักเป็นปุ๋ยน้ำหมัก",
                "นำไปเจือจางแล้วใช้รดต้นไม้ \n    (เฉพาะเครื่องดื่มที่ไม่หวานจัด ไม่เค็ม และไม่มีก๊าซ)"
            ],
            showDate: showDate
        )
    }
}

// MARK: - น้ำแข็งเหลือ
struct WetWasteDetailLeftoverIce: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: "น้ำแข็งเหลือ",
            separationSteps: [
                WasteSeparationStep(imageName: "step_ice_1", text: "เทน้ำแข็งออกจากภาชนะ"),
                WasteSeparationStep(imageName: "step_ice_2", text: "เก็บภาชนะไว้แยกต่อ")
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: "ถังขยะเปียก"),
                WasteBinStep(imageName: "bin-icon-no", text: "ถังขยะเปียก")
            ],
            recyclingMethods: [
                "นำมาใช้รดน้ำต้นไม้",
                "เทลงอ่างเพื่อล้างทำความสะอาด"
            ],
            showDate: showDate
        )
    }
}

#Preview {
    GeometryReader { geo in
        let config = ResponsiveConfig(horizontalSizeClass: .compact, geo: geo)
        
        ScrollView {
            WetWasteDetailFoodscraps(config: config)
            WetWasteDetailFruitPeel(config: config)
            WetWasteDetailEggshell(config: config)
            WetWasteDetailCrumbs(config: config)
            WetWasteDetailLeftoverDrinks(config: config)
            WetWasteDetailLeftoverIce(config: config)
        }
    }
}
