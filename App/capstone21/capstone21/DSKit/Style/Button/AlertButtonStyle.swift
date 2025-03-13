//
//  AlertButtonStyle.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

struct HeyAlertButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let colorStyle: HeyButtonColorStyle
    
    init(_ colorStyle: HeyButtonColorStyle) {
        self.colorStyle = colorStyle
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(height: 46)
            .frame(maxWidth: .infinity)
//            .font(.medium_16)
            .background(colorStyle.background)
            .foregroundStyle(colorStyle.foreground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

public extension View {
    func heyAlertButtonStyle(_ colorStyle: HeyButtonColorStyle = .gray) -> some View {
        self.buttonStyle(HeyAlertButtonStyle(colorStyle))
    }
}

