//
//  HeyAlert.swift
//  DSKit
//
//  Created by 류희재 on 12/18/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

public struct HeyAlertView: View {
    public init(
        title: String,
        primaryAction: HeyAlertButtonType,
        secondaryAction: HeyAlertButtonType? = nil
    ) {
        self.title = title
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    var title: String
    var primaryAction: HeyAlertButtonType
    var secondaryAction: HeyAlertButtonType?
    
    
    public var body: some View {
        VStack {
            Spacer()
            
            Text(title)
                .font(.medium_18)
                .foregroundColor(.heyBlack)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack {
                Button(primaryAction.title) {
                    primaryAction.action()
                }
                .heyAlertButtonStyle(primaryAction.colorSystem)
                
                if let secondaryAction = secondaryAction {
                    Spacer()
                        .frame(width: 24)
                    
                    Button(secondaryAction.title) {
                        secondaryAction.action()
                    }
                    .heyAlertButtonStyle(secondaryAction.colorSystem)
                }
            }
            
            Spacer()
                .frame(height: 24)
        }
        .padding(.horizontal, 24)
        .frame(height: 154)
        .frame(maxWidth: .infinity)
        .background(Color.heyWhite)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    public func heyAlert(
        isPresented: Bool,
        title: String,
        isEditedName: Bool = false,
        primaryButton: HeyAlertButtonType,
        secondaryButton: HeyAlertButtonType? = nil
    ) -> some View {
        self.overlay {
            if isPresented {
                ZStack {
                    Color.black.opacity(0.5)
                    
                    HeyAlertView(
                        title: title,
                        primaryAction: primaryButton,
                        secondaryAction: secondaryButton
                    )
                    .padding(.horizontal, 44)
                }
                .ignoresSafeArea()
                
            }
        }
    }
}


public enum DemoTimeTableSettingAlertType {
    case editTimeTableName
    case shareURL
    case saveImage
    case removeTimeTable
}

