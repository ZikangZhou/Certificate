//
//  SearchDisplayController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/21.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class SearchDisplayController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var courseModel: CourseModel?
    var userInfoModel: UserInfoModel?
    var searchResult = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.layer.zPosition = -1
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        (searchBar.value(forKey: "cancelButton") as! UIButton).setTitle("取消", for: .normal)
        (searchBar.value(forKey: "cancelButton") as! UIButton).setTitleColor(UIColor.black, for: .normal)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
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

}

extension SearchDisplayController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult.removeAll()
        search(searchText: searchText)
        tableView.reloadData()
    }
    
    private func search(searchText: String) {
        for index in 0..<courseModel!.count {
            for ch in courseModel!.course(at: index).name {
                if searchText.contains(ch) {
                    searchResult.append(courseModel!.course(at: index))
                    break
                }
            }
        }
        //TODO: sort
    }
}

extension SearchDisplayController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        
        cell.textLabel?.text = searchResult[indexPath.row].name
        cell.textLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResult[indexPath.section].isSelected {
            performSegue(withIdentifier: "GoToStudy", sender: tableView.cellForRow(at: indexPath))
        }
        else {
            let alert = UIAlertController(title: nil, message: "是否将\(searchResult[indexPath.section].name)课程加入学习？", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in self.addAndStudy(indexPath: indexPath) }))
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func addAndStudy(indexPath: IndexPath) {
        courseModel!.select(course: searchResult[indexPath.section])
        searchResult[indexPath.section].isSelected = true
        performSegue(withIdentifier: "GoToStudy", sender: tableView.cellForRow(at: indexPath))
    }
}
