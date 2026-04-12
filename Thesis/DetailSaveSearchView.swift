//
//  DetailSaveSearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 12/1/2569 BE.
//


import SwiftUI

struct DetailSaveSearchView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool
    var selectedImage: UIImage
    var category: String
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header Section
                ZStack {
                    Text("ค้นหา")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    
                    HStack {
                        BackButton()
                        Spacer()
                        Button {
                            // Action บันทึก
                        } label: {
                            Text("บันทึก")
                                .font(.noto(16, weight: .medium))
                                .foregroundColor(.mainColor)
                                .padding(.trailing, 25)
                        }
                    }
                }
                .padding(.bottom, 20)

                // MARK: - Content Section
                ScrollView {
                    VStack(spacing: 0) {
                        // 1. รูปภาพสินค้า (อยู่นอกพื้นที่สีครีมเพื่อให้เห็นพื้นหลังสีเขียวข้างหลัง)
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 290)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.bottom, 30) // ระยะห่างก่อนถึงขอบโค้ง
                        
                        
                        // ✅ content ตาม category เหมือน DetailWasteTypeView
                        switch category {
                        case "ขวดพลาสติก":       RecycleWasteDetailPlasticBottle(showDate: true)
                        case "แก้วพลาสติก":       RecycleWasteDetailPlasticCup(showDate: true)
                        case "กระป๋อง":           RecycleWasteDetailCan(showDate: true)
                        case "กล่องกระดาษ":       RecycleWasteDetailCardboardBox(showDate: true)
                        case "กระดาษทั่วไป":      RecycleWasteDetailPaper(showDate: true)
                        case "ถุงพลาสติก":        RecycleWasteDetailPlasticBag(showDate: true)
                        case "เศษอาหาร":          WetWasteDetailFoodscraps(showDate: true)
                        case "เปลือกผลไม้":       WetWasteDetailFruitPeel(showDate: true)
                        case "เศษขนม":            WetWasteDetailCrumbs(showDate: true)
                        case "เปลือกไข่":         WetWasteDetailEggshell(showDate: true)
                        case "เครื่องดื่มเหลือ":  WetWasteDetailLeftoverDrinks(showDate: true)
                        case "น้ำแข็งเหลือ":      WetWasteDetailLeftoverIce(showDate: true)
                        case "ซองขนม":            GeneralWasteDetailSnackBag(showDate: true)
                        case "ภาชนะใส่อาหาร":    GeneralWasteDetailFoodContainer(showDate: true)
                        case "หลอด":              GeneralWasteDetailStraw(showDate: true)
                        case "กระดาษทิชชู่":      GeneralWasteDetailTissue(showDate: true)
                        case "ตะเกียบไม้":        GeneralWasteDetailChopsticks(showDate: true)
                        case "ช้อน-ส้อมพลาสติก": GeneralWasteDetailSpoon(showDate: true)
                        default:
                            Text("ไม่พบข้อมูลประเภทขยะนี้")
                                .font(.noto(18, weight: .medium))
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .frame(minHeight: 750)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationBarHidden(true)
        .onAppear { hideTabBar = true }
    }
}
