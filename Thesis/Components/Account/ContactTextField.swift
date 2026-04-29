//
//  ContactTextField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 29/4/2569 BE.
//


import SwiftUI

struct ContactTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    let config: ResponsiveConfig
    var showError: Bool = false
    var isEmailField: Bool = false
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    private var isInvalidEmail: Bool {
        guard isEmailField, showError, !text.isEmpty else { return false }
        return !ValidationHelper.isValidEmail(text)
    }

    private var errorMessage: String {
        if showError && text.isEmpty {
            return L("จำเป็นต้องระบุ")
        } else if isInvalidEmail {
            return L("รูปแบบอีเมลไม่ถูกต้อง")
        }
        return ""
    }

    private var showBorder: Bool {
        (showError && text.isEmpty) || isInvalidEmail
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Title(title: title, config: config)
                    .padding(.leading, 6)
                    .foregroundColor(.black)
                Text("*")
                    .font(.noto(config.fontHeader, weight: .bold))
                    .foregroundColor(.errorColor)
            }
            TextField(placeholder, text: $text)
                .font(.noto(config.fontSubHeader, weight: .medium))
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .padding()
                .frame(height: config.isIPad ? 60 : 49)
                .background(Color.textFieldColor)
                .cornerRadius(config.bannerCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: config.bannerCornerRadius)
                        .stroke(Color.errorColor, lineWidth: showBorder ? 1.5 : 0)
                )
            Group {
                Text(errorMessage)
                    .font(.noto(config.fontSubBody, weight: .medium))
                    .foregroundColor(.errorColor)
                    .opacity(errorMessage.isEmpty ? 0 : 1)
            }
            .frame(height: config.isIPad ? 26 : 18, alignment: .top)
            .padding(.top, -1)
            .clipped()
            .padding(.leading, 6)
        }
        .frame(width: config.isIPad ? 445 : 345)
    }
}

struct ContactTextEditor: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let config: ResponsiveConfig
    var showError: Bool = false
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Title(title: title, config: config)
                    .padding(.leading, 6)
                    .foregroundColor(.black)
                Text("*")
                    .font(.noto(config.fontHeader, weight: .bold))
                    .foregroundColor(.errorColor)
            }
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.noto(config.fontSubHeader, weight: .medium))
                        .foregroundColor(Color(.placeholderText))
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 12)
                        .padding()
                }
                TextEditor(text: $text)
                    .font(.noto(config.fontSubHeader, weight: .medium))
                    .padding()
                    .frame(minHeight: 180)
                    .scrollContentBackground(.hidden)
            }
            .background(Color.textFieldColor)
            .cornerRadius(config.bannerCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: config.bannerCornerRadius)
                    .stroke(Color.errorColor, lineWidth: showError ? 1.5 : 0)
            )
            Group {
                Text(showError ? L("จำเป็นต้องระบุ") : "")
                    .font(.noto(config.fontSubBody, weight: .medium))
                    .foregroundColor(.errorColor)
                    .opacity(showError ? 1 : 0)
            }
            .frame(height: config.isIPad ? 26 : 18, alignment: .top)
            .clipped()
            .padding(.top,-1)
            .padding(.leading, 6)
        }
        .frame(width: config.isIPad ? 445 : 345)
    }
}

#Preview {
    ContactUsView()
}
