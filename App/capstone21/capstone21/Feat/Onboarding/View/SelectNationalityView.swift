//
//  SelectNationalityView.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import SwiftUI

public struct SelectNationalityView: View {
    @EnvironmentObject var container: DIContainer
    @ObservedObject var viewModel: SelectNationalityViewModel
    @FocusState private var isFocused: Bool
    
    public init(viewModel: SelectNationalityViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        OnboardingBaseView(
            content: {
                VStack {
                    HeyTextField(
                        text: $viewModel.searchText,
                        placeHolder: "Select your nationality",
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
                            ForEach(viewModel.state.filteredItems, id: \.self) { nationality in
                                SelectUniversityListCellView(
                                    nationality,
                                    isSelected: nationality == viewModel.nationality
                                )
                                .onTapGesture {
                                    viewModel.send(.selectNationality(nationality))
                                }
                            }
                        }
                        .cornerRadius(8)
                    }
                }
            }, titleText: "What is your nationality?",
            nextButtonIsEnabled: viewModel.state.continueButtonIsEnabled,
            nextButtonAction: { viewModel.send(.nextButtonDidTap) }
        )
        .onTapGesture { isFocused = false }
    }
}


fileprivate struct SelectUniversityListCellView: View {
    private let nationality: NationalityInfo
    private let isSelected: Bool
    
    init(_ nationality: NationalityInfo, isSelected: Bool) {
        self.nationality = nationality
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack {
            nationality.image
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 16)
            
            Text(nationality.rawValue)
                .font(.regular_14)
                .foregroundColor(.heyGray1)
                .padding(.leading, 12)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(isSelected ? Color.heyMain : Color.heyGray4)
    }
}

#Preview {
    let container = DIContainer.stub
    return SelectNationalityView(viewModel: .init(
        navigationRouter: container.navigationRouter
        )
    )
    .environmentObject(DIContainer.stub)
}
