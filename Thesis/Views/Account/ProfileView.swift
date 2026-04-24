//
//  ProfileView.swift
//  Thesis
//

import SwiftUI
import PhotosUI

@MainActor
struct ProfileView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @AppStorage("emailChangeSuccess") var emailChangeSuccess = false
    
    init() {
        _viewModel = StateObject(wrappedValue: ProfileViewModel())
    }
    
    var body: some View {
        GeometryReader { geo in
            let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)
            ZStack {
                VStack(spacing: 0) {
                    // MARK: - Header
                    ZStack {
                        Text("แก้ไขโปรไฟล์")
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .foregroundColor(Color.black)
                            .padding(.top, config.headerTopPadding)
                            .padding(.bottom, config.bottomTitlePadding)
                        
                        
                        HStack {
                            BackButton(action: {
                                viewModel.cancelEditing()
                                NotificationCenter.default.post(name: .popToAccount, object: nil)
                            })
                            
                            Spacer()
                            
                            if !viewModel.isEditing {
                                Button(action: { viewModel.startEditing() }) {
                                    Text("แก้ไข")
                                        .font(.noto(config.fontBody, weight: .medium))
                                        .foregroundColor(Color.mainColor)
                                        .padding(.horizontal, config.paddingStandard)
                                }
                            }
                        }
                        .padding(.top, config.headerTopPadding)
                        .padding(.bottom, config.bottomTitlePadding)
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            // MARK: - Profile Image
                            let isEditing = viewModel.isEditing
                            let profileImageSnapshot = viewModel.profileImage
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Group {
                                    if let image = profileImageSnapshot {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: config.profileImageSize, height: config.profileImageSize)
                                            .clipShape(Circle())
                                    } else {
                                        Image("Profile")
                                            .resizable()
                                            .frame(width: config.profileImageSize, height: config.profileImageSize)
                                            .clipShape(Circle())
                                    }
                                }
                                .overlay {
                                    if isEditing {
                                        Circle()
                                            .fill(Color.black.opacity(0.3))
                                    }
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    if isEditing {
                                        Image(systemName: "pencil")
                                            .font(.system(size: config.isIPad ? 32 : 24))
                                            .foregroundColor(.black)
                                            .offset(x: 8, y: 5)
                                    }
                                }
                            }
                            .padding(.top, 11)
                            .padding(.bottom, 11)
                            .disabled(!isEditing)
                            .onChange(of: selectedItem) { _, newItem in
                                Task { @MainActor in
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data) {
                                        viewModel.profileImage = image
                                        await viewModel.uploadProfileImage(image)
                                    }
                                }
                            }
                            
                            // MARK: - Form
                            VStack(alignment: .leading, spacing: 0){
                                
                                ProfileInputField(
                                    title: "ชื่อ",
                                    placeholder: "ป้อนชื่อของคุณ",
                                    text: $viewModel.name,
                                    isEditing: $viewModel.isEditing,
                                    isInvalid: $viewModel.isNameInvalid,
                                    isSubmitted: $viewModel.isSubmitted,
                                    errorMessage: viewModel.name.isEmpty ? "กรุณากรอกชื่อ" : "กรุณากรอกชื่อให้ถูกต้อง",
                                    onEditingChanged: { viewModel.clearError(for: "name") },
                                    config: config
                                )
                                .onChange(of: viewModel.name) { _, _ in viewModel.clearError(for: "name") }
                                
                                ProfileInputField(
                                    title: "นามสกุล",
                                    placeholder: "ป้อนนามสกุลของคุณ",
                                    text: $viewModel.lastName,
                                    isEditing: $viewModel.isEditing,
                                    isInvalid: $viewModel.isLastNameInvalid,
                                    isSubmitted: $viewModel.isSubmitted,
                                    errorMessage: viewModel.lastName.isEmpty ? "กรุณากรอกนามสกุล" : "กรุณากรอกนามสกุลให้ถูกต้อง",
                                    onEditingChanged: { viewModel.clearError(for: "lastName") },
                                    config: config
                                )
                                .onChange(of: viewModel.lastName) { _, _ in viewModel.clearError(for: "lastName") }
                                
                                ProfileEmailField(title: "อีเมล", email: viewModel.email, isEditing: $viewModel.isEditing, config: config)
                                
                                ProfileInputField(
                                    title: "เบอร์โทร",
                                    placeholder: "0XX-XXX-XXXX",
                                    text: $viewModel.phoneNumber,
                                    isEditing: $viewModel.isEditing,
                                    isInvalid: $viewModel.isPhoneInvalid,
                                    isSubmitted: $viewModel.isSubmitted,
                                    errorMessage: viewModel.phoneNumber.isEmpty ? "กรุณากรอกเบอร์โทร" : "กรุณากรอกเบอร์โทรให้ถูกต้อง",
                                    keyboardType: .numberPad,
                                    onEditingChanged: { viewModel.clearError(for: "phone") },
                                    config: config
                                )
                                .onChange(of: viewModel.phoneNumber) { _, _ in viewModel.clearError(for: "phone") }
                                
                                ProfilePasswordField(title: "รหัสผ่าน", password: viewModel.password, isEditing: $viewModel.isEditing, currentEmail: viewModel.email, config: config)
                            }
                            .frame(maxWidth: config.profileMaxWidth, alignment: .leading)
                            .padding(.leading, config.paddingStandard)
                            
                            Spacer(minLength: 40)
                            
                            if viewModel.isEditing {
                                HStack(spacing: config.isIPad ? 50 : 35) {
                                    SecondButton(
                                        title: "ยกเลิก",
                                        action: { viewModel.cancelEditing() },
                                        width: config.profileButtonWidth,
                                        height: config.buttonHeight
                                    )
                                    PrimaryButton(
                                        title: "บันทึก",
                                        action: {
                                            Task { await viewModel.saveProfile() }
                                        },
                                        width: config.profileButtonWidth,
                                        height: config.buttonHeight
                                    )
                                }
                                .padding(.bottom, 40)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.backgroundColor)
                .ignoresSafeArea()
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                .onAppear {
                    emailChangeSuccess = false
                    viewModel.isEditing = false
                    NotificationCenter.default.post(name: .popToProfile, object: nil)
                }
                
                // MARK: - Popups
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: "บันทึกข้อมูลสำเร็จ") {
                        withAnimation { viewModel.showSuccessPopup = false }
                    }
                }
                
                if viewModel.showErrorPopup {
                    ErrorPopupView(title: "บันทึกไม่สำเร็จ", onDismiss: {
                        withAnimation { viewModel.showErrorPopup = false }
                    })
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ProfileView()
}
