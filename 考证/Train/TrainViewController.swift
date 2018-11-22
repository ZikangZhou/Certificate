//
//  CourseTableViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/12.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet private weak var courseTableView: UITableView!
    @IBOutlet private weak var subjectCollectionView: UICollectionView!
    @IBOutlet weak var trainScrollView: UIScrollView!
    var courseModel = CourseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(coursesDidChange), name: .CourseModelDidChangedNotification, object: nil)
        
        courseTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showCoursesTable":
                if let vc = segue.destination as? CoursesOfSubjectTableViewController, let cell = sender as? SubjectCollectionViewCell {
                    vc.courseModel = courseModel
                    vc.subject = cell.nameLabel.text
                }
            case "SearchDisplay":
                if let vc = segue.destination as? SearchDisplayController {
                    vc.courseModel = courseModel
                }
            default:
                break
            }
        }
    }
    
    @IBAction private func addButtonPressed(_ sender: UIButton) {
        let name = "证券从业资格考试"
        let subject = "金融"
        let image = #imageLiteral(resourceName: "SAC")
        courseModel.append(course: .init(name: name, subject: subject, image: image, isSelected: true))
        courseModel.append(course: Course(name: "教师资格证考试", subject: "教育", image: #imageLiteral(resourceName: "icons8-培训课-100")))
        courseModel.append(course: Course(name: "测试一下", subject: "会计", image: #imageLiteral(resourceName: "icons8-plus-100")))
    }
    
    @objc func coursesDidChange(_ notification: Notification) {
        let behavior = notification.getUserInfo(for: .CourseModelDidChangedChangeBehaviorKey)
        syncCourseTableView(for: behavior)
    }
    
    private func syncCourseTableView(for behavior: CourseModel.changeBehavior) {
        switch behavior {
        case .selectedAdd(let indices):
            let indexPaths = IndexSet(indices)
            courseTableView.insertSections(indexPaths, with: .automatic)
        case .selectedRemove(let indices):
            let indexPaths = IndexSet(indices)
            courseTableView.deleteSections(indexPaths, with: .automatic)
        case .selectedReload:
            courseTableView.reloadData()
        default:
            break
        }
    }
}

extension TrainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courseModel.selectedCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CourseTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourseTableViewCell else {
            fatalError("The dequeued cell is not an instance of CourseTableViewCell.")
        }
        cell.nameLabel.text = courseModel.selectedCourse(at: indexPath.section).name
        cell.nameLabel.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        cell.photoImageView.image = courseModel.selectedCourse(at: indexPath.section).image
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { _, view, done in
            self.courseModel.removeSelected(at: indexPath.section)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.section).")
    }
}

extension TrainViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseModel.subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "SubjectCollectionViewCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SubjectCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of SubjectTableViewCell.")
        }
        
        cell.nameLabel.text = courseModel.subjects[indexPath.item]
        /*
        if cell.nameLabel.text == "+" {
            cell.nameLabel.font = cell.nameLabel.font.withSize(26)
        }
        */
        cell.nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowRadius = 4.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("You selected cell #\(indexPath.item)!")
        performSegue(withIdentifier: "showCoursesTable", sender: collectionView.cellForItem(at: indexPath) as? SubjectCollectionViewCell)
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

extension TrainViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        performSegue(withIdentifier: "SearchDisplay", sender: nil)
        return false
    }
}
