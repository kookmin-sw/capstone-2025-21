//
//  OnboardingView.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import SwiftUI

enum OnboardingType {
    case one
    case two
    case three
    
    var title: String {
        switch self {
        case .one:
            return "Translate restaurant menus for your visit to Korea"
        case .two:
            return "Get detailed and useful information about allergens."
        case .three:
            return "Find dishes matching your preferences"
        }
    }
    
    var image: UIImage {
        switch self {
        case .one:
            return .graphics1
        case .two:
            return .graphics2
        case .three:
            return .graphics3
        }
    }
}

public struct OnboardingView: View {
    @EnvironmentObject var container: DIContainer
    var viewModel: OnboardingViewModel
    @State var currentIndex = 0
    
    let onboardingContent: [OnboardingType] = [.one, .two, .three]
    
    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            GeometryReader { geometry in
                ZStack {
                    Color.heyMain.ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                            .frame(height: geometry.size.height * 0.15)
                        
                        VStack(alignment: .center, spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(onboardingContent[currentIndex].title)
                                        .font(.bold_20)
                                        .foregroundColor(.heyWhite)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                            }
                            .padding(.leading, 16)
                            
                            VStack {
                                Spacer()
                                Image(uiImage: onboardingContent[currentIndex].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 400)
                                Spacer()
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 80)
                        }
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    let offsetX = value.translation.width // 드래그가 끝난 후 이동한 거리를 계산한 값
                                    
                                    let progress = -offsetX / 370 // 페이지의 이동 비율 (370은 페이지의 너비로 가정)
                                    let threshold: CGFloat = 0.15
                                    let minDragDistance: CGFloat = 50 // 최소 드래그 거리 추가
                                    
                                    if progress > threshold || -offsetX > minDragDistance {
                                        // 오른쪽에서 왼쪽으로 이동 (다음 페이지로)
                                        currentIndex = min(currentIndex + 1, onboardingContent.count - 1) // 3-1 -> content.count로 수정
                                    } else if progress < -threshold {
                                        // 왼쪽에서 오른쪽으로 이동 (이전 페이지로)
                                        currentIndex = max(currentIndex - 1, 0)
                                    }
                                }
                        )
                        
                        Spacer()
                            .frame(height: 20)
                        
                        
                        VStack {
                            HStack(spacing: 6) {
                                Spacer()
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(
                                            index == (currentIndex) % 3
                                            ? Color.init(hex: "EFF2FF")
                                            : Color.init(hex: "#CBD6FF")
                                        )
                                        .frame(width: 6, height: 6)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 50)
                            
                            Button("Start") {
                                viewModel.send(.startButtonDidTap)
                            }
                            .heyBottomButtonStyle(.white)
                            .padding(.bottom, 16)
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.08)
                    }
                }
                .ignoresSafeArea(edges: .vertical)
                .ignoresSafeArea(.keyboard)
                .setMenuNavigation()
            }
        }
        .navigationBarBackButtonHidden()
    }
}
