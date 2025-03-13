//
//  Date+.swift
//  Core
//
//  Created by 류희재 on 1/14/25.
//  Copyright © 2025 Heylets-iOS. All rights reserved.
//

import Foundation

extension Date {
    public func toInt() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd" // 원하는 형식
        let dateString = formatter.string(from: self)
        return Int(dateString) ?? 0 // String을 Int로 변환
    }
}


public extension String {
    func parseTime() -> (hour: Int, minute: Int) {
        let components = self.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return (hour: 0, minute: 0) }
        return (hour: components[0], minute: components[1])
    }
}
