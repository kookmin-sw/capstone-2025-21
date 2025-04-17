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
    
    private var userInfo :UserInfo
    let allKoreanFoods: [KoreanFood] = KoreanFood.koreanFoodList
    
    @Published var searchText = ""
    @Published var selectedFoods: [KoreanFood] = []
    @Published var selectedCategory: String? = nil
    
    @Published var state = State()
    var navigationRouter: NavigationRoutableType
    private let cancelBag = CancelBag()
    
    // MARK: - Init
    init(
        navigationRouter: NavigationRoutableType,
        userInfo: UserInfo
    ) {
        self.navigationRouter = navigationRouter
        self.userInfo = userInfo
        
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
            userInfo.favoriteFoods = selectedFoods.map { $0.name }
            navigationRouter.push(to: .enterIdPassword(userInfo))
            
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
