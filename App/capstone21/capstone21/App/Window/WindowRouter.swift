//
//  WindowRouter.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation
import Combine

protocol WindowRoutable {
    var destination: WindowDestination { get }
    func `switch`(to destination: WindowDestination)
}


class WindowRouter: WindowRoutable, ObservableObjectSettable {
    
    var objectWillChange: ObservableObjectPublisher?
    
    var destination: WindowDestination = .splash {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func `switch`(to destination: WindowDestination) {
        self.destination = destination
    }
    
}

