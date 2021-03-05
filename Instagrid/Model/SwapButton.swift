//
//  SwapButton.swift
//  Instagrid
//
//  Created by DAGUIN Sébastien on 03/03/2021.
//

import Foundation
import UIKit

enum Layout {
    case layout1
    case layout2
    case layout3
}
class SwapButton {
    
   private var sender : UIButton
   private let buttonLeftTop : UIButton
   private let buttonLeftBottom : UIButton
   private let buttonRightTop: UIButton
   private let buttonRightBottom : UIButton
    private var layout : Layout = .layout1{
        didSet{
            print("Old value est \(oldValue) et la nouvelle  value est \(layout)")
            swapButton(oldLayout: oldValue, newLayout: layout)
            if layout == .layout1 {
                buttonDisappearanceAnimation(button: buttonRightTop)
            }else if layout == .layout2 {
                buttonDisappearanceAnimation(button: buttonRightBottom)
            }
        }
    }
    init(sender : UIButton, buttonLeftTop : UIButton, buttonLeftBottom : UIButton, buttonRightTop : UIButton,  buttonRightBottom : UIButton, layout : Layout ) {
        self.sender = sender
        self.buttonLeftTop = buttonLeftTop
        self.buttonLeftBottom = buttonLeftBottom
        self.buttonRightTop = buttonRightTop
        self.buttonRightBottom = buttonRightBottom
        self.layout = layout
    }
    func tappedOnButtonLayout1and2(sender : UIButton,layout : Layout) {
        resetLayout()
        selectedButton(button: sender)
        setLayout(layout)
    }
    
    private func setLayout(_ layout : Layout)  {
        self.layout = layout
    }
    //MARK:- Selected Button
    private func selectedButton(button : UIButton) {
        button.isSelected = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private func swapButton(oldLayout: Layout, newLayout: Layout){
        let layouts = [oldLayout, newLayout]
        let layout2to1 : Bool = layouts[0] == .layout2 && layouts[1] == .layout1
        let layout1to2 : Bool = layouts[0] == .layout1 && layouts[1] == .layout2
        let layout3 : Bool = layouts[1] == .layout3
        print(layouts[0])
        print(layouts[1])
        
        print("2 a 1 est \(layout2to1)")
        print(" 1 a 2 est \(layout1to2)")
        
        let saveRightTop = buttonRightTop.currentImage
        let saveRightBottom = buttonRightBottom.currentImage
        let saveLeftTop = buttonLeftTop.currentImage
        let saveLeftBottom = buttonLeftBottom.currentImage
        
        if layout2to1 {
            let imageSwap = saveLeftBottom
            buttonRightBottom.setImage(saveRightTop, for: .normal)
            buttonLeftTop.setImage(imageSwap, for: .normal)
            buttonLeftBottom.setImage(saveLeftTop, for: .normal)
        }else if layout1to2{
            let imageSwap = saveLeftTop
            buttonLeftTop.setImage(saveLeftBottom, for: .normal)
            buttonLeftBottom.setImage(imageSwap, for: .normal)
            buttonRightTop.setImage(saveRightBottom, for: .normal)
        }else if layout3{
            buttonRightTop.setImage(saveRightTop, for: .normal)
            buttonRightBottom.setImage(saveRightBottom, for: .normal)
            buttonLeftBottom.setImage(saveLeftBottom, for: .normal)
            buttonLeftTop.setImage(saveLeftTop, for: .normal)
        }
    }
    //MARK:- Button disaspperance
    ///Displays the animation of the buttons that disappear
    private func buttonDisappearanceAnimation(button : UIButton) {
        UIView.animate(withDuration: 0.5) {
            button.isHidden = true
        }
    }
    //MARK:- Reset Layout
    ///This function returns all buttons to their initial display.
    private func resetLayout() {
        UIView.animate(withDuration: 0.5) {
            self.buttonRightTop.isHidden = false
            self.buttonRightBottom.isHidden = false
            self.buttonLeftTop.isHidden = false
            self.buttonLeftBottom.isHidden = false
        }
    }
}
