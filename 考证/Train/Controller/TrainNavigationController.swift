//
//  TrainNavigationController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/29.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class TrainNavigationController: UINavigationController {

    var userInfoModel: UserInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let vc = self.topViewController as? TrainViewController {
            vc.userInfoModel = userInfoModel
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
