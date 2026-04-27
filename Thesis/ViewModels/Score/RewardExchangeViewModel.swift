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

    private let exchangeCost = 10
    private(set) var currentPoints: Int

    init(totalPoints: Int) {
        self.currentPoints = totalPoints
        loadData()
    }

    // MARK: - Load Display Data

    func loadData() {
        let remaining = currentPoints - exchangeCost

        pointsData = [
            ("total_points", "\(currentPoints)", false),
            ("redeem_points", "\(exchangeCost)", true),
            ("remaining_points", "\(max(remaining, 0))", false)
        ]

        conditionsList = [
            "condition_1",
            "condition_2",
            "condition_3",
            "condition_4",
            "condition_5",
            "condition_6",
            "condition_7"
        ]
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
    /// เรียกฟังก์ชันนี้ทุกครั้งที่ผู้ใช้สแกนขยะสำเร็จและได้รับคะแนน
    /// - Parameters:
    ///   - earnedPoints: คะแนนที่ได้รับครั้งนี้
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
