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
        HStack {
            BackButton()
            Spacer()
            Text("ค้นหา")
                .font(.noto(config.titleFontSize, weight: .bold))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.trailing, config.isIPad ? 30 : 18)
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
