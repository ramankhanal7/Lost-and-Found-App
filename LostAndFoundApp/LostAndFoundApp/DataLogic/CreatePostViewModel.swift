//
//  CreatePostViewModel.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/2/24.
//

import Foundation
import SwiftUI

class CreatePostViewModel: ObservableObject {
    @Published var isSubmitting = false
    @Published var submissionMessage: String?
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager.shared

    func submitPost(title: String, description: String, category: String, location: String, filename: String, user_id: Int, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isSubmitting = true
        }
        networkManager.submitPost(title: title, description: description, category: category, location: location, filename: filename, user_id: user_id) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isSubmitting = false
                if success {
                    self?.submissionMessage = "Post created successfully!"
                    completion(true)
                } else {
                    self?.submissionMessage = error?.localizedDescription ?? "Failed to create post."
                    completion(false)
                }
            }
        }
    }
    
    func uploadImageAndCreatePost(image: UIImage, title: String, description: String, category: String, location: String, user_id: Int, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isSubmitting = true
        }
        networkManager.uploadImage(image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let filename):
                    self?.submitPost(title: title, description: description, category: category, location: location, filename: filename, user_id: user_id) { success in
                        self?.isSubmitting = false
                        if success {
                            self?.submissionMessage = "Post created successfully!"
                            completion(true)
                        } else {
                            self?.submissionMessage = "Failed to create post."
                            completion(false)
                        }
                    }
                case .failure(let error):
                    self?.isSubmitting = false
                    self?.submissionMessage = "Failed to upload image: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }
    
}
