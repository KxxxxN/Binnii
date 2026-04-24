//
//  WasteData.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct WasteData {
    static let categories: [WasteCategory] = [
        WasteCategory(
            name: "ถังขยะเปียก",
            colorName: "(สีเขียว)",
            color: .wetWasteColor,
            description: "สำหรับขยะที่ย่อยสลายได้เองตามธรรมชาติ",
            binImage: "Bin1",
            examples: [
                WasteExample(image: "Foodscraps", label: "เศษอาหาร"),
                WasteExample(image: "Egg",        label: "เปลือกไข่"),
                WasteExample(image: "Fruit",      label: "เปลือกผลไม้"),
                WasteExample(image: "Drink",      label: "เครื่องดื่มเหลือ"),
                WasteExample(image: "Snack",      label: "เศษขนม"),
                WasteExample(image: "Ice",        label: "น้ำแข็งเหลือ")
            ]
        ),
        WasteCategory(
            name: "ถังขยะทั่วไป",
            colorName: "(สีน้ำเงิน)",
            color: .generalWasteColor,
            description: "สำหรับขยะทั่วไปไม่สามารถรีไซเคิลได้",
            binImage: "Bin2",
            examples: [
                WasteExample(image: "SnackBag",      label: "ซองขนม"),
                WasteExample(image: "Tissue",         label: "กระดาษทิชชู่"),
                WasteExample(image: "FoodContainers", label: "ภาชนะใส่อาหาร"),
                WasteExample(image: "Chopsticks",     label: "ตะเกียบไม้"),
                WasteExample(image: "Straw",          label: "หลอด"),
                WasteExample(image: "Plasticcutlery", label: "ช้อน-ส้อม พลาสติก")
            ]
        ),
        WasteCategory(
            name: "ถังขยะรีไซเคิล",
            colorName: "(สีเหลือง)",
            color: .recycleWasteColor,
            description: "สำหรับขยะที่สามารถนำกลับมาใช้ใหม่หรือแปรรูปได้",
            binImage: "Bin3",
            examples: [
                WasteExample(image: "Bottle",     label: "ขวดพลาสติก"),
                WasteExample(image: "Box",        label: "กล่องกระดาษ"),
                WasteExample(image: "Plasticcup", label: "แก้วพลาสติก"),
                WasteExample(image: "Paper",      label: "กระดาษทั่วไป"),
                WasteExample(image: "Can",        label: "กระป๋อง"),
                WasteExample(image: "Plasticbag", label: "ถุงพลาสติก")
            ]
        )
    ]

    static var allExamples: [WasteExample] {
        categories.flatMap { $0.examples }
    }
}
