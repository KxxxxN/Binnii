//
//  DetailSearchView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 9/1/2569 BE.
//

import SwiftUI

struct DetailSearchView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
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
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            
            ZStack {
                Color.backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Header Section
                    ZStack {
                        Text("ค้นหา")
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

                    // MARK: - Content
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            Image(imageForCategory(category))
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1.25, contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.horizontal, config.isIPad ? 60 : 20)
                            
                            Spacer().frame(height: config.isIPad ? 40 : 23)
                            
                            // MARK: - ส่วนเนื้อหารายละเอียด
                            VStack(spacing: 0) {
                                // ส่ง config เข้าไปในทุกๆ component ตาม category
                                switch category {
                                case "ขวดพลาสติก":       RecycleWasteDetailPlasticBottle(config: config)
                                case "แก้วพลาสติก":       RecycleWasteDetailPlasticCup(config: config)
                                case "กระป๋อง":           RecycleWasteDetailCan(config: config)
                                case "กล่องกระดาษ":       RecycleWasteDetailCardboardBox(config: config)
                                case "กระดาษทั่วไป":      RecycleWasteDetailPaper(config: config)
                                case "ถุงพลาสติก":        RecycleWasteDetailPlasticBag(config: config)
                                case "เศษอาหาร":          WetWasteDetailFoodscraps(config: config)
                                case "เปลือกผลไม้":       WetWasteDetailFruitPeel(config: config)
                                case "เศษขนม":            WetWasteDetailCrumbs(config: config)
                                case "เปลือกไข่":         WetWasteDetailEggshell(config: config)
                                case "เครื่องดื่มเหลือ":  WetWasteDetailLeftoverDrinks(config: config)
                                case "น้ำแข็งเหลือ":      WetWasteDetailLeftoverIce(config: config)
                                case "ซองขนม":            GeneralWasteDetailSnackBag(config: config)
                                case "ภาชนะใส่อาหาร":     GeneralWasteDetailFoodContainer(config: config)
                                case "หลอด":              GeneralWasteDetailStraw(config: config)
                                case "กระดาษทิชชู่":      GeneralWasteDetailTissue(config: config)
                                case "ตะเกียบไม้":        GeneralWasteDetailChopsticks(config: config)
                                case "ช้อน-ส้อมพลาสติก":  GeneralWasteDetailSpoon(config: config)
                                default:
                                    Text("ไม่พบข้อมูลประเภทขยะนี้")
                                        .font(.noto(config.detailBodyFontSize, weight: .medium))
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                                
                                // ปุ่มยืนยันภาพถ่าย
                                Button {
                                    hideTabBar = true
                                    showConfirmPhotoView = true
                                } label: {
                                    HStack {
                                        Text("ยืนยันภาพถ่าย")
                                            .font(.noto(config.fontHeader)) 
                                            .foregroundColor(.white)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    }
                                    .frame(width: config.isIPad ? 220 : 175, height: config.isIPad ? 60 : 49)
                                    .background(Color.mainColor)
                                    .cornerRadius(20)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal, config.isIPad ? 60 : 37) // อิงระยะขอบจาก iPad
                                .padding(.vertical, config.isIPad ? 40 : 30)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .background(
                                Color.knowledgeBackground
                                    .clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight]))
                                    .ignoresSafeArea(.container, edges: .horizontal)
                            )
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                .ignoresSafeArea(.container, edges: .top) // ขยายพื้นที่ด้านบนสุดเพื่อให้สี Background ดันขึ้นสุดจอ
            }
        }
        .navigationDestination(isPresented: $showConfirmPhotoView) {
            ConfirmPhotoView(hideTabBar: $hideTabBar)
        }
        .navigationBarHidden(true)
        .onAppear { hideTabBar = true }
    }
}
