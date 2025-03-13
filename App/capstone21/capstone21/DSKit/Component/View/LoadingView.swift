//
//  LoadingView.swift
//  DSKit
//
//  Created by 류희재 on 1/2/25.
//  Copyright © 2025 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct LoadingView: View {
    public init() {}
    public var body: some View {
        ProgressView()
    }
}

extension View {
    public func loading(_ isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
