//
//  ProfileViewModel.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/4/24.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var editedName = ""
    @Published var editedUsername = ""
    @Published var editedEmail = ""
    @Published var editedBio = ""
    @Published var editedImage: UIImage?
    @Published var isEditing = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showImagePicker = false

    private let networkManager = NetworkManager.shared

    func loadUserProfile() {
        isLoading = true
        let userID = SessionManager.shared.getUserID() ?? 0
        networkManager.fetchUserDetails(userID: userID) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedUser):
                    self.user = fetchedUser
                    self.resetFields()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func startEditing() {
        isEditing = true
    }

    func resetFields() {
        guard let currentUser = user else { return }
        editedName = currentUser.name
        editedUsername = currentUser.username
        editedEmail = currentUser.email
        editedBio = currentUser.bio
    }

    func updateUserProfile(with imageUrl: String) {
        guard let userID = user?.id else { return }
        networkManager.updateUser(userID: userID, name: editedName, email: editedEmail, username: editedUsername, bio: editedBio, profile_img_url: imageUrl) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedUser):
                    self?.user = updatedUser
                    self?.isEditing = false
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func cancelEditing() {
        isEditing = false
        resetFields()
    }
    
    func uploadImageAndUpdateProfile() {
        guard let image = editedImage else { return }
        networkManager.uploadImage(image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let filename):
                    self?.updateUserProfile(with: filename)
                case .failure(let error):
                    self?.errorMessage = "Image upload failed: \(error.localizedDescription)"
                }
            }
        }
    }
}
