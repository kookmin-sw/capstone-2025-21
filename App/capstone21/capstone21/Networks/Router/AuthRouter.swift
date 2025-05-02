//
//  NetworkRouter.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation
import Moya

enum AuthRouter {
    case signUp(UserInfo)
    case login(LoginDTO)
    case logout
}

extension AuthRouter: BaseTargetType {
    var headers: Parameters? {
        switch self {
        case .signUp:
            return APIConstants.hasAccessTokenHeader
        case .login:
            return APIConstants.hasAccessTokenHeader
        case .logout:
            return APIConstants.hasAccessTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/api/auth/signup"
        case .login:
            return "/api/auth/login"
        case .logout:
            return "/api/auth/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        case .login:
            return .post
        case .logout:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let request):
            return .requestJSONEncodable(request)
        case .login(let request):
            return .requestJSONEncodable(request)
        case .logout:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        switch self {
        case .signUp:
            return .successCodes
        case .login:
            return .successCodes
        case .logout:
            return .successCodes
        }
    }
}
