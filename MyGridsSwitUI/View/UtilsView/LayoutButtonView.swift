//
//  LayoutButton.swift
//  MyGridsSwitUI
//
//  Created by Sébastien DAGUIN on 06/12/2022.
//

import SwiftUI

struct LayoutButtonView: View {
    var layout : Layout
    @Binding var layoutSelected : Layout
    var body: some View {
        ZStack {
            Button {
                layoutSelected = layout
            } label: {
                ZStack {
                    Image(layout.rawValue)
                        .resizable()
                        .frame(width: 80, height: 80)
                    if layout == layoutSelected {
                        Image("Selected")
                            .resizable()
                        .frame(width: 80, height: 80)
                    }
                    
                }
            }
            
        }
    }
}

struct LayoutButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            LayoutButtonView(layout: .layout2, layoutSelected: .constant(.layout2))
        }
    }
}
