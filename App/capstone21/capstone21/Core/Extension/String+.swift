//
//  String+.swift
//  Core
//
//  Created by 류희재 on 12/31/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import Foundation

import Foundation

extension String {
    public func maskedEmail() -> String {
        let components = self.split(separator: "@")
        guard components.count == 2 else { return self } // 유효한 이메일 형식이 아니면 그대로 반환
        
        let localPart = String(components[0]) // 로컬파트
        let domainPart = String(components[1]) // 도메인
        
        // 로컬파트와 도메인을 각각 마스킹
        let maskedLocalPart = localPart.masked()
        let maskedDomainPart = domainPart.masked()
        
        return "\(maskedLocalPart)@\(maskedDomainPart)"
    }
    
    /// 문자열의 첫 번째와 마지막 문자를 제외한 부분을 *로 마스킹합니다.
    private func masked() -> String {
        guard self.count > 2 else { return self } // 길이가 2 이하라면 그대로 반환
        
        let first = self.prefix(1) // 첫 번째 문자
        let last = self.suffix(3)
        let middle = String(repeating: "*", count: self.count - 2) // 중간 문자들을 별로 대체
        
        return "\(first)\(middle)\(last)"
    }
    
    // 닉네임 유효성 검사 함수
    public func isValidNickname() -> Bool {
        // 정규식을 사용하여 닉네임 검사
        let regex = "^(?!.*\\b(admin|root|system)\\b)[a-zA-Z0-9]{2,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    // 비밀번호 유효성 검사 함수
    public func isValidPassword() -> Bool {
        // 정규식을 사용하여 비밀번호 검사
        let regex = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[a-zA-Z\\d!@#$%^&*(),.?\":{}|<>]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    // 이메일 유효성 검사 함수
    public func isValidEmail() -> Bool {
        let emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
}

//Theme & 학기 이름 format
public extension String {
    func formatName() -> String {
        let components = self.lowercased().split(separator: "_")
        let formatted = components.enumerated().map { index, word in
            index == 0 ? String(word.capitalized) : String(word)
        }.joined(separator: " ")
        return formatted
    }
}
