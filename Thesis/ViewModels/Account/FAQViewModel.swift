//
//  FAQViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 21/4/2569 BE.
//


import Foundation

@MainActor
final class FAQViewModel: ObservableObject {
    
    @Published var faqItems: [FAQItem] = []
    
    private let lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    init() {
        loadFAQItems()
    }
    
    private func loadFAQItems() {
        faqItems = [
            FAQItem(
                question: L("faq_q1"),
                answer: L("faq_a1")
            ),
            FAQItem(
                question: L("faq_q2"),
                answer: L("faq_a2")
            ),
            FAQItem(
                question: L("faq_q3"),
                answer: L("faq_a3")
            ),
            FAQItem(
                question: L("faq_q4"),
                answer: L("faq_a4")
            ),
            FAQItem(
                question: L("faq_q5"),
                answer: L("faq_a5")
            )
        ]
    }
}
