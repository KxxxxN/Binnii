//
//  ResponsiveConfig.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 4/4/2569 BE.
//

import SwiftUI

struct ResponsiveConfig {
    let isIPad: Bool
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    init(horizontalSizeClass: UserInterfaceSizeClass?, geo: GeometryProxy) {
        self.isIPad = horizontalSizeClass == .regular
        self.screenWidth = geo.size.width
        self.screenHeight = geo.size.height
    }
    
    // MARK: - 🎯 CORE SHARED: Typography (ฟอนต์ที่ใช้ร่วมกันบ่อยๆ)
    var fontTitle: CGFloat      { isIPad ? 36 : 25 }
    var fontHeader: CGFloat     { isIPad ? 28 : 20 }
    var fontSubHeader: CGFloat  { isIPad ? 24 : 18 }
    var fontBody: CGFloat       { isIPad ? 20 : 16 }
    var fontSubBody: CGFloat    { isIPad ? 20 : 15 }
    var fontCaption: CGFloat    { isIPad ? 18 : 14 }
    var fontSmall: CGFloat      { isIPad ? 16 : 12 }
    var fontTiny: CGFloat       { isIPad ? 14 : 10 }
    
    // MARK: - 🎯 CORE SHARED: Spacing & Padding (ระยะห่างที่ใช้ร่วมกันบ่อยๆ)
    var paddingStandard: CGFloat { isIPad ? 40 : 28 }
    var spacingMedium: CGFloat   { isIPad ? 30 : 20 }
    var spacingSmall: CGFloat    { isIPad ? 20 : 10 }
    var paddingMedium: CGFloat { isIPad ? 24 : 16 }
    var paddingSmall: CGFloat { isIPad ? 16 : 8 }
    
    
    // MARK: - General / Shared
    var titleFontSize: CGFloat { fontTitle }
    var sectionFontSize: CGFloat { fontBody }
    var buttonHeight: CGFloat { isIPad ? 50 : 40 }
    var buttonFont: CGFloat { fontBody }
    var historyTitleFontSize: CGFloat { isIPad ? 24 : 20 }
    
    // MARK: - Account View
    var groupSpacing: CGFloat { isIPad ? 30 : 22 }
    var topPadding: CGFloat { screenHeight * 0.07 }
    var bottomTitlePadding: CGFloat { paddingStandard }
    
    // MARK: - Main App View
    var mainHorizontalPadding: CGFloat { paddingStandard }
    var mainNameFontSize: CGFloat { isIPad ? 30 : 20 }
    var mainPointsFontSize: CGFloat { isIPad ? 60 : 40 }
    var mainPointsLabelFontSize: CGFloat { fontSubBody }
    var mainLogoWidth: CGFloat { isIPad ? 150 : 110 }
    var mainLogoHeight: CGFloat { isIPad ? 60 : 44 }
    var mainLogoTopPadding: CGFloat { isIPad ? 60 : 80 }
    var mainProfileSize: CGFloat { isIPad ? 80 : 55 }
    var mainProfileBottomPadding: CGFloat { isIPad ? 40 : 36 }
    var mainHeaderHeight: CGFloat { isIPad ? 260 : 205 }
    var mainContentSpacing: CGFloat { spacingMedium }
    var mainContentMaxWidth: CGFloat { isIPad ? 1100 : .infinity }
        
    // MARK: - Main App Subviews
    var sectionHeaderTitleFont: CGFloat { fontSubHeader }
    var sectionHeaderButtonFont: CGFloat { fontCaption }
        
    var itemCardImageHeight: CGFloat { isIPad ? 120 : 92 }
    var itemCardTitleFont: CGFloat { fontCaption }
    var itemCardCountFont: CGFloat { fontTiny }
    var itemCardHeight: CGFloat { isIPad ? 200 : 150 }
        
    var bannerCornerRadius: CGFloat { isIPad ? 25 : 20 }
    var bannerAspectRatio: CGFloat { 2.75 }
    
    // MARK: - Reward Exchange Section
    var rewardVStackSpacing: CGFloat { isIPad ? 12 : 7 }
    var rewardTextSpacing: CGFloat { isIPad ? 6 : 3 }
    var rewardSubtitleFontSize: CGFloat { fontCaption }
    var rewardCardPadding: CGFloat { isIPad ? 24 : 16 }
    var rewardButtonVPadding: CGFloat { isIPad ? 14 : 10 }
    var rewardCardHeight: CGFloat { isIPad ? 110 : 75 }
    
