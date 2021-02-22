//
//  LabelExtension.swift
//  Instagrid
//
//  Created by DAGUIN Sébastien on 18/02/2021.
//

import UIKit

extension UILabel{
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y - 5)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        
        let toPoint =  CGPoint(x: center.x + 5, y: center.y + 5)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: nil)
        
        
    }
}
