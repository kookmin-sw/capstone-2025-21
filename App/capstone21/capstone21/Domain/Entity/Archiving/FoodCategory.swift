//
//  FoodCategory.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation

enum FoodCategory: String, CaseIterable {
    case korean = "Korean"
    case bbq = "BBQ"
    case soup = "Soup"
    case street = "Street Food"
    case noodles = "Noodles"
    case rice = "Rice"
    case seafood = "Seafood"
    case dessert = "Dessert"
    
    var displayName: String {
        return self.rawValue
    }
    
    var emoji: String {
        switch self {
        case .korean: return "🇰🇷"
        case .bbq: return "🥩"
        case .soup: return "🍲"
        case .street: return "🍢"
        case .noodles: return "🍜"
        case .rice: return "🍚"
        case .seafood: return "🦐"
        case .dessert: return "🍡"
        }
    }
}
