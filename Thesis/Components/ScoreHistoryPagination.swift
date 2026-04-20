////
////  ScoreHistoryPagination.swift
////  Thesis
////
////  Created by Penpitcha Sureepitak on 14/12/2568 BE.
////
//
//import SwiftUI
//
//struct CustomPaginationView: View {
//    @Binding var currentPage: Int
//    let maxPage: Int
//
//    var pageNumbers: [Int] {
//        let actualTotalPages = maxPage + 1
//        let pagesToShow = min(actualTotalPages, 3)
//        return Array(1...pagesToShow)
//    }
//
//    var body: some View {
//        HStack(spacing: 19) {
//
//            Button(action: {
//                if currentPage > 0 { currentPage -= 1 }
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(currentPage == 0 ? .gray : Color.mainColor)
//                    .font(.system(size: 20))
//            }
//            .disabled(currentPage == 0)
//
//            ForEach(pageNumbers, id: \.self) { page in
//                let pageIndex = page - 1
//                let isSelected = pageIndex == currentPage
//                
//                Button(action: {
//                    if pageIndex <= maxPage {
//                        currentPage = pageIndex
//                    }
//                }) {
//                    Text("\(page)")
//                        .font(.noto(16, weight: .medium))
//                        .foregroundColor(isSelected ? .white : Color.mainColor)
//                        .frame(width: 30, height: 30)
//                        .background(isSelected ? Color.mainColor : Color.clear)
//                        .clipShape(Circle())
//                }
//            }
//
//            Button(action: {
//                if currentPage < maxPage { currentPage += 1 }
//            }) {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(currentPage == maxPage ? .gray : Color.mainColor)
//                    .font(.system(size: 20))
//            }
//            .disabled(currentPage == maxPage)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
