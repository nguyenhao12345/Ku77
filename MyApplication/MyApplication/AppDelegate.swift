//
//  AppDelegate.swift
//  MyApplication
//
//  Created by NguyenHao on 4/1/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        requestCheckLogin()
        return true
    }
    
    func requestCheckLogin() {
        let urlString = "http://kuclick.me/apple/web.php"
        Service.share.request(url: urlString, method: .GET) { (statusRequest, data) in
            switch statusRequest {
            case .errorURL:
                let storyBoard = UIStoryboard(name: "LoginViewController", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                vc.statusRequest = .errorURL
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            case .errorNetwork:
                let storyBoard = UIStoryboard(name: "LoginViewController", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
                vc.statusRequest = .errorNetwork
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            case .dataEmpty:
                let storyBoard = UIStoryboard(name: "HomeViewController", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            case .success:
                guard let dataResponse = data as? String else { return }
                if dataResponse == "" {
                    let storyBoard = UIStoryboard(name: "HomeViewController", bundle: nil)
                    guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                } else {
                    let storyBoard = UIStoryboard(name: "RegrisViewController", bundle: nil)
                    guard let vc = storyBoard.instantiateViewController(withIdentifier: "RegrisViewController") as? RegrisViewController else { return }
                    vc.stringURL = dataResponse
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
            }
        }
    }
}

