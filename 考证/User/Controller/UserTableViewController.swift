//
//  UserTableViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/12/3.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit
import StoreKit
import UserNotifications

class UserTableViewController: UITableViewController {

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var continuousLabel: UILabel!
    @IBOutlet weak var studyTimeLabel: UILabel!
    @IBOutlet weak var cacheLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var userInfoModel: UserInfoModel!
    let cellName = ["足迹", "错题本", "收藏夹", "消息"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appwillMoveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .notDetermined {
                    // Notification permission has not been asked yet, go for it!
                    self.notificationSwitch.isOn = false
                } else if settings.authorizationStatus == .denied {
                    // Notification permission was previously denied, go to settings & privacy to re-enable
                    self.notificationSwitch.isOn = false
                } else if settings.authorizationStatus == .authorized {
                    // Notification permission was already granted
                    self.notificationSwitch.isOn = true
                }
            }
        })
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 5
        case 3:
            return 1
        default:
            return 0
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 3:
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func exitButtonPressed(_ sender: UIButton) {
        while self.navigationController?.navigationController?.viewControllers.count != 1 {
            self.navigationController?.navigationController?.popViewController(animated: true)
        }
        self.userInfoModel.loginID = nil
    }
    
    
    @IBAction func notificationSwitchDidChange(_ sender: UISwitch) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    @objc func appwillMoveToForeground() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .notDetermined {
                    // Notification permission has not been asked yet, go for it!
                    self.notificationSwitch.isOn = false
                } else if settings.authorizationStatus == .denied {
                    // Notification permission was previously denied, go to settings & privacy to re-enable
                    self.notificationSwitch.isOn = false
                } else if settings.authorizationStatus == .authorized {
                    // Notification permission was already granted
                    self.notificationSwitch.isOn = true
                }
            }
        })
    }
}


extension UserTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCollectionViewCell", for: indexPath as IndexPath) as! UserCollectionViewCell
        cell.label.text = self.cellName[indexPath.item]
        cell.label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0, 2:
            performSegue(withIdentifier: "DisplayRecord", sender: nil)
        default:
            break
        }
    }
}
