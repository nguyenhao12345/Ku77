//
//  ButtonExtension.swift
//  MyApplication
//
//  Created by NguyenHao on 4/2/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

//extension UIView {
//    @discardableResult
//    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
//        return self.applyGradient(colours: colours, locations: nil)
//    }
//
//    @discardableResult
//    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = self.bounds
//        gradient.colors = colours.map { $0.cgColor }
//        gradient.locations = locations
//        self.layer.insertSublayer(gradient, at: 0)
//        return gradient
//    }
//}

@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable var cornerRadiusValue: CGFloat = 10.0 {
        didSet {
            setUpView()
       }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10.0
    }
    
    override func awakeFromNib() {
           setUpView()
       }

       override func prepareForInterfaceBuilder() {
           super.prepareForInterfaceBuilder()
           setUpView()
       }

    
    func setUpView() {
        self.layer.cornerRadius = 10.0
    }
    
    func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
