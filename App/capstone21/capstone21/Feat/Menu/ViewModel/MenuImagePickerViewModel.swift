//
//  MenuImagePickerViewModel.swift
//  capstone21
//
//  Created by 류희재 on 3/25/25.
//

import Foundation
import UIKit
import Combine

public class MenuImagePickerViewModel: ObservableObject {
    struct State {
        var continueButtonIsEnabled = false
        var isLoading = false
        var errorMessage = ""
    }
    
    enum Action {
        case backButtonDidTap
        case nextButtonDidTap
        case imageSelected(Data)
        case removeImage
    }
    
    // MARK: - Properties
    
    @Published var selectedImage: UIImage?
    @Published var state = State()
    
    var navigationRouter: NavigationRoutableType
    private let cancelBag = CancelBag()
    
    // MARK: - Init
    
    init(navigationRouter: NavigationRoutableType) {
        self.navigationRouter = navigationRouter
        
        observe()
    }
    
    // MARK: - Methods
    
    func send(_ action: Action) {
        switch action {
        case .backButtonDidTap:
            navigationRouter.pop()
            
        case .nextButtonDidTap:
            // Process the selected image and navigate to the next screen
            // For example, you might upload the image to a server or analyze it locally
            // Then navigate to the next screen in your app flow
            // navigationRouter.push(to: .nextScreen)
            break
            
        case .imageSelected(let imageData):
            if let image = UIImage(data: imageData) {
                selectedImage = image
            } else {
                state.errorMessage = "Failed to load the selected image."
            }
            
        case .removeImage:
            selectedImage = nil
        }
    }
    
    private func observe() {
        // Update the continue button based on whether an image is selected
        $selectedImage
            .map { $0 != nil }
            .assign(to: \.state.continueButtonIsEnabled, on: self)
            .store(in: cancelBag)
    }
}

// Extension to help with optionals in SwiftUI
extension Optional {
    var isNil: Bool {
        self == nil
    }
}
