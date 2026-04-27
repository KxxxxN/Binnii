//
//  WasteDetailContentView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

import SwiftUI

struct WasteDetailContentView: View {
    let category: String      // รับได้ทั้ง TH และ EN
    let config: ResponsiveConfig
    var showDate: Bool = false
    var dateString: String? = nil

    // ✅ normalize ให้เป็น Thai canonical key ก่อน switch เสมอ
    private var key: String { WasteImageMapper.canonicalKey(for: category) }

    var body: some View {
        switch key {
        case "ขวดพลาสติก":       RecycleWasteDetailPlasticBottle(config: config, showDate: showDate, dateString: dateString)
        case "แก้วพลาสติก":       RecycleWasteDetailPlasticCup(config: config, showDate: showDate, dateString: dateString)
        case "กระป๋อง":           RecycleWasteDetailCan(config: config, showDate: showDate, dateString: dateString)
        case "กล่องกระดาษ":       RecycleWasteDetailCardboardBox(config: config, showDate: showDate, dateString: dateString)
        case "กระดาษทั่วไป":      RecycleWasteDetailPaper(config: config, showDate: showDate, dateString: dateString)
        case "ถุงพลาสติก":        RecycleWasteDetailPlasticBag(config: config, showDate: showDate, dateString: dateString)
        case "เศษอาหาร":          WetWasteDetailFoodscraps(config: config, showDate: showDate, dateString: dateString)
        case "เปลือกผลไม้":       WetWasteDetailFruitPeel(config: config, showDate: showDate, dateString: dateString)
        case "เศษขนม":            WetWasteDetailCrumbs(config: config, showDate: showDate, dateString: dateString)
        case "เปลือกไข่":         WetWasteDetailEggshell(config: config, showDate: showDate, dateString: dateString)
        case "เครื่องดื่มเหลือ":  WetWasteDetailLeftoverDrinks(config: config, showDate: showDate, dateString: dateString)
        case "น้ำแข็งเหลือ":      WetWasteDetailLeftoverIce(config: config, showDate: showDate, dateString: dateString)
        case "ซองขนม":            GeneralWasteDetailSnackBag(config: config, showDate: showDate, dateString: dateString)
        case "ภาชนะใส่อาหาร":     GeneralWasteDetailFoodContainer(config: config, showDate: showDate, dateString: dateString)
        case "หลอด":              GeneralWasteDetailStraw(config: config, showDate: showDate, dateString: dateString)
        case "กระดาษทิชชู่":      GeneralWasteDetailTissue(config: config, showDate: showDate, dateString: dateString)
        case "ตะเกียบไม้":        GeneralWasteDetailChopsticks(config: config, showDate: showDate, dateString: dateString)
        case "ช้อน-ส้อม พลาสติก": GeneralWasteDetailSpoon(config: config, showDate: showDate, dateString: dateString)
        default:
            Text("ไม่พบข้อมูลประเภทขยะนี้")
                .font(.noto(config.fontSubHeader, weight: .medium))
                .foregroundColor(.gray)
                .padding()
        }
    }
}
