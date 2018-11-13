//
//  CourseTableViewCell.swift
//  考证
//
//  Created by 周梓康 on 2018/11/12.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
