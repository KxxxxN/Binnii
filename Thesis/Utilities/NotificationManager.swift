//
//  NotificationManager.swift
//  Thesis
//

import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @AppStorage("dailyReminderEnabled") var dailyReminderEnabled = false
    @AppStorage("dailyReminderHour")    var dailyReminderHour    = 8
    @AppStorage("dailyReminderMinute")  var dailyReminderMinute  = 0

    // MARK: - Permission
    func requestPermission(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    completion?(granted)
                }
            }
    }

    // MARK: - 🔔 Daily Reminder
    func scheduleDailyReminder(hour: Int, minute: Int) {
        // ลบของเก่าก่อนเสมอ ป้องกัน duplicate
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["daily_sort"])

        let content = UNMutableNotificationContent()
        content.title = "อย่าลืมแยกขยะวันนี้ 🗑️"
        content.body  = "แยกขยะถูกต้อง = โลกสะอาด + คะแนนสะสม!"
        content.sound = .default
        content.badge = 1

        var dateComponents    = DateComponents()
        dateComponents.hour   = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true   // วนซ้ำทุกวัน
        )

        let request = UNNotificationRequest(
            identifier: "daily_sort",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error { print("❌ scheduleDailyReminder: \(error)") }
        }

        dailyReminderEnabled = true
        dailyReminderHour    = hour
        dailyReminderMinute  = minute
    }

    func cancelDailyReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["daily_sort"])
        dailyReminderEnabled = false
    }

    // MARK: - 🏆 Points Notification
    func sendPointsNotification(points: Int, totalPoints: Int) {
        let content = UNMutableNotificationContent()
        content.title = "ได้รับ \(points) คะแนน! 🏆"
        content.body  = "คะแนนสะสมของคุณตอนนี้: \(totalPoints) คะแนน"
        content.sound = .default

        // ยิงหลัง 1 วินาที (ต้อง > 0)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "points_\(UUID().uuidString)", // unique id ทุกครั้ง
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error { print("❌ sendPointsNotification: \(error)") }
        }
    }

    // MARK: - Reset Badge
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error { print("❌ clearBadge: \(error)") }
        }
    }
}