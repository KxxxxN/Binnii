//
//  RegisterInputField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI

// MARK: - Input Field Component
struct RegisterInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "จำเป็นต้องระบุ"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?
    
    // 1. เพิ่มตัวแปรรับค่า ResponsiveConfig
    let config: ResponsiveConfig
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RequiredTitle(title: title)
                  
            HStack {
                ZStack(alignment: .leading) {
                    PlaceholderView(text: text, placeholder: placeholder)
                    
                    if isSecure {
                        if isPasswordToggle?.wrappedValue ?? false {
                            TextField("", text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    } else {
                        TextField("", text: $text)
                    }
                }
                
                if isSecure, let isVisible = isPasswordToggle {
                    Button { isVisible.wrappedValue.toggle() } label: {
                        Image(systemName: isVisible.wrappedValue ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.black)
                            .font(.system(size: config.isIPad ? 22 : 18))
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 60 : 49)
            .background(Color.textFieldColor)
            .cornerRadius(config.isIPad ? 25 : 20)
            .modifier(ValidationBorder(isValid: isValid))
                  
            // ข้อความแสดงข้อผิดพลาด
            Group {
                Text(errorMessage)
                    .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .frame(height: config.isIPad ? 25 : 20)
                    .padding(.top, 3)
                    .opacity(isValid ? 0 : 1)
            }
            .clipped()
        }
        .padding(.horizontal, config.paddingStandard)
    }
}
