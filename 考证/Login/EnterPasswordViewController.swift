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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                }
            }
        }
        else if identifier == "register" {
            userInfoModel!.addUser(user: UserInfo(phone: phone, password: passwordTextField.text))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
