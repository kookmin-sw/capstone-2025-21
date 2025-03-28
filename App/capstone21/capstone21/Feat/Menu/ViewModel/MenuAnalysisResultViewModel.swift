//
//  MenuAnalysisResultViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/26/25.
//

import Foundation
import SwiftUI
import Combine

class MenuAnalysisResultViewModel: ObservableObject {
    struct State {
        // Example state properties
    }
    
    enum Action {
        case viewParsedMenuTapped
        case returnHomeTapped
    }
    
    // Example allergen info structure
    struct AllergenInfo {
        let allergen: String
        let dishes: [String]
    }
    
    // Example spicy dish structure
    struct SpicyDish {
        let name: String
        let spiceLevel: Int
    }
    
    // Example recommended menu structure
    struct RecommendedMenu {
        let name: String
        let description: String
        let price: String
        let matchPercentage: Int
        let matchReasons: [String]
    }
    
    // Sample data - would be replaced with actual data in a real app
    let allergiesDetected: Bool = true
    let allergiesInfo: [AllergenInfo] = [
        AllergenInfo(allergen: "Nuts", dishes: ["Pad Thai", "Almond Chicken"]),
        AllergenInfo(allergen: "Seafood", dishes: ["Seafood Pasta", "Lobster Bisque"])
    ]
    
    let userSpicePreference: Int = 3
    let userSpiceLevelDescription: String = "Medium"
    
    let spicyDishes: [SpicyDish] = [
        SpicyDish(name: "Spicy Chicken Curry", spiceLevel: 4),
        SpicyDish(name: "Hot & Sour Soup", spiceLevel: 3),
        SpicyDish(name: "Buffalo Wings", spiceLevel: 5)
    ]
    
    let topRecommendedMenu: RecommendedMenu = RecommendedMenu(
        name: "Signature Bibimbap",
        description: "A colorful mix of vegetables, beef, and rice topped with a fried egg and special sauce.",
        price: "₩12,000",
        matchPercentage: 95,
        matchReasons: ["Based on history", "Low allergens", "Medium spicy"]
    )
    
    var state = State()
    
    var navigationRouter: NavigationRoutableType
    private let cancelBag = CancelBag()
    
    init(
        navigationRouter: NavigationRoutableType
    ) {
        self.navigationRouter = navigationRouter
    }
    
    func send(_ action: Action) {
        // In a real app, this would handle the actions
        switch action {
        case .viewParsedMenuTapped:
            // Navigate to parsed menu view
            break
        case .returnHomeTapped:
            navigationRouter.popToRootView()
        }
    }
}

