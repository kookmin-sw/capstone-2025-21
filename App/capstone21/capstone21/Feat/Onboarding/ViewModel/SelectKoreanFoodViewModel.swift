//
//  SelectKoreanFoodViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import Foundation
import UIKit
import Combine

public class SelectKoreanFoodViewModel: ObservableObject {
    struct State {
        var filteredItems: [KoreanFood] = []
        var continueButtonIsEnabled = false
        var errMessage = ""
        var categorizedFoods: [String: [KoreanFood]] = [:]
    }
    
    enum Action {
        case backButtonDidTap
        case nextButtonDidTap
        case textFieldDidTap
        case toggleFood(KoreanFood)
        case filterByCategory(String?)
    }
    
    // MARK: - Properties
    
    let allKoreanFoods: [KoreanFood] = [
        KoreanFood(id: "bibimbap", name: "비빔밥", emoji: "🍚", category: "밥류", description: "Mixed rice with vegetables and meat"),
        KoreanFood(id: "kimchi", name: "김치", emoji: "🥬", category: "반찬", description: "Fermented spicy cabbage"),
        KoreanFood(id: "bulgogi", name: "불고기", emoji: "🥩", category: "고기류", description: "Marinated beef barbecue"),
        KoreanFood(id: "japchae", name: "잡채", emoji: "🍜", category: "면류", description: "Glass noodles stir-fried with vegetables"),
        KoreanFood(id: "tteokbokki", name: "떡볶이", emoji: "🍢", category: "분식", description: "Spicy rice cakes"),
        KoreanFood(id: "kimbap", name: "김밥", emoji: "🍙", category: "분식", description: "Korean rice rolls"),
        KoreanFood(id: "samgyeopsal", name: "삼겹살", emoji: "🥓", category: "고기류", description: "Grilled pork belly"),
        KoreanFood(id: "jjigae", name: "김치찌개", emoji: "🍲", category: "찌개", description: "Kimchi stew"),
        KoreanFood(id: "sundubu", name: "순두부찌개", emoji: "🥘", category: "찌개", description: "Soft tofu stew"),
        KoreanFood(id: "pajeon", name: "파전", emoji: "🥞", category: "전류", description: "Green onion pancake"),
        KoreanFood(id: "galbi", name: "갈비", emoji: "🍖", category: "고기류", description: "Marinated beef short ribs"),
        KoreanFood(id: "bibimnaengmyeon", name: "비빔냉면", emoji: "🥡", category: "면류", description: "Spicy cold noodles"),
        KoreanFood(id: "doenjang", name: "된장찌개", emoji: "🍜", category: "찌개", description: "Soybean paste stew"),
        KoreanFood(id: "samgyetang", name: "삼계탕", emoji: "🐓", category: "탕류", description: "Ginseng chicken soup"),
        KoreanFood(id: "jajangmyeon", name: "짜장면", emoji: "🍝", category: "면류", description: "Black bean sauce noodles"),
        KoreanFood(id: "bossam", name: "보쌈", emoji: "🥬", category: "고기류", description: "Boiled pork wrapped in vegetables"),
        KoreanFood(id: "dakgalbi", name: "닭갈비", emoji: "🍗", category: "고기류", description: "Spicy stir-fried chicken"),
        KoreanFood(id: "hotteok", name: "호떡", emoji: "🥮", category: "디저트", description: "Sweet Korean pancake"),
        KoreanFood(id: "gimbap", name: "김밥", emoji: "🍱", category: "분식", description: "Seaweed rice roll"),
        KoreanFood(id: "naengmyeon", name: "냉면", emoji: "🥶", category: "면류", description: "Cold buckwheat noodles")
    ]
    
    @Published var searchText = ""
    @Published var selectedFoods: [KoreanFood] = []
    @Published var selectedCategory: String? = nil
    
    @Published var state = State()
    var navigationRouter: NavigationRoutableType
    private let cancelBag = CancelBag()
    
    // MARK: - Init
    init(navigationRouter: NavigationRoutableType) {
        self.navigationRouter = navigationRouter
        
        // Initialize categorized foods
        let foodsByCategory = Dictionary(grouping: allKoreanFoods) { $0.category }
        state.categorizedFoods = foodsByCategory
        
        observe()
    }
    
    // MARK: - Methods
    func send(_ action: Action) {
        switch action {
        case .backButtonDidTap:
            navigationRouter.pop()
            
        case .textFieldDidTap:
            updateFilteredItems()
            
        case .nextButtonDidTap:
            //TODO: 선호하는 한국 음식 저장
            navigationRouter.push(to: .enterIdPassword)
            
        case .toggleFood(let food):
            if selectedFoods.contains(where: { $0.id == food.id }) {
                selectedFoods.removeAll { $0.id == food.id }
            } else {
                selectedFoods.append(food)
            }
            
        case .filterByCategory(let category):
            selectedCategory = category
            updateFilteredItems()
        }
    }
    
    private func updateFilteredItems() {
        var filtered = allKoreanFoods
        
        // Apply category filter if selected
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        state.filteredItems = filtered
    }
    
    private func observe() {
        weak var owner = self
        guard let owner else { return }
        
        $selectedFoods
            .map { !$0.isEmpty }
            .assign(to: \.state.continueButtonIsEnabled, on: self)
            .store(in: cancelBag)
        
        $searchText
            .sink { [weak self] _ in
                self?.updateFilteredItems()
            }
            .store(in: cancelBag)
            
        $selectedCategory
            .sink { [weak self] _ in
                self?.updateFilteredItems()
            }
            .store(in: cancelBag)
        
        // Initialize with all foods
        state.filteredItems = allKoreanFoods
    }
}

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
