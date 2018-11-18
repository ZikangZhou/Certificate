//
//  LoginViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/17.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit
import MessageUI

class LoginViewController: UIViewController, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {

    //MARK: Properties
    var userInfo = UserInfoModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !userInfo.contains(name: "18851822663") {
            userInfo.addUser(user: UserInfo(phone: "18851822663", password: "kang1998"))
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let name = userNameTextField.text, let password = passwordTextField.text, !name.isEmpty, !password.isEmpty {
            if userInfo.contains(name: name) {
                if userInfo.passwordCorrect(name: name, password: password) {
                    performSegue(withIdentifier: "loginSuccessfully", sender: nil)
                }
                else {
                    let alert = UIAlertController(title: "登录失败", message: "账户或密码错误，请重新输入。", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "登录失败", message: "该账号尚未注册。", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil))
                alert.addAction(UIAlertAction(title: "注册", style: UIAlertAction.Style.default, handler: { action in self.register() }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func userNameTextFieldChanged(_ sender: UITextField) {
        changeStatusOfLoginButton()
    }
    
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        changeStatusOfLoginButton()
    }
    
    @IBAction func forgetPasswordButtonPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let retrievePasswordAction = UIAlertAction(title: "找回密码", style: UIAlertAction.Style.default, handler: { action in self.retrievePassword() })
        let loginWithTextMessageAction = UIAlertAction(title: "短信验证登录", style: UIAlertAction.Style.default, handler: { action in self.loginWithTextMessage() })
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel)
        actionSheet.addAction(retrievePasswordAction)
        actionSheet.addAction(loginWithTextMessageAction)
        actionSheet.addAction(cancelAction)
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        register()
    }
    
    @IBAction func hideKeyboardWhenTappedAround(_ sender: UITapGestureRecognizer) {
        sender.cancelsTouchesInView = false
        view.endEditing(true)
    }
    
    private func changeStatusOfLoginButton() {
        if let userNameText = userNameTextField.text, !userNameText.isEmpty, let passwordText = passwordTextField.text, !passwordText.isEmpty {
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        }
        else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.25
        }
    }
    
    private func register() {
        
    }
    
    private func retrievePassword() {
        
    }
    
    private func loginWithTextMessage() {
        if MFMessageComposeViewController.canSendText() {
            print("here")
            let controller = MFMessageComposeViewController()
            controller.body = "亲爱的周梓康：您好。"
            controller.recipients = ["+8618851822663"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
