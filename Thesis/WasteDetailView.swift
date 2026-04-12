//
//  WasteDetailView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/4/2569 BE.
//


import SwiftUI
import Storage
import Auth

struct WasteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var hideTabBar: Bool
    var category: String
    var capturedImage: UIImage?
    var showBarcodeImage: Bool = false
    var title: String = "ยืนยันภาพถ่าย"
    var scanMethod: String = "search"

    @State private var isSaving = false
    @State private var showSaveSuccess = false
    @State private var showSaveError = false

    private func binForCategory(_ category: String) -> String {
        switch category {
        case "ขวดพลาสติก", "แก้วพลาสติก", "กระป๋อง", "กล่องกระดาษ", "กระดาษทั่วไป", "ถุงพลาสติก":
            return "ถังขยะรีไซเคิล"
        case "ซองขนม", "กระดาษทิชชู่", "ภาชนะใส่อาหาร", "ตะเกียบไม้", "หลอด", "ช้อน-ส้อมพลาสติก":
            return "ถังขยะทั่วไป"
        case "เศษอาหาร", "เปลือกไข่", "เปลือกผลไม้", "เครื่องดื่มเหลือ", "เศษขนม", "น้ำแข็งเหลือ":
            return "ถังขยะเปียก"
        default:
            return "ถังขยะทั่วไป"
        }
    }

    private func save() async {
        isSaving = true
        defer { isSaving = false }

        do {
            let user = try await supabase.auth.session.user
            var imageURL: String? = nil

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

            try await supabase
                .from("scan_history")
                .insert([
                    "user_id": user.id.uuidString,
                    "category": category,
                    "bin_type": binForCategory(category),
                    "image_url": imageURL ?? "",
                    "points": "10",
                    "scan_method": scanMethod
                ])
                .execute()
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
        ZStack {
            Color.backgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    Text(title)
                        .font(.noto(25, weight: .bold))
                        .foregroundColor(.black)

                    HStack {
                        BackButton()
                        Spacer()
                        Button {
                            Task { await save() }
                        } label: {
                            if isSaving {
                                ProgressView().padding(.trailing, 25)
                            } else {
                                Text("บันทึก")
                                    .font(.noto(16, weight: .medium))
                                    .foregroundColor(.mainColor)
                                    .padding(.trailing, 25)
                            }
                        }
                        .disabled(isSaving)
                    }
                }
                .padding(.bottom, 20)

                // MARK: - Content
                ScrollView {
                    VStack(spacing: 0) {
                        // รูปภาพ
                        Group {
                            if let uiImage = capturedImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Image("BarcodeEx")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 290)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 30)

                        // รายละเอียดขยะ
                        switch category {
                        case "ขวดพลาสติก":   RecycleWasteDetailPlasticBottle(showDate: true)
                        case "แก้วพลาสติก":  RecycleWasteDetailPlasticCup(showDate: true)
                        case "กระป๋อง":      RecycleWasteDetailCan(showDate: true)
                        case "กล่องกระดาษ":  RecycleWasteDetailCardboardBox(showDate: true)
                        case "กระดาษทั่วไป": RecycleWasteDetailPaper(showDate: true)
                        case "ถุงพลาสติก":   RecycleWasteDetailPlasticBag(showDate: true)
                        case "ซองขนม":       GeneralWasteDetailSnackBag(showDate: true)
                        case "ภาชนะใส่อาหาร": GeneralWasteDetailFoodContainer(showDate: true)
                        case "หลอด":         GeneralWasteDetailStraw(showDate: true)
                        case "กระดาษทิชชู่": GeneralWasteDetailTissue(showDate: true)
                        case "ตะเกียบไม้":   GeneralWasteDetailChopsticks(showDate: true)
                        case "ช้อน-ส้อมพลาสติก": GeneralWasteDetailSpoon(showDate: true)
                        case "เศษอาหาร":     WetWasteDetailFoodscraps(showDate: true)
                        case "เปลือกผลไม้":  WetWasteDetailFruitPeel(showDate: true)
                        case "เศษขนม":       WetWasteDetailCrumbs(showDate: true)
                        case "เปลือกไข่":    WetWasteDetailEggshell(showDate: true)
                        case "เครื่องดื่มเหลือ": WetWasteDetailLeftoverDrinks(showDate: true)
                        case "น้ำแข็งเหลือ": WetWasteDetailLeftoverIce(showDate: true)
                        default:
                            Text("ไม่พบข้อมูลประเภทขยะนี้")
                                .font(.noto(18, weight: .medium))
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .frame(minHeight: 750)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationBarHidden(true)
        .onAppear { hideTabBar = true }
        .overlay {
            if showSaveSuccess {
                SuccessPopupView(message: "บันทึกสำเร็จ") {
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
