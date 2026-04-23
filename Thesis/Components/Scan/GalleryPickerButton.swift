//
//  GalleryPickerButton.swift
//  Thesis
//
//  Created by Penpitcha Sureepitak on 21/12/2568 BE.
//
import SwiftUI
import PhotosUI

struct GalleryPickerButton: View {
    
    @Binding var selectedItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Image("Gallery")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background(Color.secondColor)
                .clipShape(Circle())
        }
    }
}

