//
//  NotificationManager.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 25/4/2569 BE.
//

import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @AppStorage("dailyReminderEnabled") var dailyReminderEnabled = false

    private let legacyIDs = ["daily_sort"]
    private let dailySchedule: [(hour: Int, minute: Int, id: String)] = [
        (hour: 15, minute: 0, id: "daily_noon"),
        (hour: 16, minute: 0, id: "daily_4pm")
    ]

    // MARK: - Permission (ไม่ขอ .badge แล้ว)
    func requestPermission(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { granted, _ in
                DispatchQueue.main.async {
                    completion?(granted)
                }
            }
    }

    // MARK: - 🔔 Daily Reminders

    func scheduleDailyReminders() {
        let allIDs = legacyIDs + dailySchedule.map { $0.id }
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: allIDs)

        for schedule in dailySchedule {
            let content   = UNMutableNotificationContent()
            content.title = "อย่าลืมแยกขยะวันนี้ 🗑️"
            content.body  = notificationBody(for: schedule.hour)
            content.sound = .default

            var dateComponents      = DateComponents()
            dateComponents.hour     = schedule.hour
            dateComponents.minute   = schedule.minute

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )

            let request = UNNotificationRequest(
                identifier: schedule.id,
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print("❌ schedule \(schedule.id): \(error)")
                } else {
                    print("✅ scheduled \(schedule.id) → \(schedule.hour):\(String(format: "%02d", schedule.minute)) local time")
                }
            }
        }

        dailyReminderEnabled = true
    }

    func cancelDailyReminders() {
        let allIDs = legacyIDs + dailySchedule.map { $0.id }
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: allIDs)
        dailyReminderEnabled = false
    }

    func scheduleDailyReminder(hour: Int, minute: Int) { scheduleDailyReminders() }
    func cancelDailyReminder()                         { cancelDailyReminders()  }

    private func notificationBody(for hour: Int) -> String {
        switch hour {
        case 15: return "ช่วงพักเที่ยง อย่าลืมแยกขยะก่อนทิ้งนะ 🍱"
        case 16: return "ใกล้เลิกเรียนแล้ว แยกขยะวันนี้ยังไหม? ♻️"
        default: return "แยกขยะถูกต้อง = โลกสะอาด + คะแนนจิตอาสา!"
        }
    }

    // MARK: - 🏆 Points Notification
    func sendPointsNotification(points: Int, totalPoints: Int) {
        // ✅ ถ้า toggle ปิดอยู่ ไม่ส่งเลย
        guard dailyReminderEnabled else { return }
        
        let content   = UNMutableNotificationContent()
        content.title = "ได้รับ \(points) คะแนน! 🏆"
        content.body  = "คะแนนสะสมของคุณตอนนี้: \(totalPoints) คะแนน"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "points_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error { print("❌ sendPointsNotification: \(error)") }
        }
    }
    func cancelAllNotifications() {
        // ยกเลิก daily reminders
        let allIDs = legacyIDs + dailySchedule.map { $0.id }
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: allIDs)
        
        // ✅ ยกเลิก points notifications และทุกอย่างที่ pending อยู่
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // ✅ ลบที่แสดงอยู่ใน notification center แล้วด้วย
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        dailyReminderEnabled = false
    }
}
