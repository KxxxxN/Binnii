//
//  WasteTypeViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//


//  ViewModels/WasteTypeViewModel.swift
import SwiftUI
import Supabase

@MainActor
final class WasteTypeViewModel: ObservableObject {

    @Published private(set) var items        : [WasteTypeItem] = []
    @Published private(set) var isLoading    : Bool            = false
    @Published private(set) var errorMessage : String?         = nil

    // สร้าง formatter ครั้งเดียว
    private let inputFormatter: DateFormatter = {
        let f        = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        f.locale     = Locale(identifier: "en_US_POSIX")
        return f
    }()

    private let displayFormatter: DateFormatter = {
        let f        = DateFormatter()
        f.dateFormat = "d/M/yyyy - HH:mm"
        f.locale     = Locale(identifier: "en_US_POSIX")
        f.calendar   = Calendar(identifier: .buddhist)
        return f
    }()
    
    private let dateOnlyFormatter: DateFormatter = {
        let f        = DateFormatter()
        f.dateFormat = "d/M/yyyy"
        f.locale     = Locale(identifier: "en_US_POSIX")
        f.calendar   = Calendar(identifier: .buddhist)
        return f
    }()
    
    // MARK: - Fetch
    func fetchItems(category: String) async {
        guard !isLoading else { return }
        isLoading    = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let session = try await supabase.auth.session

            let rows: [ScanRow] = try await supabase
                .from("scan_history")
                .select("category, image_url, scanned_at")
                .eq("user_id", value: session.user.id.uuidString)
                .eq("category", value: category)
                .order("scanned_at", ascending: false)
                .execute()
                .value

            items = rows.map { mapToItem($0) }

        } catch {
            errorMessage = "โหลดข้อมูลไม่สำเร็จ กรุณาลองใหม่"
            items        = []
            print("❌ WasteTypeViewModel.fetchItems:", error)
        }
    }

    // MARK: - Pagination
    func pagedItems(page: Int, perPage: Int) -> [WasteTypeItem] {
        let start = (page - 1) * perPage
        let end   = min(start + perPage, items.count)
        guard start < end else { return [] }
        return Array(items[start..<end])
    }

    func totalPages(perPage: Int) -> Int {
        max(1, Int(ceil(Double(items.count) / Double(perPage))))
    }

    private func mapToItem(_ row: ScanRow) -> WasteTypeItem {
        let cleaned  = String(row.scannedAt.prefix(19))
        let date     = inputFormatter.date(from: cleaned)
        let dateStr  = date.map { displayFormatter.string(from: $0) } ?? row.scannedAt
        let dateOnly = date.map { dateOnlyFormatter.string(from: $0) } ?? row.scannedAt
        return WasteTypeItem(title: row.category,
                             date: dateStr,
                             dateOnly: dateOnly,
                             imageUrl: row.imageUrl)
    }
}
