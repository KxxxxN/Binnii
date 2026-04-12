////
////  ScoreHistoryView (Begin).swift
////  Thesis
////
////  Created by Penpitcha Sureepitak on 22/3/2569 BE.
////
//
//import SwiftUI
//
//struct ScoreHistoryView__Begin_: View {
//        @State private var currentPage = 0
//        @Binding var hideTabBar: Bool
//        @Environment(\.dismiss) var dismiss
//
//        var body: some View {
//            VStack(spacing: 0) {
//                VStack(alignment: .leading, spacing: 0) {
//                    ZStack {
//                        Text("ประวัติคะแนน")
//                            .font(.noto(25, weight: .bold))
//                            .foregroundColor(.white)
//
//                        HStack {
//                            BackButtonWhite()
//
//                            Spacer()
//                        }
//                    }
//                    .padding(.top, 65)
//
//                    HStack(alignment: .center, spacing: 13) {
//                        Image("Profile")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 55, height: 55)
//                            .clipShape(Circle())
//                            .shadow(radius: 4)
//
//                        HStack {
//                            Text("สุนิสา จินดาวัฒนา")
//                                .font(.noto(20, weight: .bold))
//                                .foregroundColor(.white)
//                            Spacer()
//                            VStack(alignment: .trailing) {
//                                Text("0")
//                                    .font(.system(size: 40, weight: .bold))
//                                    .foregroundColor(.white)
//                                Text("คะแนน")
//                                    .font(.noto(15, weight: .regular))
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        .padding(.trailing, 28)
//                    }
//                    .padding(.top, 16)
//                    .padding(.leading, 28)
//                    .padding(.bottom, 30)
//                }
//                .frame(height: 205)
//                .frame(maxWidth: .infinity)
//                .background(
//                    Color.mainColor
//                        .clipShape(
//                            RoundedCorner(
//                                radius: 20,
//                                corners: [.bottomLeft, .bottomRight]
//                            )
//                        )
//                )
//
//                TabView {
//                    PageView()
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                .background(Color.white)
//
//            }
//            .navigationBarHidden(true)
//            .edgesIgnoringSafeArea(.top)
//            .background(Color.white)
//            .onAppear { hideTabBar = true }
//            .onDisappear { hideTabBar = false }
//        }
//    }
