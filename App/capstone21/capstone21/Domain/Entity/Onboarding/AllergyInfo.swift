//
//  AllergyInfo.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation

struct AllergyInfo: Hashable, Equatable {
    let emoji: String
    let name: String
}

extension AllergyInfo {
    static let allAllergyItems: [AllergyInfo] = [
        AllergyInfo(emoji: "❌", name: "Nothing"),
        AllergyInfo(emoji: "🥛", name: "Milk"),
        AllergyInfo(emoji: "🥚", name: "Eggs"),
        AllergyInfo(emoji: "🥜", name: "Peanuts"),
        AllergyInfo(emoji: "🌰", name: "Tree nuts"),
        AllergyInfo(emoji: "🌱", name: "Soy"),
        AllergyInfo(emoji: "🌾", name: "Wheat"),
        AllergyInfo(emoji: "🐟", name: "Fish"),
        AllergyInfo(emoji: "🦐", name: "Shellfish"),
        AllergyInfo(emoji: "⚫", name: "Sesame"),
        AllergyInfo(emoji: "🌿", name: "Mustard"),
        AllergyInfo(emoji: "🥬", name: "Celery"),
        AllergyInfo(emoji: "🌸", name: "Lupin"),
        AllergyInfo(emoji: "🍷", name: "Sulfites"),
        AllergyInfo(emoji: "🌾", name: "Gluten"),
        AllergyInfo(emoji: "🦀", name: "Crustaceans"),
        AllergyInfo(emoji: "🐚", name: "Molluscs"),
        AllergyInfo(emoji: "🍑", name: "Peach"),
        AllergyInfo(emoji: "🍅", name: "Tomato"),
        AllergyInfo(emoji: "🦑", name: "Squid"),
        AllergyInfo(emoji: "🐓", name: "Chicken"),
        AllergyInfo(emoji: "🐄", name: "Beef"),
        AllergyInfo(emoji: "🐖", name: "Pork")
    ]
    
    static let etc = AllergyInfo(emoji: "➕", name: "Etc")
}
