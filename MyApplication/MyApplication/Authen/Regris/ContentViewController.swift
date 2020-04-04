//
//  ContentViewController.swift
//  MyApplication
//
//  Created by NguyenHao on 4/2/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit
import WebKit

class ContentViewController: UIViewController {
    var stringURL: String?
    @IBOutlet weak var contentWebView: WKWebView!
    
    override func viewDidLoad() {
        guard let url = stringURL else { return }
        contentWebView.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
    }
}
