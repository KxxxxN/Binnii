//
//  AppDelegate.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 11/4/2569 BE.
//


import UIKit

// ❌ ลบ @main ออกจากบรรทัดบนนี้
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // ตัวแปรสำหรับคุมการหมุนหน้าจอ
    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}