//  WasteTypePagination.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 14/12/2568 BE.
//

import SwiftUI


struct WasteTypePagination: View {

    @Binding var currentPage: Int
    let totalItems: Int
    let itemsPerPage: Int

    private var totalPages: Int {
        Int(ceil(Double(totalItems) / Double(itemsPerPage)))
    }

    var body: some View {
        HStack(spacing: 19) {

            // ◀️ Prev
            Button {
                if currentPage > 1 {
                    currentPage -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(
                        currentPage == 1 ? .gray : Color.mainColor
                    )
            }
            .disabled(currentPage == 1)

            // 🔢 Pages
            ForEach(1...totalPages, id: \.self) { page in
                Button {
                    currentPage = page
                } label: {
                    Text("\(page)")
                        .font(.noto(16, weight: .medium))
                        .foregroundColor(
                            currentPage == page ? .white : Color.mainColor
                        )
                        .frame(width: 30, height: 30)
                        .background(
                            currentPage == page
                            ? Color.mainColor
                            : Color.clear
                        )
                        .clipShape(Circle())
                }
            }

            // ▶️ Next
            Button {
                if currentPage < totalPages {
                    currentPage += 1
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .foregroundColor(
                        currentPage == totalPages ? .gray : Color.mainColor
                    )
            }
            .disabled(currentPage == totalPages)
        }
        .padding(.vertical, 16)
    }
}
