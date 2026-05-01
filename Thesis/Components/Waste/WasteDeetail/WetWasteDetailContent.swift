//
//  WetWasteDetailContent.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/3/2569 BE.
//

import SwiftUI

private func formatCurrentDate() -> String {
    let f = DateFormatter()
    f.dateFormat = "d/M/yyyy - HH:mm"
    f.locale     = Locale(identifier: "en_US_POSIX")
    f.calendar   = Calendar(identifier: .buddhist)
    return f.string(from: Date())
}

// MARK: - Shared Component
struct WetWasteDetailContent: View {
    let config: ResponsiveConfig

    let category: String
    var wasteDetail: String? = nil
    let separationSteps: [WasteSeparationStep]
    let binSteps: [WasteBinStep]
    let recyclingMethods: [String]
    var showDate: Bool = false
    var dateString: String? = nil

    // ✅ observe ภาษา
    @ObservedObject private var lm = LanguageManager.shared

    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(spacing: 12) {
                Text(category)
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.black)

                if showDate {
                    Text(dateString ?? formatCurrentDate())
                        .font(.noto(config.detailStepTextFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, config.isIPad ? 12 : 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, config.detailContentPaddingH)

            if let wasteDetail {
                Text(wasteDetail)
                    .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, config.detailContentPaddingH)
            }

            HStack(spacing: 13) {
                Image("Bin1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.detailMainBinHeight, height: config.detailMainBinHeight)

                VStack(alignment: .leading, spacing: 4) {
                    Text(L("ประเภทถังขยะ"))
                        .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                    HStack(spacing: 0) {
                        Text(L("ถังขยะเปียก") + " ")
                            .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                        Text(L("(สีเขียว)"))
                            .font(.noto(config.isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.wetWasteColor)
                    }
                }
            }
            .padding(.top, 25)
            .padding(.horizontal, config.detailContentPaddingH)

            VStack(alignment: .leading, spacing: 10) {
                Text(L("วิธีการแยกขยะ"))
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
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, config.isIPad ? 20 : 10)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)

            VStack(alignment: .leading, spacing: 10) {
                Text(L("การรีไซเคิล"))
                    .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(recyclingMethods, id: \.self) { method in
                        Text("•   \(method)")
                            .font(.noto(config.detailBodyFontSize, weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: lm.localized("เศษอาหาร"),
            wasteDetail: lm.localized("เช่น ข้าว เศษผัก เศษเนื้อ ก้างปลา กระดูกไก่"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_food_1", text: lm.localized("เทเศษอาหารออกจากภาชนะ")),
                WasteSeparationStep(imageName: "step_food_2", text: lm.localized("เก็บภาชนะไว้แยกต่อ"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon-no", text: lm.localized("ถังขยะเปียก"))
            ],
            recyclingMethods: [
                lm.localized("ทำปุ๋ยหมักจากเศษอาหาร"),
                lm.localized("นำไปหมักเป็นปุ๋ยน้ำสำหรับต้นไม้"),
                lm.localized("ใช้เป็นอาหารปลา (เฉพาะเศษผัก ผลไม้ และเศษอาหารชิ้นเล็กๆ)")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - เปลือกผลไม้
struct WetWasteDetailFruitPeel: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: lm.localized("เปลือกผลไม้"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_fruit_1", text: lm.localized("แยกออกจากภาชนะ")),
                WasteSeparationStep(imageName: "step_fruit_2", text: lm.localized("เก็บภาชนะไว้แยกต่อ"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon-no", text: lm.localized("ถังขยะเปียก"))
            ],
            recyclingMethods: [
                lm.localized("ตากแห้งทำปุ๋ยหมัก"),
                lm.localized("ทำปุ๋ยน้ำหมักชีวภาพ"),
                lm.localized("ใช้เป็นน้ำหมักไล่แมลงอ่อน ๆ")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - เศษขนม
struct WetWasteDetailCrumbs: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: lm.localized("เศษขนม"),
            wasteDetail: lm.localized("เช่น ขนมขบเคี้ยว คุกกี้ ขนมปัง เค้ก"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_snack_1", text: lm.localized("เทเศษขนมออกจากภาชนะ")),
                WasteSeparationStep(imageName: "step_snack_2", text: lm.localized("เก็บภาชนะไว้แยกต่อ"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon-no", text: lm.localized("ถังขยะเปียก"))
            ],
            recyclingMethods: [
                lm.localized("นำไปทำปุ๋ยหมัก"),
                lm.localized("นำไปหมักเป็นปุ๋ยน้ำสำหรับต้นไม้"),
                lm.localized("ใช้เลี้ยงสัตว์เล็กบางชนิด (เฉพาะเศษขนมที่เหมาะสม)")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - เปลือกไข่
struct WetWasteDetailEggshell: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: lm.localized("เปลือกไข่"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_eggshell_1", text: lm.localized("แยกออกจากภาชนะ")),
                WasteSeparationStep(imageName: "step_eggshell_2", text: lm.localized("เก็บภาชนะไว้แยกต่อ"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon-no", text: lm.localized("ถังขยะเปียก"))
            ],
            recyclingMethods: [
                lm.localized("บดผสมดินเพิ่มแคลเซียมให้ต้นไม้"),
                lm.localized("ใส่กระถางช่วยบำรุงดิน"),
                lm.localized("นำไปใช้เป็นปุ๋ยธรรมชาติ")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - เครื่องดื่มเหลือ
struct WetWasteDetailLeftoverDrinks: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: lm.localized("เครื่องดื่มเหลือ"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_drink_1", text: lm.localized("เทเครื่องดื่มออกจากภาชนะ")),
                WasteSeparationStep(imageName: "step_drink_2", text: lm.localized("เก็บภาชนะไว้แยกต่อ"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon-no", text: lm.localized("ถังขยะเปียก"))
            ],
            recyclingMethods: [
                lm.localized("นำไปหมักเป็นปุ๋ยน้ำหมัก"),
                lm.localized("นำไปเจือจางแล้วใช้รดต้นไม้     (เฉพาะเครื่องดื่มที่ไม่หวานจัด ไม่เค็ม และไม่มีก๊าซ)")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - น้ำแข็งเหลือ
struct WetWasteDetailLeftoverIce: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        WetWasteDetailContent(
            config: config,
            category: lm.localized("น้ำแข็งเหลือ"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_ice_1", text: lm.localized("เทน้ำแข็งออกจากภาชนะ")),
                WasteSeparationStep(imageName: "step_ice_2", text: lm.localized("เก็บภาชนะไว้แยกต่อ"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon-no", text: lm.localized("ถังขยะเปียก"))
            ],
            recyclingMethods: [
                lm.localized("นำมาใช้รดน้ำต้นไม้"),
                lm.localized("เทลงอ่างเพื่อล้างทำความสะอาด")
            ],
            showDate: showDate,
            dateString: dateString
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
