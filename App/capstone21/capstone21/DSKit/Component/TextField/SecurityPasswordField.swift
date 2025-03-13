//
//  SecurityPasswordField.swift
//  DSKit
//
//  Created by 류희재 on 12/31/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct SecurityPasswordField: View {
    @Binding var password: String
    
    let placeHolder: String
    @Binding var textFieldState: TextFieldState
    let colorSystem: HeyTextFieldColorStyle
    
    public init(
        password: Binding<String>,
        placeHolder: String = "Password",
        textFieldState: Binding<TextFieldState> = .constant(.idle),
        colorSystem: HeyTextFieldColorStyle = .gray
    ) {
        self._password = password
        self.placeHolder = placeHolder
        self._textFieldState = textFieldState
        self.colorSystem = colorSystem
    }
    
    public var body: some View {
        HStack {
            SecureField(
                "",
                text: $password,
                prompt: Text(placeHolder)
                    .foregroundColor(.heyGray3)
            )
            .heyTextFieldStyle()
            
            
            if textFieldState.isValid() {
                Image(uiImage: textFieldState.image!)
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
    
    
