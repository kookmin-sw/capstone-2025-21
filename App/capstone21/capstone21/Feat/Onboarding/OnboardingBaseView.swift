//
//  OnboardingBaseView.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import SwiftUI

struct OnboardingBaseView<Content:View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    let content: Content
    
    let titleText: String
    
    let hiddenCloseBtn: Bool
    
    let buttonTitle: String
    let nextButtonIsEnabled: Bool
    let nextButtonAction: () -> Void
    
    init(
        @ViewBuilder content: () -> Content,
        titleText: String,
        nextButtonIsEnabled: Bool = true,
        buttonTitle: String = "Continue",
        hiddenCloseBtn: Bool = true,
        nextButtonAction: @escaping () -> Void
    ) {
        self.content = content()
        self.titleText = titleText
        self.buttonTitle = buttonTitle
        self.hiddenCloseBtn = hiddenCloseBtn
        self.nextButtonIsEnabled = nextButtonIsEnabled
        self.nextButtonAction = nextButtonAction
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Spacer()
                    .frame(height: 92)
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(uiImage: .icBack)
                            .resizable()
                            .frame(width: 22, height: 18)
                    }
                    .hidden(!hiddenCloseBtn)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(uiImage: .icClose)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    .hidden(hiddenCloseBtn)
                    
                }
                
                VStack(alignment: .leading) {
                    Text(titleText)
                        .font(.semibold_18)
                        .foregroundColor(.heyGray1)
                        .padding(.bottom, 18)
                    
                    content
                    
                    Spacer()
                    
                    Button(buttonTitle) {
                        nextButtonAction()
                    }
                    .disabled(!nextButtonIsEnabled)
                    .heyBottomButtonStyle()
                    
                }
                .padding(.top, 36)
                .padding(.bottom, 65)
            }
            .padding(.horizontal, 16)
            .background(Color.heyWhite)
            .ignoresSafeArea(edges: .vertical)
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden()
        }
    }
}

