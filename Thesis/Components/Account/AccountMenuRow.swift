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
                    .scaleEffect(config.isIPad ? 1.2 : 1.0)
            }
            .padding(.trailing)
            .frame(height: config.accountRowHeight)
            .background(Color.accountSecColor)
        }
    }
}
