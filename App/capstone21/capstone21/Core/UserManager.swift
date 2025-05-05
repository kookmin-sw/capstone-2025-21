//
//  UserDefaultKeyList.swift
//  ZOOC
//
//  Created by 장석우 on 2023/04/26.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case accessToken
    case userName
}

@propertyWrapper
struct UserDefaultWrapper<T> {
    private let key: String
    private let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}




struct UserDefaultsManager {
    @UserDefaultWrapper<String>(key: UserDefaultKeys.accessToken.rawValue, defaultValue: "")
    static var accessToken: String
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.userName.rawValue, defaultValue: "이름없음")
    static var userName: String
}

