//
//  UserInfo.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation

struct UserInfo: Codable {
    let username: String
    let password: String
    let nationality: String
    let favoriteFoods: [String]
    let allergies: [String]
    let spiceLevel: String
}
