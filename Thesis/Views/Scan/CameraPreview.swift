//
//  CameraPreview.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @Binding var isScanning: Bool
    @Binding var isActive: Bool
    @Binding var capturedImage: UIImage?
    @Binding var isFlashOn: Bool
    var shouldCapture: Bool = false
    var scanMode: Bool = false
    var barcodeMode: Bool = false
    var onScan: ((String) -> Void)? = nil
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate {
        let session = AVCaptureSession()
        let photoOutput = AVCapturePhotoOutput()
        var onScan: ((String) -> Void)?
        var isScanning = true
        var onCapture: ((UIImage) -> Void)?
        
        init(onScan: ((String) -> Void)?) {
            self.onScan = onScan
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            guard error == nil,
                  let data = photo.fileDataRepresentation(),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.onCapture?(image)
            }
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
             guard isScanning,
                   let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                   let stringValue = metadataObject.stringValue else { return }
             isScanning = false
             
             let settings = AVCapturePhotoSettings()
             photoOutput.capturePhoto(with: settings, delegate: self)
             
             onScan?(stringValue)
         }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan)
    }
    
    func makeUIView(context: Context) -> UIView {
        
        class PreviewView: UIView {
            override func layoutSubviews() {
                super.layoutSubviews()
                layer.sublayers?.forEach { $0.frame = bounds }
            }
        }
        
        let view = PreviewView(frame: .zero)
        let session = context.coordinator.session
        session.sessionPreset = .high
        
        guard
            let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else { return view }
        
        session.addInput(input)
        
        if session.canAddOutput(context.coordinator.photoOutput) {
            session.addOutput(context.coordinator.photoOutput)
        }
        
        if scanMode {
            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
                
                if onScan != nil && !barcodeMode {
                    metadataOutput.metadataObjectTypes = [.qr]
                } else {
                    metadataOutput.metadataObjectTypes = [.ean13, .ean8, .code128, .code39, .upce]
                }
            }
        }
        
        context.coordinator.onCapture = { image in
            capturedImage = image
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
        
        let session = context.coordinator.session
        
        if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
            try? device.lockForConfiguration()
            device.torchMode = isFlashOn ? .on : .off
            device.unlockForConfiguration()
        }
        
        context.coordinator.onCapture = { image in
            capturedImage = image
        }
        
        context.coordinator.isScanning = isScanning
        
        if isActive {
            if !session.isRunning {
                DispatchQueue.global(qos: .userInitiated).async {
                    session.startRunning()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
                        context.coordinator.isScanning = isScanning
                    }
                }
            }
        } else {
            if session.isRunning { session.stopRunning() }
        }
        
        if shouldCapture && session.isRunning {
            let settings = AVCapturePhotoSettings()
            context.coordinator.photoOutput.capturePhoto(with: settings, delegate: context.coordinator)
        }
    }
}
