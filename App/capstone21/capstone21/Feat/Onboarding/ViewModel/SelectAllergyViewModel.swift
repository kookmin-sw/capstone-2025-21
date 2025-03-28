//
//  SelectAllergyViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import UIKit
import Combine

public class SelectAllergyViewModel: ObservableObject {
    struct State {
        var filteredItems: [String] = []
        var continueButtonIsEnabled = false
        var errMessage = ""
        var showingCustomAllergyInput = false
        var customAllergyText = ""
        var selectedSpicyLevel: Int = 0 // 0: None, 1: Mild, 2: Medium, 3: Hot
    }
    
    enum Action {
        case backButtonDidTap
        case nextButtonDidTap
        case textFieldDidTap
        case toggleAllergy(String)
        case showCustomAllergyInput
        case addCustomAllergy
        case updateCustomAllergyText(String)
        case cancelCustomAllergyInput
        case selectSpicyLevel(Int)
    }
    
    // MARK: - Properties
    
    let allAllergyItems: [String] = [
        "❌ Nothing",
        "🥛 Milk",
        "🥚 Eggs",
        "🥜 Peanuts",
        "🌰 Tree nuts",
        "🌱 Soy",
        "🌾 Wheat",
        "🐟 Fish",
        "🦐 Shellfish",
        "⚫ Sesame",
        "🌿 Mustard",
        "🥬 Celery",
        "🌸 Lupin",
        "🍷 Sulfites",
        "🌾 Gluten",
        "🦀 Crustaceans",
        "🐚 Molluscs",
        "🍑 Peach",
        "🍅 Tomato",
        "🦑 Squid",
        "🐓 Chicken",
        "🐄 Beef",
        "🐖 Pork",
        "➕ Etc" // 기타 옵션 추가
    ]

    
    @Published var searchText = ""
    @Published var selectedAllergies: [String] = []
    
    @Published var state = State()
    var navigationRouter: NavigationRoutableType
    private let cancelBag = CancelBag()
    
    // MARK: - Init
    init(navigationRouter: NavigationRoutableType) {
        self.navigationRouter = navigationRouter
        
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
            //TODO: 맵기 및 알러지 정보 얻기
            navigationRouter.push(to: .selectKoreanFood)
            
        case .toggleAllergy(let allergy):
            if allergy == "➕ Etc" {
                state.showingCustomAllergyInput = true
            } else if selectedAllergies.contains(allergy) {
                selectedAllergies.removeAll { $0 == allergy }
            } else {
                selectedAllergies.append(allergy)
            }
            
        case .showCustomAllergyInput:
            state.showingCustomAllergyInput = true
            
        case .addCustomAllergy:
            if !state.customAllergyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let customAllergy = "🔖 \(state.customAllergyText.trimmingCharacters(in: .whitespacesAndNewlines))"
                if !selectedAllergies.contains(customAllergy) {
                    selectedAllergies.append(customAllergy)
                }
                state.customAllergyText = ""
                state.showingCustomAllergyInput = false
            }
            
        case .updateCustomAllergyText(let text):
            state.customAllergyText = text
            
        case .cancelCustomAllergyInput:
            state.customAllergyText = ""
            state.showingCustomAllergyInput = false
            
        case .selectSpicyLevel(let level):
            state.selectedSpicyLevel = level
        }
    }
    
    private func updateFilteredItems() {
        if searchText.isEmpty {
            state.filteredItems = allAllergyItems
        } else {
            state.filteredItems = allAllergyItems.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func observe() {
        weak var owner = self
        guard let owner else { return }
        
        $selectedAllergies
            .map { !$0.isEmpty }
            .assign(to: \.state.continueButtonIsEnabled, on: self)
            .store(in: cancelBag)
        
        $searchText
            .sink { [weak self] _ in
                self?.updateFilteredItems()
            }
            .store(in: cancelBag)
        
        // Initialize with all allergies
        state.filteredItems = allAllergyItems
    }
}
