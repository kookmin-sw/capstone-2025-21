//
//  TextFieldColorStyle.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct HeyTextFieldColorStyle {
    let background: Color
    let foreground: Color
}


extension HeyTextFieldColorStyle {
    static public let white = HeyTextFieldColorStyle(background: .heyWhite, foreground: .heyBlack)
    static public let primary = HeyTextFieldColorStyle(background: .heyWhite, foreground: .heyGray2)
    static public let gray = HeyTextFieldColorStyle(background: .heyGray4, foreground: .heyBlack)
    static public let lightgray = HeyTextFieldColorStyle(background: .heyGray5, foreground: .heyBlack)
}
