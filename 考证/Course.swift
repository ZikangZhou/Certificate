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
    let image: UIImage
    
    init(name: String, image: UIImage) {
        self.id = courseId()
        self.name = name
        self.image = image
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
