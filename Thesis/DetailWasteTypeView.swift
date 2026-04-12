//
//  DetailWasteTypeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct DetailWasteTypeView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    let category: String
    
    private func imageForCategory(_ category: String) -> String {
        switch category {
        case "ขวดพลาสติก":  return "TypeBottle"
        case "แก้วพลาสติก":  return "TypePlasticCup"
        case "กระป๋อง":      return "TypeCan"
        case "กล่องกระดาษ":  return "TypeCardboard"
        case "กระดาษทั่วไป": return "TypePaper"
        case "ถุงพลาสติก":   return "TypePlasticBag"
        case "เศษอาหาร":  return "TypeFood"
        case "เปลือกผลไม้":  return "TypeFruit"
        case "เศษขนม":      return "TypeSnack"
        case "เปลือกไข่":  return "TypeEgg"
        case "เครื่องดื่มเหลือ": return "TypeDrink"
        case "น้ำแข็งเหลือ":   return "TypeIce"
        case "ซองขนม": return "TypeSnackBag"
        case "ภาชนะใส่อาหาร": return "TypeContainer"
        case "หลอด": return "TypeStraw"
        case "กระดาษทิชชู่": return "TypeTissue"
        case "ตะเกียบไม้": return "TypeChopstick"
        case "ช้อน-ส้อมพลาสติก": return "TypeSpoon"
        default:             return "TypeBottle2"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {

                    // ส่วน Header (ชื่อหน้า + ปุ่ม Back)
                    ZStack {
                        Text("ประเภทขยะ")
                            .font(.noto(config.fontTitle, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack {
                            BackButton()
                            Spacer()
                        }
                    }
                    .padding(.horizontal, config.isIPad ? 60 : 20)
                    .padding(.bottom, config.isIPad ? 40 : 27)
                    .padding(.top, config.headerTopPadding)

                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 0) {
                            Image(imageForCategory(category))
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1.25, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.horizontal, config.isIPad ? 60 : 20)
                            
                            Spacer().frame(height: config.isIPad ? 40 : 23)
                            
                            // ✅ แสดง component ตาม category และส่ง config เข้าไป
                            switch category {
                            case "ขวดพลาสติก":  RecycleWasteDetailPlasticBottle(config: config)
                            case "แก้วพลาสติก":  RecycleWasteDetailPlasticCup(config: config)
                            case "กระป๋อง":      RecycleWasteDetailCan(config: config)
                            case "กล่องกระดาษ":  RecycleWasteDetailCardboardBox(config: config)
                            case "กระดาษทั่วไป": RecycleWasteDetailPaper(config: config)
                            case "ถุงพลาสติก":   RecycleWasteDetailPlasticBag(config: config)
                            case "เศษอาหาร":     WetWasteDetailFoodscraps(config: config)
                            case "เปลือกผลไม้":  WetWasteDetailFruitPeel(config: config)
                            case "เศษขนม":       WetWasteDetailCrumbs(config: config)
                            case "เปลือกไข่":    WetWasteDetailEggshell(config: config)
                            case "เครื่องดื่มเหลือ": WetWasteDetailLeftoverDrinks(config: config)
                            case "น้ำแข็งเหลือ":   WetWasteDetailLeftoverIce(config: config)
                            case "ซองขนม":       GeneralWasteDetailSnackBag(config: config)
                            case "ภาชนะใส่อาหาร": GeneralWasteDetailFoodContainer(config: config)
                            case "หลอด":         GeneralWasteDetailStraw(config: config)
                            case "กระดาษทิชชู่":   GeneralWasteDetailTissue(config: config)
                            case "ตะเกียบไม้":     GeneralWasteDetailChopsticks(config: config)
                            case "ช้อน-ส้อมพลาสติก": GeneralWasteDetailSpoon(config: config)
                                
                            default:
                                Text("ไม่พบข้อมูลประเภทขยะนี้")
                                    .font(.noto(config.fontSubHeader, weight: .medium))
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)  // ⭐ ให้ยาวจนสุดขอบล่าง
                }
                .ignoresSafeArea(.container, edges: .top)

            }
            .navigationBarHidden(true)
            .onAppear {
                hideTabBar = true
            }
        }
    }
}
