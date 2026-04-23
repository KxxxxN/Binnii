//
//  PrimaryButton.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 10/12/2568 BE.
//


import SwiftUI
// MARK: - Button Component

//PrimaryButton
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.noto(20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(Color.mainColor)
                .cornerRadius(20)
        }
    }
}

//SecondButton
struct SecondButton: View {
    let title: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.noto(20, weight: .bold))
                .foregroundColor(.mainColor)
                .frame(width: width, height: height)
                .background(Color.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.mainColor, lineWidth: 2)
                )
        }
    }
}

//BackButton
//struct BackButton: View {
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        Button {
//            dismiss()
//        } label: {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.black)
//                .font(.system(size: 25))
//        }
//        .padding(.leading, 25)
//    }
//}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            if let action {
                action()
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 25))
        }
        .padding(.leading, 25)
    }
}

struct BackButtonWhite: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 25))
        }
        .padding(.leading, 25)
    }
}

struct XBackButtonWhite: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
        }
        .padding(.leading, 25)
    }
}

struct XBackButtonBlack: View {
    @Binding var index: Int

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.35)) {
                index = 0
            }
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundColor(.black)
                .frame(width: 24, height: 24)
        }
        .padding(.leading, 25)
    }
}


