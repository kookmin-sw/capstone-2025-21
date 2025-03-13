//
//  PasswordTextField.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct PasswordField: View {
    @Binding var password: String
    @Binding var showPassword: Bool
    
    let placeHolder: String
    @Binding var textFieldState: TextFieldState
    let colorSystem: HeyTextFieldColorStyle
    
    public init(
        password: Binding<String>,
        showPassword: Binding<Bool>,
        placeHolder: String = "Password",
        textFieldState: Binding<TextFieldState> = .constant(.idle),
        colorSystem: HeyTextFieldColorStyle = .gray
    ) {
        self._password = password
        self._showPassword = showPassword
        self.placeHolder = placeHolder
        self._textFieldState = textFieldState
        self.colorSystem = colorSystem
    }
    
    public var body: some View {
        HStack {
            if !showPassword {
                SecureField(
                    "",
                    text: $password,
                    prompt: Text(placeHolder)
                        .foregroundColor(.heyGray3)
                )
                .heyTextFieldStyle()
            } else {
                TextField(
                    "",
                    text: $password,
                    prompt: Text("Password")
                        .foregroundColor(.heyGray3)
                )
                .heyTextFieldStyle()
            }
            
            Button(action: { self.showPassword.toggle() }) {
                Image(uiImage: showPassword ? .icShow : .icHide)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(colorSystem.background)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(textFieldState.strokeColor, lineWidth: 2)
        )
        
    }
}
