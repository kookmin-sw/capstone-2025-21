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
    
    // Example spicy dish structure
    struct SpicyDish {
        let name: String
        let spiceLevel: Int
    }
    
    // Example recommended menu structure
    struct RecommendedMenu {
        let name: String
        let description: String
        let price: String
        let matchPercentage: Int
        let matchReasons: [String]
    }
    
    //TODO: 서버통신으로 연결
    let allergiesDetected: Bool = true
    let allergiesInfo: [AllergenInfo] = [
        AllergenInfo(allergen: "Nuts", dishes: ["Pad Thai", "Almond Chicken"]),
        AllergenInfo(allergen: "Seafood", dishes: ["Seafood Pasta", "Lobster Bisque"])
    ]
    
    //TODO: 서버통신으로 연결
    let topRecommendedMenu: RecommendedMenu = RecommendedMenu(
        name: "Signature Bibimbap",
        description: "A colorful mix of vegetables, beef, and rice topped with a fried egg and special sauce.",
        price: "₩12,000",
        matchPercentage: 95,
        matchReasons: ["Based on history", "Low allergens", "Medium spicy"]
    )
    
    // Add properties for handling UI state
    @Published var parsedMenuImage: UIImage? = UIImage(systemName: "pencil")
    @Published var isLoadingImage: Bool = false
    @Published var showImageSheet: Bool = false
    @Published var showShareSheet: Bool = false
    
    var state = State()
    
    var navigationRouter: NavigationRoutableType
    private let cancelBag = CancelBag()
    
    init(
        navigationRouter: NavigationRoutableType
    ) {
        self.navigationRouter = navigationRouter
    }
    
    func send(_ action: Action) {
        switch action {
        case .onAppear:
            Providers.HomeProvider.request(target: .getMenuAnalyze, instance: BaseResponse<MenuAnalyzeResult>.self) { [weak self] data in
                guard let self = self else { return }
                
                if data.success {
                    // When data arrives, load the parsed menu image
//                    if let imageURL = data.result?.parsedMenuImageURL {
//                        self.loadParsedMenuImage(from: imageURL)
//                    }
                }
            }
            
            Providers.HomeProvider.request(target: .getTranslateMenuImage, instance: BaseResponse<MenuTranslateResult>.self) { [weak self] data in
                guard let self = self else { return }
                
                if data.success {
                    // When data arrives, load the parsed menu image
                    if let imageURL = URL(string: data.data!.imageURL) {
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
