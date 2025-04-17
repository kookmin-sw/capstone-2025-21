//
//  ArchivingViewModel.swift
//  capstone21
//
//  Created on 4/16/25.
//

import SwiftUI
import Combine


class ArchivingViewModel: ObservableObject {
    @Published var userPreferredFoods: [PreferredFood] = [
        PreferredFood(id: "bibimbap", name: "비빔밥", emoji: "🍚"),
        PreferredFood(id: "kimchi", name: "김치", emoji: "🥬"),
        PreferredFood(id: "bulgogi", name: "불고기", emoji: "🥩"),
        PreferredFood(id: "tteokbokki", name: "떡볶이", emoji: "🍢"),
        PreferredFood(id: "jjigae", name: "김치찌개", emoji: "🍲")
    ]
    
    // Featured recommendations (top picks)
    @Published var featuredRecommendations: [Restaurant] = []
    
    // All restaurant recommendations
    @Published var allRestaurants: [Restaurant] = []
    
    // Filtered restaurants based on search and filters
    @Published var filteredRestaurants: [Restaurant] = []
    
    // Search text
    @Published var searchText: String = ""
    
    // Filter states
    @Published var selectedCategories: Set<FoodCategory> = []
    @Published var selectedPriceRange: Set<PriceRange> = []
    
    private var cancelBag = CancelBag()
    
    init() {
        setupSampleData()
        setupObservers()
    }
    
    private func setupSampleData() {
        // Sample data for featured recommendations
        featuredRecommendations = [
            Restaurant(
                name: "Seoul Garden",
                foodTags: ["Korean BBQ", "Banchan", "Bibimbap"],
                priceRange: .moderate,
                rating: 4.5,
                distance: "1.2 km",
                recommendedMenu: "Bulgogi",
                matchPercentage: 95,
                categories: [.korean, .bbq],
                image: Image(systemName: "photo").renderingMode(.original)
            ),
            Restaurant(
                name: "Kimchi House",
                foodTags: ["Stew", "Kimchi", "Traditional"],
                priceRange: .budget,
                rating: 4.2,
                distance: "2.5 km",
                recommendedMenu: "Kimchi Jjigae",
                matchPercentage: 90,
                categories: [.korean, .soup],
                image: Image(systemName: "photo.fill").renderingMode(.original)
            ),
            Restaurant(
                name: "Gangnam Street",
                foodTags: ["Tteokbokki", "Kimbap", "Street Food"],
                priceRange: .budget,
                rating: 4.8,
                distance: "0.8 km",
                recommendedMenu: "Spicy Tteokbokki",
                matchPercentage: 88,
                categories: [.korean, .street],
                image: Image(systemName: "fork.knife").renderingMode(.original)
            )
        ]
        
        // Sample data for all restaurants
        allRestaurants = [
            Restaurant(
                name: "Seoul Garden",
                foodTags: ["Korean BBQ", "Banchan", "Bibimbap"],
                priceRange: .moderate,
                rating: 4.5,
                distance: "1.2 km",
                recommendedMenu: "Bulgogi",
                matchPercentage: 95,
                categories: [.korean, .bbq],
                image: Image(systemName: "photo").renderingMode(.original)
            ),
            Restaurant(
                name: "Kimchi House",
                foodTags: ["Stew", "Kimchi", "Traditional"],
                priceRange: .budget,
                rating: 4.2,
                distance: "2.5 km",
                recommendedMenu: "Kimchi Jjigae",
                matchPercentage: 90,
                categories: [.korean, .soup],
                image: Image(systemName: "photo.fill").renderingMode(.original)
            ),
            Restaurant(
                name: "Gangnam Street",
                foodTags: ["Tteokbokki", "Kimbap", "Street Food"],
                priceRange: .budget,
                rating: 4.8,
                distance: "0.8 km",
                recommendedMenu: "Spicy Tteokbokki",
                matchPercentage: 88,
                categories: [.korean, .street],
                image: Image(systemName: "fork.knife").renderingMode(.original)
            ),
            Restaurant(
                name: "Busan Seafood",
                foodTags: ["Seafood", "Soup", "Grilled Fish"],
                priceRange: .expensive,
                rating: 4.6,
                distance: "3.1 km",
                recommendedMenu: "Haemul Jeongol",
                matchPercentage: 82,
                categories: [.korean, .seafood, .soup],
                image: Image(systemName: "fish").renderingMode(.original)
            ),
            Restaurant(
                name: "Bibim House",
                foodTags: ["Bibimbap", "Rice Bowls", "Vegetarian"],
                priceRange: .moderate,
                rating: 4.3,
                distance: "1.8 km",
                recommendedMenu: "Dolsot Bibimbap",
                matchPercentage: 87,
                categories: [.korean, .rice],
                image: Image(systemName: "cup.and.saucer").renderingMode(.original)
            ),
            Restaurant(
                name: "Noodle King",
                foodTags: ["Naengmyeon", "Japchae", "Ramyeon"],
                priceRange: .budget,
                rating: 4.0,
                distance: "0.5 km",
                recommendedMenu: "Cold Buckwheat Noodles",
                matchPercentage: 75,
                categories: [.korean, .noodles],
                image: Image(systemName: "bowl.fill").renderingMode(.original)
            ),
            Restaurant(
                name: "Sweet Seoul",
                foodTags: ["Bingsu", "Hotteok", "Tea"],
                priceRange: .moderate,
                rating: 4.7,
                distance: "1.5 km",
                recommendedMenu: "Patbingsu",
                matchPercentage: 65,
                categories: [.korean, .dessert],
                image: Image(systemName: "cup.and.saucer.fill").renderingMode(.original)
            ),
            Restaurant(
                name: "Jeju Island",
                foodTags: ["Seafood", "BBQ", "Island Specialties"],
                priceRange: .expensive,
                rating: 4.9,
                distance: "4.2 km",
                recommendedMenu: "Black Pork BBQ",
                matchPercentage: 80,
                categories: [.korean, .bbq, .seafood],
                image: Image(systemName: "flame").renderingMode(.original)
            )
        ]
        
        // Initialize filtered restaurants
        filteredRestaurants = allRestaurants
    }
    
    private func setupObservers() {
        // Filter restaurants when search text changes
        Publishers.CombineLatest3($searchText, $selectedCategories, $selectedPriceRange)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [weak self] (searchText, categories, prices) -> [Restaurant] in
                guard let self = self else { return [] }
                
                return self.allRestaurants.filter { restaurant in
                    // Search text filter
                    let matchesSearch = searchText.isEmpty ||
                                       restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                                       restaurant.foodTags.contains { $0.localizedCaseInsensitiveContains(searchText) }
                    
                    // Category filter
                    let matchesCategory = categories.isEmpty ||
                                         restaurant.categories.contains { categories.contains($0) }
                    
                    // Price filter
                    let matchesPrice = prices.isEmpty ||
                                      prices.contains(restaurant.priceRange)
                    
                    return matchesSearch && matchesCategory && matchesPrice
                }
                .sorted { $0.matchPercentage ?? 0 > $1.matchPercentage ?? 0 }
            }
            .assign(to: \.filteredRestaurants, on: self)
            .store(in: cancelBag)
    }
    
    func selectRestaurant(_ restaurant: Restaurant) {
        // In a real app, this would navigate to a restaurant detail view
        print("Selected restaurant: \(restaurant.name)")
    }
    
    func toggleCategory(_ category: FoodCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}
