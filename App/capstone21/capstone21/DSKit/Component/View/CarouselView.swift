import SwiftUI

public struct CarouselView<Content: View>: View {
    public typealias PageIndex = Int
    
    let pageCount: Int
    let visibleEdgeSpace: CGFloat // 화면의 양쪽 가장자리에 보일 여백
    let spacing: CGFloat // 두 뷰 사이에 간격
    let content: (PageIndex) -> Content // 페이지마다 어떤 뷰가 들어갈지 정의하는 클로저
    
    @GestureState var dragOffset: CGFloat = 0 // 드래그 중 페이지 이동을 추적하기 위한 상태
    @State var currentIndex: Int = 0 // 현재 표시되고 있는 페이지의 인덱스
    
    public init(
        pageCount: Int,
        visibleEdgeSpace: CGFloat = 0, // 여백 없애기
        spacing: CGFloat = 0, // 간격 없애기
        @ViewBuilder content: @escaping (PageIndex) -> Content
    ) {
        self.pageCount = pageCount
        self.visibleEdgeSpace = visibleEdgeSpace
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            GeometryReader { proxy in
                // 양쪽 가장자리에 보일 여백 = 두 뷰 사이 간격 + 화면 양쪽 가장자리에 보일 여백
                let baseOffset: CGFloat = spacing + visibleEdgeSpace
                // 각 페이지의 너비 = 전체 너비 - (화면 양쪽 가장자리에 보일 여백 + 두 뷰 사이 간격) * 양쪽(= 2)
                
                let pageWidth: CGFloat = proxy.size.width - (visibleEdgeSpace + spacing) * 2
                
                // HStack의 전체 오프셋을 계산하여 페이지 전환을 구현
                let offsetX: CGFloat = baseOffset + CGFloat(currentIndex) * -pageWidth + CGFloat(currentIndex) * -spacing + dragOffset
                
                
                
                // Carousel 뷰
                HStack(spacing: spacing) {
                    ForEach(0..<pageCount, id: \.self) { pageIndex in
                        self.content(pageIndex)
                            .frame(
                                width: pageWidth,
                                height: proxy.size.height
                            )
                    }
                    .contentShape(Rectangle())
                }
                .offset(x: offsetX)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let offsetX = value.translation.width // 드래그가 끝난 후 이동한 거리를 계산한 값
                            
                            let progress = -offsetX / pageWidth // 페이지의 이동 비율로, -offsetX / pageWidth로 계산
                            let threshold: CGFloat = 0.3
                            
                            withAnimation {
                                    if progress > threshold {
                                        // 오른쪽에서 왼쪽으로 이동 (다음 페이지로)
                                        currentIndex = min(currentIndex + 1, pageCount - 1)
                                    } else if progress < -threshold {
                                        // 왼쪽에서 오른쪽으로 이동 (이전 페이지로)
                                        currentIndex = max(currentIndex - 1, 0)
                                    }
                                }
                        }
                )
            }
            
            Spacer()
                .frame(height: 60)
            
            // 동그라미 페이지 표시
            HStack(spacing: 6) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .fill(
                            index == (currentIndex) % pageCount
                            ? Color.init(hex: "EFF2FF")
                            : Color.init(hex: "#CBD6FF")
                        )
                        .frame(width: 6, height: 6) // 동그라미 크기 설정
                }
            }
            .frame(maxWidth: .infinity) // HStack을 화면 너비에 맞춤
            .padding(.bottom, 10) // 화면 아래쪽 여백 설정
        }
    }
}

import SwiftUI
enum OnboardingType {
    case timeTable
    case theme
    
    var title: String {
        switch self {
        case .timeTable:
            return "Add a personal schedule to\nyour school timetable"
        case .theme:
            return "Customize Your Timetable\nwith Your Favorite Color"
        }
    }
    
    var description: String {
        switch self {
        case.timeTable:
            return "Manage your school-related schedules\nall at once!"
        case .theme:
            return "Customize your timetable with your\nfavorite colors!"
        }
    }
    
    var image: UIImage {
        switch self {
        case .timeTable:
            return .graphicsTimeTable
        case .theme:
            return .graphicsTheme
        }
    }
}

struct ContentView2: View {
    let onboardingContent: [OnboardingType] = [.timeTable, .theme]
    
    var body: some View {
        CarouselView(pageCount: onboardingContent.count, visibleEdgeSpace: 0, spacing: 0) { index in
            VStack(alignment: .leading) {
                Text(onboardingContent[index].title)
                    .font(.regular_16)
                    .foregroundColor(.heyBlack)
                    .lineSpacing(3.5)
                    .padding(.bottom, 12)
                    .padding(.leading, 16)
                    .lineLimit(2)
                
                Text(onboardingContent[index].description)
                    .font(.medium_14)
                    .foregroundColor(.heyBlack)
                    .padding(.leading, 16)
                    .lineLimit(2)
                
                Spacer()
                    .frame(height: 52)
                
                Image(uiImage: onboardingContent[index].image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(height: 353) // 전체 Carousel 뷰의 높이 설정
        .padding(.horizontal, 0) // 양쪽 여백을 없애기 위해 horizontal padding 0
    }
}

#Preview {
    ContentView2()
}
