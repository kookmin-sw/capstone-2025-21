//
//  SocialLoginResponseDTO.swift
//  capstone21
//
//  Created by 류희재 on 3/14/25.
//

import Foundation

struct LoginDTO: Codable {
    let id: String
    let password: String
}

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
