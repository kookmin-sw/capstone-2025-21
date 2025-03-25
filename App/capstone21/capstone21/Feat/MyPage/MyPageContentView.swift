//
//  MyPageContentView.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import SwiftUI

struct MyPageContentView: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    public init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AccountView(viewModel: viewModel)
                
                SupportView(viewModel: viewModel)
                
                AppSettingView(viewModel: viewModel)
                
                EtcView(viewModel: viewModel)
            }
            
            Spacer()
                .frame(height: 60)
        }
        .scrollIndicators(.hidden)
    }
}

public struct AccountView: View {
    @ObservedObject private var viewModel: MyPageViewModel
    
    fileprivate init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Account")
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    Button {
                        viewModel.send(.changePasswordButtonDidTap)
                    } label: {
                        Text("Change password")
                            .font(.regular_14)
                            .foregroundColor(.heyGray1)
                    }
                    
                    Text("Change User ID")
                        .font(.regular_14)
                        .foregroundColor(.heyGray1)
                    
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)
                
                Spacer()
            }
            
        }
        .background(Color.heyGray4)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public struct SupportView: View {
    @ObservedObject private var viewModel: MyPageViewModel
    
    public init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Support")
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    Button {
                        viewModel.send(.privacyPolicyButtonDidTap)
                    } label: {
                        Text("Privacy policy")
                            .font(.regular_14)
                            .foregroundColor(.heyGray1)
                    }
                    
                    Button {
                        viewModel.send(.termsOfServiceButtonDidTap)
                    } label: {
                        Text("Terms of service")
                            .font(.regular_14)
                            .foregroundColor(.heyGray1)
                    }
                    
                    Button {
                        viewModel.send(.contactUsButtonDidTap)
                    } label: {
                        Text("Contact us")
                            .font(.regular_14)
                            .foregroundColor(.heyGray1)
                    }
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)
                
                Spacer()
            }
            
        }
        .background(Color.heyGray4)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public struct AppSettingView: View {
    @ObservedObject private var viewModel: MyPageViewModel
    
    fileprivate init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Account")
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    Button {
                        viewModel.send(.notificationSettingButtonDidTap)
                    } label: {
                        Text("Notification setting")
                            .font(.regular_14)
                            .foregroundColor(.heyGray1)
                    }
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)
                
                Spacer()
            }
            
        }
        .background(Color.heyGray4)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public struct EtcView: View {
    @ObservedObject private var viewModel: MyPageViewModel
    
    fileprivate init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Etc")
                        .font(.semibold_16)
                        .foregroundColor(.heyGray1)
                    
                    Button {
                        viewModel.send(.deleteAccountButtonDidTap)
                    } label: {
                        Text("Delete account")
                            .font(.regular_14)
                            .foregroundColor(.heyGray1)
                    }
                    
                    Button {
                        viewModel.send(.logoutButtonDidTap)
                    } label: {
                        Text("Log out")
                            .font(.regular_14)
                            .foregroundColor(.heyGray1)
                    }
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)
                
                Spacer()
            }
            
        }
        .background(Color.heyGray4)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

