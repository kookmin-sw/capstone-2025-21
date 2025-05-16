import Foundation
import SwiftUI
import Combine

class MenuAnalysisResultViewModel: ObservableObject {
    struct State {
        // Example state properties
    }
    
    enum Action {
        case onAppear
        case viewParsedMenuTapped
        case downloadImageTapped
        case returnHomeTapped
        case dismissImageSheet
    }
    
    // Example allergen info structure
    struct AllergenInfo {
        let allergen: String
        let dishes: [String]
    }
    
    //TODO: 서버통신으로 연결
    let allergiesDetected: Bool = true
    let allergiesInfo: [AllergenInfo] = [
        AllergenInfo(allergen: "Nuts", dishes: ["Pad Thai", "Almond Chicken"]),
        AllergenInfo(allergen: "Seafood", dishes: ["Seafood Pasta", "Lobster Bisque"])
    ]
    
    //TODO: 서버통신으로 연결
    var recommendedMenus: [MenuResult] = []
    
    // Add properties for handling UI state
    @Published var parsedMenuImage: UIImage? = UIImage(systemName: "pencil")
    @Published var isLoadingImage: Bool = false
    @Published var showImageSheet: Bool = false
    @Published var showShareSheet: Bool = false
    
    var state = State()
    
    var navigationRouter: NavigationRoutableType
    private let cancelBag = CancelBag()
    
    init(navigationRouter: NavigationRoutableType) {
        self.navigationRouter = navigationRouter
    }
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Providers.HomeProvider.request(target: .getMenuAnalyze, instance: BaseResponse<MenuAnalyzeResult>.self) { [weak self] data in
                guard let self = self else { return }
                
                if data.success {
                    self.recommendedMenus = data.data!.recommendations
                }
            }
            
            Providers.HomeProvider.request(target: .getTranslateMenuImage, instance: BaseResponse<String>.self) { [weak self] data in
                guard let self = self else { return }
                
                if data.success {
                    // When data arrives, load the parsed menu image
                    if let imageURL = URL(string: data.data!) {
                        self.loadParsedMenuImage(from: imageURL)
                    }
                }
            }
        case .viewParsedMenuTapped:
            // Show the image sheet
            if parsedMenuImage != nil {
                showImageSheet = true
            } else {
                isLoadingImage = true
                // You could add logic to retry loading the image if needed
            }
        case .downloadImageTapped:
            // Show share sheet for downloading
            showShareSheet = true
        case .dismissImageSheet:
            showImageSheet = false
        case .returnHomeTapped:
            navigationRouter.popToRootView()
        }
    }
    
    private func loadParsedMenuImage(from url: URL) {
        self.isLoadingImage = true
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingImage = false
                
                if let data = data, let image = UIImage(data: data) {
                    self.parsedMenuImage = image
                }
            }
        }.resume()
    }
}
