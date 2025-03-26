//
//  SplashViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import Combine

class SplashViewModel: ObservableObject {
    
//MARK: - Action, State
    
    enum Action {
        case onAppear
    }
    
    enum Alert {
        case confirm
    }
    
    //MARK: - Dependency
    
    private(set) var windowRouter: WindowRoutableType
    
    //MARK: - Properties
    
    private let cancelBag = CancelBag()

    //MARK: - Init
    
    init(windowRouter: WindowRoutableType) {
        self.windowRouter = windowRouter
    }
    
    //MARK: - Methods
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            windowRouter.switch(to: .onboarding)
        }
    }
}

