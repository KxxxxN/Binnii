//
//  OrientationHelper.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 11/4/2569 BE.
//


import UIKit

struct OrientationHelper {
    
    static func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        AppDelegate.orientationLock = orientation
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let rootViewController = windowScene.windows.first?.rootViewController
            rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            
            if #available(iOS 16.0, *) {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            } else {
                let targetOrientation: UIInterfaceOrientation = (orientation == .portrait) ? .portrait : .unknown
                UIDevice.current.setValue(targetOrientation.rawValue, forKey: "orientation")
            }
        }
    }
}
