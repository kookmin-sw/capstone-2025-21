//
//  NavigationDestination.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation

enum NavigationDestination: Hashable {
    // Onboarding
    case logIn
    
    case selectNationality
    case selectAllergy(UserInfo)
    case selectKoreanFood(UserInfo)
    case enterIdPassword(UserInfo)
    
    //Menu
    case menuAnalysisLoading(String)
    case menuAnalysResult
}
