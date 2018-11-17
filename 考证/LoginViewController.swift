//
//  LoginViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/17.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: Properties
    var users = UserInfoModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users.addUser(user: UserInfo(phone: "18851822663", password: "kang1998"))
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
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        if let name = userNameTextField.text, let password = passWordTextField.text {
            if users.contains(name: name, password: password) {
                //self.present(TrainViewController(), animated: true, completion: nil)
                performSegue(withIdentifier: "loginSuccessfully", sender: nil)
            }
            else {
                
            }
        }
        else {
            
        }
    }
    
    @IBAction func forgetPasswordButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        
    }
    
    @IBAction func hideKeyboardWhenTappedAround(_ sender: UITapGestureRecognizer) {
        sender.cancelsTouchesInView = false
        view.endEditing(true)
    }
}
