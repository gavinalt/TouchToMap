//
//  UIButton+.swift
//  TouchToMap
//
//  Created by Gavin Li on 5/1/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

    @IBInspectable var horizontalInset: CGFloat {
        set {
            let topInset = contentEdgeInsets.top
            let bottomInset = contentEdgeInsets.bottom
            contentEdgeInsets = UIEdgeInsets(top: topInset, left: newValue, bottom: bottomInset, right: newValue)
        }
        get {
            return contentEdgeInsets.left
        }
    }

    @IBInspectable var verticalInset: CGFloat {
        set {
            let leftInset = contentEdgeInsets.left
            let rightInset = contentEdgeInsets.right
            contentEdgeInsets = UIEdgeInsets(top: newValue, left: leftInset, bottom: newValue, right: rightInset)
        }
        get {
            return contentEdgeInsets.top
        }
    }
}
