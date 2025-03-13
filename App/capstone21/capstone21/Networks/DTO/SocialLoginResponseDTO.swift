//
//  SocialLoginResponseDTO.swift
//  capstone21
//
//  Created by 류희재 on 3/14/25.
//

import Foundation

struct SocialLogineResponseDTO: Codable {
    let userId: Int
    let token: Token
}

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
