//
//  SelectKoreanFoodView.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import SwiftUI

public struct SelectKoreanFoodView: View {
    @EnvironmentObject var container: DIContainer
    @ObservedObject var viewModel: SelectKoreanFoodViewModel
    @FocusState private var isFocused: Bool
    
    private let categoryColors: [String: Color] = [
        "밥류": .red,
        "반찬": .green,
        "고기류": .orange,
        "면류": .yellow,
        "분식": .pink,
        "찌개": .purple,
        "전류": .blue,
        "탕류": .brown,
        "디저트": .mint
    ]
    
    public init(viewModel: SelectKoreanFoodViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        OnboardingBaseView(
            content: {
                VStack(spacing: 16) {
                    // Category filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryButton(
                                title: "전체",
                                isSelected: viewModel.selectedCategory == nil,
                                color: .heyGray1
                            ) {
                                viewModel.send(.filterByCategory(nil))
                            }
                            
                            ForEach(Array(viewModel.state.categorizedFoods.keys.sorted()), id: \.self) { category in
                                CategoryButton(
                                    title: category,
                                    isSelected: viewModel.selectedCategory == category,
                                    color: categoryColors[category, default: .gray]
                                ) {
                                    viewModel.send(.filterByCategory(category))
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Selected foods
                    if !viewModel.selectedFoods.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Selected Foods")
                                .font(.regular_16)
                                .foregroundColor(.heyGray1)
                                .padding(.leading, 4)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.selectedFoods) { food in
                                        SelectedFoodView(food: food) {
                                            viewModel.send(.toggleFood(food))
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        
                        // Divider
                        Rectangle()
                            .fill(Color.heyGray4)
                            .frame(height: 1)
                            .padding(.vertical, 8)
                    }
                    
                    // Food grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                            ForEach(viewModel.state.filteredItems) { food in
                                KoreanFoodCell(
                                    food: food,
                                    isSelected: viewModel.selectedFoods.contains(where: { $0.id == food.id }),
                                    color: categoryColors[food.category, default: .gray]
                                ) {
                                    viewModel.send(.toggleFood(food))
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .padding(.bottom, 30)
                }
            }, titleText: "Select your favorite Korean food",
            nextButtonIsEnabled: viewModel.state.continueButtonIsEnabled,
            nextButtonAction: { viewModel.send(.nextButtonDidTap) }
        )
        .onTapGesture { isFocused = false }
    }
}

// MARK: - Supporting Views

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.medium_12)
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? color : Color.white)
                        .overlay(
                            Capsule()
                                .stroke(color, lineWidth: 1)
                        )
                )
        }
    }
}

struct SelectedFoodView: View {
    let food: KoreanFood
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(food.emoji)
                    .font(.system(size: 18))
                Text(food.name)
                    .font(.medium_14)
                    .foregroundColor(.white)
                
                Image(uiImage: .icClose)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.heyMain)
            )
        }
    }
}

struct KoreanFoodCell: View {
    let food: KoreanFood
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(food.emoji)
                        .font(.system(size: 28))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(food.name)
                            .font(.medium_16)
                            .foregroundColor(.heyGray1)
                        
                        Spacer()
                        
                        Text(food.category)
                            .font(.regular_12)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(color)
                            )
                    }
                    
                    Text(food.description)
                        .font(.regular_14)
                        .foregroundColor(.heyGray2)
                        .lineLimit(1)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.clear : Color.heyGray4, lineWidth: 1.5)
                        .background(
                            Circle()
                                .fill(isSelected ? Color.heyMain : Color.clear)
                        )
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
    }
}

#Preview {
    let container = DIContainer.stub
    return SelectKoreanFoodView(viewModel: .init(
        navigationRouter: container.navigationRouter)
    )
    .environmentObject(DIContainer.stub)
}
