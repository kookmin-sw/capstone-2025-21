//
//  TabBarView.swift
//  DSKit
//
//  Created by 류희재 on 2/28/25.
//  Copyright © 2025 Heylets-iOS. All rights reserved.
//

import SwiftUI

enum TabType {
    case timeTable
    case todo
    case my
    
    var image: UIImage {
        switch self {
        case .timeTable:
            return .tabTimetable
        case .todo:
            return .tabTodo
        case .my:
            return .tabMypage
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .timeTable:
            return .tabTimetableFilled
        case .todo:
            return .tabTodoFilled
        case .my:
            return .tabMypage
        }
    }
    
    var title: String {
        switch self {
        case .timeTable:
            return "Timetable"
        case .todo:
            return "To do"
        case .my:
            return "My"
        }
    }
    
}

public struct TabBarView: View {
    public var timeTableAction: (() -> Void)?
    public var todoAction: (() -> Void)?
    public var mypageAction: (() -> Void)?
    
    public init(
        timeTableAction: ((() -> Void))? = nil,
        todoAction: (() -> Void)? = nil,
        mypageAction: (() -> Void)? = nil
    ) {
        self.timeTableAction = timeTableAction
        self.todoAction = todoAction
        self.mypageAction = mypageAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                TabItemView(.timeTable, timeTableAction == nil)
                    .onTapGesture {
                        guard let timeTableAction else { return }
                        timeTableAction()
                    }
                    .frame(width: 50)
                    
                Spacer()
                
                TabItemView(.todo, todoAction == nil)
                    .onTapGesture {
                        guard let todoAction else { return }
                        todoAction()
                    }
                    .frame(width: 27)
                
                Spacer()
                
                TabItemView(.my, false)
                    .onTapGesture {
                        guard let mypageAction else { return }
                        mypageAction()
                    }
                    .frame(width: 23)
            }
            .padding(.horizontal, 58)
            .padding(.top, 16)
            .padding(.bottom, 30)
            .frame(height: 86)
            .background(Color.heyWhite)
            .ignoresSafeArea()
        }
        .shadow(
            color: Color(hex: "#000000").opacity(0.06),
            radius: 17.2,
            x: 0,
            y: 2
        )
    }
    
}

struct TabItemView: View {
    private let isFilled: Bool
    private let tabType: TabType
    
    init(
        _ tabType: TabType,
        _ isFilled: Bool
    ) {
        self.tabType = tabType
        self.isFilled = isFilled
    }
    
    var body: some View {
        VStack {
            Image(
                uiImage: isFilled
                ? tabType.selectedImage
                : tabType.image
            )
            .resizable()
            .frame(width: 23, height: 23)
//            .padding(.bottom, 6)
            
            Text(tabType.title)
                .font(.semibold_10)
                .foregroundColor(
                    isFilled
                    ? Color.init(hex: "#1B1B1C")
                    : Color.init(hex: "#D2D2D2")
                )
        }
    }
}

#Preview {
    TabBarView()
}
