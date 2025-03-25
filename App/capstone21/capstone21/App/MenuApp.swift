//
//  capstone21App.swift
//  capstone21
//
//  Created by 류희재 on 3/14/25.
//

import SwiftUI

@main
struct MenuApp: App {
    @StateObject var container = DIContainer.default
    
    var body: some Scene {
        WindowGroup {
            SplashView(viewModel: .init(windowRouter: container.windowRouter))
                .environmentObject(container)
        }
    }
}