    // MARK: - QR Scan View
    var qrContentMaxWidth: CGFloat {
        isIPad ? 500 : (screenWidth > screenHeight ? 400 : 343)
    }
    var headerTopPadding: CGFloat { isIPad ? 80 : 65 }
    var headerSidePadding: CGFloat { isIPad ? 30 : 10 }
    var headerIconSize: CGFloat { isIPad ? 45 : 35 }
    
    var instructionFont: CGFloat { fontHeader }
    var instructionPaddingV: CGFloat { spacingMedium }
    var instructionPaddingTop: CGFloat { isIPad ? 80 : 40 }
    
    var cameraSize: CGFloat { isIPad ? 450 : 288 }
    var cameraPaddingTop: CGFloat { isIPad ? 80 : 60 }
    
    var alertIconSize: CGFloat { isIPad ? 140 : 111 }
    var alertTitleFont: CGFloat { isIPad ? 32 : 25 }
    var alertResultFont: CGFloat { fontSubHeader }
    var alertButtonSpacing: CGFloat { isIPad ? 30 : 21 }
    
    // MARK: - Knowledge View
    var knowledgeBinImageSize: CGFloat { isIPad ? 350 : 235 }
    var knowledgeBinPaddingBottom: CGFloat { isIPad ? 40 : 20 }
    var knowledgeArrowButtonSize: CGFloat { isIPad ? 70 : 50 }
    var knowledgeArrowIconSize: CGFloat { isIPad ? 40 : 30 }
    var knowledgeArrowSidePadding: CGFloat { isIPad ? 60 : 29 }
    var knowledgeContentPaddingH: CGFloat { isIPad ? 60 : 35 }
    var knowledgeContentPaddingTop: CGFloat { paddingStandard }
    var knowledgeDescFont: CGFloat { isIPad ? 26 : 20 }
    var knowledgeDescHeight: CGFloat { isIPad ? 80 : 55 }
    var knowledgeGridSpacing: CGFloat { spacingSmall }
        
    // MARK: - Waste Card (Knowledge View)
    var wasteCardImageSize: CGFloat { isIPad ? 80 : 60 }
    var wasteCardTextFont: CGFloat { isIPad ? 22 : 16 }
    var wasteCardHeight: CGFloat { isIPad ? 110 : 85 }
    
    // MARK: - Recycle Waste Detail
    var detailContentPaddingH: CGFloat { isIPad ? 60 : 30 }
    var detailSectionTitleFontSize: CGFloat { fontHeader }
    var detailBodyFontSize: CGFloat { isIPad ? 22 : 17 }
    var detailStepTextFontSize: CGFloat { fontSubBody }
    var detailBinTextFontSize: CGFloat { fontSmall }
    var detailMainBinHeight: CGFloat { isIPad ? 150 : 108 }
    var detailStepImageSize: CGFloat { isIPad ? 120 : 80 }
    var detailBinIconSize: CGFloat { isIPad ? 60 : 40 }
    var detailArrowSize: CGFloat { spacingMedium } // 30:20 เท่ากัน
    var detailWasteImgWidth: CGFloat { isIPad ? 585 : 350 }
    var detailWasteImgHeight: CGFloat { isIPad ? 435 : 290 }
    
    // MARK: - Search View
    var searchHeaderHeight: CGFloat { isIPad ? 160 : 123 }
    var searchHeaderTopPadding: CGFloat { isIPad ? 80 : 67 }
    var searchImageHeight: CGFloat { isIPad ? 400 : 290 }
    var searchButtonWidth: CGFloat { isIPad ? 220 : 175 }
    var searchButtonHeight: CGFloat { isIPad ? 60 : 49 }
    
    // MARK: - AI Scan Button
    var aiButtonOuterSize: CGFloat { isIPad ? 110 : 85 }
    var aiButtonOuterLineWidth: CGFloat { isIPad ? 5 : 3 }
    var aiButtonInnerSize: CGFloat { isIPad ? 95 : 73 }
    var aiButtonIconSize: CGFloat { isIPad ? 75 : 57 }
    
    // MARK: - Scan Bottom Bar
    var aiBarWidth: CGFloat { isIPad ? 500 : 344 }
    var aiBarHeight: CGFloat { isIPad ? 70 : 50 }
    var aiBarTabWidth: CGFloat { aiBarWidth / 3.1 } // หารเฉลี่ยให้พอดีกับ 3 ปุ่ม
    var aiBarTabHeight: CGFloat { aiBarHeight * 0.84 }
    var aiBarIconSize: CGFloat { isIPad ? 35 : 27 }
    var aiBarAIIconSize: CGFloat { isIPad ? 45 : 37 }
    
