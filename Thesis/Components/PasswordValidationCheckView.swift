//
//  PasswordValidationCheckView.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 6/1/2569 BE.
//

import SwiftUI

struct ValidationRow: View {
    let title: String
    let passed: Bool
    let checkColor: Color
    let defaultColor: Color
    let config: ResponsiveConfig 
    
    var body: some View {
        HStack(spacing: config.isIPad ? 8 : 4) {
            Image(systemName: passed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(passed ? checkColor : defaultColor)
                .font(.system(size: config.isIPad ? 18 : 14))
            
            Text(title)
                .font(.noto(config.isIPad ? 18 : 14, weight: .medium))
                .foregroundColor(passed ? checkColor : defaultColor)
        }
    }
}

struct PasswordValidationCheckView: View {
    let password: String
    let config: ResponsiveConfig
    
    var body: some View {
        let checkColor: Color = Color.mainColor
        let defaultColor: Color = Color.placeholderColor
        
        VStack(alignment: .leading, spacing: config.isIPad ? 6 : 3) {
            // เรียกใช้ ValidationHelper ตรงๆ เลย
            ValidationRow(
                title: "อย่างน้อย 8 ตัวอักษร",
                passed: ValidationHelper.hasMinimumLength(password),
                checkColor: checkColor,
                defaultColor: defaultColor,
                config: config)
            
            ValidationRow(
                title: "มีตัวอักษรพิมพ์ใหญ่ อย่างน้อย 1 ตัว (A–Z)",
                passed: ValidationHelper.hasUppercase(password),
                checkColor: checkColor,
                defaultColor: defaultColor,
                config: config)
            
            ValidationRow(
                title: "มีตัวอักษรพิมพ์เล็ก อย่างน้อย 1 ตัว (a–z)",
                passed: ValidationHelper.hasLowercase(password),
                checkColor: checkColor,
                defaultColor: defaultColor,
                config: config)
            
            ValidationRow(
                title: "มีตัวเลข อย่างน้อย 1 ตัว (0–9)",
                passed: ValidationHelper.hasDigit(password),
                checkColor: checkColor,
                defaultColor: defaultColor,
                config: config)
            
            ValidationRow(
                title: "มีอักขระพิเศษ อย่างน้อย 1 ตัว (!@#$%&*_-)",
                passed: ValidationHelper.hasSpecialCharacter(password),
                checkColor: checkColor,
                defaultColor: defaultColor,
                config: config)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, config.paddingStandard)
    }
}
