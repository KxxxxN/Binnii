//
//  DetailSearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 9/1/2569 BE.
//

import SwiftUI

struct DetailSearchView: View {
//    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool
    @State private var showConfirmPhotoView = false
    
    let category: String

    private func imageForCategory(_ category: String) -> String {
        switch category {
        case "ขวดพลาสติก":  return "TypeBottle1"
        case "แก้วพลาสติก":  return "TypePlasticCup"
        case "กระป๋อง":      return "TypeCan"
        case "กล่องกระดาษ":  return "TypeCardboard"
        case "กระดาษทั่วไป": return "TypePaper"
        case "ถุงพลาสติก":   return "TypePlasticBag"
        case "เศษอาหาร":     return "TypeFood"
        case "เปลือกผลไม้":  return "TypeFruit"
        case "เศษขนม":       return "TypeSnack"
        case "เปลือกไข่":    return "TypeEgg"
        case "เครื่องดื่มเหลือ": return "TypeDrink"
        case "น้ำแข็งเหลือ": return "TypeIce"
        case "ซองขนม":       return "TypeSnackBag"
        case "ภาชนะใส่อาหาร": return "TypeContainer"
        case "หลอด":         return "TypeStraw"
        case "กระดาษทิชชู่": return "TypeTissue"
        case "ตะเกียบไม้":   return "TypeChopstick"
        case "ช้อน-ส้อมพลาสติก": return "TypeSpoon"
        default:             return "TypeBottle1"
        }
    }

    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header Section
                ZStack {
                    Text("ค้นหา")
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)
                    HStack {
                        BackButton()
                        Spacer()
                    }
                }
                .padding(.bottom, 27)

                // MARK: - Content
                ScrollView {
                    Image(imageForCategory(category))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 290)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Spacer().frame(height: 23)
                    
                    VStack(spacing: 0) {
                        // แสดง component ตาม category
                        switch category {
                        case "ขวดพลาสติก":       RecycleWasteDetailPlasticBottle()
                        case "แก้วพลาสติก":       RecycleWasteDetailPlasticCup()
                        case "กระป๋อง":           RecycleWasteDetailCan()
                        case "กล่องกระดาษ":       RecycleWasteDetailCardboardBox()
                        case "กระดาษทั่วไป":      RecycleWasteDetailPaper()
                        case "ถุงพลาสติก":        RecycleWasteDetailPlasticBag()
                        case "เศษอาหาร":          WetWasteDetailFoodscraps()
                        case "เปลือกผลไม้":       WetWasteDetailFruitPeel()
                        case "เศษขนม":            WetWasteDetailCrumbs()
                        case "เปลือกไข่":         WetWasteDetailEggshell()
                        case "เครื่องดื่มเหลือ":  WetWasteDetailLeftoverDrinks()
                        case "น้ำแข็งเหลือ":      WetWasteDetailLeftoverIce()
                        case "ซองขนม":            GeneralWasteDetailSnackBag()
                        case "ภาชนะใส่อาหาร":    GeneralWasteDetailFoodContainer()
                        case "หลอด":              GeneralWasteDetailStraw()
                        case "กระดาษทิชชู่":      GeneralWasteDetailTissue()
                        case "ตะเกียบไม้":        GeneralWasteDetailChopsticks()
                        case "ช้อน-ส้อมพลาสติก": GeneralWasteDetailSpoon()
                        default:
                            Text("ไม่พบข้อมูลประเภทขยะนี้")
                                .font(.noto(18, weight: .medium))
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        hideTabBar = true
                        showConfirmPhotoView = true
                    } label: {
                        HStack {
                            Text("ยืนยันภาพถ่าย")
                                .font(.noto(20, weight: .bold))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 175, height: 49)
                        .background(Color.mainColor)
                        .cornerRadius(20)
                    }
                    .padding(.trailing, 25)
                    .padding(.bottom, 25)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationDestination(isPresented: $showConfirmPhotoView) {
            ConfirmPhotoView(hideTabBar: $hideTabBar, category: category)
        }
        .navigationBarHidden(true)
        .onAppear { hideTabBar = true }
    }
}
struct PlasticbottleStep {
    let imageName: String
    let text: String
    let imageSize: CGSize
}

#Preview {
    DetailSearchView(hideTabBar: .constant(false), category: "ขวดพลาสติก")
}

