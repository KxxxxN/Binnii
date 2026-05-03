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

private func formatCurrentDate() -> String {
    let f = DateFormatter()
    f.dateFormat = "d/M/yyyy - HH:mm"
    f.locale     = Locale(identifier: "en_US_POSIX")
    f.calendar   = Calendar(identifier: .buddhist)
    return f.string(from: Date())
}

// MARK: - Shared Component
struct RecycleWasteDetailContent: View {
    let config: ResponsiveConfig
    let category: String
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
                        .padding(.top, 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, config.detailContentPaddingH)

            HStack(spacing: 13) {
                Image("Bin3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: config.detailMainBinHeight)

                VStack(alignment: .leading, spacing: 4) {
                    Text(L("ประเภทถังขยะ"))
                        .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                        .foregroundColor(.black)
                    HStack(spacing: 0) {
                        Text(L("ถังขยะรีไซเคิล") + " ")
                            .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                            .foregroundColor(.black)
                        Text(L("(สีเหลือง)"))
                            .font(.noto(config.isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.recycleWasteColor)
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
                .frame(maxWidth: .infinity)
                .padding(.horizontal, config.isIPad ? config.detailContentPaddingH : 10)
            }
            .frame(maxWidth: .infinity)
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

// MARK: - ขวดพลาสติก
struct RecycleWasteDetailPlasticBottle: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(spacing: 12) {
                Text(lm.localized("ขวดพลาสติก"))
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.black)
                if showDate {
                    Text(dateString ?? formatCurrentDate())
                        .font(.noto(config.detailStepTextFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, config.detailContentPaddingH)

            HStack(spacing: 13) {
                Image("Bin3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: config.detailMainBinHeight)
                VStack(alignment: .leading, spacing: 4) {
                    Text(lm.localized("ประเภทถังขยะ"))
                        .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                        .foregroundColor(.black)
                    HStack(spacing: 0) {
                        Text(lm.localized("ถังขยะรีไซเคิล") + " ")
                            .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                            .foregroundColor(.black)
                        Text(lm.localized("(สีเหลือง)"))
                            .font(.noto(config.isIPad ? 24 : 18, weight: .bold))
                            .foregroundColor(.recycleWasteColor)
                    }
                }
            }
            .padding(.top, 25)
            .padding(.horizontal, config.detailContentPaddingH)

            VStack(alignment: .leading, spacing: 10) {
                Text(lm.localized("วิธีการแยกขยะ"))
                    .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, config.detailContentPaddingH)

                HStack(alignment: .top, spacing: 0) {
                    // Step 1
                    VStack(spacing: 0) {
                        Image("DetailRecycle1").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: config.detailStepImageSize, height: config.detailStepImageSize)
                            .padding(.bottom, 10)
                        Text(lm.localized("เทน้ำให้หมด"))
                            .font(.noto(config.detailStepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 45, alignment: .top)
                        Spacer().frame(height: 8)
                        VStack(spacing: 2) {
                            Image("bin-icon1").resizable().scaledToFit()
                                .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                            Text(lm.localized("ถังขยะเปียก"))
                                .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }.frame(maxWidth: .infinity)

                    Image(systemName: "arrow.right").foregroundColor(.black)
                        .font(.system(size: config.detailArrowSize)).padding(.horizontal, 2)
                        .padding(.top, config.detailStepImageSize / 2 - (config.detailArrowSize / 2))

                    // Step 2
                    VStack(spacing: 0) {
                        Image("DetailRecycle2").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: config.detailStepImageSize, height: config.detailStepImageSize).padding(.bottom, 10)
                        Text(lm.localized("แยกฝาและฉลาก"))
                            .font(.noto(config.detailStepTextFontSize, weight: .medium)).foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 45, alignment: .top)
                        Spacer().frame(height: 8)
                        HStack(spacing: 5) {
                            VStack(spacing: 2) {
                                Image("bin-icon3").resizable().scaledToFit()
                                    .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                                Text(lm.localized("ถังขยะรีไซเคิล"))
                                    .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                            VStack(spacing: 2) {
                                Image("bin-icon2").resizable().scaledToFit()
                                    .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                                Text(lm.localized("ถังขยะทั่วไป"))
                                    .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Image(systemName: "arrow.right").foregroundColor(.black)
                        .font(.system(size: config.detailArrowSize)).padding(.horizontal, 2)
                        .padding(.top, config.detailStepImageSize / 2 - (config.detailArrowSize / 2))

                    // Step 3
                    VStack(spacing: 0) {
                        Image("DetailRecycle3").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: config.detailStepImageSize, height: config.detailStepImageSize)
                            .padding(.bottom, 10)
                        Text(lm.localized("บีบขวดให้แบน"))
                            .font(.noto(config.detailStepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 45, alignment: .top)
                        Spacer().frame(height: 8)
                        VStack(spacing: 2) {
                            Image("bin-icon3").resizable().scaledToFit()
                                .frame(width: config.detailBinIconSize, height: config.detailBinIconSize)
                            Text(lm.localized("ถังขยะรีไซเคิล"))
                                .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }.frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, config.isIPad ? config.detailContentPaddingH : 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)

            VStack(alignment: .leading, spacing: 10) {
                Text(lm.localized("การรีไซเคิล"))
                    .font(.noto(config.detailSectionTitleFontSize, weight: .bold))
                    .foregroundColor(.black)
                VStack(alignment: .leading, spacing: 6) {
                    ForEach([
                        lm.localized("ทำเป็นกระถางปลูกต้นไม้เล็กๆ"),
                        lm.localized("ตัดครึ่งขวดทำเป็นที่ใส่เครื่องเขียน"),
                        lm.localized("นำไปหลอมเป็นเส้นใยพลาสติก")
                    ], id: \.self) { method in
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
        .background(Color.knowledgeBackground.clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight])))
    }
}

// MARK: - แก้วพลาสติก
struct RecycleWasteDetailPlasticCup: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: lm.localized("แก้วพลาสติก"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_plastic_cup_1", text: lm.localized("เทน้ำให้หมด")),
                WasteSeparationStep(imageName: "step_plastic_cup_2", text: lm.localized("ล้างแก้วเล็กน้อย")),
                WasteSeparationStep(imageName: "step_plastic_cup_3", text: lm.localized("บีบหรือซ้อนแก้ว"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล")),
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล"))
            ],
            recyclingMethods: [
                lm.localized("ทำเป็นกระถางปลูกต้นไม้เล็กๆ"),
                lm.localized("ทำเป็นที่ใส่เครื่องเขียน"),
                lm.localized("ใช้เป็นที่เพาะต้นอ่อน")
            ],
            showDate: showDate, dateString: dateString
        )
    }
}

// MARK: - กระป๋อง
struct RecycleWasteDetailCan: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: lm.localized("กระป๋อง"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_can_1", text: lm.localized("เทน้ำให้หมด")),
                WasteSeparationStep(imageName: "step_can_2", text: lm.localized("ล้างกระป๋อง")),
                WasteSeparationStep(imageName: "step_can_3", text: lm.localized("บีบให้แบน"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล")),
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล"))
            ],
            recyclingMethods: [
                lm.localized("ทำเป็นที่ใส่เครื่องเขียน"),
                lm.localized("ทำเป็นกระถางปลูกต้นไม้เล็กๆ"),
                lm.localized("ประดิษฐ์เป็นโคมไฟตกแต่ง"),
                lm.localized("ทำเป็นโมบายหรือกระดิ่งลมแขวน")
            ],
            showDate: showDate, dateString: dateString
        )
    }
}

// MARK: - กล่องกระดาษ
struct RecycleWasteDetailCardboardBox: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: lm.localized("กล่องกระดาษ"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_cardboard_1", text: lm.localized("แกะเทปและฉลาก")),
                WasteSeparationStep(imageName: "step_cardboard_2", text: lm.localized("พับกล่องให้แบน"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป")),
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล"))
            ],
            recyclingMethods: [
                lm.localized("ใช้ทำเป็นงานประดิษฐ์"),
                lm.localized("ทำกล่องจัดระเบียบและเก็บของ"),
                lm.localized("ตัดเป็นแผ่นรองพัสดุหรือกันกระแทก")
            ],
            showDate: showDate, dateString: dateString
        )
    }
}

// MARK: - กระดาษทั่วไป
struct RecycleWasteDetailPaper: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: lm.localized("กระดาษทั่วไป"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_paper_1", text: lm.localized("แยกกระดาษแห้ง")),
                WasteSeparationStep(imageName: "step_paper_2", text: lm.localized("พับหรือมัดรวมกัน")),
                WasteSeparationStep(imageName: "step_paper_3", text: lm.localized("กระดาษเปียก"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล")),
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("ใช้ซ้ำเป็นกระดาษโน้ต"),
                lm.localized("ทำเป็นงานประดิษฐ์หรือของเล่น"),
                lm.localized("ใช้ห่อกันกระแทก")
            ],
            showDate: showDate, dateString: dateString
        )
    }
}

// MARK: - ถุงพลาสติก
struct RecycleWasteDetailPlasticBag: View {
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    var body: some View {
        RecycleWasteDetailContent(
            config: config,
            category: lm.localized("ถุงพลาสติก"),
            separationSteps: [
                WasteSeparationStep(imageName: "step_plastic_bag_1", text: lm.localized("เขย่าเศษอาหารออก")),
                WasteSeparationStep(imageName: "step_plastic_bag_2", text: lm.localized("ถุงสะอาดล้าง-ทำให้แห้ง-พับ")),
                WasteSeparationStep(imageName: "step_plastic_bag_3", text: lm.localized("ถุงสกปรก"))
            ],
            binSteps: [
                WasteBinStep(imageName: "bin-icon1", text: lm.localized("ถังขยะเปียก")),
                WasteBinStep(imageName: "bin-icon3", text: lm.localized("ถังขยะรีไซเคิล")),
                WasteBinStep(imageName: "bin-icon2", text: lm.localized("ถังขยะทั่วไป"))
            ],
            recyclingMethods: [
                lm.localized("นำกลับมาใช้ซ้ำ"),
                lm.localized("ใช้เป็นถุงใส่ขยะ"),
                lm.localized("ถักเป็นพรมหรือกระเป๋า")
            ],
            showDate: showDate, dateString: dateString
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
