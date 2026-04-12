////
////  SaveSearchPhotoView.swift
////  Thesis
////
////  Created by Penpitcha Sureepitak on 10/1/2569 BE.
////
//
//import SwiftUI
//import PhotosUI
//
//struct SaveSearchPhotoView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Binding var hideTabBar: Bool
//    @State private var showDetailSaveSearchView = false
//
//    @State private var isFlashOn = false
//    @State private var selectedItem: PhotosPickerItem? = nil
//    var selectedImage: UIImage
//    var category: String
//
//    var body: some View {
//            ZStack(alignment: .top) {
//
//                GeometryReader { geo in
//                    ZStack {
//                        Image(uiImage: selectedImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .clipped()
//                            .background(Color.cameraBackground)
//                    }
//                    .ignoresSafeArea()
//                }
//
//                VStack(spacing: 0) {
//
//                    headerView
//
//                    VStack {
//                        
//                        Spacer()
//                        // สามารถเพิ่ม preview, caption, หรือ UI อื่นได้
//                    }
//                }
//            }
//            .navigationDestination(isPresented: $showDetailSaveSearchView) {
//                DetailSaveSearchView(
//                    hideTabBar: $hideTabBar,
//                    selectedImage: selectedImage,
//                    category: category  // ✅ ส่งต่อ
//                )
//            }
//            .navigationBarHidden(true)
//    }
//
//    var headerView: some View {
//        HStack {
//            BackButton()
//            Color.clear.frame(width: 15,height: 15)
//            
//            Spacer()
//            
//            Text("ยืนยันภาพถ่าย")
//                .font(.noto(25, weight: .bold))
//                .foregroundColor(.black)
//            Spacer()
//            Button {
//                hideTabBar = true
//                showDetailSaveSearchView = true
//            } label: {
//                Text("บันทึก")
//                    .font(.noto(16, weight: .medium))
//                    .foregroundColor(.mainColor)
//            }
//        }
//        .padding(.trailing, 18)
//        .padding(.bottom, 18)
//        .frame(maxWidth: .infinity)
//        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
//    }
//}
//
