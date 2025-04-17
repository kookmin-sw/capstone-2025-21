//
//  NavigationRoutingView.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import SwiftUI

struct NavigationRoutingView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .logIn:
            LogInView(viewModel: .init(
                navigationRouter: container.navigationRouter,
                windowRouter: container.windowRouter
                )
            )
        case .selectNationality:
            SelectNationalityView(viewModel: .init(navigationRouter: container.navigationRouter))
            
        case .selectAllergy(let user):
            SelectAllergyView(
                viewModel: .init(
                    navigationRouter: container.navigationRouter,
                    userInfo: user
                )
            )
            
        case .selectKoreanFood(let user):
            SelectKoreanFoodView(
                viewModel: .init(
                    navigationRouter: container.navigationRouter,
                    userInfo: user
                )
            )
            
        case .enterIdPassword(let user):
            EnterIdPasswordView(
                viewModel: .init(
                    navigationRouter: container.navigationRouter,
                    windowRouter: container.windowRouter,
                    userInfo: user
                )
            )
            
        case .menuAnalysisLoading:
            MenuAnalysisLoadingView(
                navigationRouter: container.navigationRouter
            )
            
        case .menuAnalysResult:
            MenuAnalysisResultView(
                viewModel: .init(
                    navigationRouter: container.navigationRouter
                )
            )
        }
    }
}


extension View {
    
    func setMenuNavigation() -> some View {
        self.navigationDestination(for: NavigationDestination.self) { destination in
            return NavigationRoutingView(destination: destination)
        }
    }
    
    
}

