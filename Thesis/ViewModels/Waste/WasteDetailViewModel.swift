//
//  WasteDetailViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

import SwiftUI
import Storage
import Auth

@MainActor
final class WasteDetailViewModel: ObservableObject {

    @Published var isSaving: Bool = false
    @Published var showSaveSuccess: Bool = false
    @Published var showSaveError: Bool = false

    private let earnedPointsPerScan = 10

    func save(category: String, scanMethod: String, capturedImage: UIImage?) async {
        isSaving = true
        defer { isSaving = false }

        do {
            let user = try await supabase.auth.session.user
            var imageURL: String? = nil

            // อัปโหลดรูป
            if let uiImage = capturedImage,
               let data = uiImage.jpegData(compressionQuality: 0.8) {
                let fileName = "\(user.id)_\(Date().timeIntervalSince1970).jpg"
                try await supabase.storage
                    .from("scan-images")
                    .upload(fileName, data: data, options: FileOptions(upsert: true))
                let url = try supabase.storage
                    .from("scan-images")
                    .getPublicURL(path: fileName)
                imageURL = url.absoluteString
            }

            // บันทึก scan history
            try await supabase
                .from("scan_history")
                .insert([
                    "user_id":      user.id.uuidString,
                    "category":     category,
                    "bin_type":     WasteImageMapper.bin(for: category),
                    "image_url":    imageURL ?? "",
                    "points":       "\(earnedPointsPerScan)",
                    "scan_method":  scanMethod
                ])
                .execute()

            // อัปเดตคะแนนสะสมใน user metadata
            let previousPoints = user.userMetadata["points"]?.intValue ?? 0
            let newTotalPoints = previousPoints + earnedPointsPerScan
            try await supabase.auth.update(
                user: UserAttributes(data: ["points": .integer(newTotalPoints)])
            )

            // ✅ แจ้งเตือนคะแนนหลัง save สำเร็จ
            NotificationManager.shared.sendPointsNotification(
                points: earnedPointsPerScan,
                totalPoints: newTotalPoints
            )

            showSaveSuccess = true

        } catch {
            print("❌ Save error: \(error)")
            showSaveError = true
        }
    }
}
