//
//  MainTabView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 25/10/2568 BE.
//

import SwiftUI

struct MainTabView: View {
    @Binding var index: Int
    @Namespace private var animation

    var body: some View {
        ZStack {
            (index == 2 ? Color.knowledgeBackground : Color.backgroundColor)
            
            Color.mainColor
                .clipShape(TabCorner(radius: 20, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
                .ignoresSafeArea(.container, edges: .horizontal)


            HStack {
                tabButton(image: "Home2", selectedImage: "Home1", label: "หน้าหลัก", indexValue: 0)
                Spacer(minLength: 15)
                tabButton(image: "Scan2", selectedImage: "Scan1", label: "แสกน", indexValue: 1)
                Spacer(minLength: 15)
                tabButton(image: "Book2", selectedImage: "Book1", label: "ความรู้ทั่วไป", indexValue: 2)
                Spacer(minLength: 15)
                tabButton(image: "User2", selectedImage: "User1", label: "บัญชีผู้ใช้", indexValue: 3)
            }
            .padding(.horizontal, 25)
        }
        .frame(height: 88)
    }

    func tabButton(image: String, selectedImage: String, label: String, indexValue: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                self.index = indexValue
            }
        }) {
            VStack(spacing: 0) {
                ZStack {
                    if self.index == indexValue {
                        Circle()
                            .fill(Color.tabbarColor)
                            .matchedGeometryEffect(id: "circleBG", in: animation)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Circle()
                                    .stroke(Color.backgroundColor, lineWidth: 5)
                                    .matchedGeometryEffect(id: "circleBorder", in: animation)
                            )
                            .offset(y: -10)
                    }

                    Image(self.index == indexValue ? selectedImage : image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 37, height: 37)
                        .frame(width: 60, height: 60)
                        .offset(y: self.index == indexValue ? -10 : 0)
                }

                Text(label)
                    .font(.noto(15, weight: .regular))   
                    .foregroundColor(.white)
                    .padding(.bottom, 13)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct TabCorner: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
