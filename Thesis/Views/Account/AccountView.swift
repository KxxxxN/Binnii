//
//  AccountView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 5/11/2568 BE.
//

import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var showLogoutPopup = false
    @State private var showErrorPopup = false
    @State private var errorTitle = ""
    @State private var showDeleteAccountPopup = false
    @EnvironmentObject var authViewModel: AuthViewModel

    @ObservedObject private var lm = LanguageManager.shared
    private func L(_ key: String) -> String { lm.localized(key) }

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {

                            // MARK: - Header
                            Text(L("บัญชีผู้ใช้"))
                                .font(.noto(config.titleFontSize, weight: .bold))
                                .padding(.top, config.headerTopPadding)
                                .padding(.bottom, config.bottomTitlePadding)

                            // MARK: - Menu Sections
                            VStack(spacing: config.groupSpacing) {

                                MenuSection(title: L("ข้อมูลผู้ใช้"), fontSize: config.sectionFontSize) {
                                    AccountMenuRow(
                                        title: L("แก้ไขโปรไฟล์"),
                                        imageName: "IconUser",
                                        config: config,
                                        action: { viewModel.navigate(to: .profile) }
                                    )
                                }

                                MenuSection(title: L("ตั้งค่า"), fontSize: config.sectionFontSize) {
                                    VStack(spacing: 0) {
                                        AccountMenuRow(
                                            title: L("เปลี่ยนภาษา"),
                                            imageName: "IconTranslate",
                                            config: config,
                                            action: { viewModel.navigate(to: .translate) }
                                        )
                                        AccountToggleRow(
                                            title: L("การแจ้งเตือน"),
                                            imageName: "IconNotification",
                                            isOn: $viewModel.isNotificationOn,
                                            config: config
                                        )
                                    }
                                }

                                MenuSection(title: L("ทั่วไป"), fontSize: config.sectionFontSize) {
                                    VStack(spacing: 0) {
                                        AccountMenuRow(
                                            title: L("ช่วยเหลือ"),
                                            imageName: "IconHelp",
                                            config: config,
                                            action: { viewModel.navigate(to: .helpCenter) }
                                        )
                                        AccountMenuRow(
                                            title: L("ติดต่อเรา"),
                                            imageName: "IconSupport",
                                            config: config,
                                            action: { viewModel.navigate(to: .contactUs) }
                                        )
                                    }
                                }

                                MenuSection(title: L("บัญชี"), fontSize: config.sectionFontSize, titleColor: .clear) {
                                    VStack(spacing: 0) {
                                        AccountMenuRow(
                                            title: L("ออกจากระบบ"),
                                            imageName: "IconLogout",
                                            config: config,
                                            action: { showLogoutPopup = true }
                                        )
                                        AccountMenuRow(
                                            title: L("ลบบัญชี"),
                                            imageName: "IconDelete",
                                            config: config,
                                            action: { showDeleteAccountPopup = true }
                                        )
                                    }
                                }
                            }

                            Spacer(minLength: 50)
                        }
                        .frame(width: config.screenWidth)
                    }

                    // MARK: - Popups
                    if showLogoutPopup {
                        LogoutPopupView(
                            isPresented: $showLogoutPopup,
                            onConfirm: {
                                Task {
                                    viewModel.hasError = false
                                    await viewModel.signOut()
                                    if viewModel.hasError {
                                        errorTitle = L("ออกจากระบบไม่สำเร็จ")
                                        showErrorPopup = true
                                    }
                                }
                            }
                        )
                    }

                    if showDeleteAccountPopup {
                        DeleteAccountPopupView(
                            isPresented: $showDeleteAccountPopup,
                            onConfirm: {
                                Task {
                                    viewModel.hasError = false
                                    await viewModel.deleteAccount()
                                    if viewModel.hasError {
                                        errorTitle = L("ลบบัญชีไม่สำเร็จ")
                                        showErrorPopup = true
                                    } else {
                                        viewModel.navigate(to: .deleteAccountSuccess)
                                    }
                                }
                            }
                        )
                    }

                    if showErrorPopup {
                        ErrorPopupView(
                            title: errorTitle,
                            onDismiss: { showErrorPopup = false }
                        )
                    }
                }
            }
            .background(Color.backgroundColor)
            .ignoresSafeArea()
            .navigationBarHidden(true)

            .onAppear {
                Task { await viewModel.loadSession() }
            }

            .navigationDestination(for: AccountDestination.self) { destination in
                switch destination {
                case .profile: ProfileView()
                case .translate: TranslateView()
                case .helpCenter: HelpCenterView()
                case .contactUs: ContactUsView()
                case .confirmPassword: ConfirmPasswordView()
                case .confirmEmail(let email): ConfirmEmailView(currentEmail: email)
                case .deleteAccountSuccess:
                    DeleteAccountSuccessView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}

#Preview {
    AccountView()
}

