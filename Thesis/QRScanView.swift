//
//  QRScanView.swift
//  Thesis
//

import SwiftUI
import AVFoundation
import PhotosUI

struct QRScanView: View {

    @Environment(\.dismiss) private var dismiss
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

    private var resultTitle: AttributedString {
        var text = AttributedString(qrResult)
        text.font = .noto(18, weight: .medium)
        if let range = text.range(of: "COSCI") {
            text[range].font = .inter(18, weight: .medium)
        }
        return text
    }

    var body: some View {
        ZStack(alignment: .top) {

            GeometryReader { geo in
                Image("QRBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {

                headerView

                VStack(spacing: 0) {

//                    Text("โปรดสแกนคิวอาร์โค้ด\nที่ติดอยู่บนถังขยะเพื่อเริ่มใช้งาน")
//                        .font(.noto(20, weight: .medium))
//                        .foregroundColor(.black)
//                        .multilineTextAlignment(.center)
//                        .frame(width: 343, height: 115)
//                        .background(Color.textFieldColor)
//                        .cornerRadius(20)
                    
                    NavigationLink("โปรดสแกนคิวอาร์โค้ด\nที่ติดอยู่บนถังขยะเพื่อเริ่มใช้งาน", destination: AiScanView(hideTabBar: $hideTabBar))
                        .font(.noto(20, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 343, height: 115)
                        .background(Color.textFieldColor)
                        .cornerRadius(20)
                    
                    .padding(.top, 62)

                    ZStack {
                        // ✅ อัปเดต CameraPreview ให้ตรง signature ใหม่
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
                        .frame(width: 288, height: 288)
                        .cornerRadius(20)
                        
                        QRCornerLines()
                    }
                    .frame(width: 288, height: 288)
                    .padding(.top, 93)

                    Spacer()
                    Color.clear.frame(height: 50)
                }
            }

            // Result Alert
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
                            .frame(width: 111, height: 111)
                            .multilineTextAlignment(.center)
                            .padding(.top, 25)

                        Text("ยืนยันถังขยะ")
                            .font(.noto(25, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)

                        Text(resultTitle)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)

                        HStack(spacing: 21) {
                            Button {
                                showResultAlert = false
                                showResultAlert = false
                                cameraID = UUID()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isScanning = true
                                    isCameraActive = true
                                }
                            } label: {
                                Text("ยกเลิก")
                                    .font(.noto(16, weight: .bold))
                                    .foregroundColor(.mainColor)
                                    .frame(width: 120, height: 40)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.mainColor, lineWidth: 2)
                                    )
                            }

                            Button {
                                hideTabBar = true
                                showResultAlert = false
                                showAiScanView = true
                            } label: {
                                Text("ยืนยัน")
                                    .font(.noto(16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 120, height: 40)
                                    .background(Color.mainColor)
                                    .cornerRadius(20)
                            }
                        }
                        .padding(25)
                    }
                    .padding(20)
                    .frame(width: 343, height: 320)
                    .background(Color.white)
                    .cornerRadius(20)
                }
            }

            // Error Alert
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
        }
        .onDisappear {
            hideTabBar = false
            isCameraActive = false
        }
        .navigationDestination(isPresented: $showAiScanView) {
            AiScanView(hideTabBar: $hideTabBar)
        }
    }

    private var headerView: some View {
        HStack {
            XBackButtonBlack(index: $index)
            Color.clear.frame(width: 10, height: 10)

            Spacer()

            Text("สแกนคิวอาร์โค้ดถังขยะ")
                .font(.noto(25, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Button { isFlashOn.toggle() } label: {
                Image(isFlashOn ? "FlashOn" : "FlashOff")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 25)
            }
        }
        .padding(.top, 65)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor.ignoresSafeArea(edges: .top))
    }
}

// MARK: - QR Frame View
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
    let lineLength: CGFloat = 30
    let lineWidth: CGFloat = 4

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
