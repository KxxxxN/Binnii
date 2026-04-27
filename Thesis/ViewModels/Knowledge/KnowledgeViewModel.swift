//
//  KnowledgeViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

@MainActor
final class KnowledgeViewModel: ObservableObject {

    @Published var currentIndex: Int = 0
    
    // Observe LanguageManager so when language changes, categories recompute
    @ObservedObject private var languageManager: LanguageManager

    init(languageManager: LanguageManager = .shared) {
        self.languageManager = languageManager
    }

    // Compute categories from current language
    var wasteCategories: [WasteCategory] {
        WasteData.categories(lm: languageManager)
    }

    var current: WasteCategory { wasteCategories[currentIndex] }
    var canGoPrevious: Bool { currentIndex > 0 }
    var canGoNext: Bool { currentIndex < wasteCategories.count - 1 }

    func previous() {
        guard canGoPrevious else { return }
        withAnimation(.easeInOut) { currentIndex -= 1 }
    }

    func next() {
        guard canGoNext else { return }
        withAnimation(.easeInOut) { currentIndex += 1 }
    }
}
