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
    
    public init(viewModel: SelectAllergyViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        OnboardingBaseView(
            content: {
                VStack {
                    HeyTextField(
                        text: $viewModel.searchText,
                        placeHolder: "Select your university",
                        leftImage: .icSchool
                    )
                    .focused($isFocused)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.heyMain, lineWidth: 2)
                    )
                    .onChange(of: isFocused) { isFocused in
                        if isFocused {
                            viewModel.send(.textFieldDidTap)
                        }
                    }
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.state.filteredItems, id: \.self) { university in
                                SelectUniversityListCellView(
                                    university,
                                    isSelected: university == viewModel.university
                                )
                                .onTapGesture {
                                    viewModel.send(.selectUniversity(university))
                                }
                            }
                        }
                        .cornerRadius(8)
                    }
                }
            }, titleText: "What school are you attending?",
            nextButtonIsEnabled: viewModel.state.continueButtonIsEnabled,
            nextButtonAction: { viewModel.send(.nextButtonDidTap) }
        )
        .onTapGesture { isFocused = false }
    }
}


fileprivate struct SelectUniversityListCellView: View {
    private let university: String
    private let isSelected: Bool
    
    init(_ university: String, isSelected: Bool) {
        self.university = university
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack {
            Image(uiImage: .icAdd)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 16)
            
            Text(university)
                .font(.regular_14)
                .foregroundColor(.heyGray1)
                .padding(.leading, 12)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(isSelected ? Color.heyMain : Color.heyGray4)
    }
}

