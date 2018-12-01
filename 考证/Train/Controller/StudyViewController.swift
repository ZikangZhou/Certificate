//
//  StudyViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/26.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit
import UserNotifications

class StudyViewController: UIViewController {

    @IBOutlet weak var entranceCollectionView: UICollectionView!
    @IBOutlet weak var examTimeLabel: UILabel!
    @IBOutlet weak var countDownDayLabel: UILabel!
    var pickAlert: UIAlertController!
    var datePicker: UIDatePicker!
    var courseModel: CourseModel!
    var userInfoModel: UserInfoModel!
    var courseName: String?
    private let entranceName = ["报考指南", "官网入口", "学习", "题库", "学习闹钟", "成绩查询"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = courseName
        var dateComponent = userInfoModel.getUser(withId: userInfoModel.loginID!)!.examTime[courseName]
        if dateComponent == nil {
            dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            userInfoModel.setUser(withId: userInfoModel.loginID!, examTime: dateComponent!, course: courseName)
        }
        examTimeLabel.text = "目标日：\(dateComponent!.year ?? 0)-\(dateComponent!.month ?? 0)-\(dateComponent!.day ?? 0)"
        countDownDayLabel.text = "\(Calendar.current.dateComponents([.day], from: Date(), to: Calendar.current.date(from: dateComponent!)!).day ?? 0)"
    }
    
    @IBAction func editExamTimeButtonPressed(_ sender: UIButton) {
        pickAlert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
        let attributedString = NSAttributedString(string: "设置考试日期", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.black])
        pickAlert.setValue(attributedString, forKey: "attributedTitle")
        pickAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        datePicker = UIDatePicker(frame: CGRect(x: 17, y: 30, width: 250, height: 170))
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.setDate((Calendar.current.date(from: userInfoModel.getUser(withId: userInfoModel.loginID!)?.examTime[courseName] ?? Calendar.current.dateComponents([.year, .month, .day], from: Date()))!), animated: true)
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date() + (20 * 365 * 24 * 60 * 60)
        pickAlert.view.addSubview(datePicker)
        present(pickAlert, animated: true) {
            self.pickAlert.view.superview?.subviews[0].isUserInteractionEnabled = true
            self.pickAlert.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hidePickAlert)))
        }
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        if datePicker.datePickerMode == .time {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute], from: datePicker.date)
            userInfoModel.setUser(withId: userInfoModel.loginID, alertTime: dateComponents, course: courseName)
            
            let content = UNMutableNotificationContent()
            content.title = "考证"
            content.body = "小证来提醒您学习\(courseName!)啦，快来领取今天的任务吧！"
            if content.badge == nil {
                content.badge = 1
            }
            else {
                content.badge = content.badge!.intValue + 1 as NSNumber
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: courseName!, content: content, trigger: trigger)
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if error != nil {
                    // Handle any errors.
                }
            }
        }
        else if datePicker.datePickerMode == .date {
            userInfoModel.setUser(withId: userInfoModel.loginID!, examTime: Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date), course: courseName)
            let dateComponent = userInfoModel.getUser(withId: userInfoModel.loginID!)!.examTime[courseName]
            examTimeLabel.text = "目标日：\(dateComponent!.year ?? 0)-\(dateComponent!.month ?? 0)-\(dateComponent!.day ?? 0)"
            countDownDayLabel.text = "\(Calendar.current.dateComponents([.day], from: Date(), to: Calendar.current.date(from: dateComponent!)!).day ?? 0)"
        }
    }
    
    @objc func hidePickAlert(sender: UITapGestureRecognizer) {
        self.pickAlert.dismiss(animated: true, completion: nil)
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

extension StudyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entranceName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "EntranceCollectionViewCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? EntranceCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of EntranceCollectionViewCell.")
        }
        cell.nameLabel.text = entranceName[indexPath.item]
        cell.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowRadius = 4.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EntranceCollectionViewCell
        switch cell?.nameLabel.text {
        case "学习闹钟":
            pickAlert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
            pickAlert.popoverPresentationController?.sourceView = collectionView
            pickAlert.popoverPresentationController?.sourceRect = collectionView.bounds
            let attributedString = NSAttributedString(string: "设置提醒时间", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor : UIColor.black])
            pickAlert.setValue(attributedString, forKey: "attributedTitle")
            pickAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            datePicker = UIDatePicker(frame: CGRect(x: 70, y: 30, width: 250, height: 170))
            datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
            datePicker.datePickerMode = .time
            datePicker.setDate((Calendar.current.date(from: userInfoModel.getUser(withId: userInfoModel.loginID!)?.alertTime[courseName] ?? DateComponents(hour:20, minute: 0))!), animated: true)
            pickAlert.view.addSubview(datePicker)
            present(pickAlert, animated: true) {
                self.pickAlert.view.superview?.subviews[0].isUserInteractionEnabled = true
                self.pickAlert.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hidePickAlert)))
            }
            
        case "官网入口":
            performSegue(withIdentifier: "GoToOfficialWebsite", sender: nil)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}
