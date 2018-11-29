//
//  Course.swift
//  考证
//
//  Created by 周梓康 on 2018/11/12.
//  Copyright © 2018 周梓康. All rights reserved.
//

import Foundation
import UIKit

struct Course {
    
    typealias courseId = UUID
    
    let id: courseId
    let name: String
    let subject: String
    var image: UIImage
    var isSelected = false
    
    init(name: String, subject: String, image: UIImage, isSelected: Bool = false) {
        self.id = courseId()
        self.name = name
        self.subject = subject
        self.image = image
        self.isSelected = isSelected
    }
}

extension Course: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

extension Course: Equatable {
    public static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
}
