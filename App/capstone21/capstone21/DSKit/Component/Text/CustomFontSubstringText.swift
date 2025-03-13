//
//  CustomFontSubstringText.swift
//  DSKit
//
//  Created by 류희재 on 2/10/25.
//  Copyright © 2025 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct TextWithCustomFontSubstring: View {
    var originalText: String
    var targetSubstring: String
    var targetFont: Font

    public init(originalText: String, targetSubstring: String, targetFont: Font) {
        self.originalText = originalText
        self.targetSubstring = targetSubstring
        self.targetFont = targetFont
    }
    
    public var body: some View {
        if let range = originalText.range(of: targetSubstring) {
            // Substring을 String으로 변환
            let beforeText = String(originalText[..<range.lowerBound])
            let highlightedText = String(originalText[range])
            let afterText = String(originalText[range.upperBound...])
            
            return Text(beforeText)
                + Text(highlightedText)
                    .font(targetFont) // 지정한 폰트를 적용
                + Text(afterText)
        } else {
            return Text(originalText)
        }
    }
}
