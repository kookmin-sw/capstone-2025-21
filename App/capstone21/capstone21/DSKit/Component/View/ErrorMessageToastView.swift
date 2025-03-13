//
//  ErrorMessageToastView.swift
//  DSKit
//
//  Created by 류희재 on 1/20/25.
//  Copyright © 2025 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct ErrorMessageToastView: View {
    var message: String
    
    public init(_ message: String) {
        self.message = message
    }
    
    public var body: some View {
        Text(message)
            .font(.bold_20)
            .multilineTextAlignment(.center)
            .foregroundColor(.heyError)
            .animation(.easeInOut, value: message)
    }
}
