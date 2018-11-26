//
//  LoginModel.swift
//  考证
//
//  Created by 周梓康 on 2018/11/17.
//  Copyright © 2018 周梓康. All rights reserved.
//

import Foundation

class UserInfoModel {
    
    private(set) var userInfo: Set<UserInfo> = Set<UserInfo>()
    
    init() { }
    
    func addUser(user: UserInfo) {
        userInfo.insert(user)
    }
    
    func removeUser(withId id: UUID) {
        for user in userInfo {
            if user.id == id {
                userInfo.remove(user)
            }
        }
    }
    
    func removeUser(withPhone phone: String?) {
        for user in userInfo {
            if user.phone == phone {
                userInfo.remove(user)
            }
        }
    }
    
    func removeUser(withEmail email: String?) {
        for user in userInfo {
            if user.email == email {
                userInfo.remove(user)
            }
        }
    }
    
    func setUser(withId id: UUID, newPhone phone: String?) {
        for user in userInfo {
            if user.id == id {
                var tmp = user
                tmp.setPhone(withPhone: phone)
                removeUser(withId: id)
                addUser(user: tmp)
                return
            }
        }
    }
    
    func setUser(withId id: UUID, newEmail email: String?) {
        for user in userInfo {
            if user.id == id {
                var tmp = user
                tmp.setEmail(withEmail: email)
                removeUser(withId: id)
                addUser(user: tmp)
                return
            }
        }
    }
    
    func setUser(withId id: UUID, newPassword password: String?) {
        for user in userInfo {
            if user.id == id {
                var tmp = user
                tmp.setPassword(withPassword: password)
                removeUser(withId: id)
                addUser(user: tmp)
                return
            }
        }
    }
    
    func getUser(withId id: UUID) -> UserInfo? {
        for user in userInfo {
            if user.id == id {
                return user
            }
        }
        return nil
    }
    
    func getUser(withPhone phone: String?) -> UserInfo? {
        for user in userInfo {
            if user.phone == phone {
                return user
            }
        }
        return nil
    }
    
    func getUser(withEmail email: String?) -> UserInfo? {
        for user in userInfo {
            if user.email == email {
                return user
            }
        }
        return nil
    }
    
    func contains(name: String?) -> Bool {
        for user in userInfo {
            if user.phone == name || user.email == name {
                return true
            }
        }
        return false
    }
    
    func passwordCorrect(name: String?, password: String?) -> Bool {
        for user in userInfo {
            if (user.phone == name || user.email == name) && user.password == password {
                return true
            }
        }
        return false
    }
    
    var count: Int {
        return userInfo.count
    }
}
