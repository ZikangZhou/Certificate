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
            if nextStepButton.title(for: .normal) == "下一步" {
                return true
            }
            else {
                return false
            }
        default:
            return true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.backBarButtonItem?.title = "返回"
        retrieveVerificationCodeButton.isEnabled = isEnabledOfRetrieveButton
        retrieveVerificationCodeButton.alpha = alphaOfRetrieveButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //timerDelegate?.isCounting = true
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
        }
        else {
            let alert = UIAlertController(title: nil, message: "请正确输入手机号。", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextStepButtonPressed(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
