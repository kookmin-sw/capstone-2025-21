//
//  MenuAnalysResultView.swift
//  capstone21
//
//  Created by 류희재 on 3/26/25.
//

import SwiftUI

struct MenuAnalysisResultView: View {
    @EnvironmentObject var container: DIContainer
    @ObservedObject var viewModel: MenuAnalysisResultViewModel
    
    @State private var animateCards: Bool = false
    @State private var showTopRecommendation: Bool = false
    
    public init(viewModel: MenuAnalysisResultViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Top congratulation section
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.heyMain)
                        .padding(.bottom, 8)
                    
                    Text("Analysis Complete!")
                        .font(.bold_24)
                        .foregroundColor(.heyGray1)
                    
                    Text("We've analyzed your menu and found some insights for you")
                        .font(.regular_16)
                        .foregroundColor(.heyGray2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.heyGray5.opacity(0.6), Color.heyGray5.opacity(0.2)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Top Recommendation Card
                // Recommendations Cards Section
                // Recommendations Cards Section
                VStack(alignment: .leading, spacing: 0) {
                    Text("RECOMMENDED FOR YOU")
                        .font(.medium_12)
                        .foregroundColor(.heyGray3)
                        .padding(.bottom, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        if !viewModel.recommendedMenus.isEmpty {
                            HStack(spacing: 16) {
                                // Card for top recommendation
                                ZStack(alignment: .topTrailing) {
                                    
                                    
                                    VStack(alignment: .center, spacing: 12) {
                                        // Food icon
                                        Image(systemName: "fork.knife.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.heyMain.opacity(0.8))
                                            .padding(.top, 8)
                                        
                                        // Menu name
                                        Text(viewModel.recommendedMenus[0].menu_name ?? "")
                                            .font(.semibold_16)
                                            .foregroundColor(.heyGray1)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(height: 50)
                                        
                                        // Match percentage badge
                                        Text("\(viewModel.recommendedMenus[0].similarity)% Match")
                                            .font(.semibold_14)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.heyMain, Color.heyMain.opacity(0.7)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(16)
                                    }
                                    .padding(16)
                                    .frame(width: 160, height: 180)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white, Color.heyGray5.opacity(0.3)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.heyMain.opacity(0.3), lineWidth: 1.5)
                                    )
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                    
                                    // Top recommendation badge
                                    if viewModel.recommendedMenus[0].similarity >= 90 {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color.yellow)
                                            .clipShape(Circle())
                                            .offset(x: -8, y: 8)
                                    }
                                }
                                .scaleEffect(1.05) // Make the top recommendation slightly larger
                                
                                // Cards for other recommendations
                                ForEach(viewModel.recommendedMenus, id: \.self) { menu in
                                    VStack(alignment: .center, spacing: 12) {
                                        // Food icon - different for variety
                                        Image(systemName: menu.menu_name.contains("Bib") ? "leaf.circle.fill" : "flame.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(getColorForMatchPercentage(menu.similarity))
                                            .padding(.top, 8)
                                        
                                        // Menu name
                                        Text(menu.menu_name)
                                            .font(.semibold_16)
                                            .foregroundColor(.heyGray1)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(height: 50)
                                        
                                        // Match percentage badge
                                        Text("\(menu.similarity)% Match")
                                            .font(.semibold_14)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [getColorForMatchPercentage(menu.similarity), getColorForMatchPercentage(menu.similarity).opacity(0.7)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(16)
                                    }
                                    .padding(16)
                                    .frame(width: 150, height: 170)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white, Color.heyGray5.opacity(0.2)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(getColorForMatchPercentage(menu.similarity).opacity(0.2), lineWidth: 1)
                                    )
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .opacity(showTopRecommendation ? 1 : 0)
                    .offset(y: showTopRecommendation ? 0 : 20)
                        }
                        
                
                // Analysis Cards
                VStack(spacing: 16) {
                    // Allergy Information Card
                    AnalysisCard(
                        title: "Allergy Information",
                        iconName: "exclamationmark.triangle.fill",
                        iconColor: viewModel.allergiesDetected ? .red : .green,
                        iconBackgroundColor: viewModel.allergiesDetected ? Color.red.opacity(0.1) : Color.green.opacity(0.1),
                        delay: 0.1
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            if viewModel.allergiesDetected {
                                Text("Potential Allergens Detected")
                                    .font(.semibold_16)
                                    .foregroundColor(.red)
                                
                                ForEach(viewModel.allergiesInfo, id: \.allergen) { item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Circle()
                                            .fill(Color.red.opacity(0.8))
                                            .frame(width: 8, height: 8)
                                            .padding(.top, 6)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.allergen)
                                                .font(.medium_14)
                                                .foregroundColor(.heyGray1)
                                            
                                            Text("Found in: \(item.dishes.joined(separator: ", "))")
                                                .font(.regular_14)
                                                .foregroundColor(.heyGray2)
                                                .lineLimit(2)
                                        }
                                    }
                                }
                            } else {
                                Text("No Allergens Detected")
                                    .font(.semibold_16)
                                    .foregroundColor(.green)
                                
                                Text("Based on your profile, we haven't found any items containing your allergens.")
                                    .font(.regular_14)
                                    .foregroundColor(.heyGray2)
                            }
                        }
                    }
                    
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        // View Parsed Menu Button
                        Button(action: {
                            viewModel.send(.viewParsedMenuTapped)
                        }) {
                            HStack {
                                Image(systemName: "doc.text.magnifyingglass")
                                    .font(.body)
                                
                                Text("View Parsed Menu")
                                    .font(.semibold_16)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.heyMain)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        // Return Home Button
                        Button(action: {
                            viewModel.send(.returnHomeTapped)
                        }) {
                            HStack {
                                Image(systemName: "house.fill")
                                    .font(.body)
                                
                                Text("Return to Home")
                                    .font(.regular_16)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.heyGray5)
                            .foregroundColor(.heyGray1)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.heyWhite)
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(edges: .bottom)
            
            .onAppear {
                viewModel.send(.onAppear)
                withAnimation(Animation.easeOut(duration: 0.5).delay(0.2)) {
                    animateCards = true
                }
                
                withAnimation(Animation.easeOut(duration: 0.6).delay(0.5)) {
                    showTopRecommendation = true
                }
            }
            .sheet(isPresented: $viewModel.showImageSheet) {
                ParsedMenuSheetView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showShareSheet) {
                if let image = viewModel.parsedMenuImage {
                    ShareSheet(activityItems: [image])
                }
            }
        }
    }
    
