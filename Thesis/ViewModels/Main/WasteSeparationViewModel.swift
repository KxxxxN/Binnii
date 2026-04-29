//
//  WasteSeparationViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 24/4/2569 BE.
//


import SwiftUI
import Combine

final class WasteSeparationViewModel: ObservableObject {

    let totalPages   = 3
    let virtualPages = 300

    @Published var currentIndex: Int = 0

    private var cancellable: AnyCancellable?

    func startAutoScroll() {
        currentIndex = 0
        cancellable = Timer
            .publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                withAnimation(.easeInOut) {
                    self.currentIndex = (self.currentIndex + 1) % self.virtualPages
                }
            }
    }

    func stopAutoScroll() {
        cancellable = nil
    }
}
