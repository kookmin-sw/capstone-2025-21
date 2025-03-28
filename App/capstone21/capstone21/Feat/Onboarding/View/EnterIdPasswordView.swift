//
//  EnterIdPasswordView.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import SwiftUI

public struct EnterIdPasswordView: View {
    @EnvironmentObject var container: DIContainer
    @ObservedObject var viewModel: EnterIdPasswordViewModel
    
    @State var showPassword = false
    
    public init(viewModel: EnterIdPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        OnboardingBaseView(content: {
            Spacer()
                .frame(height: 8)
            
            VStack(spacing: 32) {
                HeyTextField(
                    text: $viewModel.nickName,
                    placeHolder: "username",
                    rightImage: .icRepeat,
                    textFieldState: $viewModel.state.nickNameIsValid,
                    colorSystem: .gray,
                    action: {
                        viewModel.send(.checkIDAvailabilityButtonDidTap)
                    }
                )
                
                PasswordField(
                    password: $viewModel.password,
                    showPassword: $showPassword,
                    textFieldState: $viewModel.state.passwordIsValid
                )
                
                SecurityPasswordField(
                    password: $viewModel.checkPassword,
                    placeHolder: "Confirm Password",
                    textFieldState: $viewModel.state.checkPasswordIsValid
                )
            }
            
        }, titleText: "Create your username\nand password", nextButtonIsEnabled: viewModel.state.continueButtonIsEnabled, nextButtonAction: { viewModel.send(.nextButtonDidTap) }
        )
    }
}

#Preview {
    let container = DIContainer.stub
    return EnterIdPasswordView(viewModel: .init(
        navigationRouter: container.navigationRouter,
        windowRouter: container.windowRouter
    )
    )
    .environmentObject(DIContainer.stub)
}
