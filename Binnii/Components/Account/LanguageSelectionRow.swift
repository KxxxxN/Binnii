//
//  LanguageSelectionRow.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI

struct LanguageSelectionRow: View {
    let code: String
    let name: String
    let imageName: String
    let selectedCode: String
    let action: (String) -> Void
    
    var isSelected: Bool {
        selectedCode == code
    }

    var body: some View {
        Button(action: {
            action(code) 
            print("\(name) selected")
        }) {
            HStack(spacing: 15) {
                Image(imageName)
                    .resizable()
                    .frame(width: 43, height: 43) 
                    .padding(.leading, 31)

                Text(name)
                    .font(.noto(20, weight: .medium))
                    .foregroundColor(Color.black)

                Spacer()

                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.mainColor : Color.mainColor.opacity(0.5), lineWidth: 2)
                        .frame(width: 25, height: 25)

                    if isSelected {
                        Circle()
                            .fill(Color.mainColor)
                            .frame(width: 15, height: 15)
                    }
                }
            }
            .padding(.trailing)
            .frame(height: 93)
            .background(Color.accountSecColor)
        }
    }
}
