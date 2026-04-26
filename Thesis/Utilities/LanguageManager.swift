//
//  LanguageManager.swift
//  Thesis
//

import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("selectedLanguage") var selectedLanguage: String = "th" {
        didSet {
            // บอก SwiftUI ให้ re-render ทุก view ที่ observe LanguageManager
            objectWillChange.send()
        }
    }

    var locale: Locale { Locale(identifier: selectedLanguage) }

    /// แปล key โดยใช้ภาษาปัจจุบัน — ใช้ใน ViewModel / non-View layer
    func localized(_ key: String) -> String {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}