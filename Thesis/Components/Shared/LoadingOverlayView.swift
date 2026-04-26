////
////  LoadingOverlayView.swift
////  Thesis
////
////  Created by Kansinee Klinkhachon on 25/4/2569 BE.
////
//
//
//// LoadingOverlayView.swift
//
//import SwiftUI
//
//struct LoadingOverlayView: View {
//    @State private var isAnimating = false
//    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                Image("LoadingIcon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
//                    .onAppear {
//                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
//                            isAnimating = true
//                        }
//                    }
//
//                Text("กำลังโหลดข้อมูล...")
//                    .font(.noto(25, weight: .bold))
//                    .foregroundColor(.black)
//                    .padding(.top, 30)
//
//                Text("กรุณารอสักครู่")
//                    .font(.noto(18, weight: .medium))
//                    .foregroundColor(.gray)
//            }
//            .frame(width: 320, height: 320)
//            .padding(.horizontal, 24)
//            .background(Color.white)
//            .cornerRadius(20)
//        }
//        .onAppear {
//            isAnimating = true
//        }
//    }
//}
//
//#Preview {
//    LoadingOverlayView()
//}
