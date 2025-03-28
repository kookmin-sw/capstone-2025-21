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
    case selectAllergy
    case selectKoreanFood
    case enterIdPassword
    
    //Menu
    case menuAnalysisLoading
    case menuAnalysResult
}
