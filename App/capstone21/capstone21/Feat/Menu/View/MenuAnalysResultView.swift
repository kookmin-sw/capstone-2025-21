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
                VStack(alignment: .leading, spacing: 0) {
                    Text("YOUR TOP RECOMMENDATION")
                        .font(.medium_12)
                        .foregroundColor(.heyGray3)
                        .padding(.bottom, 8)
                    
                    ZStack(alignment: .topTrailing) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top, spacing: 16) {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundColor(.yellow)
                                    .padding(12)
                                    .background(Color.yellow.opacity(0.2))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(viewModel.topRecommendedMenu.name)
                                        .font(.semibold_18)
                                        .foregroundColor(.heyGray1)
                                    
                                    Text("Best match for your preferences")
                                        .font(.regular_14)
                                        .foregroundColor(.heyGray2)
                                }
                                
                                Spacer()
                                
                                Text("\(viewModel.topRecommendedMenu.price)")
                                    .font(.semibold_16)
                                    .foregroundColor(.heyMain)
                            }
                            
                            Text(viewModel.topRecommendedMenu.description)
                                .font(.regular_14)
                                .foregroundColor(.heyGray2)
                                .lineLimit(3)
                                .padding(.leading, 8)
                            
                            HStack(spacing: 8) {
                                ForEach(viewModel.topRecommendedMenu.matchReasons, id: \.self) { reason in
                                    Text(reason)
                                        .font(.medium_12)
                                        .foregroundColor(.heyMain)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.heyMain.opacity(0.1))
                                        .cornerRadius(16)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        
                        // Match percentage badge
                        Text("\(viewModel.topRecommendedMenu.matchPercentage)% Match")
                            .font(.semibold_14)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.heyMain)
                            .cornerRadius(16)
                            .padding(16)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .opacity(showTopRecommendation ? 1 : 0)
                .offset(y: showTopRecommendation ? 0 : 20)
                
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
