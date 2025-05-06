//
//  NetworkRouter.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation
import Moya

enum HomeRouter {
    case getRestaurantList
    case getProfile
    case postMenuImage(Data)
    case getMenuImage(String)
    case getTranslateMenuImage
    case getMenuAnalyze
    
}

extension HomeRouter: BaseTargetType {
    var headers: Parameters? {
        switch self {
        case .getRestaurantList:
            return APIConstants.hasAccessTokenHeader
        case .getProfile:
            return APIConstants.hasAccessTokenHeader
        case .postMenuImage:
            return APIConstants.hasAccessTokenHeader
        case .getMenuImage:
            return APIConstants.hasAccessTokenHeader
        case .getTranslateMenuImage:
            return APIConstants.hasAccessTokenHeader
        case .getMenuAnalyze:
            return APIConstants.hasAccessTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .getRestaurantList:
            return "/api/home"
        case .getProfile:
            return "/api/user/profile"
        case .postMenuImage:
            return "/api/gallery/upload"
        case .getMenuImage(let fileName):
            return "/api/gallery/images/{fileName}"
                .replacingOccurrences(
                    of: "{fileName}",
                    with: fileName
                )
        case .getTranslateMenuImage:
            return "/api/analysis/translate"
        case .getMenuAnalyze:
            return "/api/analysis/analyze"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRestaurantList:
            return .get
        case .getProfile:
            return .get
        case .postMenuImage:
            return .post
        case .getMenuImage:
            return .get
        case .getTranslateMenuImage:
            return .get
        case .getMenuAnalyze:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRestaurantList:
            return .requestPlain
        case .getProfile:
            return .requestPlain
        case .postMenuImage(let file):
            var multipartFormData: [MultipartFormData] = []
            let imageData = MultipartFormData(
                    provider: .data(file),
                    name: "image",
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg")
            multipartFormData.append(imageData)
            return .uploadMultipart(multipartFormData)
        case .getMenuImage:
            return .requestPlain
        case .getTranslateMenuImage:
            return .requestPlain
        case .getMenuAnalyze:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        switch self {
        case .getRestaurantList:
            return .successCodes
        case .getProfile:
            return .successCodes
        case .postMenuImage:
            return .successCodes
        case .getMenuImage:
            return .successCodes
        case .getTranslateMenuImage:
            return .successCodes
        case .getMenuAnalyze:
            return .successCodes
        }
    }
}
