//
//  CoursesOfSubjectTableViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/21.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class CoursesOfSubjectTableViewController: UITableViewController {

    var courseModel: CourseModel!
    var userInfoModel: UserInfoModel!
    var subject: String?
    var coursesOfSubject = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCoursesOfSubject(subject: subject)
        title = subject
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 80
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "返回"
        backBarButtonItem.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        if let vc = segue.destination as? StudyViewController, let cell = sender as? UITableViewCell {
            vc.courseModel = courseModel
            vc.userInfoModel = userInfoModel
            vc.courseName = cell.textLabel!.text
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if subject == "更多" {
            return courseModel.count
        }
        else {
            return courseModel.coursesOfSubjectCount(subject: subject)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesOfSubjectCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = coursesOfSubject[indexPath.section].name
        cell.textLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        cell.imageView?.image = coursesOfSubject[indexPath.section].image
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if coursesOfSubject[indexPath.section].isSelected {
            performSegue(withIdentifier: "GoToStudy", sender: tableView.cellForRow(at: indexPath))
        }
        else {
            let alert = UIAlertController(title: nil, message: "是否将\(coursesOfSubject[indexPath.section].name)课程加入学习？", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in self.addAndStudy(indexPath: indexPath) }))
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func loadCoursesOfSubject(subject: String?) {
        if subject == "更多" {
            for index in 0..<courseModel.count {
                coursesOfSubject.append(courseModel.course(at: index))
            }
        }
        else {
            for index in 0..<courseModel.count {
                if courseModel.course(at: index).subject == subject {
                    coursesOfSubject.append(courseModel.course(at: index))
                }
            }
        }
    }
    
    private func addAndStudy(indexPath: IndexPath) {
        courseModel.select(course: coursesOfSubject[indexPath.section])
        coursesOfSubject[indexPath.section].isSelected = true
        performSegue(withIdentifier: "GoToStudy", sender: tableView.cellForRow(at: indexPath))
    }
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
}
