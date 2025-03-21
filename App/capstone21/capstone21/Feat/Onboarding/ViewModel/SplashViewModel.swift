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
    
//    private let appService: AppServiceType
//    private let authService: AuthenticationServiceType
//    private var userDefaultsService: UserDefaultsServiceType
//    private let remoteConfigService: RemoteConfigServiceType
    private(set) var windowRouter: WindowRoutableType
    
    //MARK: - Properties
    
//    @Published var state = State()
    private let cancelBag = CancelBag()

    //MARK: - Init
    
    init(
//        appService: AppServiceType,
//        remoteConfigService: RemoteConfigServiceType,
//        authService: AuthenticationServiceType,
//        userDefaultsService: UserDefaultsServiceType = UserDefaultsService.shared,
        windowRouter: WindowRoutableType
    ) {
//        self.appService = appService
//        self.remoteConfigService = remoteConfigService
//        self.authService = authService
//        self.userDefaultsService = userDefaultsService
        self.windowRouter = windowRouter
    }
    
    //MARK: - Methods
    
    func send(_ action: Action) {
        weak var owner = self
        guard let owner else { return }
        switch action {
            
        case .onAppear:
            break
//            appService.isLatestVersion()
//                .receive(on: RunLoop.main)
//                .sink { isLatestVersion in
//                    
//                    guard isLatestVersion else {
//                        owner.state.mustUpdateAlertIsPresented = true
//                        return
//                    }
//                    
//                    Just(owner.appService.getDeviceIdentifier() ?? "" )
//                        .filter { !$0.isEmpty }
//                        .flatMap(owner.authService.signIn)
//                        .receive(on: RunLoop.main)
//                        .map {
//                            owner.userDefaultsService.userID = $0.userID
//                            owner.userDefaultsService.accessToken = $0.accessToken
//                            return WindowDestination.main
//                        }
//                        .catch { _ in Just(WindowDestination.onboarding) }
//                        .sink {
//                            owner.windowRouter.switch(to: $0)
//                        }
//                        .store(in: owner.cancelBag)
//                    
//                    owner.remoteConfigService.getServerCheck()
//                        .filter { $0 }
//                        .map { _ in }
//                        .flatMap(owner.remoteConfigService.getServerCheckMessage)
//                        .receive(on: RunLoop.main)
//                        .catch { _ in Empty() }
//                        .map { (true, $0 ) }
//                        .assign(to: \.state.serverCheckAlert, on: owner)
//                        .store(in: owner.cancelBag)
//                    
//                }
//                .store(in: cancelBag)
        }
    }
}

