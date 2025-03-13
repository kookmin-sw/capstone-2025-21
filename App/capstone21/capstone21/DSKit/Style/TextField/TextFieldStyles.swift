//
//  TextFieldStyles.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import Foundation
import SwiftUI

struct HeyTextFieldStlyes: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
//            .font(.medium_14)
            .foregroundColor(.heyBlack)
            .frame(height: 52)
            .frame(maxWidth: .infinity)
    }
}

extension View {
    func heyTextFieldStyle() -> some View {
        self.textFieldStyle(HeyTextFieldStlyes())
    }
}
