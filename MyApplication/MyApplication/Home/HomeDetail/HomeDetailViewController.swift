//
//  HomeDetailViewController.swift
//  MyApplication
//
//  Created by NguyenHao on 4/1/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

enum HomeDetailStatus: String {
    case inputError = "Vui lòng điền đủ thông tin"
    case countNameLess = "Họ tên phải ít nhất 6 ký tự"
    case countNameOverflow = "Họ tên phải dưới 30 ký tự"
    case countPhone = "Nhập số điện thoại không đúng quy tắc"
}

class HomeDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    enum TypeSelect {
        case height
        case year
        case typePlayer
        case none
    }
    
    var typeSelect: TypeSelect = .none
    
    var priorityTypePlayer = ["GK", "SW", "CB", "LB", "RB", "CM", "LM", "RM", "ST"]
    var selectTypePlayer: String?
    
    var priorityHeightTypes = ["1m60", "1m61", "1m62" , "1m63", "1m64", "1m65", "1m66", "1m67", "1m68", "1m69", "1m70", "1m71", "1m72", "1m73", "1m74", "1m75", "1m76", "1m77", "1m78", "1m79", "1m80", "1m81", "1m82", "1m83", "1m84", "1m85", "1m86", "1m87", "1m88", "1m89", "1m90", "1m91", "1m92", "1m92", "1m93", "1m94", "1m95", "1m96", "1m97", "1m98", "1m99", "2m"]
    var selectedPriorityHeight: String?
    
    var priorityYear = ["1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"]
    var selectedPriorityYear: String?
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var typePlayerTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var titleTopLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typePlayerLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewDidLoad() {
        createPickerView()
        dissmissPickerView()
        setupTextView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        if UIDevice.current.userInterfaceIdiom == .pad { setupLayoutForIPad() }
    }
    
    func setupLayoutForIPad() {
        titleTopLabel.font = UIFont (name: "Helvetica Neue", size: 30)
        fullNameTextField.font = UIFont (name: "Helvetica Neue", size: 24)
        yearTextField.font = UIFont (name: "Helvetica Neue", size: 24)
        heightTextField.font = UIFont (name: "Helvetica Neue", size: 24)
        typePlayerTextField.font = UIFont (name: "Helvetica Neue", size: 24)
        phoneTextField.font = UIFont (name: "Helvetica Neue", size: 24)
        fullNameLabel.font = UIFont (name: "Helvetica Neue", size: 24)
        yearLabel.font = UIFont (name: "Helvetica Neue", size: 24)
        heightLabel.font = UIFont (name: "Helvetica Neue", size: 24)
        typePlayerLabel.font = UIFont (name: "Helvetica Neue", size: 24)
        phoneLabel.font = UIFont (name: "Helvetica Neue", size: 24)
    }
    
    @objc func dismissKeyboard() {
        typeSelect = .none
        view.endEditing(true)
    }
    
    @IBAction func addPlayerButton(_ sender: Any) {
        guard let name = fullNameTextField.text,
            let year = yearTextField.text,
            let height = heightTextField.text,
            let typePlayer = typePlayerTextField.text,
            let phone = phoneTextField.text else { return }
        if checkInput(name: name, year: year, height: height, typePlayer: typePlayer, phone: phone) == false {
            showArlet(type: .inputError)
            return
        }
        if checkInputNameCountLess(name: name) == false {
            showArlet(type: .countNameLess)
            return
        }
        if checkInputNameCountOverflow(name: name) == false {
            showArlet(type: .countNameOverflow)
            return
        }
        if checkInputPhone(phone: phone) == false {
            showArlet(type: .countPhone)
            return
        }
        let player = Player(type: typePlayer, name: name, height: height, year: year)
        dataPlayer.append(player)
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkInputPhone(phone: String) -> Bool {
        if phone.count < 10 || phone.count > 11 {
            return false
        }
        return true
    }
    
    func checkInputNameCountOverflow(name: String) -> Bool {
        if name.count > 30 {
            return false
        }
        return true
    }
    
    func checkInputNameCountLess(name: String) -> Bool {
        if name.count < 6 {
            return false
        }
        return true
    }
    
    func checkInput(name: String, year: String, height: String, typePlayer: String, phone: String) -> Bool {
        if name == "" || year == "" || height == "" || typePlayer == "" || phone == "" {
            return false
        }
        return true
    }
    
    private func showArlet(type: HomeDetailStatus, title: String = "Thông báo") {
        self.view.removeBluerLoader()
        let message = type.rawValue
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
     }
    
    func setupTextView() {
        yearTextField.delegate = self
        typePlayerTextField.delegate = self
        heightTextField.delegate = self
        yearTextField.tag = 0
        heightTextField.tag = 1
        typePlayerTextField.tag = 2
        phoneTextField.keyboardType = .decimalPad
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch typeSelect {
        case .height:
            return priorityHeightTypes.count
        case .year:
            return priorityYear.count
        case .typePlayer:
            return priorityTypePlayer.count
        case .none:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch typeSelect {
        case .height:
            return priorityHeightTypes[row]
        case .year:
            return priorityYear[row]
        case .typePlayer:
            return priorityTypePlayer[row]
        case .none:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch typeSelect {
        case .height:
            selectedPriorityHeight = priorityHeightTypes[row]
            heightTextField?.text = selectedPriorityHeight
        case .year:
            selectedPriorityYear =  priorityYear[row]
            yearTextField?.text = selectedPriorityYear
        case .typePlayer:
            selectTypePlayer = priorityTypePlayer[row]
            typePlayerTextField?.text = selectTypePlayer
        case .none:
            print("none")
        }
    }
    
    func dissmissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let dontButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.disssmissKeyBoard))
        toolBar.setItems([dontButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        yearTextField.inputAccessoryView = toolBar
        heightTextField.inputAccessoryView = toolBar
        typePlayerTextField.inputAccessoryView = toolBar
        phoneTextField.inputAccessoryView = toolBar
    }
    
    @objc func disssmissKeyBoard() {
        typeSelect = .none
        self.view.endEditing(true)
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        heightTextField.inputView = pickerView
        yearTextField.inputView = pickerView
        typePlayerTextField.inputView = pickerView
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tag = textField.tag
        if tag == 0 {
            typeSelect = .year
        } else if tag == 1 {
            typeSelect = .height
        } else if tag == 2 {
            typeSelect = .typePlayer
        }
    }
}
