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
    var searchResult = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //searchBar.setValue("取消", forKey: "_cancelButtonText")
        (searchBar.value(forKey: "cancelButton") as! UIButton).setTitle("取消", for: .normal)
        (searchBar.value(forKey: "cancelButton") as! UIButton).setTitleColor(UIColor.black, for: .normal)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
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
                    searchResult.append(courseModel!.course(at: index).name)
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
        
        cell.textLabel?.text = searchResult[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return cell
    }
}
