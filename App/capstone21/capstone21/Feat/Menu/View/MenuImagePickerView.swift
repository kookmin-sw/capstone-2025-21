//
//  MenuImagePickerView.swift
//  capstone21
//
//  Created on 3/25/25.
//

import SwiftUI
import PhotosUI

public struct MenuImagePickerView: View {
    @EnvironmentObject var container: DIContainer
    @ObservedObject var viewModel: MenuImagePickerViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    public init(viewModel: MenuImagePickerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        VStack(alignment: .leading) {
            
            Spacer()
                .frame(height: 92)
            
            VStack(alignment: .leading) {
                Text("Upload Menu Image")
                    .font(.semibold_18)
                    .foregroundColor(.heyGray1)
                    .padding(.bottom, 18)
                
                VStack(spacing: 24) {
                    // PhotosPicker with image display in the same position
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let selectedImage = viewModel.selectedImage {
                            // Selected image display
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 400)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(12)
                                
                                Button(action: {
                                    viewModel.send(.removeImage)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(8)
                            }
                        } else {
                            // Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 60))
                                    .foregroundColor(.heyGray3)
                                
                                Text("Select a menu photo from your gallery")
                                    .font(.regular_16)
                                    .foregroundColor(.heyGray2)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(height: 400)
                            .frame(maxWidth: .infinity)
                            .background(Color.heyGray5.opacity(0.5))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Continue button (replacing the former photo picker button)
                    if !viewModel.selectedImage.isNil {
                        Button(action: {
                            viewModel.send(.nextButtonDidTap)
                        }) {
                            HStack {
                                Text("Continue")
                                    .font(.regular_16)
                                Image(systemName: "arrow.right")
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .foregroundColor(.white)
                            .background(viewModel.state.continueButtonIsEnabled ? Color.heyMain : Color.heyGray3)
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                        }
                        .disabled(!viewModel.state.continueButtonIsEnabled)
                        
                        Text("Make sure the menu image is clear and readable.")
                            .font(.regular_14)
                            .foregroundColor(.heyGray2)
                            .padding(.top, 8)
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding(.top, 36)
        .padding(.bottom, 65)
        .padding(.horizontal, 16)
        .background(Color.heyWhite)
        .ignoresSafeArea(edges: .vertical)
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.send(.imageSelected(data))
                }
            }
        }
    }
}


#Preview {
    let container = DIContainer.stub
    return MenuImagePickerView(viewModel: .init(
        navigationRouter: container.navigationRouter)
    )
    .environmentObject(DIContainer.stub)
}
