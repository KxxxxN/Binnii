//
//  WasteSeparationStepsView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 9/4/2569 BE.
//


//
//  WasteSeparationStepsView.swift
//  Thesis
//
//  Shared component สำหรับแสดง steps + bin icons
//  ใช้ร่วมกันใน WetWasteDetailContent, GeneralWasteDetailContent, RecycleWasteDetailContent
//

import SwiftUI

struct WasteSeparationStepsView: View {
    let config: ResponsiveConfig
    let separationSteps: [WasteSeparationStep]
    let binSteps: [WasteBinStep]

    var body: some View {
        GeometryReader { geo in
            let hPadding: CGFloat       = config.isIPad ? 20 : 10
            let availableWidth          = geo.size.width - (hPadding * 2)
            let stepCount               = CGFloat(separationSteps.count)
            let arrowCount              = stepCount - 1
            // ความกว้างลูกศร = ขนาด icon + horizontal padding (2+2)
            let arrowSlotWidth: CGFloat = config.detailArrowSize + 6
            let stepWidth               = (availableWidth - arrowSlotWidth * arrowCount) / stepCount
            // รูปภาพ: ไม่เกิน config แต่ shrink ได้เมื่อจอแคบ
            let imageSize               = min(stepWidth * 0.80, config.detailStepImageSize)

            HStack(alignment: .top, spacing: 0) {
                ForEach(separationSteps.indices, id: \.self) { index in

                    // ลูกศร (ยกเว้น step แรก)
                    if index > 0 {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                            .font(.system(size: config.detailArrowSize))
                            .padding(.horizontal, 2)
                            .padding(.top, imageSize / 2 - config.detailArrowSize / 2)
                            .frame(width: arrowSlotWidth)
                    }

                    // แต่ละ step
                    VStack(spacing: 0) {
                        Image(separationSteps[index].imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageSize, height: imageSize)
                            .padding(.bottom, 10)

                        Text(separationSteps[index].text)
                            .font(.noto(config.detailStepTextFontSize, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity,
                                   minHeight: config.isIPad ? 60 : 45,
                                   alignment: .top)

                        Spacer().frame(height: 10)

                        if index < binSteps.count {
                            VStack(spacing: 2) {
                                Image(binSteps[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: config.detailBinIconSize,
                                           height: config.detailBinIconSize)
                                Text(binSteps[index].text)
                                    .font(.noto(config.detailBinTextFontSize, weight: .medium))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(width: stepWidth)
                }
            }
            .padding(.horizontal, hPadding)
        }
        // ความสูงคงที่ให้ GeometryReader ทำงานถูกต้อง
        .frame(height: config.detailStepImageSize
                     + (config.isIPad ? 60 : 45)
                     + config.detailBinIconSize
                     + 50)
    }
}