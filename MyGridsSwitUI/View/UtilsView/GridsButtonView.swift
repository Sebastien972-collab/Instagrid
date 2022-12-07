//
//  GridsButtonView.swift
//  MyGridsSwitUI
//
//  Created by Sébastien DAGUIN on 06/12/2022.
//

import SwiftUI
import UIKit

struct GridsButtonView: View {
    @Binding var imageSaved: UIImage?
    @State var currentImage : UIImage?
    @State var confirmDiagIsPresented = false
    @State var imagePickerIsPresented = false
    @State var selection : UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        ZStack {
            Button {
                confirmDiagIsPresented.toggle()
            } label: {
                if let newImage = currentImage {
                    Image(uiImage: newImage)
                        .resizable()
                        .renderingMode(.original)
                        .clipped()
                } else if let imageSaved = imageSaved, imageSaved != UIImage(named: "Plus") {
                    Image(uiImage: imageSaved)
                        .resizable()
                        .renderingMode(.original)
                        .clipped()
                } else {
                    Image(uiImage: UIImage(named: "Plus")!)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipped()
                }
                
            }
            .confirmationDialog("Choose a picture", isPresented: $confirmDiagIsPresented, titleVisibility: .visible) {
                Button("Camera") {
                    selection = .camera
                    imagePickerIsPresented.toggle()
                }
                Button("Photo Library") {
                    selection = .photoLibrary
                    imagePickerIsPresented.toggle()
                    print("<<<<<<<<<<<<<<<<<<<<<<<<< Image >>>>>>>>><")
                    print(currentImage == nil)
                }
            }
        }
        .frame(minWidth: 130, maxWidth: .infinity, minHeight: 130, maxHeight: 130)
        .background(Color.white)
        .sheet(isPresented: $imagePickerIsPresented) {
            ImagePicker(image: $currentImage, sourceType: selection)
        }
        .onDisappear() {
            if let imageToSave = currentImage {
                imageSaved = imageToSave
            }
        }
    }
}

struct GridsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.cyan
            GridsButtonView(imageSaved: .constant(nil))
        }
    }
}
