//
//  WasteImageMapper.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

// ✅ ใช้ key ภาษาไทยตลอด (canonical key) — ไม่เปลี่ยน
// WasteDetailContentView จะ normalize category ก่อนส่งเข้า switch เสมอ

enum WasteImageMapper {

    static func image(for category: String) -> String {
        switch canonicalKey(for: category) {
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
        case "ช้อน-ส้อม พลาสติก": return "TypeSpoon"
        default:                  return "TypeBottle1"
        }
    }

    static func bin(for category: String) -> String {
        switch canonicalKey(for: category) {
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

    // MARK: - EN → TH canonical key
    // รองรับทั้ง TH และ EN label ที่มาจาก WasteData / xcstrings
    static func canonicalKey(for category: String) -> String {
        switch category {
        // Recycle
        case "Plastic Bottle":   return "ขวดพลาสติก"
        case "Plastic Cup":      return "แก้วพลาสติก"
        case "Can":              return "กระป๋อง"
        case "Cardboard Box":    return "กล่องกระดาษ"
        case "General Paper":    return "กระดาษทั่วไป"
        case "Plastic Bag":      return "ถุงพลาสติก"
        // Wet
        case "Food Waste", "Food waste": return "เศษอาหาร"
        case "Fruit Peel":       return "เปลือกผลไม้"
        case "Snack Crumbs":     return "เศษขนม"
        case "Eggshell":         return "เปลือกไข่"
        case "Leftover Drinks":  return "เครื่องดื่มเหลือ"
        case "Leftover Ice":     return "น้ำแข็งเหลือ"
        // General
        case "Snack Bag":        return "ซองขนม"
        case "Food Container":   return "ภาชนะใส่อาหาร"
        case "Straw":            return "หลอด"
        case "Tissue Paper":     return "กระดาษทิชชู่"
        case "Wooden Chopsticks": return "ตะเกียบไม้"
        case "Plastic Cutlery":  return "ช้อน-ส้อม พลาสติก"
        default:                 return category  // ภาษาไทยผ่านได้เลย
        }
    }
}
