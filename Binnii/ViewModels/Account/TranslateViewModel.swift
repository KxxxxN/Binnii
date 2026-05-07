//
//  TranslateViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//

import Foundation

@MainActor
final class TranslateViewModel: ObservableObject {

    let languages: [Language] = [
        Language(code: "th", name: "ภาษาไทย", image: "Thai"),
        Language(code: "en", name: "English",  image: "English")
    ]

    // ✅ อ่าน/เขียนตรงจาก LanguageManager — ทุก view ที่ observe lm จะ re-render อัตโนมัติ
    var selectedLanguageCode: String {
        get { LanguageManager.shared.selectedLanguage }
        set { LanguageManager.shared.selectedLanguage = newValue }
    }

    func selectLanguage(_ code: String) {
        selectedLanguageCode = code
        // บอก TranslateView ให้ re-render ด้วย (เพราะ selectedLanguageCode ไม่ใช่ @Published)
        objectWillChange.send()
    }
}
