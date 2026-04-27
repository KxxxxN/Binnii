//
//  RewardExchangeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 8/12/2568 BE.
//

import SwiftUI

struct RewardExchangeView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    let totalPoints: Int
    let profileVM: UserProfileViewModel

    @StateObject private var vm: RewardExchangeViewModel
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    init(hideTabBar: Binding<Bool>, totalPoints: Int, profileVM: UserProfileViewModel) {
        _hideTabBar = hideTabBar
        self.totalPoints = totalPoints
        self.profileVM = profileVM
        _vm = StateObject(wrappedValue: RewardExchangeViewModel(totalPoints: totalPoints))
    }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
            ZStack{
                VStack(spacing: 0) {
                    
                    // MARK: - Top Bar
                    ZStack {
                        Color.mainColor
                        
                        HStack {
                            XBackButtonWhite()
                            
                            Spacer()
                            
                            Text(L("แลกคะแนน"))                                .font(.noto(config.titleFontSize, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Color.clear.frame(width: config.headerIconSize,
                                              height: config.headerIconSize)
                        }
                        .padding(.top, config.headerTopPadding)
                        .padding(.trailing, config.paddingMedium)
                        .padding(.bottom, config.paddingMedium)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: config.searchHeaderHeight)
                    .clipShape(RoundedCorner(radius: config.bannerCornerRadius,
                                             corners: [.bottomLeft, .bottomRight]))
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            PointsSummaryCard(pointsData: vm.pointsData, config: config)
                                .padding(.top, config.rewardScrollTopPadding)
                            
                            ConditionsAndExchangeSection(
                                conditionsList: vm.conditionsList,
                                config: config,
                                onConfirm: {
                                    vm.confirmExchange()
                                }
                            )
                            
                        }
                        .padding(.horizontal, config.paddingMedium)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .onAppear { hideTabBar = true }
                .onDisappear { hideTabBar = false }
                if vm.showConfirmAlert {
                    ExchangeConfirmPopupView(
                        isPresented: $vm.showConfirmAlert,
                        onConfirm: {
                            Task {
                                await profileVM.deductPoints(amount: 10)
                                vm.performExchange()
                            }
                        }
                    )
                }
                if vm.showSuccessPopup {
                    SuccessPopupView(message: L("แลกคะแนนสำเร็จ")) {                        vm.showSuccessPopup = false
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - PointsSummaryCard
struct PointsSummaryCard: View {
    let pointsData: [(label: String, value: String, isBold: Bool)]
    let config: ResponsiveConfig

    var body: some View {
        VStack(spacing: -10) {
            ForEach(pointsData.indices, id: \.self) { index in
                HStack {
                    Text(pointsData[index].label)
                        .font(.noto(config.fontBody, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.bottom, config.paddingMedium)

                    Spacer()

                    Text(pointsData[index].value)
                        .font(.noto(
                            pointsData[index].isBold ? config.fontHeader : config.fontSubHeader,
                            weight: pointsData[index].isBold ? .bold : .medium
                        ))
                        .foregroundColor(.black)
                        .padding(.bottom, config.paddingMedium)
                }
            }
        }
        .padding(.top, config.paddingMedium)
        .padding(.horizontal, config.paddingStandard)
        .frame(maxWidth: .infinity)
        .frame(height: config.pointsCardHeight)
        .background(Color.wasteCard)
        .cornerRadius(config.bannerCornerRadius)
        .frame(maxWidth: config.mainContentMaxWidth)
    }
}

// MARK: - ConditionsAndExchangeSection
struct ConditionsAndExchangeSection: View {
    let conditionsList: [String]
    let config: ResponsiveConfig
    let onConfirm: () -> Void
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        VStack(spacing: 0) {

            Text(L("แลกรับชั่วโมงจิตอาสา 5 ชั่วโมง"))                .font(.noto(config.fontHeader, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, config.conditionsTitlePaddingH)
                .padding(.vertical, config.conditionsTitlePaddingV)

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 5) {
                    Text(L("รายละเอียด และเงื่อนไข"))
                        .font(.noto(config.fontBody, weight: .bold))
                        .foregroundColor(.black)
                    Text(L("(จำลอง)"))
                        .font(.noto(config.fontBody, weight: .bold))
                        .foregroundColor(.placeholderColor)
                }
                .padding(.bottom, config.spacingMedium)

                VStack(alignment: .leading, spacing: config.rewardVStackSpacing) {
                    ForEach(conditionsList.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: config.isIPad ? 15 : 10) {
                            Text("\(index + 1).")
                                .font(.noto(config.fontBody, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: config.isIPad ? 40 : 25, alignment: .leading)
                            
                            Text(conditionsList[index])
                                .font(.noto(config.fontBody, weight: .medium))
                                .foregroundColor(.black)
                                .lineSpacing(config.isIPad ? 8 : 4) // ระยะบรรทัดกว้างขึ้นใน iPad
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(config.paddingStandard)
            .background(Color.wasteCard)
            .cornerRadius(config.bannerCornerRadius)
            .frame(maxWidth: config.mainContentMaxWidth)

            Button(action: { onConfirm() }) {
                Text(L("ยืนยันแลกคะแนน"))
                    .font(.noto(config.fontSubHeader, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: config.searchButtonHeight)
                    .background(Color.mainColor)
                    .cornerRadius(config.bannerCornerRadius)
            }
            .frame(maxWidth: config.mainContentMaxWidth)
            .padding(.top, config.paddingStandard)
            .padding(.bottom, config.paddingStandard * 2)
        }
        .frame(maxWidth: .infinity)
    }
}
