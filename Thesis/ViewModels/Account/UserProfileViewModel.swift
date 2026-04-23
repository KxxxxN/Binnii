//
//  UserProfile.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/3/2569 BE.
//


import SwiftUI
import Supabase

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
    @Published var fullName: String = "ชื่อ - นามสกุล"
    @Published var totalPoints: Int = 0
    @Published var profileImage: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var latestHistory: HistoryItem? = nil
    
    func fetchProfile(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }
        
        await fetchName()
        await fetchTotalPoints(userId: userId)
        await fetchLatestHistory(userId: userId)
    }
    
    func clearProfile() {
        print("🧹 clearProfile called")
        fullName = "ชื่อ - นามสกุล"
        totalPoints = 0
        profileImage = nil
        latestHistory = nil
    }
    private func fetchName() async {
        do {
            let user = try await supabase.auth.session.user
            let meta = user.userMetadata

            let firstName = meta["first_name"]?.stringValue ?? ""
            let lastName  = meta["last_name"]?.stringValue ?? ""
            fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)

            if let avatarURLString = meta["avatar_url"]?.stringValue,
               let url = URL(string: avatarURLString) {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.profileImage = image
                }
            }
        } catch {
            fullName = "ชื่อ - นามสกุล"
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
                let cleanedDate = String(latest.scannedAt.prefix(19)) // "2026-03-12T10:46:18"

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
                    points: "+\(latest.points)",
                    pointsLabel: "คะแนน"
                )
            }
        } catch {
            print("❌ fetchLatestHistory error: \(error)")
        }
    }
}

