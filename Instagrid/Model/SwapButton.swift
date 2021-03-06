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
    
    private var sender : UIButton{
        didSet{
            oldValue.isSelected = false
            selectedButton(button: sender)
        }
    }
    private var layout : Layout = .layout1{
        didSet{
            swapButton(oldLayout: oldValue, newLayout: layout)
            if layout == .layout1 {
                buttonDisappearanceAnimation(button: buttonRightTop)
            }else if layout == .layout2 {
                buttonDisappearanceAnimation(button: buttonRightBottom)
            }
        }
    }
    private let buttonLeftTop : UIButton
    private let buttonLeftBottom : UIButton
    private let buttonRightTop: UIButton
    private let buttonRightBottom : UIButton
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
        self.sender = sender
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
        let layout2to1 : Bool = layouts.first == .layout2 && layouts.last == .layout1
        let layout1to2 : Bool = layouts.first == .layout1 && layouts.last == .layout2
        let layout3 : Bool = layouts.last == .layout3
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
    ///This function returns the images of the buttons to their defaults.
     func resetAllButton() {
        buttonRightTop.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        buttonRightBottom.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        buttonLeftBottom.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        buttonLeftTop.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
    }
    private func resetLayout() {
        UIView.animate(withDuration: 0.5) {
            self.buttonRightTop.isHidden = false
            self.buttonRightBottom.isHidden = false
        }
    }
}
