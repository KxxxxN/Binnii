//
//  GeneralWasteDetailContent.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 16/3/2569 BE.
//

import SwiftUI

private func formatCurrentDate() -> String {
    let f = DateFormatter()
    f.dateFormat = "d/M/yyyy - HH:mm"
    f.locale     = Locale(identifier: "en_US_POSIX")
    f.calendar   = Calendar(identifier: .buddhist)
    return f.string(from: Date())
}

struct GeneralWasteDetailContent: View {
    let config: ResponsiveConfig

    let category: String
    var wasteDetail: String? = nil
    let separationSteps: [WasteSeparationStep]
    let binSteps: [WasteBinStep]
    let recyclingMethods: [String]
    var showDate: Bool = false
    var dateString: String? = nil

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
                    .padding(.horizontal, config.detailContentPaddingH)
            }

            HStack(spacing: 13) {
                Image("Bin2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: config.detailMainBinHeight)

                VStack(alignment: .leading, spacing: 4) {
                    Text(L("ประเภทถังขยะ"))
                        .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                        .foregroundColor(.black)
                    HStack(spacing: 0) {
                        Text(L("ถังขยะทั่วไป") + " ")
                            .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                            .foregroundColor(.black)
                        Text(L("(สีน้ำเงิน)"))
                            .font(.noto(config.isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.generalWasteColor)
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
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, config.isIPad ? 20 : 10)
            }
            .padding(.top, 30)

            VStack(alignment: .leading, spacing: 10) {
                Text(L("การรีไซเคิล"))
                    .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                    .foregroundColor(.black)
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(recyclingMethods, id: \.self) { method in
                        Text("•   \(method)")
                            .font(.noto(config.detailBodyFontSize, weight: .medium))
                            .foregroundColor(.black)
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

// MARK: - ซองขนม
struct GeneralWasteDetailSnackBag: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        GeneralWasteDetailContent(
            config: config,
            category: lm.localized("ซองขนม"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_snackbag_1", text: lm.localized("เทเศษขนมออก")),
                WasteSeparationStep(imageName: "step_snackbag_2", text: lm.localized("พับหรือม้วนให้เล็กลง"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("ทำซองใส่ของชิ้นเล็ก"),
                lm.localized("นำมาสานเป็นกระเป๋า"),
                lm.localized("ประดิษฐ์เป็นของตกแต่ง")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - ภาชนะใส่อาหาร
struct GeneralWasteDetailFoodContainer: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        GeneralWasteDetailContent(
            config: config,
            category: lm.localized("ภาชนะใส่อาหาร"),
            wasteDetail: lm.localized("เช่น กล่องพลาสติก ถ้วยพลาสติก"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_container_1", text: lm.localized("เทเศษอาหารออก")),
                WasteSeparationStep(imageName: "step_container_2", text: lm.localized("ซับคราบมัน"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("ใช้เป็นกล่องเก็บของชิ้นเล็ก"),
                lm.localized("ใช้เป็นที่เพาะต้นอ่อน"),
                lm.localized("ทำเป็นที่ใส่อุปกรณ์งานฝีมือ")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - หลอด
struct GeneralWasteDetailStraw: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        GeneralWasteDetailContent(
            config: config,
            category: lm.localized("หลอด"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_straw_1", text: lm.localized("เขย่าน้ำออกจากหลอด")),
                WasteSeparationStep(imageName: "step_straw_2", text: lm.localized("ทิ้งลงถังขยะทั่วไป"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("นำไปร้อยทำโมบายตกแต่ง"),
                lm.localized("ทำเป็นงานประดิษฐ์หรือของเล่น")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - กระดาษทิชชู่
struct GeneralWasteDetailTissue: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        GeneralWasteDetailContent(
            config: config,
            category: lm.localized("กระดาษทิชชู่"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_tissue_1", text: lm.localized("พับให้เล็กลง")),
                WasteSeparationStep(imageName: "step_tissue_2", text: lm.localized("ทิ้งลงถังขยะทั่วไป"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("ใช้เช็ดทำความสะอาดซ้ำ"),
                lm.localized("ใช้รองของเปียก"),
                lm.localized("ใช้ห่อของแตกง่าย")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - ตะเกียบไม้
struct GeneralWasteDetailChopsticks: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        GeneralWasteDetailContent(
            config: config,
            category: lm.localized("ตะเกียบไม้"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_chopstick_1", text: lm.localized("เช็ดคราบอาหารออก")),
                WasteSeparationStep(imageName: "step_chopstick_2", text: lm.localized("หักให้สั้นลง"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("ใช้ทำงานประดิษฐ์"),
                lm.localized("นำไปทำเป็นไม้ค้ำต้นไม้เล็ก ๆ"),
                lm.localized("นำไปทำป้ายชื่อกระถางต้นไม้")
            ],
            showDate: showDate,
            dateString: dateString
        )
    }
}

// MARK: - ช้อน-ส้อมพลาสติก
struct GeneralWasteDetailSpoon: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        GeneralWasteDetailContent(
            config: config,
            category: lm.localized("ช้อน-ส้อม พลาสติก"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_spoon_1", text: lm.localized("เช็ดคราบอาหารออก")),
                WasteSeparationStep(imageName: "step_spoon_2", text: lm.localized("ทิ้งลงถังขยะทั่วไป"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("นำไปทำป้ายชื่อกระถางต้นไม้"),
                lm.localized("ใช้ทำงานประดิษฐ์ตกแต่ง"),
                lm.localized("ทำเป็นที่แขวนของเล็ก ๆ")
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
            GeneralWasteDetailSnackBag(config: config)
            GeneralWasteDetailFoodContainer(config: config)
            GeneralWasteDetailStraw(config: config)
            GeneralWasteDetailTissue(config: config)
            GeneralWasteDetailChopsticks(config: config)
            GeneralWasteDetailSpoon(config: config)
        }
    }
}
