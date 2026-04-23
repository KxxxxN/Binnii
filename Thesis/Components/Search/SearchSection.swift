//
//  SearchSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct SearchSection: View {
    let config: ResponsiveConfig
    @Binding var hideTabBar: Bool
    @Binding var searchText: String
    let searchItems: [String]
    var onSelectItem: (String) -> Void
    var isFocused: FocusState<Bool>.Binding

    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(config: config, searchText: $searchText, isFocused: isFocused)

            if !searchText.isEmpty {
                VStack(spacing: 0) {
                    if searchItems.isEmpty {
                        Text("ไม่พบรายการที่ค้นหา")
                            .font(.noto(config.buttonFont, weight: .bold))
                            .foregroundColor(.gray)
                            .frame(height: config.buttonHeight)
                            .padding(.vertical, config.isIPad ? 20 : 10)
                    } else {
                        ForEach(searchItems.indices, id: \.self) { index in
                            VStack(spacing: 0) {
                                NavigationLink {
                                    DetailSearchView(hideTabBar: $hideTabBar, category: searchItems[index])
                                } label: {
                                    HStack {
                                        Text(searchItems[index])
                                            .font(.noto(config.buttonFont, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding(.vertical, config.isIPad ? 16 : 11)
                                }

                                if index < searchItems.count - 1 {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, config.isIPad ? 30 : 20)
                .padding(.top, config.isIPad ? 16 : 10)
                .padding(.bottom, config.isIPad ? 20 : 10)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.searchColor)
        )
        .onChange(of: isFocused.wrappedValue) {
            withAnimation(.easeInOut(duration: 0.25)) {
                isExpanded = isFocused.wrappedValue
            }
        }
        .onChange(of: searchText) {
            if !searchText.isEmpty {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded = true
                }
            }
        }
    }
}

struct SearchBar: View {
    let config: ResponsiveConfig
    @Binding var searchText: String
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(spacing: config.isIPad ? 12 : 8) {
            TextField("ค้นหา", text: $searchText)
                .font(.noto(config.buttonFont))
                .focused(isFocused)
                .padding(.leading, config.isIPad ? 35 : 23)

            Button { } label: {
                Image("SearchBlack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.isIPad ? 45 : 37,
                           height: config.isIPad ? 45 : 37)
            }
            .padding(.trailing, config.isIPad ? 35 : 23)
        }
        .frame(height: config.buttonHeight)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.textFieldColor)
        )
    }
}
