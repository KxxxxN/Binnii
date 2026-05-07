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
    var dateString: String? = nil
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    private var normalizedKey: String {
        let baseKey = WasteImageMapper.canonicalKey(for: category).trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch baseKey.lowercased() {
        case "ขวดพลาสติก", "plasticbottle", "plastic bottle":
            return "ขวดพลาสติก"
        case "แก้วพลาสติก", "plastic cups", "plastic cup":
            return "แก้วพลาสติก"
        case "กระป๋อง", "can", "cans":
            return "กระป๋อง"
        case "กล่องกระดาษ", "cardboard box":
            return "กล่องกระดาษ"
        case "กระดาษทั่วไป", "general paper", "paper":
            return "กระดาษทั่วไป"
        case "ถุงพลาสติก", "plastic bag":
            return "ถุงพลาสติก"
        case "เศษอาหาร", "food waste":
            return "เศษอาหาร"
        case "เปลือกผลไม้", "fruit peel":
            return "เปลือกผลไม้"
        case "เศษขนม", "crumbs":
            return "เศษขนม"
        case "เปลือกไข่", "eggshell":
            return "เปลือกไข่"
        case "เครื่องดื่มเหลือ", "leftover drinks":
            return "เครื่องดื่มเหลือ"
        case "น้ำแข็งเหลือ", "leftover ice":
            return "น้ำแข็งเหลือ"
        case "ซองขนม", "snack bag":
            return "ซองขนม"
        case "ภาชนะใส่อาหาร", "food container":
            return "ภาชนะใส่อาหาร"
        case "หลอด", "straw":
            return "หลอด"
        case "กระดาษทิชชู่", "tissues", "tissue":
            return "กระดาษทิชชู่"
        case "ตะเกียบไม้", "wooden chopsticks":
            return "ตะเกียบไม้"
        case "ช้อน-ส้อม พลาสติก", "plastic cutlery":
            return "ช้อน-ส้อม พลาสติก"
        default:
            return baseKey
        }
    }

    var body: some View {
        switch normalizedKey {
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
            Text(L("ไม่พบข้อมูลประเภทขยะนี้"))
                .font(.noto(config.fontSubHeader, weight: .medium))
                .foregroundColor(.gray)
                .padding()
        }
    }
}
