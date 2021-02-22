//
//  UIViewExtension.swift
//  Instagrid
//
//  Created by DAGUIN Sébastien on 10/02/2021.
//

import Foundation
import UIKit

extension UIView{
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
        
        
    }
}
