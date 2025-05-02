//
//  HomeView.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            //탭뷰
            TabView(selection: $viewModel.selectedTab) {
                ArchivingView()
                    .tabItem {
                        VStack {
                            Image (systemName: viewModel.selectedTab == .archiving
                                ? "archivebox.fill"
                                : "archivebox"
                            )
                            
                            Text("Archiving")
                        }
                        
                    }
                    .tag(Tab.archiving)
                
                MenuImagePickerView(viewModel: .init(navigationRouter: container.navigationRouter))
                    .tabItem {
                        VStack {
                            Image (systemName: viewModel.selectedTab == .menu
                                ? "camera.fill"
                                : "camera"
                            )
                            
                            Text("menu")
                        }
                    }
                    .tag(Tab.menu)
                
                MyPageView(viewModel: .init(
                    navigationRouter: container.navigationRouter,
                    windowRouter: container.windowRouter
                ))
                    .tabItem {
                        VStack {
                            Image (
                                systemName: viewModel.selectedTab == .mypage
                                ? "person.crop.circle.fill"
                                : "person.crop.circle"
                            )
                            
                            Text("my page")
                        }
                        
                    }
                    .tag(Tab.mypage)
            }
            
            
        }
    }
}

private struct SeperatorLineView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 10)
                .padding(.bottom, 60)
        }
    }
}

#Preview {
    HomeView(viewModel: .init())
        .environmentObject(DIContainer.stub)
}
