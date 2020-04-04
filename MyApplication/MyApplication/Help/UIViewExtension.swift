//
//  UIViewExtension.swift
//  MyApplication
//
//  Created by NguyenHao on 4/2/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

enum ColorApp {
    static let backGroundDefault = UIColor.hexStringToUIColor(hex: Color.backGroundDefault.code)
}

enum Color: String {
    case backGroundDefault = "D42D26"
    
    var code: String { return self.rawValue }
}



class BlurLoader: UIView {
    
    var blurEffectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect()
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        self.blurEffectView?.backgroundColor = .black
        self.blurEffectView?.alpha = 0.5
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.color = ColorApp.backGroundDefault
        activityIndicator.startAnimating()
    }
}

extension UIView {
    func showBlurLoader() {
        if let windowCheck = window {
            let blurLoader = BlurLoader(frame: windowCheck.frame)
            blurLoader.layer.zPosition = 1
            self.addSubview(blurLoader)
        } else {
            let window = UIWindow()
            let blurLoader = BlurLoader(frame: window.frame)
            blurLoader.layer.zPosition = 1
            self.addSubview(blurLoader)
        }
    }
    
    func removeBluerLoader() {
        DispatchQueue.main.async {
            if let blurLoader = self.subviews.first(where: { $0 is BlurLoader }) {
                blurLoader.removeFromSuperview()
            }
        }
    }
}
