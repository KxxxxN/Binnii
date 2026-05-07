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

        guard let windowScene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene else { return }

        if #available(iOS 16.0, *) {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            windowScene.windows.first?.rootViewController?
                .setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            let target = (orientation == .portrait)
                ? UIInterfaceOrientation.portrait.rawValue
                : UIInterfaceOrientation.unknown.rawValue
            UIDevice.current.setValue(target, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}
