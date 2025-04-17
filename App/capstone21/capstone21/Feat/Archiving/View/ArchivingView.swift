//
//  ArchivingView.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import SwiftUI

struct ArchivingView: View {
    @StateObject private var viewModel = ArchivingViewModel()
    @State private var searchText = ""
    @State private var showingFilter = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header and search bar
                headerSection
                
                // Featured recommendations
                if !viewModel.featuredRecommendations.isEmpty {
                    featuredSection
                }
                
                // Category selection
                categorySection
                
                // Restaurant list based on preferences
                recommendationsSection
            }
            .padding(.top, 92) // Top safe area for the design
            .padding(.bottom, 70) // Bottom safe area
        }
        .background(Color.heyWhite)
        .sheet(isPresented: $showingFilter) {
            FilterView(
                selectedFoodCategories: $viewModel.selectedCategories,
                selectedPriceRange: $viewModel.selectedPriceRange
            )
        }
        .overlay(alignment: .top) {
            // Custom navigation bar
            titleBar
        }
    }
    
    // MARK: - UI Components
    
    private var titleBar: some View {
        ZStack {
            Color.heyMain
                .frame(height: 92)
                .ignoresSafeArea(edges: .top)
            
            VStack {
                Spacer()
                Text("Food Archive")
                    .font(.semibold_18)
                    .foregroundColor(.white)
                    .padding(.bottom, 16)
            }
        }
        .frame(height: 92)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                TextField("Search restaurants", text: $searchText)
                    .padding(12)
                    .background(Color.heyGray4)
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.heyGray2)
                                .padding(.trailing, 12)
                        }
                    )
                
                Button(action: {
                    showingFilter = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.heyGray1)
                        .frame(width: 44, height: 44)
                        .background(Color.heyGray4)
                        .cornerRadius(8)
                }
            }
            
            Text("Based on your food preferences")
                .font(.bold_20)
                .foregroundColor(.heyGray1)
                
            HStack(spacing: 8) {
                ForEach(viewModel.userPreferredFoods.prefix(3), id: \.id) { food in
                    HStack(spacing: 4) {
                        Text(food.emoji)
                            .font(.system(size: 16))
                        Text(food.name)
                            .font(.medium_12)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.heyMain)
                    )
                }
                
                if viewModel.userPreferredFoods.count > 3 {
                    Text("+\(viewModel.userPreferredFoods.count - 3)")
                        .font(.medium_12)
                        .foregroundColor(.heyGray1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .stroke(Color.heyGray3, lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FEATURED RECOMMENDATIONS")
                .font(.medium_14)
                .foregroundColor(.heyGray2)
                .padding(.leading, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.featuredRecommendations) { restaurant in
                        FeaturedRestaurantCard(restaurant: restaurant)
                            .onTapGesture {
                                viewModel.selectRestaurant(restaurant)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BROWSE BY CATEGORY")
                .font(.medium_14)
                .foregroundColor(.heyGray2)
                .padding(.leading, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(FoodCategory.allCases, id: \.self) { category in
                        ArchivingCategoryButton(
                            category: category,
                            isSelected: viewModel.selectedCategories.contains(category),
                            action: {
                                viewModel.toggleCategory(category)
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("RECOMMENDED FOR YOU")
                .font(.medium_14)
                .foregroundColor(.heyGray2)
                .padding(.leading, 16)
                .padding(.top, 8)
            
            if viewModel.filteredRestaurants.isEmpty {
                emptyStateView
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredRestaurants) { restaurant in
                        RestaurantCard(restaurant: restaurant)
                            .onTapGesture {
                                viewModel.selectRestaurant(restaurant)
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife")
                .font(.system(size: 48))
                .foregroundColor(.heyGray3)
            
            Text("No restaurants found")
                .font(.medium_16)
                .foregroundColor(.heyGray2)
            
            Text("Try changing your filters or search terms")
                .font(.regular_14)
                .foregroundColor(.heyGray3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

// MARK: - Supporting Views

struct FeaturedRestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                restaurant.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240, height: 160)
                    .cornerRadius(12)
                    .clipped()
                
                if let matchPercentage = restaurant.matchPercentage {
                    Text("\(matchPercentage)% Match")
                        .font(.semibold_12)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.heyMain)
                        .cornerRadius(8)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.semibold_16)
                    .foregroundColor(.heyGray1)
                
                HStack(spacing: 4) {
                    ForEach(restaurant.foodTags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.regular_12)
                            .foregroundColor(.heyGray2)
                    }
                    
                    if restaurant.foodTags.count > 3 {
                        Text("...")
                            .font(.regular_12)
                            .foregroundColor(.heyGray3)
                    }
                }
                
                HStack {
                    Text(restaurant.priceRange.rawValue)
                        .font(.regular_12)
                        .foregroundColor(.heyGray2)
                    
                    Text("•")
                        .foregroundColor(.heyGray3)
                    
                    Text(restaurant.distance)
                        .font(.regular_12)
                        .foregroundColor(.heyGray2)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.semibold_12)
                            .foregroundColor(.heyGray1)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 240)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

private struct ArchivingCategoryButton: View {
    let category: FoodCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(category.emoji)
                    .font(.system(size: 16))
                
                Text(category.displayName)
                    .font(.regular_14)
                    .foregroundColor(isSelected ? .white : .heyGray1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.heyMain : Color.white)
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? Color.clear : Color.heyGray4, lineWidth: 1)
                    )
            )
        }
    }
}

struct RestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            restaurant.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(restaurant.name)
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    Spacer()
                    
                    if let matchPercentage = restaurant.matchPercentage {
                        Text("\(matchPercentage)%")
                            .font(.semibold_14)
                            .foregroundColor(.heyMain)
                    }
                }
                
                HStack(spacing: 4) {
                    ForEach(restaurant.foodTags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.regular_12)
                            .foregroundColor(.heyGray2)
                            .lineLimit(1)
                    }
                    
                    if restaurant.foodTags.count > 3 {
                        Text("...")
                            .font(.regular_12)
                            .foregroundColor(.heyGray3)
                    }
                }
                
                if let specialMenu = restaurant.recommendedMenu {
                    HStack(spacing: 4) {
                        Text("Try:")
                            .font(.regular_12)
                            .foregroundColor(.heyGray3)
                        
                        Text(specialMenu)
                            .font(.medium_12)
                            .foregroundColor(.heyMain)
                    }
                    .padding(.top, 2)
                }
                
                Spacer()
                
                HStack {
                    Text(restaurant.priceRange.rawValue)
                        .font(.regular_12)
                        .foregroundColor(.heyGray2)
                    
                    Text("•")
                        .foregroundColor(.heyGray3)
                    
                    Text(restaurant.distance)
                        .font(.regular_12)
                        .foregroundColor(.heyGray2)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.semibold_12)
                            .foregroundColor(.heyGray1)
                    }
                }
            }
            .frame(height: 100, alignment: .leading)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct FilterView: View {
    @Binding var selectedFoodCategories: Set<FoodCategory>
    @Binding var selectedPriceRange: Set<PriceRange>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                // Food Categories
                VStack(alignment: .leading, spacing: 12) {
                    Text("Food Categories")
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            Button(action: {
                                if selectedFoodCategories.contains(category) {
                                    selectedFoodCategories.remove(category)
                                } else {
                                    selectedFoodCategories.insert(category)
                                }
                            }) {
                                HStack {
                                    Text(category.emoji)
                                        .font(.system(size: 20))
                                        .frame(width: 32)
                                    
                                    Text(category.displayName)
                                        .font(.regular_16)
                                        .foregroundColor(.heyGray1)
                                    
                                    Spacer()
                                    
                                    if selectedFoodCategories.contains(category) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.heyMain)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Price Range
                VStack(alignment: .leading, spacing: 12) {
                    Text("Price Range")
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(PriceRange.allCases, id: \.self) { price in
                            Button(action: {
                                if selectedPriceRange.contains(price) {
                                    selectedPriceRange.remove(price)
                                } else {
                                    selectedPriceRange.insert(price)
                                }
                            }) {
                                HStack {
                                    Text(price.rawValue)
                                        .font(.regular_16)
                                        .foregroundColor(.heyGray1)
                                    
                                    Spacer()
                                    
                                    if selectedPriceRange.contains(price) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.heyMain)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Apply Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Apply Filters")
                        .font(.semibold_16)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.heyMain)
                        .cornerRadius(12)
                }
            }
            .padding(16)
            .navigationTitle("Filter Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedFoodCategories.removeAll()
                        selectedPriceRange.removeAll()
                    }
                    .foregroundColor(.heyMain)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.heyGray1)
                }
            }
        }
    }
}

extension Image {
    static func placeholder(_ color: Color = .gray) -> Image {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color) as! Image
    }
}

#Preview {
    ArchivingView()
}
