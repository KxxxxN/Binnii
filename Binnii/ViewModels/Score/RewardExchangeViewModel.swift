//
//  RewardExchangeViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

import Foundation

class RewardExchangeViewModel: ObservableObject {

    @Published var pointsData: [(label: String, value: String, isBold: Bool)] = []
    @Published var conditionsList: [String] = []
    @Published var showConfirmAlert = false
    @Published var showSuccessPopup = false

    private let exchangeCost = 500
    private(set) var currentPoints: Int

    init(totalPoints: Int) {
        self.currentPoints = totalPoints
        loadData()
    }

    // MARK: - Load Display Data

    func loadData() {
        let lm = LanguageManager.shared 
        let remaining = currentPoints - exchangeCost

        pointsData = [
            (lm.localized("total_points"), "\(currentPoints)", false),
            (lm.localized("redeem_points"), "\(exchangeCost)", true),
            (lm.localized("remaining_points"), "\(max(remaining, 0))", false)
        ]

        let keys = [
            "condition_1", "condition_2", "condition_3",
            "condition_4", "condition_5", "condition_6", "condition_7"
        ]
        conditionsList = keys.map { lm.localized($0) }
    }

    // MARK: - Exchange Flow

    func confirmExchange() {
        showConfirmAlert = true
    }

    func performExchange() {
        guard currentPoints >= exchangeCost else { return }
        currentPoints -= exchangeCost
        loadData()
        showSuccessPopup = true
    }

    // MARK: - 🏆 เพิ่มคะแนน + แจ้งเตือน
    func addPoints(_ earnedPoints: Int) {
        print("🏆 addPoints called: +\(earnedPoints), total: \(currentPoints + earnedPoints)")
        currentPoints += earnedPoints
        loadData()
        NotificationManager.shared.sendPointsNotification(
            points: earnedPoints,
            totalPoints: currentPoints
        )
    }
}
