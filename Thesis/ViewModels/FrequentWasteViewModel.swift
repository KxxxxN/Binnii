//
//  FrequentWasteViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//


//
//  FrequentWasteViewModel.swift
//  Thesis
//

import SwiftUI
import Supabase

@MainActor
class FrequentWasteViewModel: ObservableObject {
    @Published var wasteItems: [WasteItem] = []
    @Published var isLoading: Bool = false
    
    // map category name → image name
    let imageMap: [String: String] = [
        "ขวดพลาสติก": "Bottle",
        "แก้วพลาสติก": "Plasticcup",
        "กระป๋อง": "Can",
        "เศษอาหาร": "Foodscraps",
        "ซองขนม": "SnackBag",
        "ถุงพลาสติก": "Plasticbag",
        "เปลือกไข่": "Egg",
        "หลอด": "Straw",
        "ช้อนส้อมพลาสติก": "Plasticcutlery",
        "กระดาษทิชชู่": "Tissue",
        "เปลือกผลไม้": "Fruit",
        "ภาชนะใส่อาหาร": "FoodContainers",
        "เศษขนม": "Snack",
        "เครื่องดื่มเหลือ": "Drink",
        "น้ำแข็งเหลือ": "Ice",
        "ตะเกียบ": "Chopsticks",
        "กล่องกระดาษ": "Box",
        "กระดาษทั่วไป": "Paper"
        
    ]
    
    func fetchWasteCounts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let session = try await supabase.auth.session
            
            struct WasteCount: Decodable {
                let category: String
                let count: Int
            }
            
            let rows: [WasteCount] = try await supabase
                .rpc("get_waste_counts", params: ["p_user_id": session.user.id.uuidString])
                .execute()
                .value
            
            // ✅ แปลงผลลัพธ์เป็น dict เพื่อ lookup ง่าย
            let countDict = Dictionary(uniqueKeysWithValues: rows.map { ($0.category, $0.count) })
            
            // ✅ วน imageMap ทุกรายการ ถ้าไม่มีใน Supabase ให้ count = 0
            wasteItems = imageMap
                .map { (title, imageName) in
                    WasteItem(
                        imageName: imageName,
                        title: title,
                        count: "\(countDict[title] ?? 0) ครั้ง"
                    )
                }
                .sorted { extractNumber($0.count) > extractNumber($1.count) } // เรียงมาก→น้อย
        } catch {
            print("❌ fetchWasteCounts error: \(error)")
            // ✅ แสดง default items ทั้งหมดเป็น 0 ครั้ง แทนที่จะว่างเปล่า
            wasteItems = imageMap.map { (title, imageName) in
                WasteItem(imageName: imageName, title: title, count: "0 ครั้ง")
            }
            .sorted { $0.title < $1.title }
        }
    }
    // ✅ เพิ่ม helper function
    private func extractNumber(_ text: String) -> Int {
        Int(text.replacingOccurrences(of: " ครั้ง", with: "")) ?? 0
    }
}

