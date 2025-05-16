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
    static let multipart = "multipart/form-data"
    static let auth = "Authorization"
    static let timeZone = "Time-Zone"
    static let seoul = "Asia/Seoul"
    
    static var accessToken: String {
        return "Bearer \(UserDefaultsManager.accessToken)"
    }
}

extension APIConstants {
    static var hasAccessTokenHeader: [String: String] {
        return [
            contentType: applicationJSON,
            auth: accessToken
        ]
    }
    
    static var multipartHeader: [String: String] {
        return [
            auth: accessToken
        ]
    }
    
    static var signHeader: [String: String] {
        return [contentType: applicationJSON]
    }
}
