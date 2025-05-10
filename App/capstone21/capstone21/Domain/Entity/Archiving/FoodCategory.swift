//
//  FoodCategory.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation

public enum FoodCategory: String, CaseIterable {
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

extension FoodCategory {
    public static func toEntity(_ menu: String) -> FoodCategory {
        switch menu {
        case "닭갈비", "보쌈", "갈비", "삼겹살", "불고기":
            return .bbq
        case "삼계탕", "된장찌개", "순두부찌개", "김치찌개":
            return .soup
        case "김밥", "떡볶이":
            return .street
        case "냉면", "짜장면", "비빔냉면", "잡채":
            return .noodles
        case "비빔밥":
            return .rice
        case "호떡" :
            return .dessert
        default:
            return .korean
        }
    }
}
