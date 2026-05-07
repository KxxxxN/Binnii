//
//  ContactRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 11/12/2568 BE.
//


import SwiftUI

struct ContactRow: View {
    let title: String
    let imageName: String
    let config: ResponsiveConfig
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: config.accountRowSpacing) {
                Image(imageName)
                    .resizable()
                    .frame(width: config.accountRowIconSize, height: config.accountRowIconSize)
                    .padding(.leading, config.accountRowIconLeading)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.noto(config.accountRowFontSize, weight: .medium)) 
                        .foregroundColor(Color.black)
                }
                
                Spacer()
                
            }
            .padding(.trailing, config.paddingStandard)
            .frame(height: config.accountRowHeight)
            .background(Color.accountSecColor)
        }
    }
}
