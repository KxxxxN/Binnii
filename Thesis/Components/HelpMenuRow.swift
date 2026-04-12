//
//  HelpMenuRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//


import SwiftUI

struct HelpMenuRow<Destination: View>: View {
    let title: String
    let imageName: String
    let destination: Destination
    let config: ResponsiveConfig // 1. เพิ่ม Config เข้ามา

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: config.accountRowSpacing) {
                Image(imageName)
                    .resizable()
                    .frame(width: config.accountRowIconSize, height: config.accountRowIconSize)
                    .padding(.leading, config.accountRowIconLeading)

                Text(title)
                    .font(.noto(config.accountRowFontSize, weight: .medium))
                    .foregroundColor(Color.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.system(size: config.accountRowChevronSize, weight: .bold))

            }
            .padding(.trailing, config.paddingStandard)
            .frame(height: config.accountRowHeight)
            .background(Color.accountSecColor)
        }
    }
}
