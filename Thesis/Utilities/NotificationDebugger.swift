//
//  NotificationDebugger.swift
//  Thesis
//
//  ⚠️ ไฟล์นี้ใช้ debug ชั่วคราว ลบออกได้หลังแก้ปัญหาเสร็จ
//

import UserNotifications

struct NotificationDebugger {

    /// เรียกฟังก์ชันนี้ใน onAppear ของหน้าใดก็ได้ แล้วดูผลใน Xcode Console
    static func runFullDiagnostic() {
        print("\n========== 🔔 NOTIFICATION DIAGNOSTIC ==========")

        // Step 1: เช็ค Permission
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("\n📋 [1] Authorization Status: \(statusDescription(settings.authorizationStatus))")
            print("   Alert:  \(settings.alertSetting == .enabled ? "✅" : "❌")")
            print("   Sound:  \(settings.soundSetting == .enabled ? "✅" : "❌")")
            print("   Badge:  \(settings.badgeSetting == .enabled ? "✅" : "❌")")
            print("   Banner: \(settings.alertStyle == .banner ? "✅ Banner" : settings.alertStyle == .alert ? "✅ Alert" : "❌ None")")

            // Step 2: เช็ค Delegate
            let delegate = UNUserNotificationCenter.current().delegate
            print("\n👤 [2] Delegate: \(delegate != nil ? "✅ \(type(of: delegate!))" : "❌ nil ← ปัญหาหลัก! foreground notification จะไม่แสดง")")

            // Step 3: เช็ค Pending Notifications
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("\n📬 [3] Pending Notifications: \(requests.count) รายการ")
                if requests.isEmpty {
                    print("   ⚠️ ไม่มี notification ที่ตั้งไว้เลย — scheduleDailyReminder() ยังไม่ถูกเรียก")
                } else {
                    requests.forEach { req in
                        print("   - id: \(req.identifier)")
                        print("     trigger: \(req.trigger.map { "\($0)" } ?? "none")")
                    }
                }

                // Step 4: ยิง test notification ทันที
                print("\n🚀 [4] Firing test notification in 3 seconds...")
                fireTestNotification()

                print("=================================================\n")
            }
        }
    }

    /// ยิง notification จริงหลัง 3 วินาที — ถ้าเห็นแสดงว่า setup ถูกต้อง
    static func fireTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🧪 Test Notification"
        content.body  = "ถ้าเห็นข้อความนี้แสดงว่า notification ทำงานได้ปกติ"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "debug_test", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("❌ [4] Fire failed: \(error.localizedDescription)")
            } else {
                print("✅ [4] Test notification scheduled — รอดูใน 3 วินาที")
            }
        }
    }

    private static func statusDescription(_ status: UNAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "❓ notDetermined — ยังไม่เคยถามผู้ใช้"
        case .denied:        return "❌ denied — ผู้ใช้ปฏิเสธ หรือถูก revoke"
        case .authorized:    return "✅ authorized"
        case .provisional:   return "⚠️ provisional"
        case .ephemeral:     return "⚠️ ephemeral"
        @unknown default:    return "❓ unknown"
        }
    }
}