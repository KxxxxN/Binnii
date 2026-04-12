//
//  OrientationHelper.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 11/4/2569 BE.
//


import UIKit

struct OrientationHelper {
    
    /// ฟังก์ชันสำหรับล็อกการหมุนหน้าจอ
    /// - Parameter orientation: ทิศทางที่ต้องการ เช่น .portrait หรือ .all
    static func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        // 1. อัปเดตตัวแปรใน AppDelegate เพื่อกำหนดขอบเขตการหมุน
        AppDelegate.orientationLock = orientation
        
        // 2. แจ้งระบบว่าค่า Supported Orientations เปลี่ยนไปแล้ว
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let rootViewController = windowScene.windows.first?.rootViewController
            rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            
            // 3. สั่งให้หน้าจอหมุน (Force Rotation) ตามแนวที่กำหนดทันที
            if #available(iOS 16.0, *) {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            } else {
                // สำหรับ iOS รุ่นเก่ากว่า 16
                let targetOrientation: UIInterfaceOrientation = (orientation == .portrait) ? .portrait : .unknown
                UIDevice.current.setValue(targetOrientation.rawValue, forKey: "orientation")
            }
        }
    }
}