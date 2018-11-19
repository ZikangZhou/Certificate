//
//  CourseModel.swift
//  考证
//
//  Created by 周梓康 on 2018/11/13.
//  Copyright © 2018 周梓康. All rights reserved.
//

import Foundation

class CourseModel {
    
    enum changeBehavior {
        case add([Int])
        case remove([Int])
        case reload
    }
    
    private var courses: [Course] = [] {
        didSet {
            let behavior = CourseModel.diff(prev: oldValue, cur: courses)
            NotificationCenter.default.post(
                name: .CourseModelDidChangedNotification,
                object: self,
                typedUserInfo: [.CourseModelDidChangedChangeBehaviorKey: behavior])
        }
    }
    
    static private func diff(prev: [Course], cur: [Course]) -> changeBehavior {
        let prevSet = Set(prev)
        let curSet = Set(cur)
        if prevSet.isSubset(of: curSet) {
            let addSet = curSet.subtracting(prevSet)
            let indices = addSet.compactMap { cur.index(of: $0) }
            return .add(indices)
        } else if curSet.isSubset(of: prevSet) {
            let removeSet = prevSet.subtracting(curSet)
            let indices = removeSet.compactMap { prev.index(of: $0) }
            return .remove(indices)
        } else {
            return .reload
        }
    }
    
    init() {}
    
    var count: Int {
        return courses.count
    }
    
    func course(at index: Int) -> Course {
        return courses[index]
    }
    
    func append(course: Course) {
        courses.append(course)
    }
    
    func append(courses: [Course]) {
        self.courses.append(contentsOf: courses)
    }
    
    func remove(at index: Int) {
        courses.remove(at: index)
    }
    
    func remove(course: Course) {
        guard let index = courses.index(of: course) else { return }
        remove(at: index)
    }
    
    func edit(prev: Course, cur: Course) {
        guard let index = courses.index(of: prev) else { return }
        courses[index] = cur
    }
}
