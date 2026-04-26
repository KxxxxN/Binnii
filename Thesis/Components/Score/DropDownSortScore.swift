//
//  DropDownSortScore.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/12/2568 BE.
//

import SwiftUI

struct DropdownOverlay: View {
    @Binding var items: [ScoreItem]
    @Binding var currentPage: Int
    @Binding var isOpen: Bool
    @Binding var selectedSort: SortType

    init(
        items: Binding<[ScoreItem]>,
        currentPage: Binding<Int>,
        isOpen: Binding<Bool>,
        selectedSort: Binding<SortType>
    ) {
        self._items = items
        self._currentPage = currentPage
        self._isOpen = isOpen
        self._selectedSort = selectedSort
    }

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    private var menuItems: [SortType] = [.newest, .oldest, .highToLow, .lowToHigh]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(menuItems, id: \.self) { item in
                Button {
                    selectedSort = item
                    sortItems()
                    withAnimation { isOpen = false }
                } label: {
                    HStack {
                        Text(item.title(L))
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(
                                item == selectedSort ? .white : .mainColor
                            )
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 40)
                    .background(
                        item == selectedSort
                        ? Color.mainColor
                        : Color.white
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: 165, height: 160)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        .offset(y: 45)
        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
    }
    
    private func date(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
    
    private func compareDatesNewestFirst(item1: ScoreItem, item2: ScoreItem) -> Bool {
        let date1 = date(from: item1.date) ?? Date.distantPast
        let date2 = date(from: item2.date) ?? Date.distantPast
        return date1 > date2
    }
    
    private func cleanPoints(_ points: String) -> Int {
        let isNegative = points.hasPrefix("-")
        let cleanString = points.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "")
        let value = Int(cleanString) ?? 0
        return isNegative ? -value : value
    }

    private func sortItems() {
        switch selectedSort {
        case .newest:
            items.sort { date(from: $0.date) ?? Date.distantPast > date(from: $1.date) ?? Date.distantPast }
        case .oldest:
            items.sort { date(from: $0.date) ?? Date.distantPast < date(from: $1.date) ?? Date.distantPast }
        case .highToLow:
            items.sort { item1, item2 in
                let points1 = cleanPoints(item1.points)
                let points2 = cleanPoints(item2.points)
                if points1 != points2 {
                    return points1 > points2
                } else {
                    return compareDatesNewestFirst(item1: item1, item2: item2)
                }
            }
        case .lowToHigh:
            items.sort { item1, item2 in
                let points1 = cleanPoints(item1.points)
                let points2 = cleanPoints(item2.points)
                if points1 != points2 {
                    return points1 < points2
                } else {
                    return compareDatesNewestFirst(item1: item1, item2: item2)
                }
            }
        }
        currentPage = 1
    }
}

