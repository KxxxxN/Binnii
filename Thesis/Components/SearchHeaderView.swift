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
            Color.clear.frame(width: config.isIPad ? 40 : 25)
        }
        .padding(.trailing, config.isIPad ? 30 : 18)
        .padding(.top, config.searchHeaderTopPadding)
        .padding(.bottom, config.isIPad ? 40 : 27)
        .frame(maxWidth: .infinity)
        .frame(height: config.searchHeaderHeight)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }
}
