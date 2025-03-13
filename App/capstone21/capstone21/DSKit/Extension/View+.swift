//
//  View+.swift
//  DSKit
//
//  Created by 류희재 on 12/23/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

extension View {
    /// Bool 값에 따라 뷰를 숨기거나 표시
    @ViewBuilder
    public func hidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden() // 완전히 숨김 처리
        } else {
            self
        }
    }
}

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

public struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

// 바텀시트
extension View {
    public func bottomSheetTransition() -> some View {
        self.zIndex(2)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom)
                        .animation(.easeOut(duration: 10)),
                    removal: .opacity.animation(.easeIn(duration: 0.3))
                )
            )
    }
}

extension View {
    public func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


//캡쳐
extension View {
    public func captureAsImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}

