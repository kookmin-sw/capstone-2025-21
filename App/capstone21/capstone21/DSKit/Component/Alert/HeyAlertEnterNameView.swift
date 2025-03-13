//
//  HeyAlertEnterNameView.swift
//  capstone21
//
//  Created by 류희재 on 3/14/25.
//

import SwiftUI

public struct HeyAlertEnterNameView: View {
    public init(
        title: String,
        text: Binding<String>,
        primaryAction: HeyAlertButtonType,
        secondaryAction: HeyAlertButtonType
    ) {
        self.title = title
        self._text = text
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    var title: String
    @Binding var text: String
    var primaryAction: HeyAlertButtonType
    var secondaryAction: HeyAlertButtonType
    
    
    public var body: some View {
        VStack {
            Spacer()
            
            Text(title)
                .font(.medium_18)
                .foregroundColor(.heyBlack)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            TextField(text: $text, label: {
                
            })
            .font(.medium_12)
            .foregroundColor(.heyGray1)
            .frame(height: 51)
            .background(Color.init(hex: "#F4F4F4"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.bottom, 26)
            HStack {
                Button(primaryAction.title) {
                    primaryAction.action()
                }
                .heyAlertButtonStyle(primaryAction.colorSystem)
                
                
                Spacer()
                    .frame(width: 24)
                
                Button(secondaryAction.title) {
                    text = ""
                    secondaryAction.action()
                }
                .heyAlertButtonStyle(secondaryAction.colorSystem)
            }
            
            Spacer()
                .frame(height: 24)
        }
        .padding(.horizontal, 24)
        .frame(height: 213)
        .frame(maxWidth: .infinity)
        .background(Color.heyWhite)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