    // Reusable Analysis Card Component
    struct AnalysisCard<Content: View>: View {
        let title: String
        let iconName: String
        let iconColor: Color
        let iconBackgroundColor: Color
        let delay: Double
        let content: Content
        @State private var isVisible: Bool = false
        
        init(title: String, iconName: String, iconColor: Color, iconBackgroundColor: Color, delay: Double, @ViewBuilder content: () -> Content) {
            self.title = title
            self.iconName = iconName
            self.iconColor = iconColor
            self.iconBackgroundColor = iconBackgroundColor
            self.delay = delay
            self.content = content()
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: iconName)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                        .padding(10)
                        .background(iconBackgroundColor)
                        .clipShape(Circle())
                    
                    Text(title)
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                }
                
                content
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
//                viewModel.send(.onAppear)
                withAnimation(Animation.easeOut(duration: 0.5).delay(delay)) {
                    isVisible = true
                }
            }
        }
    }
    
    // Helper function for dynamic color based on match percentage
    private func getColorForMatchPercentage(_ percentage: Double) -> Color {
        switch percentage {
        case 90...100:
            return .green
        case 70..<90:
            return .heyMain
        case 50..<70:
            return .orange
        default:
            return .gray
        }
    }
}

// MARK: - ShareSheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - ParsedMenuSheetView
struct ParsedMenuSheetView: View {
    @ObservedObject var viewModel: MenuAnalysisResultViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.send(.dismissImageSheet)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("Parsed Menu")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    viewModel.send(.downloadImageTapped)
                }) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            if let image = viewModel.parsedMenuImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                ProgressView()
                    .padding()
            }
            
            Button(action: {
                viewModel.send(.downloadImageTapped)
            }) {
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Download Image")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            Spacer()
        }
    }
}

#Preview {
    let container = DIContainer.stub
    return MenuAnalysisResultView(viewModel: .init(navigationRouter: container.navigationRouter))
        .environmentObject(DIContainer.stub)
}
