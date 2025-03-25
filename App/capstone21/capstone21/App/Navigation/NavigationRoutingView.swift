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
        case .SelectAllergy:
            SelectAllergyView(viewModel: .init(navigationRouter: container.navigationRouter))
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

