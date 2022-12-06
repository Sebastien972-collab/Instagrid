//
//  MainGridsView.swift
//  MyGridsSwitUI
//
//  Created by Sébastien DAGUIN on 06/12/2022.
//

import SwiftUI

struct MainGridsView: View {
    @State var layoutSelectd: Layout = .layout2
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundApp.edgesIgnoringSafeArea(.all)
                VStack(spacing: 30) {
                    SwipeUpToShareView()
                    GridsView(layout: layoutSelectd)
                        .padding(.bottom)
                    HStack(spacing: 10) {
                        ForEach(Layout.allCases, id: \.self) { layout in
                            LayoutButtonView(layout: layout, layoutSelected: $layoutSelectd)
                                .padding()
                        }
                    }
                }
                
            }
        }
    }
}

struct MainGridsView_Previews: PreviewProvider {
    static var previews: some View {
        MainGridsView()
    }
}

struct SwipeUpToShareView: View {
    var body: some View {
        VStack {
            Image("Arrow Up")
                .resizable()
                .frame(width: 10, height: 10)
            Text("Swipe up to share")
                .foregroundColor(.white)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("MyGrids")
                    .font(.title)
            }
        }
    }
}
