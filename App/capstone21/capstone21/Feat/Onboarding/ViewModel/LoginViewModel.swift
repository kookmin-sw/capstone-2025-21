//
//  LoginViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import Combine

public class LogInViewModel: ObservableObject {
    
    enum Action {
        case onAppear
        case loginButtonDidTap
        case dismissToastView
        case forgotPasswordButtonDidTap
        case signUpButtonDidTap
    }
    
    struct State {
        var loginButtonEnabled = true
        var errMessage: String = ""
        var showToast: Bool { return !errMessage.isEmpty }
        var showCloseBtn: Bool = false
        var isLoading = false
    }
    
    @Published var id: String = ""
    @Published var password: String = ""
    
    @Published var state = State()
    var navigationRouter: NavigationRoutableType
    var windowRouter: WindowRoutableType
    private let cancelBag = CancelBag()
    
    init(
        navigationRouter: NavigationRoutableType,
        windowRouter: WindowRoutableType
    ) {
        self.navigationRouter = navigationRouter
        self.windowRouter = windowRouter
        
        observe()
        bindState()
    }
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            if UserDefaultsManager.accessToken != "" {
                navigationRouter.destinations = []
                windowRouter.switch(to: .home)
            }
            
        case .loginButtonDidTap:
            let request = LoginRequest(username: id, password: password)
            Providers.AuthProvider.request(target: .login(request), instance: BaseResponse<LoginResult>.self) { [weak self] data in
                if data.success {
                    UserDefaultsManager.accessToken = data.data?.token ?? ""
                    UserDefaultsManager.userName = data.data?.username ?? ""
                    self?.navigationRouter.destinations = []
                    self?.windowRouter.switch(to: .home)
                }
            }
            
        case .dismissToastView:
            state.errMessage = ""
        case .forgotPasswordButtonDidTap:
            break
        case .signUpButtonDidTap:
            navigationRouter.push(to: .selectNationality)
        }
    }
    
    private func observe() {
        weak var owner = self
        guard let owner else { return }
        
        Publishers.CombineLatest($id, $password)
            .map { !$0.isEmpty && !$1.isEmpty }
            .assign(to: \.state.loginButtonEnabled, on: owner)
            .store(in: cancelBag)
    }
    
    private func bindState() {
//        useCase.errMessage
//            .receive(on: RunLoop.main)
//            .assign(to: \.state.errMessage, on: self)
//            .store(in: cancelBag)
    }
}

