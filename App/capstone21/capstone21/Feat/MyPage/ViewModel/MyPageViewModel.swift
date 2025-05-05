//
//  MyPageViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import UIKit
import Combine

struct ProfileInfo {
    var name: String = "hidi"
    var nationality: String = "USA"
    var imageURL: String? = nil
}

public class MyPageViewModel: ObservableObject {
    struct State {
        var referralCodeViewHidden: Bool = false
        var logoutAlertViewIsPresented: Bool = false
        var isLoading: Bool = false
    }
    
    enum Action {
        case onAppear
        
        case changePasswordButtonDidTap
        case privacyPolicyButtonDidTap
        case termsOfServiceButtonDidTap
        case contactUsButtonDidTap
        case notificationSettingButtonDidTap
        case deleteAccountButtonDidTap
        case copyReferralCodeButtonDidTap
        
        case signUpLogInButtonDidTap
        case editSchoolButtonDidTap
        
        case logoutButtonDidTap
        case dismissLogoutAlertView
    }
    
    @Published var state = State()
    @Published var profileInfo: ProfileInfo = .init()
    
    
    var navigationRouter: NavigationRoutableType
    var windowRouter: WindowRoutableType
    private let cancelBag = CancelBag()

    init(
        navigationRouter: NavigationRoutableType,
        windowRouter: WindowRoutableType
    ) {
        self.navigationRouter = navigationRouter
        self.windowRouter = windowRouter
    }
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Providers.HomeProvider.request(target: .getProfile, instance: BaseResponse<ProfileResult>.self) { [weak self] data in
                if data.success {
                    guard let data = data.data else { return }
                    self?.profileInfo.name = data.username
                    self?.profileInfo.nationality = data.nationality
                }
            }
            
        case .changePasswordButtonDidTap:
            break
            
        case .privacyPolicyButtonDidTap:
            break
            
        case .termsOfServiceButtonDidTap:
            break
            
        case .contactUsButtonDidTap:
            break
            
        case .notificationSettingButtonDidTap:
            break
            
        case .deleteAccountButtonDidTap:
            break
            
        case .logoutButtonDidTap:
            Providers.AuthProvider.request(target: .logout, instance: BaseResponse<EmptyResponseDTO>.self) { [weak self] data in
                if data.success {
                    self?.navigationRouter.destinations = []
                    self?.windowRouter.switch(to: .onboarding)
                }
            }
            
        case .copyReferralCodeButtonDidTap:
            break
            
        case .dismissLogoutAlertView:
            break
            
        case .signUpLogInButtonDidTap:
            break
            
        case .editSchoolButtonDidTap:
            break
        }
    }
}
