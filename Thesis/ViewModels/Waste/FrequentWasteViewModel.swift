//
//  FrequentWasteViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//

import SwiftUI
import Supabase

@MainActor
class FrequentWasteViewModel: ObservableObject {
    @Published var wasteItems: [FrequentWasteItem] = []
    @Published var isLoading: Bool = false

    private let lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    let imageMap: [String: String] = [
        "ขวดพลาสติก": "Bottle",
        "แก้วพลาสติก": "Plasticcup",
        "กระป๋อง": "Can",
        "เศษอาหาร": "Foodscraps",
        "ซองขนม": "SnackBag",
        "ถุงพลาสติก": "Plasticbag",
        "เปลือกไข่": "Egg",
        "หลอด": "Straw",
        "ช้อน-ส้อม พลาสติก": "Plasticcutlery",
        "กระดาษทิชชู่": "Tissue",
        "เปลือกผลไม้": "Fruit",
        "ภาชนะใส่อาหาร": "FoodContainers",
        "เศษขนม": "Snack",
        "เครื่องดื่มเหลือ": "Drink",
        "น้ำแข็งเหลือ": "Ice",
        "ตะเกียบไม้": "Chopsticks",
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

            let countDict = Dictionary(uniqueKeysWithValues: rows.map { ($0.category, $0.count) })

            wasteItems = imageMap
                .map { (title, imageName) in
                    FrequentWasteItem(
                        imageName: imageName,
                        title: L(title),
                        count: "\(countDict[title] ?? 0) \(L("ครั้ง"))"
                    )
                }
                .sorted { extractNumber($0.count) > extractNumber($1.count) }

        } catch {
            print("❌ fetchWasteCounts error: \(error)")
            wasteItems = imageMap
                .map { (title, imageName) in
                    FrequentWasteItem(
                        imageName: imageName,
                        title: L(title),
                        count: "0 \(L("ครั้ง"))"
                    )
                }
                .sorted { $0.title < $1.title }
        }
    }

    private func extractNumber(_ text: String) -> Int {
        let digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(digits) ?? 0
    }
}
