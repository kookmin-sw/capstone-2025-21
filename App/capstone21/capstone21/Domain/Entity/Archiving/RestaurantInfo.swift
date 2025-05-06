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
    let image: Image
}

extension Restaurant {
    static let list: [Restaurant] = [
        Restaurant(
            name: "Seoul Garden",
            foodTags: ["Korean BBQ", "Banchan", "Bibimbap"],
            priceRange: .moderate,
            rating: 4.5,
            recommendedMenu: "Bulgogi",
            categories: [.korean, .bbq],
            image: Image(systemName: "photo").renderingMode(.original)
        ),
        Restaurant(
            name: "Kimchi House",
            foodTags: ["Stew", "Kimchi", "Traditional"],
            priceRange: .budget,
            rating: 4.2,
            recommendedMenu: "Kimchi Jjigae",
            categories: [.korean, .soup],
            image: Image(systemName: "photo.fill").renderingMode(.original)
        ),
        Restaurant(
            name: "Gangnam Street",
            foodTags: ["Tteokbokki", "Kimbap", "Street Food"],
            priceRange: .budget,
            rating: 4.8,
            recommendedMenu: "Spicy Tteokbokki",
            categories: [.korean, .street],
            image: Image(systemName: "fork.knife").renderingMode(.original)
        ),
        Restaurant(
            name: "Busan Seafood",
            foodTags: ["Seafood", "Soup", "Grilled Fish"],
            priceRange: .expensive,
            rating: 4.6,
            recommendedMenu: "Haemul Jeongol",
            categories: [.korean, .seafood, .soup],
            image: Image(systemName: "fish").renderingMode(.original)
        ),
        Restaurant(
            name: "Bibim House",
            foodTags: ["Bibimbap", "Rice Bowls", "Vegetarian"],
            priceRange: .moderate,
            rating: 4.3,
            recommendedMenu: "Dolsot Bibimbap",
            categories: [.korean, .rice],
            image: Image(systemName: "cup.and.saucer").renderingMode(.original)
        ),
        Restaurant(
            name: "Noodle King",
            foodTags: ["Naengmyeon", "Japchae", "Ramyeon"],
            priceRange: .budget,
            rating: 4.0,
            recommendedMenu: "Cold Buckwheat Noodles",
            categories: [.korean, .noodles],
            image: Image(systemName: "bowl.fill").renderingMode(.original)
        ),
        Restaurant(
            name: "Sweet Seoul",
            foodTags: ["Bingsu", "Hotteok", "Tea"],
            priceRange: .moderate,
            rating: 4.7,
            recommendedMenu: "Patbingsu",
            categories: [.korean, .dessert],
            image: Image(systemName: "cup.and.saucer.fill").renderingMode(.original)
        ),
        Restaurant(
            name: "Jeju Island",
            foodTags: ["Seafood", "BBQ", "Island Specialties"],
            priceRange: .expensive,
            rating: 4.9,
            recommendedMenu: "Black Pork BBQ",
            categories: [.korean, .bbq, .seafood],
            image: Image(systemName: "flame").renderingMode(.original)
        )
    ]
}
