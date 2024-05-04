//
//  HomeScreenViewModel.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/1/24.
//

import Foundation
import SwiftUI

class HomeScreenViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userProfiles: [Int: User] = [:]

    private let networkManager = NetworkManager.shared

    func loadPosts() {
        isLoading = true
        networkManager.getPosts { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let posts = result {
                    self?.posts = posts
                    self?.loadUserProfiles(for: posts)
                } else if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getUserById(_ id: Int, completion: @escaping (Result<User, Error>) -> Void) {
        networkManager.fetchUserDetails(userID: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("User fetched successfully: \(user)")
                case .failure(let error):
                    print("Failed to fetch user: \(error)")
                }
                completion(result)
            }
        }
    }
    
    private func loadUserProfiles(for posts: [Post]) {
        let userIds = Set(posts.map { $0.user_id })
        userIds.forEach { userId in
            if self.userProfiles[userId] == nil {
                networkManager.fetchUserDetails(userID: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let user):
                            self.userProfiles[userId] = user
                        case .failure(let error):
                            print("Error loading user details: \(error)")
                        }
                    }
                }
            }
        }
    }
}
