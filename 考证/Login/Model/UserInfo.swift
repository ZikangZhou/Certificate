//
//  UserInfo.swift
//  考证
//
//  Created by 周梓康 on 2018/11/17.
//  Copyright © 2018 周梓康. All rights reserved.
//

import Foundation

struct UserInfo {
    
    var id = UUID()
    var phone: String? = String()
    var email: String? = String()
    var password: String? = String()
    var alertTime = [String?: DateComponents]()
    
    init(phone: String?, password: String?) {
        self.phone = phone
        self.password = password
    }
    
    init(phone: String?, email: String?, password: String?) {
        self.phone = phone
        self.email = email
        self.password = password
    }
    
    mutating func setPhone(withPhone phone: String?) {
        self.phone = phone
    }
    
    mutating func setEmail(withEmail email: String?) {
        self.email = email
    }
    
    mutating func setPassword(withPassword password: String?) {
        self.password = password
    }
    
    mutating func setAlertTime(course: String?, alertTime: DateComponents) {
        self.alertTime[course] = alertTime
    }
}

extension UserInfo: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

extension UserInfo: Equatable {
    public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.phone == rhs.phone && lhs.email == rhs.email
    }
}
