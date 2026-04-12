//
//  DetailBarcodeView.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//

import SwiftUI
import Storage
import Auth

struct DetailBarcodeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass // ✅ เพิ่มสำหรับเช็ค iPad/iPhone
    @Binding var hideTabBar: Bool
    var category: String
    var capturedImage: UIImage? = nil
    
    @State private var isSaving = false
    @State private var showSaveSuccess = false
    @State private var showSaveError = false
    
    private func binForCategory(_ category: String) -> String {
        switch category {
        case "ขวดพลาสติก", "แก้วพลาสติก", "กระป๋อง", "กล่องกระดาษ", "กระดาษทั่วไป", "ถุงพลาสติก":
            return "ถังขยะรีไซเคิล"
        default:
            return "ถังขยะทั่วไป"
        }
    }

    private func saveScan() async {
        isSaving = true
        defer { isSaving = false }
        
        do {
            let user = try await supabase.auth.session.user
            var imageURL: String? = nil
            
            // ✅ อัปโหลดรูป
            if let uiImage = capturedImage,
               let data = uiImage.jpegData(compressionQuality: 0.8) {
                let fileName = "\(user.id)_\(Date().timeIntervalSince1970).jpg"
                try await supabase.storage
                    .from("scan-images")
                    .upload(fileName, data: data, options: FileOptions(upsert: true))
                let url = try supabase.storage
                    .from("scan-images")
                    .getPublicURL(path: fileName)
                imageURL = url.absoluteString
            }
            
            // ✅ บันทึกลง DB
            try await supabase
                .from("scan_history")
                .insert([
                    "user_id": user.id.uuidString,
                    "category": category,
                    "bin_type": binForCategory(category),
                    "image_url": imageURL ?? "",
                    "points": "10"
                ])
                .execute()
            
            // ✅ อัปเดตคะแนนใน user metadata
            let currentPoints = (user.userMetadata["points"]?.intValue ?? 0) + 1
            try await supabase.auth.update(
                user: UserAttributes(data: ["points": .integer(currentPoints)])  
            )
            
            showSaveSuccess = true
        } catch {
            print("Save error: \(error)")
            showSaveError = true
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
                        Text("สแกนบาร์โค้ด")
                            .font(.noto(config.fontTitle, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack {
                            BackButton()
                            Spacer()
                            Button {
                                Task { await saveScan() }
                            } label: {
                                Text("บันทึก")
                                    .font(.noto(config.isIPad ? 20 : 16, weight: .medium))
                                    .foregroundColor(.mainColor)
                            }
                        }
                    }
                    .padding(.horizontal, config.isIPad ? 60 : 20)
                    .padding(.bottom, config.isIPad ? 40 : 27)
                    .padding(.top, config.headerTopPadding)

                    // MARK: - Content Section
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            // Image Section
                            if let uiImage = capturedImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: config.isIPad ? 450 : 290)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.horizontal, config.isIPad ? 60 : 20)
                                    .padding(.bottom, config.isIPad ? 40 : 30)
                            } else {
                                Image("BarcodeEx")
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(1.25, contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(.horizontal, config.isIPad ? 60 : 20)
                            }
                            
                            // ✅ ส่ง config เข้าไปในทุก Component
                            switch category {
                            case "ขวดพลาสติก":
                                RecycleWasteDetailPlasticBottle(config: config, showDate: true)
                            case "แก้วพลาสติก":
                                RecycleWasteDetailPlasticCup(config: config, showDate: true)
                            case "กระป๋อง":
                                RecycleWasteDetailCan(config: config, showDate: true)
                            case "กล่องกระดาษ":
                                RecycleWasteDetailCardboardBox(config: config, showDate: true)
                            case "กระดาษทั่วไป":
                                RecycleWasteDetailPaper(config: config, showDate: true)
                            case "ถุงพลาสติก":
                                RecycleWasteDetailPlasticBag(config: config, showDate: true)
                            default:
                                Text("ไม่พบข้อมูลประเภทขยะนี้")
                                    .font(.noto(config.isIPad ? 24 : 18, weight: .medium))
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                        .frame(minHeight: 750)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                .ignoresSafeArea(.container, edges: .top)
            }
            .navigationBarHidden(true)
            .onAppear {
                hideTabBar = true
            }
            .overlay {
                if showSaveSuccess {
                    SuccessPopupView(message: "บันทึกสำเร็จ!\n+10 คะแนน") {
                        showSaveSuccess = false
                        dismiss()
                    }
                }
                if showSaveError {
                    ErrorPopupView(title: "บันทึกไม่สำเร็จ") {
                        showSaveError = false
                    }
                }
            }
        }
    }
}

#Preview {
    DetailBarcodeView(hideTabBar: .constant(true), category: "กล่องกระดาษ")
}
