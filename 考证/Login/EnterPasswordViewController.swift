//
//  EnterPasswordViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/20.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class EnterPasswordViewController: UIViewController, UITextFieldDelegate {

    var userInfoModel: UserInfoModel?
    var identifier: String?
    var phone: String?
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MainViewController {
            vc.userInfoModel = userInfoModel
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func hideKeyboardWhenTappedAround(_ sender: UITapGestureRecognizer) {
        sender.cancelsTouchesInView = false
        view.endEditing(true)
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        if identifier == "retrievePassword" {
            for user in userInfoModel!.userInfo {
                if user.phone == phone {
                    userInfoModel?.setUser(withId: user.id, newPassword: passwordTextField.text)
                    userInfoModel?.loginID = user.id
                }
            }
        }
        else if identifier == "register" {
            let user = UserInfo(phone: phone, password: passwordTextField.text)
            userInfoModel?.addUser(user: user)
            userInfoModel?.loginID = user.id
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
