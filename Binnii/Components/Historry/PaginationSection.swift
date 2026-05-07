//
//  PaginationSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 25/3/2569 BE.
//

import SwiftUI

struct PaginationSection: View {
    let config: ResponsiveConfig
    @Binding var currentPage: Int
    let totalPages: Int

    private var visiblePages: [Int] {
        guard totalPages > 0 else { return [] }

        let windowSize = 5
        var start = currentPage - 2       
        var end   = start + windowSize - 1

        if start < 1 {
            start = 1
            end   = min(windowSize, totalPages)
        }
        if end > totalPages {
            end   = totalPages
            start = max(1, end - windowSize + 1)
        }

        return Array(start...end)
    }

    var body: some View {
        HStack(spacing: config.paginationSpacing) {
            Button(action: { if currentPage > 1 { currentPage -= 1 } }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(currentPage == 1 ? .gray : Color.mainColor)
                    .font(.system(size: config.fontHeader))
            }
            .disabled(currentPage == 1)

            if visiblePages.first ?? 1 > 1 {
                Text("...")
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(Color.mainColor)
            }

            ForEach(visiblePages, id: \.self) { page in
                Button(action: { currentPage = page }) {
                    Text("\(page)")
                        .font(.noto(config.fontBody, weight: .medium))
                        .foregroundColor(currentPage == page ? .white : Color.mainColor)
                        .frame(width: config.paginationButtonSize,
                               height: config.paginationButtonSize)
                        .background(currentPage == page ? Color.mainColor : Color.clear)
                        .clipShape(Circle())
                }
            }

            if visiblePages.last ?? totalPages < totalPages {
                Text("...")
                    .font(.noto(config.fontBody, weight: .medium))
                    .foregroundColor(Color.mainColor)
            }

            Button(action: { if currentPage < totalPages { currentPage += 1 } }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(currentPage == totalPages ? .gray : Color.mainColor)
                    .font(.system(size: config.fontHeader))
            }
            .disabled(currentPage == totalPages)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, config.paddingMedium)
    }
}
