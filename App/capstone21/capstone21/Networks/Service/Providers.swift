//
//  Providers.swift
//  HMH_iOS
//
//  Created by 지희의 MAC on 1/12/24.
//

import Foundation
import Moya

struct Providers {
    static let HomeProvider = NetworkProvider<HomeRouter>(withAuth: true)
    static let AuthProvider = NetworkProvider<AuthRouter>(withAuth: false)
}

extension MoyaProvider {
    
    convenience init(withAuth: Bool) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120 // 요청 타임아웃 시간 (초)
        configuration.timeoutIntervalForResource = 120 // 리소스 타임아웃 시간 (다운로드 등)
        
        if withAuth {
            self.init(session: Session(configuration: configuration, interceptor: AuthInterceptor.shared),
                      plugins: [MoyaLoggingPlugin()])
        } else {
            self.init(plugins: [MoyaLoggingPlugin()])
        }
    }
}
