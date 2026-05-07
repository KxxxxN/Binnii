//
//  DropDownSortScore.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/12/2568 BE.
//

import SwiftUI

struct DropdownOverlay: View {
    @Binding var currentPage: Int
    @Binding var isOpen: Bool
    @Binding var selectedSort: SortType

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    private var menuItems: [SortType] = [.newest, .oldest, .highToLow, .lowToHigh]

    // Explicit internal initializer to avoid any access control ambiguity
    init(currentPage: Binding<Int>, isOpen: Binding<Bool>, selectedSort: Binding<SortType>) {
        self._currentPage = currentPage
        self._isOpen = isOpen
        self._selectedSort = selectedSort
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(menuItems, id: \.self) { item in
                Button {
                    selectedSort = item
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
}
