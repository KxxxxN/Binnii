//
//  ProfileInputField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 7/1/2569 BE.
//

import SwiftUI

struct ProfileInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var isInvalid: Bool
    @Binding var isSubmitted: Bool
    var errorMessage: String
    var keyboardType: UIKeyboardType = .default
    var onEditingChanged: () -> Void = {}
    
    let config: ResponsiveConfig
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }


    var body: some View {
        VStack(alignment: .leading, spacing: config.isIPad ? 6 : 4) {
            Title(title: title, config: config)
                .foregroundColor(.black)
                .padding(.leading, 6)

            HStack {
                ZStack(alignment: .leading) {
                    if isEditing {
                        PlaceholderView(text: text, placeholder: placeholder, config: config)
                        
                        TextField("", text: $text)
                            .font(.noto(config.accountRowFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .keyboardType(keyboardType)
                            .onChange(of: text) { oldValue, newValue in
                                onEditingChanged()
                            }
                    } else {
                        Text(text.isEmpty ? L("กรุณาเพิ่มข้อมูล") : text)
                            .font(.noto(config.accountRowFontSize, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.leading, config.paddingMedium)
                
                Spacer()
                
                if isEditing {
                    Image(systemName: "pencil")
                        .font(.system(size: config.isIPad ? 24 : 18))
                        .foregroundColor(.black)
                        .padding(.trailing, config.paddingMedium)
                }
            }
            .frame(width: config.isIPad ? 545 : 345, height: config.isIPad ? 60 : 49)
            .background(Color.textFieldColor)
            .cornerRadius(config.bannerCornerRadius)
            .modifier(ValidationBorder(isValid: isEditing ? !(isSubmitted && isInvalid) : true))
            
            Group {
                Text(isEditing && isSubmitted && isInvalid ? errorMessage : "")
                    .font(.noto(config.fontSubBody, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .padding(.top, -1)
                    .opacity(isEditing && isSubmitted && isInvalid ? 1 : 0)
            }
            .frame(height: config.isIPad ? 26 : 20, alignment: .top)
            .clipped()
            .padding(.leading, 6)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileEmailField: View {
    let title: String
    let email: String
    @Binding var isEditing: Bool
    
    let config: ResponsiveConfig
    
    var body: some View {
        VStack(alignment: .leading, spacing: config.isIPad ? 6 : 4) {
            Title(title: title, config: config)
                .foregroundColor(.black)
                .padding(.leading, 6)
            
            HStack {
                ZStack(alignment: .leading) {
                    if isEditing {
                        NavigationLink(destination: ConfirmPasswordView()) {
                            HStack {
                                Text(email)
                                    .font(.noto(config.accountRowFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: config.isIPad ? 24 : 18))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, config.paddingMedium)
                            .frame(width: config.isIPad ? 545 : 345, height: config.isIPad ? 60 : 49)
                            .overlay(
                                RoundedRectangle(cornerRadius: config.bannerCornerRadius)
                                    .stroke(Color.placeholderColor, lineWidth: config.isIPad ? 3 : 2)
                            )
                            .background(Color.backgroundColor)
                        }
                    } else {
                        HStack {
                            Text(email)
                                .font(.noto(config.accountRowFontSize, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal, config.paddingMedium)
                        .frame(width: config.isIPad ? 545 : 345, height: config.isIPad ? 60 : 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(config.bannerCornerRadius)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Color.clear
                .frame(maxWidth: .infinity, minHeight: config.isIPad ? 26 : 20)
        }
        .frame(width: config.isIPad ? 545 : 345)
        .frame(maxWidth: .infinity)
    }
}

struct ProfilePasswordField: View {
    let title: String
    let password: String
    @Binding var isEditing: Bool
    let currentEmail: String
    let config: ResponsiveConfig
    
    var body: some View {
        VStack(alignment: .leading, spacing: config.isIPad ? 6 : 4) {
            Title(title: title, config: config)
                .foregroundColor(.black)
                .padding(.leading, 6)
            
            HStack {
                ZStack(alignment: .leading) {
                    if isEditing {
                        NavigationLink(destination: ConfirmEmailView(currentEmail: currentEmail)) {
                            HStack {
                                Text(String(repeating: "•", count: 8))
                                    .font(.noto(config.accountRowFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .padding(.top, 5)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: config.isIPad ? 24 : 18))
                                    .foregroundColor(Color.mainColor)
                            }
                            .padding(.horizontal, config.paddingMedium)
                            .frame(width: config.isIPad ? 545 : 345, height: config.isIPad ? 60 : 49)
                            .overlay(
                                RoundedRectangle(cornerRadius: config.bannerCornerRadius)
                                    .stroke(Color.placeholderColor, lineWidth: config.isIPad ? 3 : 2)
                            )
                            .background(Color.backgroundColor)
                        }
                    } else {
                        HStack {
                            Text(String(repeating: "•", count: 8))
                                .font(.noto(config.accountRowFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.top, 5)
                            Spacer()
                        }
                        .padding(.horizontal, config.paddingMedium)
                        .frame(width: config.isIPad ? 545 : 345, height: config.isIPad ? 60 : 49)
                        .background(Color.textFieldColor)
                        .cornerRadius(config.bannerCornerRadius)
                    }
                }
            }
            Color.clear
                .frame(maxWidth: .infinity, minHeight: config.isIPad ? 26 : 20)
        }
        .frame(width: config.isIPad ? 545 : 345)
        .frame(maxWidth: .infinity)
    }
}

#Preview{
    ProfileView()
}
