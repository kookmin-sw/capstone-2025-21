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
        
        Providers.HomeProvider.request(target: .getRestaurantList, instance: BaseResponse<RestuarantResult>.self) {  data in
            if data.success {
                guard let data = data.data else { return }
                print("🚨🚨🚨🚨\(data.menus)🚨🚨🚨")
            }
        }
    }
    
    private func setupSampleData() {
        featuredRecommendations = Restaurant.list
        allRestaurants = Restaurant.list
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
