//
//  SearchViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


//  ViewModels/SearchViewModel.swift

import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var searchText: String = ""

    var filteredItems: [String] {
        let allLabels = WasteData.allExamples(lm: LanguageManager.shared).map { $0.label }
        if searchText.isEmpty { return allLabels }
        return allLabels.filter {
            $0.localizedCaseInsensitiveContains(searchText)
        }
    }
}
