//
//  FormComponents.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 27/11/2568 BE.
//

// FormComponents.swift

import SwiftUI

// MARK: - Required Title Component
struct RequiredTitle: View {
    let title: String
    let config: ResponsiveConfig
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.noto(config.fontHeader, weight: .bold))
            
            Text(" *")
                .font(.noto(config.fontHeader, weight: .bold))
                .foregroundColor(.red)
        }
    }
}

struct Title : View {
    let title: String
    let config: ResponsiveConfig
    
    var body: some View {
        Text(title)
            .font(.noto(config.fontHeader, weight: .bold))
    }
}

// MARK: - Placeholder View Helper
struct PlaceholderView: View {
    let text: String
    let placeholder: String
    let config: ResponsiveConfig
    
    var body: some View {
        HStack {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.placeholderColor)
                    .font(.noto(config.fontSubHeader , weight: .medium))
            }
            Spacer()
        }
        .allowsHitTesting(false)
    }
}

// MARK: - View Modifier (ValidationBorder)
struct ValidationBorder: ViewModifier {
    let isValid: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isValid ? Color.clear : Color.errorColor, lineWidth: isValid ? 0 : 2)
            )
    }
}