    // MARK: - Barcode Scan View
    var barcodeShutterIconSize: CGFloat     { isIPad ? 57 : 45 }
    var barcodeShutterSpacerHeight: CGFloat { screenHeight * (isIPad ? 0.60 : 0.63) }
    
    // MARK: - QR Scan View 
 
    /// ความสูง banner คำแนะนำด้านบน
    var qrBannerHeight: CGFloat           { isIPad ? 150 : 115 }
 
    /// padding top ของ banner
    var qrBannerTopPadding: CGFloat       { isIPad ? 80 : 62 }
 
    /// padding top ของกล้อง QR
    var qrCameraTopPadding: CGFloat       { isIPad ? 120 : 93 }
 
    /// ความยาวเส้นมุม QR frame
    var qrCornerLineLength: CGFloat       { isIPad ? 45 : 30 }
 
    /// ความสูง Result Alert popup
    var qrAlertHeight: CGFloat            { isIPad ? 420 : 320 }
 
    /// ความกว้าง/สูงปุ่มใน Alert
    var qrAlertButtonWidth: CGFloat       { isIPad ? 160 : 120 }
    var qrAlertButtonHeight: CGFloat      { isIPad ? 52 : 40 }
    
    // MARK: - Confirm Photo View
    var confirmBannerHeight: CGFloat      { isIPad ? 80 : 60 }
    var confirmBannerTopPadding: CGFloat  { isIPad ? 50 : 35 }
    
    // MARK: - Frequent Waste View
    var wasteGridTopPadding: CGFloat      { isIPad ? 60 : 43 }
    var paginationSpacing: CGFloat        { isIPad ? 26 : 19 }
    var paginationButtonSize: CGFloat     { isIPad ? 42 : 30 }
    var wasteCardImageZStackHeight: CGFloat { isIPad ? 180 : 140 }
    var wasteCardTotalHeight: CGFloat     { isIPad ? 290 : 215 }
    
    // MARK: - Reward Exchange View
    /// padding top ก่อน PointsSummaryCard
    var rewardScrollTopPadding: CGFloat   { isIPad ? 55 : 41 }
    
    /// ความสูง PointsSummaryCard
    var pointsCardHeight: CGFloat         { isIPad ? 200 : 150 }
 
    /// padding horizontal ของ title "แลกรับชั่วโมง..."
    var conditionsTitlePaddingH: CGFloat  { isIPad ? 60 : 42 }
 
    /// padding top/bottom ของ title "แลกรับชั่วโมง..."
    var conditionsTitlePaddingV: CGFloat  { isIPad ? 46 : 34 }
     
    // MARK: - Score History View 
 
    /// padding top ของ sort menu (ต่างจาก paddingStandard 28/40)
    var sortMenuTopPadding: CGFloat       { isIPad ? 32 : 24 }
    /// ขนาดรูป empty state
    var emptyStateImageSize: CGFloat      { isIPad ? 420 : 300 }
    
    // MARK: - Waste Type View
    var wasteListBottomPadding: CGFloat   { isIPad ? 160 : 125 }
    var wasteItemCardSpacing: CGFloat     { isIPad ? 65 : 49 }
    var wasteItemImageWidth: CGFloat      { isIPad ? 190 : 140 }
    var wasteItemImageHeight: CGFloat     { isIPad ? 124 : 92 }
    var wasteItemImageRadius: CGFloat     { isIPad ? 40 : 30 }
    var wasteItemCardHeight: CGFloat      { isIPad ? 148 : 110 }
    
    // MARK: - Profile View
    var profileImageSize: CGFloat { isIPad ? 120 : 85 }
    var profileMaxWidth: CGFloat { isIPad ? 600 : .infinity }
    var profileButtonWidth: CGFloat { isIPad ? 220 : 155 }
    
    // MARK: - Account Row 
    var accountRowHeight: CGFloat { isIPad ? 90 : 70 }
    var accountRowIconSize: CGFloat { isIPad ? 55 : 40 }
    var accountRowIconLeading: CGFloat { isIPad ? 50 : 35 }
    var accountRowSpacing: CGFloat { isIPad ? 22 : 15 }
    var accountRowFontSize: CGFloat { isIPad ? 26 : 20 }
    var accountRowChevronSize: CGFloat { isIPad ? 32 : 24 }
}
