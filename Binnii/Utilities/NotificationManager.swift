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
        (hour: 12, minute: 0, id: "daily_noon"),
        (hour: 16, minute: 0, id: "daily_4pm")
    ]

    private var lang: String { LanguageManager.shared.selectedLanguage }

    // MARK: - Permission
    func requestPermission(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { granted, _ in
                DispatchQueue.main.async { completion?(granted) }
            }
    }

    // MARK: - 🔔 Daily Reminders
    func scheduleDailyReminders() {
        let allIDs = legacyIDs + dailySchedule.map { $0.id }
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: allIDs)

        for schedule in dailySchedule {
            let content   = UNMutableNotificationContent()
            content.title = notificationTitle()
            content.body  = notificationBody(for: schedule.hour)
            content.sound = .default

            var dateComponents    = DateComponents()
            dateComponents.hour   = schedule.hour
            dateComponents.minute = schedule.minute

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
                    print("✅ scheduled \(schedule.id) → \(schedule.hour):\(String(format: "%02d", schedule.minute)) [\(self.lang)]")
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

    func cancelAllNotifications() {
        let allIDs = legacyIDs + dailySchedule.map { $0.id }
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: allIDs)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        dailyReminderEnabled = false
    }

    func scheduleDailyReminder(hour: Int, minute: Int) { scheduleDailyReminders() }
    func cancelDailyReminder()                         { cancelDailyReminders()  }

    // MARK: - Notification Text
    private func notificationTitle() -> String {
        lang == "en"
            ? "Remember to sort the waste 🗑️"
            : "อย่าลืมแยกขยะวันนี้ 🗑️"
    }

    private func notificationBody(for hour: Int) -> String {
        switch lang {
        case "en":
            switch hour {
            case 12: return "Lunch break! Remember to sort your waste before throwing it away 🍱"
            case 16: return "Almost time to go! Did you sort your waste today? ♻️"
            default: return "Sorting waste correctly = Clean world + Volunteer points!"
            }
        default:
            switch hour {
            case 12: return "ช่วงพักเที่ยง อย่าลืมแยกขยะก่อนทิ้งนะ 🍱"
            case 16: return "ใกล้เลิกเรียนแล้ว แยกขยะวันนี้ยังทันไหม? ♻️"
            default: return "แยกขยะถูกต้อง = โลกสะอาด + คะแนนจิตอาสา!"
            }
        }
    }

    // MARK: - 🏆 Points Notification
    func sendPointsNotification(points: Int, totalPoints: Int) {
        guard dailyReminderEnabled else { return }

        let content = UNMutableNotificationContent()
        if lang == "en" {
            content.title = "You earned \(points) points! 🏆"
            content.body  = "Your total points: \(totalPoints) pts"
        } else {
            content.title = "ได้รับ \(points) คะแนน! 🏆"
            content.body  = "คะแนนสะสมของคุณตอนนี้: \(totalPoints) คะแนน"
        }
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
}
