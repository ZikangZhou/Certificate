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

    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var entranceCollectionView: UICollectionView!
    
    var courseModel: CourseModel?
    var userInfoModel: UserInfoModel?
    var courseName: String?
    private let entranceName = ["报考指南", "官网入口", "学习", "题库", "学习闹钟", "成绩查询"]
    private let hourData = Array(1...12)
    private let minuteData = Array(0...59)
    private lazy var minuteMiddle = 50 * minuteData.count
    private lazy var hourMiddle = 50 * hourData.count
    var alertSheet: UIAlertController?
    var isPm = 1
    var hour = 8
    var minute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = courseName
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAlertSheet))
        //tapGestureRecognizer.cancelsTouchesInView = false
        //self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func hideAlertSheet(sender: UITapGestureRecognizer) {
        self.alertSheet?.dismiss(animated: true, completion: nil)
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
            alertSheet = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
            alertSheet!.popoverPresentationController?.sourceView = collectionView
            alertSheet!.popoverPresentationController?.sourceRect = collectionView.bounds
            let timePicker = UIPickerView(frame: CGRect(x: 70, y: 30, width: 250, height: 170))
            timePicker.delegate = self
            timePicker.dataSource = self
            timePicker.selectRow(rowForValueOfHour(value: hour)!, inComponent: 1, animated: true)
            timePicker.selectRow(rowForValueOfMinute(value: minute)!, inComponent: 2, animated: true)
            alertSheet!.view.addSubview(timePicker)
            present(alertSheet!, animated: true) {
                self.alertSheet!.view.superview?.subviews[0].isUserInteractionEnabled = true
                self.alertSheet!.view.superview?.subviews[0].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideAlertSheet)))
            }
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

extension StudyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func valueForRowOfHour(row: Int) -> Int {
        return hourData[row % hourData.count]
    }
    
    func valueForRowOfMinute(row: Int) -> Int {
        return minuteData[row % minuteData.count]
    }
    
    func rowForValueOfHour(value: Int) -> Int? {
        if let _ = hourData.index(of: value) {
            return hourMiddle + value - 1
        }
        return nil
    }
    
    func rowForValueOfMinute(value: Int) -> Int? {
        if let _ = minuteData.index(of: value) {
            return minuteMiddle + value
        }
        return nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 2
        case 1:
            return hourData.count * 100
        case 2:
            return minuteData.count * 100
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            switch row {
            case 0:
                if isPm == 0 {
                    return "上午"
                }
                else {
                    return "下午"
                }
            case 1:
                if isPm == 0 {
                    return "下午"
                }
                else {
                    return "上午"
                }
            default:
                return nil
            }
        case 1:
            return "\(valueForRowOfHour(row: row))"
        case 2:
            return "\(valueForRowOfMinute(row: row))"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if row == 1 {
                isPm = 1 - isPm
            }
        case 1:
            hour = valueForRowOfHour(row: hourMiddle + (row % hourData.count))
        case 2:
            minute = valueForRowOfMinute(row: minuteMiddle + (row % minuteData.count))
        default:
            break
        }
        
        let content = UNMutableNotificationContent()
        content.title = "考证"
        content.body = "小证来提醒您学习\(title!)啦，快来领取今天的任务吧！"
        if content.badge == nil {
            content.badge = 1
        }
        else {
            content.badge = content.badge!.intValue + 1 as NSNumber
        }
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour + isPm * 12
        if dateComponents.hour == 24 {
            dateComponents.hour = 0
        }
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: title!, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
}
