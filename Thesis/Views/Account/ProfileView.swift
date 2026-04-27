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
    
    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }
    
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
                        Text(L("แก้ไขโปรไฟล์"))
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
                                    Text(L("แก้ไข"))
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
                                    title: L("first_name"),
                                    placeholder: L("enter_first_name"),
                                    text: $viewModel.name,
                                    isEditing: $viewModel.isEditing,
                                    isInvalid: $viewModel.isNameInvalid,
                                    isSubmitted: $viewModel.isSubmitted,
                                    errorMessage: viewModel.name.isEmpty
                                        ? L("error_empty_first_name")
                                        : L("error_invalid_first_name"),
                                    onEditingChanged: { viewModel.clearError(for: "name") },
                                    config: config
                                )
                                .onChange(of: viewModel.name) { _, _ in viewModel.clearError(for: "name") }
                                
                                ProfileInputField(
                                    title: L("last_name"),
                                    placeholder: L("enter_last_name"),
                                    text: $viewModel.lastName,
                                    isEditing: $viewModel.isEditing,
                                    isInvalid: $viewModel.isLastNameInvalid,
                                    isSubmitted: $viewModel.isSubmitted,
                                    errorMessage: viewModel.lastName.isEmpty ? L("error_empty_last_name")
                                    : L("error_invalid_last_name"),
                                    onEditingChanged: { viewModel.clearError(for: "lastName") },
                                    config: config
                                )
                                .onChange(of: viewModel.lastName) { _, _ in viewModel.clearError(for: "lastName") }
                                
                                ProfileEmailField(title: L("email"),email: viewModel.email, isEditing: $viewModel.isEditing, config: config)
                                
                                ProfileInputField(
                                    title: L("phone"),
                                    placeholder: L("phone_placeholder"),
                                    text: $viewModel.phoneNumber,
                                    isEditing: $viewModel.isEditing,
                                    isInvalid: $viewModel.isPhoneInvalid,
                                    isSubmitted: $viewModel.isSubmitted,
                                    errorMessage: viewModel.phoneNumber.isEmpty ? L("error_empty_phone")
                                    : L("error_invalid_phone"),
                                    keyboardType: .numberPad,
                                    onEditingChanged: { viewModel.clearError(for: "phone") },
                                    config: config
                                )
                                .onChange(of: viewModel.phoneNumber) { _, _ in viewModel.clearError(for: "phone") }
                                
                                if viewModel.isOAuthUser {
                                    VStack(alignment: .leading, spacing: config.isIPad ? 6 : 4) {
                                        Text(L("รหัสผ่าน"))
                                            .font(.noto(config.fontTitle, weight: .bold))
                                            .foregroundColor(.black)
                                            .padding(.leading, 6)
                                        
                                        NavigationLink(destination: ConfirmEmailView(currentEmail: viewModel.email)) {
                                            HStack {
                                                Text(L("กรุณาตั้งรหัสผ่าน"))
                                                    .font(.noto(config.accountRowFontSize, weight: .medium))
                                                    .foregroundColor(Color.dangerColor)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: config.isIPad ? 24 : 18))
                                                    .foregroundColor(Color.mainColor)
                                            }
                                            .padding(.horizontal, config.paddingMedium)
                                            .frame(width: config.isIPad ? 545 : 345, height: config.isIPad ? 60 : 49)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: config.bannerCornerRadius)
                                                    .stroke(Color.placeholderColor, lineWidth: config.isIPad ? 3 : 2)
                                            )
                                            .background(Color.backgroundColor)
                                        }
                                        
                                        Color.clear
                                            .frame(maxWidth: .infinity, minHeight: config.isIPad ? 26 : 20)
                                    }
                                    .padding(.horizontal, config.paddingMedium)
                                    .frame(maxWidth: .infinity)
                                } else {
                                    ProfilePasswordField(
                                        title: L("รหัสผ่าน"),
                                        password: viewModel.password,
                                        isEditing: $viewModel.isEditing,
                                        currentEmail: viewModel.email,
                                        config: config
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            
                            Spacer(minLength: 40)
                            
                            if viewModel.isEditing {
                                HStack(spacing: config.isIPad ? 50 : 35) {
                                    SecondButton(
                                        title: L("ยกเลิก"),
                                        action: { viewModel.cancelEditing() },
                                        width: config.profileButtonWidth,
                                        height: config.buttonHeight
                                    )
                                    PrimaryButton(
                                        title: L("บันทึก"),
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
                    .scrollDismissesKeyboard(.interactively)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.backgroundColor)
                .ignoresSafeArea(edges: .top)
                .blur(radius: (viewModel.showSuccessPopup || viewModel.showErrorPopup) ? 3 : 0)
                .disabled(viewModel.showSuccessPopup || viewModel.showErrorPopup)
                .onAppear {
                    emailChangeSuccess = false
                    viewModel.isEditing = false
                    Task { await viewModel.loadProfile() }
                    NotificationCenter.default.post(name: .popToProfile, object: nil)
                }
                
                // MARK: - Popups
                if viewModel.showSuccessPopup {
                    SuccessPopupView(message: L("บันทึกข้อมูลสำเร็จ")) {
                        withAnimation { viewModel.showSuccessPopup = false }
                    }
                }
                
                if viewModel.showErrorPopup {
                    ErrorPopupView(title: L("บันทึกไม่สำเร็จ"), onDismiss: {
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
