//
//  OnboardingViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import Combine

public class OnboardingViewModel: ObservableObject {
    
    enum Action {
        case startButtonDidTap
    }
    
    @Published var index: Int = 0
    var navigationRouter: NavigationRoutableType
    
    init(navigationRouter: NavigationRoutableType) {
        self.navigationRouter = navigationRouter
    }
    
    func send(_ action: Action) {
        switch action {
        case .startButtonDidTap:
            navigationRouter.push(to: .logIn)
        }
    }
}


