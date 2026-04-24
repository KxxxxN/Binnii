//
//  DeleteAccountSuccessView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 23/4/2569 BE.
//

import SwiftUI

struct DeleteAccountSuccessView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

            VStack(spacing: 0) {
                Spacer()

                Image("Passmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: config.isIPad ? 160 : 120, height: config.isIPad ? 160 : 120)
                    .padding(.bottom, config.isIPad ? 40 : 29)

                Text("ลบบัญชีสำเร็จ")
                    .font(.noto(config.fontTitle, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.bottom, config.isIPad ? 16 : 12)

                VStack(spacing: config.isIPad ? 6 : 4) {
                    Text("บัญชีของคุณถูกลบเรียบร้อยแล้ว")
                    Text("ขอบคุณที่ร่วมใช้งานกับเรา")
                    Text("คุณสามารถสมัครใช้งานใหม่ได้ทุกเมื่อ")
                }
                .font(.noto(config.fontBody, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

                Spacer()

                Button {
                    dismiss()
                    authViewModel.session = nil
                    authViewModel.isAuthenticated = false
                    isLoggedIn = false
                } label: {
                    Text("กลับสู่หน้าหลัก")
                        .font(.noto(config.isIPad ? 24 : 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: config.isIPad ? 500 : .infinity)
                        .frame(height: config.isIPad ? 70 : 58)
                        .background(Color.mainColor)
                        .cornerRadius(config.isIPad ? 25 : 20)
                        .padding(.horizontal, config.isIPad ? 0 : 24)
                }
                .padding(.bottom, config.isIPad ? 60 : 80)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    DeleteAccountSuccessView()
}
