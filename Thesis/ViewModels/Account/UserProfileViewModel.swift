//
//  UserProfile.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//


import SwiftUI
import Supabase
import Combine  

struct UserProfile: Decodable {
    let firstName: String
    let lastName: String
    let points: Int

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName  = "last_name"
        case points
    }
}

@MainActor
class UserProfileViewModel: ObservableObject{
    @Published var fullName: String = LanguageManager.shared.localized("ชื่อ - นามสกุล")
    @Published var totalPoints: Int = 0
    @Published var profileImage: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var latestHistory: HistoryItem? = nil
    
    private var langCancellable: AnyCancellable?
    
    init() {
        langCancellable = LanguageManager.shared.objectWillChange.sink { [weak self] _ in
            guard let self else { return }
            // ถ้ายังไม่มีชื่อจริง (ยังเป็น default) ให้ update ตามภาษาใหม่
            if self.fullName == LanguageManager.shared.localized("ชื่อ - นามสกุล") ||
               self.fullName == "ชื่อ - นามสกุล" ||
               self.fullName == "First - Last Name" {
                Task { @MainActor in
                    self.fullName = LanguageManager.shared.localized("ชื่อ - นามสกุล")
                }
            }
        }
    }
    
    private func L(_ key: String) -> String {
        LanguageManager.shared.localized(key)
    }
    
    func fetchProfile(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        
        async let name: Void = fetchName()
        async let points: Void = fetchTotalPoints(userId: userId)
        async let history: Void = fetchLatestHistory(userId: userId)
        _ = await (name, points, history)
    }
    
    private func fetchName() async {
        do {
            let user = try await supabase.auth.session.user
            let meta = user.userMetadata

            let firstName = meta["first_name"]?.stringValue ?? ""
            let lastName  = meta["last_name"]?.stringValue ?? ""
            fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)

            let fileName = "\(user.id).jpg"
            if let url = try? supabase.storage
                .from("avatars")
                .getPublicURL(path: fileName) {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.profileImage = image
                }
            }
        } catch {
            fullName = L("ชื่อ - นามสกุล")
            print("❌ fetchName error: \(error)")
        }
    }
    
    private func fetchTotalPoints(userId: UUID) async {
        do {
            struct PointsRow: Decodable {
                let points: Int
            }
            
            let rows: [PointsRow] = try await supabase
                .from("scan_history")
                .select("points")
                .eq("user_id", value: userId.uuidString)
                .execute()
                .value
            
            totalPoints = rows.reduce(0) { $0 + $1.points }
        } catch {
            totalPoints = 0
            print("❌ fetchTotalPoints error: \(error)")
        }
    }
    
    private func fetchLatestHistory(userId: UUID) async {
        do {
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
                .eq("user_id", value: userId.uuidString)
                .order("scanned_at", ascending: false)
                .limit(1)
                .execute()
                .value

            if let latest = rows.first {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                formatter.locale = Locale(identifier: "en_US_POSIX")

                let displayDate: String
                let cleanedDate = String(latest.scannedAt.prefix(19))

                let parser = DateFormatter()
                parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                parser.locale = Locale(identifier: "en_US_POSIX")

                if let date = parser.date(from: cleanedDate) {
                    let display = DateFormatter()
                    display.dateFormat = "d/M/yyyy"
                    display.locale = Locale(identifier: "en_US_POSIX")
                    display.calendar = Calendar(identifier: .gregorian)
                    displayDate = display.string(from: date)
                } else {
                    displayDate = latest.scannedAt
                }

                latestHistory = HistoryItem(
                    title: latest.category,
                    date: displayDate,
                    points: latest.points < 0 ? "\(latest.points)" : "+\(latest.points)",
                    pointsLabel: L("คะแนน")
                )
                print("📋 latestHistory updated: \(latest.category) | \(latest.points)")
            }
        } catch {
            print("❌ fetchLatestHistory error: \(error)")
        }
    }
    
    func deductPoints(amount: Int) async {
        guard let session = try? await supabase.auth.session else {
            print("❌ deductPoints: no session")
            return
        }

        do {
            struct InsertRow: Encodable {
                let user_id: String
                let category: String
                let bin_type: String
                let points: Int
                let scanned_at: String
            }

            let now = ISO8601DateFormatter().string(from: Date())

            try await supabase
                .from("scan_history")
                .insert(InsertRow(
                    user_id: session.user.id.uuidString,
                    category: "แลกคะแนน",
                    bin_type: "แลกคะแนน",
                    points: -amount,
                    scanned_at: now
                ))
                .execute()

            print("✅ deductPoints success: -\(amount)")

            totalPoints -= amount
            
            await fetchLatestHistory(userId: session.user.id)

        } catch {
            print("❌ deductPoints error: \(error)")
        }
    }
}

