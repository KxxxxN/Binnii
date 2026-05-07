//
//  WasteData.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

import SwiftUI

struct WasteData {

    // ✅ รับ LanguageManager เพื่อให้ข้อมูลเปลี่ยนตามภาษา
    static func categories(lm: LanguageManager) -> [WasteCategory] {
        let L = lm.localized  // shorthand

        return [
            WasteCategory(
                name:        L("ถังขยะเปียก"),
                colorName:   L("(สีเขียว)"),
                color:       .wetWasteColor,
                description: L("สำหรับขยะที่ย่อยสลายได้เองตามธรรมชาติ"),
                binImage:    "Bin1",
                examples: [
                    WasteExample(image: "Foodscraps", label: L("เศษอาหาร")),
                    WasteExample(image: "Egg",        label: L("เปลือกไข่")),
                    WasteExample(image: "Fruit",      label: L("เปลือกผลไม้")),
                    WasteExample(image: "Drink",      label: L("เครื่องดื่มเหลือ")),
                    WasteExample(image: "Snack",      label: L("เศษขนม")),
                    WasteExample(image: "Ice",        label: L("น้ำแข็งเหลือ"))
                ]
            ),
            WasteCategory(
                name:        L("ถังขยะทั่วไป"),
                colorName:   L("(สีน้ำเงิน)"),
                color:       .generalWasteColor,
                description: L("สำหรับขยะทั่วไปไม่สามารถรีไซเคิลได้"),
                binImage:    "Bin2",
                examples: [
                    WasteExample(image: "SnackBag",       label: L("ซองขนม")),
                    WasteExample(image: "Tissue",          label: L("กระดาษทิชชู่")),
                    WasteExample(image: "FoodContainers",  label: L("ภาชนะใส่อาหาร")),
                    WasteExample(image: "Chopsticks",      label: L("ตะเกียบไม้")),
                    WasteExample(image: "Straw",           label: L("หลอด")),
                    WasteExample(image: "Plasticcutlery",  label: L("ช้อน-ส้อม พลาสติก"))
                ]
            ),
            WasteCategory(
                name:        L("ถังขยะรีไซเคิล"),
                colorName:   L("(สีเหลือง)"),
                color:       .recycleWasteColor,
                description: L("สำหรับขยะที่สามารถนำกลับมาใช้ใหม่หรือแปรรูปได้"),
                binImage:    "Bin3",
                examples: [
                    WasteExample(image: "Bottle",      label: L("ขวดพลาสติก")),
                    WasteExample(image: "Box",         label: L("กล่องกระดาษ")),
                    WasteExample(image: "Plasticcup",  label: L("แก้วพลาสติก")),
                    WasteExample(image: "Paper",       label: L("กระดาษทั่วไป")),
                    WasteExample(image: "Can",         label: L("กระป๋อง")),
                    WasteExample(image: "Plasticbag",  label: L("ถุงพลาสติก"))
                ]
            )
        ]
    }

    // allExamples ก็รับ lm เพื่อความสม่ำเสมอ
    static func allExamples(lm: LanguageManager) -> [WasteExample] {
        categories(lm: lm).flatMap { $0.examples }
    }
}
