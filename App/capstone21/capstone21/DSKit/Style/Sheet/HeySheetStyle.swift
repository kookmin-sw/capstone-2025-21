//
//  HeySheetStyle.swift
//  DSKit
//
//  Created by 류희재 on 12/26/24.
//  Copyright © 2024 Heylets-iOS. All rights reserved.
//

import SwiftUI

//https://devocean.sk.com/blog/techBoardDetail.do?ID=166992&boardType=techBlog

struct ShowLicenseAgreement: View {
    @State private var isShowingSheet = false
    var body: some View {
        Button(action: {
            isShowingSheet.toggle()
        }) {
            Text("Show License Agreement")
        }
        .sheet(isPresented: $isShowingSheet) {
            VStack {
                Text("License Agreement")
                    .font(.title)
                    .padding(50)
                Text("""
                        Terms and conditions go here.
                    """)
                .padding(50)
                Button("Dismiss",
                       action: { isShowingSheet.toggle() })
            }
            .presentationDetents([.height(280)])
        }
    }
}

#Preview {
    ShowLicenseAgreement()
}
