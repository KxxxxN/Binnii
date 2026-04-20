// Models.swift
import Foundation

struct HistoryItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let points: String
    let pointsLabel: String
}

struct RecyclableItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let countNumber: Int
//    let count: String
}

struct NavigationItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    var isActive: Bool
}
