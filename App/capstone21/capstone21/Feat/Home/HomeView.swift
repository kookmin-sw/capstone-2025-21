//
//  HomeView.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            //탭뷰
            TabView(selection: $homeViewModel.selectedTab) {
                ArchivingView()
                    .tabItem {
                        VStack {
                            Image (systemName: homeViewModel.selectedTab == .archiving
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
                            Image (systemName: homeViewModel.selectedTab == .menu
                                ? "camera.fill"
                                : "camera"
                            )
                            
                            Text("menu")
                        }
                    }
                    .tag(Tab.menu)
                
                MyPageView(viewModel: .init())
                    .tabItem {
                        VStack {
                            Image (
                                systemName: homeViewModel.selectedTab == .mypage
                                ? "person.crop.circle.fill"
                                : "person.crop.circle"
                            )
                            
                            Text("my page")
                        }
                        
                    }
                    .tag(Tab.mypage)
            }
            
            //구분선
            SeperatorLineView()
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
    HomeView(homeViewModel: .init())
        .environmentObject(DIContainer.stub)
}
