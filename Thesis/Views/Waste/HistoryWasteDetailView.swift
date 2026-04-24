//
//  HistoryWasteDetailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 23/4/2569 BE.
//


import SwiftUI

struct HistoryWasteDetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var hideTabBar: Bool
    let item: WasteTypeItem

    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

            VStack(spacing: 0) {

                DetailWasteHeader(title: "รายละเอียด", config: config)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        if let urlString = item.imageUrl, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure, .empty:
                                    Color.thirdColor
                                @unknown default:
                                    Color.thirdColor
                                }
                            }
                            .frame(width: max(0, geo.size.width - 40), height: 290)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.thirdColor)
                                .frame(width: geo.size.width - 40, height: 290)
                        }

                        Spacer().frame(height: config.isIPad ? 40 : 23)

                        WasteDetailContentView(
                            category: item.title,
                            config: config,
                            showDate: true,
                            dateString: item.date
                        )
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .onAppear {
                hideTabBar = true
                print("item.date = \(item.date)")
            }
        }
    }
}

#Preview {
    HistoryWasteDetailView(
        hideTabBar: .constant(false),
        item: WasteTypeItem(title: "ขวดพลาสติก", date: "22/4/2569 - 14:30", dateOnly: "22/4/2569", imageUrl: nil)
    )
}
