//
//  ChangePasswordField.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//
import SwiftUI

struct ChangePasswordField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @Binding var isValid: Bool
    var errorMessage: String = "กรุณากรอกรหัสผ่าน"
    var isSecure: Bool = false
    var isPasswordToggle: Binding<Bool>?

    let config: ResponsiveConfig

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Title(title: L(title), config: config)
                .foregroundColor(.black)


            HStack {
                ZStack(alignment: .leading) {
                    PlaceholderView(text: text, placeholder: L(placeholder), config: config)

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
            .frame(maxWidth: config.isIPad ? 445 : 345, maxHeight: config.isIPad ? 60 : 49)
            .background(Color.textFieldColor)
            .cornerRadius(config.isIPad ? 25 : 20)
            .modifier(ValidationBorder(isValid: isValid))

            Group {
                Text(L(errorMessage))
                    .font(.noto(config.isIPad ? 18 : 15, weight: .medium))
                    .foregroundColor(Color.errorColor)
                    .opacity(isValid ? 0 : 1)
            }
            .frame(height: config.isIPad ? 25 : 20, alignment: .top)
            .clipped()
            .padding(.leading, 6)
            .padding(.top, 4)
        }
        .padding(.horizontal, config.paddingStandard)
    }
}

#Preview {
    ChangePasswordView()
}
