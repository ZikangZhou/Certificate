//
//  UserNavigationController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/29.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class UserNavigationController: UINavigationController {

    var userInfoModel: UserInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.isHidden = true
        if let vc = self.topViewController as? UserTableViewController {
            vc.userInfoModel = userInfoModel
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
