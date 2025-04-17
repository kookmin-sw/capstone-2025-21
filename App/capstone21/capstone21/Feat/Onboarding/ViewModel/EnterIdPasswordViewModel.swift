//
//  EnterIdPasswordViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import Foundation
import Combine

public class EnterIdPasswordViewModel: ObservableObject {
    struct State {
        var nickNameIsValid: TextFieldState = .valid
        var passwordIsValid: TextFieldState = .idle
        var checkPasswordIsValid: TextFieldState = .idle
        var errorMessage: String = ""
        var continueButtonIsEnabled: Bool = false
    }
    
    enum Action {
        case backButtonDidTap
        case nextButtonDidTap
        case checkIDAvailabilityButtonDidTap
    }
    
    var navigationRouter: NavigationRoutableType
    var windowRouter: WindowRoutableType
    var userInfo :UserInfo
    private let cancelBag = CancelBag()
    
    @Published var state = State()
    @Published var nickName = ""
    @Published var password = ""
    @Published var checkPassword = ""
    
    init(
        navigationRouter: NavigationRoutableType,
        windowRouter: WindowRoutableType,
        userInfo: UserInfo
    ) {
        self.navigationRouter = navigationRouter
        self.windowRouter = windowRouter
        self.userInfo = userInfo
        
        observe()
        bindState()
    }
    
    func send(_ action: Action) {
        switch action {
        case .backButtonDidTap:
            navigationRouter.pop()
            
        case .nextButtonDidTap:
            //TODO: 회원가입 진행 -> 성공하면 홈으로
            windowRouter.switch(to: .home)
            
        case .checkIDAvailabilityButtonDidTap:
            //TODO: ID 중복 확인
            break
        }
    }
    
    private func observe() {
        weak var owner = self
        guard let owner else { return }
        
        $password
            .map { $0.isEmpty ? .idle : ($0.isValidPassword() ? .valid : .invalid) }
            .assign(to: \.state.passwordIsValid, on: owner)
            .store(in: cancelBag)
        
        $checkPassword
            .map { $0.isEmpty ? .idle : ($0 == self.password ? .valid : .invalid) }
            .assign(to: \.state.checkPasswordIsValid, on: owner)
            .store(in: cancelBag)
        
        Publishers.CombineLatest3($nickName, $password, $checkPassword)
            .map { _ in
                owner.state.nickNameIsValid == .valid &&
                owner.state.passwordIsValid == .valid &&
                owner.state.checkPasswordIsValid == .valid
            }
            .assign(to: \.state.continueButtonIsEnabled, on: owner)
            .store(in: cancelBag)
    }
    
    private func bindState() {
        weak var owner = self
        guard let owner else { return }
        
//        useCase.errMessage
//            .receive(on: RunLoop.main)
//            .handleEvents(receiveOutput: { _ in
//                owner.state.nickNameIsValid = .invalid
//            })
//            .assign(to: \.state.errorMessage, on: self)
//            .store(in: cancelBag)
    }
}
