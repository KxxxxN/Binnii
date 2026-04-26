//
//  MainAppViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 24/4/2569 BE.
//


import SwiftUI
import Combine

@MainActor
final class MainAppViewModel: ObservableObject {

    // MARK: - Sub ViewModels
    @Published var profileVM = UserProfileViewModel()
    @Published var wasteVM   = FrequentWasteViewModel()

    // MARK: - Computed: ขยะที่แสดงใน FrequentWasteSection
    var displayedWasteItems: [RecyclableItem] {
        guard !wasteVM.wasteItems.isEmpty else {
            return [
                RecyclableItem(imageName: "Bottle",     title: "ขวดพลาสติก", countNumber: 0),
                RecyclableItem(imageName: "Plasticcup", title: "แก้วพลาสติก",  countNumber: 0),
                RecyclableItem(imageName: "Can",        title: "กระป๋อง",    countNumber: 0)
            ]
        }
        return wasteVM.wasteItems.prefix(3).map {
            RecyclableItem(
                imageName: $0.imageName,
                title: $0.title,
                countNumber: Int(
                    $0.count.replacingOccurrences(of: " ครั้ง", with: "")
                ) ?? 0
            )
        }
    }

    // MARK: - Actions
//    func onLoginStateChanged(isLoggedIn: Bool) async {
//        profileVM.clearProfile()
//        guard isLoggedIn else { return }
//        do {
//            let session = try await supabase.auth.session
//            await profileVM.fetchProfile(userId: session.user.id)
//            await wasteVM.fetchWasteCounts()
//        } catch {
//            print("❌ No session: \(error)")
//        }
//    }
//
//    func onLogout() {
//        profileVM.clearProfile()
//    }
}