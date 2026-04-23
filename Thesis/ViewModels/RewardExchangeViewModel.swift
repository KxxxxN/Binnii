//
//  RewardExchangeViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


// RewardExchangeViewModel.swift

import Foundation

class RewardExchangeViewModel: ObservableObject {
    
    @Published var pointsData: [(label: String, value: String, isBold: Bool)] = []
    @Published var conditionsList: [String] = []
    @Published var isLoading = false
    @Published var showConfirmAlert = false

    init() {
        loadData()
    }

    func loadData() {
        // จำลองข้อมูล — แทนที่ด้วย Supabase call ได้เลย
        pointsData = [
            ("คะแนนทั้งหมด :", "333", false),
            ("ต้องการแลกคะแนน :", "300", true),
            ("คะแนนคงเหลือ :", "33", false)
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

    func confirmExchange() {
        // ใส่ logic แลกคะแนนกับ Supabase ที่นี่
        showConfirmAlert = true
    }
}