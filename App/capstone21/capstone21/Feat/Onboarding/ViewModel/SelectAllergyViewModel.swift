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
        var filteredItems: [AllergyInfo] = []
        var continueButtonIsEnabled = false
        var errMessage = ""
        var showingCustomAllergyInput = false
        var customAllergyText: String = ""
        var selectedSpicyLevel: String = "" // 0: None, 1: Mild, 2: Medium, 3: Hot
    }
    
    enum Action {
        case backButtonDidTap
        case nextButtonDidTap
        case toggleAllergy(AllergyInfo)
        case showCustomAllergyInput
        case addCustomAllergy
        case updateCustomAllergyText(String)
        case cancelCustomAllergyInput
        case selectSpicyLevel(String)
    }
    
    // MARK: - Properties
    
    let allAllergyItems: [AllergyInfo] = AllergyInfo.allAllergyItems
    @Published var selectedAllergies: [AllergyInfo] = []
    
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
            
        case .nextButtonDidTap:
            //TODO: 맵기 및 알러지 정보 얻기
            navigationRouter.push(to: .selectKoreanFood)
            
        case .toggleAllergy(let allergy):
            if allergy == AllergyInfo.etc {
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
                let customAllergy = AllergyInfo(emoji: "🔖", name: state.customAllergyText.trimmingCharacters(in: .whitespacesAndNewlines))
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
    
    private func observe() {
        weak var owner = self
        guard let owner else { return }
        
        $selectedAllergies
            .map { !$0.isEmpty }
            .assign(to: \.state.continueButtonIsEnabled, on: self)
            .store(in: cancelBag)
        
        state.filteredItems = allAllergyItems
    }
}
