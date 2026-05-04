//
//  QRScanView.swift
//  Thesis
//

import SwiftUI
import AVFoundation
import PhotosUI

struct QRScanView: View {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @Binding var index: Int
    
    @StateObject private var viewModel = QRScanViewModel()
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
            
            ZStack(alignment: .top) {
                
                // MARK: - Background
                Image("QRBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()
                
                // MARK: - Foreground
                VStack(spacing: 0) {
                    
                    headerView(config: config)

                    Button {
                        viewModel.navigateToAIScan(hideTabBar: &hideTabBar)
                    } label: {
                        Text(L("โปรดสแกนคิวอาร์โค้ด\nที่ติดอยู่บนถังขยะเพื่อเริ่มใช้งาน"))
                            .font(.noto(config.fontHeader, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(width: config.qrContentMaxWidth, height: config.isIPad ? 155 : 115)
                            .background(Color.textFieldColor)
                            .cornerRadius(config.bannerCornerRadius)
                    }
                    .padding(.top, config.qrBannerTopPadding)
                    
                    ZStack {
                        CameraPreview(
                            isScanning: $viewModel.isScanning,
                            isActive: $viewModel.isCameraActive,
                            capturedImage: .constant(nil),
                            isFlashOn: $viewModel.isFlashOn,
                            scanMode: true,
                            onScan: {
                                viewModel.handleScanResult($0)
                            }
                        )
                        .id(viewModel.cameraID)
                        .frame(width: config.cameraSize, height: config.cameraSize)
                        .cornerRadius(config.bannerCornerRadius)
                        
                        QRCornerLines(config: config)
                    }
                    .frame(width: config.cameraSize, height: config.cameraSize)
                    .padding(.top, config.qrCameraTopPadding)
                    
                    Spacer()
                    Color.clear.frame(height: 50)
                }
                
                if viewModel.showResultAlert {
                    resultAlertOverlay(config: config)
                }
                
                if viewModel.showErrorAlert {
                    ErrorPopupView(title: L("สแกนไม่สำเร็จ")) {
                        viewModel.dismissError()
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showAiScanView) {
                ScanContainerView(hideTabBar: $hideTabBar)
            }
        }
        
        .onAppear { viewModel.onAppear(hideTabBar: &hideTabBar) }
        .onDisappear {
            viewModel.onDisappear(hideTabBar: &hideTabBar)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                NotificationCenter.default.post(name: .didFinishScan, object: nil)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        HStack {
            XBackButtonBlack(index: $index)
//                .simultaneousGesture(TapGesture().onEnded {
//                    viewModel.isCameraActive = false
//                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.8) {
//                        DispatchQueue.main.async {
//                            NotificationCenter.default.post(name: .didFinishScan, object: nil)
//                        }
//                    }
//                })
            Color.clear.frame(width: 10, height: 10)
            Spacer()
            Text(L("สแกนคิวอาร์โค้ดถังขยะ"))
                .font(.noto(config.titleFontSize, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Button { viewModel.toggleFlash() } label: {
                Image(viewModel.isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize, height: config.headerIconSize)
                    .padding(.trailing, config.paddingStandard)
            }
        }
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.bottomTitlePadding)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .ignoresSafeArea()
    }
    
    // MARK: - Result Alert Overlay
    private func resultAlertOverlay(config: ResponsiveConfig) -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Image("Passmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.alertIconSize, height: config.alertIconSize)
                    .padding(.top, config.paddingStandard)
                
                Text(L("ยืนยันถังขยะ"))
                    .font(.noto(config.titleFontSize, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, config.spacingSmall)
                
                Text(viewModel.resultTitle(config: config))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, config.paddingSmall)
                
                HStack(spacing: config.alertButtonSpacing) {
                    Button { viewModel.cancelResult() } label: {
                        Text(L("ยกเลิก"))                            .font(.noto(config.fontBody, weight: .bold))
                            .foregroundColor(.mainColor)
                            .frame(width: config.qrAlertButtonWidth,
                                   height: config.qrAlertButtonHeight)
                            .background(Color.white)
                            .cornerRadius(config.qrAlertButtonHeight / 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: config.qrAlertButtonHeight / 2)
                                    .stroke(Color.mainColor, lineWidth: 2)
                            )
                    }
                    
                    Button { viewModel.confirmResult(hideTabBar: &hideTabBar) } label: {
                        Text(L("ยืนยัน"))                            .font(.noto(config.fontBody, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: config.qrAlertButtonWidth,
                                   height: config.qrAlertButtonHeight)
                            .background(Color.mainColor)
                            .cornerRadius(config.qrAlertButtonHeight / 2)
                    }
                }
                .padding(config.paddingStandard)
            }
            .padding(config.paddingMedium)
            .frame(width: config.qrContentMaxWidth, height: config.qrAlertHeight)
            .background(Color.white)
            .cornerRadius(config.bannerCornerRadius)
        }
    }
}

// MARK: - QR Corner Lines
struct QRCornerLines: View {
    var config: ResponsiveConfig? = nil

    private var lineLength: CGFloat { config?.qrCornerLineLength ?? 30 }
    private let lineWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                path.move(to: CGPoint(x: 0, y: lineLength))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: lineLength, y: 0))

                path.move(to: CGPoint(x: w - lineLength, y: 0))
                path.addLine(to: CGPoint(x: w, y: 0))
                path.addLine(to: CGPoint(x: w, y: lineLength))

                path.move(to: CGPoint(x: 0, y: h - lineLength))
                path.addLine(to: CGPoint(x: 0, y: h))
                path.addLine(to: CGPoint(x: lineLength, y: h))

                path.move(to: CGPoint(x: w - lineLength, y: h))
                path.addLine(to: CGPoint(x: w, y: h))
                path.addLine(to: CGPoint(x: w, y: h - lineLength))
            }
            .stroke(Color.mainColor, lineWidth: lineWidth)
        }
    }
}

#Preview {
    NavigationStack {
        QRScanView(
            hideTabBar: .constant(false),
            index: .constant(0)
        )
    }
}
