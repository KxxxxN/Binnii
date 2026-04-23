//
//  ProfileViewModel.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 12/1/2569 BE.
//


import Foundation
import SwiftUI
import Supabase

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Input Fields
    @Published var name: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    
    // MARK: - UI States
    @Published var isEditing: Bool = false
    @Published var isSubmitted: Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var showSuccessPopup: Bool = false
    @Published var showErrorPopup: Bool = false
    
    // MARK: - Validation States
    @Published var isNameInvalid: Bool = false
    @Published var isLastNameInvalid: Bool = false
    @Published var isPhoneInvalid: Bool = false
    
    // MARK: - Original Data (ใช้สำหรับยกเลิก)
    private var originalName: String = ""
    private var originalLastName: String = ""
    private var originalPhone: String = ""
    
    @Published var profileImage: UIImage? = nil
    @Published var navigateToAccount: Bool = false
    
    init() {
        Task { await loadProfile() }
    }
    
    func loadProfile() async {
        do {
            let user = try await supabase.auth.session.user
            let meta = user.userMetadata
            
            print("avatar_url: \(meta["avatar_url"]?.stringValue ?? "nil")")
            
            self.email = user.email ?? ""
            self.name = meta["first_name"]?.stringValue ?? ""
            self.lastName = meta["last_name"]?.stringValue ?? ""
            self.phoneNumber = meta["phone"]?.stringValue ?? ""
            
            // ✅ โหลดรูปจาก URL
            if let avatarURLString = meta["avatar_url"]?.stringValue,
               let url = URL(string: avatarURLString) {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    self.profileImage = image
                }
            }
            
            saveOriginalData()
        } catch {
            print("Load profile error: \(error.localizedDescription)")
        }
    }

    private func saveOriginalData() {
        originalName = name
        originalLastName = lastName
        originalPhone = phoneNumber
    }
    
    // MARK: - Functions
    
    func startEditing() {
        saveOriginalData()
        isEditing = true
        isSubmitted = false
    }
    
    func cancelEditing() {
        name = originalName
        lastName = originalLastName
        phoneNumber = originalPhone
        
        isNameInvalid = false
        isLastNameInvalid = false
        isPhoneInvalid = false
        isEditing = false
        isSubmitted = false
    }
    
    func clearError(for field: String) {
        switch field {
        case "name": isNameInvalid = false
        case "lastName": isLastNameInvalid = false
        case "phone": isPhoneInvalid = false
        default: break
        }
    }
    
    func validateForm() -> Bool {
        isNameInvalid = name.isEmpty || !ValidationHelper.isNameValid(name: name)
        isLastNameInvalid = lastName.isEmpty || !ValidationHelper.isNameValid(name: lastName)
        isPhoneInvalid = phoneNumber.isEmpty || !ValidationHelper.isValidPhone(phoneNumber)
        
        return !isNameInvalid && !isLastNameInvalid && !isPhoneInvalid
    }
    
    func uploadProfileImage(_ image: UIImage) async {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            let user = try await supabase.auth.session.user
            let fileName = "\(user.id).jpg"
            
            try await supabase.storage
                .from("avatars")
                .upload(
                    fileName,
                    data: data,
                    options: FileOptions(cacheControl: "3600", upsert: true)
                )
            
            let url = try supabase.storage
                .from("avatars")
                .getPublicURL(path: fileName)
            
            try await supabase.auth.update(
                user: UserAttributes(data: [
                    "avatar_url": .string(url.absoluteString)
                ])
            )
        } catch {
            print("Upload error: \(error.localizedDescription)")
        }
    }

    func saveProfile() async {
        isSubmitted = true
        
        if validateForm() {
            do {
                try await supabase.auth.update(
                    user: UserAttributes(data: [
                        "first_name": .string(name),
                        "last_name": .string(lastName),
                        "phone": .string(phoneNumber)
                    ])
                )
                
                saveOriginalData()
                
                withAnimation {
                    showSuccessPopup = true
                    isEditing = false
                    isSubmitted = false
                }
            } catch {
                print("Save profile error: \(error.localizedDescription)")
                withAnimation {
                    showErrorPopup = true
                }
            }
        } else {
            withAnimation {
                showErrorPopup = true
            }
        }
    }
}

