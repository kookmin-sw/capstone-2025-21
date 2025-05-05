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
    let matchPercentage: Int?
    let categories: [FoodCategory]
    let image: Image
}
