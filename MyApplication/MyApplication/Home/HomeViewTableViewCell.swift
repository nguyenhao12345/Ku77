//
//  HomeViewTableViewCell.swift
//  MyApplication
//
//  Created by NguyenHao on 4/1/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

class HomeViewTableViewCell: UITableViewCell {
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typePlayerLabel: UILabel!
    @IBOutlet weak var namePlayerLabel: UILabel!
    @IBOutlet weak var heightPlayerLabel: UILabel!
    @IBOutlet weak var yearPlayerLabel: UILabel!
    
    func config(type: String, name: String, height: String, year: String) {
        self.typePlayerLabel?.text = type
        self.namePlayerLabel?.text = name
        self.heightPlayerLabel?.text = "Cao: " + height
        self.yearPlayerLabel?.text = "SN: " + year
    }
    
    override func awakeFromNib() {
        typeView.layer.cornerRadius = typeView.frame.height / 2
        if UIDevice.current.userInterfaceIdiom == .pad { setupLayoutForIPad() }
    }
    
    @IBOutlet weak var heightTypePlayerConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthTypePlayerConstraint: NSLayoutConstraint!
    
    func setupLayoutForIPad() {
        heightTypePlayerConstraint.constant = 80
        widthTypePlayerConstraint.constant = 80
        typeView.layer.cornerRadius = 40
        typePlayerLabel.font = UIFont (name: "Helvetica Neue", size: 40)
        namePlayerLabel.font = UIFont (name: "Helvetica Neue", size: 24)
        heightPlayerLabel.font = UIFont (name: "Helvetica Neue", size: 24)
        yearPlayerLabel.font = UIFont (name: "Helvetica Neue", size: 24)
    }
}
