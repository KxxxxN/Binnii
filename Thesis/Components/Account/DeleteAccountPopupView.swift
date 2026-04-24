//
//  DeleteAccountPopupView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 23/4/2569 BE.
//


import SwiftUI

struct DeleteAccountPopupView: View {
    @Binding var isPresented: Bool
    var onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 0) {

                Image("WarningIcon")
                    .resizable()
                    .frame(width: 110, height: 110)
                    .padding(.top, 30)

                Text("ลบบัญชี?")
                    .font(.noto(25, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 10)

                VStack(spacing: 2) {
                    Text("ข้อมูลทั้งหมดของคุณจะถูกลบถาวร")
                    Text("และไม่สามารถกู้คืนได้")
                }
                .font(.noto(16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)

                HStack(spacing: 21) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("ยกเลิก")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(width: 120, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.placeholderColor, lineWidth: 1.5)
                            )
                    }

                    Button {
                        isPresented = false
                        onConfirm()
                    } label: {
                        Text("ลบบัญชี")
                            .font(.noto(16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 40)
                            .background(Color.dangerColor)
                            .cornerRadius(20)
                    }
                }
                .padding(.bottom, 24)
            }
            .frame(width: 320, height: 320)
            .padding(.horizontal, 24)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    struct DeleteAccountPopupPreviewContainer: View {
        @State private var isPresented = true

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3).ignoresSafeArea()
                DeleteAccountPopupView(
                    isPresented: $isPresented,
                    onConfirm: { print("Delete confirmed") }
                )
            }
        }
    }

    return DeleteAccountPopupPreviewContainer()
}
