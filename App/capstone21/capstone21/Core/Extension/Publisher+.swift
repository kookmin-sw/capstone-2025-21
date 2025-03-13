//
//  Publisher+.swift
//  Core
//
//  Created by 류희재 on 1/2/25.
//  Copyright © 2025 Heylets-iOS. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public extension Publisher {
    func assignLoading<Root>(to keyPath: ReferenceWritableKeyPath<Root, Bool>, on object: Root) -> Publishers.HandleEvents<Self> {
        handleEvents(
            receiveCompletion: { _ in object[keyPath: keyPath] = false },
            receiveRequest: { _ in object[keyPath: keyPath] = true }
        )
    }
}

public extension Publisher {
    /// Output을 Void로 변환하는 메서드
    func asVoid() -> AnyPublisher<Void, Failure> {
        self.map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// Error 타입을 일반 Error로 변환하는 메서드
    func mapToGeneralError() -> AnyPublisher<Output, Error> {
        self.mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    /// Output을 Void로 변환하고, Failure 타입을 일반 Error로 변환하는 메서드
    func asVoidWithGeneralError() -> AnyPublisher<Void, Error> {
        self.map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
