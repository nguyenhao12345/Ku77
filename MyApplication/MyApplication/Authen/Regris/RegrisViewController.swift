//
//  RegrisViewController.swift
//  MyApplication
//
//  Created by NguyenHao on 4/1/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

enum RegrisStatusRequest: String {
    case success = "Thành công"
    case inputEmpty = "Bạn chưa nhập tên hoặc số điện thoại"
    case failNetwork = "Đã xảy ra sự cố vui lòng thực hiện lại"
    case error = "Lấy dữ liệu không thành công"
    case errorUrl = "Lỗi hệ thống"
    case unknown = "unknown"
    case inputOverflow = "Thông tin nhập vào không được quá 30 ký tự"
}

class RegrisViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var kuTextField: UITextField!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var regirsButton: GradientButton!
    @IBOutlet weak var containerView: UIView!
    
    var stringURL: String?
    
    override func viewDidLoad() {
        containerView.layer.cornerRadius = 10
        setupRegrisButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        if UIDevice.current.userInterfaceIdiom == .pad { setupLayoutForIPad() }
    }
    
    @IBOutlet weak var widthContainerView: NSLayoutConstraint!
    @IBOutlet weak var heightPhoneConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightKuContstraint: NSLayoutConstraint!
    @IBOutlet weak var heightButtonRegrisConstraint: NSLayoutConstraint!
    
    func setupLayoutForIPad() {
        widthContainerView.constant = 500
        introLabel.font = UIFont (name: "Helvetica Neue", size: 35)
        nameTextField.font = UIFont (name: "Helvetica Neue", size: 20)
        phoneNumberTextField.font = UIFont (name: "Helvetica Neue", size: 20)
        kuTextField.font = UIFont (name: "Helvetica Neue", size: 20)
        heightPhoneConstraint.constant = 50
        heightNameConstraint.constant = 50
        heightKuContstraint.constant = 50
        heightButtonRegrisConstraint.constant = 60
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupRegrisButton() {
        regirsButton.layer.borderWidth = 2
    }
    
    @IBAction func regrisButton(_ sender: Any) {
        guard let name = nameTextField.text, let phone = phoneNumberTextField.text, let ku = kuTextField.text else { return }
        if checkInput(name: name, phone: phone) == false {
            showArlet(type: .inputEmpty)
            return
        }
        if checkInputOverflow(name: name, phone: phone, ku: ku) == false {
            showArlet(type: .inputOverflow)
            return
        }
        self.view.showBlurLoader()
        let urlString = "https://kuclick.me/dangky.php?name=\(name)&sdt=\(phone)&ku=\(ku)"
        Service.share.request(url: urlString, method: .POST) { (statusRequest, data) in
            switch statusRequest {
            case .errorURL:
                self.showArlet(type: .errorUrl)
                return
            case .errorNetwork:
                self.showArlet(type: .failNetwork)
                return
            case .dataEmpty:
                self.showArlet(type: .error)
                return
            case .success:
                self.view.removeBluerLoader()
                guard let stringURLUnwrap = self.stringURL else {
                    self.showArlet(type: .error)
                    return
                }
                let storyBoard = UIStoryboard(name: "ContentViewController", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else {
                    self.showArlet(type: .error)
                    return
                }
                vc.stringURL = stringURLUnwrap
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func checkInputOverflow(name: String, phone: String, ku: String) -> Bool {
        if name.count > 30 || phone.count > 30 || ku.count > 30 {
            return false
        }
        return true
    }
    
    func checkInput(name: String, phone: String) -> Bool{
        if name == "" || phone == "" {
            return false
        }
        return true
    }
    
    private func showArlet(type: RegrisStatusRequest, title: String = "Thông báo") {
           DispatchQueue.main.async {
               self.view.removeBluerLoader()
               let message = type.rawValue
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
        }
    }
}
