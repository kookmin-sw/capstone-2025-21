//
//  NationalityInfo.swift
//  capstone21
//
//  Created by 류희재 on 4/17/25.
//

import Foundation
import SwiftUI

enum NationalityInfo: String {
    case USA
    case JPN
    case CHN
    
    var image: Image {
        switch self {
        case .USA:
            return Image(.usa)
        case .JPN:
            return Image(.japen)
        case .CHN:
            return Image(.china)
        }
    }
}
