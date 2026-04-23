//
//  ScoreHistoryViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//


//
//  ScoreHistoryViewModel.swift
//  Thesis
//

import SwiftUI
import Supabase

@MainActor
class ScoreHistoryViewModel: ObservableObject {
    @Published var items: [ScoreItem] = []
    @Published var isLoading: Bool = false

    func fetchHistory() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let session = try await supabase.auth.session

            struct ScanRow: Decodable {
                let category: String
                let points: Int
                let scannedAt: String
                enum CodingKeys: String, CodingKey {
                    case category
                    case points
                    case scannedAt = "scanned_at"
                }
            }

            let rows: [ScanRow] = try await supabase
                .from("scan_history")
                .select("category, points, scanned_at")
                .eq("user_id", value: session.user.id.uuidString)
                .order("scanned_at", ascending: false)
                .execute()
                .value

            let parser = DateFormatter()
            parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            parser.locale = Locale(identifier: "en_US_POSIX")

            let display = DateFormatter()
            display.dateFormat = "d/M/yyyy"
            display.locale = Locale(identifier: "en_US_POSIX")
            display.calendar = Calendar(identifier: .gregorian)

            items = rows.map { row in
                let cleanedDate = String(row.scannedAt.prefix(19))
                let dateStr = parser.date(from: cleanedDate).map { display.string(from: $0) } ?? row.scannedAt
                return ScoreItem(
                    title: row.category,
                    date: dateStr,
                    points: "+\(row.points)",
                    color: .secondColor
                )
            }
        } catch {
            print("❌ fetchHistory error: \(error)")
        }
    }
}
