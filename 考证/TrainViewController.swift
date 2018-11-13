//
//  CourseTableViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/12.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var courseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(coursesDidChange), name: .CourseModelDidChangedNotification, object: nil)
        
    }
    
    private func syncCourseTableView(for behavior: CourseModel.changeBehavior) {
        switch behavior {
        case .add(let indices):
            let indexPaths = indices.map {IndexPath(row: $0, section: 0)}
            courseTableView.insertRows(at: indexPaths, with: .automatic)
        case .remove(let indices):
            let indexPaths = indices.map {IndexPath(row: $0, section: 0)}
            courseTableView.deleteRows(at: indexPaths, with: .automatic)
        case .reload:
            courseTableView.reloadData()
        }
    }
    
    @objc func coursesDidChange(_ notification: Notification) {
        let behavior = notification.getUserInfo(for: .CourseModelDidChangedChangeBehaviorKey)
        syncCourseTableView(for: behavior)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let courses = CourseModel.shared
        let name = "证券从业资格考试"
        let image = #imageLiteral(resourceName: "SAC")
        courses.append(course: .init(name: name, image: image))
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CourseModel.shared.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CourseTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourseTableViewCell else {
            fatalError("The dequeued cell is not an instance of CourseTableViewCell.")
        }
        
        // TODO: Configure the cell...
        cell.nameLabel.text = CourseModel.shared.course(at: indexPath.row).name
        cell.nameLabel.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        cell.photoImageView.image = CourseModel.shared.course(at: indexPath.row).image

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, view, done in
            CourseModel.shared.remove(at: indexPath.row)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
