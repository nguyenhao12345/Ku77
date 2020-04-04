//
//  LoginViewController.swift
//  MyApplication
//
//  Created by NguyenHao on 4/1/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

enum LoginStatusRequest: String {
      case success = "Thành công"
      case inputEmpty = "Bạn chưa nhập tên hoặc số điện thoại"
      case failNetwork = "Đã xảy ra sự cố vui lòng thực hiện lại"
      case error = "Lấy dữ liệu không thành công"
      case errorUrl = "Lỗi hệ thống"
      case unknown = "unknown"
}

class LoginViewController: UIViewController {
    var statusRequest: StatusRequest?
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginButton: GradientButton!
    @IBOutlet weak var regrisButton: GradientButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        containerView.layer.cornerRadius = 10
        setupButton()
        if UIDevice.current.userInterfaceIdiom == .pad { setupLayoutForIPad() }
        guard let status = statusRequest else { return }
        switch status {
        case .errorURL:
            self.showArlet(type: .errorUrl)
            return
        case .errorNetwork:
            self.showArlet(type: .error)
            return
        case .dataEmpty:
            print("data empty")
        case .success:
            print("success")
        }
    }
    
    func setupButton() {
        loginButton.layer.borderWidth = 2
        regrisButton.layer.borderWidth = 2
    }
    
    @IBOutlet weak var widthContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightPasswordConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightRegrisButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLoginButtonConstraint: NSLayoutConstraint!
    
    func setupLayoutForIPad() {
        widthContainerViewConstraint.constant = 500
        heightPasswordConstraint.constant = 50
        heightNameConstraint.constant = 50
        nameTextField.font = UIFont (name: "Helvetica Neue", size: 20)
        passwordTextField.font = UIFont (name: "Helvetica Neue", size: 20)
        heightRegrisButtonConstraint.constant = 60
        heightLoginButtonConstraint.constant = 60
    }
    
    func requestCheckLogin() {
        let urlString = "http://kuclick.me/apple/web.php"
        Service.share.request(url: urlString, method: .GET) { (statusRequest, data) in
            switch statusRequest {
            case .errorURL:
                self.showArlet(type: .errorUrl)
                return
            case .errorNetwork:
                self.showArlet(type: .error)
                return
            case .dataEmpty:
                self.view.removeBluerLoader()
                let storyBoard = UIStoryboard(name: "HomeViewController", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            case .success:
                self.view.removeBluerLoader()
                guard let dataResponse = data as? String else { return }
                if dataResponse == "" {
                    let storyBoard = UIStoryboard(name: "HomeViewController", bundle: nil)
                    guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    let storyBoard = UIStoryboard(name: "RegrisViewController", bundle: nil)
                    guard let vc = storyBoard.instantiateViewController(withIdentifier: "RegrisViewController") as? RegrisViewController else { return }
                    vc.stringURL = dataResponse
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func showArlet(type: LoginStatusRequest, title: String = "Thông báo") {
        DispatchQueue.main.async {
            self.view.removeBluerLoader()
            let message = type.rawValue
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Thử lại", style: .default, handler: { (alert) in
                self.requestCheckLogin()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func regrisButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "RegrisViewController", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "RegrisViewController") as? RegrisViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let name = nameTextField.text,
            let password = passwordTextField.text else { return }
        if name == "name123456" && password == "123456" {
            let storyBoard = UIStoryboard(name: "HomeViewController", bundle: nil)
            guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
