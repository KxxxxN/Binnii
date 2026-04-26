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
            ("คะแนนทั้งหมด :",    "\(currentPoints)",     false),
            ("ต้องการแลกคะแนน :", "\(exchangeCost)",       true),
            ("คะแนนคงเหลือ :",    "\(max(remaining, 0))", false)
        ]

        conditionsList = [
            "ผู้ใช้จะได้รับ คะแนนจากการแยกขยะถูกประเภทผ่านระบบสแกนขยะ",
            "คะแนนสามารถใช้ แลกเป็นชั่วโมงจิตอาสาของมหาวิทยาลัย",
            "ระบบจะตรวจสอบข้อมูลการแยกขยะจากบัญชีผู้ใช้ก่อนยืนยันชั่วโมง",
            "ชั่วโมงจิตอาสาที่แลกแล้ว ไม่สามารถยกเลิกหรือโอนให้ผู้อื่นได้",
            "เฉพาะนักศึกษาของมหาวิทยาลัยเท่านั้นที่สามารถแลกได้",
            "การโกงระบบหรือส่งข้อมูลเท็จ จะถูกตัดสิทธิ์ทันที",
            "มหาวิทยาลัยขอสงวนสิทธิ์ในการเปลี่ยนแปลงเงื่อนไขโดยไม่ต้องแจ้งล่วงหน้า"
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
