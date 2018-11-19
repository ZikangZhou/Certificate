//
//  Notification.swift
//  考证
//
//  Created by 周梓康 on 2018/11/19.
//  Copyright © 2018 周梓康. All rights reserved.
//

import Foundation

extension Notification {
    struct UserInfoKey<ValueType>: Hashable {
        let key: String
    }
    
    func getUserInfo<T>(for key: Notification.UserInfoKey<T>) -> T {
        return userInfo![key] as! T
    }
}

extension Notification.Name {
    static let CourseModelDidChangedNotification = Notification.Name(rawValue: "CourseModelDidChangedNotification")
    static let RetrieveRemainedTimeChangedNotification = Notification.Name(rawValue: "RetrieveRemainedTimeChangedNotification")
    static let RetrieveisCountingChangedNotification = Notification.Name(rawValue: "RetrieveisCountingChangedNotification")
}

extension Notification.UserInfoKey {
    static var CourseModelDidChangedChangeBehaviorKey: Notification.UserInfoKey<CourseModel.changeBehavior> {
        return Notification.UserInfoKey(key: "CourseModelDidChangedNotification.changeBehavior")
    }
}

extension NotificationCenter {
    func post<T>(name aName: NSNotification.Name, object anObject: Any?, typedUserInfo aUserInfo: [Notification.UserInfoKey<T> : T]? = nil) {
        post(name: aName, object: anObject, userInfo: aUserInfo)
    }
}
