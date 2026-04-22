//
//  WasteDetailContentView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct WasteDetailContentView: View {
    let category: String
    let config: ResponsiveConfig
    var showDate: Bool = false

    var body: some View {
        switch category {
        case "ขวดพลาสติก":      RecycleWasteDetailPlasticBottle(config: config, showDate: showDate)
        case "แก้วพลาสติก":      RecycleWasteDetailPlasticCup(config: config, showDate: showDate)
        case "กระป๋อง":          RecycleWasteDetailCan(config: config, showDate: showDate)
        case "กล่องกระดาษ":      RecycleWasteDetailCardboardBox(config: config, showDate: showDate)
        case "กระดาษทั่วไป":     RecycleWasteDetailPaper(config: config, showDate: showDate)
        case "ถุงพลาสติก":       RecycleWasteDetailPlasticBag(config: config, showDate: showDate)
        case "เศษอาหาร":         WetWasteDetailFoodscraps(config: config, showDate: showDate)
        case "เปลือกผลไม้":      WetWasteDetailFruitPeel(config: config, showDate: showDate)
        case "เศษขนม":           WetWasteDetailCrumbs(config: config, showDate: showDate)
        case "เปลือกไข่":        WetWasteDetailEggshell(config: config, showDate: showDate)
        case "เครื่องดื่มเหลือ": WetWasteDetailLeftoverDrinks(config: config, showDate: showDate)
        case "น้ำแข็งเหลือ":     WetWasteDetailLeftoverIce(config: config, showDate: showDate)
        case "ซองขนม":           GeneralWasteDetailSnackBag(config: config, showDate: showDate)
        case "ภาชนะใส่อาหาร":    GeneralWasteDetailFoodContainer(config: config, showDate: showDate)
        case "หลอด":             GeneralWasteDetailStraw(config: config, showDate: showDate)
        case "กระดาษทิชชู่":     GeneralWasteDetailTissue(config: config, showDate: showDate)
        case "ตะเกียบไม้":       GeneralWasteDetailChopsticks(config: config, showDate: showDate)
        case "ช้อน-ส้อมพลาสติก": GeneralWasteDetailSpoon(config: config, showDate: showDate)
        default:
            Text("ไม่พบข้อมูลประเภทขยะนี้")
                .font(.noto(config.fontSubHeader, weight: .medium))
                .foregroundColor(.gray)
                .padding()
        }
    }
}
