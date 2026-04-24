//
//  TranslateViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import Foundation

@MainActor
final class TranslateViewModel: ObservableObject {

    @Published var selectedLanguageCode: String = "TH"

    let languages: [Language] = [
        Language(code: "TH", name: "ภาษาไทย", image: "Thai"),
        Language(code: "EN", name: "English",  image: "English")
    ]

    func selectLanguage(_ code: String) {
        selectedLanguageCode = code
    }
}
