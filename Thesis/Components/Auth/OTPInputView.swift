//
//  OTPInputView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//

import SwiftUI

// MARK: - Otp Input
struct OTPInputView: View {
    @ObservedObject var viewModel: OTPConfirmViewModel
    @FocusState.Binding var focusedField: Int?
    
    let config: ResponsiveConfig
    
    private func borderColor(for index: Int) -> Color {
        if viewModel.isSubmitted && viewModel.isFieldInvalid[index] {
            return Color.errorColor
        } else {
            return Color.clear
        }
    }
    
    var body: some View {
        HStack(spacing: config.isIPad ? 15 : 7) {
            ForEach(0..<6, id: \.self) { index in
                TextField("", text: $viewModel.otpFields[index])
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(
                        width: config.isIPad ? 80 : 60,
                        height: config.isIPad ? 100 : 75
                    )
                    .background(Color.textFieldColor)
                    .cornerRadius(config.isIPad ? 25 : 20)
                    .font(.noto(config.isIPad ? 40 : 30, weight: .medium))
                    .overlay(
                        RoundedRectangle(cornerRadius: config.isIPad ? 25 : 20)
                            .stroke(borderColor(for: index), lineWidth: 2)
                    )
                    .focused($focusedField, equals: index)
                    .onChange(of: viewModel.otpFields[index]) { oldValue, newValue in
                        guard newValue != oldValue else { return }

                        if newValue.count > 1 {
                            viewModel.otpFields[index] = String(newValue.last!)
                        }

                        let nextIndex = viewModel.handleOTPChange(index: index, newValue: newValue)

                        DispatchQueue.main.async {
                            focusedField = nextIndex
                        }
                    }
            }
        }
    }
}
