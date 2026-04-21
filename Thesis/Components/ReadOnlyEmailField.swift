//
//  ReadOnlyEmailField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/2/2569 BE.
//


import SwiftUI

struct ReadOnlyEmailField: View {
    let title: String
    let email: String
    let config: ResponsiveConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Title(title: title)
            
            HStack {
                Text(email)
                    .font(.noto(config.isIPad ? 20 : 17, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.leading, config.isIPad ? 20 : 15)
                
                Spacer()
                
                Image(systemName: "lock.fill")
                    .font(.system(size: config.isIPad ? 24 : 20))
                    .foregroundColor(.placeholderColor)
                    .padding(.trailing, config.isIPad ? 20 : 15)
            }
//            .frame(maxWidth: .infinity, maxHeight: config.isIPad ? 60 : 49)
            .frame(maxWidth: config.isIPad ? .infinity : 345, maxHeight: config.isIPad ? 60 : 49)
            .background(Color.textFieldColor)
            .cornerRadius(config.isIPad ? 25 : 20)
            .opacity(0.6)
        }
    }
}
