//
//  UserInfo.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation

struct UserInfo: Hashable, Codable {
    var username: String
    var password: String
    var nationality: String
    var favoriteFoods: [String]
    var allergies: [String]
    var spiceLevel: String
}

extension UserInfo {
    static var empty: UserInfo {
        .init(
            username: "",
            password: "",
            nationality: "",
            favoriteFoods: [],
            allergies: [],
            spiceLevel: ""
        )
    }
}
