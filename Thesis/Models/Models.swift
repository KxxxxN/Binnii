// Models.swift
import Foundation

struct HistoryItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let points: String
    let pointsLabel: String
}

struct RecyclableItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let countNumber: Int
}

struct NavigationItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    var isActive: Bool
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct Language {
    let code: String
    let name: String
    let image: String
}

struct ScanResult {
    let label: String
    let thai: String
}

struct FrequentWasteItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let count: String
}

struct WasteTypeItem: Identifiable {
    let id       = UUID()
    let title    : String
    let date     : String
    let imageUrl : String?
}

struct ScanRow: Decodable {
    let category  : String
    let imageUrl  : String?
    let scannedAt : String

    enum CodingKeys: String, CodingKey {
        case category
        case imageUrl  = "image_url"
        case scannedAt = "scanned_at"
    }
}
