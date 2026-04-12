//
//  AccountView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

enum AccountDestination: Hashable {
    case profile
    case translate
    case helpCenter
    case contactUs
    case confirmPassword
    case confirmEmail(String)
//    case newPassword
//    case confirmEmail(String)
//    case otp(String)
}

struct AccountView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isNotificationOn = true
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var path = NavigationPath()
    
    // 1. ดึง Size Class มาจาก Environment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geo in
                // 2. เรียกใช้ ResponsiveConfig ไฟล์เดียวจบ
                let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // Header Title
                        Text("บัญชีผู้ใช้")
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .padding(.top, config.topPadding)
                            .padding(.bottom, config.bottomTitlePadding)
                        
                        // Main Content Group
                        VStack(spacing: config.groupSpacing) {
                            
                            // --- กลุ่ม: ข้อมูลผู้ใช้ ---
                            menuSection(title: "ข้อมูลผู้ใช้", fontSize: config.sectionFontSize) {
                                AccountMenuRow(
                                    title: "แก้ไขโปรไฟล์",
                                    imageName: "IconUser", config: config,
                                    action: { path.append(AccountDestination.profile) }
                                )
                            }
                            
                            // --- กลุ่ม: ตั้งค่า ---
                            menuSection(title: "ตั้งค่า", fontSize: config.sectionFontSize) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "เปลี่ยนภาษา",
                                        imageName: "IconTranslate", config: config,
                                        action: { path.append(AccountDestination.translate) }
                                    )
                                    AccountToggleRow(
                                        title: "การแจ้งเตือน",
                                        imageName: "IconNotification",
                                        isOn: $isNotificationOn, config: config,
                                    )
                                }
                            }
                            
                            // --- กลุ่ม: ทั่วไป ---
                            menuSection(title: "ทั่วไป", fontSize: config.sectionFontSize) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "ช่วยเหลือ",
                                        imageName: "IconHelp", config: config,
                                        action: { path.append(AccountDestination.helpCenter) }
                                    )
                                    AccountMenuRow(
                                        title: "ติดต่อเรา",
                                        imageName: "IconSupport", config: config,
                                        action: { path.append(AccountDestination.contactUs) }
                                    )
                                }
                            }
                            
                            // --- กลุ่ม: บัญชี ---
                            menuSection(title: "บัญชี", fontSize: config.sectionFontSize, titleColor: .clear) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "ออกจากระบบ",
                                        imageName: "IconLogout", config: config,
                                        action: {
                                            Task {
                                                await authViewModel.signOut()
                                                isLoggedIn = false
                                            }
                                        }
                                    )
                                    AccountMenuRow(
                                        title: "ลบบัญชี",
                                        imageName: "IconDelete", config: config,
                                        action: { print("Delete Account") }
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .frame(width: config.screenWidth) // ให้กว้างเท่าหน้าจอ
                }
            }
            .background(Color.backgroundColor.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                Task { await authViewModel.getInitialSession() }
            }
            .navigationDestination(for: AccountDestination.self) { destination in
                switch destination {
                case .profile:        ProfileView()
                case .translate:      TranslateView()
                case .helpCenter:     HelpCenterView()
                case .contactUs:      ContactUsView()
                case .confirmPassword: ConfirmPasswordView()
                case .confirmEmail(let email): ConfirmEmailView(currentEmail: email)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .popToAccount)) { _ in
            path = NavigationPath()
        }
        .onReceive(NotificationCenter.default.publisher(for: .popToProfile)) { _ in
            while path.count > 1 { path.removeLast() }
        }
    }

    // 3. Helper View
    @ViewBuilder
    private func menuSection<Content: View>(
        title: String,
        fontSize: CGFloat,
        titleColor: Color = .black,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.noto(fontSize, weight: .bold))
                .foregroundColor(titleColor)
                .padding(.horizontal, 20)
            
            content()
        }
    }
}
#Preview {
    AccountView()
}

