//
//  BarcodeViewMadel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 9/3/2569 BE.
//

import Foundation
import Supabase

@MainActor
class BarcodeViewModel: ObservableObject {
    @Published var productName: String = ""
    @Published var category: String = ""
    @Published var wasteType: String = ""
    @Published var isLoading: Bool = false
    @Published var isNotFound: Bool = false
    
    func fetchProduct(barcode: String) async {
        isLoading = true
        isNotFound = false
        
        // 1. ดึงจาก Supabase ก่อน
        do {
            let result = try await supabase
                .from("products")
                .select()
                .eq("barcode", value: barcode)
                .execute() // ✅ เอา .single() ออก
            
            let data = result.data
            if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
               let json = jsonArray.first { // ✅ เอาอันแรกออกมา
                print("✅ Supabase found: \(json)")
                self.category = json["category"] as? String ?? ""
                self.wasteType = json["waste_type"] as? String ?? ""
                isLoading = false
                return
            }
            print("⚠️ Supabase: barcode not in database")
        } catch {
            print("❌ Supabase error: \(error)")
        }
        // 2. Open Food Facts
        if let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json") {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("✅ API response: \(json)") // ✅ debug ดู response ทั้งหมด
                    
                    let status = json["status"] as? Int
                    print("✅ status: \(status ?? -1)")
                    
                    guard status == 1 else {
                        print("❌ product not found in Open Food Facts")
                        isNotFound = true
                        isLoading = false
                        return
                    }
                    
                    if let product = json["product"] as? [String: Any] {
                        let packaging = product["packaging"] as? String ?? ""
                        let productName = product["product_name"] as? String ?? ""
                        let keywords = product["_keywords"] as? [String] ?? []
                        let categoriesTags = product["categories_tags"] as? [String] ?? [] // ✅ เพิ่ม
                        let packagingTags = product["packaging_tags"] as? [String] ?? []   // ✅ เพิ่ม
                        
                        print("✅ packaging: \(packaging)")
                        print("✅ productName: \(productName)")
                        print("✅ categoriesTags: \(categoriesTags)")
                        print("✅ packagingTags: \(packagingTags)")
                        
                        self.productName = productName
                        categorizeWaste(
                            from: packaging,
                            productName: productName,
                            keywords: keywords,
                            categoriesTags: categoriesTags,
                            packagingTags: packagingTags
                        )
                    } else {
                        isNotFound = true
                    }
                }
            } catch {
                print("❌ API error: \(error)")
                isNotFound = true
            }
        }
        
        isLoading = false
    }
    
    private func categorizeWaste(
        from packaging: String,
        productName: String = "",
        keywords: [String] = [],
        categoriesTags: [String] = [],
        packagingTags: [String] = []
    ) {
        let combined = (packaging + " " + productName + " " + keywords.joined(separator: " ")).lowercased()
        let allTags = (categoriesTags + packagingTags).joined(separator: " ").lowercased()
        let fullText = combined + " " + allTags
        
        print("✅ fullText for matching: \(fullText)")
        
        let isPlastic = fullText.contains("plastic")
        let isBottle = fullText.contains("bottle")
        let isCan = fullText.contains("can") || fullText.contains("metal") || fullText.contains("aluminium") || fullText.contains("กระป๋อง")
        let isPaper = fullText.contains("cardboard") || fullText.contains("paper") || fullText.contains("กล่องกระดาษ")
        let isBag = fullText.contains("bag") || fullText.contains("ถุง")
        let isWater = fullText.contains("water") || fullText.contains("eau") || fullText.contains("น้ำดื่ม")
        let isBeverage = fullText.contains("beverage") || fullText.contains("drink") || fullText.contains("boisson") || fullText.contains("น้ำอัดลม") || fullText.contains("เครื่องดื่ม")
        
        if isPlastic && isBottle {
            wasteType = "ขยะรีไซเคิล"
            category = "ขวดพลาสติก"
        } else if isCan {
            wasteType = "ขยะรีไซเคิล"
            category = "กระป๋อง"
        } else if isPaper {
            wasteType = "ขยะรีไซเคิล"
            category = "กล่องกระดาษ"
        } else if isPlastic && isBag {
            wasteType = "ขยะรีไซเคิล"
            category = "ถุงพลาสติก"
        } else if isPlastic {
            wasteType = "ขยะรีไซเคิล"
            category = "แก้วพลาสติก"
        } else if isWater || isBeverage {
            // ✅ น้ำดื่ม/เครื่องดื่มที่ไม่รู้ packaging → default ขวดพลาสติก
            wasteType = "ขยะรีไซเคิล"
            category = "ขวดพลาสติก"
        } else {
            wasteType = "ขยะทั่วไป"
            category = "ขยะทั่วไป"
            isNotFound = true
        }
    }
}
