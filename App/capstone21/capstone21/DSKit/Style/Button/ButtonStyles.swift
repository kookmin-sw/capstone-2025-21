//
//  ButtonStyle.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct HeyBottomButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let colorStyle: HeyButtonColorStyle
    private let cornerRadius: CGFloat
    
    init(
        _ colorStyle: HeyButtonColorStyle,
        cornerRadius: CGFloat
    ) {
        self.colorStyle = colorStyle
        self.cornerRadius = cornerRadius
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(height: 56)
            .frame(maxWidth: .infinity)
//            .font(.semibold_14)
            .background(isEnabled ? colorStyle.background : colorStyle.disabledBackground)
            .foregroundStyle(isEnabled ? colorStyle.foreground : colorStyle.disabledForeground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

extension View {
    public func heyBottomButtonStyle(_ colorStyle: HeyButtonColorStyle = .primary, cornerRadius: CGFloat = 28) -> some View {
        self.buttonStyle(HeyBottomButtonStyle(colorStyle, cornerRadius: cornerRadius))
    }
}

