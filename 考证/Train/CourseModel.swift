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
        case selectedAdd([Int])
        case selectedRemove([Int])
        case selectedReload
    }
    
    private var courses = [Course]() {
        didSet {
            let behavior = CourseModel.diff(identifier: "courses", prev: oldValue, cur: courses)
            NotificationCenter.default.post(
                name: .CourseModelDidChangedNotification,
                object: self,
                typedUserInfo: [.CourseModelDidChangedChangeBehaviorKey: behavior])
        }
    }
    
    private var selectedCourses = [Course]() {
        didSet {
            let behavior = CourseModel.diff(identifier: "selectedCourses", prev: oldValue, cur: selectedCourses)
            NotificationCenter.default.post(
                name: .CourseModelDidChangedNotification,
                object: self,
                typedUserInfo: [.CourseModelDidChangedChangeBehaviorKey: behavior])
        }
    }
    
    static private func diff(identifier: String, prev: [Course], cur: [Course]) -> changeBehavior {
        let prevSet = Set(prev)
        let curSet = Set(cur)
        if prevSet.isSubset(of: curSet) {
            let addSet = curSet.subtracting(prevSet)
            let indices = addSet.compactMap { cur.index(of: $0) }
            if identifier == "courses" {
                return .add(indices)
            }
            else {
                return .selectedAdd(indices)
            }
        } else if curSet.isSubset(of: prevSet) {
            let removeSet = prevSet.subtracting(curSet)
            let indices = removeSet.compactMap { prev.index(of: $0) }
            if identifier == "courses" {
                return .remove(indices)
            }
            else {
                return .selectedRemove(indices)
            }
        } else {
            if identifier == "courses" {
                return .reload
            }
            else {
                return .selectedReload
            }
        }
    }
    
    init() {}
    
    var count: Int {
        return courses.count
    }
    
    var selectedCount: Int {
        return selectedCourses.count
    }
    
    func course(at index: Int) -> Course {
        return courses[index]
    }
    
    func selectedCourse(at index: Int) -> Course {
        return selectedCourses[index]
    }
    
    func append(course: Course) {
        courses.append(course)
        if course.isSelected {
            selectedCourses.append(course)
        }
    }
    
    func remove(at index: Int) {
        if courses[index].isSelected {
            if let selectedIndex = selectedCourses.index(of: courses[index]) {
                selectedCourses.remove(at: selectedIndex)
            }
        }
        courses.remove(at: index)
    }
    
    func removeSelected(at selectedIndex: Int) {
        selectedCourses.remove(at: selectedIndex)
    }
    
    func remove(course: Course) {
        guard let index = courses.index(of: course) else { return }
        remove(at: index)
    }
    
    func edit(prev: Course, cur: Course) {
        guard let index = courses.index(of: prev) else { return }
        courses[index] = cur
        if let selectedIndex = selectedCourses.index(of: prev) {
            selectedCourses[selectedIndex] = cur
            if !selectedCourses[selectedIndex].isSelected {
                selectedCourses.remove(at: selectedIndex)
            }
        }
    }
}
