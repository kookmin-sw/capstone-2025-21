//
//  SplashView.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: SplashViewModel
    
    var body: some View {
        
        Group {
            switch viewModel.windowRouter.destination {
            case .splash:
                splashView
            case .onboarding: OnboardingView(viewModel: .init(navigationRouter: container.navigationRouter))
//            case .main:
//                HomeView(
//                viewModel: .init(
//                    roomService: container.service.roomService,
//                    navigationRouter: container.navigationRouter
//                )
//            )
            }
        }
    }
        
    
    var splashView: some View {
        ZStack {
            Image(.icAdd)
                .resizable()
                .scaledToFill()
            
            VStack(alignment: .center) {
                Image(.icAdd)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 140)
                    .padding(.horizontal, 106)
                
                
                Spacer()
                Image(.icAdd)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 47)
                
                Color.heyWhite
                    .frame(height: 120)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.send(.onAppear)
        }
        
    }
}
