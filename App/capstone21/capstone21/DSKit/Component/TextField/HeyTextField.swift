//
//  HeyTextField.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct HeyTextField: View {
    @Binding var text: String
    let placeHolder: String
    let leftImage: UIImage?
    let rightImage: UIImage?
    @Binding var textFieldState: TextFieldState
    let colorSystem: HeyTextFieldColorStyle
    let action: () -> Void
    
    public init(
        text: Binding<String>,
        placeHolder: String,
        leftImage: UIImage? = nil,
        rightImage: UIImage? = nil,
        textFieldState: Binding<TextFieldState> = .constant(.idle),
        colorSystem: HeyTextFieldColorStyle = .white,
        action: @escaping () -> Void = {}
    ) {
        self._text = text
        self.placeHolder = placeHolder
        self.leftImage = leftImage
        self.rightImage = rightImage
        self._textFieldState = textFieldState
        self.colorSystem = colorSystem
        self.action = action
    }
    
    
    public var body: some View {
        HStack {
            if let image = leftImage {
                Image(uiImage: image)
            }
            
            TextField(
                "",
                text: $text,
                prompt: Text(placeHolder)
                    .foregroundColor(.heyGray3)
            )
            .heyTextFieldStyle()
            
            if let image = rightImage {
                Button(action: self.action) {
                    Image(uiImage: image)
                }
            } else {
                if let image = textFieldState.image {
                    Image(uiImage: image)
                }
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

