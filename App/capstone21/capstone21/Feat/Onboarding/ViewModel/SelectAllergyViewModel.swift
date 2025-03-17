//
//  SelectAllergyViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import UIKit

public class SelectAllergyViewModel: ObservableObject {
    struct State {
        var filteredItems: [String] = []
        var continueButtonIsEnabled = false
        var errMessage = ""
    }
    
    enum Action {
        case backButtonDidTap
        case nextButtonDidTap
        case textFieldDidTap
        case selectUniversity(String)
    }
    
    // MARK: - Properties
    
    private let allUniversityItems: [String] = ["NTU", "NUS", "SMU"]
    @Published var searchText = ""
    @Published var university: String? = nil
    
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
            state.filteredItems = allUniversityItems
            
        case .nextButtonDidTap:
            break
//            guard let university = university else { return }
//            useCase.userInfo.university = university.rawValue
//            navigationRouter.push(to: .verifyEmail)
            
        case .selectUniversity(let university):
            break
//            self.university = university
//            searchText = university.rawValue
        }
    }
    
    private func observe() {
        weak var owner = self
        guard let owner else { return }
        
//        $university
//            .map { $0 != nil }
//            .assign(to: \.state.continueButtonIsEnabled, on: self)
//            .store(in: cancelBag)
//
//        $searchText
//            .map { text in
//                return text.isEmpty
//                ? []
//                : owner.allUniversityItems.filter {
//                    $0.rawValue.localizedCaseInsensitiveContains(text)
//                }
//            }
//            .assign(to: \.state.filteredItems, on: owner)
//            .store(in: cancelBag)
//
//        $searchText
//            .map { text in
//                owner.allUniversityItems.first {
//                    $0.rawValue.caseInsensitiveCompare(text) == .orderedSame
//                }
//            }
//            .handleEvents(receiveOutput: { university in
//                print(university ?? "nil")
//            })
//            .assign(to: \.university, on: self)
//            .store(in: cancelBag)
    }
}


