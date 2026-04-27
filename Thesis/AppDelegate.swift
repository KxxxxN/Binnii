//
//  AppDelegate.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 11/4/2569 BE.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        NotificationManager.shared.requestPermission()
        preloadFonts()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    private func preloadFonts() {
        let fontNames = [
            "NotoSansThai-Regular",
            "NotoSansThai-Bold",
            "NotoSansThai-Medium",
            "NotoSansThai-SemiBold",
            "NotoSansThai-Light",
            "NotoSansThai-Thin",
            "Inter-Regular",
            "Inter-Bold",
            "Inter-Medium",
            "Inter-SemiBold",
            "Inter-Light",
            "Inter-Thin",
        ]
        fontNames.forEach { _ = UIFont(name: $0, size: 12) }
    }
}
