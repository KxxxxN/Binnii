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

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            GeometryReader { geo in
                let config = ResponsiveConfig(horizontalSizeClass: horizontalSizeClass, geo: geo)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // MARK: - Header
                        Text("บัญชีผู้ใช้")
                            .font(.noto(config.titleFontSize, weight: .bold))
                            .padding(.top, config.topPadding)
                            .padding(.bottom, config.bottomTitlePadding)
                        
                        // MARK: - Menu Sections
                        VStack(spacing: config.groupSpacing) {

                            MenuSection(title: "ข้อมูลผู้ใช้", fontSize: config.sectionFontSize) {
                                AccountMenuRow(
                                    title: "แก้ไขโปรไฟล์",
                                    imageName: "IconUser",
                                    config: config,
                                    action: { viewModel.navigate(to: .profile)
                                    }
                                )
                            }
                            
                            MenuSection(title: "ตั้งค่า", fontSize: config.sectionFontSize) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "เปลี่ยนภาษา",
                                        imageName: "IconTranslate",
                                        config: config,
                                        action: { viewModel.navigate(to: .translate)
                                        }
                                    )
                                    AccountToggleRow(
                                        title: "การแจ้งเตือน",
                                        imageName: "IconNotification",
                                        isOn: $viewModel.isNotificationOn,
                                        config: config,
                                    )
                                }
                            }
                            
                            MenuSection(title: "ทั่วไป", fontSize: config.sectionFontSize) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "ช่วยเหลือ",
                                        imageName: "IconHelp",
                                        config: config,
                                        action: { viewModel.navigate(to: .helpCenter)
                                        }
                                    )
                                    AccountMenuRow(
                                        title: "ติดต่อเรา",
                                        imageName: "IconSupport",
                                        config: config,
                                        action: { viewModel.navigate(to: .contactUs)
                                        }
                                    )
                                }
                            }

                            MenuSection(title: "บัญชี", fontSize: config.sectionFontSize, titleColor: .clear) {
                                VStack(spacing: 0) {
                                    AccountMenuRow(
                                        title: "ออกจากระบบ",
                                        imageName: "IconLogout",
                                        config: config,
                                        action: {
                                            Task { await viewModel.signOut()
                                            }
                                        }
                                    )
                                    AccountMenuRow(
                                        title: "ลบบัญชี",
                                        imageName: "IconDelete",
                                        config: config,
                                        action: { viewModel.deleteAccount()
                                        }
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .frame(width: config.screenWidth)
                }
            }
            .background(Color.backgroundColor.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await viewModel.loadSession()
                }
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
    }
}

#Preview {
    AccountView()
}

