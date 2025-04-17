//
//  KoreanFoodInfo.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation

// MARK: - Models
struct KoreanFood: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let category: String
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: KoreanFood, rhs: KoreanFood) -> Bool {
        return lhs.id == rhs.id
    }
}
