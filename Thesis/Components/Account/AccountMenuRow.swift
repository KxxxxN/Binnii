import SwiftUI

// MARK: - 1. Component: แถวเมนูทั่วไป
struct AccountMenuRow<Destination: View>: View {
    let title: String
    let imageName: String
    let destination: Destination?
    let action: (() -> Void)?
    let config: ResponsiveConfig // เพิ่ม Config เข้ามา
    
    // Initializer สำหรับ NavigationLink (มีปลายทาง)
    init(title: String, imageName: String, config: ResponsiveConfig, destination: Destination) {
        self.title = title
        self.imageName = imageName
        self.config = config
        self.destination = destination
        self.action = nil
    }
    
    // Initializer สำหรับ Button (ไม่มีปลายทาง)
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
            
            // แสดง Chevron ถ้ามีปลายทาง (destination หรือ action ที่ไม่ใช่ Logout/Delete)
            if destination != nil || title == "แก้ไขโปรไฟล์" || title == "เปลี่ยนภาษา" || title == "ช่วยเหลือ" || title == "ติดต่อเรา" {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.system(size: config.accountRowChevronSize, weight: .bold)) // ใช้ขนาด Chevron จาก config
            }
        }
        .padding(.trailing)
        .frame(height: config.accountRowHeight) // ความสูงแถวจาก config
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
    
    var body: some View {
        Button(action: {
            isOn.toggle()
            print("\(title) toggled to \(isOn)")
        }) {
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
                    // หมายเหตุ: Toggle ของระบบ iOS ไม่สามารถใช้ .frame เพื่อขยายขนาดตรงๆ ได้
                    // หากต้องการให้ Toggle ใหญ่ขึ้นบน iPad อาจต้องใช้ .scaleEffect(config.isIPad ? 1.3 : 1.0) ช่วยครับ
                    .scaleEffect(config.isIPad ? 1.2 : 1.0)
            }
            .padding(.trailing)
            .frame(height: config.accountRowHeight) // ความสูงแถวจาก config
            .background(Color.accountSecColor)
        }
    }
}
