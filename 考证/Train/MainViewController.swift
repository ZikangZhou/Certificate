//
//  MainViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/22.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    var userInfoModel: UserInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let selectedColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let unselectedColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TrainNavigationController {
            vc.userInfoModel = userInfoModel
        }
        else if let vc = segue.destination as? ExploreNavigationController {
            vc.userInfoModel = userInfoModel
        }
        else if let vc = segue.destination as? UserNavigationController {
            vc.userInfoModel = userInfoModel
        }
    }

}
