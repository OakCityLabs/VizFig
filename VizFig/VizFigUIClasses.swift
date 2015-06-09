//
//  VizFigUIClasses.swift
//  VizFigDemo
//
//  Created by Jay Lyerly on 6/9/15.
//  Copyright (c) 2015 Oak City Labs. All rights reserved.
//

import UIKit

//MARK: UIView
@IBDesignable
class VizFigView: UIView {}

extension UIView {
    @IBInspectable var vizFigBackgroundColor: String {
        get { return "" }
        set {
            backgroundColor = VizFig.sharedManager.getColorForString(newValue) ?? backgroundColor
        }
    }

}

//MARK: UILabel
@IBDesignable
class VizFigLabel: UILabel {
    override var font: UIFont! {
        didSet {
            println("Font did change:\(font)")
        }
    }
}

extension UILabel {
    @IBInspectable var vizFigTextColor: String {
        get { return "" }
        set {
            textColor = VizFig.sharedManager.getColorForString(newValue) ?? textColor
        }
    }
    @IBInspectable var vizFigTextFont: String {
        get { return "" }
        set {
            font = VizFig.sharedManager.getFontForString(newValue) ?? font
        }
    }
    
    
}

//MARK: UIButton
@IBDesignable
class VizFigButton: UIButton {}

extension UIButton {
    @IBInspectable var vizFigButtonColor: String {
        get { return "" }
        set {
            if let color = VizFig.sharedManager.getColorForString(newValue) {
                setTitleColor(color, forState: .Normal)
                setTitleColor(color, forState: .Selected)
            }
        }
    }
    
}