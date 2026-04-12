//
//  QRScanView.swift
//  Thesis
//

import SwiftUI
import AVFoundation
import PhotosUI

struct QRScanView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var hideTabBar: Bool
    @State private var showDetailView = false
    @Binding var index: Int

    @State private var isFlashOn = false
    @State private var showResultAlert = false
    @State private var showErrorAlert = false
    @State private var showAiScanView = false

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isCameraActive = false
    @State private var isScanning = true
    @State private var cameraID = UUID()

    @State private var qrResult: String = ""

    private func resultTitle(config: ResponsiveConfig) -> AttributedString {
        var text = AttributedString(qrResult)
        text.font = .noto(config.fontSubHeader, weight: .medium)
        if let range = text.range(of: "COSCI") {
            text[range].font = .inter(config.fontSubHeader, weight: .medium)
        }
        return text
    }

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

                    VStack(spacing: 0) {

                        Text("โปรดสแกนคิวอาร์โค้ด\nที่ติดอยู่บนถังขยะเพื่อเริ่มใช้งาน")
                            .font(.noto(config.fontHeader, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: config.qrContentMaxWidth,
                                   minHeight: config.qrBannerHeight)
                            .background(Color.textFieldColor)
                            .cornerRadius(config.bannerCornerRadius)
                            .padding(.top, config.qrBannerTopPadding)

                        ZStack {
                            CameraPreview(
                                isScanning: $isScanning,
                                isActive: $isCameraActive,
                                capturedImage: .constant(nil),
                                isFlashOn: $isFlashOn,
                                scanMode: true,
                                onScan: { result in
                                    qrResult = result
                                    isCameraActive = false
                                    isScanning = false
                                    if result.contains("COSCI") {
                                        showResultAlert = true
                                    } else {
                                        showErrorAlert = true
                                    }
                                }
                            )
                            .id(cameraID)
                            .frame(width: config.cameraSize,
                                   height: config.cameraSize)
                            .cornerRadius(config.bannerCornerRadius)

                            QRCornerLines(config: config)
                        }
                        .frame(width: config.cameraSize, height: config.cameraSize)
                        .padding(.top, config.qrCameraTopPadding)

                        Spacer()
                        Color.clear.frame(height: 50)
                    }
                }

                // MARK: - Result Alert
                if showResultAlert {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .opacity(0.8)
                            .ignoresSafeArea()

                        VStack(spacing: 0) {
                            Image("Passmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: config.alertIconSize,
                                       height: config.alertIconSize)
                                .padding(.top, config.paddingStandard)

                            Text("ยืนยันถังขยะ")
                                .font(.noto(config.titleFontSize, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, config.spacingSmall)

                            Text(resultTitle(config: config))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, config.paddingSmall)

                            HStack(spacing: config.alertButtonSpacing) {
                                Button {
                                    showResultAlert = false
                                    cameraID = UUID()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isScanning = true
                                        isCameraActive = true
                                    }
                                } label: {
                                    Text("ยกเลิก")
                                        .font(.noto(config.fontBody, weight: .bold))
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

                                Button {
                                    hideTabBar = true
                                    showResultAlert = false
                                    showAiScanView = true
                                } label: {
                                    Text("ยืนยัน")
                                        .font(.noto(config.fontBody, weight: .bold))
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
                        .frame(width: config.qrContentMaxWidth,
                               height: config.qrAlertHeight)
                        .background(Color.white)
                        .cornerRadius(config.bannerCornerRadius)
                    }
                }

                // MARK: - Error Alert
                if showErrorAlert {
                    ErrorPopupView(title: "สแกนไม่สำเร็จ") {
                        showErrorAlert = false
                        cameraID = UUID()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isScanning = true
                            isCameraActive = true
                        }
                    }
                }
            }
            .onAppear {
                hideTabBar = true
                isCameraActive = true
                OrientationHelper.setOrientation(.portrait)
            }
            .onDisappear {
                hideTabBar = false
                isCameraActive = false
                OrientationHelper.setOrientation(.all)
            }
            .navigationDestination(isPresented: $showAiScanView) {
                AiScanView(hideTabBar: $hideTabBar)
            }
        }
    }

    // MARK: - Header
    private func headerView(config: ResponsiveConfig) -> some View {
        HStack {
            XBackButtonBlack(index: $index)
            Color.clear.frame(width: config.spacingSmall,               
                              height: config.spacingSmall)

            Spacer()

            Text("สแกนคิวอาร์โค้ดถังขยะ")
                .font(.noto(config.titleFontSize, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.headerIconSize,
                           height: config.headerIconSize)
                    .padding(.trailing, config.paddingStandard)
            }
        }
        .padding(.top, config.headerTopPadding)
        .padding(.bottom, config.paddingMedium)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }

    // MARK: - Orientation Helper
    func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            AppDelegate.orientationLock = orientation
            let rootViewController = windowScene.windows.first?.rootViewController
            rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            if #available(iOS 16.0, *) {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            } else {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
    }
}

// MARK: - QR Scan Frame View
struct QRScanFrameView: View {
    var body: some View {
        ZStack {
            Image("QR")
                .resizable()
                .scaledToFill()
                .frame(width: 288, height: 288)
                .clipped()
            QRCornerLines()
        }
        .frame(width: 288, height: 288)
        .background(Color.white)
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
