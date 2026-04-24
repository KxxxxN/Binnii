//
//  ExchangeConfirmPopupView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 24/4/2569 BE.
//


import SwiftUI

struct ExchangeConfirmPopupView: View {
    @Binding var isPresented: Bool
    var onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 0) {

                Text("ยืนยันการแลกคะแนน")
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 40)

                Text("ต้องการใช้ 500 คะแนน\nแลก 5 ชั่วโมงจิตอาสาใช่หรือไม่?")
                    .font(.noto(16, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                    .padding(.bottom, 40)

                HStack(spacing: 21) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("ยกเลิก")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(.mainColor)
                            .frame(width: 120, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.mainColor, lineWidth: 1.5)
                            )
                    }

                    Button {
                        isPresented = false
                        onConfirm()
                    } label: {
                        Text("ยืนยัน")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 40)
                            .background(Color.mainColor)
                            .cornerRadius(20)
                    }
                }
                .padding(.bottom, 24)
            }
            .frame(width: 320, height: 260)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 32)
        }
    }
}
