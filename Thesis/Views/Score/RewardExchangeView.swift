//
//  RewardExchangeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct RewardExchangeView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool

    let pointsData: [(label: String, value: String, isBold: Bool)] = [
        ("คะแนนทั้งหมด :", "333", false),
        ("ต้องการแลกคะแนน :", "300", true),
        ("คะแนนคงเหลือ :", "33", false)
    ]

    let conditionsList = [
        "ผู้ใช้จะได้รับ คะแนนจากการแยกขยะถูกประเภทผ่านระบบสแกนขยะ",
        "คะแนนสามารถใช้ แลกเป็นชั่วโมงจิตอาสาของมหาวิทยาลัย",
        "ระบบจะตรวจสอบข้อมูลการแยกขยะจากบัญชีผู้ใช้ก่อนยืนยันชั่วโมง",
        "ชั่วโมงจิตอาสาที่แลกแล้ว ไม่สามารถยกเลิกหรือโอนให้ผู้อื่นได้",
        "เฉพาะนักศึกษาของมหาวิทยาลัยเท่านั้นที่สามารถแลกได้",
        "การโกงระบบหรือส่งข้อมูลเท็จ จะถูกตัดสิทธิ์ทันที",
        "มหาวิทยาลัยขอสงวนสิทธิ์ในการเปลี่ยนแปลงเงื่อนไขโดยไม่ต้องแจ้งล่วงหน้า"
    ]

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)

            VStack(spacing: 0) {

                // MARK: - Top Bar
                ZStack {
                    Color.mainColor

                    HStack {
                        XBackButtonWhite()

                        Spacer()

                        Text("แลกคะแนน")
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        Color.clear.frame(width: config.headerIconSize,
                                          height: config.headerIconSize)
                    }
                    .padding(.top, config.headerTopPadding)
                    .padding(.trailing, config.paddingMedium)
                    .padding(.bottom, config.paddingMedium)
                }
                .frame(maxWidth: .infinity)
                .frame(height: config.searchHeaderHeight)
                .clipShape(RoundedCorner(radius: config.bannerCornerRadius,
                                         corners: [.bottomLeft, .bottomRight]))

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        PointsSummaryCard(pointsData: pointsData, config: config)
                            .padding(.top, config.rewardScrollTopPadding)

                        ConditionsAndExchangeSection(conditionsList: conditionsList, config: config)
                    }
                    .padding(.horizontal, config.paddingMedium)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear { hideTabBar = true }
            .onDisappear { hideTabBar = false }
        }
    }
}

// MARK: - PointsSummaryCard
struct PointsSummaryCard: View {
    let pointsData: [(label: String, value: String, isBold: Bool)]
    let config: ResponsiveConfig

    var body: some View {
        VStack(spacing: -10) {
            ForEach(pointsData.indices, id: \.self) { index in
                HStack {
                    Text(pointsData[index].label)
                        .font(.noto(config.fontBody, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.bottom, config.paddingMedium)

                    Spacer()

                    Text(pointsData[index].value)
                        .font(.noto(
                            pointsData[index].isBold ? config.fontHeader : config.fontSubHeader,
                            weight: pointsData[index].isBold ? .bold : .medium
                        ))
                        .foregroundColor(.black)
                        .padding(.bottom, config.paddingMedium)
                }
            }
        }
        .padding(.top, config.paddingMedium)
        .padding(.horizontal, config.paddingStandard)
        .frame(maxWidth: .infinity)
        .frame(height: config.pointsCardHeight)
        .background(Color.wasteCard)
        .cornerRadius(config.bannerCornerRadius)
        .frame(maxWidth: config.mainContentMaxWidth)
    }
}

// MARK: - ConditionsAndExchangeSection
struct ConditionsAndExchangeSection: View {
    let conditionsList: [String]
    let config: ResponsiveConfig

    var body: some View {
        VStack(spacing: 0) {

            Text("แลกรับชั่วโมงจิตอาสา 1 ชั่วโมง")
                .font(.noto(config.fontHeader, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, config.conditionsTitlePaddingH)
                .padding(.vertical, config.conditionsTitlePaddingV)

            // ส่วนของกรอบเงื่อนไข
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 5) {
                    Text("รายละเอียด และเงื่อนไข")
                        .font(.noto(config.fontBody, weight: .bold))
                        .foregroundColor(.black)
                    Text("(จำลอง)")
                        .font(.noto(config.fontBody, weight: .bold))
                        .foregroundColor(.placeholderColor)
                }
                .padding(.bottom, config.spacingMedium)

                VStack(alignment: .leading, spacing: config.rewardVStackSpacing) {
                    ForEach(conditionsList.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: config.isIPad ? 15 : 10) {
                            Text("\(index + 1).")
                                .font(.noto(config.fontBody, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: config.isIPad ? 40 : 25, alignment: .leading)
                            
                            Text(conditionsList[index])
                                .font(.noto(config.fontBody, weight: .medium))
                                .foregroundColor(.black)
                                .lineSpacing(config.isIPad ? 8 : 4) // ระยะบรรทัดกว้างขึ้นใน iPad
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(config.paddingStandard)
            .background(Color.wasteCard)
            .cornerRadius(config.bannerCornerRadius)
            .frame(maxWidth: config.mainContentMaxWidth)

            // ปุ่มยืนยัน
            Button(action: { /* Action */ }) {
                Text("ยืนยันแลกคะแนน")
                    .font(.noto(config.fontSubHeader, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: config.searchButtonHeight)
                    .background(Color.mainColor)
                    .cornerRadius(config.bannerCornerRadius)
            }
            .frame(maxWidth: config.mainContentMaxWidth)
            .padding(.top, config.paddingStandard)
            .padding(.bottom, config.paddingStandard * 2)
        }
        .frame(maxWidth: .infinity)
    }
}
