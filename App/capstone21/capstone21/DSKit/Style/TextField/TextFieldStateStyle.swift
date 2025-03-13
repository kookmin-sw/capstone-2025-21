//
//  TextFieldStateStyle.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

public enum TextFieldState {
    case idle
    case valid
    case invalid
    
    var strokeColor: Color {
        switch self {
        case .idle:
            return .clear
        case .valid:
            return .heyGreen
        case .invalid:
            return .heyError
        }
    }
    
    var image: UIImage? {
        switch self {
        case .valid:
            return .icSuccess
        default:
            return nil
        }
    }
    
    func isValid() -> Bool {
        return self == .valid
    }
}
