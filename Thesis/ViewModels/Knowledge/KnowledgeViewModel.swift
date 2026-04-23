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

    // ✅ ดึงจาก WasteData แทน
    let wasteCategories: [WasteCategory] = WasteData.categories

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
