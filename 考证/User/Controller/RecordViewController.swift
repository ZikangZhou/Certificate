//
//  RecordViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/12/3.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var trainRecordView: UIView!
    @IBOutlet weak var postRecordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = segmentedControl
        trainRecordView.isHidden = false
        postRecordView.isHidden = true
    }
    

    @IBAction func indexedDidChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            trainRecordView.isHidden = false
            postRecordView.isHidden = true
        case 1:
            trainRecordView.isHidden = true
            postRecordView.isHidden = false
        default:
            break
        }
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
