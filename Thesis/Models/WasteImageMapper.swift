//
//  WasteImageMapper.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


enum WasteImageMapper {

    static func image(for category: String) -> String {
        switch category {
        case "ขวดพลาสติก":       return "TypeBottle"
        case "แก้วพลาสติก":       return "TypePlasticCup"
        case "กระป๋อง":           return "TypeCan"
        case "กล่องกระดาษ":       return "TypeCardboard"
        case "กระดาษทั่วไป":      return "TypePaper"
        case "ถุงพลาสติก":        return "TypePlasticBag"
        case "เศษอาหาร":          return "TypeFood"
        case "เปลือกผลไม้":       return "TypeFruit"
        case "เศษขนม":            return "TypeSnack"
        case "เปลือกไข่":         return "TypeEgg"
        case "เครื่องดื่มเหลือ":  return "TypeDrink"
        case "น้ำแข็งเหลือ":      return "TypeIce"
        case "ซองขนม":            return "TypeSnackBag"
        case "ภาชนะใส่อาหาร":     return "TypeContainer"
        case "หลอด":              return "TypeStraw"
        case "กระดาษทิชชู่":      return "TypeTissue"
        case "ตะเกียบไม้":        return "TypeChopstick"
        case "ช้อน-ส้อม พลาสติก":  return "TypeSpoon"
        default:                  return "TypeBottle1"
        }
    }

    static func bin(for category: String) -> String {
        switch category {
        case "ขวดพลาสติก", "แก้วพลาสติก", "กระป๋อง",
             "กล่องกระดาษ", "กระดาษทั่วไป", "ถุงพลาสติก":
            return "ถังขยะรีไซเคิล"
        case "ซองขนม", "กระดาษทิชชู่", "ภาชนะใส่อาหาร",
             "ตะเกียบไม้", "หลอด", "ช้อน-ส้อม พลาสติก":
            return "ถังขยะทั่วไป"
        case "เศษอาหาร", "เปลือกไข่", "เปลือกผลไม้",
             "เครื่องดื่มเหลือ", "เศษขนม", "น้ำแข็งเหลือ":
            return "ถังขยะเปียก"
        default:
            return "ถังขยะทั่วไป"
        }
    }
}
