//
//  BaseModel.swift
//  HMH_iOS
//
//  Created by 이지희 on 5/12/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    var success: Bool
    var message: String?
    var data: T?
}
