//
//  DIContainer.swift
//  capstone21
//
//  Created by 류희재 on 3/17/25.
//

import Foundation

typealias NavigationRoutableType = NavigationRoutable & ObservableObjectSettable
typealias WindowRoutableType = WindowRoutable & ObservableObjectSettable

final class DIContainer: ObservableObject {
    
//    var service: ServiceType
    var navigationRouter: NavigationRoutableType
    var windowRouter: WindowRoutableType
    
    private init(
//        service: ServiceType,
        navigationRouter: NavigationRoutableType = NavigationRouter(),
        windowRouter: WindowRoutableType = WindowRouter()
    ) {
//        self.service = service
        self.navigationRouter = navigationRouter
        self.windowRouter = windowRouter
        
        navigationRouter.setObjectWillChange(objectWillChange)
        windowRouter.setObjectWillChange(objectWillChange)
    }
}

extension DIContainer {
//    static let `default` = DIContainer(service: Service())
//    static let stub = DIContainer(service: StubService())
    static let `default` = DIContainer()
    static let stub = DIContainer()
}

