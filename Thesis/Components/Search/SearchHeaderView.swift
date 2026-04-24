//
//  SearchHeaderView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


import SwiftUI

struct SearchHeaderView: View {
    let config: ResponsiveConfig

    var body: some View {
        ZStack {
            Text("ค้นหา")
                .font(.noto(config.fontTitle, weight: .bold))
                .foregroundColor(.black)
            HStack {
                BackButton()
                Spacer()
            }
        }
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.bottomTitlePadding)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        SearchView(
            hideTabBar: .constant(false),
            currentTab: .constant(.search),
            slideDirection: .constant(0)
        )
    }
}
