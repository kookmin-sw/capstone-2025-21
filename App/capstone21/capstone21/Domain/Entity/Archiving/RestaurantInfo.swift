//
//  RestaurantInfo.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation
import SwiftUI

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let foodTags: [String]
    let priceRange: PriceRange
    let rating: Double
    let recommendedMenu: String?
    let categories: [FoodCategory]
    let image: URL
    let homepageURL: String
}

extension Restaurant {
    static let list: [Restaurant] = [
        Restaurant(
            name: "Seoul Garden",
            foodTags: ["Korean BBQ", "Banchan", "Bibimbap"],
            priceRange: .moderate,
            rating: 4,
            recommendedMenu: "Bulgogi",
            categories: [.korean, .bbq],
            image: URL(string: "")!,
            homepageURL: ""
        ),
        Restaurant(
            name: "Kimchi House",
            foodTags: ["Stew", "Kimchi", "Traditional"],
            priceRange: .budget,
            rating: 4,
            recommendedMenu: "Kimchi Jjigae",
            categories: [.korean, .soup],
            image: URL(string: "")!,
            homepageURL: ""
        ),
        Restaurant(
            name: "Gangnam Street",
            foodTags: ["Tteokbokki", "Kimbap", "Street Food"],
            priceRange: .budget,
            rating: 4,
            recommendedMenu: "Spicy Tteokbokki",
            categories: [.korean, .street],
            image: URL(string: "")!,
            homepageURL: ""
        ),
        Restaurant(
            name: "Busan Seafood",
            foodTags: ["Seafood", "Soup", "Grilled Fish"],
            priceRange: .expensive,
            rating: 4,
            recommendedMenu: "Haemul Jeongol",
            categories: [.korean, .seafood, .soup],
            image: URL(string: "")!,
            homepageURL: ""
        ),
        Restaurant(
            name: "Bibim House",
            foodTags: ["Bibimbap", "Rice Bowls", "Vegetarian"],
            priceRange: .moderate,
            rating: 4,
            recommendedMenu: "Dolsot Bibimbap",
            categories: [.korean, .rice],
            image: URL(string: "")!,
            homepageURL: ""
        ),
        Restaurant(
            name: "Noodle King",
            foodTags: ["Naengmyeon", "Japchae", "Ramyeon"],
            priceRange: .budget,
            rating: 4,
            recommendedMenu: "Cold Buckwheat Noodles",
            categories: [.korean, .noodles],
            image: URL(string: "")!,
            homepageURL: ""
        ),
        Restaurant(
            name: "Sweet Seoul",
            foodTags: ["Bingsu", "Hotteok", "Tea"],
            priceRange: .moderate,
            rating: 4,
            recommendedMenu: "Patbingsu",
            categories: [.korean, .dessert],
            image: URL(string: "")!,
            homepageURL: ""
        ),
        Restaurant(
            name: "Jeju Island",
            foodTags: ["Seafood", "BBQ", "Island Specialties"],
            priceRange: .expensive,
            rating: 4,
            recommendedMenu: "Black Pork BBQ",
            categories: [.korean, .bbq, .seafood],
            image: URL(string: "")!,
            homepageURL: ""
        )
    ]
}
