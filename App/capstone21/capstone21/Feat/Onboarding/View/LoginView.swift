//
//  LoginView.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

//
//  LogInView.swift
//  OnboardingFeature
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct LogInView: View {
    @EnvironmentObject var container: DIContainer
    @ObservedObject var viewModel: LogInViewModel
    
    @State var showPassword: Bool = false
    @FocusState var isFocused: Field?
    
    enum Field {
        case id
        case password
    }
    
    public init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Button {
                        viewModel.send(.closeButtonDidTap)
                    } label: {
                        Image(uiImage: .icClose)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    .hidden(!viewModel.state.showCloseBtn)
                }
                .padding(.bottom, 10)
                
                Image(uiImage: .icAdd)
                    .resizable()
                    .frame(height: 56)
                    .padding(.horizontal, 125)
                    .padding(.bottom, 32)
                
                HStack {
                    Text("Log In")
                        .font(.semibold_18)
                        .foregroundStyle(Color.heyGray1)
                    
                    Spacer()
                    
                    Text("New to Heylets?")
                        .font(.regular_14)
                        .foregroundStyle(Color.heyGray1)
                        .padding(.trailing, 8)
                    
                    Button {
                        viewModel.send(.signUpButtonDidTap)
                    } label: {
                        Text("Sign Up")
                            .font(.regular_12)
                            .foregroundStyle(Color.heyMain)
                    }
                }
                .padding(.bottom, 29)
                
                HeyTextField(
                    text: $viewModel.id,
                    placeHolder: "ID"
                )
                .focused($isFocused, equals: .id)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.heyGray3, lineWidth: 1)
                )
                .padding(.bottom, 21)
                
                PasswordField(
                    password: $viewModel.password,
                    showPassword: $showPassword, colorSystem: .white
                )
                .focused($isFocused, equals: .password)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.heyGray3, lineWidth: 1)
                )
                .padding(.bottom, 14)
                
                HStack {
                    Text(viewModel.state.errMessage)
                        .font(.regular_14)
                        .foregroundColor(.heyError)
                        .frame(width: 180)
                    
                    Spacer()
                    
                    Button {
                        viewModel.send(.forgotPasswordButtonDidTap)
                    } label: {
                        Text("Forgot password?")
                            .font(.regular_12)
                            .foregroundStyle(Color.heyGray1)
                    }
                }
                
                Spacer()
                
                Button("Log In") {
                    viewModel.send(.loginButtonDidTap)
                }
                .heyBottomButtonStyle()
            }
            .onSubmit {
                switch isFocused {
                case .id:
                    isFocused = .password
                default:
                    isFocused = nil
                }
            }
            .onAppear {
                viewModel.send(.onAppear)
            }
            .padding(.top, 106)
            .padding(.bottom, 65)
            .padding(.horizontal, 16)
            .background(Color.heyWhite)
            .ignoresSafeArea(edges: .vertical)
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden()
            .onTapGesture {
                isFocused = nil
            }
            .loading(viewModel.state.isLoading)
            .setMenuNavigation()
        }
    }
}
