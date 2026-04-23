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
                            // ใช้สถานะ isFieldInvalid จาก ViewModel
                            .stroke(borderColor(for: index), lineWidth: 2)
                    )
                    // ผูก focus state กับ index
                    .focused($focusedField, equals: index)
                    // ใช้ .onChange เพื่อจัดการ Logic ผ่าน ViewModel
                    .onChange(of: viewModel.otpFields[index]) { oldValue, newValue in
                        // ป้องกัน Logic ทำงานตอนที่เราสั่งล้างค่า หรือค่าไม่ได้เปลี่ยนจริง
                        guard newValue != oldValue else { return }
                        
                        // ถ้าพิมพ์เกิน 1 ตัว (เช่น พิมพ์ทับตัวเดิม) ให้ตัดเหลือตัวเดียวทันที
                        if newValue.count > 1 {
                            viewModel.otpFields[index] = String(newValue.last!)
                        }
                        
                        // หา Index ที่ต้อง Focus ต่อ
                        let nextIndex = viewModel.handleOTPChange(index: index, newValue: newValue)
                        
                        // ใช้ DispatchQueue เพื่อให้ UI คืนค่า TextField ให้เสร็จก่อนเปลี่ยน Focus
                        DispatchQueue.main.async {
                            focusedField = nextIndex
                        }
                    }
            }
        }
    }
}
