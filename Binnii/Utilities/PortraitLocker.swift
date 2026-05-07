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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard self?.viewIfLoaded?.window != nil else { return }
            OrientationHelper.setOrientation(.portrait)
        }
    }
}
