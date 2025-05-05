//
//  APIConstants.swift
//  HMH_iOS
//
//  Created by 지희의 MAC on 1/11/24.
//

import Foundation
import Moya

struct APIConstants {
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
    static let auth = "Authorization"
    static let timeZone = "Time-Zone"
    static let seoul = "Asia/Seoul"
    
    static var accessToken: String {
        return "Bearer \(UserDefaultsManager.accessToken)"
    }
    
    static var refreshToken: String {
        return "Bearer " 
//        + (UserManager.shared.refreshToken ?? "")
    }
    
    static var appleAccessToken: String {
        return ""
//        UserManager.shared.socialToken ?? ""
    }
    
    static let OS = "OS"
    static let iOS = "iOS"
}

extension APIConstants {
    static var hasAccessTokenHeader: [String: String] {
        return [
            contentType: applicationJSON,
            auth: accessToken
        ]
    }
    
    
    static var signHeader: [String: String] {
        return [contentType: applicationJSON]
    }
}
