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
    
    // 1. รับ config เข้ามาใช้งาน
    let config: ResponsiveConfig

    var body: some View {
        VStack(alignment: .leading, spacing: config.isIPad ? 6 : 4) {
            // 1. หัวข้อ
            Title(title: title)
            
            // 2. ส่วนของ Input / Text
            HStack {
                ZStack(alignment: .leading) {
                    if isEditing {
                        PlaceholderView(text: text, placeholder: placeholder)
                        
                        TextField("", text: $text)
                            .font(.noto(config.accountRowFontSize, weight: .medium)) // 26 สำหรับ iPad, 20 สำหรับ iPhone
                            .foregroundColor(.black)
                            .keyboardType(keyboardType)
                            .onChange(of: text) { oldValue, newValue in
                                onEditingChanged()
                            }
                    } else {
                        Text(text.isEmpty ? "ไม่ได้ระบุ" : text)
                            .font(.noto(config.accountRowFontSize, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.leading, config.paddingMedium) // 24 สำหรับ iPad, 16 สำหรับ iPhone
                
                Spacer()
                
                if isEditing {
                    Image(systemName: "pencil")
                        .font(.system(size: config.isIPad ? 24 : 18)) // ขยายไอคอนใน iPad
                        .foregroundColor(.black)
                        .padding(.trailing, config.paddingMedium)
                }
            }
            // เปลี่ยนจาก Fixed Width เป็น maxWidth และปรับความสูงตามจอ
            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 65 : 49)
            .background(Color.textFieldColor)
            .cornerRadius(config.bannerCornerRadius) // 25 สำหรับ iPad, 20 สำหรับ iPhone
            .modifier(ValidationBorder(isValid: isEditing ? !(isSubmitted && isInvalid) : true))
            
            // 3. ส่วนแสดงข้อความ Error
            Group {
                Text(isEditing && isSubmitted && isInvalid ? errorMessage : "")
                    .font(.noto(config.fontSubBody, weight: .medium)) // 20 สำหรับ iPad, 15 สำหรับ iPhone
                    .foregroundColor(Color.errorColor)
                    .padding(.top, -1)
                    .opacity(isEditing && isSubmitted && isInvalid ? 1 : 0)
            }
            .frame(height: config.isIPad ? 26 : 20, alignment: .top) // ขยายพื้นที่ Error เล็กน้อยบน iPad
            .clipped()
            .padding(.leading, 7)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileEmailField: View {
    let title: String
    let email: String
    @Binding var isEditing: Bool
    
    // รับ config
    let config: ResponsiveConfig
    
    var body: some View {
        VStack(alignment: .leading, spacing: config.isIPad ? 6 : 4) {
            Title(title: title)
            
            Group {
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
                        .frame(maxWidth: .infinity, minHeight: config.isIPad ? 65 : 49)
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
                    .frame(maxWidth: .infinity, minHeight: config.isIPad ? 65 : 49)
                    .background(Color.textFieldColor)
                    .cornerRadius(config.bannerCornerRadius)
                }
            }
            
            Color.clear
                .frame(maxWidth: .infinity, minHeight: config.isIPad ? 26 : 20)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfilePasswordField: View {
    let title: String
    let password: String
    @Binding var isEditing: Bool
    let currentEmail: String
    
    // รับ config
    let config: ResponsiveConfig
    
    var body: some View {
        VStack(alignment: .leading, spacing: config.isIPad ? 6 : 4) {
            Title(title: title)
            
            Group {
                if isEditing {
                    NavigationLink(destination: ConfirmEmailView(currentEmail: currentEmail)) {
                        HStack {
                            Text(String(repeating: "•", count: 8))
                                .font(.noto(config.accountRowFontSize, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.top, 5) // ช่วยให้จุดไข่ปลาอยู่กึ่งกลางขึ้น
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: config.isIPad ? 24 : 18))
                                .foregroundColor(Color.mainColor)
                        }
                        .padding(.horizontal, config.paddingMedium)
                        .frame(maxWidth: .infinity, minHeight: config.isIPad ? 65 : 49)
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
                    .frame(maxWidth: .infinity, minHeight: config.isIPad ? 65 : 49)
                    .background(Color.textFieldColor)
                    .cornerRadius(config.bannerCornerRadius)
                }
            }
            
            Color.clear
                .frame(maxWidth: .infinity, minHeight: config.isIPad ? 26 : 20)
        }
        .frame(maxWidth: .infinity)
    }
}
