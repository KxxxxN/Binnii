//
//  DetailWasteHeader.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 22/4/2569 BE.
//


//  Components/DetailWasteHeader.swift

import SwiftUI

struct DetailWasteHeader: View {
    let title: String
    let config: ResponsiveConfig

    var body: some View {
        ZStack {
            Text(title)
                .font(.noto(config.fontTitle, weight: .bold))
                .foregroundColor(.black)
            HStack {
                BackButton()
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, config.isIPad ? 40 : 27)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }
}
