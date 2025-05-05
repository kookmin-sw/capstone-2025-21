//
//  SelectAllergyView.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import SwiftUI

public struct SelectAllergyView: View {
    @EnvironmentObject var container: DIContainer
    @ObservedObject var viewModel: SelectAllergyViewModel
    @FocusState private var isFocused: Bool
    @FocusState private var customAllergyFocused: Bool
    
    public init(viewModel: SelectAllergyViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        OnboardingBaseView(
            content: {
                VStack(alignment: .leading) {
                    Text("Allergies")
                        .font(.bold_14)
                        .padding(.bottom, 4)
                        
                    if !viewModel.selectedAllergies.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(viewModel.selectedAllergies, id: \.self) { allergy in
                                    AllergyCapsuleView(
                                        allergy: allergy,
                                        isSelected: true
                                    ) {
                                        viewModel.send(.toggleAllergy(allergy))
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Rectangle()
                        .fill(Color.heyGray4)
                        .frame(height: 1)
                        .padding(.vertical, 8)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(viewModel.state.filteredItems, id: \.self) { allergy in
                                AllergyCapsuleView(
                                    allergy: allergy,
                                    isSelected: viewModel.selectedAllergies.contains(allergy)
                                ) {
                                    viewModel.send(.toggleAllergy(allergy))
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .padding(.bottom, 30)
                }
            }, titleText: "Select your allergies!",
            nextButtonIsEnabled: viewModel.state.continueButtonIsEnabled,
            nextButtonAction: { viewModel.send(.nextButtonDidTap) }
        )
        .onTapGesture { isFocused = false }
        .sheet(isPresented: $viewModel.state.showingCustomAllergyInput) {
            CustomAllergyInputView(
                customAllergyText: Binding(
                    get: { viewModel.state.customAllergyText },
                    set: { viewModel.send(.updateCustomAllergyText($0)) }
                ),
                isFocused: _customAllergyFocused,
                onAdd: { viewModel.send(.addCustomAllergy) },
                onCancel: { viewModel.send(.cancelCustomAllergyInput) }
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    customAllergyFocused = true
                }
            }
        }
    }
}

struct CustomAllergyInputView: View {
    @Binding var customAllergyText: String
    @FocusState var isFocused: Bool
    let onAdd: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Add Custom Allergy")
                .font(.bold_14)
                .padding(.top, 20)
            
            TextField("Enter allergy name", text: $customAllergyText)
                .focused($isFocused)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.heyGray4, lineWidth: 1)
                )
                .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.medium_16)
                        .foregroundColor(.heyGray1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.heyGray4, lineWidth: 1)
                        )
                }
                
                Button(action: onAdd) {
                    Text("Add")
                        .font(.medium_16)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.heyMain)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(height: 200)
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}

struct AllergyCapsuleView: View {
    let allergy: AllergyInfo
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text("\(allergy.emoji) \(allergy.name)")
                    .font(.regular_14)
                    .foregroundColor(isSelected ? .white : .heyGray1)
                
                if isSelected {
                    Image(uiImage: .icClose)
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                }
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

#Preview {
    let container = DIContainer.stub
    return SelectAllergyView(viewModel: .init(
        navigationRouter: container.navigationRouter,
        userInfo: .empty
    )
    )
    .environmentObject(DIContainer.stub)
}
