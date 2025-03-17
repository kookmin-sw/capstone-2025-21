//
//  SplashViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

//import SwiftUI
//
//struct SplashView: View {
//    
//    @EnvironmentObject var container: DIContainer
//    @StateObject var viewModel: SplashViewModel
//    
//    var body: some View {
//        
//        Group {
//            switch viewModel.windowRouter.destination {
//            case .splash:
//                splashView
//            case .onboarding: OnboardingView(
//                viewModel: .init(appService: container.service.appService, authService: container.service.authService, windowRouter: container.windowRouter)
//            )
//            case .main:
//                HomeView(
//                viewModel: .init(
//                    roomService: container.service.roomService,
//                    navigationRouter: container.navigationRouter
//                )
//            )
//            }
//        }
//
//        .smAlert(
//            isPresented:
//                viewModel.state.mustUpdateAlertIsPresented,
//            title: "새로운 버전이 출시됐어요☺️\n지금 앱스토에서 업데이트 해보세요",
//            primaryButton: ("업데이트", {
//                guard let url = URL(string:"itms-apps://itunes.apple.com/app/1546583360") else { return }
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url)
//                }
//            })
//        )
//        .smAlert(
//            isPresented:
//                viewModel.state.serverCheckAlert.isPresented,
//            title: viewModel.state.serverCheckAlert.message,
//            primaryButton: ("확인", {
//                viewModel.send(.alert(.confirm))
//            })
//        )
//            
//    }
//        
//    
//    var splashView: some View {
//        ZStack {
//            Image(.splashBackground)
//                .resizable()
//                .scaledToFill()
//            
//            VStack(alignment: .center) {
//                Image(.logo)
//                    .resizable()
//                    .scaledToFit()
//                    .padding(.top, 140)
//                    .padding(.horizontal, 106)
//                
//                
//                Spacer()
//                Image(.graphics3Friends)
//                    .resizable()
//                    .scaledToFit()
//                    .padding(.horizontal, 47)
//                
//                Color.smWhite
//                    .frame(height: 120)
//            }
//        }
//        .ignoresSafeArea()
//        .onAppear {
//            viewModel.send(.onAppear)
//        }
//        
//    }
//}
//
//#Preview {
//    SplashView(viewModel: SplashViewModel(appService: DIContainer.stub.service.appService, remoteConfigService: DIContainer.stub.service.remoteConfigService, authService: DIContainer.stub.service.authService,windowRouter: DIContainer.stub.windowRouter))
//        .environmentObject(DIContainer.stub)
//}
//
