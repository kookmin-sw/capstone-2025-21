//
//  Color+.swift
//  DSKit
//
//  Created by 류희재 on 1/7/25.
//  Copyright © 2025 Heylets-iOS. All rights reserved.
//

import SwiftUI

extension Color {
    public init(hex: String, opacity: CGFloat = 1.0) {
        // 16진수에서 # 제거
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        // RGB 값 추출
        let red = Double((int >> 16) & 0xFF) / 255.0
        let green = Double((int >> 8) & 0xFF) / 255.0
        let blue = Double(int & 0xFF) / 255.0
        
        // SwiftUI Color 생성
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
