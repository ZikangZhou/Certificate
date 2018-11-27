//
//  LoginWithTextMessageViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/18.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

protocol TimerDelegate: class {
    var isCounting: Bool {get set}
}

class LoginOptionViewController: UIViewController {

    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var retrieveVerificationCodeButton: UIButton!
    
    var userInfoModel: UserInfoModel?
    var identifier: String?
    weak var timerDelegate: TimerDelegate? = nil
    var titleOfNextStepButton: String?
    var titleOfRetrieveButton: String? {
        didSet {
            retrieveVerificationCodeButton?.setTitle(titleOfRetrieveButton, for: .normal)
        }
    }
    var isEnabledOfRetrieveButton: Bool = true {
        didSet {
            retrieveVerificationCodeButton?.isEnabled = isEnabledOfRetrieveButton
        }
    }
    var alphaOfRetrieveButton: CGFloat = 1.0 {
        didSet {
            retrieveVerificationCodeButton?.alpha = alphaOfRetrieveButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(remainedTimeDidChange), name: .RetrieveRemainedTimeChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isCountingDidChange), name: .RetrieveisCountingChangedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        nextStepButton.setTitle(titleOfNextStepButton, for: .normal)
        retrieveVerificationCodeButton.isEnabled = isEnabledOfRetrieveButton
        retrieveVerificationCodeButton.alpha = alphaOfRetrieveButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "返回"
        backBarButtonItem.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        if let identifier = segue.identifier {
            switch identifier {
            case "enterPassword":
                if let vc = segue.destination as? EnterPasswordViewController {
                    vc.identifier = self.identifier
                    vc.phone = phoneTextField.text
                    vc.userInfoModel = userInfoModel
                }
            default:
                break
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "enterPassword":
            if self.identifier == "retrievePassword" || self.identifier == "register" {
                return true
            }
            else {
                return false
            }
        case "loginWithTextMessageSuccessfully":
            if self.identifier == "retrievePassword" || self.identifier == "register" {
                return false
            }
            else {
                return true
            }
        default:
            return true
        }
    }
    
    @objc func remainedTimeDidChange(_ notification: Notification) {
        let remainedTime = notification.userInfo?["value"] as! Int
        if remainedTime < 0 {
            titleOfRetrieveButton = "获取验证码"
        }
        else {
            titleOfRetrieveButton = "请等待\(remainedTime)秒"
        }
    }
    
    @objc func isCountingDidChange(_ notification: Notification) {
        let isCounting = notification.userInfo?["value"] as! Bool
        if !isCounting, let phone = phoneTextField.text, let _ = Int(phone), phone.count == 11 {
            isEnabledOfRetrieveButton = true
            alphaOfRetrieveButton = 1
        }
        else {
            isEnabledOfRetrieveButton = false
            alphaOfRetrieveButton = 0.25
        }
    }

    @IBAction func hideKeyboardWhenTappedAround(_ sender: UITapGestureRecognizer) {
        sender.cancelsTouchesInView = false
        view.endEditing(true)
    }
    
    @IBAction func phoneTextFieldChanged(_ sender: UITextField) {
        if titleOfRetrieveButton == "获取验证码", let phone = sender.text, Int(phone) != nil, phone.count == 11 {
            isEnabledOfRetrieveButton = true
            alphaOfRetrieveButton = 1.0
        }
        else {
            isEnabledOfRetrieveButton = false
            alphaOfRetrieveButton = 0.25
        }
        if verificationTextField.text != nil, let phone = sender.text, Int(phone) != nil, phone.count == 11 {
            nextStepButton.isEnabled = true
            nextStepButton.alpha = 1.0
        }
        else {
            nextStepButton.isEnabled = false
            nextStepButton.alpha = 0.25
        }
    }
    
    @IBAction func verificationTextFieldChanged(_ sender: UITextField) {
        if sender.text != nil, let phone = phoneTextField.text, Int(phone) != nil, phone.count == 11 {
            nextStepButton.isEnabled = true
            nextStepButton.alpha = 1.0
        }
        else {
            nextStepButton.isEnabled = false
            nextStepButton.alpha = 0.25
        }
    }
    
    @IBAction func retrieveVerificationCodeButtonPressed(_ sender: UIButton) {
        if let phone = phoneTextField.text, Int(phone) != nil, phone.count == 11 {
            if !userInfoModel!.contains(name: phone) && identifier == "retrievePassword" {
                let alert = UIAlertController(title: nil, message: "该账号尚未注册。", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if !userInfoModel!.contains(name: phone) && identifier == "loginWithTextMessage" {
                let alert = UIAlertController(title: nil, message: "请先完成注册。", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if userInfoModel!.contains(name: phone) && identifier == "register" {
                let alert = UIAlertController(title: nil, message: "该账号已存在。", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                SMSSDK.getVerificationCode(by: SMSGetCodeMethod.SMS, phoneNumber: phone, zone: "86") {
                    (error: Error?) -> Void in
                    if error == nil {
                        self.timerDelegate?.isCounting = true
                    }
                    else {
                        let alert = UIAlertController(title: nil, message: "验证码请求失败，请重新获取。", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        else {
            let alert = UIAlertController(title: nil, message: "请正确输入手机号。", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        
        if let phone = phoneTextField.text, let code = verificationTextField.text {
            SMSSDK.commitVerificationCode(code, phoneNumber: phone, zone: "86") {
                (error: Error?) -> Void in
                if error == nil {
                    if self.identifier == "retrievePassword" || self.identifier == "register" {
                        self.performSegue(withIdentifier: "enterPassword", sender: nil)
                    }
                    else {
                        self.performSegue(withIdentifier: "loginWithTextMessageSuccessfully", sender: nil)
                    }
                }
                else {
                    let alert = UIAlertController(title: nil, message: "验证失败", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
