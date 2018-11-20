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
        nextStepButton.setTitle(titleOfNextStepButton, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(remainedTimeDidChange), name: .RetrieveRemainedTimeChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isCountingDidChange), name: .RetrieveisCountingChangedNotification, object: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        retrieveVerificationCodeButton.isEnabled = isEnabledOfRetrieveButton
        retrieveVerificationCodeButton.alpha = alphaOfRetrieveButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    @IBAction func hideKeyboardWhenTappedAround(_ sender: UITapGestureRecognizer) {
        sender.cancelsTouchesInView = false
        view.endEditing(true)
    }
    
    @IBAction func phoneTextFieldChanged(_ sender: UITextField) {
        if titleOfRetrieveButton == "获取验证码", let phone = sender.text, let _ = Int(phone), phone.count == 11 {
            isEnabledOfRetrieveButton = true
            alphaOfRetrieveButton = 1.0
        }
        else {
            isEnabledOfRetrieveButton = false
            alphaOfRetrieveButton = 0.25
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
            timerDelegate?.isCounting = true
            // TODO: send message                                                                                                                                                                                                                                   
        }
        else {
            let alert = UIAlertController(title: nil, message: "请正确输入手机号。", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        
        // TODO: check the verification code
        
        if identifier == "retrievePassword" || identifier == "register" {
            performSegue(withIdentifier: "enterPassword", sender: nil)
        }
        else {
            performSegue(withIdentifier: "loginWithTextMessageSuccessfully", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "返回"
        backBarButtonItem.tintColor = #colorLiteral(red: 0.4352941215, green: 0.4431372583, blue: 0.4745098054, alpha: 1)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
