//
//  ColorExtension.swift
//  Theis
//
//  Created by Kansinee Klinkhachon on 22/10/2568 BE.
//

import SwiftUI

extension Color {
    static let mainColor = Color(red: 0x3B/255, green: 0x51/255, blue: 0x31/255)
    static let secondColor = Color(red: 0x76/255, green: 0x85/255, blue: 0x72/255)
    static let thirdColor = Color(red: 0xBC/255, green: 0xBF/255, blue: 0xB1/255)
    static let backgroundColor = Color(red: 0xF4/255, green: 0xF5/255, blue: 0xF7/255)
    static let tabbarColor = Color(red: 0x12/255, green: 0x18/255, blue: 0x10/255)
    static let tabbarButton = Color(red: 0x12/255, green: 0x18/255, blue: 0x10/255)
    static let textFieldColor = Color(red: 0xD9/255, green: 0xD9/255, blue: 0xD9/255)
    static let dangerColor = Color(red: 0xD7/255, green: 0x69/255, blue: 0x69/255)
    static let errorColor = Color(red: 0xE3/255, green: 0x36/255, blue: 0x29/255)
    static let placeholderColor = Color(red: 0x9C/255, green: 0x9C/255, blue: 0x9C/255)
    static let accountSecColor = Color(red: 0xEC/255, green: 0xED/255, blue: 0xE9/255)
    static let searchColor = Color(red: 0xEE/255, green: 0xEE/255, blue: 0xEE/255)


    static let knowledgeBackground = Color(red: 0xE8/255, green: 0xE6/255, blue: 0xE2/255)
    static let wetWasteColor = Color(red: 0x00/255, green: 0x93/255, blue: 0x45/255)
    static let wasteCard = Color(red: 0xD9/255, green: 0xD5/255, blue: 0xCF/255)
    static let generalWasteColor = Color(red: 0x1A/255, green: 0x75/255, blue: 0xBB/255)
    static let recycleWasteColor = Color(red: 0xE9/255, green: 0xAF/255, blue: 0x43/255)
    static let redeemColor = Color(red: 0xD7/255, green: 0x69/255, blue: 0x69/255)
    static let cameraBackground = Color(red: 0xEB/255, green: 0xEB/255, blue: 0xEB/255)

}

extension Font {
    
    static func noto(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .thin:
            return .custom("Noto Sans Thai Thin", size: size)
        case .light:
            return .custom("Noto Sans Thai Light", size: size)
        case .medium:
            return .custom("Noto Sans Thai Medium", size: size)
        case .semibold:
            return .custom("Noto Sans Thai SemiBold", size: size)
        case .bold:
            return .custom("Noto Sans Thai Bold", size: size)
        default:
            return .custom("Noto Sans Thai Regular", size: size)
        }
    }
    static func inter(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .thin:
            return .custom("Inter-Thin", size: size)
        case .light:
            return .custom("Inter-Light", size: size)
        case .medium:
            return .custom("Inter-Medium", size: size)
        case .semibold:
            return .custom("Inter-SemiBold", size: size)
//        case .bold:
//            return .custom("Inter-Bold", size: size)
        default:
            return .custom("Inter-Regular", size: size)
        }
    }
    
}

extension UIImage {
    func fixedOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return normalized
    }
}
