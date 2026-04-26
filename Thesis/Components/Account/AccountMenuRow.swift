import SwiftUI

// MARK: - 1. Component: แถวเมนูทั่วไป
struct AccountMenuRow<Destination: View>: View {
    let title: String
    let imageName: String
    let destination: Destination?
    let action: (() -> Void)?
    let config: ResponsiveConfig

    init(title: String, imageName: String, config: ResponsiveConfig, destination: Destination) {
        self.title = title
        self.imageName = imageName
        self.config = config
        self.destination = destination
        self.action = nil
    }

    init(title: String, imageName: String, config: ResponsiveConfig, action: @escaping () -> Void) where Destination == EmptyView {
        self.title = title
        self.imageName = imageName
        self.config = config
        self.action = action
        self.destination = nil
    }

    var rowContent: some View {
        HStack(spacing: config.accountRowSpacing) {
            Image(imageName)
                .resizable()
                .frame(width: config.accountRowIconSize, height: config.accountRowIconSize)
                .padding(.leading, config.accountRowIconLeading)

            Text(title)
                .font(.noto(config.accountRowFontSize, weight: .medium))
                .foregroundColor(Color.black)

            Spacer()

            if destination != nil || title == "แก้ไขโปรไฟล์" || title == "เปลี่ยนภาษา" || title == "ช่วยเหลือ" || title == "ติดต่อเรา" {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.system(size: config.accountRowChevronSize, weight: .bold))
            }
        }
        .padding(.trailing)
        .frame(height: config.accountRowHeight)
        .background(Color.accountSecColor)
    }

    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination) {
                rowContent
            }
        } else if let action = action {
            Button(action: action) {
                rowContent
            }
        } else {
            rowContent
        }
    }
}

// MARK: - 2. Component: แถวเมนูที่มี Toggle (การแจ้งเตือน)
struct AccountToggleRow: View {
    let title: String
    let imageName: String
    @Binding var isOn: Bool
    let config: ResponsiveConfig

    // แสดง alert เมื่อ permission ถูกปฏิเสธ
    @State private var showPermissionDeniedAlert = false

    var body: some View {
        HStack(spacing: config.accountRowSpacing) {
            Image(imageName)
                .resizable()
                .frame(width: config.accountRowIconSize, height: config.accountRowIconSize)
                .padding(.leading, config.accountRowIconLeading)

            Text(title)
                .font(.noto(config.accountRowFontSize, weight: .medium))
                .foregroundColor(Color.black)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.mainColor)
                .fixedSize()
                .scaleEffect(config.isIPad ? 1.2 : 1.0)
                .onChange(of: isOn) { _, newValue in
                    handleToggle(newValue)
                }
        }
        .padding(.trailing)
        .frame(height: config.accountRowHeight)
        .background(Color.accountSecColor)
        // Alert เมื่อผู้ใช้ปฏิเสธ permission
        .alert("ไม่สามารถเปิดการแจ้งเตือนได้", isPresented: $showPermissionDeniedAlert) {
            Button("ไปที่การตั้งค่า") {
                openAppSettings()
            }
            Button("ยกเลิก", role: .cancel) {
                // คืนค่า toggle กลับเป็น false เพราะไม่ได้รับ permission
                isOn = false
            }
        } message: {
            Text("กรุณาเปิดการแจ้งเตือนในการตั้งค่าของ iPhone\nการตั้งค่า > การแจ้งเตือน > แอปนี้")
        }
    }

    // MARK: - Logic

    private func handleToggle(_ newValue: Bool) {
        if newValue {
            // ผู้ใช้กด ON → ตรวจสอบ / ขอ permission
            requestNotificationPermission()
        } else {
            // ผู้ใช้กด OFF → ยกเลิกการแจ้งเตือนทั้งหมด
            NotificationManager.shared.cancelDailyReminder()
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {

                case .notDetermined:
                    // ยังไม่เคยถาม → ขอ permission
                    NotificationManager.shared.requestPermission { granted in
                        if granted {
                            scheduleDefaultReminder()
                        } else {
                            // ผู้ใช้กด "ไม่อนุญาต"
                            isOn = false
                        }
                    }

                case .authorized, .provisional, .ephemeral:
                    // มี permission อยู่แล้ว → เปิดเลย
                    scheduleDefaultReminder()

                case .denied:
                    // ถูกปฏิเสธ → แจ้งให้ไปเปิดใน Settings
                    isOn = false
                    showPermissionDeniedAlert = true

                @unknown default:
                    isOn = false
                }
            }
        }
    }

    /// ตั้งค่า default ให้ใช้ตารางแจ้งเตือนใน NotificationManager (12:00 และ 16:00)
    private func scheduleDefaultReminder() {
        // ใช้ API ที่มีอยู่แล้ว ซึ่งจะตั้งทั้งสองเวลาให้โดยอัตโนมัติ
        NotificationManager.shared.scheduleDailyReminder(hour: 0, minute: 0)
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
