//
//  MenuAnalysisLoadingView.swift
//  capstone21
//
//  Created on 3/26/25.
//

import SwiftUI

public struct MenuAnalysisLoadingView: View {
    @EnvironmentObject var container: DIContainer
    
    @State private var isAnimating = false
    @State private var dotOpacity1 = 0.3
    @State private var dotOpacity2 = 0.3
    @State private var dotOpacity3 = 0.3
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 92)
            
            VStack(spacing: 40) {
                // Loading animation
                VStack(spacing: 16) {
                    // Animated cute image
                    ZStack {
                        // Outer spinning circle
                        Circle()
                            .stroke(Color.heyMain.opacity(0.3), lineWidth: 5)
                            .frame(width: 100, height: 100)
                        
                        // Inner spinning circle (opposite direction)
                        Circle()
                            .stroke(Color.heyMain.opacity(0.7), lineWidth: 3)
                            .frame(width: 70, height: 70)
                            .rotationEffect(Angle(degrees: isAnimating ? -360 : 0))
                            .animation(
                                Animation.linear(duration: 3)
                                    .repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                        
                        // Cute food icon
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundColor(.heyMain)
                            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 4)
                                    .repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                            .scaleEffect(isAnimating ? 1.1 : 0.9)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 6)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                    
                    // Loading text
                    VStack(spacing: 8) {
                        Text("Analyzing Menu")
                            .font(.semibold_18)
                            .foregroundColor(.heyGray1)
                        
                        Text("Please wait while we process your menu image")
                            .font(.regular_16)
                            .foregroundColor(.heyGray2)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Animated dots
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.heyMain)
                            .frame(width: 10, height: 10)
                            .opacity(dotOpacity1)
                        
                        Circle()
                            .fill(Color.heyMain)
                            .frame(width: 10, height: 10)
                            .opacity(dotOpacity2)
                        
                        Circle()
                            .fill(Color.heyMain)
                            .frame(width: 10, height: 10)
                            .opacity(dotOpacity3)
                    }
                    .padding(.top, 12)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
                .background(Color.heyGray5.opacity(0.3))
                .cornerRadius(16)
                
                // Analysis information
                VStack(alignment: .leading, spacing: 16) {
                    Text("We're working on it...")
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    Text("Our system is analyzing your menu image to extract menu items, prices, and categories.")
                        .font(.regular_14)
                        .foregroundColor(.heyGray2)
                        .padding(.bottom, 8)
                    
                    Text("This process may take up to 30 seconds depending on the complexity of your menu.")
                        .font(.regular_14)
                        .foregroundColor(.heyGray3)
                }
                .padding(20)
                .background(Color.heyGray5.opacity(0.2))
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 36)
        .padding(.bottom, 65)
        .background(Color.heyWhite)
        .ignoresSafeArea(edges: .vertical)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startLoadingAnimation()
        }
    }
    
    private func startLoadingAnimation() {
        isAnimating = true
        
        // Animate the dots
        withAnimation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0.0)) {
            dotOpacity1 = 1.0
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0.2)) {
            dotOpacity2 = 1.0
        }
        
        withAnimation(Animation.easeInOut(duration: 0.6).repeatForever().delay(0.4)) {
            dotOpacity3 = 1.0
        }
    }
}

#Preview {
    MenuAnalysisLoadingView()
        .environmentObject(DIContainer.stub)
}
