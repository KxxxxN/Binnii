//
//  PaginationSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 25/3/2569 BE.
//

import SwiftUI

struct PaginationSection: View {
    @Binding var currentPage: Int
    let totalPages: Int

    var body: some View {
        HStack(spacing: 19) {
            Button(action: { if currentPage > 1 { currentPage -= 1 } }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(currentPage == 1 ? .gray : Color.mainColor)
                    .font(.system(size: 20))
            }
            .disabled(currentPage == 1)

            ForEach(1...max(1, totalPages), id: \.self) { page in
                Button(action: { currentPage = page }) {
                    Text("\(page)")
                        .font(.noto(16, weight: .medium))
                        .foregroundColor(currentPage == page ? .white : Color.mainColor)
                        .frame(width: 30, height: 30)
                        .background(currentPage == page ? Color.mainColor : Color.clear)
                        .clipShape(Circle())
                }
            }

            Button(action: { if currentPage < totalPages { currentPage += 1 } }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(currentPage == totalPages ? .gray : Color.mainColor)
                    .font(.system(size: 20))
            }
            .disabled(currentPage == totalPages)
        }
    }
}
