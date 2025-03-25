//
//  HomeViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import Foundation

import Foundation

enum Tab {
    case archiving
    case menu
    case mypage
}

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    
    init(selectedTab: Tab = .menu) {
        self.selectedTab = selectedTab
    }
}

extension HomeViewModel {
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}
