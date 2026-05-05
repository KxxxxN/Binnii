//
//  PortraitLocker.swift
//  Thesis
//

import SwiftUI
import UIKit

struct PortraitLocker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PortraitLockerVC {
        PortraitLockerVC()
    }
    func updateUIViewController(_ uiViewController: PortraitLockerVC, context: Context) {}
}

class PortraitLockerVC: UIViewController {
    // ถูกเรียกทุกครั้งที่ view กลับมา รวมถึงตอน pop จาก NavigationStack
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OrientationHelper.setOrientation(.portrait)
    }
}