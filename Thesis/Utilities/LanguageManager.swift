//
//  LanguageManager.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 26/4/2569 BE.
//

import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("selectedLanguage") var selectedLanguage: String = "th" {
        didSet {
            objectWillChange.send()

            
            if NotificationManager.shared.dailyReminderEnabled {
                NotificationManager.shared.scheduleDailyReminders()
            }
        }
    }

    var locale: Locale { Locale(identifier: selectedLanguage) }

    @_semantics("localization_key")
    func localized(_ key: String) -> String {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch selectedLanguage {
        case "th":
            return .noto(size, weight: weight)
        default:
            return .inter(size, weight: weight)
        }
    }
}
