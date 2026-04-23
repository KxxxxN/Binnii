//
//  MenuSection.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 21/4/2569 BE.
//


import SwiftUI

struct MenuSection<Content: View>: View {
    let title: String
    let fontSize: CGFloat
    var titleColor: Color = .black
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.noto(fontSize, weight: .bold))
                .foregroundColor(titleColor)
                .padding(.horizontal, 20)
            
            content()
        }
    }
}
