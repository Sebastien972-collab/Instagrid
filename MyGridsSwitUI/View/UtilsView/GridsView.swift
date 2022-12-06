//
//  GridsView.swift
//  MyGridsSwitUI
//
//  Created by Sébastien DAGUIN on 06/12/2022.
//

import SwiftUI

struct GridsView: View {
    var layout : Layout
    @State var savedImages: UIImage?
    @State private var imagePlus = UIImage(named: "Plus")
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            HStack {
                GridsButtonView(imageSaved: .constant(nil))
                if layout == .layout1 || layout == .layout3 {
                    if layout == .layout3 {
                        GridsButtonView(imageSaved: $imagePlus)
                    } else {
                        GridsButtonView(imageSaved: $savedImages)
                    }
                       
                       
                }
                
            }
            .padding(.top,10)
            HStack {
                GridsButtonView(imageSaved: .constant(nil))
                if layout == .layout2 || layout == .layout3 {
                    GridsButtonView(imageSaved: $savedImages)
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 10)
        .background(Color.customBleu)
        .frame(width: 300, height: 300)
    }
}

struct GridsView_Previews: PreviewProvider {
    static var previews: some View {
        GridsView(layout: .layout2)
    }
}
