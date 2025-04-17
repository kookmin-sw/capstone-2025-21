//
//  SelectNationalityViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import UIKit
import SwiftUI

public class SelectNationalityViewModel: ObservableObject {
    struct State {
        var filteredItems: [NationalityInfo] = []
        var continueButtonIsEnabled = false
        var errMessage = ""
    }
    
    enum Action {
        case backButtonDidTap
        case nextButtonDidTap
        case textFieldDidTap
        case selectNationality(NationalityInfo)
    }
    
    // MARK: - Properties
    
    private var userInfo = UserInfo.empty
    private let allNationalityItems: [NationalityInfo] = [.USA, .JPN, .CHN]
    @Published var searchText = ""
    @Published var nationality: NationalityInfo? = nil
    
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
            state.filteredItems = allNationalityItems
            
        case .nextButtonDidTap:
            guard let nationality else { return }
            userInfo.nationality = nationality.rawValue
            navigationRouter.push(to: .selectAllergy(userInfo))
            
        case .selectNationality(let nationality):
            self.nationality = nationality
            searchText = nationality.rawValue
        }
    }
    
    private func observe() {
        weak var owner = self
        guard let owner else { return }
        
        $nationality
            .map { $0 != nil }
            .assign(to: \.state.continueButtonIsEnabled, on: self)
            .store(in: cancelBag)
        
        $searchText
            .map { text in
                return text.isEmpty
                ? []
                : owner.allNationalityItems.filter {
                    $0.rawValue.localizedCaseInsensitiveContains(text)
                }
            }
            .assign(to: \.state.filteredItems, on: owner)
            .store(in: cancelBag)
        
        $searchText
            .map { text in
                owner.allNationalityItems.first {
                    $0.rawValue.caseInsensitiveCompare(text) == .orderedSame
                }
            }
            .handleEvents(receiveOutput: { university in
                print(university ?? "nil")
            })
            .assign(to: \.nationality, on: self)
            .store(in: cancelBag)
    }
}

